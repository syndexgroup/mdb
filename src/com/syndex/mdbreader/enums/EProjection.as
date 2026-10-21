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

package com.syndex.mdbreader.enums {
    /**
     * Projection identifier
     */
    public final class EProjection {
        /**
         * Unspecified
         */
        public static const UNSPECIFIED:EProjection = new EProjection(0, "Unspecified");

        /**
         * GoPro native lens projection (GPRO), used by conventional HERO camera media
         */
        public static const GOPRO:EProjection = new EProjection(9, "GoPro");

        private var _value:uint;
        private var _displayName:String;

        public function EProjection(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        public function get value():uint {
            return _value;
        }

        public function get displayName():String {
            return _displayName;
        }

        public static function fromValue(value:uint):EProjection {
            switch (value) {
                case 0:
                    return UNSPECIFIED;
                case 9:
                    return GOPRO;
                default:
                    return new EProjection(value, "Projection " + value);
            }
        }

        public function toString():String {
            return displayName;
        }
    }
}
