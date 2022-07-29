# Worker

Description:
Sample Worker SQL for creating data models and reports at OTBI.

Notes:
1. Most attributes listed in each SQL query are deemed relevant and shall be reflected in the reconciliation report for data migration.
2. Dates are converted into YYYY/MM/DD format.
3. IDs' datatype is converted from NUM (double) to CHAR (string) for the best display of IDs at reports (particularly for excel-format reports).
4. The table HRC_INTEGRATION_KEY_MAP is connected to almost all tables for attributes: SourceSystemId, and SourceSystemOwner.
5. As mentioned by note # 3, attribute SourceSystemId don't need datatype conversion.
6. ObjectName attribute is set to each business object's respective integration key.
7. The SYSDATE filter between Effective Dates is included for loading relevant and up-to-date data.
8. Additional notes are included as comments for each business object if available.
9. Navigating through several business objects are a hassle so I organized them according to their respective path at Oracle Fusion VBO (View Business Object).
10. Each Business Objects' data loaded are DISTINCT.
11. CASE() statements and nvl() expressions are used to avoid 'no data error' unless the main table has actually no data itself.
12. LEFT JOIN(s) is/are necessary for the main table to retain its PK (Primary Key) which is the best reference for all queries.
13. The code is divided into two (optional), the primary attributes are required at VBO (View Business Object) of Oracle Fusion, is displayed at the top. These attributes are either required or for new records only, also included are User Keys for the required/for new records attributes. So the upper part or first division displays the attributes for the reconciliation report. The lower part or second division are optional but can easily be displayed unto the said report.
14. Additionally, the following auditing attributes are to be displayed on the reports:
	a. CreatedBy
	b. CreationDate
	c. LastUpdatedBy
	d. LastUpdateDate
	The attribute 'LastUpdateLogin' will not be displayed since it makes no sense due to its hash and unreadable value.
15. Filter parameters are added for User Keys.