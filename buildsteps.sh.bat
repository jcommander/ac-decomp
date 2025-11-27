@echo off
# GAME_NAME=mygame

:: python configure.py --non-matching --map

echo >/dev/null # >nul & GOTO WINDOWS & rem ^
# Linux Section ---

# extract the value from the shared line
game_folder="$(grep '^# GAME_NAME=' "$0" | cut -d= -f2)"

# build - exit on fail
ninja || exit 1

cp "./build/GAFE01_00/foresta/foresta.rel.szs" "./build/$game_folder/files"
cp "./build/GAFE01_00/static.dol" "./build/$game_folder/sys/main.dol"

exit 0

:WINDOWS
:: Windows Section ---
set "SKIP_BUILD=false"
set "SKIP_COPY=false"
set "SKIP_RUN=false"

:: extract the value from the shared line
for /f "tokens=2 delims==" %%A in ('findstr /b "# GAME_NAME=" "%~f0"') do set "GAME_NAME=%%A"

:: loop over all command-line args
:loop
if "%~1"=="" goto afterargs
if /I "%~1"=="--skip-build" set "SKIP_BUILD=true"
if /I "%~1"=="--skip-copy" set "SKIP_COPY=true"
if /I "%~1"=="--skip-run" set "SKIP_RUN=true"
shift
goto loop

:afterargs

if "%SKIP_BUILD%"=="false" (
    echo Windows: running build
    # build - exit on fail
    ninja
    if errorlevel 1 goto end
) else (
    echo Windows: skipping build
)

if "%SKIP_COPY%"=="false" (
    echo Windows: copying files
    copy /Y ".\build\GAFE01_00\foresta\foresta.rel.szs" ".\build\%GAME_NAME%\files"
    copy /Y ".\build\GAFE01_00\static.dol" ".\build\%GAME_NAME%\sys\main.dol"
) else (
    echo Windows: skipping copy
)

if "%SKIP_RUN%"=="false" (
    echo Windows: running dolphin
    dolphin ".\build\%GAME_NAME%\sys\main.dol"
) else (
    echo Windows: skipping run
)

:end