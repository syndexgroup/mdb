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

package com.syndex.mdbreader.util {
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public final class BinaryReader {
        private var _data:ByteArray;
        private var _base:uint;
        private var _length:uint;

        public function BinaryReader(data:ByteArray, base:uint = 0, length:uint = uint.MAX_VALUE) {
            _data = data;
            _data.endian = Endian.LITTLE_ENDIAN;
            _base = base;

            var available:uint = base <= data.length ? uint(data.length - base) : 0;
            _length = length < available ? length : available;
        }

        public function canRead(offset:uint, count:uint):Boolean {
            return Number(offset) + Number(count) <= _length;
        }

        public function u8(offset:uint):uint {
            if (!canRead(offset, 1)) {
                return 0;
            }

            _data.position = _base + offset;
            return _data.readUnsignedByte();
        }

        public function u16(offset:uint):uint {
            if (!canRead(offset, 2)) {
                return 0;
            }

            _data.position = _base + offset;
            return _data.readUnsignedShort();
        }

        public function u32(offset:uint):uint {
            if (!canRead(offset, 4)) {
                return 0;
            }

            _data.position = _base + offset;
            return _data.readUnsignedInt();
        }

        public function u64(offset:uint):UInt64 {
            if (!canRead(offset, 8)) {
                return new UInt64();
            }

            _data.position = _base + offset;
            var lo:uint = _data.readUnsignedInt();
            var hi:uint = _data.readUnsignedInt();

            return new UInt64(hi, lo);
        }

        public function cString(offset:uint, maxLength:uint):String {
            var result:String = "";

            for (var i:uint = 0; i < maxLength && canRead(offset + i, 1); i++) {
                var value:uint = u8(offset + i);
                if (value == 0) {
                    break;
                }

                if (value >= 32 && value < 127) {
                    result += String.fromCharCode(value);
                }
            }

            return result;
        }

        public function stringSegments(offset:uint, maxLength:uint, minSegmentLength:uint = 2):String {
            var segments:Array = [];
            var current:String = "";

            for (var i:uint = 0; i < maxLength && canRead(offset + i, 1); i++) {
                var value:uint = u8(offset + i);

                if (value >= 32 && value < 127) {
                    current += String.fromCharCode(value);
                }
                else {
                    current = trim(current);
                    if (current.length >= minSegmentLength) {
                        segments.push(current);
                    }

                    current = "";
                }
            }

            current = trim(current);
            if (current.length >= minSegmentLength) {
                segments.push(current);
            }

            return segments.join(" ");
        }

        public function hex(offset:uint, count:uint):String {
            var result:String = "";

            for (var i:uint = 0; i < count && canRead(offset + i, 1); i++) {
                var value:String = u8(offset + i).toString(16);
                if (value.length < 2) {
                    value = "0" + value;
                }

                result += value;
            }

            return result;
        }

        private static function trim(value:String):String {
            return value.replace(/^\s+|\s+$/g, "");
        }
    }
}
