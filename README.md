# Date Generator Solution

## Overview
This PowerApps Canvas App solution allows users to generate a list of dates based on a specified date range, manage federal and custom holidays, determine actual dates for variable holidays, and export the data to CSV and SharePoint List. This allows the user to easily generate a present and future list of dates for future holidays to use in business date calcuates as a date table.

## Features
- **Date Range Input**: Input a start and end date to generate a list of all dates within the range.
- **Holiday Management**: Manage predefined federal holidays and custom holidays, including recurring rules.
- **Variable Holiday Calculation**: Determine the actual date for holidays that occur on variable dates (e.g., 3rd Monday of January).
- **Data Export**: Export the date range and holiday information to CSV and SharePoint.

## Instructions for Initial Setup

1. Create your SharePoint Site.
2. Run the PowerShell Scripts "SP_Provision_DateGenList" and "SP_Provision_HolidayList". In the scripts, change $SharePointSite to the url of your SharePoint Site.
3. Import the solution using either Manual Import or PAC CLI. Note: if using PAC CLI, update the settings file used to point to the list guids created in the prior steps.
4. If importing manually, Update Environment Variable SharePoint Site and list value "Date Generator List" and  "Holiday List" to the newly created list.