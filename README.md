# CS2102-Team56-Project

## Topic A: Task sourcing
This is a task matching application (e.g., https://www.taskrabbit.com) to facilitate users to hire temporary help to complete certain tasks. Tasks are general chores such as
- washing a car at Kent Vales car park on Sunday
- delivering a parcel on Tuesday between 17:00 and 19:00.

Users of this application are either
- Employers: looking for help to complete some task or
- Employees: bidding to complete some freelance task

The application provides templates for generic common tasks to facilitate task requesters to create new tasks. The successful bidder for a task could either be chosen by the task requester or automatically selected by the system based on some criteria. Each user has an account, and administrators can create/modify/delete entries.

## Requirements and Functionalities
The data models of your application must satisfy the following requirements:
- The ER model have must be at least 10 entity sets (including at least one weak entity set) and at least 10 relationship sets. OR  The ER model must have at least a total of 15 entity/relationship sets with (a) at least one weak entity set, and (b) at least one ISA hierarchy.
    - In both options, a ISA hierarchy itself (represented by the triangle symbol)  is not counted as a relationship set. Each subclass/superclass entity class wrt to a ISA hierarchy could of course participate in relationship set(s).
- There must be at least three non-trivial application constraints that cannot be enforced using column/table constraints (i.e., they must be enforced using triggers).

Each application must provide at least the following functionalities.
- Support the creation/deletion/update of data.
- Support the browsing and searching of data.
- Support at least three interesting complex queries on the data. An example of an interesting query is one that performs some data analysis that provides some insights about your application.

For the final project demo, your application’s database should be loaded with reasonably large tables. To generate data for your application, you can use some online data generators (e.g., https://mockaroo.com, https://www.generatedata.com) or write your own program.

## ER Model
Latest version refer to report.

## Developers' Guide

### Deploy and run
From within the project folder, run
- npm start

Note: Remember to set your .env file with the appropriate parameters.
- DATABASE_URL according to your PostgreSQL set up
- SECRET key

Visit localhost:3000 to access the application. Enjoy!

Run the `SQL/tables.sql` script in your PostgreSQL database to create the tables needed for the application.
Run the `SQL/dummy_data.sql` script in your PostgreSQL database to populate the tables with some dummy data. Mostly for testing.

### Tech stack
- DBMS: PostgreSQL
- Backend: ExpressJS
- Frontend: HTML (in EJS views), CSS, Javascript, Bootstrap
- Others: PassportJS for authentication
