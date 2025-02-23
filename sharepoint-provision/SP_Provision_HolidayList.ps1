# Provision the Date Generation List

$SharePointSite = "https://powerfxhelp.sharepoint.com/sites/Sandbox"
$ListName = "Holidays-Test"
$HolidayCsv = Import-Csv ..\data\Holidays.csv
Connect-PnPOnline -url $SharePointSite -Interactive


$CheckExisting =  Get-PnPList -Identity $ListName

If($CheckExisting){

    Remove-PnPList -Identity $ListName -Force

}

New-PnPList -Title $ListName -Template GenericList -OnQuickLaunch:$true

$ListInfo = Get-PnPList -Identity $ListName
Write-Host "$Listname list id: $($ListInfo.id) created" -ForegroundColor cyan 

Set-PnPList -Identity $ListName -Description "Holiday List for Date Table usage" | Out-Null

# Add fields

Add-PnPField -List $ListName -InternalName "MonthNum" -DisplayName "MonthNum" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "Day" -DisplayName "Day" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "WeekNum" -DisplayName "WeekNum" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "DayofWeekNum" -DisplayName "DayofWeekNum" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "HolidayType" -DisplayName "HolidayType" -Type Text -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "Notes" -DisplayName "Notes" -Type Note -AddToDefaultView | Out-Null
Set-PnPField -List $ListName "WeekNum" -Values @{Description = "The week number of the month in which the holiday occurs."}
Set-PnPField -List $ListName "DayofWeekNum" -Values @{Description = "The numerical day of the week the holiday occurs as represented by excel weekday function. If the day varies, leave blank."}

Foreach ($holiday in $HolidayCsv){

    $HolidayObj = @{
        Title = $holiday.Title
        MonthNum = $holiday.MonthNum
        WeekNum = $holiday.WeekNum
        Day = $holiday.Day
        DayofWeekNum = $holiday.DayofWeekNum
        HolidayType = $holiday.HolidayType
        Notes = $holiday.Notes

    }

    Add-PnPListItem -List $ListName -Values $HolidayObj | Out-Null
}

Disconnect-PnPOnline