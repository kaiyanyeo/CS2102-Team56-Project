-- Clear all possible duplicate tables
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS History CASCADE;
DROP TABLE IF EXISTS Biddings CASCADE;
DROP TABLE IF EXISTS Assigns CASCADE;
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
	startDate		TIMESTAMP NOT NULL,
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
	FOREIGN KEY (employeeName) REFERENCES Employees(userName),
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
	
-- Prevent update if there is existing assignments for the target update taskID
CREATE OR REPLACE FUNCTION check_existing_assignments() RETURNS trigger AS $ret$
	BEGIN
		IF EXISTS(SELECT 1 FROM Assigns a WHERE a.taskID = NEW.taskID) THEN
			RAISE EXCEPTION 'Assignment % exists', NEW.taskID;
		END IF;
		RETURN NEW;
	END;
$ret$ LANGUAGE plpgsql;	
	
CREATE TRIGGER check_assigns_from_tasks
	BEFORE UPDATE ON Tasks
	FOR EACH ROW
	EXECUTE PROCEDURE check_existing_assignments();
	
CREATE OR REPLACE FUNCTION check_existing_biddings() RETURNS trigger AS $ret$
	DECLARE
		mycursor CURSOR FOR SELECT employeeID FROM Biddings b WHERE b.taskID = NEW.taskID;
		eID varchar(32); aID INTEGER; scheduleStart TIMESTAMP; scheduleEnd TIMESTAMP; taskStart TIMESTAMP; taskEnd TIMESTAMP; taskDuration INTEGER;
	BEGIN
		OPEN mycursor;
		SELECT startDate FROM Tasks t WHERE t.taskID = NEW.taskID INTO taskStart;
		SELECT duration FROM Tasks t WHERE t.taskID = NEW.taskID INTO taskDuration;
		taskEnd := taskStart + (taskDuration * INTERVAL '1 hours');
		LOOP
			FETCH mycursor INTO eID;
			EXIT WHEN NOT FOUND;
			SELECT assignID FROM Assigns a WHERE a.employeeID = eID INTO aID;
			SELECT startDate FROM Tasks t WHERE t.taskID = (SELECT taskID FROM Assigns a WHERE a.assignID = aID) INTO scheduleStart;
			SELECT scheduleStart + (duration * INTERVAL '1 hours') FROM Tasks t WHERE t.taskID = (SELECT taskID FROM Assigns a WHERE a.assignID = aID) INTO scheduleEnd;
			IF (taskStart < scheduleStart AND taskEnd > scheduleStart) OR
				(taskStart = scheduleStart AND taskEnd = scheduleEnd) OR
				(taskStart > scheduleStart AND taskStart < scheduleEnd) OR
				(scheduleStart >= taskStart AND scheduleEnd < taskEnd) THEN
				RAISE NOTICE 'DELETE CLASH BIDDING % taskID %', eID, NEW.taskID;
				EXECUTE 'DELETE FROM Biddings b WHERE b.employeeID = $1 AND b.taskID = $2;' USING eID, NEW.taskID;
			END IF;
		END LOOP;
		CLOSE mycursor;
		RETURN NEW;
	END;
$ret$ LANGUAGE plpgsql;	

CREATE TRIGGER check_biddings_from_tasks
	AFTER UPDATE ON Tasks
	FOR EACH ROW
	EXECUTE PROCEDURE check_existing_biddings();

-- Prevent insert if there is clash in schedule/existing bids
CREATE OR REPLACE FUNCTION check_clash() RETURNS trigger AS $ret$
	DECLARE
		mycursor CURSOR FOR SELECT assignID FROM Schedules s WHERE s.employeeID = NEW.employeeID;
		mycursor2 CURSOR FOR SELECT taskID FROM Biddings b WHERE b.employeeID = NEW.employeeID;
		scheduleStart TIMESTAMP; scheduleEnd TIMESTAMP; taskStart TIMESTAMP; taskEnd TIMESTAMP; taskDuration INTEGER; id INTEGER; aID INTEGER; eID varchar(64);
	BEGIN
		OPEN mycursor;
		SELECT startDate FROM Tasks t WHERE t.taskID = NEW.taskID INTO taskStart;
		SELECT duration FROM Tasks t WHERE t.taskID = NEW.taskID INTO taskDuration;
		taskEnd := taskStart + (taskDuration * INTERVAL '1 hours');
		LOOP
			FETCH mycursor INTO aID;
			EXIT WHEN NOT FOUND;
			SELECT startDate FROM Tasks t WHERE t.taskID = (SELECT taskID FROM Assigns a WHERE a.assignID = aID) INTO scheduleStart;
			SELECT scheduleStart + (duration * INTERVAL '1 hours') FROM Tasks t WHERE t.taskID = (SELECT taskID FROM Assigns a WHERE a.assignID = aID) INTO scheduleEnd;
			IF (taskStart < scheduleStart AND taskEnd > scheduleStart) OR
				(taskStart = scheduleStart AND taskEnd = scheduleEnd) OR
				(taskStart > scheduleStart AND taskStart < scheduleEnd) OR
				(scheduleStart >= taskStart AND scheduleEnd < taskEnd) THEN
				RAISE EXCEPTION 'Schedule clash';
			END IF;
		END LOOP;
		CLOSE mycursor;
		OPEN mycursor2;
		LOOP
			FETCH mycursor2 INTO id;
			EXIT WHEN NOT FOUND;
			SELECT startDate FROM Tasks t WHERE t.taskID = id INTO scheduleStart;
			SELECT duration FROM Tasks t WHERE t.taskID = id INTO taskDuration;
			scheduleEnd := scheduleStart + (taskDuration * INTERVAL '1 hours');
			IF (taskStart < scheduleStart AND taskEnd > scheduleStart) OR
				(taskStart = scheduleStart AND taskEnd = scheduleEnd) OR
				(taskStart > scheduleStart AND taskStart < scheduleEnd) OR
				(scheduleStart >= taskStart AND scheduleEnd < taskEnd) THEN
				RAISE EXCEPTION 'Biddings clash';
			END IF;
		END LOOP;
		CLOSE mycursor2;
		SELECT employerName FROM TASKS t WHERE t.taskID = NEW.taskID INTO eID;
		IF eID = NEW.employeeID THEN
			RAISE EXCEPTION 'Cannot bid for own task';
		END IF;
		RETURN NEW;
	END;
$ret$ LANGUAGE plpgsql;	
	
CREATE TRIGGER check_schedule_biddings_from_biddings
	BEFORE INSERT ON Biddings
	FOR EACH ROW
	EXECUTE PROCEDURE check_clash();
