-- execute first
CREATE DATABASE PA036NoTemporal;
-- then
CREATE SCHEMA demo;

CREATE TABLE demo.BranchHistory
(
ID BIGINT NOT NULL,
Name VARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
ValidFrom TIMESTAMP  NOT NULL,
ValidTo TIMESTAMP NOT NULL DEFAULT('9999-12-31 23:59:59.9999999')
);

CREATE TABLE demo.Branch
(
ID BIGINT NOT NULL PRIMARY KEY,
Name VARCHAR(64) NOT NULL,
ParentID BIGINT NULL,
ValidFrom TIMESTAMP  NOT NULL,
ValidTo TIMESTAMP NOT NULL DEFAULT('9999-12-31 23:59:59.9999999')
);

CREATE TABLE demo.EmployeeHistory
(
ID BIGINT NOT NULL,
BranchID BIGINT NOT NULL,
FirstName VARCHAR(64) NOT NULL,
LastName VARCHAR(64) NOT NULL,
ValidFrom TIMESTAMP NOT NULL,
ValidTo TIMESTAMP NOT NULL DEFAULT('9999-12-31 23:59:59.9999999')
);

CREATE TABLE demo.Employee
(
ID BIGINT NOT NULL PRIMARY KEY,
BranchID BIGINT NOT NULL,
FirstName VARCHAR(64) NOT NULL,
LastName VARCHAR(64) NOT NULL,
ValidFrom TIMESTAMP NOT NULL,
ValidTo TIMESTAMP NOT NULL DEFAULT('9999-12-31 23:59:59.9999999'),
FOREIGN KEY (BranchID) REFERENCES demo.Branch(ID)
);  


INSERT INTO demo.Branch(ID, Name, ParentID, ValidFrom, ValidTo)
VALUES
(1, 'Root', NULL, '2000/01/01', DEFAULT),
(2, 'Czech Republic', 1, '2000/01/01', DEFAULT),
(3, 'Brno', 2, '2000/01/01', DEFAULT),
(4, 'Prague', 2, '2005/01/01', DEFAULT),
(5, 'United Kingdom', 1, '2000/01/01', DEFAULT),
(7, 'London', 5, '2000/01/01', DEFAULT),
(8, 'Manchester', 5, '2005/01/01', DEFAULT);
INSERT INTO demo.BranchHistory(ID, Name, ParentID, ValidFrom, ValidTo)
VALUES (6, 'Birmingham', 5, '2000/01/01', '2005/01/01');


INSERT INTO demo.Employee(ID, BranchID, FirstName, LastName, ValidFrom, ValidTo)
VALUES
(1, 3, 'Jonathan', 'Maxwell', '2000/01/01', DEFAULT),
(2, 3, 'Harvey', 'Frazier', '2000/01/01', DEFAULT),
(4, 3, 'Ross', 'James', '2005/01/01', DEFAULT),
(5, 4, 'Elaine', 'Phillips ', '2005/01/01', DEFAULT),
(6, 4, 'Hugh', 'Griffith', '2005/01/01', DEFAULT);
INSERT INTO demo.EmployeeHistory(ID, BranchID, FirstName, LastName, ValidFrom, ValidTo)
VALUES
(3, 3, 'Roxanne', 'Barnett', '2000/01/01', '2005/01/01');