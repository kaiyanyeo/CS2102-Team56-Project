CREATE SCHEMA Users;

CREATE TABLE Users.account(
	userName        VARCHAR(100),
	passwordHash    VARCHAR(64) NOT NULL,
	FOREIGN KEY (userName) REFERENCES Users.user (userName)
);

CREATE TABLE Users.user(
	userName            VARCHAR(100) PRIMARY KEY,
	name                VARCHAR(100),
	gender              CHAR(1),
	birthDate           DATE,
    phoneNumber         VARCHAR(15)
);

CREATE TABLE Users.admin(
	adminUserName       VARCHAR(100),
	adminId             CHAR(10),
	FOREIGN KEY (adminUserName) REFERENCES Users.user (userName)
);

CREATE TABLE Users.employer(
	employerUserName    VARCHAR(100),
    FOREIGN KEY (employerUserName) REFERENCES Users.user (userName)
);

CREATE TABLE Users.employee(
	employeeUserName    VARCHAR(100),
	FOREIGN KEY (employeeUserName) REFERENCES Users.user (userName)
);



--------------------------------------------------------------

CREATE SCHEMA AdminActions;

CREATE TABLE AdminActions.manages(
	adminUserName       VARCHAR(100),
	taskId              CHAR(10),
	FOREIGN KEY (adminUserName) REFERENCES Users.user (userName),
	FOREIGN KEY (taskId) REFERENCES EmployerActions.task (taskId)
);


------------------------------------------------------------------



CREATE SCHEMA EmployerActionss;

CREATE TABLE EmployerActions.posts(
	employerUserName   VARCHAR(100),
	taskId             CHAR(10),
	FOREIGN KEY (employerUserName) REFERENCES Users.user (userName),
	FOREIGN KEY (taskId) REFERENCES EmployerActions.task (taskId)
);

CREATE TABLE EmployerActions.task(
	taskId             CHAR(10) PRIMARY KEY,
	categoryName       VARCHAR(100),
	startTime          TIMESTAMP NOT NULL,
	endTime            TIMESTAMP NOT NULL,
	taskName           VARCHAR(100) NOT NULL,
	type               VARCHAR(30),
	pay                NUMERIC NOT NULL,
	requirement        TEXT
);


------------------------------------------------------------


CREATE SCHEMA EmployeeActions;

CREATE TABLE EmployeeActions.bidding(
	employeeUserName  VARCHAR(100),
	taskId            CHAR(10),
	timePlaced        TIMESTAMP,
	FOREIGN KEY (taskId) REFERENCES EmployerActions.task (taskId),
	FOREIGN KEY (employeeUserName) REFERENCES Users.user (userName)
);


CREATE TABLE EmployeeActions.schedule(
	employeeUserName  VARCHAR(100),
	startTime         TIMESTAMP NOT NULL,
	endTime           TIMESTAMP NOT NULL,
	FOREIGN KEY (employeeUserName) REFERENCES Users.user (userName)
);


CREATE TABLE EmployeeActions.history(
	employeeUserName  VARCHAR(100),
	rating            INTEGER NOT NULL,
	comments          TEXT NOT NULL,
	FOREIGN KEY (employeeUserName) REFERENCES Users.user (userName)
);


-----------------------------------------------------------


CREATE schema TaskActions;

CREATE TABLE TaskActions.category(
	categoryName      VARCHAR(100) PRIMARY KEY,
	description       TEXT
);


CREATE TABLE TaskActions.belongs(
	taskId            CHAR(10),
	categoryName      VARCHAR(100),
    FOREIGN KEY (taskId) REFERENCES EmployerActions.task (taskId),
    FOREIGN KEY (categoryname) REFERENCES TaskActions.category (categoryName)
);

CREATE TABLE TaskActions.assigns(
   employerUserName   VARCHAR(100),
   employeeUserName   VARCHAR(100),
   taskId             CHAR(10),
   FOREIGN KEY (taskId) REFERENCES EmployerActions.task (taskId),
   FOREIGN KEY (employerUserName) REFERENCES Users.user (userName),
   FOREIGN KEY (employeeUserName) REFERENCES Users.user (userName)
);

----------------------------------------------------------