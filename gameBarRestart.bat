@echo off

@REM Game Bar 프로세스 종료 중...
taskkill /f /im GameBar.exe > nul 2>&1

@REM 3초 대기 중...
timeout /t 3 /nobreak > nul

@REM Game Bar 다시 실행 중...
cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\jkakk_apps"
start gameBarLink
