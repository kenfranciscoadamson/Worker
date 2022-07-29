SELECT * FROM (
SELECT DISTINCT TO_CHAR(PEAI.EXT_IDENTIFIER_ID) "ExternalIdentifierId"
	, TO_CHAR(PEAI.PERSON_ID) "PersonId"
	, nvl (PAPF.PERSON_NUMBER, NULL) "PersonNumber"
	, PEAI.EXT_IDENTIFIER_SEQ "Sequence"
	, PEAI.EXT_IDENTIFIER_TYPE "ExternalIdentifierType"
	, PEAI.EXT_IDENTIFIER_NUMBER "ExternalIdentifierNumber"
	, TO_CHAR(PEAI.DATE_FROM, 'YYYY/MM/DD') "DateFrom"
	, nvl (CASE WHEN PEAI.ASSIGNMENT_ID IS NOT NULL
					THEN (SELECT DISTINCT PAAM.ASSIGNMENT_NUMBER
							FROM PER_ALL_ASSIGNMENTS_M PAAM
							WHERE PAAM.ASSIGNMENT_ID = PEAI.ASSIGNMENT_ID
								AND SYSDATE BETWEEN PAAM.EFFECTIVE_START_DATE AND PAAM.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') "AssignmentNumber"
	-- for auditing
	, PEAI.CREATED_BY "CreatedBy"
	, TO_CHAR(PEAI.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PEAI.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PEAI.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	-- for integration
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- for filter parameters
	, nvl (PAPF.PERSON_NUMBER, NULL) AS PERSON_NUMBER
	, PEAI.EXT_IDENTIFIER_SEQ AS SEQUENCE
	, PEAI.DATE_FROM AS DATE_FROM
	, nvl (CASE WHEN PEAI.ASSIGNMENT_ID IS NOT NULL
					THEN (SELECT DISTINCT PAAM.ASSIGNMENT_NUMBER
							FROM PER_ALL_ASSIGNMENTS_M PAAM
							WHERE PAAM.ASSIGNMENT_ID = PEAI.ASSIGNMENT_ID
								AND SYSDATE BETWEEN PAAM.EFFECTIVE_START_DATE AND PAAM.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') AS ASSIGNMENT_NUMBER
FROM PER_EXT_APP_IDENTIFIERS PEAI
	LEFT JOIN PER_ALL_PEOPLE_F PAPF
		ON PAPF.PERSON_ID = PEAI.PERSON_ID
		AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PEAI.EXT_IDENTIFIER_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'ExternalIdentifier'
)
WHERE 1 = 1
	AND PERSON_NUMBER = NVL(:PersonNumber, PERSON_NUMBER)
	AND SEQUENCE = NVL(:Sequence, SEQUENCE)
	AND TRUNC(DATE_FROM) = NVL(:DateFrom, TRUNC(DATE_FROM))
	AND ASSIGNMENT_NUMBER = NVL(:AssignmentNumber, ASSIGNMENT_NUMBER)

/*
A person's identifier in an external application. For example a third-party payroll identifier, or a time device badge identifier.

Required:
	• Person ID - A unique reference to the person to whom this external identifier belongs. (User Key: Person Number)
	• External Identifier ID - The surrogate ID for the external identifier record. Only available when updating existing records. (User Keys: PersonNumber, ExternalIdentifierSequence)

Required for new records:
	• External Identifier Type	- The type of external identifier, such as Third-Party Payroll ID.
	• External Identifier Number - The external identifier number.
	• From Date and Time - The date and time from when the external identifier is valid.
	• Sequence - The sequence of the external identifier.

User Keys
	• Person Number - The person number of the person to whom this external identifier belongs.
	• Sequence
	• From Date and Time	
	• Assignment Number - The assignment number to which the external identifier belongs.
*/

/*
Sample code from current project:

SELECT DISTINCT TO_CHAR(PEAI.EXT_IDENTIFIER_ID) "ExternalIdentifierId"
	, TO_CHAR(PEAI.DATE_TO, 'YYYY/MM/DD') "DateTo"
	, PEAI.EXT_IDENTIFIER_NUMBER "ExternalIdentifierNumber"
	, PEAI.COMMENTS "Comments"
	, PEAI.EXT_IDENTIFIER_TYPE "ExternalIdentifierType"
	, TO_CHAR(PEAI.DATE_FROM, 'YYYY/MM/DD') "DateFrom"
	, TO_CHAR(PEAI.PERSON_ID) "PersonId"
	, nvl (CASE WHEN PEAI.PERSON_ID IS NOT NULL
				THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
						FROM PER_ALL_PEOPLE_F PAPF
						WHERE 1 = 1
							AND PAPF.PERSON_ID = PEAI.PERSON_ID)
				ELSE NULL
			END, '') "PersonNumber"
	, PEAI.EXT_IDENTIFIER_SEQ "ExternalIdentifierSequence"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, PEAI.CREATED_BY "CreatedBy"
	, TO_CHAR(PEAI.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PEAI.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PEAI.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	, PEAI.LAST_UPDATE_LOGIN "LastUpdateLogin"
	--
	, PEAI.ASSIGNMENT_ID "AssignmentId"
	, nvl (CASE WHEN PEAI.ASSIGNMENT_ID IS NOT NULL
				THEN (SELECT DISTINCT PAAM.ASSIGNMENT_NUMBER
						FROM PER_ALL_ASSIGNMENTS_M PAAM
						WHERE 1 = 1
							AND PAAM.ASSIGNMENT_ID = PEAI.ASSIGNMENT_ID
							)
				ELSE NULL
			END, '') "AssignmentNumber"
	, HIKM.GUID "Guid"
FROM PER_EXT_APP_IDENTIFIERS PEAI
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PEAI.EXT_IDENTIFIER_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'ExternalIdentifier'
	
Relevant and system relevant attributes from Data Dictionary:
DateTo
ExternalIdentifierNumber
Comments
ExternalIdentifierType
DateFrom
PersonId
PersonNumber
ExternalIdentifierId
ExternalIdentifierSequence
SourceSystemOwner
SourceSystemId
*/