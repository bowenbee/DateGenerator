# Date Generator Solution

## Overview
This PowerApps Canvas App solution allows users to generate a list of dates based on a specified date range, manage federal and custom holidays, determine actual dates for variable holidays, and export the data to CSV and SharePoint List. This allows the user to easily generate a present and future list of dates for future holidays to use in business date calcuates as a date table.

## Features
- **Date Range Input**: Input a start and end date to generate a list of all dates within the range.
- **Holiday Management**: Manage predefined federal holidays and custom holidays, including recurring rules.
- **Variable Holiday Calculation**: Determine the actual date for holidays that occur on variable dates (e.g., 3rd Monday of January).
- **Data Export**: Export the date range and holiday information to CSV and SharePoint.

## Project Scope

The goal of this project is to develop an application that allows users to generate a list of dates based on a specified date range, manage holidays (including federal and custom holidays), determine the actual dates for variable holidays, and export the data to CSV and SharePoint. This application will streamline the process of date and holiday management for users, providing a flexible and user-friendly solution.

## User Stories

1. Generate List of Dates
    · User Story: As a user, I want to input a start and end date into an app and generate a list of dates within that range.
    · Acceptance Criteria:
        The user can input a start date and an end date.
        The system generates a list of all dates within the specified range.
2. Manage Holidays
    · User Story: As a user, I need to be able to manage holidays, including federal holidays, and be able to add my own custom holidays.
        · Acceptance Criteria:
            · The user can view a list of predefined federal holidays.
            · The user can add new custom holidays with a specific date or recurring rule.
            · The user can edit or delete existing holidays.
3. Determine Actual Holiday Dates
    · User Story: As a user, I need the system to determine the actual date for variable holidays (e.g., a holiday that falls on the 3rd Monday of January) for a given year.
    · Acceptance Criteria:
        · The system calculates the correct date for holidays that follow a variable rule (e.g., "3rd Monday of January").
        · The user can view the calculated date for the current year and any specified year.
4. Export to CSV and SharePoint
    · User Story: As a user, I need the means to take the generated date range and export it to a CSV file and also write it to a SharePoint list.
    · Acceptance Criteria:
        · The user can export the list of dates to a CSV file.
        · The user can write the list of dates to a specified SharePoint list.

The system confirms the success of the export to both CSV and SharePoint.

### PowerPlatform Components

PowerApp Canvas
Power Automate

## Instructions for Initial Setup

1. Create your SharePoint Site.
2. Run the PowerShell Scripts "SP_Provision_DateGenList" and "SP_Provision_HolidayList". In the scripts, change $SharePointSite to the url of your SharePoint Site.
3. Import the solution using either Manual Import or PAC CLI. Note: if using PAC CLI, update the settings file used to point to the list guids created in the prior steps.
4. If importing manually, Update Environment Variable SharePoint Site and list value "Date Generator List" and  "Holiday List" to the newly created list.