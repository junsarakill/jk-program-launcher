#Requires AutoHotkey v2.0
#Include Utility.ahk

/************************************************************************
 * @description 프로그램 실행용
 * @author JKAKK
 * @date 2026/11/03
 * @version 0.0.2
 ***********************************************************************/
; 프로그램 정보 | pathSheetdata
class ProgramInfo
{
    name := ""
    path := ""
    args := ""

    __New(name := "", path := "", args := "") {
        this.name := name
        this.path := path
        this.args := args
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
     * #### 이름으로 목표 실행 정보 가져오기
     * *
     * @param {String} targetName - 목표 이름
     * @returns {ProgramInfo} - 목표 실행 정보
     */
    static GetTargetPath(targetName)
    {
        try 
        {
            if(this.programInfoMap.Has(targetName))
            {
                /** @type {ProgramInfo} */
                targetInfo := this.programInfoMap[targetName]

                return targetInfo
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
            return targetInfo()
        }
    }

    /**
     * #### 이름으로 프로그램 실행
     * @description 이름 받아서 시트 데이터에 실행 데이터 조회
     * @param {String} targetName - 목표 이름
     */
    static RunTarget(targetName)
    {
        /** @type {ProgramInfo} */
        targetInfo := this.GetTargetPath(targetName)
        if(!targetInfo.path)
        {
            JKUtility.Log("경로 없음")
            return
        }
        
        this.RunTargetInfo(targetInfo)
    }

    /**
     * #### 경로로 프로그램 실행
     * @param {ProgramInfo} targetInfo - 프로그램 실행 정보
     */
    static RunTargetInfo(targetInfo)
    {
        ; 경로 좌우에 자동으로 큰따옴표를 붙여서 Run에 전달
        if(targetInfo.args != "")
            Run('"' targetInfo.path '" "' targetInfo.args '"')
        else
            Run('"' targetInfo.path '"')

        JKUtility.Log("프로그램 실행 : " targetInfo.name)
        Sleep(50)
    }

    /**
     * #### 이름 배열 받아서 순차적 실행
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
