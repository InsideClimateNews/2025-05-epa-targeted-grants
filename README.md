# Analysis of programs and grants targeted for termination by US Environmental Protection Agency

Data, methodology and [R](https://www.r-project.org/) code for the analysis underlying [this Inside Climate News article]().

Code for the analysis is in the script `epa_grants.R`, which processes the CSV file in the `data` folder, downloaded for a search at the [USAspending](https://www.usaspending.gov/) database for all grants under programs listed as "slated to be terminated" in [this April 23, 2025 court filing](https://www.documentcloud.org/documents/25919517-epa-court-filing-april-23-2025/) from the Environmental Protection Agency.

The script filters the data for grants for those that had not passed their end date by Feb. 13, when EPA administrator Lee Zeldin began targeting the programs for termination, and joins to [data](https://clerk.house.gov/Members/ExcelMemberData) downloaded from the Clerk of the U.S. House of Representatives to facilitate analyses by congressional district, member and their parties.

The script summarizes the data by program, congressional district of the main place of performance, congressional district of the recipient organization, parties of the member by both preceding criteria and state of the main place of performance, calculating the number of grants, the total funds obligated (`amount_awarded`), how much had already been sent to recipients by the time of the search (`total_outlays`) and the amount remaining to be paid out (`not_disbursed`).

The output from the script is saved in the `processed_data` folder in a series of CSV files, which are also combined in the spreadsheet `epa-grants-targeted-programs.xlsx`.

### Questions/Feedback

Email Peter Aldhous at peter.aldhous\@insideclimatenews.org.
