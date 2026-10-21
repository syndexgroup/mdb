# MDB reader

Adobe AIR library for reading and parsing GoPro `mdb.db` media databases (based on [eXtremeDB](https://en.wikipedia.org/wiki/EXtremeDB)). 

## Device support
- HERO 5/6/7
- HERO 8/9/MAX
- HERO 10
- HERO11+ 
- MAX2

## Usage

```actionscript
import com.syndex.mdbreader.MdbParser;
import com.syndex.mdbreader.models.Database;

var database:Database = MdbParser.parse("H:\\mdb.db");

// match database records to media files on the card
MdbParser.resolveFiles(database, "H:\\DCIM");
```

## Build

Ensure the Adobe AIR ([Harman AIR](https://airsdk.harman.com/download)) tools are available in your PATH, then run the relevant script for your platform:

```bat
build.cmd
```

```sh
./build.sh
```
