#Requires AutoHotkey v2.0
#Include JKProgramLauncher.ahk

/************************************************************************
 * @description 게임바 재시작
 * @author JKAKK
 * @date 2026/05/26
 * @version 0.0.2
 ***********************************************************************/


class JKGameBarRestart extends JKProgramLauncher
{
    /**
     * #### 종료할 게임 바 관련 프로세스 리스트
     * @type {Array} 
     * @default null
     */
    static gameBarProcesses := ["GameBar.exe", "GameBarFTServer.exe", "XboxGamingOverlay.exe"]

    /**
     * #### 게임 바 관련 프로세스 종료
     * *
     * @returns {void}
     */
    static CloseGameBar(processAry)
    {
        ; 리스트를 돌면서 켜져 있는 프로세스가 있으면 모두 종료
        for process in processAry
        {
            if ProcessExist(process)
                ProcessClose(process)
        }
    }
}

; MARK: 실행 영역

; 게임바 프로세스 종료
JKGameBarRestart.CloseGameBar(JKGameBarRestart.gameBarProcesses)

; 3초 대기후 게임바 실행
SetTimer(() => (
    JKGameBarRestart.RunTarget("gamebar")
    ExitApp()
), -3000)