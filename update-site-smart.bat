@echo off

REM Get list of changed QMD files since last commit
for /f "delims=" %%f in ('git diff --name-only HEAD ^| findstr /R "\.qmd$"') do (
    set "changed_qmds=!changed_qmds! %%f"
)

REM Enable delayed variable expansion
setlocal enabledelayedexpansion

REM Count how many QMD files changed
set count=0
for %%f in (!changed_qmds!) do (
    set /a count+=1
)

REM Check conditions for full vs partial render
if "!changed_qmds!"=="" (
    echo No QMD changes found. Rendering full site to be safe...
    quarto render
) else if "!changed_qmds!"==" _quarto.yml" (
    echo _quarto.yml changed. Rendering full site...
    quarto render
) else if %count% GTR 1 (
    echo Multiple QMD files changed. Rendering full site...
    quarto render
) else (
    echo Rendering single file: !changed_qmds!
    quarto render !changed_qmds!
)

REM Add changes to git
git add .
set /p commitmsg="Enter commit message: "
git commit -m "%commitmsg%"
git push

pause
