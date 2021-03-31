@echo off
REM 
chcp 65001
CLS

tree /F 
echo.
mkdir "./build/default/proj"
cd "./src"

cmake -S "." -B "../build/default/proj"
cmake --build "../build/default/proj" --target Demo --config Release
echo.
echo "Build Finish-----------------------"
echo.

pause