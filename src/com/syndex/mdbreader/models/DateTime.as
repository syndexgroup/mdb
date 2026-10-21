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
    /**
     * Date and time
     */
    public final class DateTime {
        /**
         * Year
         */
        public var year:int;

        /**
         * Month
         */
        public var month:int;

        /**
         * Day
         */
        public var day:int;

        /**
         * Hour
         */
        public var hour:int;

        /**
         * Minute
         */
        public var minute:int;

        /**
         * Second
         */
        public var second:int;

        /**
         * Constructor
         * @param year Year value
         * @param month Month value
         * @param day Day value
         * @param hour Hour value
         * @param minute Minute value
         * @param second Second value
         */
        public function DateTime(year:int = 0, month:int = 0, day:int = 0, hour:int = 0, minute:int = 0, second:int = 0) {
            this.year = year;
            this.month = month;
            this.day = day;
            this.hour = hour;
            this.minute = minute;
            this.second = second;
        }

        /**
         * Confirm if date is valid
         */
        public function get valid():Boolean {
            return year >= 1980 && year <= 2200 && month >= 1 && month <= 12 && day >= 1 && day <= 31 && hour >= 0 && hour < 24 && minute >= 0 && minute < 60 && second >= 0 && second < 60;
        }

        /**
         * Convert to a Date object
         * @return The converted object
         */
        public function toDate():Date {
            if (!valid) {
                return null;
            }

            return new Date(year, month - 1, day, hour, minute, second);
        }

        /**
         * Get standalone object
         * @return The newly created object
         */
        public function toObject():Object {
            if (!valid) {
                return null;
            }

            return {
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second
            };
        }

        /**
         * Convert to readable string
         * @return The readable string
         */
        public function toString():String {
            if (!valid) {
                return "";
            }

            return pad4(year) + "-" + pad2(month) + "-" + pad2(day) + " " + pad2(hour) + ":" + pad2(minute) + ":" + pad2(second);
        }

        private static function pad2(value:int):String {
            return value < 10 ? "0" + value : String(value);
        }

        private static function pad4(value:int):String {
            var result:String = String(value);
            while (result.length < 4) {
                result = "0" + result;
            }

            return result;
        }
    }
}
