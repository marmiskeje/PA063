CREATE OR REPLACE FUNCTION demo.Branches_CompareSnapshots
(
	Date1 TIMESTAMP,
	Date2 TIMESTAMP
)
RETURNS TABLE
(
	ID BIGINT,
	Name VARCHAR(64),
	ParentID BIGINT,
	ChangeType INT
)
AS $$
BEGIN
	RETURN QUERY
	WITH CTE
	AS
	(
		-- no change
		SELECT b.ID, b.Name, b.ParentID, 0 as ChangeType
		FROM demo.Branches_GetSnapshot(Date1) b
		INTERSECT
		SELECT b.ID, b.Name, b.ParentID, 0 as ChangeType
		FROM demo.Branches_GetSnapshot(Date2) b
											
		UNION ALL
		-- removed
		SELECT b.ID, b.Name, b.ParentID, -1 as ChangeType
		FROM demo.Branches_GetSnapshot(Date1) b
		EXCEPT
		SELECT b.ID, b.Name, b.ParentID, -1 as ChangeType
		FROM demo.Branches_GetSnapshot(Date2) b
		
		UNION ALL
		-- new
		SELECT b.ID, b.Name, b.ParentID, 1 as ChangeType
		FROM demo.Branches_GetSnapshot(Date2) b
		EXCEPT
		SELECT b.ID, b.Name, b.ParentID, 1 as ChangeType
		FROM demo.Branches_GetSnapshot(Date1) b
	)
	SELECT c.* FROM CTE c ORDER BY c.ID;
END; $$

LANGUAGE 'plpgsql';