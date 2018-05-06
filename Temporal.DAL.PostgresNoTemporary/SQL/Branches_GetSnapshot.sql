CREATE OR REPLACE FUNCTION demo.Branches_GetSnapshot
(
	Date TIMESTAMP
)
RETURNS TABLE
(
	ID BIGINT,
	Name VARCHAR(64),
	ParentID BIGINT
)
AS $$
BEGIN
	RETURN QUERY
	WITH CTE
	AS
	(
		SELECT b.ID, b.Name, b.ParentID
		FROM demo.Branch b
		WHERE Date >= b.ValidFrom AND Date < b.ValidTo
		UNION ALL
		SELECT b.ID, b.Name, b.ParentID
		FROM demo.BranchHistory b
		WHERE Date >= b.ValidFrom AND Date < b.ValidTo
	)
	SELECT c.* FROM CTE c ORDER BY c.ID;
END; $$

LANGUAGE 'plpgsql';