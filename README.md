# Nashville-Housing-Data-Cleaning-Using-SQL
This GitHub repository contains the SQL Data File and resources of project Nashville-Housing Data Cleaning.

## Table Of Contents

- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Utilized SQL Queries](#utilized-sql-queries)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [References](#references)

### Project Overview
This project aims to leverage the capabilities of SQL for data cleaning tasks.

---
```
-- Standardize Date Format

SELECT SALEDATE, CONVERT( Date, SaleDate)
FROM Data_Cleaning_project.dbo.Housing
```
```
-- Populating Property Address Data
UPDATE A 
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Data_Cleaning_project.dbo.Housing A 
JOIN Data_Cleaning_project.dbo.Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL
```
---

### Data Source
The primary dataset used for analysis is the "Nashville-Housing-Data.xlsx" file.
- [Download Here](https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data)

### Utilized SQL Queries
The following SQL queries were employed for various data operations:

- SELECT: Utilized for data retrieval and viewing
- DELETE: Employed for eliminating redundant or erroneous data entries
- Common Table Expressions (CTEs): Utilized for constructing temporary result sets, aiding in complex data manipulations
- CONVERT: Applied for altering the data type of specific columns
- PARSENAME: Used for parsing relevant information from columns
- JOINS: Employed for combining data from multiple tables.
- SUBSTRING: Utilized for extracting substrings from column values.
- CASE: Employed for conditional logic operations.
- ALTER: Utilized for modifying table structures
- UPDATE: Employed to make alterations to existing table records

### Data Cleaning/Preparation
During the initial data preparation phase, the following tasks were executed:

- Adjusted column data types using CONVERT Query
- Populated Property Address Data
- Broke out address into individual columns (Address, City, State)
- Changed 'Y' and 'N' values to 'YES' and 'NO' in the 'Sold as vacant' field
- Removed duplicates
- DDeleted unused columns

### References

- [SQL Server Documentations](https://learn.microsoft.com/en-us/sql/tools/overview-sql-tools?view=sql-server-ver16)
