@echo off
quarto render
git add .
git commit -m "Restructure TSA repo into multi-course lecture notes"
git push
pause