/* Cleaning Data In SQL*/

EXEC sp_help 'dbo.Housing'

SELECT * FROM Data_Cleaning_project.dbo.Housing

--Standardize Date Format

SELECT SALEDATE, CONVERT( Date, SaleDate)
FROM Data_Cleaning_project.dbo.Housing

UPDATE Housing SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE HOUSING
ADD SaleDateConverted Date

UPDATE Housing SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------

-- Populating Property Address Data

SELECT *
FROM Data_Cleaning_project.dbo.Housing 
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
FROM Data_Cleaning_project.dbo.Housing A 
JOIN Data_Cleaning_project.dbo.Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

------- VIEWING 

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Data_Cleaning_project.dbo.Housing A 
JOIN Data_Cleaning_project.dbo.Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

-- UPDATING

UPDATE A 
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Data_Cleaning_project.dbo.Housing A 
JOIN Data_Cleaning_project.dbo.Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

-----------------------------------------------------------------

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM Data_Cleaning_project.dbo.Housing

-- TAKING OUT ADDRESS AND CITY FROM FULL ADDRESS

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS ADDRESS,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS CITY
FROM Data_Cleaning_project.dbo.Housing

-- ADDING ADDRESS AND CITY COLUMN IN DATA FROM PROPERTY ADDRESS

ALTER TABLE HOUSING
ADD Property_Address Nvarchar(250)

UPDATE Housing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE HOUSING
ADD Property_City Nvarchar(250)

UPDATE Housing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

---- CHECKING IF OUR COLUMN IS GETTING ADDED OR NOT
SELECT * FROM Data_Cleaning_project.dbo.Housing

------------------------------------------------------------------------------------------------

--ADDING OWNER ADDRESS AND CITY COLUMN IN DATA FROM PROPERTY ADDRESS
SELECT OwnerAddress
FROM Data_Cleaning_project.dbo.Housing

/*
SELECT OwnerAddress,
SUBSTRING(OwnerAddress, 1, CHARINDEX(',',OwnerAddress)-1) AS OWNER_ADDRESS,
SUBSTRING(OwnerAddress,CHARINDEX(',',OwnerAddress)+1, CHARINDEX(',',OwnerAddress)-4) AS OWNER_CITY,
SUBSTRING(OwnerAddress,CHARINDEX(',',OwnerAddress, CHARINDEX(',',OwnerAddress)+1)+1, LEN(OwnerAddress)) AS OWNER_CODE
FROM Data_Cleaning_project.dbo.Housing
*/

-- ANOTHER WAY (EASY WAY)

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
FROM Data_Cleaning_project.dbo.Housing

ALTER TABLE HOUSING
ADD Owner_Address Nvarchar(250)

UPDATE Housing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE HOUSING
ADD Owner_City Nvarchar(250)

UPDATE Housing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE HOUSING
ADD Owner_State Nvarchar(250)

UPDATE Housing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

SELECT *
FROM Data_Cleaning_project.dbo.Housing

---------------------------------------------------------------------------------------------------
-- CHANGE Y AND N TO YES AND NO IN SOLD AS VACANT FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Data_Cleaning_project.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM Data_Cleaning_project.dbo.Housing

UPDATE Housing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

------------------------------------------------------------------
-- REMOVE DUPLICATED

WITH RowNumCTE as(
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY ParcelID,
			LandUse,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
			ORDER BY UniqueID
			) row_num
FROM Data_Cleaning_project.dbo.Housing
)
/*
DELETE
FROM RowNumCTE
WHERE ROW_NUM > 1
*/
SELECT *
FROM RowNumCTE
WHERE ROW_NUM > 1
ORDER BY PropertyAddress

------------------------------------------------------------------------

-- DELETING UNUSED COLUMNS

SELECT *
FROM Data_Cleaning_project.dbo.Housing

ALTER TABLE HOUSING
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict,SaleDate

