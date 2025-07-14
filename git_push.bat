@echo off
set /p msg=Commit message: 

if "%msg%"=="" (
  echo Commit message darf nicht leer sein.
  pause
  exit /b 1
)

git add .
git commit -m "%msg%"
git push origin main

pause