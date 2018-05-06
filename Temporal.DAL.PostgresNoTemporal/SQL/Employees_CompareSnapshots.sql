CREATE OR REPLACE FUNCTION demo.Employees_CompareSnapshots
(
	Date1 TIMESTAMP,
	Date2 TIMESTAMP
)
RETURNS TABLE
(
	ID BIGINT,
	BranchID BIGINT,
	FirstName VARCHAR(64),
	LastName VARCHAR(64),
	ChangeType INT
)
AS $$
BEGIN
	RETURN QUERY
	WITH CTE
	AS
	(
		-- no change
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, 0 as ChangeType
		FROM demo.Employees_GetSnapshot(Date1) e
		INTERSECT
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, 0 as ChangeType
		FROM demo.Employees_GetSnapshot(Date2) e
											
		UNION ALL
		-- removed
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, -1 as ChangeType
		FROM demo.Employees_GetSnapshot(Date1) e
		EXCEPT
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, -1 as ChangeType
		FROM demo.Employees_GetSnapshot(Date2) e
		
		UNION ALL
		-- new
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, 1 as ChangeType
		FROM demo.Employees_GetSnapshot(Date2) e
		EXCEPT
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName, 1 as ChangeType
		FROM demo.Employees_GetSnapshot(Date1) e
	)
	SELECT c.* FROM CTE c ORDER BY c.ID;
END; $$

LANGUAGE 'plpgsql';