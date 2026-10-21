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

package com.syndex.mdbreader.models {
    import com.syndex.mdbreader.enums.EAvcLevel;
    import com.syndex.mdbreader.enums.EAvcProfile;
    import com.syndex.mdbreader.enums.EFileType;
    import com.syndex.mdbreader.enums.EFieldOfView;
    import com.syndex.mdbreader.enums.ELensConfiguration;
    import com.syndex.mdbreader.enums.EProjection;
    import com.syndex.mdbreader.util.UInt64;

    /**
     * Media record
     */
    public final class Record {
        public var slotOffset:uint;
        public var fileHandle:UInt64 = new UInt64();

        /**
         * Media type
         */
        public var fileType:EFileType = EFileType.UNKNOWN;

        /**
         * Media duration (in milliseconds)
         */
        public var duration:Number = 0;

        /**
         * Media size (in bytes)
         */
        public var size:Number = 0;

        /**
         * Media creation date
         */
        public var created:DateTime;

        /**
         * Last access date
         */
        public var lastAccess:DateTime;

        /**
         * Camera model
         */
        public var cameraModel:String = "";

        /**
         * Camera submodel
         */
        public var subModel:String = "";

        /**
         * Directory number (xxxGOPRO)
         */
        public var dirNo:uint;

        /**
         * Group the asset is in
         */
        public var group:Group;

        /**
         * Number of tags present
         */
        public var tagCount:uint;

        /**
         * Number of chapters present
         */
        public var chapterCount:uint;

        /**
         * AVC codec profile
         */
        public var avcProfile:EAvcProfile = EAvcProfile.UNSPECIFIED;

        /**
         * AVC codec level
         */
        public var avcLevel:EAvcLevel = EAvcLevel.UNSPECIFIED;

        /**
         * If EIS is enabled
         */
        public var hasImageStabilization:Boolean;

        /**
         * If HDR is enabled
         */
        public var hasHDR:Boolean;

        /**
         * Lens projection mode
         */
        public var projection:EProjection = EProjection.UNSPECIFIED;

        /**
         * Lens configuration
         */
        public var lensConfig:ELensConfiguration = ELensConfiguration.UNSPECIFIED;

        /**
         * Digital field-of-view setting
         */
        public var fov:EFieldOfView = EFieldOfView.WIDE;

        /**
         * Native media path populated by MdbParser.resolveFiles
         */
        public var resolvedPath:String;

        /**
         * Media file number
         * @return The media file number
         */
        public function get fileNumber():uint {
            return fileHandle.lo & 0x3fff;
        }

        /**
         * Group index
         * @return The group index
         */
        public function get groupIndex():uint {
            return fileHandle.lo >>> 14;
        }

        /**
         * Chapter number
         * @return The chapter number (starting from 1)
         */
        public function get chapter():uint {
            return groupIndex + 1;
        }

        /**
         * Directory number
         * @return The directory number
         */
        public function get encodedDirectory():uint {
            return fileHandle.hi & 0xff;
        }

        /**
         * File type flag
         * @return The file type flag
         */
        public function get typeFlag():uint {
            return fileHandle.hi >>> 24;
        }

        /**
         * Get display name of the file type
         * @return The file type's display name
         */
        public function get fileTypeName():String {
            return EFileType.name(fileType);
        }

        /**
         * Get standalone object from current record
         * @return The newly created object
         */
        public function toObject():Object {
            return {
                slotOffset: slotOffset,
                fileHandle: fileHandle.toHexString(),
                fileType: fileType.value,
                fileTypeName: fileTypeName,
                durationMs: duration,
                sizeBytes: size,
                created: created ? created.toObject() : null,
                lastAccess: lastAccess ? lastAccess.toObject() : null,
                cameraModel: cameraModel,
                subModel: subModel,
                dirNo: dirNo,
                encodedDirectory: encodedDirectory,
                fileNumber: fileNumber,
                groupIndex: groupIndex,
                chapter: chapter,
                grpNo: group ? group.toObject() : null,
                tagCount: tagCount,
                chapterCount: chapterCount,
                avcProfile: avcProfile.value,
                avcProfileName: avcProfile.displayName,
                avcLevel: avcLevel.value,
                avcLevelName: avcLevel.displayName,
                hasEis: hasImageStabilization,
                hasHdr: hasHDR,
                projection: projection.value,
                projectionName: projection.displayName,
                lensConfig: lensConfig.value,
                lensConfigName: lensConfig.displayName,
                fov: fov.value,
                fovName: fov.displayName,
                resolvedPath: resolvedPath
            };
        }
    }
}
