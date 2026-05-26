#Requires AutoHotkey v2.0
#Include Utility.ahk

/************************************************************************
 * @description 프로그램 실행용
 * @author JKAKK
 * @date 2026/05/19
 * @version 0.0.1
 ***********************************************************************/
; 프로그램 정보 | pathSheetdata
class ProgramInfo
{
    name := ""
    path := ""

    __New(name := "", path := "") {
        this.name := name
        this.path := path
    }
}

/**
 * 프로그램 실행 스크립트 베이스
 */
class JKProgramLauncher
{
    ; MARK: 변수 영역

    ; 프로그램 경로 시트명
    static PATH_SHEET_NAME => "PathSheet"

    /**
     * #### 이름 : 프로그램 정보 맵
     * @type {Map} 
     * @see ProgramInfo
     * @default Map[name:ProgramInfo()]
     */
    static programInfoMap := this.LoadPathSheet(JKUtility.SHEET_FOLDER, this.PATH_SHEET_NAME)

    ; MARK: 함수 영역

    /**
     * #### 프로그램 경로 시트 읽어서 클래스화
     * *
     * @param {String} sheetFolderPath - 경로 시트의 경로
     * @param {String} sheetName - 경로 시트의 이름
     * @see ProgramInfo
     * @returns {Map} - Map[name:ProgramInfo()]
     */
    static LoadPathSheet(sheetFolderPath, sheetName)
    {
        sheetData := JKUtility.LoadPrioritySheetData(sheetFolderPath, sheetName)

        ; 클래스화
        return JKUtility.MasterMapToClassMap(sheetData, ProgramInfo)
    }

    /**
     * #### 이름으로 목표 경로 가져오기
     * *
     * @param {String} targetName - 목표 이름
     * @returns {String} - 목표 경로
     */
    static GetTargetPath(targetName)
    {
        try 
        {
            if(this.programInfoMap.Has(targetName))
            {
                /** @type {ProgramInfo} */
                targetInfo := this.programInfoMap[targetName]

                return targetInfo.path
            }
            
            ; Map에 키가 없다면 의도적으로 에러를 발생시켜 catch 블록으로 보냅니다.
            throw Error("등록되지 않은 프로그램 이름입니다: " . targetName)
        }
        catch Error as err 
        {
            ; 로그를 남기거나 경고창을 띄워 크래시 없이 상황을 인지합니다.
            JKUtility.Log(err.Message)
            MsgBox(err.Message, "경로 로드 실패", "Icon! T2") 
            
            ; 크래시를 방지하기 위해 안전하게 빈 값을 반환합니다.
            return ""
        }
    }

    ; 이름으로 프로그램 실행
    /**
     * #### 이름으로 프로그램 실행
     * *
     * @param {String} targetName - 목표 이름
     * @param {String} args - 실행 인수
     */
    static RunTarget(targetName, args := "")
    {
        /** @type {String} */
        targetPath := this.GetTargetPath(targetName)
        if(targetPath = "")
            return
                
        this.RunTargetPath(targetPath, args)

        JKUtility.Log("프로그램 실행 : " targetName)
    }

    /**
     * #### 경로로 프로그램 실행
     * *
     * @param {String} targetPath - 목표 경로
     * @param {String} args - 실행 인수
     */
    static RunTargetPath(targetPath, args := "")
    {
        ; 경로 좌우에 자동으로 큰따옴표를 붙여서 Run에 전달
        if (args != "")
            Run('"' targetPath '" ' args)
        else
            Run('"' targetPath '"')
    }

    /**
     * #### 이름 배열 받아서 순차적 실행
     * *
     * 지금은 인수 필요없으니 일단 미작업
     * @param {Array} targetNameAry - 이름 배열
     */
    static RunTargetAry(targetNameAry)
    {
        for name in targetNameAry
        {
            this.RunTarget(name)
        }
    }

    ; 인수 받아서 처리
    static RunWithArgs()
    {
        ; 실제 내용은 각 파일이 상속 받아서 구현
        JKUtility.Log(A_Args.Length)
    }

}


; MARK: 실행 영역
; XXX 테스트용
; JKProgramLauncher.RunWithArgs()

; JKProgramLauncher.RunTarget("notepad")
; Run("dmmgameplayer://play/GCL/dolwav/cl/win")
