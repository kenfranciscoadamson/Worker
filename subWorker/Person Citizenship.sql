SELECT * FROM(
SELECT DISTINCT TO_CHAR(PC.CITIZENSHIP_ID) "CitizenshipId"
	, TO_CHAR(PC.PERSON_ID) "PersonId"
	, PC.CITIZENSHIP_STATUS "CitizenshipStatus"
	, PC.LEGISLATION_CODE "LegislationCode"
	, nvl (CASE WHEN PC.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE 1 = 1
								AND PAPF.PERSON_ID = PC.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
								)
					ELSE NULL
				END, '') "PersonNumber"
	-- for auditing
	, PC.CREATED_BY "CreatedBy"
	, TO_CHAR(PC.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PC.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PC.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	-- for integration
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- for filter parameters
	, nvl (CASE WHEN PC.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE 1 = 1
								AND PAPF.PERSON_ID = PC.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
								)
					ELSE NULL
				END, '') AS PERSON_NUMBER
	, PC.LEGISLATION_CODE AS LEGISLATION_CODE
FROM PER_CITIZENSHIPS PC
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PC.CITIZENSHIP_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'Citizenship'
)
WHERE 1 = 1
	AND PERSON_NUMBER = NVL(:PersonNumber, PERSON_NUMBER)
	AND LEGISLATION_CODE = NVL(:LegislationCode, LEGISLATION_CODE)

/*
The state or nation to which the person belongs, is a native of, or a naturalized member.

Required:
	• Citizenship ID (Surrogate ID) - The surrogate ID for the citizenship record. Only available when updating existing citizenships. (User Keys: PersonNumber, LegislationCode)
	• Person ID (Parent Surrogate ID) - A unique reference to the person to whom this address belongs. (User Key: PersonNumber)

Required for new records:
	• Citizenship Status - The status of the citizenship.
	• Legislation Code - The citizenship legislation code.

User Keys:
	• Person Number - A number to uniquely identify the person. If you have configured person numbers to be automatically generated, this leave blank.
	• Legislation Code
*/

/*
List of values SQL code for Legislation Code:

SELECT DISTINCT LEGISLATION_CODE FROM PER_CITIZENSHIPS
*/

/*
SELECT DISTINCT TO_CHAR(PC.CITIZENSHIP_ID) "CitizenshipId"
	, PC.LEGISLATION_CODE "LegislationCode"
	, PC.CITIZENSHIP_STATUS "CitizenshipStatus"
	, TO_CHAR(PC.DATE_FROM, 'YYYY/MM/DD') "DateFrom"
	, TO_CHAR(PC.DATE_TO, 'YYYY/MM/DD') "DateTo"
	, TO_CHAR(PC.PERSON_ID) "PersonId"
	, nvl (CASE WHEN PC.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE 1 = 1
								AND PAPF.PERSON_ID = PC.PERSON_ID
								--AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
								)
					ELSE NULL
				END, '') "PersonNumber"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, PC.CREATED_BY "CreatedBy"
	, TO_CHAR(PC.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PC.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PC.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	, PC.LAST_UPDATE_LOGIN "LastUpdateLogin"
	--
	, HIKM.GUID "Guid"
FROM PER_CITIZENSHIPS PC
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PC.CITIZENSHIP_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'Citizenship'

Relevant attributes from data dictionary:
LegislationCode
CitizenshipStatus
DateFrom
DateTo
PersonId
PersonNumber
CitizenshipId
SourceSystemOwner
SourceSystemId
*/