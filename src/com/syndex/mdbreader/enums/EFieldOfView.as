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
     * GoPro digital field-of-view setting
     */
    public final class EFieldOfView {
        /**
         * Wide
         */
        public static const WIDE:EFieldOfView = new EFieldOfView(0, "Wide");

        /**
         * Narrow
         */
        public static const NARROW:EFieldOfView = new EFieldOfView(2, "Narrow");

        /**
         * Superview
         */
        public static const SUPERVIEW:EFieldOfView = new EFieldOfView(3, "Superview");

        /**
         * Linear
         */
        public static const LINEAR:EFieldOfView = new EFieldOfView(4, "Linear");

        /**
         * Max SuperView
         */
        public static const MAX_SUPERVIEW:EFieldOfView = new EFieldOfView(7, "Max SuperView");

        /**
         * Linear + Horizon Leveling
         */
        public static const LINEAR_HORIZON_LEVELING:EFieldOfView = new EFieldOfView(8, "Linear + Horizon Leveling");

        /**
         * HyperView
         */
        public static const HYPERVIEW:EFieldOfView = new EFieldOfView(9, "HyperView");

        /**
         * Linear + Horizon Lock
         */
        public static const LINEAR_HORIZON_LOCK:EFieldOfView = new EFieldOfView(10, "Linear + Horizon Lock");

        /**
         * Max HyperView
         */
        public static const MAX_HYPERVIEW:EFieldOfView = new EFieldOfView(11, "Max HyperView");

        /**
         * Ultra SuperView
         */
        public static const ULTRA_SUPERVIEW:EFieldOfView = new EFieldOfView(12, "Ultra SuperView");

        /**
         * Ultra Wide
         */
        public static const ULTRA_WIDE:EFieldOfView = new EFieldOfView(13, "Ultra Wide");

        /**
         * Ultra Linear
         */
        public static const ULTRA_LINEAR:EFieldOfView = new EFieldOfView(14, "Ultra Linear");

        /**
         * ultra HyperView
         */
        public static const ULTRA_HYPERVIEW:EFieldOfView = new EFieldOfView(104, "Ultra HyperView");

        private static const VALUES:Array = [
            WIDE,
            NARROW,
            SUPERVIEW,
            LINEAR,
            MAX_SUPERVIEW,
            LINEAR_HORIZON_LEVELING,
            HYPERVIEW,
            LINEAR_HORIZON_LOCK,
            MAX_HYPERVIEW,
            ULTRA_SUPERVIEW,
            ULTRA_WIDE,
            ULTRA_LINEAR,
            ULTRA_HYPERVIEW
        ];

        private var _value:uint;
        private var _displayName:String;

        public function EFieldOfView(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        public function get value():uint {
            return _value;
        }

        public function get displayName():String {
            return _displayName;
        }

        public static function fromValue(value:uint):EFieldOfView {
            for each (var fieldOfView:EFieldOfView in VALUES) {
                if (fieldOfView.value == value) {
                    return fieldOfView;
                }
            }

            return new EFieldOfView(value, "Unknown field of view " + value);
        }

        public function toString():String {
            return displayName;
        }
    }
}
