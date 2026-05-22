#Requires AutoHotkey v2.0
#Include JKProgramLauncher.ahk

/************************************************************************
 * @description 게임바 재시작
 * @author JKAKK
 * @date 2026/05/19
 * @version 0.0.1
 ***********************************************************************/


class JKGameBarRestart extends JKProgramLauncher
{

}


; MARK: 실행 영역

; 게임바 프로세스 종료
; 종료할 게임 바 관련 프로세스 리스트
gameBarProcesses := ["GameBar.exe", "GameBarFTServer.exe", "XboxGamingOverlay.exe"]

; 리스트를 돌면서 켜져 있는 프로세스가 있으면 모두 종료
for process in gameBarProcesses
{
    if ProcessExist(process)
        ProcessClose(process)
}

; 3초 대기
; 게임바 실행
SetTimer(() => (
    JKGameBarRestart.RunTarget("gamebar")
    ExitApp()
), -3000)