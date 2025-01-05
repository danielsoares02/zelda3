@echo off

2>nul (del builds/zelda3_assets.dat)
python extract_assets/restool.py --extract-from-rom -r extras/zelda3.sfc --assets-path=/zelda3/assets
IF NOT ERRORLEVEL 0 goto ERROR

IF NOT EXIST "builds/zelda3_assets.dat" (
  ECHO ERROR: The python program didn't generate builds/zelda3_assets.dat successfully.
  goto ERROR  
) ELSE (
  REM
)

goto DONE


:ERROR
ECHO:
ECHO ERROR: Asset extraction failed!
pause
EXIT /B 1

:DONE
echo Complete!
pause