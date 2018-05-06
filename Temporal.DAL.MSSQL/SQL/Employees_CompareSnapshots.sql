-- this is just simplified example, can be written better but we are counting on cache usage
-- using functions is also an option but in most cases specification of selected attributes is not desired, i.e. calling like this: select attr1, attr2 from function_name(args)
USE PA036
GO
CREATE OR ALTER PROCEDURE demo.Employees_CompareSnapshots
(
@Date1 DATETIME2, 
@Date2 DATETIME2
)
AS
BEGIN
	WITH CTE AS
	(
		-- no change
		SELECT ID, BranchID, FirstName, LastName, 0 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date1
		INTERSECT
		SELECT ID, BranchID, FirstName, LastName, 0 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date2

		UNION ALL
		-- removed
		SELECT ID, BranchID, FirstName, LastName, -1 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date1
		EXCEPT
		SELECT ID, BranchID, FirstName, LastName, -1 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date2

		UNION ALL
		-- new
		SELECT ID, BranchID, FirstName, LastName, 1 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date2
		EXCEPT
		SELECT ID, BranchID, FirstName, LastName, 1 as ChangeType
		FROM demo.Employee
		FOR SYSTEM_TIME AS OF @Date1
	)
	SELECT * FROM CTE ORDER BY ID, BranchID
END