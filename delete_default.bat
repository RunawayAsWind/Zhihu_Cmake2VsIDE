@echo off
REM 
chcp 65001
CLS


if exist ".\build\default" (
	rmdir /s/q ".\build\default"
)

echo.
echo "Delete Finish-----------------------"
echo.

pause