#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
VERSION_FILE="$SCRIPT_DIR/version.txt"

if [ ! -f "$VERSION_FILE" ]; then
    echo "version.txt was not found!!" >&2
    exit 1
fi

MDB_VERSION=$(tr -d '\r\n' < "$VERSION_FILE")
if [ -z "$MDB_VERSION" ]; then
    echo "version.txt is empty!" >&2
    exit 1
fi

mkdir -p "$SCRIPT_DIR/out"
compc "-source-path=$SCRIPT_DIR/src" "-include-sources=$SCRIPT_DIR/src" "-output=$SCRIPT_DIR/out/mdb_$MDB_VERSION.swc"
