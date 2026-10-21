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
     * AVC profile
     */
    public final class EAvcProfile {
        /**
         * Unspecified
         */
        public static const UNSPECIFIED:EAvcProfile = new EAvcProfile(0, "Unspecified");

        /**
         * CAVLC 4:4:4 Intra
         */
        public static const CAVLC_444_INTRA:EAvcProfile = new EAvcProfile(44, "CAVLC 4:4:4 Intra");

        /**
         * Baseline
         */
        public static const BASELINE:EAvcProfile = new EAvcProfile(66, "Baseline");

        /**
         * Main
         */
        public static const MAIN:EAvcProfile = new EAvcProfile(77, "Main");

        /**
         * Scalable Baseline
         */
        public static const SCALABLE_BASELINE:EAvcProfile = new EAvcProfile(83, "Scalable Baseline");

        /**
         * Scalable High
         */
        public static const SCALABLE_HIGH:EAvcProfile = new EAvcProfile(86, "Scalable High");

        /**
         * Extended
         */
        public static const EXTENDED:EAvcProfile = new EAvcProfile(88, "Extended");

        /**
         * High
         */
        public static const HIGH:EAvcProfile = new EAvcProfile(100, "High");

        /**
         * High 10
         */
        public static const HIGH_10:EAvcProfile = new EAvcProfile(110, "High 10");

        /**
         * Multiview High
         */
        public static const MULTIVIEW_HIGH:EAvcProfile = new EAvcProfile(118, "Multiview High");

        /**
         * High 4:2:2
         */
        public static const HIGH_422:EAvcProfile = new EAvcProfile(122, "High 4:2:2");

        /**
         * Stereo High
         */
        public static const STEREO_HIGH:EAvcProfile = new EAvcProfile(128, "Stereo High");

        /**
         * Multiview Depth High
         */
        public static const MULTIVIEW_DEPTH_HIGH:EAvcProfile = new EAvcProfile(138, "Multiview Depth High");

        /**
         * High 4:4:4 Predictive
         */
        public static const HIGH_444_PREDICTIVE:EAvcProfile = new EAvcProfile(244, "High 4:4:4 Predictive");

        private static const VALUES:Array = [
            UNSPECIFIED,
            CAVLC_444_INTRA,
            BASELINE,
            MAIN,
            SCALABLE_BASELINE,
            SCALABLE_HIGH,
            EXTENDED,
            HIGH,
            HIGH_10,
            MULTIVIEW_HIGH,
            HIGH_422,
            STEREO_HIGH,
            MULTIVIEW_DEPTH_HIGH,
            HIGH_444_PREDICTIVE
        ];

        private var _value:uint;
        private var _displayName:String;

        public function EAvcProfile(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        public function get value():uint {
            return _value;
        }

        public function get displayName():String {
            return _displayName;
        }

        public static function fromValue(value:uint):EAvcProfile {
            for each (var profile:EAvcProfile in VALUES) {
                if (profile.value == value) {
                    return profile;
                }
            }

            return new EAvcProfile(value, "Unknown AVC profile " + value);
        }

        public function toString():String {
            return displayName;
        }
    }
}
