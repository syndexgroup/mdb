@echo off
setlocal

pushd "%~dp0"

if not exist "version.txt" (
    echo version.txt was not found!! 1>&2
    popd
    exit /b 1
)

set /p "MDB_VERSION="<"version.txt"
if not defined MDB_VERSION (
    echo version.txt is empty! 1>&2
    popd
    exit /b 1
)

if not exist "out" mkdir "out"
if not exist "airpackage\swc" mkdir "airpackage\swc"

call compc "-source-path=src" "-include-sources=src" "-output=out/mdb_%MDB_VERSION%.swc"
set "BUILD_RESULT=%ERRORLEVEL%"
if not "%BUILD_RESULT%"=="0" (
    popd
    exit /b %BUILD_RESULT%
)

copy /Y "out\mdb_%MDB_VERSION%.swc" "airpackage\swc\mdb.swc" >nul
set "BUILD_RESULT=%ERRORLEVEL%"

popd
exit /b %BUILD_RESULT%
