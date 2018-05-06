USE PA036
GO
CREATE OR ALTER PROCEDURE demo.Branches_CompareSnapshots
(
@Date1 DATETIME2, 
@Date2 DATETIME2
)
AS
BEGIN
	WITH CTE AS
	(
		-- no change
		SELECT ID, Name, ParentID, 0 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date1
		INTERSECT
		SELECT ID, Name, ParentID, 0 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date2

		UNION ALL
		-- removed
		SELECT ID, Name, ParentID, -1 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date1
		EXCEPT
		SELECT ID, Name, ParentID, -1 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date2

		UNION ALL
		-- new
		SELECT ID, Name, ParentID, 1 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date2
		EXCEPT
		SELECT ID, Name, ParentID, 1 as ChangeType
		FROM demo.Branch
		FOR SYSTEM_TIME AS OF @date1
	)
	SELECT * FROM CTE ORDER BY ID
END