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