DELETE from biddings;
DELETE from history;
DELETE from schedules;
DELETE from assigns;
DELETE from posts;
DELETE from tasks;
DELETE from categories;
DELETE from employers;
DELETE from employees;
DELETE from admins;
DELETE from users;
DELETE from accounts;

-- INSERT USERS
INSERT INTO Accounts(username,pword) VALUES ('test@hello.com', '$2b$10$B68w41fUDsuTgMvN4KyMVu90zjwVJ8TgGN7StMPo5KOfzmMhFGJ2G');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('hello', 'world', 'test@hello.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('test@hello.com');
INSERT INTO Employees(username) VALUES ('test@hello.com');

INSERT INTO Accounts(username,pword) VALUES ('dfsad@example.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('dfsad', 'dsf', 'dfsad@example.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('dfsad@example.com');
INSERT INTO Employees(username) VALUES ('dfsad@example.com');

INSERT INTO Accounts(username,pword) VALUES ('bobby@hotmail.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('Bobby', 'Tan', 'bobby@hotmail.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('bobby@hotmail.com');
INSERT INTO Employees(username) VALUES ('bobby@hotmail.com');

INSERT INTO Accounts(username,pword) VALUES ('mary@gmail.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('Mary', 'Sue', 'mary@gmail.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('mary@gmail.com');
INSERT INTO Employees(username) VALUES ('mary@gmail.com');

INSERT INTO Accounts(username,pword) VALUES ('mark@yahoo.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('Mark', 'Lim', 'mark@yahoo.com', 'M', '1990-08-19');
INSERT INTO Employers(username) VALUES ('mark@yahoo.com');
INSERT INTO Employees(username) VALUES ('mark@yahoo.com');

-- INSERT ADMINS
-- INSERT INTO Accounts(username,pword) VALUES ('admin01@website.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
-- INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('One', 'Admin', 'admin01@website.com', 'M', '1990-08-19');
-- INSERT INTO Admins (id, userName) VALUES ('admin01', 'admin01@website.com');

-- INSERT INTO Accounts(username,pword) VALUES ('admin02@website.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
-- INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('Two', 'Admin', 'admin02@website.com', 'M', '1990-08-19');
-- INSERT INTO Admins (id, userName) VALUES ('admin02', 'admin02@website.com');

-- INSERT INTO Accounts(username,pword) VALUES ('admin03@website.com', '$2b$10$V9g/zRLCqzkLv5o7KKPwbuNFOeP.aMc27wstSfYTmWmqijdYQAQcC');
-- INSERT INTO Users(firstname,lastname,username,gender,birthdate) VALUES ('Three', 'Admin', 'admin03@website.com', 'M', '1990-08-19');
-- INSERT INTO Admins (id, userName) VALUES ('admin03', 'admin03@website.com');

-- INSERT CATEGORIES
INSERT INTO Categories (name) VALUES
('Service'),
('Manual Labour'),
('Bug Extermination'),
('Tech Support'),
('Driving'),
('Temporary Sales'),
('Specialised'),
('Household'),
('Proofreading');

-- INSERT TASKS
INSERT INTO TASKS(title, employername, startdate, duration, payamt, categoryname, requirement) VALUES
('Wash car', 'test@hello.com', '2019-04-20', 1, 12, 'Service', 1),
('Build IKEA furniture', 'dfsad@example.com', '2019-04-28', 5, 48, 'Manual Labour', 1),
('Package delivery', 'test@hello.com', '2019-04-28', 1, 20, 'Driving', 1),
('Wash aircon', 'dfsad@example.com', '2019-04-24', 6, 65, 'Specialised', 2),
('Need plumber for leaky tap', 'dfsad@example.com', '2019-04-19', 6, 65, 'Specialised', 2),
('Babysitting', 'test@hello.com', '2019-05-01', 2, 45, 'Household', 1);
('Help me move house', 'bobby@hotmail.com', '2019-05-11', 8, 100, 'Manual Labour', 0),
('Mow Lawn', 'mary@gmail.com','2019-05-16', 1, 8, 'Manual Labour', 0),
('Recover files from broken hard disk', 'mark@yahoo.com', '2019-05-16', 3, 25, 'Tech Support', 1),
('Finish my thesis for me', 'bobby@hotmail.com', '2019-06-19', 8, 50, 'Proofreading', 1);


-- INSERT INTO Tasks (taskID, title, employerName, startDate, startTime, endTime, duration, payAmt, categoryName, requirement) VALUES
-- (1, 'Help me move house', 'user1', '2019-04-11', '08:00:00', '16:00:00', 8, 10, 'Manual Labour', 0),
-- (2, 'Mow Lawn', 'user2','2019-05-16', '08:00:00', '9:00:00', 1, 8, 'Manual Labour', 0),
-- (3, 'Recover files from broken hard disk', 'user1', '2019-06-06', '13:00:00', '16:00:00', 3, 25, 'Tech Support', 1),
-- (4, 'Finish my thesis for me', 'user2', '2019-06-19', '08:00:00', '16:00:00', 8, 50, 'Proofreading', 1);

INSERT INTO Biddings (employeeID, taskId, timePlaced) VALUES
('test@hello.com', 4, '2019-02-16 19:23:45'),
('test@hello.com', 2, '2019-03-10 11:40:45'),
('bobby@hotmail.com', 5, '2019-01-06 15:13:45'),
('bobby@hotmail.com', 9, '2019-02-11 15:33:45'),
('mark@yahoo.com', 7, '2019-03-27 15:03:15'),
('mary@gmail.com', 6, '2019-01-02 15:53:35'),
('mark@yahoo.com', 6, '2019-01-03 15:53:35'),
('bobby@hotmail.com', 6, '2019-01-03 15:58:35'),
('test@hello.com', 6, '2019-01-04 09:28:35');

INSERT INTO Assigns (taskID, employeeID) VALUES
(1, 'test@hello.com'),	-- completed
(3, 'mary@gmail.com'),	-- not completed
(10, 'mark@yahoo.com');

INSERT INTO Schedules (employeeID, assignid, taskDate, timeStart, timeEnd) VALUES
('test@hello.com', 1),
('mary@gmail.com', 2);

INSERT INTO History (employeeName, employerName, assignid, rating, comments) VALUES
('test@hello.com', 'dfsad@example.com', '1', 5, 'Good at carrying boxes. Finished very quickly');

