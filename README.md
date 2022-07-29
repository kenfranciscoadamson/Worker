# Worker

Description:
Sample Worker SQL for creating data models and reports at OTBI.

Notes:

A. Folder and Directory
	1. Based on VBO (View Business Object)

B. Query
	1. Items or attributes are based on the required attributes at VBO alongside the User Keys.
	2. First attribute is the PK (Primary Key) from the business object's main table.
	3. Succeeding attributes consist of the following:
		- Required attributes as well as for new records.
		- User keys are included as well.
		- Auditing attributes that consists of the following:
			a. Created By
			b. Creation Date
			c. Last Updated By
			d. Last Update Date
		- Integration attributes from the table "HRC_INTEGRATION_KEY_MAP":
			a. Source System Id
			b. Source System Owner
		- As observed, an auditing attribute and an integrating attribute are both removed since the purpose of the queries is for reporting. Last Update Login and Guid having HASH key value makes no sense for reporting.
		- Filter parameters which are user keys under different alias to be ran via OTBI.
	4. Dates are formatted into YYYY/MM/DD format. IDs are converted into STRING as well for optimal display via excel. Source System Id and some other IDs don't need conversion.
	5. DISTINCT is enabled.
	6. CASE() statement and nvl() expressions are used to ensure query values.
	7. For multiple subqueries, the following are used:
		- ROWNUM
		- LEFT JOIN(s), nested if multiple
		- using effective date, latest change, MAX, or any other filter
C. FROM
	1. The main table is always present here containing the PK of the business object.
	2. HRC_INTEGRATION_KEY_MAP is always included if available.
	3. Additional tables are included with extreme respect to the main table, usually in rare occassions.
D. WHERE
	1. "1 = 1" is always included for true value tester.
	2. Effective dates (start and end) are always used as filter for current and updated data.
	3. The main table and HRC_INTEGRATION_KEY_MAP is always connected via the main table's PK equal to HIKM's Surrogate Id.
	4. Object Name from HIKM is loaded with respect to the business object's integration details.
	5. Filter parameters are used for better and more specific navigation of data, usually filtered by user keys.
