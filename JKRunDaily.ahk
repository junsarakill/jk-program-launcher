#Requires AutoHotkey v2.0
#Include JKProgramLauncher.ahk

/************************************************************************
 * @description 돌핀웨이브 실행용
 * @author JKAKK
 * @date 2026/05/22
 * @version 0.0.1
 ***********************************************************************/

; 그룹 데이터
class RunGroup
{
    ; 그룹 이름(키)
    name := ""
    ; 그룹 배열 [멤버 string]
    group := []

    __New(name := "", group := []) {
        this.name := name
        this.group := group
    }
}

class JKRunDaily extends JKProgramLauncher
{
    ; 현재 받은 인수 | 실행할때 받아서 분기 처리
    static curArgs := ""

    ; 실행 그룹 시트명
    static DAILY_GROUP_SHEEP_NAME := "DailyGroupSheet"

    /**
     * #### 그룹 맵 [그룹 이름 key : 그룹 객체]
     * @type {Map} 
     * @default null
     */
    static groupInsMap := this.LoadDailyGroupData(JKUtility.SHEET_FOLDER, this.DAILY_GROUP_SHEEP_NAME)

    ; MARK: 함수 영역
    
    ; 배열 { 맵[헤더] : 값}
    ; 실행 그룹 시트 받아서 실사용 가공
    static LoadDailyGroupData(csvFolderPath, csvFileName, keyHeader := "")
    {
        sheetDataMap := JKUtility.LoadPrioritySheetData(csvFolderPath, csvFileName, keyHeader)

        ; 데이터내 , string을 배열로 변환
        JKUtility.ConvertCommaStringToAry(sheetDataMap)

        ; 데이터 맵을 클래스로 변환
        groupDataIns := JKUtility.MasterMapToClassMap(sheetDataMap, RunGroup)

        return groupDataIns
    }

    ; 실행 그룹 이름 받아서 해당 그룹 실행
    static RunTargetGroup(groupName)
    {
        ; 그룹 배열 찾기
        if(this.groupInsMap.Has(groupName))
        {
            ; 그룹 멤버 순차 실행
            /** @type {RunGroup} */
            oneGroup := this.groupInsMap[groupName]
            for member in oneGroup.group
            {
                this.RunTarget(member)
            }
        }
        else
            JKUtility.Log("해당 그룹 없음 : " groupName)
    }

    ; 인수(그룹명) 으로 실행
    static RunWithArgs()
    {
        if(A_Args.Length = 0)
            return
        
        this.RunTargetGroup(A_Args[1])
    }
}

; MARK: 실행 영역 

; 인수 처리
JKRunDaily.RunWithArgs()
