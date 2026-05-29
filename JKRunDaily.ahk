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

    __New(name := "", group := []) 
    {
        this.name := name
        this.group := group
    }
}

class JKRunDaily extends JKProgramLauncher
{
    /**
     * #### 실행 그룹 시트명
     * @type {String} 
     * @readonly
     * @default null
     */
    static DAILY_GROUP_SHEEP_NAME => "DailyGroupSheet"

    /**
     * #### 그룹 맵 [그룹 이름 key : 그룹 객체]
     * @type {Map} 
     * @see RunGroup
     * @default Map[key:RunGroup()]
     */
    static groupInsMap := this.LoadDailyGroupData(JKUtility.SHEET_FOLDER, this.DAILY_GROUP_SHEEP_NAME)

    ; MARK: 함수 영역
    
    ; 배열 { 맵[헤더] : 값}
    ; 실행 그룹 시트 받아서 실사용 가공
    /**
     * #### 실행 그룹 시트 받아서 실사용 맵{키:클래스} 로 가공
     * *
     * @see RunGroup
     * @param {String} csvFolderPath - 시트 폴더 경로
     * @param {String} csvFileName - 시트 파일 이름
     * @param {String} keyHeader - 객체를 찾을 키로 할 시트 헤더 이름
     * @returns {Map} - Map[key:RunGroup()]
     */
    static LoadDailyGroupData(csvFolderPath, csvFileName, keyHeader := "")
    {
        /** @type {Map} */
        sheetDataMap := JKUtility.LoadPrioritySheetData(csvFolderPath, csvFileName, keyHeader)

        ; 데이터내 , string을 배열로 변환
        sheetDataMap := JKUtility.ConvertCommaStringToAry(sheetDataMap)

        ; 데이터 맵을 클래스로 변환
        groupDataIns := JKUtility.MasterMapToClassMap(sheetDataMap, RunGroup)

        return groupDataIns
    }

    /**
     * #### 실행 그룹 이름 받아서 해당 그룹 실행
     * *
     * @param {String} groupName - 그룹 이름
     */
    static RunTargetGroup(groupName)
    {
        ; 그룹 존재 확인
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

    /**
     * #### 인수(그룹명) 으로 실행
     * *
     * ;@@ 그룹 안에 또 그룹이 있어서 재귀로 다 처리 하면 좋겠다.
     * 그러면 csv에 적을 때, all 같은 것도 그룹 두 개 적어서 재사용 되잖아?
     */
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