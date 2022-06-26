SELECT DISTINCT PP.PERSON_ID "PersonId"
	, nvl (PAPF.PERSON_NUMBER, NULL) "PersonNumber"
	, nvl (PAAM.ACTION_CODE, '') "ActionCode" 
	, PP.COUNTRY_OF_BIRTH "CountryOfBirth"
	, nvl (TO_CHAR(PAPF.EFFECTIVE_START_DATE, 'YYYY/MM/DD'), '') "EffectiveStartDate"
	, nvl (PAAM.REASON_CODE, '') "ReasonCode"
	, TO_CHAR(PP.START_DATE, 'YYYY/MM/DD') "StartDate"
	, PP.TOWN_OF_BIRTH "TownOfBirth"
	, '' "PersonDuplicateCheck"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- the following attributes below are deemed irrelevant to be displayed for reconciliation reports
	, nvl (TO_CHAR(PPOS.ACTUAL_TERMINATION_DATE, 'YYYY/MM/DD'), '') "ActualTerminationDate"
	, nvl (PAR.ASSIGNMENT_CATEGORY, '') "AssignmentCategory"
	, PP.BLOOD_TYPE "BloodType"
	, nvl (PAAM.EMPLOYMENT_CATEGORY, '') "EmploymentCategory"
	, PP.REGION_OF_BIRTH "RegionOfBirth"
	, nvl (PAAM.ASSIGNMENT_NAME, '') "AssignmentName"
	, nvl (PAAM.ASSIGNMENT_STATUS_TYPE, '') "AssignmentStatusTypeCode"
	, PP.CORRESPONDENCE_LANGUAGE "CorrespondenceLanguage"
	, TO_CHAR(PP.DATE_OF_DEATH, 'YYYY/MM/DD') "DateOfDeath"
	, nvl (PAAM.COLLECTIVE_AGREEMENT_ID, NULL) "CollectiveAgreementIdCode"
	, TO_CHAR(PP.DATE_OF_BIRTH, 'YYYY/MM/DD') "DateOfBirth"
	, HIKM.GUID "Guid"
FROM PER_ALL_PEOPLE_F PAPF
	, PER_PERSONS PP
	, PER_ALL_ASSIGNMENTS_M PAAM
	, HRC_INTEGRATION_KEY_MAP HIKM
	, PER_PERIODS_OF_SERVICE PPOS
	, PER_ASG_RESPONSIBILITIES PAR
WHERE 1 = 1
	AND PAPF.PERSON_ID = PP.PERSON_ID
	AND PAPF.PERSON_ID = PAAM.PERSON_ID
	AND PAPF.PERSON_ID = HIKM.SURROGATE_ID
	AND PAPF.PERSON_ID = PPOS.PERSON_ID
	AND PAPF.PERSON_ID = PAR.PERSON_ID
	--AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
	--AND SYSDATE BETWEEN PAAM.EFFECTIVE_START_DATE AND PAAM.EFFECTIVE_END_DATE
	-- SYSDATE filters are removed to also load historic data
	AND HIKM.OBJECT_NAME = 'Person'
	
/*
Relevant and system relevant attributes from Data Dictionary:
PersonNumber
ActionCode
CountryOfBirth
DateOfBirth
EffectiveStartDate
ReasonCode
StartDate
TownOfBirth
PersonId
PersonDuplicateCheck
SourceSystemOwner
SourceSystemId

Additional note(s):
PersonDuplicaCheck - Determines whether checking for duplicate person records is enabled and the attributes that are used to identify duplicate records. (blank)
*/