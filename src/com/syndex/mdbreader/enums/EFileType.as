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
     * Typed media file value
     */
    public final class EFileType {
        /**
         * Unspecified file type
         */
        public static const UNKNOWN:EFileType = new EFileType(0, "Unknown 0x0");

        /**
         * Video file
         */
        public static const VIDEO:EFileType = new EFileType(0x00001000, "Video");

        /**
         * Right channel of 3D video
         */
        public static const VIDEO_3D_RIGHT:EFileType = new EFileType(0x00001003, "3D Video (Right)");

        /**
         * Left channel of 3D video
         */
        public static const VIDEO_3D_LEFT:EFileType = new EFileType(0x00001005, "3D Video (Left)");

        /**
         * Proxy video
         */
        public static const VIDEO_LRV:EFileType = new EFileType(0x00001010, "Low-Resolution Video");

        /**
         * Thumbnail companion for a video file
         */
        public static const VIDEO_THM:EFileType = new EFileType(0x00001020, "Video Thumbnail");

        /**
         * TRV companion for a video file
         */
        public static const VIDEO_TRV:EFileType = new EFileType(0x00001040, "TRV Video Companion");

        /**
         * HQ audio for a video file
         */
        public static const VIDEO_WAV:EFileType = new EFileType(0x00001080, "Video Audio");

        /**
         * Loopable video
         */
        public static const VIDEO_LOOP:EFileType = new EFileType(0x00001100, "Looping Video");

        /**
         * Proxy for loopable video
         */
        public static const VIDEO_LOOP_LRV:EFileType = new EFileType(0x00001110, "Low-Resolution Looping Video");

        /**
         * HQ audio for loopable video
         */
        public static const VIDEO_WAV_LOOP:EFileType = new EFileType(0x00001180, "Looping Video Audio");

        /**
         * Chaptered video
         */
        public static const VIDEO_CHAPTERED:EFileType = new EFileType(0x00001200, "Chaptered Video");

        /**
         * Proxy for a chaptered video
         */
        public static const VIDEO_CHAPTERED_LRV:EFileType = new EFileType(0x00001210, "Low-Resolution Chaptered Video");

        /**
         * HQ audio for a chaptered video
         */
        public static const VIDEO_CHAPTERED_WAV:EFileType = new EFileType(0x00001280, "Chaptered Video Audio");

        /**
         * Timelapse video
         */
        public static const VIDEO_TIMELAPSE:EFileType = new EFileType(0x00011000, "Time-Lapse Video");

        /**
         * Photo
         */
        public static const PHOTO:EFileType = new EFileType(0x00002000, "Photo");

        /**
         * Right channel of 3D photo
         */
        public static const PHOTO_3D_RIGHT:EFileType = new EFileType(0x00002003, "3D Photo (Right)");

        /**
         * Left channel of 3D photo
         */
        public static const PHOTO_3D_LEFT:EFileType = new EFileType(0x00002005, "3D Photo (Left)");

        /**
         * Raw DNG photo
         */
        public static const PHOTO_DNG:EFileType = new EFileType(0x00002010, "Raw Photo");

        /**
         * Photo burst
         */
        public static const PHOTO_BURST:EFileType = new EFileType(0x00002100, "Burst Photo");

        /**
         * Right 3D channel of photo burst
         */
        public static const PHOTO_BURST_3D_RIGHT:EFileType = new EFileType(0x00002103, "3D Burst Photo (Right)");

        /**
         * Left 3D channel of photo burst
         */
        public static const PHOTO_BURST_3D_LEFT:EFileType = new EFileType(0x00002105, "3D Burst Photo (Left)");

        /**
         * Photo captured while recording video
         */
        public static const PHOTO_PIV:EFileType = new EFileType(0x00002400, "Photo Captured During Video");

        /**
         * Timelapse photo
         */
        public static const PHOTO_TIMELAPSE:EFileType = new EFileType(0x00012100, "Time-Lapse Photo");

        /**
         * Continuous photo sequence
         */
        public static const PHOTO_CONTINUOUS:EFileType = new EFileType(0x00022100, "Continuous Photo");

        /**
         * Night-lapse photo sequence
         */
        public static const PHOTO_NIGHTLAPSE:EFileType = new EFileType(0x00042100, "Night-Lapse Photo");

        /**
         * Night photo
         */
        public static const PHOTO_NIGHT:EFileType = new EFileType(0x00102000, "Night Photo");

        /**
         * Metadata file
         */
        public static const METADATA:EFileType = new EFileType(0x00004000, "Metadata");

        /**
         * Standalone audio
         */
        public static const AUDIO:EFileType = new EFileType(0x00008000, "Audio");

        /**
         * 360-degree video
         */
        public static const VIDEO_360:EFileType = new EFileType(0x20001000, "360-Degree Video");

        /**
         * Raw MDB value
         */
        private var _value:uint;

        /**
         * Readable value name
         */
        private var _displayName:String;

        /**
         * Constructor
         * @param value Raw value stored in the MDB record
         * @param displayName Readable name for the value
         */
        public function EFileType(value:uint, displayName:String) {
            _value = value;
            _displayName = displayName;
        }

        /**
         * Raw value stored in the MDB record
         */
        public function get value():uint {
            return _value;
        }

        /**
         * Readable file type name
         */
        public function get displayName():String {
            return _displayName;
        }

        /**
         * Get display name
         * @param value The value to display
        * @return The display name
         */
        public static function name(value:EFileType):String {
            return value == null ? UNKNOWN.displayName : value.displayName;
        }

        /**
         * Get typed value
         * @param value Raw value stored in the MDB record
         * @return The matching enum value
         */
        public static function fromValue(value:uint):EFileType {
            var values:Array = [
                VIDEO,
                VIDEO_3D_RIGHT,
                VIDEO_3D_LEFT,
                VIDEO_LRV,
                VIDEO_THM,
                VIDEO_TRV,
                VIDEO_WAV,
                VIDEO_LOOP,
                VIDEO_LOOP_LRV,
                VIDEO_WAV_LOOP,
                VIDEO_CHAPTERED,
                VIDEO_CHAPTERED_LRV,
                VIDEO_CHAPTERED_WAV,
                VIDEO_TIMELAPSE,
                PHOTO,
                PHOTO_3D_RIGHT,
                PHOTO_3D_LEFT,
                PHOTO_DNG,
                PHOTO_BURST,
                PHOTO_BURST_3D_RIGHT,
                PHOTO_BURST_3D_LEFT,
                PHOTO_PIV,
                PHOTO_TIMELAPSE,
                PHOTO_CONTINUOUS,
                PHOTO_NIGHTLAPSE,
                PHOTO_NIGHT,
                METADATA,
                AUDIO,
                VIDEO_360
            ];

            for each (var fileType:EFileType in values) {
                if (fileType.value == value) {
                    return fileType;
                }
            }

            return value == 0 ? UNKNOWN : new EFileType(value, "Unknown 0x" + value.toString(16));
        }

        /**
         * If the type is a photo
         * @param value The value to check
         * @return If the type is a photo
         */
        public static function isPhoto(value:EFileType):Boolean {
            return value != null && ((value.value & 0x00002000) == 0x00002000 || value == PHOTO_TIMELAPSE || value == PHOTO_CONTINUOUS || value == PHOTO_NIGHTLAPSE || value == PHOTO_NIGHT);
        }

        /**
         * Get the filename extensions used by a media type
         * @param value The media type to resolve
         * @return Uppercase extensions without leading dot
         */
        public static function expectedExtensions(value:EFileType):Array {
            if (value == VIDEO_LRV || value == VIDEO_LOOP_LRV || value == VIDEO_CHAPTERED_LRV) {
                return ["LRV"];
            }

            if (value == VIDEO_THM) {
                return ["THM"];
            }

            if (value == VIDEO_TRV) {
                return ["TRV"];
            }

            if (value == VIDEO_WAV || value == VIDEO_WAV_LOOP || value == VIDEO_CHAPTERED_WAV || value == AUDIO) {
                return ["WAV"];
            }

            if (value == VIDEO_360) {
                return ["360"];
            }

            if (value == PHOTO_DNG) {
                return ["GPR"];
            }

            if (isPhoto(value)) {
                return ["JPG", "JPEG"];
            }

            if (value == VIDEO || value == VIDEO_3D_RIGHT || value == VIDEO_3D_LEFT || value == VIDEO_LOOP || value == VIDEO_CHAPTERED || value == VIDEO_TIMELAPSE) {
                return ["MP4"];
            }

            return [];
        }

        /**
         * Convert to readable name
         * @return The display name
         */
        public function toString():String {
            return displayName;
        }
    }
}
