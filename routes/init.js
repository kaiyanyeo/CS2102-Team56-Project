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
	// app.get('/password' , passport.antiMiddleware(), retrieve );

	/* PROTECTED POST */
	app.post('/reg_user', passport.antiMiddleware(), reg_user);

	/* LOGIN */
	app.post('/login', passport.authenticate('local', {
		successRedirect: '/dashboard',
		failureRedirect: '/'
	}));

	/* LOGOUT */
	// app.get('/logout', passport.authMiddleware(), logout);
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
		res.render('index', { page: '', auth: false });
	} else {
		basic(req, res, 'index', { page: '', auth: true });
	}
}

function register(req, res, next) {
	var regResult = req.query.reg;
	res.render('register', { page: 'register', auth: false, regFail: regResult });
}

// // POST
function reg_user(req, res, next) {
	var firstname = req.body.firstname;
	var lastname = req.body.lastname;
	var gender = req.body.gender === "Male" ? 'M' : 'F';
	var birthdate = req.body.birthdate;
	var username = req.body.username;
	var password = bcrypt.hashSync(req.body.password, salt);
	pool.query(sql_queries.query.create_account, [username, password], (err, data1) => {
		if (err) {
			console.error("Error in creating account", err.detail);
			res.redirect('/register?reg=fail');
		} else {
			pool.query(sql_queries.query.add_user, [firstname, lastname, username, gender, birthdate], (err, data2) => {
				if (err) {
					console.error("Error in adding user", err.detail);
					res.redirect('/register?reg=fail');
				} else {
					console.log('====');
					console.log(data2);
					// req.login({
					// 	username: username,
					// 	passwordHash: password,
					// }, function (err) {
					// 	if (err) {
					// 		console.log('err');
					// 		return res.redirect('/');
					// 	} else {
					// 		return res.redirect('/');
					// 	}
					// });
				}
			});
		}
	});
}


// // LOGOUT
// function logout(req, res, next) {
// 	req.session.destroy()
// 	req.logout()
// 	res.redirect('/')
// }

module.exports = initRouter;