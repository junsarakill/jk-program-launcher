#Requires AutoHotkey v2.0
#Include Lib\jk-utility\JKUtilityBase.ahk


class JKUtility Extends JKUtilityBase
{
    static LoadPrioritySheetData(csvFolderPath, csvFileName, keyHeader := "")
    {
        return super.LoadPrioritySheetData(csvFolderPath, csvFileName, keyHeader)
    }
}
