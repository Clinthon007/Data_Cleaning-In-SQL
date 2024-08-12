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

**1. Standardize Date Format (SaleDate) which was Previously in a 'DateTime format' to 'Date'**    
  
**Uncleaned _"SaleDate"_ format**

![Prev_SaleDate](https://github.com/user-attachments/assets/cc8a19ab-f273-4e68-9449-dbfdf5b6c1e2)


```SQL
ALTER TABLE Nashville_Housing
ADD SaleDateConverted Date

UPDATE Nashville_Housing
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT
      SaleDateConverted
FROM
    Nashville_housing;
```
**Cleaned SaleDate** 

  ![Sale_Date](https://github.com/user-attachments/assets/994c5408-506b-4bcf-853b-a1e04b08a4f7)

---

**2. Populate PropertyAddress Data Using SELF-JOIN**

The _"PropertyAddress"_ contained null values which were filled using the SELF-JOIN function as well as the UPDATE function to set any null cell with what the other table contained. 

**Uncleaned _"PropertyAddress"_ format**

![Prev_Null_PropertyAddress](https://github.com/user-attachments/assets/41e69e31-a790-4db7-8828-5b3a7d30fda7)

```SQL
SELECT *
FROM 
    nashville_housing
WHERE 
     PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
      a.ParcelID, 
	  a.PropertyAddress, 
	  b.ParcelID, 
	  b.PropertyAddress, 
	  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
    nashville_housing a
JOIN nashville_housing b
    ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE 
     a.PropertyAddress IS NULL


UPDATE a
SET 
    PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
    nashville_housing a
JOIN nashville_housing b
    ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE 
     a.PropertyAddress IS NULL;
```
---

**3. Breaking Out Adress Into Individual Columns (Address, City, State)**

The _"PropertyAddress"_ contained three(3) columns in one, and was split into these columns individually (Address, City, and State) with the use of the **SUBSTRING ()** together with the **UPDATE** in order to modify the table with the new columns.

**Uncleaned _PropertyAddress_ format**

![Prev_PropertyAddress](https://github.com/user-attachments/assets/524645f4-5f47-45d0-aa1f-66eeba2bc0ad)



```SQL
SELECT
      SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
	 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
FROM Nashville_Housing


ALTER TABLE Nashville_Housing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE Nashville_Housing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashville_Housing
ADD PropertySplitCity NVARCHAR(255)

UPDATE Nashville_Housing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT *
FROM Nashville_Housing;
```

**Cleaned_PropertyAddress**

![Cleaned_PropertyAddress](https://github.com/user-attachments/assets/4dfbb427-07b9-4429-af53-776195849da2)

---

**4. Breaking Out _OwnerAddress_ to Individual Columns**

The _"Ownerddress"_ contained three(3) columns in one, and was split into these columns individually (Address, City, and State) with the use of the **PARSENAME ()** together with the **ALTER** function and **UPDATE** to modify the table with the new columns.

**Uncleaned _OwnerAddress_**

![Prev_OwnerAddress](https://github.com/user-attachments/assets/a06cc199-0d6f-42ba-ab24-81016de97782)



```SQL
SELECT 
      OwnerAddress
FROM 
    Nashville_Housing;

SELECT
      PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) Address,
	    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) City,
	    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) State
FROM Nashville_Housing;


ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE Nashville_Housing
SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville_Housing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE Nashville_Housing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_Housing
ADD OwnerSplitState NVARCHAR(255)

UPDATE Nashville_Housing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select *
FROM Nashville_Housing;
```
**Cleaned OwnerAddress**

![Cleaned_OwnerAddress](https://github.com/user-attachments/assets/47bd56c9-7bba-4eac-89d7-0fd9a833889d)

---

**5. Changing Y and N to Yes and No in "SoldAsVacant"**

The _SoldAsVacant_ column contained in some cells either Y or N or No or Yes, but that didn't sit well with me, so I had to clean it by replacing cells containing either values with 'Yes' for (Y) and 'No' for (N) with the use of the **CASE statement** and **UPDATE** to modify the table with the new values.

**Uncleaned SoldAsVacant**

![Prev_SoldAsVacant](https://github.com/user-attachments/assets/52144c53-d622-4b38-98de-146179ff1c18)

```SQL
SELECT 
       Distinct(SoldAsVacant), 
       COUNT(SoldAsVacant)
FROM nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2;


select
      SoldAsVacant,
	  CASE
	      when SoldAsVacant = 'Y' then 'Yes'
		  when SoldAsVacant = 'N' then 'No'
		  else SoldAsVacant
		  end
FROM Nashville_Housing; 



UPDATE Nashville_Housing
SET SoldAsVacant = CASE
	                  when SoldAsVacant = 'Y' then 'Yes'
		              when SoldAsVacant = 'N' then 'No'
		              else SoldAsVacant
		           end;
```

**Cleaned SoldAsVacant**

![Cleaned_SoldAsVacant](https://github.com/user-attachments/assets/a5495162-7553-42fc-8ae7-878e38c02723)

---

**6. Removing Duplicates**

Columns with duplicated values were sorted and removed using the **WINDOWS function ( OVER() )** together with the **ROW_NUMBER** function and finally the **DELETE** function to remove all duplicates. these functions were all embedded in the CTE.
 As seen below, there were over 100 number of duplicated values which were removed totally.

- **Uncleaned Duplicates**

 ![Duplicates](https://github.com/user-attachments/assets/32286ad5-4d1e-48d1-8a9d-5d66db94e6de)

```SQL
WITH RowNumCTE AS (
select *,
   ROW_NUMBER() over (
                    PARTITION BY
                                ParcelID,
                                PropertyAddress,
				                        SalePrice,
				                        SaleDate,
				                        LegalReference
                   ORDER BY
				                    UniqueID
                   ) AS row_num
FROM
    Nashville_Housing
)
--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--order by PropertyAddress;
```
---

**7. Deleting Unused Columns**

Columns that were previously split into individual columns (**PropertyAddress**, **OwnerAddress**, and **SaleDate**) were removed, as well as columns that seemed not really important to our Data Analysis process later on, like the **TaxDistrict** which showed places where people go in to pay their stipulated taxes. These were carried out with the use of the **ALTER** and **DROP** clauses.

**Uncleande Columns**

![Uncleaned_Columns](https://github.com/user-attachments/assets/8a26e297-293a-4dce-b203-e0a58ea5d6ca)

```SQL
SELECT *
FROM
    Nashville_Housing


ALTER TABLE
            Nashville_Housing
DROP COLUMN
            OwnerAddress,
            PropertyAddress,
			      TaxDistrict,
			      SaleDate;


			SELECT *
			FROM Nashville_Housing;
```

**Cleaned Columns**

![Cleaned_Columns](https://github.com/user-attachments/assets/9d9dc16d-41a6-4c01-afa2-4d97d2ecfd9e)

