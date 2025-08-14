@echo off
setlocal enabledelayedexpansion

REM --- Get list of changed QMD files and check for _quarto.yml ---
set "changed_qmds="
set "full_render_needed=0"
set count=0

REM Use a single loop to find all changes
for /f "delims=" %%f in ('git diff --name-only HEAD') do (
    set "file=%%f"
    if /i "!file!"==" _quarto.yml" (
        set "full_render_needed=1"
        goto :render_check
    )
    REM Check if the file ends with .qmd
    echo !file! | findstr /I /E ".qmd$" >nul
    if !errorlevel! equ 0 (
        set "changed_qmds=!changed_qmds! "%%f""
        set /a count+=1
    )
)

:render_check
REM --- Check conditions for full vs partial render ---
if !full_render_needed! equ 1 (
    echo _quarto.yml changed. Rendering full site...
    quarto render
) else if "!changed_qmds!"=="" (
    echo No QMD changes found. Rendering full site to be safe...
    quarto render
) else if !count! GTR 1 (
    echo Multiple QMD files changed. Rendering full site...
    quarto render
) else (
    echo Rendering single file: !changed_qmds!
    quarto render !changed_qmds!
)

REM --- Git Operations ---
git add .
set /p commitmsg="Enter commit message: "
git commit -m "%commitmsg%"
git push

pause