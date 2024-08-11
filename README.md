# Data_Cleaning-In-SQL
---

## OVerview

Using SQL to clean a Nashville_Housing dataset containing **56,477** rows of data, and it was done using the Microsoft Server SQL (MSSQL).

## Data Source

  The dataset used is 'NashvilleHousing.xslx' [Check_here](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)

## Tools Used

 - **MS SQL**

## Data Cleaning/Preparation
   - _'MS server Import and Export Data'_ tool was used to import/load the data into MS SQL Server since there seemed to be some difficulties doing that using the actual MS SQL Server itself for some unknown reasons.

   The following were carried out to make for proper cleaning of the data;

   - Standardize Date Format (SaleDate) which was Previously in a 'DateTime format' to 'Date'
```SQL
SELECT
      SaleDateConverted, CONVERT(Date, SaleDate)
FROM
      Nashville_housing;

ALTER TABLE Nashville_Housing
ADD SaleDateConverted Date

UPDATE Nashville_Housing
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT
      SaleDateConverted
FROM
    Nashville_housing;
```
  #### Its Outcome
  
  
  
    
