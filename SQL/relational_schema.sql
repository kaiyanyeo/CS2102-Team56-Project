-- Clear all possible duplicate data
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
	employeeID	 	VARCHAR(32), 
	taskID			SERIAL,
	taskDate        INTEGER,
	timeStart		DATE,
	timeEnd			DATE,
	PRIMARY KEY (employeeID, taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Assigns(assignID)
);

-- History of completed Tasks by an Employee
CREATE TABLE History (
	userName	 	VARCHAR(32), 
	taskID			SERIAL,
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


-- INSERT USERS
INSERT INTO Accounts(username,pword) VALUES ('test@hello.com', '$2b$10$B68w41fUDsuTgMvN4KyMVu90zjwVJ8TgGN7StMPo5KOfzmMhFGJ2G');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('hello', 'world', 'test@hello.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('test@hello.com');
INSERT INTO Employees(username) VALUES ('test@hello.com');
INSERT INTO Accounts(username,pword) VALUES ('dfsad@example.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('dfsad', 'dsf', 'dfsad@example.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('dfsad@example.com');
INSERT INTO Employees(username) VALUES ('dfsad@example.com');

-- INSERT CATEGORIES
INSERT INTO Categories(name) VALUES ('Service');
INSERT INTO Categories(name) VALUES ('Labour');
INSERT INTO Categories(name) VALUES ('Delivery');
INSERT INTO Categories(name) VALUES ('Specialised');
INSERT INTO Categories(name) VALUES ('Household');

-- INSERT TASKS
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES ('Wash car', 'test@hello.com', '2019-01-01', 2, 5, 'Service', 1);
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES ('Build IKEA furniture', 'dfsad@example.com', '2019-01-01', 2, 5, 'Labour', 1);
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES ('Package delivery', 'test@hello.com', '2019-01-01', 2, 5, 'Delivery', 1);
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES ('Wash aircon', 'dfsad@example.com', '2019-01-01', 2, 5, 'Specialised', 2);
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES ('Babysitting', 'test@hello.com', '2019-01-01', 2, 5, 'Household', 1);