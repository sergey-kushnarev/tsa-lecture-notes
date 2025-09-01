@echo off
REM Render the Quarto site
quarto render

REM Stage all changes
git add .

REM Prompt for commit message
set /p commitmsg="Enter commit message: "

REM Commit with the message you typed
git commit -m "%commitmsg%"

REM Push to GitHub
git push

pause