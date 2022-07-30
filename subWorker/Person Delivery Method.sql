SELECT * FROM(
SELECT DISTINCT TO_CHAR(PPDM.DELIVERY_METHOD_ID) "DeliveryMethodId"
	, TO_CHAR(PPDM.PERSON_ID) "PersonId"
	, PPDM.COMM_DLVRY_METHOD "CommunicationDeliveryMethod"
	, TO_CHAR(PPDM.DATE_START, 'YYYY/MM/DD') "DateStart"
	, nvl (CASE WHEN PPDM.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE PAPF.PERSON_ID = PPDM.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') "PersonNumber"
	, PPDM.PREFERRED_ORDER "PreferredOrder"
	-- for auditing
	, PPDM.CREATED_BY "CreatedBy"
	, TO_CHAR(PPDM.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PPDM.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PPDM.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	-- for integration
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	-- for filter parameters
	, nvl (CASE WHEN PPDM.PERSON_ID IS NOT NULL
					THEN (SELECT DISTINCT PAPF.PERSON_NUMBER
							FROM PER_ALL_PEOPLE_F PAPF
							WHERE PAPF.PERSON_ID = PPDM.PERSON_ID
								AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE)
					ELSE NULL
				END, '') AS PERSON_NUMBER
	, PPDM.COMM_DLVRY_METHOD AS COMM_DLVRY_METHOD
	, PPDM.PREFERRED_ORDER AS PREFERRED_ORDER
FROM PER_PERSON_DLVRY_METHODS PPDM
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	AND PPDM.DELIVERY_METHOD_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'DeliveryMethod'
)
WHERE 1 = 1
	AND PERSON_NUMBER = NVL(:PersonNumber, PERSON_NUMBER)
	AND COMM_DLVRY_METHOD = NVL(:CommunicationDeliveryMethod, COMM_DLVRY_METHOD)
	AND PREFERRED_ORDER = NVL(:PreferredOrder, PREFERRED_ORDER)

/*
Specify the different methods of communication with the person. For example, this may include phone, email, IM, and so on.

Required:
	• Person Delivery Method ID (Surrogate ID) - The surrogate ID for the delivery method. Only available when updating existing delivery methods. (User Keys: PersonNumber, CommDlvryMethod, PreferredOrder)
	• Person ID (Parent Surrogate ID) - A unique reference to the person to whom this address belongs. (User Key: PersonNumber)

Required for new records:
	• Communication Delivery Method - The communication method, such as e-mail or phone.
	• Start Date - The start date of the delivery method.

User Keys:
	• Person Number - A number to uniquely identify the person. If you have configured person numbers to be automatically generated, this leave blank.
	• Communication Delivery Method - The communication method, such as e-mail or phone.
	• Preferred Order - The preferred order for the communication delivery method.
*/

/*
Code not totally tested due to test table not having any data.
*/

/*
SELECT DISTINCT TO_CHAR(PPDM.DELIVERY_METHOD_ID) "DeliveryMethodId"
	, TO_CHAR(PPDM.PERSON_ID) "PersonId"
	, PPDM.CREATED_BY "CreatedBy"
	, TO_CHAR(PPDM.CREATION_DATE, 'YYYY/MM/DD') "CreationDate"
	, PPDM.LAST_UPDATED_BY "LastUpdatedBy"
	, TO_CHAR(PPDM.LAST_UPDATE_DATE, 'YYYY/MM/DD') "LastUpdateDate"
	, PPDM.LAST_UPDATE_LOGIN "LastUpdateLogin"
	--
	, PPDM.PREFERRED_ORDER "PreferredOrder"
	, PPDM.COMM_DLVRY_METHOD "CommDlvryMethod"
	--, PAPF.PERSON_NUMBER "PersonNumber"
	, PPDM.COMM_DLVRY_ADDRESS "CommDlvryAddress"
	--, PPAUF.ADDRESS_TYPE "AddressType"
	--, PAF.ADDRESS_LINE_1 "AddressLine1"
	--, PEA.EMAIL_ADDRESS "EmailAddress"
	--, PEA.EMAIL_TYPE "EmailType"
	, TO_CHAR(PPDM.DATE_END, 'YYYY/MM/DD') "DateEnd"
	, PPDM.COMM_DLVRY_FK_ID "CommDlvryFkId"
	, TO_CHAR(PPDM.DATE_START, 'YYYY/MM/DD') "DateStart"
	--, PP.PHONE_NUMBER "PhoneNumber"
	--, PP.PHONE_TYPE "PhoneType"
	, HIKM.SOURCE_SYSTEM_OWNER "SourceSystemOwner"
	, HIKM.SOURCE_SYSTEM_ID "SourceSystemId"
	, HIKM.GUID "Guid"
FROM PER_ALL_PEOPLE_F PAPF
	, PER_PERSON_DLVRY_METHODS PPDM
	--, PER_ADDRESSES_F PAF
	--, PER_PERSON_ADDR_USAGES_F PPAUF
	--, PER_EMAIL_ADDRESSES PEA
	--, PER_PHONES PP
	, HRC_INTEGRATION_KEY_MAP HIKM
WHERE 1 = 1
	--AND PAPF.PERSON_ID = PPDM.PERSON_ID
	--AND PAF.ADDRESS_ID = PPAUF.ADDRESS_ID
	--AND PAPF.PERSON_ID = PPAUF.PERSON_ID
	--AND PAPF.PERSON_ID = PEA.PERSON_ID
	--AND PAPF.PERSON_ID = PP.PERSON_ID
	AND PPDM.DELIVERY_METHOD_ID = HIKM.SURROGATE_ID
	AND HIKM.OBJECT_NAME = 'DeliveryMethod'
	
Relevant attribute(s) from Data Dictionary:
PersonId

Additional notes:
Only system relevant attribute is PersonId;
SQL code can be improved;
Table PER_PERSON_DLVRY_METHODS is empty
*/