SELECT DISTINCT PPEIF.PERSON_EXTRA_INFO_ID "PersonExtraInfoId"
	, TO_CHAR(PPEIF.EFFECTIVE_START_DATE, 'YYYY/MM/DD') "EffectiveStartDate"
	, TO_CHAR(PPEIF.EFFECTIVE_END_DATE, 'YYYY/MM/DD') "EffectiveEndDate"
	, PPEIF.INFORMATION_TYPE "InformationType"
	, PPEIF.CATEGORY_CODE "CategoryCode"
	, PPEIF.PERSON_ID "PersonId"
	, nvl (CASE WHEN PPEIF.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE 1 = 1
								AND PAPF.PERSON_ID = PPEIF.PERSON_ID
								--AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
								)
					ELSE NULL
				END, '') "PersonNumber"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, PPEIF.PEI_INFORMATION_CATEGORY "PeiInformationCategory"
	--
	, HIKM.GUID "Guid"
FROM PER_PEOPLE_EXTRA_INFO_F PPEIF
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PPEIF.PERSON_EXTRA_INFO_ID = HIKM.SURROGATE_ID
	--AND SYSDATE BETWEEN PPEIF.EFFECTIVE_START_DATE AND PPEIF.EFFECTIVE_END_DATE
	AND HIKM.OBJECT_NAME = 'PersonExtraInfo'
	
/*
Relevant and system relevant attributes from Data Dictionary:
EffectiveStartDate
EffectiveEndDate
InformationType
CategoryCode
PersonId
PersonNumber
SourceSystemOwner
SourceSystemId
PersonExtraInfoId
PeiInformationCategory

Additional note(s):
*/