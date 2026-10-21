package com.syndex.mdbreader.models {
    import com.syndex.mdbreader.util.UInt64;

    /**
     * Grouped media record
     */
    public final class Group {
        public var slotOffset:uint;
        public var fileHandle:UInt64 = new UInt64();

        /**
         * Framerate numerator
         */
        public var frameRateTimescale:uint;

        /**
         * Framerate denominator
         */
        public var frameRateDuration:uint;

        /**
         * Number of elements
         */
        public var elementCount:uint;

        /**
         * Group number
         */
        public var groupNumber:uint;

        /**
         * Group creation date
         */
        public var created:DateTime;

        /**
         * Media width
         */
        public var width:uint;

        /**
         * Media height
         */
        public var height:uint;

        /**
         * If the group contains progressive media
         */
        public var progressive:Boolean;

        /**
         * If the group is marked as subsampled
         */
        public var subsample:Boolean;

        /**
         * GUSI identifier
         */
        public var gusi:String = "";

        /**
         * GUMI identifier
         */
        public var gumi:String = "";

        /**
         * FPS
         * @return The calculated framerate
         */
        public function get fps():Number {
            return frameRateDuration == 0 ? 0 : Number(frameRateTimescale) / Number(frameRateDuration);
        }

        /**
         * Get standalone object from current group
         * @return The newly created object
         */
        public function toObject():Object {
            return {
                slotOffset: slotOffset,
                fileHandle: fileHandle.toHexString(),
                frameRateTimescale: frameRateTimescale,
                frameRateDuration: frameRateDuration,
                fps: fps,
                elementCount: elementCount,
                groupNumber: groupNumber,
                created: created ? created.toObject() : null,
                width: width,
                height: height,
                progressive: progressive,
                subsample: subsample,
                gusi: gusi,
                gumi: gumi
            };
        }
    }
}
