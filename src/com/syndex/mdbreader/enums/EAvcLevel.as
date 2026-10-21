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
     * AVC level
     */
    public final class EAvcLevel {
        /**
         * Unspecified
         */
        public static const UNSPECIFIED:EAvcLevel = new EAvcLevel(0, "Unspecified");

        /**
         * Level 1
         */
        public static const LEVEL_1:EAvcLevel = new EAvcLevel(10, "Level 1");

        /**
         * Level 1.1
         */
        public static const LEVEL_1_1:EAvcLevel = new EAvcLevel(11, "Level 1.1");

        /**
         * Level 1.2
         */
        public static const LEVEL_1_2:EAvcLevel = new EAvcLevel(12, "Level 1.2");

        /**
         * Level 1.3
         */
        public static const LEVEL_1_3:EAvcLevel = new EAvcLevel(13, "Level 1.3");

        /**
         * Level 2
         */
        public static const LEVEL_2:EAvcLevel = new EAvcLevel(20, "Level 2");

        /**
         * Level 2.1
         */
        public static const LEVEL_2_1:EAvcLevel = new EAvcLevel(21, "Level 2.1");

        /**
         * Level 2.2
         */
        public static const LEVEL_2_2:EAvcLevel = new EAvcLevel(22, "Level 2.2");

        /**
         * Level 3
         */
        public static const LEVEL_3:EAvcLevel = new EAvcLevel(30, "Level 3");

        /**
         * Level 3.1
         */
        public static const LEVEL_3_1:EAvcLevel = new EAvcLevel(31, "Level 3.1");

        /**
         * Level 3.2
         */
        public static const LEVEL_3_2:EAvcLevel = new EAvcLevel(32, "Level 3.2");

        /**
         * Level 4
         */
        public static const LEVEL_4:EAvcLevel = new EAvcLevel(40, "Level 4");

        /**
         * Level 4.1
         */
        public static const LEVEL_4_1:EAvcLevel = new EAvcLevel(41, "Level 4.1");

        /**
         * Level 4.2
         */
        public static const LEVEL_4_2:EAvcLevel = new EAvcLevel(42, "Level 4.2");

        /**
         * Level 5
         */
        public static const LEVEL_5:EAvcLevel = new EAvcLevel(50, "Level 5");

        /**
         * Level 5.1
         */
        public static const LEVEL_5_1:EAvcLevel = new EAvcLevel(51, "Level 5.1");

        /**
         * Level 5.2
         */
        public static const LEVEL_5_2:EAvcLevel = new EAvcLevel(52, "Level 5.2");

        /**
         * Level 6
         */
        public static const LEVEL_6:EAvcLevel = new EAvcLevel(60, "Level 6");

        /**
         * Level 6.1
         */
        public static const LEVEL_6_1:EAvcLevel = new EAvcLevel(61, "Level 6.1");

        /**
         * Level 6.2
         */
        public static const LEVEL_6_2:EAvcLevel = new EAvcLevel(62, "Level 6.2");

        private static const VALUES:Array = [
            UNSPECIFIED,
            LEVEL_1,
            LEVEL_1_1,
            LEVEL_1_2,
            LEVEL_1_3,
            LEVEL_2,
            LEVEL_2_1,
            LEVEL_2_2,
            LEVEL_3,
            LEVEL_3_1,
            LEVEL_3_2,
            LEVEL_4,
            LEVEL_4_1,
            LEVEL_4_2,
            LEVEL_5,
            LEVEL_5_1,
            LEVEL_5_2,
            LEVEL_6,
            LEVEL_6_1,
            LEVEL_6_2
        ];

        private var _value:uint;
        private var _displayName:String;

        public function EAvcLevel(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        public function get value():uint {
            return _value;
        }

        public function get displayName():String {
            return _displayName;
        }

        public static function fromValue(value:uint):EAvcLevel {
            for each (var level:EAvcLevel in VALUES) {
                if (level.value == value) {
                    return level;
                }
            }

            return new EAvcLevel(value, "Unknown AVC level " + value);
        }

        public function toString():String {
            return displayName;
        }
    }
}
