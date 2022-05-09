select * from portfolio_project..nashvillehousing


--modify saledate format
alter table nashvillehousing
alter column saledate date

--populate property address column

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
,ISNULL(b.propertyaddress,a.PropertyAddress) from portfolio_project..nashvillehousing a
join portfolio_project..nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null

update b
set propertyaddress=ISNULL(b.propertyaddress,a.PropertyAddress)
 from portfolio_project..nashvillehousing a
join portfolio_project..nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null


select * from portfolio_project..nashvillehousing
where PropertyAddress is null

--breaking addresss into individual columns (address,city,state) method 1

select substring(propertyaddress,1,CHARINDEX(',',PROPERTYADDRESS)-1) AS Address, 
substring(propertyaddress,CHARINDEX(',',PROPERTYADDRESS)+1,LEN(PropertyAddress)) AS CITY
from portfolio_project..nashvillehousing

ALTER TABLE portfolio_project..nashvillehousing
ADD PROPERTY_ADDRESS VARCHAR(255)

UPDATE portfolio_project..nashvillehousing
SET PROPERTY_ADDRESS=substring(propertyaddress,1,CHARINDEX(',',PROPERTYADDRESS)-1)

ALTER TABLE portfolio_project..nashvillehousing
ADD PROPERTY_CITY VARCHAR(255)

UPDATE portfolio_project..nashvillehousing
SET PROPERTY_CITY=substring(propertyaddress,CHARINDEX(',',PROPERTYADDRESS)+1,LEN(PropertyAddress))

--breaking addresss into individual columns (address,city,state) method 2

select PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)

from portfolio_project..nashvillehousing

ALTER TABLE portfolio_project..nashvillehousing
ADD owner_ADDRESS_street VARCHAR(255)

UPDATE portfolio_project..nashvillehousing
SET  owner_ADDRESS_street=PARSENAME(replace(owneraddress,',','.'),3)

ALTER TABLE portfolio_project..nashvillehousing
ADD owner_ADDRESS_city VARCHAR(255)

UPDATE portfolio_project..nashvillehousing
SET  owner_ADDRESS_city=PARSENAME(replace(owneraddress,',','.'),2)

ALTER TABLE portfolio_project..nashvillehousing
ADD owner_ADDRESS_state VARCHAR(255)

UPDATE portfolio_project..nashvillehousing
SET  owner_ADDRESS_state=PARSENAME(replace(owneraddress,',','.'),1)

select * from portfolio_project..nashvillehousing


--change Y and N to yes and no in "sold as vacant" field
select soldasvacant 
 ,case when soldasvacant='y' then 'yes'
      when soldasvacant='n' then 'no'
	  else soldasvacant
	  end
from portfolio_project..nashvillehousing

UPDATE portfolio_project..nashvillehousing
SET  soldasvacant=case when soldasvacant='y' then 'yes'
      when soldasvacant='n' then 'no'
	  else soldasvacant
	  end

select distinct(soldasvacant) from portfolio_project..nashvillehousing

-- delete the duplicates 

with rownumcte as
(select *,ROW_NUMBER() over (partition by parcelid,landuse,propertyaddress,saledate,ownername
,legalreference order by uniqueid ) 
as rownum
from portfolio_project..nashvillehousing)

--delete from rownumcte where rownum>1(execute this )

select * from rownumcte where rownum>1

