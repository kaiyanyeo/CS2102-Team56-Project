const sql_queries = require('../sql');
const passport = require('passport');
const bcrypt = require('bcrypt')

// Postgre SQL Connection
const { Pool } = require('pg');
const pool = new Pool({
	connectionString: process.env.DATABASE_URL,
	//ssl: true
});

const round = 10;
const salt = bcrypt.genSaltSync(round);

function initRouter(app) {
	/* GET */
	app.get('/', index);

	/* PROTECTED GET */
	app.get('/register', passport.antiMiddleware(), register);
	app.get('/dashboard', passport.authMiddleware(), dashboard);
	// app.get('/password' , passport.antiMiddleware(), retrieve );

	/* PROTECTED POST */
	app.post('/reg_user', passport.antiMiddleware(), reg_user);

	/* LOGIN */
	app.post('/login', passport.authenticate('local', {
		successRedirect: '/dashboard',
		failureRedirect: '/'
	}));

	/* LOGOUT */
	app.get('/logout', passport.authMiddleware(), logout);
}


// // Render Function
// function basic(req, res, page, other) {
// 	var info = {
// 		page: page,
// 		user: req.user.username,
// 		firstname: req.user.firstname,
// 		lastname : req.user.lastname,
// 		status   : req.user.status,
// 	};
// 	if(other) {
// 		for(var fld in other) {
// 			info[fld] = other[fld];
// 		}
// 	}
// 	res.render(page, info);
// }

// function query(req, fld) {
// 	return req.query[fld] ? req.query[fld] : '';
// }
// function msg(req, fld, pass, fail) {
// 	var info = query(req, fld);
// 	return info ? (info=='pass' ? pass : fail) : '';
// }

// GET
function index(req, res, next) {
	if (!req.isAuthenticated()) {
		res.render('index', { auth: false, userInfo: null });
	} else {
		var info = {
			user: req.user.username,
			firstname: req.user.firstname,
			lastname: req.user.lastname
		};
		res.render('index', { auth: true, userinfo: info });
	}
}

function register(req, res, next) {
	var regResult = req.query.reg;
	res.render('register', { page: 'register', auth: false, regFail: regResult });
}

// user should already be authenticated due to use of authMiddleware
function dashboard(req, res, next) {
	var info = {
		user: req.user.username,
		firstname: req.user.firstname,
		lastname: req.user.lastname
	}

	pool.query(sql_queries.query.retrieve_tasks, [req.user.username], (err, data) => {
		if(err) {
			console.log("Error in retrieving tasks", err);
			res.render('dashboard', { auth: true, userinfo: info, tasks: null });
		} else {
			var tasks = data.rows;
			console.log(data.rows);
			res.render('dashboard', { auth: true, userinfo: info, tasks: tasks });
		}
	});
}

// // POST
function reg_user(req, res, next) {
	var firstname = req.body.firstname;
	var lastname = req.body.lastname;
	var gender = req.body.gender === "Male" ? 'M' : 'F';
	var birthdate = req.body.birthdate;
	var username = req.body.username;
	var password = bcrypt.hashSync(req.body.password, salt);

	// Transaction to be done in sequence
	pool.query(sql_queries.query.create_account, [username, password], (err, data1) => {
		if (err) {
			console.error("Error in creating account", err);
			res.redirect('/register?reg=fail');
		} else {
			pool.query(sql_queries.query.add_user, [firstname, lastname, username, gender, birthdate], (err, data2) => {
				if (err) {
					console.error("Error in adding user", err);
					res.redirect('/register?reg=fail');
				} else {
					pool.query(sql_queries.query.add_employer, [username], (err, data1) => {
						if (err) {
							console.error("Error in adding employer", err);
							res.redirect('/register?reg=fail');
						} else {
							pool.query(sql_queries.query.add_employee, [username], (err, data1) => {
								if (err) {
									console.error("Error in adding employee", err);
									res.redirect('/register?reg=fail');
								} else {
									req.login({
										username: username,
										passwordHash: password,
										firstname: firstname,
										lastname: lastname,
									}, function (err) {
										if (err) {
											console.log('login err');
											return res.redirect('/register?reg=fail');
										} else {
											console.log('user registered');
											return res.redirect('/dashboard');
										}
									});
								}
							});
						}
					});
				}
			});
		}
	});
}


// // LOGOUT
function logout(req, res, next) {
	req.session.destroy();
	req.logout();
	res.redirect('/')
}

module.exports = initRouter;