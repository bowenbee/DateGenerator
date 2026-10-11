# Date Generator

---

## 📘 Overview

This Power Platform solution builds a **date table** in SharePoint: every day in a chosen range, enriched with week numbers, weekend flags and holidays. You can use it for business-day calculations in other apps and reports.

A **Canvas App** lets you pick a date range and manage the holiday rules. That includes fixed federal holidays and variable ones such as "3rd Monday of January", whose actual date the app works out for each year. Holidays that fall on a weekend are flagged on the day they're **observed**, following the federal rules, so the table is ready for business-day math.

The generated dates appear in a navigable **calendar** with day details, or as a list. From there, the app writes them to a **SharePoint** list or exports them to CSV through **Power Automate**.

Everything uses standard connectors, so no premium license is needed.

---

## Compatibility

<!-- BADGES -->

![Premium License](https://img.shields.io/badge/Premium%20License-Not%20Required-green.svg "Premium Power Apps license not required (standard connectors only)")
![On-Premises Connectors](https://img.shields.io/badge/On--Premises%20Connectors-No-green.svg "Does not use on-premise connectors")
![Custom Connectors](https://img.shields.io/badge/Custom%20Connectors-No-green.svg "Does not use custom connectors")
![Data Gateway](https://img.shields.io/badge/Data%20Gateway-No-green.svg "No on-premises data gateway required")

![App Type Canvas](https://img.shields.io/static/v1?label=App%20Type&message=Canvas%20App&color=742774 "This solution uses Canvas Apps")
![Power Automate](https://img.shields.io/static/v1?label=Automation&message=Power%20Automate&color=0066FF "This solution uses Power Automate")

![DataSource SharePoint](https://img.shields.io/static/v1?label=Data%20Source&message=SharePoint&color=0078D4 "Holidays and Date Generator lists")
![DataSource Excel](https://img.shields.io/static/v1?label=Data%20Source&message=Excel&color=217346 "Holidays.xlsx seeds the Holidays list")


## 🧩 Solution Components

### Power Apps

* **Date Generator App** (tablet canvas app, responsive down to phone width):
  * **Date Configuration** screen:
    * Pick the start of week and the start and end dates, then generate.
    * The Holidays list on the same screen opens holidays for editing or deletes custom ones.
    * On phones the two panels stack vertically.
  * **Date Generation** screen: shows the generated dates, with a **Calendar / List** toggle.
    * **Calendar** (default):
      * A Sunday-to-Saturday month grid with previous and next arrows and a **Jump to** month picker, limited to the generated range.
      * Each day cell shows today, weekends, out-of-range days and holidays.
      * Clicking a day shows its details: weekday, ISO week, WkNumDay, quarter, fiscal year, holiday, and observed date.
      * The panel also lists the month's holidays.
    * **List**: every generated date with its holiday name.
    * **Show Holidays Only** filters the list and fades non-holiday days in the calendar.
    * Toolbar actions: **Save** to the **DateGenerator** list and **Export** to CSV.
  * **Holiday Edit** screen: add or edit a holiday rule (fixed date, Nth weekday, or last weekday of the month).
* **Styling:**
  * Uses the **Steel** modern theme.
  * All colors come from one named formula record, **`nf_ThemeColors`**, and the accents follow `App.Theme`, so changing the theme recolors the app.
  * Named formulas use the `nf_` prefix, user-defined functions `fn_`, and controls follow `type_Screen_Purpose` (for example `gal_DateGen_Days`, `btn_Config_GenerateDates`).

### Automation

* **Export Dates to CSV** (called from the app):
  * takes the generated dates as JSON and builds a CSV
  * saves it to OneDrive as `/Date Generation/DateGenerator-<date>-<time>.csv`
  * returns a download link to the app
  * deletes the file **one minute later**, so the link is only valid briefly
* **Provision Holiday and Date Generator Lists** (manual, run once per environment):
  * creates the **Holidays** list on the Sandbox Site and fills it from the table in **Holidays.xlsx**
  * creates the empty **DateGenerator** list with all its columns
  * **deletes either list first if it already exists** (see Known Limitations)

### Data Sources

* **SharePoint**, on the site set by the **Sandbox Site** environment variable:
  * **Holidays**: holiday rules. Columns: Title, MonthNum, Day, WeekNum, DayofWeekNum, FixedHoliday, HolidayType, Notes.
  * **DateGenerator**: the generated date table. Columns: Title, Date, Year, MonthNum, Day, Quarter, FiscalYear, StartOfWeek, EndOfWeek, ISOWeekofYear, WkNumDay, WeekdayNum, isHoliday, HolidayName, isWeekEnd.
    * **isHoliday** is true on the day the holiday is **observed** (the day off).
    * **HolidayName** carries "(observed)" when that day differs from the actual date.
    * **FiscalYear** follows the US government fiscal year, which starts October 1.
* **Excel**: **Holidays.xlsx** seeds the Holidays list. It contains the 11 US federal holidays plus Inauguration Day; a CSV copy is in [`data/`](data/).
* **OneDrive for Business**: temporary storage for CSV exports

---

## 📅 How Holidays Are Calculated

Each row in the **Holidays** list is a rule. When you click **Generate Dates**, the app turns the rules into actual dates for every year in the range, **plus the following year**. The extra year means a New Year's Day that falls on a Saturday is observed on December 31 of the last year in the range.

| Rule (Holidays row) | Example | Calculation |
|---|---|---|
| `FixedHoliday` = Yes: MonthNum + Day | Independence Day: 7 / 4 | `Date(Year, MonthNum, Day)` |
| Nth weekday: WeekNum 1–4 + DayofWeekNum | MLK Day: 3rd Monday (3, 2) in January | `fn_DateForGivenWeekNumAndDay` = `Date(y,m,1) + 7·N − Weekday(Date(y,m,8−dow))` |
| Last weekday: WeekNum **0** (not fixed) + DayofWeekNum | Memorial Day: last Monday (0, 2) in May | `fn_GetLastWeekdayOfMonth` = end of month − days back to that weekday |

`DayofWeekNum` counts from Sunday = 1, so Monday = 2 and Thursday = 5.

**Observed dates:** this follows [5 U.S.C. 6103](https://www.law.cornell.edu/uscode/text/5/6103) and OPM's federal holiday policy, implemented in `fn_ObservedDate`.
* A holiday on a **Saturday** is observed on the **Friday before**.
* A holiday on a **Sunday** is observed on the **Monday after**.
* **Inauguration Day** (January 20) applies only every fourth year after 1965 (`fn_IsInaugurationYear`), and only to federal employees in the Washington, DC area. If it falls on a Sunday it moves to Monday, but if it falls on a **Saturday there is no day off**.
* If two holidays share a date, they're combined into one row, for example "Birthday of Martin Luther King, Jr., Inauguration Day" on January 20, 2025.

**What the date table records:**

| Date | isHoliday | HolidayName | ObservedHoliday |
|---|---|---|---|
| Fri 7/3/2026 | true | Independence Day (observed) | |
| Sat 7/4/2026 | false (already a weekend) | Independence Day | 7/3/2026 |
| Sat 1/20/2029 | false | Inauguration Day | Not observed |

The logic was checked against the federal rules for 2024–2032: the app flags exactly the 100 official days off in that period.

---

## 🎯 User Stories

1. **Generate a list of dates:** enter a start and end date, and get every date in that range.
2. **Manage holidays:** see the predefined federal holidays, add custom ones with a fixed date or a recurring rule, and edit or delete existing ones.
3. **Work out variable holiday dates:** for any year, calculate the actual date of rule-based holidays such as "3rd Monday of January".
4. **Export to CSV and SharePoint:** export the generated dates to a CSV file, write them to the SharePoint list, and get confirmation that both succeeded.

---

## 🔐 Licensing & Connectivity

* ✅ No premium Power Apps license required (SharePoint, OneDrive, Excel and Power Automate are standard connectors)
* ✅ No on-premises data gateway needed
* ✅ No on-premises connectors used
* ✅ No custom connectors used

The solution runs on Microsoft 365 services alone, so it's easy to deploy with minimal admin effort.

---

## 🚀 Deployment

1. **Create the SharePoint lists.** Use one of these two options:
   * **PowerShell:** run [`SP_Provision_HolidayList.ps1`](sharepoint-provision/SP_Provision_HolidayList.ps1) and [`SP_Provision_DateGenList.ps1`](sharepoint-provision/SP_Provision_DateGenList.ps1).
     * They need PnP.PowerShell and sign in interactively. Change `$SharePointSite` at the top of each script to your site first.
     * The Holidays script creates the **Holidays** list with every column the app uses, including FixedHoliday, and imports all rows from [`data/Holidays.csv`](data/Holidays.csv).
     * The DateGenerator script creates the empty **DateGenerator** list with the same columns the flow creates.
     * `SP_CopyHolidaysListData.ps1` is an empty placeholder for now.
   * **Flow:** after importing (step 2), upload **Holidays.xlsx** to the site, point the flow's **List Holidays** action at it, and run **Provision Holiday and Date Generator Lists**.

   Both options create the same lists and columns.
2. **Import the Date Generator solution.** Use managed for downstream environments. You can import manually, or with `pac solution import --settings-file`.
   * Settings files hold per-environment values, so they're **kept out of git**: `deployment/*settings*.json` is in `.gitignore`.
   * Generate one with `pac solution create-settings --solution-zip deployment/DateGenerator_managed.zip --settings-file deployment/DateGenerator_settings_<Env>.json`.
   * Fill in the list GUIDs from step 1 and your connection IDs.
3. **Set the environment variables** if you didn't use a settings file:

   | Variable | Schema name | Purpose |
   |---|---|---|
   | Sandbox Site | `bb89_SandboxSite` | SharePoint site that holds both lists. Its default is the dev Sandbox site, so override it. |
   | Holidays List | `bb89_HolidaysList` | The **Holidays** list on that site (no default) |
   | Date Generator List | `bb89_DateGeneratorList` | The **DateGenerator** list on that site (no default) |

4. **Create or map the connection references:**

   | Connection reference | Connector |
   |---|---|
   | `bb89_DateGenSharePoint` | SharePoint |
   | `bb89_sharedonedriveforbusiness_38459` | OneDrive for Business |
   | `bb89_sharedexcelonlinebusiness_216f7` | Excel Online (Business) |

5. **Turn on both flows, then share the app.** Users need edit access to both SharePoint lists.

---

## 🛠️ Configuration Notes

* Set **Sandbox Site** first: both list variables are picked from that site.
* **Save** replaces the DateGenerator list's contents safely:
  * It writes the new dates **first**. If that fails, you see the error and the existing rows are kept.
  * Only after a successful write does it remove the previous rows, identified by their **Created** time. It removes them in batches of 2,000, because SharePoint's `RemoveIf` is limited to that many rows per call.
  * A notification confirms the result. If any old rows remain, it asks you to Save again.
* **Export Dates to CSV** creates an **anonymous, editable share link** so the app can download the file. Your tenant's sharing settings must allow "Anyone" links, or the export fails.
* The exported CSV is deleted from OneDrive after one minute. If you want to keep exports, increase or remove the **Delay** and **Delete file** steps.
* The Holidays rows use the numbering in **How Holidays Are Calculated**. For a variable holiday, `WeekNum` 0 means "last weekday of the month".
* **Start of Week** controls the generated data (WeekdayNum, StartOfWeek, EndOfWeek). The calendar always displays Sunday to Saturday.
* Inauguration Day is identified by its **Title** ("Inauguration Day"), so keep that exact name in the Holidays list.

---

## 🧪 Testing

<!-- TODO: add testing notes -->

---

## 📌 Known Limitations

* **Provision Holiday and Date Generator Lists deletes and recreates both lists.**
  * Any existing dates or custom holidays are lost.
  * The new lists get **new IDs**, so the Holidays List and Date Generator List environment variables must be updated after every run.
* That flow reads Holidays.xlsx using a **hard-coded drive ID and file ID** from the dev site. In a new environment, re-select the file in the designer before running it.
* Both provisioning options (the flow and the PowerShell scripts) **delete an existing list with the same name** before recreating it.
* The export file name uses a 12-hour clock (`hhmmss`) with no AM/PM, so two exports 12 hours apart could produce the same name.
* The solution includes the dev values of the environment variables. Override them during import, or with a settings file, so nothing points at the dev site.

---

## 📄 Related Documentation

* [`sharepoint-provision/`](sharepoint-provision/): PnP PowerShell scripts that create the lists
* [`deployment/`](deployment/): managed and unmanaged solution zips. Local `pac` settings files also go here, but aren't committed.
* [`data/`](data/): the federal holiday seed data (`Holidays.xlsx` and `Holidays.csv`)
* [`pac solution` reference](https://learn.microsoft.com/power-platform/developer/cli/reference/solution): `pac solution import` and the `--settings-file` option

---

## 👤 Maintainer

**Brendan Bowen**
Power Platform | Power Apps | Power Automate

---

## 📝 License

This project is provided as-is for internal or educational use.
