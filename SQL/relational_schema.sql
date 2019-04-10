-- Clear all possible duplicate data
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS History CASCADE;
DROP TABLE IF EXISTS Biddings CASCADE;
DROP TABLE IF EXISTS Assigns CASCADE;
DROP TABLE IF EXISTS Posts CASCADE;
DROP TABLE IF EXISTS Tasks CASCADE;
DROP TABLE IF EXISTS Accounts CASCADE;
DROP TABLE IF EXISTS Admins CASCADE;
DROP TABLE IF EXISTS Employers CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Categories CASCADE;
DROP TABLE IF EXISTS Users CASCADE;

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
	numOfCompletedJobs	INTEGER,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

-- Categories that Tasks may belong to
CREATE TABLE Categories (
	categoryName	    VARCHAR(64),
    categoryDescription TEXT,
	PRIMARY KEY (categoryName)
);

-- Tasks are general chores posted by Employers
CREATE TABLE Tasks (
	taskID			INTEGER,
	taskTitle       VARCHAR(64),
    employerName    VARCHAR(32) NOT NULL,
	duration		INTEGER NOT NULL,
	payAmt          INTEGER,
	categoryName	VARCHAR(64),
	requirement		INTEGER,
	PRIMARY KEY (taskID),
    FOREIGN KEY (employerName) REFERENCES Employers(userName),
	FOREIGN KEY (categoryName) REFERENCES Categories(categoryName)
);

-- Post details of a particular Task by a particular Employer
CREATE TABLE Posts (
    postDate        DATE NOT NULL,
    taskID          INTEGER,
    employerID      VARCHAR(32),
    PRIMARY KEY (taskID, employerID),
    FOREIGN KEY (taskID) REFERENCES Tasks(taskID),
    FOREIGN KEY (employerID) REFERENCES Employers(userName)
);

-- Assignment of Tasks to Employee
CREATE TABLE Assigns (
	assignID		INTEGER,
	taskID			INTEGER,
	employeeID		VARCHAR(32),
	PRIMARY KEY (assignID),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName)
);

-- Schedule of a particular Employee's Tasks
CREATE TABLE Schedules (
	userName	 	VARCHAR(32), 
	taskID			INTEGER,
	taskDate        INTEGER,
	timeStart		DATE,
	timeEnd			DATE,
	PRIMARY KEY (userName, taskID),
	FOREIGN KEY (userName) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Assigns(assignID)
);

-- History of completed Tasks by an Employee
CREATE TABLE History (
	userName	 	VARCHAR(32), 
	taskID			INTEGER,
    rating          INTEGER,
    comments        TEXT,
	PRIMARY KEY (userName, taskID),
	FOREIGN KEY (userName) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Assigns(assignID)
);

-- Biddings placed by an Employee for a Task
CREATE TABLE Biddings (
	employeeID		VARCHAR(32),
	taskID			INTEGER,
	timePlaced		DATE,
	PRIMARY KEY (employeeID, taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID)
);

-- Prevent creation of duplicate accounts
CREATE OR REPLACE FUNCTION create_account() RETURNS trigger AS $ret$
	BEGIN
		IF EXISTS(SELECT 1 FROM Accounts a WHERE a.userName = NEW.userName) THEN
			RAISE EXCEPTION 'Username % exists', NEW.userName;
		END IF;
	END;
$ret$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_duplicate_accounts
	BEFORE INSERT ON Account
	FOR EACH ROW
	EXECUTE PROCEDURE create_account();