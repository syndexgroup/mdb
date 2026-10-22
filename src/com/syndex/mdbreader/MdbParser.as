/*
 * MIT License
 *
 * Copyright (c) 2026 SYNDEX
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
*/

package com.syndex.mdbreader {
    import com.syndex.mdbreader.enums.EAvcLevel;
    import com.syndex.mdbreader.enums.EAvcProfile;
    import com.syndex.mdbreader.enums.EFileType;
    import com.syndex.mdbreader.enums.EFieldOfView;
    import com.syndex.mdbreader.enums.ELensConfiguration;
    import com.syndex.mdbreader.enums.EProjection;
    import com.syndex.mdbreader.models.Database;
    import com.syndex.sharedpublic.DateTime;
    import com.syndex.mdbreader.models.Group;
    import com.syndex.mdbreader.models.Record;
    import com.syndex.mdbreader.models.Schema;
    import com.syndex.mdbreader.models.Version;
    import com.syndex.mdbreader.util.BinaryReader;
    import com.syndex.mdbreader.util.UInt64;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;

    /**
     * Parser for GoPro MDB databases
     */
    public final class MdbParser {
        private static const PAGE_SIZE:uint = 512;
        private static const TABLE_SINGLE_EX:uint = 3;
        private static const TABLE_GROUPED_EX:uint = 4;
        private static const HERO5_SINGLE_MIN_SIZE:uint = 78;
        private static const HERO8_SINGLE_MIN_SIZE:uint = 151;
        private static const MAX2_SINGLE_MIN_SIZE:uint = 151;
        private static const MODERN_SINGLE_MIN_SIZE:uint = 142;
        private static const HERO5_GROUP_MIN_SIZE:uint = 57;
        private static const MODERN_GROUP_MIN_SIZE:uint = 81;
        private var _data:ByteArray;
        private var _reader:BinaryReader;
        private var _database:Database;
        private var _fileHandleSet:Object;
        private var _matchedHandleSet:Object;
        private var _recordGroupNumbers:Dictionary;

        /**
         * Parse a MDB file
         * @param path The file to parse
         * @return The parsed database
         */
        public static function parse(path:String):Database {
            if (path == null || path.length == 0) {
                throw new ArgumentError("A MDB file path is required");
            }

            return new MdbParser().parseFile(new File(path));
        }

        /**
         * Resolves parsed records against files in DCIM
         * @param database The database to parse
         * @param dcimPath The DCIM directory
         */
        public static function resolveFiles(database:Database, dcimPath:String):void {
            if (database == null || dcimPath == null || dcimPath.length == 0) {
                return;
            }

            var dataDirectory:File = new File(dcimPath);
            if (!dataDirectory.exists || !dataDirectory.isDirectory) {
                return;
            }

            var byDirectory:Object = {};
            var record:Record;

            for each (record in database.records) {
                var directoryNumber:uint = record.encodedDirectory;

                if (directoryNumber == 0) {
                    directoryNumber = record.dirNo;
                }

                if (directoryNumber == 0) {
                    continue;
                }

                var key:String = String(directoryNumber);
                if (byDirectory[key] == null) {
                    byDirectory[key] = [];
                }

                byDirectory[key].push(record);
            }

            for (var directoryKey:String in byDirectory) {
                var folder:File = dataDirectory.resolvePath(pad3(uint(directoryKey)) + "GOPRO");
                if (!folder.exists || !folder.isDirectory) {
                    continue;
                }

                var files:Array;

                try {
                    files = folder.getDirectoryListing();
                }
                catch (error:Error) {
                    continue;
                }

                var records:Array = byDirectory[directoryKey] as Array;

                for each (var file:File in files) {
                    if (file.isDirectory) {
                        continue;
                    }

                    var info:Object = parseFilename(file.name);
                    if (info == null) {
                        continue;
                    }

                    for each (record in records) {
                        if (record.resolvedPath != null || record.fileNumber != info.fileNumber) {
                            continue;
                        }

                        if (EFileType.expectedExtensions(record.fileType).indexOf(info.extension) < 0) {
                            continue;
                        }

                        if (EFileType.isPhoto(record.fileType)) {
                            record.resolvedPath = file.nativePath;
                        }
                        else if (record.chapter == info.chapter || (record.chapter == 1 && info.legacyFirst)) {
                            record.resolvedPath = file.nativePath;
                        }
                    }
                }
            }
        }

        private function parseFile(file:File):Database {
            if (!file.exists || file.isDirectory) {
                throw new ArgumentError("A readable GoPro mdb.db file is required: " + file.nativePath);
            }

            _data = readFile(file);
            if (_data.length < 0x500) {
                throw new ArgumentError("File is too small to be a media database: " + file.nativePath);
            }

            _reader = new BinaryReader(_data);
            _database = new Database();
            _database.sourcePath = file.nativePath;
            _database.headerValid = validateHeader();

            if (!_database.headerValid) {
                throw new ArgumentError("Header does not match the expected format");
            }

            _database.dbVersion = new Version(_reader.u16(0x400), _reader.u16(0x402));
            _database.dictionaryOffset = getDictOffset();

            parseVersion();
            _database.schema = detectSchema();

            _fileHandleSet = findIndexedFileHandles();
            _matchedHandleSet = {};
            _recordGroupNumbers = new Dictionary();
            scanRecordSlots();
            resolveRecordGroups();
            addUnmatchedHandles();

            return _database;
        }

        private function readFile(file:File):ByteArray {
            var result:ByteArray = new ByteArray();
            result.endian = Endian.LITTLE_ENDIAN;

            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.READ);

            try {
                stream.readBytes(result, 0, stream.bytesAvailable);
            }
            finally {
                stream.close();
            }

            result.position = 0;
            return result;
        }

        private function validateHeader():Boolean {
            if (_data.length < 11 || _reader.u8(0) != 0) {
                return false;
            }

            for (var i:uint = 1; i < 11; i++) {
                if (_reader.u8(i) != 0xff) {
                    return false;
                }
            }

            return true;
        }

        private function getDictOffset():uint {
            var candidates:Array = [0x0c08, 0x0600];

            for each (var candidate:uint in candidates) {
                if (isValidVersion(candidate + 8)) {
                    return candidate;
                }
            }

            var end:uint = uint(Math.min(0x2000, _data.length - 8));

            for (var offset:uint = 0x0400; offset < end; offset += 8) {
                if (isValidVersion(offset)) {
                    return offset >= 8 ? offset - 8 : 0;
                }
            }

            throw new ArgumentError("Could not locate eXtremeDB dictionary/version block");
        }

        private function isValidVersion(offset:uint):Boolean {
            var major:uint = _reader.u16(offset);
            var minor:uint = _reader.u16(offset + 2);
            var build:uint = _reader.u16(offset + 4);

            return major >= 5 && major <= 10 && minor <= 10 && build >= 1000 && build < 3000;
        }

        private function parseVersion():void {
            var offset:uint = _database.dictionaryOffset + 8;
            _database.mcoVersion = new Version(
                _reader.u16(offset),
                _reader.u16(offset + 2),
                _reader.u16(offset + 4)
            );
        }

        private function detectSchema():String {
            var hasCameraModel:Boolean = containsAscii("camera_model");
            var hasVmoment:Boolean = containsAscii("vmoment");
            var isMax2:Boolean = containsBytes([0x41, 0x58, 0x32, 0x00]);

            if (_database.dictionaryOffset < 0x0800) {
                return hasCameraModel ? Schema.HERO8 : Schema.HERO5;
            }

            if (isMax2) {
                return Schema.MAX2;
            }

            return hasVmoment ? Schema.HERO11_PLUS : Schema.HERO10;
        }

        private function containsAscii(value:String):Boolean {
            var bytes:Array = [];

            for (var i:uint = 0; i < value.length; i++) {
                bytes.push(value.charCodeAt(i) & 0xff);
            }

            return containsBytes(bytes);
        }

        private function containsBytes(needle:Array):Boolean {
            if (needle == null || needle.length == 0 || needle.length > _data.length) {
                return false;
            }

            var limit:uint = uint(_data.length - needle.length);

            outer: for (var i:uint = 0; i <= limit; i++) {
                for (var j:uint = 0; j < needle.length; j++) {
                    if (_reader.u8(i + j) != uint(needle[j])) {
                        continue outer;
                    }
                }

                return true;
            }

            return false;
        }

        private function findIndexedFileHandles():Object {
            var result:Object = {};

            for (var page:uint = 0x0200; page + 16 <= _data.length; page += PAGE_SIZE) {
                var kind:uint = _reader.u8(page) & 0x0f;
                if (kind != 2 && kind != 3) {
                    continue;
                }

                var end:uint = uint(Math.min(page + PAGE_SIZE, _data.length));

                for (var offset:uint = page + 8; offset + 8 <= end; offset += 8) {
                    var fileHandle:UInt64 = _reader.u64(offset);
                    if (isValidFileHandle(fileHandle)) {
                        result[fileHandle.toKey()] = fileHandle;
                    }
                }
            }

            return result;
        }

        private function isValidFileHandle(fileHandle:UInt64):Boolean {
            if (fileHandle == null || fileHandle.isZero) {
                return false;
            }

            var directoryNumber:uint = fileHandle.hi & 0xff;
            var baseFile:uint = fileHandle.lo & 0x3fff;
            var sentinel:uint = (fileHandle.lo >>> 16) & 0xffff;
            var typeFlag:uint = fileHandle.hi >>> 24;

            if (sentinel == 0xffff) {
                return false;
            }

            return directoryNumber >= 100 && directoryNumber != 255 && baseFile >= 1 && baseFile <= 9999 && typeFlag <= 3;
        }

        private function scanRecordSlots():void {
            var scanStart:uint;
            var step:uint;

            if (_database.schema == Schema.HERO5 || _database.schema == Schema.HERO8) {
                scanStart = _database.dictionaryOffset < 0x0800 ? 0x1800 : 0x2800;
                step = 128;
            }
            else {
                scanStart = 0x2800;
                step = 8;
            }

            for (var slot:uint = scanStart; slot + 16 <= _data.length; slot += step) {
                var kind:uint = _reader.u8(slot) & 0x0f;
                if (kind != 0) {
                    continue;
                }

                var tableId:uint = _reader.u16(slot + 2);
                if (tableId != TABLE_SINGLE_EX && tableId != TABLE_GROUPED_EX) {
                    continue;
                }

                var recordSize:uint = _reader.u32(slot + 4);
                var minimumSize:uint = minimumRecordSize(tableId);
                if (recordSize < minimumSize) {
                    continue;
                }

                var dataStart:uint = slot + 16;
                if (Number(dataStart) + Number(recordSize) > _data.length) {
                    continue;
                }

                if (tableId == TABLE_SINGLE_EX) {
                    parseSingleSlot(slot, dataStart, recordSize);
                }
                else {
                    parseGroupSlot(slot, dataStart, recordSize);
                }
            }
        }

        private function minimumRecordSize(tableId:uint):uint {
            if (tableId == TABLE_GROUPED_EX) {
                return _database.schema == Schema.HERO5 ? HERO5_GROUP_MIN_SIZE : MODERN_GROUP_MIN_SIZE;
            }

            if (_database.schema == Schema.HERO5) {
                return HERO5_SINGLE_MIN_SIZE;
            }

            if (_database.schema == Schema.HERO8) {
                return HERO8_SINGLE_MIN_SIZE;
            }

            if (_database.schema == Schema.MAX2) {
                return MAX2_SINGLE_MIN_SIZE;
            }

            return MODERN_SINGLE_MIN_SIZE;
        }

        private function parseSingleSlot(slot:uint, dataStart:uint, recordSize:uint):void {
            var fileHandle:UInt64 = extractSingleFileHandle(dataStart, recordSize);
            if (fileHandle == null || fileHandle.isZero) {
                return;
            }

            var key:String = fileHandle.toKey();
            if (_fileHandleSet[key] == null || _matchedHandleSet[key] != null) {
                return;
            }

            var record:Record;

            if (_database.schema == Schema.HERO5) {
                record = parseHero5Single(dataStart, recordSize, fileHandle);
            }
            else if (_database.schema == Schema.HERO8) {
                record = parseHero8Single(dataStart, recordSize);
            }
            else if (_database.schema == Schema.MAX2) {
                record = parseMax2Single(dataStart, recordSize);
            }
            else {
                record = parseModernSingle(dataStart, recordSize);
            }

            if (record == null || record.fileHandle.isZero) {
                return;
            }

            record.slotOffset = slot;
            _matchedHandleSet[key] = true;
            _database.records.push(record);
        }

        private function extractSingleFileHandle(dataStart:uint, recordSize:uint):UInt64 {
            var offsets:Array;

            if (_database.schema == Schema.HERO5) {
                offsets = [24, 8, 0, 16, 32, 40];
            }
            else if (_database.schema == Schema.HERO8) {
                offsets = [40, 32, 24];
            }
            else if (_database.schema == Schema.MAX2) {
                offsets = [8, 0];
            }
            else {
                offsets = [24, 16, 8];
            }

            var reader:BinaryReader = new BinaryReader(_data, dataStart, recordSize);

            for each (var offset:uint in offsets) {
                var fileHandle:UInt64 = reader.u64(offset);
                if (isValidFileHandle(fileHandle)) {
                    return fileHandle;
                }
            }

            return null;
        }

        private function parseHero5Single(dataStart:uint, recordSize:uint, fileHandle:UInt64):Record {
            var reader:BinaryReader = new BinaryReader(_data, dataStart, recordSize);
            var result:Record = new Record();
            result.fileType = EFileType.fromValue(reader.u32(0));
            result.duration = reader.u64(4).toNumber();
            result.size = reader.u64(12).toNumber();
            result.fileHandle = fileHandle.clone();

            result.created = readDateTime(reader, 40, false);
            result.lastAccess = readDateTime(reader, 58, false);
            result.tagCount = reader.u16(38);
            result.chapterCount = reader.u16(56);
            result.avcLevel = EAvcLevel.fromValue(reader.u8(71));
            result.avcProfile = EAvcProfile.fromValue(reader.u8(77));
            result.hasImageStabilization = reader.u8(68) != 0;
            result.cameraModel = "HERO5/6/7";
            result.dirNo = result.fileHandle.hi & 0xff;

            return result;
        }

        private function parseHero8Single(dataStart:uint, recordSize:uint):Record {
            var reader:BinaryReader = new BinaryReader(_data, dataStart + 8, recordSize - 8);
            var result:Record = new Record();
            result.duration = reader.u32(20);
            result.fileType = EFileType.fromValue(reader.u32(28));
            result.fileHandle = reader.u64(32);
            result.size = reader.u64(8).toNumber();
            result.created = readDateTime(reader, 62, true);
            result.lastAccess = readDateTime(reader, 76, true);
            result.dirNo = reader.u16(86);
            result.avcProfile = EAvcProfile.fromValue(reader.u8(80));
            result.avcLevel = EAvcLevel.fromValue(reader.u8(81));
            result.cameraModel = reader.stringSegments(123, 20, 2);

            return result.fileHandle.isZero ? null : result;
        }

        private function parseMax2Single(dataStart:uint, recordSize:uint):Record {
            var reader:BinaryReader = new BinaryReader(_data, dataStart + 8, recordSize - 8);
            var result:Record = new Record();
            result.fileHandle = reader.u64(0);

            var duration:Number = reader.u64(8).toNumber();
            result.duration = duration < 1000000000 ? duration : 0;
            result.size = reader.u64(16).toNumber();
            result.created = readDateTime(reader, 58, false);
            result.lastAccess = readDateTime(reader, 72, false);
            result.cameraModel = reader.cString(128, 30);
            result.fileType = EFileType.VIDEO_360;
            result.dirNo = result.fileHandle.hi & 0xff;

            return result.fileHandle.isZero ? null : result;
        }

        private function parseModernSingle(dataStart:uint, recordSize:uint):Record {
            var reader:BinaryReader = new BinaryReader(_data, dataStart + 8, recordSize - 8);
            var result:Record = new Record();
            result.duration = reader.u64(0).toNumber();
            result.size = reader.u64(8).toNumber();
            result.fileHandle = reader.u64(16);
            result.fileType = EFileType.fromValue(reader.u32(36));
            result.created = readDateTime(reader, 52, false);
            result.lastAccess = readDateTime(reader, 66, false);
            result.tagCount = reader.u16(60);
            result.chapterCount = reader.u16(62);

            _recordGroupNumbers[result] = reader.u16(64);

            result.dirNo = reader.u16(76);
            result.hasHDR = reader.u8(85) != 0;
            result.avcLevel = EAvcLevel.fromValue(reader.u8(88));
            result.avcProfile = EAvcProfile.fromValue(reader.u8(89));
            result.hasImageStabilization = reader.u8(92) != 0;
            result.projection = EProjection.fromValue(reader.u8(94));
            result.lensConfig = ELensConfiguration.fromValue(reader.u8(96));
            result.cameraModel = reader.stringSegments(97, 30, 2);
            result.subModel = reader.stringSegments(128, 16, 2);
            result.fov = EFieldOfView.fromValue(reader.u8(129));

            return result.fileHandle.isZero ? null : result;
        }

        private function parseGroupSlot(slot:uint, dataStart:uint, recordSize:uint):void {
            var result:Group;

            if (_database.schema == Schema.HERO5) {
                result = parseHero5Group(dataStart, recordSize);
            }
            else {
                result = parseModernGroup(dataStart, recordSize);
            }

            if (result == null) {
                return;
            }

            result.slotOffset = slot;

            if (_database.schema == Schema.HERO5 || _database.schema == Schema.HERO8) {
                _database.groups.push(result);
                return;
            }

            if (result.fileHandle.isZero || _fileHandleSet[result.fileHandle.toKey()] != null) {
                _database.groups.push(result);
            }
        }

        private function parseHero5Group(dataStart:uint, recordSize:uint):Group {
            var reader:BinaryReader = new BinaryReader(_data, dataStart, recordSize);
            var result:Group = new Group();
            result.frameRateDuration = reader.u32(0);
            result.frameRateTimescale = reader.u32(4);
            result.elementCount = reader.u32(8);
            result.fileHandle = reader.u64(12);
            result.groupNumber = reader.u16(20);
            result.created = readDateTime(reader, 22, false);
            result.height = reader.u16(30);
            result.width = reader.u16(32);
            result.progressive = reader.u8(40) != 0;
            result.gumi = reader.hex(41, 16);

            return result;
        }

        private function parseModernGroup(dataStart:uint, recordSize:uint):Group {
            var reader:BinaryReader = new BinaryReader(_data, dataStart + 8, recordSize - 8);
            var result:Group = new Group();
            result.fileHandle = reader.u64(0);
            result.frameRateTimescale = reader.u32(8);
            result.frameRateDuration = reader.u32(12);
            result.elementCount = reader.u32(16);
            result.created = readDateTime(reader, 20, false);
            result.groupNumber = reader.u16(28);
            result.width = reader.u16(30);
            result.height = reader.u16(32);
            result.gusi = reader.hex(36, 16);
            result.subsample = reader.u8(52) != 0;
            result.progressive = reader.u8(53) != 0;
            result.gumi = reader.hex(57, 16);

            return result;
        }

        private function resolveRecordGroups():void {
            var groupsByNumber:Object = {};

            for each (var group:Group in _database.groups) {
                var key:String = String(group.groupNumber);

                if (groupsByNumber[key] == null) {
                    groupsByNumber[key] = group;
                }
            }

            for each (var record:Record in _database.records) {
                var groupNumber:uint = uint(_recordGroupNumbers[record]);

                if (groupNumber != 0) {
                    record.group = groupsByNumber[String(groupNumber)] as Group;
                }
            }
        }

        private function readDateTime(reader:BinaryReader, offset:uint, actualYear:Boolean):DateTime {
            var year:uint = reader.u16(offset);
            if (!actualYear && year > 0) {
                year += 1980;
            }

            var result:DateTime = new DateTime(
                int(year),
                    int(reader.u8(offset + 2)),
                    int(reader.u8(offset + 3)),
                int(reader.u8(offset + 5)),
                    int(reader.u8(offset + 4)),
                    int(reader.u8(offset + 6))
            );

            return result.valid ? result : null;
        }

        private function addUnmatchedHandles():void {
            if (_database.schema != Schema.HERO5 || _database.records.length != 0) {
                return;
            }

            for (var key:String in _fileHandleSet) {
                if (_matchedHandleSet[key] != null) {
                    continue;
                }

                var record:Record = new Record();
                record.fileHandle = UInt64(_fileHandleSet[key]).clone();
                record.dirNo = record.fileHandle.hi & 0xff;
                record.cameraModel = "HERO5/6/7";
                _database.records.push(record);
            }
        }

        private static function parseFilename(name:String):Object {
            var upper:String = name.toUpperCase();
            var match:Object = /^GOPR(\d{4})\.(MP4|LRV|THM|TRV|WAV|JPG|JPEG|GPR)$/i.exec(upper);

            if (match != null) {
                return {
                    extension: String(match[2]).toUpperCase(),
                    fileNumber: uint(match[1]),
                    chapter: 1,
                    legacyFirst: true
                };
            }

            match = /^GP(\d{2})(\d{4})\.(MP4|LRV|THM|TRV|WAV)$/i.exec(upper);
            if (match != null) {
                return {
                    extension: String(match[3]).toUpperCase(),
                    chapter: uint(match[1]) + 1,
                    fileNumber: uint(match[2]),
                    legacyFirst: false
                };
            }

            match = /^G[A-Z](\d{2})(\d{4})\.(MP4|360|LRV|THM|TRV|WAV)$/i.exec(upper);
            if (match != null) {
                return {
                    extension: String(match[3]).toUpperCase(),
                    chapter: uint(match[1]),
                    fileNumber: uint(match[2]),
                    legacyFirst: false
                };
            }

            match = /^G\d{3}(\d{4})\.(JPG|JPEG|GPR)$/i.exec(upper);
            if (match != null) {
                return {
                    extension: String(match[2]).toUpperCase(),
                    chapter: 1,
                    fileNumber: uint(match[1]),
                    legacyFirst: false
                };
            }

            return null;
        }

        private static function pad3(value:uint):String {
            var result:String = String(value);

            while (result.length < 3) {
                result = "0" + result;
            }

            return result;
        }
    }
}
