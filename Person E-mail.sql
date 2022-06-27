SELECT DISTINCT PEA.EMAIL_ADDRESS_ID "EmailAddressId"
	, PEA.EMAIL_ADDRESS	"EmailAddress"
	, PEA.EMAIL_TYPE "EmailType"
	, CASE WHEN PAPF.PRIMARY_EMAIL_ID = PEA.EMAIL_ADDRESS_ID
            THEN 'Y'
            ELSE 'N'
        END "PrimaryFlag" -- this CASE statement validates if the EmailAddressId is a primary one
	, TO_CHAR(PEA.DATE_FROM, 'YYYY/MM/DD')	"DateFrom"
	, TO_CHAR(PEA.DATE_TO, 'YYYY/MM/DD')	"DateTo"
	, PAPF.PERSON_NUMBER "PersonNumber"
	, PEA.PERSON_ID "PersonId"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- Guid is deemed irrelevant to not be displayed at reconciliation reports
	, HIKM.GUID "Guid"
FROM PER_EMAIL_ADDRESSES PEA
	, PER_ALL_PEOPLE_F PAPF
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PAPF.PERSON_ID = PEA.PERSON_ID
	AND HIKM.SURROGATE_ID = PEA.EMAIL_ADDRESS_ID
	AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
	-- unlike Worker, tried adding a filter to load most recent data
	AND HIKM.OBJECT_NAME = 'EmailAddress'
	
/*
Relevant and system relevant attributes from sample Data Dictionary to be displayed for Reconcilation Reports:

EmailAddress
EmailType
PrimaryFlag
DateFrom
DateTo
PersonNumber
PersonId
EmailAddressId
SourceSystemOwner
SourceSystemId
*/