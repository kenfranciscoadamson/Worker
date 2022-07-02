# Worker

Description:
Sample Worker SQL for creating data models and reports at OTBI.

Notes:
1. Most attributes listed in each SQL query are deemed relevant and shall be reflected in the reconciliation report for data migration.
2. Dates are converted into YYYY/MM/DD format.
3. IDs' datatype is converted from NUM (double) to CHAR (string) for the best display of IDs at reports (particularly for excel-format reports).
4. The table HRC_INTEGRATION_KEY_MAP is connected to almost all tables for attributes: SourceSystemId, SourceSystemOwner, and GUID.
5. As mentioned by note # 3, attributes SourceSystemId and GUID don't need datatype conversion.
6. ObjectName attribute is set to each business object's respective integration key.
7. The SYSDATE filter between Effective Dates is included for loading relevant and up-to-date data.
8. Additional notes are included as comments for each business object if available.
9. Navigating through several business objects are a hassle so I organized them according to their respective path at Oracle Fusion VBO (View Business Object).
10. Each Business Objects' data loaded are DISTINCT.
11. CASE() statements and nvl() expressions are used to avoid 'no data error' unless the main table has actually no data itself.
