/*
Data Cleaning Using SQL
*/
SELECT *
FROM Nashville_Housing;
------------------------------------------------------------------------------

--Standardize Date Format (SaleDate)
--Was Previously in a DateTime format

ALTER TABLE Nashville_Housing
ADD SaleDateConverted Date

UPDATE Nashville_Housing
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM Nashville_housing;

--------------------------------------------------------------------------------

--Populate PropertyAddress Data Using SELF-JOIN

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
     a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------

--Breaking Out Adress Into Individual Columns (Address, City, State)

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

----------------------------------------------------------------------------------------------

--Breaking Out Owner Address to Individual Columns

SELECT OwnerAddress
FROM Nashville_Housing;

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

--------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "SoldAsVacant"

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



UPDATE nashville_Housing
SET SoldAsVacant = CASE
	                  when SoldAsVacant = 'Y' then 'Yes'
		          when SoldAsVacant = 'N' then 'No'
		          else SoldAsVacant
		          end;

----------------------------------------------------------------------------------------------------------
-- Remove Duplicates
WITH RowNumCTE AS (
select *,
   ROW_NUMBER() over (
                      PARTITION BY ParcelID,
                                   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
                          ORDER BY
				   UniqueID
				  ) AS row_num
from Nashville_Housing
)
--DELETE
select *
from RowNumCTE
where row_num > 1
ORDER BY PropertyAddress;

-------------------------------------------------------------------------------------------------------------

-- Deleting Unused Columns

select *
from Nashville_Housing


ALTER TABLE Nashville_Housing
DROP COLUMN OwnerAddress,
            PropertyAddress,
			TaxDistrict,
			SaleDate;
