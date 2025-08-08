@echo off
quarto render
git add .
git commit -m "Update lectures"
git push
pause