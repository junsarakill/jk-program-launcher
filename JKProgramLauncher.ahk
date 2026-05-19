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
    ; 프로그램 경로 시트명
    static PATH_SHEET_NAME := "PathSheet"

    ; 별명 : 프로그램 전체 경로 중첩 맵
    static pathTable := JKUtility.LoadPrioritySheetData(JKUtility.SHEET_FOLDER, this.PATH_SHEET_NAME)
}