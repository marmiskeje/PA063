USE PA036
GO
CREATE OR ALTER PROCEDURE demo.Employees_GetSnapshot
(
	@Date DATETIME2
)
AS
BEGIN
	SELECT ID, BranchId, FirstName, LastName
	FROM demo.Employee
	FOR SYSTEM_TIME AS OF @date
	ORDER BY ID
END