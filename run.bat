@echo off
setlocal

:: Get the path to LOVE
set LOVE_PATH="C:\Program Files\LOVE\love.exe"

:: Check if LOVE exists
if not exist %LOVE_PATH% (
    echo LOVE is not installed at %LOVE_PATH%
    exit /b 1
)

:: Run LOVE with the current directory as the game source
%LOVE_PATH% .

endlocal
