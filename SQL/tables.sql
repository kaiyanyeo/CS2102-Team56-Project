-- Clear all possible duplicate tables
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS History CASCADE;
DROP TABLE IF EXISTS Biddings CASCADE;
DROP TABLE IF EXISTS Assigns CASCADE;
DROP TABLE IF EXISTS Posts CASCADE;
DROP TABLE IF EXISTS Tasks CASCADE;
DROP TABLE IF EXISTS Admins CASCADE;
DROP TABLE IF EXISTS Employers CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Accounts CASCADE;
DROP TABLE IF EXISTS Categories CASCADE;

-- Create tables
-- Accounts are owned by Users
CREATE TABLE Accounts (
	userName	VARCHAR(64),
	pword		VARCHAR(64) NOT NULL,
	PRIMARY KEY (userName)
);

-- Users are Admins, Employers, or Employees
CREATE TABLE Users (
	firstName	VARCHAR(32) NOT NULL,
	lastName	VARCHAR(32) NOT NULL,
	userName	VARCHAR(64),
	gender		CHAR(1) NOT NULL,
	birthdate	DATE NOT NULL,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Accounts(userName)
);

-- Admins can only be added manually
CREATE TABLE Admins (
    id           char(10),
	userName	 VARCHAR(32),
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

CREATE TABLE Employers (
	userName	 	VARCHAR(32),
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

CREATE TABLE Employees (
	userName	 		VARCHAR(32), 
	numOfCompletedJobs	INTEGER DEFAULT 0,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

-- Categories that Tasks may belong to
CREATE TABLE Categories (
	name	    CHAR(20),
	PRIMARY KEY (name)
);

-- Tasks are general chores posted by Employers
CREATE TABLE Tasks (
	taskID			SERIAL,
	title			VARCHAR(64),
    employerName    VARCHAR(32) NOT NULL,
	startDate		DATE NOT NULL,
	duration		INTEGER NOT NULL,	-- in hours
	payAmt          NUMERIC NOT NULL CHECK(payAmt>=0),	-- in dollars
	categoryName	VARCHAR(64),
	requirement		INTEGER,	-- given as option on front end
	PRIMARY KEY (taskID),
    FOREIGN KEY (employerName) REFERENCES Employers(userName),
	FOREIGN KEY (categoryName) REFERENCES Categories(name)
);

-- Assignment of Tasks to Employee
CREATE TABLE Assigns (
	assignID		SERIAL,
	taskID			INTEGER,
	employeeID		VARCHAR(32),
	PRIMARY KEY (assignID),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName)
);

-- Schedule of a particular Employee's Tasks
CREATE TABLE Schedules (
	employeeID	 	VARCHAR(32), 
	assignID		INTEGER,
	PRIMARY KEY (employeeID, assignID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName),
	FOREIGN KEY (assignID) REFERENCES Assigns(assignID)
);

-- History of completed Tasks
CREATE TABLE History (
	employeeName	VARCHAR(32),
	employerName	VARCHAR(32),
	assignID		INTEGER,
    rating          INTEGER,
    comments        TEXT,
	PRIMARY KEY (assignID),
	FOREIGN KEY (employeeName) REFERENCES Employees(userName)
	FOREIGN KEY (employerName) REFERENCES Employers(userName),
	FOREIGN KEY (assignID) REFERENCES Assigns(assignID)
);

-- Biddings placed by an Employee for a Task
CREATE TABLE Biddings (
	employeeID		VARCHAR(32),
	taskID			INTEGER,
	timePlaced		TIMESTAMP,
	PRIMARY KEY (employeeID, taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID) ON DELETE CASCADE
);

-- Prevent creation of duplicate accounts
CREATE OR REPLACE FUNCTION create_account() RETURNS trigger AS $ret$
	BEGIN
		IF EXISTS(SELECT 1 FROM Accounts a WHERE a.userName = NEW.userName) THEN
			RAISE EXCEPTION 'Username % exists', NEW.userName;
		END IF;
		RETURN NEW;
	END;
$ret$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_duplicate_accounts
	BEFORE INSERT ON Accounts
	FOR EACH ROW
	EXECUTE PROCEDURE create_account();
