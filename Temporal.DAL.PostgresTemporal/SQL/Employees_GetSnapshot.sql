CREATE OR REPLACE FUNCTION demo.Employees_GetSnapshot
(
	Date TIMESTAMP
)
RETURNS TABLE
(
	ID BIGINT,
	BranchID BIGINT,
	FirstName VARCHAR(64),
	LastName VARCHAR(64)
)
AS $$
BEGIN
	RETURN QUERY
	WITH CTE
	AS
	(
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName
		FROM demo.Employee e
		WHERE e.SysPeriod @> Date::timestamptz
		UNION ALL
		SELECT e.ID, e.BranchID, e.FirstName, e.LastName
		FROM demo.EmployeeHistory e
		WHERE e.SysPeriod @> Date::timestamptz
	)
	SELECT c.* FROM CTE c ORDER BY c.ID;
END; $$

LANGUAGE 'plpgsql';