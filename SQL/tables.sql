create schema appuser;

create table appuser.account(
	userName        varchar(100),
	password        varchar(25) not null,
	foreign key (userName) references appuser.user (userName)
);

create table appuser.user(
	userName            varchar(100) primary key,
	name                varchar(100),
	gender              char(1),
	birthDate           date,
    phoneNumber         varchar(15)
);

create table appuser.admin(
	adminUserName       varchar(100),
	adminId             char(10),
	foreign key (adminUserName) references appuser.user (userName)
);

create table appuser.employer(
	employerUserName    varchar(100),
    foreign key (employerUserName) references appuser.user (userName)
);

create table appuser.employee(
	employeeUserName    varchar(100),
	foreign key (employeeUserName) references appuser.user (userName)
);



--------------------------------------------------------------

create schema adminAction;

create table adminAction.manages(
	adminUserName       varchar(100),
	taskId              char(10),
	foreign key (adminUserName) references appuser.user (userName),
	foreign key (taskId) references employerAction.task (taskId)
);


------------------------------------------------------------------



create schema employerAction;

create table employerAction.posts(
	employerUserName   varchar(100),
	taskId             char(10),
	foreign key (employerUserName) references appuser.user (userName),
	foreign key (taskId) references employerAction.task (taskId)
);

create table employerAction.task(
	taskId             char(10) primary key,
	categoryName       varchar(100),
	startTime          timestamp not null,
	endTime            timestamp not null,
	taskName           varchar(100) not null,
	type               varchar(30),
	pay                numeric not null,
	requirement        text
);


------------------------------------------------------------


create schema employeeAction;

create table employeeAction.bidding(
	employeeUserName  varchar(100),
	taskId            char(10),
	timePlaced        timestamp,
	foreign key (taskId) references employerAction.task (taskId),
	foreign key (employeeUserName) references appuser.user (userName)
);


create table employeeAction.schedule(
	employeeUserName  varchar(100),
	startTime         timestamp not null,
	endTime           timestamp not null,
	foreign key (employeeUserName) references appuser.user (userName)
);


create table employeeAction.history(
	employeeUserName  varchar(100),
	rating            integer not null,
	comments          text not null,
	foreign key (employeeUserName) references appuser.user (userName)
);


-----------------------------------------------------------


create schema taskAction;

create table taskAction.category(
	categoryName      varchar(100) primary key,
	description       text
);


create table taskAction.belongs(
	taskId            char(10),
	categoryName      varchar(100),
    foreign key (taskId) references employerAction.task (taskId),
    foreign key (category Name) references taskAction.category (categoryName)
);

create table taskAction.assigns(
   employerUserName   varchar(100),
   employeeUserName   varchar(100),
   taskId             char(10),
   foreign key (taskId) references employerAction.task (taskId),
   foreign key (employerUserName) references appuser.user (userName),
   foreign key (employeeUserName) references appuser.user (userName)
);

----------------------------------------------------------