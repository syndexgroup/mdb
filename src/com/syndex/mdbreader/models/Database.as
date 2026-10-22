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

package com.syndex.mdbreader.models  {
    import com.syndex.sharedpublic.Version;

    /**
     * A MDB database
     */
    public final class Database {
        /**
         * Database source path
         */
        public var sourcePath:String;

        /**
         * If the header is valid
         */
        public var headerValid:Boolean;

        /**
         * The type of database
         */
        public var schema:String = Schema.UNKNOWN;

        /**
         * Offset to the database's dictionary data
         */
        public var dictionaryOffset:uint;

        /**
         * Database version identifier
         */
        public var dbVersion:Version = new Version();

        /**
         * MCO version identifier
         */
        public var mcoVersion:Version = new Version();

        /**
         * Database records present
         */
        public var records:Vector.<Record> = new Vector.<Record>();

        /**
         * Database groups present
         */
        public var groups:Vector.<Group> = new Vector.<Group>();

        /**
         * Get standalone object from current database
         * @return The newly created object
         */
        public function toObject():Object {
            var recordObjects:Array = [];
            var groupObjects:Array = [];
            var record:Record;
            var group:Group;

            for each (record in records) {
                recordObjects.push(record.toObject());
            }

            for each (group in groups) {
                groupObjects.push(group.toObject());
            }

            return {
                sourcePath: sourcePath,
                headerValid: headerValid,
                schema: schema,
                dictionaryOffset: dictionaryOffset,
                dbVersion: dbVersion.toObject(),
                mcoVersion: mcoVersion.toObject(),
                records: recordObjects,
                groups: groupObjects
            };
        }
    }
}
