#Requires AutoHotkey v2.0
#Include JKProgramLauncher.ahk

/************************************************************************
 * @description 돌핀웨이브 실행용
 * @author JKAKK
 * @date 2026/05/22
 * @version 0.0.1
 ***********************************************************************/

class JKRunDaily extends JKProgramLauncher
{
    ; 현재 받은 인수 | 실행할때 받아서 분기 처리
    static curArgs := ""

    ; 실행 그룹 시트명
    static DAILY_GROUP_SHEEP_NAME := "DailyGroupSheet"

    ; 인수 이름 : 실행 그룹 배열
    static groupMap := this.LoadDailyGroupSheet(JKUtility.SHEET_FOLDER, this.DAILY_GROUP_SHEEP_NAME)
    
    ; 실행 그룹 시트 받아서 실사용 가공
    static LoadDailyGroupSheet(csvFolderPath, csvFileName)
    {
        sheetData := JKUtility.LoadPrioritySheetData(csvFolderPath, csvFileName)

        ; csvData의 각 항목을 순회하며 데이터 변환
        for key, value in sheetData
        {
            ; 값이 쉼표를 포함하고 있는지 확인
            if (InStr(value, ","))
            {
                ; 쉼표가 포함되어 있다면 배열로 변환하여 덮어쓰기
                sheetData[key] := StrSplit(value, ",")
            }
        }

        return sheetData
    }
}

; ; jkghk 실행
; JKRunDaily.RunTarget("jkghk")
; ; 돌핀웨이브 실행
; JKRunDaily.RunTarget("dolphinwave")
