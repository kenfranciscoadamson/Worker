SELECT * FROM (
SELECT DISTINCT TO_CHAR(PPAUF.PERSON_ADDR_USAGE_ID) "PersonAddrUsageId"
	, TO_CHAR(PPAUF.PERSON_ID) "PersonId"
	, TO_CHAR(PPAUF.EFFECTIVE_START_DATE, 'YYYY/MM/DD') "EffectiveStartDate"
	, nvl (CASE WHEN PPAUF.PERSON_ID IS NOT NULL
					THEN (SELECT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE PAPF.PERSON_ID = PPAUF.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') "PersonNumber"
	, PPAUF.ADDRESS_TYPE "AddressType"
	, nvl (PAF.ADDRESS_LINE_1, '') "AddressLine1"
	, TO_CHAR(PPAUF.ADDRESS_ID) "AddressId"
	, nvl (PAF.COUNTRY, '') "Country"
	-- for auditing
	, PPAUF.CREATED_BY "CreatedBy"
	, TO_CHAR(PPAUF.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PPAUF.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PPAUF.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	-- for integration
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- for filter parameters
	, nvl (CASE WHEN PPAUF.PERSON_ID IS NOT NULL
					THEN (SELECT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE PAPF.PERSON_ID = PPAUF.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') AS PERSON_NUMBER
	, PPAUF.ADDRESS_TYPE AS ADDRESS_TYPE
	, nvl (PAF.ADDRESS_LINE_1, '') AS ADDRESS_LINE_1
FROM PER_PERSON_ADDR_USAGES_F PPAUF
	LEFT JOIN PER_ADDRESSES_F PAF
		ON PAF.ADDRESS_ID = PPAUF.ADDRESS_ID
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND SYSDATE BETWEEN PPAUF.EFFECTIVE_START_DATE AND PPAUF.EFFECTIVE_END_DATE
	AND PPAUF.PERSON_ADDR_USAGE_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'PersonAddressUsage'
)
WHERE 1 = 1
	AND PERSON_NUMBER = NVL(:PersonNumber, PERSON_NUMBER)
	AND ADDRESS_TYPE = NVL(:AddressType, ADDRESS_TYPE)
	AND ADDRESS_LINE_1 = NVL(:AddressLine1, ADDRESS_LINE_1)

/*
The postal address of a person, which includes country dependent elements. For example, a UK address comprises Address Line 1 - 3, City or Town, County, Post Code, and Country, while a US address comprises Address Line 1 - 3, City, State, ZIP Code, and County.

Required:
	• Person ID - A unique reference to the person to whom this address belongs. (User Key: PersonNumber)
	• Person Address Usage ID - The surrogate ID for the address usage record. Only available when updating existing addresses. (User Keys: PersonNumber, AddressType, AddressLine1)

For new records:
	• Address ID - The surrogate ID for the address record.
	• Country - The country of the address.
	• Address Type - The address type.

User Keys:
	• Person Number - A number to uniquely identify the person. If you have configured person numbers to be automatically generated, this leave blank.
	• Address Type
	• Address Line 1 - The first line of the address.
	
List of values for Address Type:
SQL:
SELECT DISTINCT ADDRESS_TYPE
FROM PER_PERSON_ADDR_USAGES_F
WHERE 1 = 1
	AND SYSDATE BETWEEN PPAUF.EFFECTIVE_START_DATE AND PPAUF.EFFECTIVE_END_DATE
List of Values:
HOME
MAIL
*/

/*
Sample code from current project:

SELECT DISTINCT TO_CHAR(PPAUF.PERSON_ADDR_USAGE_ID) "PersonAddrUsageId"
	, PPAUF.ADDRESS_TYPE "AddressType"
	, PAF.ADDRESS_LINE_1 "AddressLine1"
	, TO_CHAR(PPAUF.EFFECTIVE_START_DATE, 'YYYY/MM/DD') "EffectiveStartDate"
	, TO_CHAR(PPAUF.EFFECTIVE_END_DATE, 'YYYY/MM/DD') "EffectiveEndDate"
	, PAF.ADDRESS_LINE_2 "AddressLine2"
	, PAF.ADDRESS_LINE_3 "AddressLine3"
	, PAF.ADDRESS_LINE_4 "AddressLine4"
	, PAF.COUNTRY "Country"
	, PAF.TOWN_OR_CITY "TownOrCity"
	, PAF.POSTAL_CODE "PostalCode"
	, CASE WHEN PAPF.MAILING_ADDRESS_ID = PPAUF.ADDRESS_ID
            THEN 'Y'
            ELSE 'N'
        END "PrimaryFlag"
	, PAF.REGION_2 "Region2"
	--, PPAUF.PERSON_ID "PersonId"
	, TO_CHAR(PPAUF.PERSON_ID) "PersonId"
	, PAPF.PERSON_NUMBER "PersonNumber"
	-- PPAUF.ADDRESS_ID "AddressId"
	, TO_CHAR(PPAUF.ADDRESS_ID) "AddressId"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, PPAUF.CREATED_BY "CreatedBy"
	, TO_CHAR(PPAUF.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PPAUF.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PPAUF.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	, PPAUF.LAST_UPDATE_LOGIN "LastUpdateLogin"
	--
	, PAF.LONG_POSTAL_CODE "LongPostalCode"
	, PAF.REGION_1 "Region1"
	, PAF.REGION_3 "Region3"
	, PAF.ADDL_ADDRESS_ATTRIBUTE1 "AddlAddressAttribute1"
	, PAF.ADDL_ADDRESS_ATTRIBUTE2 "AddlAddressAttribute2"
	, PAF.ADDL_ADDRESS_ATTRIBUTE3 "AddlAddressAttribute3"
	, PAF.ADDL_ADDRESS_ATTRIBUTE4 "AddlAddressAttribute4"
	, PAF.ADDL_ADDRESS_ATTRIBUTE5 "AddlAddressAttribute5"
	, HIKM.GUID "Guid"
FROM PER_ALL_PEOPLE_F PAPF
	, PER_PERSON_ADDR_USAGES_F PPAUF
	, PER_ADDRESSES_F PAF
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PAPF.PERSON_ID = PPAUF.PERSON_ID
	AND PPAUF.ADDRESS_ID = PAF.ADDRESS_ID
	AND PPAUF.PERSON_ADDR_USAGE_ID = HIKM.SURROGATE_ID
	--AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
	AND HIKM.OBJECT_NAME = 'PersonAddressUsage'
	
/*
Relevant attributes from Data Dictionary:
AddressType
AddressLine1
EffectiveStartDate
EffectiveEndDate
AddressLine2
AddressLine3
AddressLine4
Country
TownOrCity
PostalCode
PrimaryFlag
Region2
PersonId
PersonNumber
AddressId
SourceSystemOwner
SourceSystemId
*/