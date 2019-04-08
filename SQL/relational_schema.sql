Users (userName: varchar(100), name: varchar(100), gender: char(1), birthDate: date, phoneNumber varchar(15));
Account (userName: varchar(100), password: varchar(25));
Admin (userName: varchar(100), adminId: char(10));
Employer (employerUserName varchar(100));
Employee (employeeUserName varchar(100));
Manages(adminUserName: varchar(100), taskId: char(10));
Posts(employerUserName: varchar(100), taskId: char(10));
Bidding (employeeUserName: varchar(100), timeplaced: timestamp, taskId: char(10));
Task (taskId: char(10), categoryName: varchar(100), startTime: timestamp, endTime: timestamp, taskName: varchar(100), type: varchar(30), pay: numeric, requirement: text)
Category (categoryName: varchar(100), description: text);
Belongs (taskId: char(10), categoryName: varchar(100));
Assigns (employerUserName: varchar(100), employeeUserName; varchar(100), taskId: char(10));
Schedule (employeeUserName: varchar(100), startTime: timestamp, endTime: timestamp);
History (employeeUserName: varchar(100), rating: integer, comments: text);