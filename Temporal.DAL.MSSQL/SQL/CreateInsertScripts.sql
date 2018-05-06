﻿CREATE DATABASE PA036
GO
USE PA036
GO
CREATE SCHEMA demo
GO
CREATE TABLE demo.BranchHistory
(
ID BIGINT NOT NULL,
Name NVARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
ValidFrom DATETIME2  NOT NULL,
ValidTo DATETIME2 NOT NULL DEFAULT('9999-12-31 23:59:59.9999999')
)
GO
CREATE TABLE demo.Branch
(
ID BIGINT PRIMARY KEY NOT NULL,
Name NVARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT('9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom,ValidTo)
)
WITH (SYSTEM_VERSIONING = ON(HISTORY_TABLE = demo.BranchHistory)) 
GO
CREATE TABLE demo.EmployeeHistory
(
ID BIGINT NOT NULL,
BranchID BIGINT NOT NULL,
FirstName NVARCHAR(64) NOT NULL,
LastName NVARCHAR(64) NOT NULL,
ValidFrom DATETIME2 NOT NULL,
ValidTo DATETIME2 NOT NULL DEFAULT('9999-12-31 23:59:59.9999999')
)
GO
CREATE TABLE demo.Employee
(
ID BIGINT PRIMARY KEY NOT NULL,
BranchID BIGINT NOT NULL,
FirstName NVARCHAR(64) NOT NULL,
LastName NVARCHAR(64) NOT NULL,
ValidFrom datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
ValidTo datetime2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT('9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom,ValidTo),
FOREIGN KEY (BranchID) REFERENCES demo.Branch(ID)
)
WITH (SYSTEM_VERSIONING = ON(HISTORY_TABLE = demo.EmployeeHistory))   

GO
ALTER TABLE demo.Branch SET (SYSTEM_VERSIONING = OFF)
GO
ALTER TABLE demo.Branch DROP PERIOD FOR SYSTEM_TIME
GO
INSERT INTO demo.Branch(ID, Name, ParentID, ValidFrom, ValidTo)
VALUES
(1, 'Root', NULL, '2000/01/01', DEFAULT),
(2, 'Czech Republic', 1, '2000/01/01', DEFAULT),
(3, 'Brno', 2, '2000/01/01', DEFAULT),
(4, 'Prague', 2, '2005/01/01', DEFAULT),
(5, 'United Kingdom', 1, '2000/01/01', DEFAULT),
(7, 'London', 5, '2000/01/01', DEFAULT),
(8, 'Manchester', 5, '2005/01/01', DEFAULT)
INSERT INTO demo.BranchHistory(ID, Name, ParentID, ValidFrom, ValidTo)
VALUES (6, 'Birmingham', 5, '2000/01/01', '2005/01/01')
GO
ALTER TABLE demo.Branch ADD PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo)
GO
ALTER TABLE demo.Branch SET (SYSTEM_VERSIONING = ON(HISTORY_TABLE = demo.BranchHistory, DATA_CONSISTENCY_CHECK = ON))

GO
ALTER TABLE demo.Employee SET (SYSTEM_VERSIONING = OFF)
GO
ALTER TABLE demo.Employee DROP PERIOD FOR SYSTEM_TIME
GO
INSERT INTO demo.Employee(ID, BranchID, FirstName, LastName, ValidFrom, ValidTo)
VALUES
(1, 3, 'Jonathan', 'Maxwell', '2000/01/01', DEFAULT),
(2, 3, 'Harvey', 'Frazier', '2000/01/01', DEFAULT),
(4, 3, 'Ross', 'James', '2005/01/01', DEFAULT),
(5, 4, 'Elaine', 'Phillips ', '2005/01/01', DEFAULT),
(6, 4, 'Hugh', 'Griffith', '2005/01/01', DEFAULT)
INSERT INTO demo.EmployeeHistory(ID, BranchID, FirstName, LastName, ValidFrom, ValidTo)
VALUES
(3, 3, 'Roxanne', 'Barnett', '2000/01/01', '2005/01/01')
ALTER TABLE demo.Employee ADD PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo)
GO
ALTER TABLE demo.Employee SET (SYSTEM_VERSIONING = ON(HISTORY_TABLE = demo.EmployeeHistory, DATA_CONSISTENCY_CHECK = ON))
