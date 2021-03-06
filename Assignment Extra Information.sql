SELECT DISTINCT TO_CHAR(PAEIM.ASSIGNMENT_EXTRA_INFO_ID) "AssignmentExtraInfoId"
	, TO_CHAR(PAEIM.EFFECTIVE_START_DATE, 'YYYY/MM/DD') "EffectiveStartDate"
	, TO_CHAR(PAEIM.EFFECTIVE_END_DATE, 'YYYY/MM/DD') "EffectiveEndDate"
	, PAEIM.LEGISLATION_CODE "LegislationCode"
	, PAEIM.EFFECTIVE_LATEST_CHANGE "EffectiveLatestChange"
	, PAEIM.EFFECTIVE_SEQUENCE "EffectiveSequence"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, TO_CHAR(PAEIM.ASSIGNMENT_ID) "AssignmentId"
	, HIKM.GUID "Guid"
FROM PER_ASSIGNMENT_EXTRA_INFO_M PAEIM
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PAEIM.ASSIGNMENT_EXTRA_INFO_ID = HIKM.SURROGATE_ID
	AND SYSDATE BETWEEN PAEIM.EFFECTIVE_START_DATE AND PAEIM.EFFECTIVE_END_DATE
	AND HIKM.OBJECT_NAME = 'AssignmentExtraInfo'