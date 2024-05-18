# Provision the Date Generator List

$SharePointSite = "https://powerfxhelp.sharepoint.com/sites/Sandbox"
$ListName = "DateGenerator"

Connect-PnPOnline -url $SharePointSite -Interactive

$CheckExisting =  Get-PnPList -Identity $ListName

If($CheckExisting){

    Remove-PnPList -Identity $ListName -Force

}

# Create List

New-PnPList -Title $ListName -Template GenericList -OnQuickLaunch:$true

$ListInfo = Get-PnPList -Identity $ListName
Write-Host "$Listname list id: $($ListInfo.id) created" -ForegroundColor cyan 

Set-PnPList -Identity $ListName -Description "Contains Dates Generated by Date Generator App" | Out-Null

# Add Fields

Add-PnPField -List $ListName -InternalName "Date" -DisplayName "Date" -Type DateTime -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "MonthNum" -DisplayName "MonthNum" -Type Number | Out-Null
Add-PnPField -List $ListName -InternalName "Day" -DisplayName "Day" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "Year" -DisplayName "Year" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "StartOfWeek" -DisplayName "StartOfWeek" -Type DateTime -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "EndOfWeek" -DisplayName "EndOfWeek" -Type DateTime -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "ISOWeekNum" -DisplayName "ISOWeekNum" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "WkNumDay" -DisplayName "WkNumDay" -Type Text -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "WeekdayNum" -DisplayName "WeekdayNum" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "isHoliday" -DisplayName "isHoliday" -Type Boolean -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "HolidayName" -DisplayName "HolidayName" -Type Text -AddToDefaultView | Out-Null
Add-PnPField -List $ListName -InternalName "isWeekEnd" -DisplayName "isWeekEnd" -Type Boolean -AddToDefaultView | Out-Null

Disconnect-PnPOnline