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
     * Version
     */
    public final class Version {
        /**
         * Major component
         */
        public var major:uint;

        /**
         * Minor component
         */
        public var minor:uint;

        /**
         * Patch/build component
         */
        public var patch:uint;

        /**
         * Constructor
         * @param major Major component
         * @param minor Minor component
         * @param patch Patch/build component
         */
        public function Version(major:uint = 0, minor:uint = 0, patch:uint = 0) {
            this.major = major;
            this.minor = minor;
            this.patch = patch;
        }

        /**
         * Get standalone object from current version
         * @return The newly created object
         */
        public function toObject():Object {
            return {
                major: major,
                minor: minor,
                patch: patch
            };
        }

        /**
         * Convert to display string
         * @return The major, minor and patch components separated by periods
         */
        public function toString():String {
            return major + "." + minor + "." + patch;
        }
    }
}
