-- execute first
CREATE DATABASE PA036;
-- then
CREATE EXTENSION temporal_tables;
-- then
CREATE SCHEMA demo;

CREATE TABLE demo.BranchHistory
(
ID BIGINT NOT NULL,
Name VARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
SysPeriod tstzrange NOT NULL
);

CREATE TABLE demo.Branch
(
ID BIGINT NOT NULL PRIMARY KEY,
Name VARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
SysPeriod tstzrange NOT NULL
);

CREATE TABLE demo.EmployeeHistory
(
ID BIGINT NOT NULL,
BranchID BIGINT NOT NULL,
FirstName VARCHAR(64) NOT NULL,
LastName VARCHAR(64) NOT NULL,
SysPeriod tstzrange NOT NULL
);

CREATE TABLE demo.Employee
(
ID BIGINT NOT NULL PRIMARY KEY,
BranchID BIGINT NOT NULL,
FirstName VARCHAR(64) NOT NULL,
LastName VARCHAR(64) NOT NULL,
SysPeriod tstzrange NOT NULL,
FOREIGN KEY (BranchID) REFERENCES demo.Branch(ID)
);  


INSERT INTO demo.Branch(ID, Name, ParentID, SysPeriod)
VALUES
(1, 'Root', NULL, '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(2, 'Czech Republic', 1, '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(3, 'Brno', 2, '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(4, 'Prague', 2, '[2005/01/01, 9999-12-31 23:59:59.9999999)'),
(5, 'United Kingdom', 1, '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(7, 'London', 5, '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(8, 'Manchester', 5, '[2005/01/01, 9999-12-31 23:59:59.9999999)');
INSERT INTO demo.BranchHistory(ID, Name, ParentID, SysPeriod)
VALUES (6, 'Birmingham', 5, '[2000/01/01, 2005-01-01)');


INSERT INTO demo.Employee(ID, BranchID, FirstName, LastName, SysPeriod)
VALUES
(1, 3, 'Jonathan', 'Maxwell', '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(2, 3, 'Harvey', 'Frazier', '[2000/01/01, 9999-12-31 23:59:59.9999999)'),
(4, 3, 'Ross', 'James', '[2005/01/01, 9999-12-31 23:59:59.9999999)'),
(5, 4, 'Elaine', 'Phillips ', '[2005/01/01, 9999-12-31 23:59:59.9999999)'),
(6, 4, 'Hugh', 'Griffith', '[2005/01/01, 9999-12-31 23:59:59.9999999)');
INSERT INTO demo.EmployeeHistory(ID, BranchID, FirstName, LastName, SysPeriod)
VALUES
(3, 3, 'Roxanne', 'Barnett', '[2000/01/01, 2005-01-01)');

CREATE TRIGGER BranchVersioningTrigger
BEFORE INSERT OR UPDATE OR DELETE ON demo.Branch
FOR EACH ROW EXECUTE PROCEDURE versioning('SysPeriod', 'demo.BranchHistory', true);

CREATE TRIGGER EmployeeVersioningTrigger
BEFORE INSERT OR UPDATE OR DELETE ON demo.Employee
FOR EACH ROW EXECUTE PROCEDURE versioning('SysPeriod', 'demo.EmployeeHistory', true);