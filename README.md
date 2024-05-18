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
2. Import the Data Management Solution using PAC CLI.
3. Run the Power Automate "Provision Holiday and Date Generator Lists". This will provision the Holidays List and populate it with the Federal Holidays. Additionally, the Data Generator List will be created.
4. Update Environment Variable list value "Date Generator List" to the newly created "DateGenerator" List.
5. Update Environment Variable list value "Holiday List" to the newly created "Holiday" List.
