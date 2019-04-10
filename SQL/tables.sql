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
	adminUserName       varchar(100) references appuser.user (userName),
	adminId             char(10),
	primary key (adminUserName) 
);

create table appuser.employer(
	employerUserName    varchar(100) references appuser.user (userName),
    primary key (employerUserName) 
);

create table appuser.employee(
	employeeUserName    varchar(100) references appuser.user (userName),
	primary key (employeeUserName) 
);


--------------------------------------------------------------

create schema adminAction;

create table adminAction.manages(
	adminUserName       varchar(100),
	taskId              serial,
	foreign key (adminUserName) references appuser.user (userName),
	foreign key (taskId) references employerAction.task (taskId)
);


------------------------------------------------------------------



create schema employerAction;

create table employerAction.task(
	taskId             serial primary key,
	employerUserName   varchar(100) references appuser.uesr(userName),
	categoryName       varchar(100) references taskAction.category(categoryName),
	startTime          timestamp not null,
	endTime            timestamp not null,
	taskName           varchar(100) not null,
	payAmt             numeric not null CHECK (payAmt > 0),
	requirement        text,
	CHECK (startTime <=	 endTime)
);

------------------------------------------------------------


create schema employeeAction;

create table employeeAction.bidding(
	employeeUserName  varchar(100),
	taskId            char(10),
	timePlaced        timestamp,
	foreign key (taskId) references employerAction.task (taskId) ON DELETE CASCADE,
	foreign key (employeeUserName) references appuser.user (userName)
);


create table employeeAction.schedule(
	employeeUserName  varchar(100),
	taskId            serial references employerAction.task (taskId) ON DELETE CASCADE,
	startTime         timestamp not null,
	endTime           timestamp not null,
	foreign key (employeeUserName) references appuser.user (userName)
);


create table employeeAction.history(
	employeeUserName  varchar(100),
	taskName          varchar(100) not null,
	requirement       text,
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

create table taskAction.assigns(
   employerUserName   varchar(100),
   employeeUserName   varchar(100),
   taskId             serial ON DELETE CASCADE,
   foreign key (taskId) references employerAction.task (taskId),
   foreign key (employerUserName) references appuser.user (userName),
   foreign key (employeeUserName) references appuser.user (userName)
);

----------------------------------------------------------