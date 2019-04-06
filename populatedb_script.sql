CREATE TABLE Users (
	userName	 VARCHAR(32), 
	name	 	 VARCHAR(64) NOT NULL,
	gender 	 	 VARCHAR(1) NOT NULL,
	age 	 	 INTEGER NOT NULL,
	phoneNumber  INTEGER NOT NULL,
	PRIMARY KEY (userName)
);

CREATE TABLE Accounts (
	userName VARCHAR(32),
	pword VARCHAR(32) NOT NULL,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);


CREATE TABLE Admins (
	userName	 VARCHAR(32),
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

CREATE TABLE Employers (
	userName	 	VARCHAR(32), 
	numOfPostings	INTEGER,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);

CREATE TABLE Employees (
	userName	 		VARCHAR(32), 
	numOfCompletedJobs	INTEGER,
	PRIMARY KEY (userName),
	FOREIGN KEY (userName) REFERENCES Users(userName)
);


CREATE TABLE Categories (
	categoryName	VARCHAR(64),
	PRIMARY KEY (categoryName)
);


CREATE TABLE Tasks (
	taskID			INTEGER,
	name			VARCHAR(64),
	date			INTEGER,
	duration		INTEGER,
	pay				INTEGER,
	categoryName	VARCHAR(64),
	requirement		INTEGER,
	PRIMARY KEY (taskID),
	FOREIGN KEY (categoryName) REFERENCES Categories(categoryName)
);


CREATE TABLE Assignments (
	taskID			INTEGER,
	employerID		VARCHAR(32),
	employeeID		VARCHAR(32),
	PRIMARY KEY (taskID),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID),
	FOREIGN KEY (employerID) REFERENCES Employers(userName),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName)
);

CREATE TABLE Schedules (
	userName	 	VARCHAR(32), 
	taskID			INTEGER,
	date			INTEGER,
	timeStart		INTEGER,
	timeEnd			INTEGER,
	PRIMARY KEY (userName, taskID),
	FOREIGN KEY (userName) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Assignments(taskID)
);

CREATE TABLE History (
	userName	 	VARCHAR(32), 
	taskID			INTEGER,
	PRIMARY KEY (userName, taskID),
	FOREIGN KEY (userName) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Assignments(taskID)
);


CREATE TABLE Biddings (
	employeeID		VARCHAR(32),
	taskID			INTEGER,
	timePlaced		INTEGER,
	PRIMARY KEY (employeeID, taskID),
	FOREIGN KEY (employeeID) REFERENCES Employees(userName),
	FOREIGN KEY (taskID) REFERENCES Tasks(taskID)
);