#Requires AutoHotkey v2.0
#Include Utility.ahk

/************************************************************************
 * @description 프로그램 실행용
 * @author JKAKK
 * @date 2026/05/19
 * @version 0.0.1
 ***********************************************************************/

/**
 * 프로그램 실행 스크립트 베이스
 */
class JKProgramLauncher
{
    ; MARK: 변수 영역

    ; 프로그램 경로 시트명
    static PATH_SHEET_NAME := "PathSheet"

    ; 별명 : 프로그램 전체 경로 중첩 맵
    static pathTable := JKUtility.LoadPrioritySheetData(JKUtility.SHEET_FOLDER, this.PATH_SHEET_NAME)

    ; 실행할 목표
    static curTargetName := ""

    ; MARK: 함수 영역

    ; 이름으로 목표 경로 가져오기
    static GetTargetPath(targetName)
    {
        targetPath := ""
        for row in this.pathTable
        {
            if(row["name"] = targetName)
            {
                targetPath := row["path"]
                break
            }
        }

        return targetPath
    }

    ; 이름으로 프로그램 실행
    static RunTarget(targetName, args := "")
    {
        targetPath := this.GetTargetPath(targetName)

        this.RunTargetPath(targetPath, args)

        JKUtility.Log("프로그램 실행 : " targetName)
    }

    static RunTargetPath(targetPath, args := "")
    {
        ; 경로 좌우에 자동으로 큰따옴표를 붙여서 Run에 전달
        if (args != "")
            Run('"' targetPath '" ' args)
        else
            Run('"' targetPath '"')
    }

}


; MARK: 실행 영역

; XXX 테스트용
; JKProgramLauncher.RunTarget("notepad")
; Run("dmmgameplayer://play/GCL/dolwav/cl/win")