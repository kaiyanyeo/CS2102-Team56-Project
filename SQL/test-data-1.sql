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

INSERT INTO Accounts (userName, pword) VALUES
('user1', '1234'),
('user2', '4321'),
('admin1', 'admin');

INSERT INTO Users (firstName, lastName, userName, gender, birthDate) VALUES
('Bobby', 'Tan', 'user1', 'M', '1983-12-25'),
('Mary', 'Sue', 'user2', 'F', '1994-11-01'),
('Mark', 'Admin', 'admin1', 'M', '1963-05-05');

INSERT INTO Admins (id, userName) VALUES
(0, 'admin1');

INSERT INTO Employees (userName, numOfCompletedJobs) VALUES
('user1', 27),
('user2', 4),
('admin1', 0);

INSERT INTO Employers (userName) VALUES
('user1'),
('user2'),
('admin1');

INSERT INTO Categories (name) VALUES
('Manual Labour'),
('Bug Extermination'),
('Tech Support'),
('Driving'),
('Temporary Sales'),
('Proofreading');

INSERT INTO Tasks (taskID, title, employerName, startDate, startTime, endTime, duration, payAmt, categoryName, requirement) VALUES
(1, 'Help me move house', 'user1', '2019-04-11', '08:00:00', '16:00:00', 8, 10, 'Manual Labour', 0),
(2, 'Mow Lawn', 'user2','2019-05-16', '08:00:00', '9:00:00', 1, 8, 'Manual Labour', 0),
(3, 'Recover files from broken hard disk', 'user1', '2019-06-06', '13:00:00', '16:00:00', 3, 25, 'Tech Support', 1),
(4, 'Finish my thesis for me', 'user2', '2019-06-19', '08:00:00', '16:00:00', 8, 50, 'Proofreading', 1);

INSERT INTO Posts (postDate, taskID, employerID) VALUES
('2019-04-01', 1, 'user1'),
('2019-04-08', 2, 'user2'),
('2019-04-09', 3, 'user1');

INSERT INTO Assigns (assignID, taskID, employeeID) VALUES
(1, 2, 'user1'),
(2, 3, 'user2');

INSERT INTO Schedules (employeeID, taskID, taskDate, timeStart, timeEnd) VALUES
('user1', 1, '2019-05-16', '08:00:00', '9:00:00'),
('user2', 2, '2019-06-06', '13:00:00', '16:00:00');

INSERT INTO History (userName, taskId, rating, comments) VALUES
('user2', '1', 5, 'Good at carrying boxes. Finished very quickly');

INSERT INTO Biddings (employeeID, taskId, timePlaced) VALUES
('user1', 4, '2019-05-16 15:23:45');