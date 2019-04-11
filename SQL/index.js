const sql = {}

sql.query = {
    // Login
    auth_user: 'SELECT A.username, pword, firstname, lastname FROM Accounts A INNER JOIN Users U ON A.username = U.username WHERE A.username=$1',

    // register
    create_account: 'INSERT INTO Accounts (username, pword) VALUES ($1,$2)',
    add_user: 'INSERT INTO Users(firstname, lastname, username, gender, birthdate) VALUES ($1,$2,$3,$4,$5)',
    add_employer: 'INSERT INTO Employers(username) VALUES ($1)',
    add_employee: 'INSERT INTO Employees(username) VALUES ($1)',

    // Get own tasks
    get_own_tasks: 'SELECT * FROM Tasks WHERE employername = $1',
    get_other_tasks: 'SELECT * FROM Tasks WHERE employername <> $1',

    // Task actions
    delete_task: 'DELETE FROM Tasks WHERE taskid = $1',
    get_single_task: 'SELECT * FROM Tasks WHERE taskid = $1',
    edit_task: 'UPDATE Tasks SET title=$1, startdate=$2, duration=$3, payamt=$4 where taskid=$5',

    // Get Number of postings by each employer
    get_postings: 'SELECT count(*) from Employers e1 LEFT JOIN employerAction.posts p1 ON e1.employerUserName = p1.employerUserName GROUP BY e1.employerUserName',

    // Get Number of Jobs done by the Employee in the past
    get_num_history: 'SELECT count(*) from appuser.employee e1 LEFT JOIN employeeAction.history h1 ON e1.employeeUserName = h1.employeeUserName GROUP BY e1.employeeUserName',

    // Get user with the most task at hand right for each category
    get_busiest_user: 'SELECT c1.employeeUserName, categoryName, count(*) FROM (appuser.employee e1 LEFT JOIN taskAction.assigns a1 ON e1.employeeUserName = a1.employeeUserName as c1) NATURAL JOIN taskAction.category c2 GROUP BY employeeUserName, categoryName'
}

module.exports = sql