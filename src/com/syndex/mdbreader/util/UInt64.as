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
    public final class UInt64 {
        public var hi:uint;
        public var lo:uint;

        public function UInt64(hi:uint = 0, lo:uint = 0) {
            this.hi = hi;
            this.lo = lo;
        }

        public function get isZero():Boolean {
            return hi == 0 && lo == 0;
        }

        public function equals(other:UInt64):Boolean {
            return other != null && hi == other.hi && lo == other.lo;
        }

        public function clone():UInt64 {
            return new UInt64(hi, lo);
        }

        public function toNumber():Number {
            return Number(hi) * 4294967296.0 + Number(lo);
        }

        public function toKey():String {
            return hex8(hi) + ":" + hex8(lo);
        }

        public function toHexString():String {
            return "0x" + hex8(hi) + hex8(lo);
        }

        public function toString():String {
            return toHexString();
        }

        private static function hex8(value:uint):String {
            var result:String = value.toString(16);
            while (result.length < 8) {
                result = "0" + result;
            }

            return result;
        }
    }
}
