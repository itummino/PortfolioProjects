--Nashville Housing Project -- Data Cleaning

SELECT * FROM PortfolioProject..NashvilleHousing

------- Standardize sale date format to remove the time --------------

SELECT SaleDate, CONVERT(DATE, SaleDate) FROM PortfolioProject..NashvilleHousing
--didn't update SaleDate for some reason

ALTER TABLE PortfolioProject..NashvilleHousing
ALTER COLUMN SaleDate DATE

SELECT SaleDate FROM PortfolioProject..NashvilleHousing
-- successful, SaleDate is now just date format


------- Populate Property Address data, exclude NULL PropertyAddresses --------------

SELECT * FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL

--self JOIN
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL

--now to update this
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL

SELECT * FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL
--there are no NULL values now


--------- Separating out the PropertyAddress into street and city --------------

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as StreetAddress 
FROM PortfolioProject..NashvilleHousing
-- now street address shows

SELECT SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM PortfolioProject..NashvilleHousing
-- now city shows

--need to make these into actual columns
ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyStreet Nvarchar(255)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyCity Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT PropertyStreet, PropertyCity FROM PortfolioProject..NashvilleHousing
-- now these two columns exist and break out the street address and city


-------- Separating out the OwnerAddress into street, city and state --------------

--using an easier method to break it up
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
FROM PortfolioProject..NashvilleHousing
--this gives us the last part of the string (state) ex:(TN)

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject..NashvilleHousing
--this separates street address, city, state

--creating columns
ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerStreet Nvarchar(255) 

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerCity Nvarchar(255) 

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerState Nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT OwnerStreet, OwnerCity, OwnerState FROM PortfolioProject..NashvilleHousing
--successfully separates into 3 diff columns: street, city, state


----------- "SoldAsVacant" column --------------

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
-- this column shows N, Yes, Y, and No which is inconsistent data...need to change this
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
-- shows there are 51403 No's, 4623 Yes's, 399 N's and 52 Y's
-- so lets change the N's and Y's into Yes and No since these are more popular
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing
--set the column to reflect this
UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
SELECT * FROM PortfolioProject..NashvilleHousing
-- successful, no more Y's and N's


----------- Removing Duplicates ----------------------

---using a CTE table
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
		ORDER BY UniqueID ) row_num 
		FROM PortfolioProject..NashvilleHousing ) 
		SELECT * FROM RowNumCTE
		WHERE row_num > 1
		ORDER BY PropertyAddress
-- this shows all the duplicate rows of data (denoted by row_num = 2) *(all row_nums>1 are duplicate)*
-- need to delete all the duplicate rows

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
		ORDER BY UniqueID ) row_num 
		FROM PortfolioProject..NashvilleHousing ) 
		DELETE FROM RowNumCTE
		WHERE row_num > 1
-- now if we retype the first CTE code, there are no rows > 1, hence no duplicates


-------------- Remove unnecessary columns (OwnerAddress, PropertyAddress, TaxDistrict) ----------

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict
