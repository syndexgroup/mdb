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
     * Lens-configuration identifier stored in a GoPro media record
     */
    public final class ELensConfiguration {
        /**
         * Unspecified
         */
        public static const UNSPECIFIED:ELensConfiguration = new ELensConfiguration(0, "Unspecified");

        /**
         * Max Lens Mod 1.0
         */
        public static const MAX_LENS_MOD_1_0:ELensConfiguration = new ELensConfiguration(1, "Max Lens Mod 1.0");

        /**
         * Max Lens Mod 2.0
         */
        public static const MAX_LENS_MOD_2_0:ELensConfiguration = new ELensConfiguration(2, "Max Lens Mod 2.0");

        /**
         * Max Lens Mod 2.5
         */
        public static const MAX_LENS_MOD_2_5:ELensConfiguration = new ELensConfiguration(3, "Max Lens Mod 2.5");

        /**
         * Macro Lens Mod
         */
        public static const MACRO:ELensConfiguration = new ELensConfiguration(4, "Macro Lens Mod");

        /**
         * Anamorphic Lens Mod
         */
        public static const ANAMORPHIC:ELensConfiguration = new ELensConfiguration(5, "Anamorphic Lens Mod");

        /**
         * ND4 filter
         */
        public static const ND4:ELensConfiguration = new ELensConfiguration(6, "ND4");

        /**
         * ND8 filter
         */
        public static const ND8:ELensConfiguration = new ELensConfiguration(7, "ND8");

        /**
         * ND16 filter
         */
        public static const ND16:ELensConfiguration = new ELensConfiguration(8, "ND16");

        /**
         * ND32 filter
         */
        public static const ND32:ELensConfiguration = new ELensConfiguration(9, "ND32");

        /**
         * Standard lens
         */
        public static const STANDARD_LENS:ELensConfiguration = new ELensConfiguration(10, "Standard Lens");

        /**
         * ND64 filter
         */
        public static const ND64:ELensConfiguration = new ELensConfiguration(11, "ND64");

        /**
         * Automatically detect the installed lens configuration
         */
        public static const AUTO_DETECT:ELensConfiguration = new ELensConfiguration(100, "Auto Detect");

        private var _value:uint;
        private var _displayName:String;

        public function ELensConfiguration(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        public function get value():uint {
            return _value;
        }

        public function get displayName():String {
            return _displayName;
        }

        public static function fromValue(value:uint):ELensConfiguration {
            switch (value) {
                case 0:
                    return UNSPECIFIED;
                case 1:
                    return MAX_LENS_MOD_1_0;
                case 2:
                    return MAX_LENS_MOD_2_0;
                case 3:
                    return MAX_LENS_MOD_2_5;
                case 4:
                    return MACRO;
                case 5:
                    return ANAMORPHIC;
                case 6:
                    return ND4;
                case 7:
                    return ND8;
                case 8:
                    return ND16;
                case 9:
                    return ND32;
                case 10:
                    return STANDARD_LENS;
                case 11:
                    return ND64;
                case 100:
                    return AUTO_DETECT;
                default:
                    return new ELensConfiguration(value, "Lens configuration " + value);
            }
        }

        public function toString():String {
            return displayName;
        }
    }
}
