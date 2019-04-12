var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('login');
});

// app.get('../register', function (req, res, next) {
//   res.render('join', { title: "Join", userData: req.user, messages: { danger: req.flash('danger'), warning: req.flash('warning'), success: req.flash('success') } });
// });


// app.post('/join', async function (req, res) {
//   try {
//     const client = await pool.connect()
//     await client.query('BEGIN')
//     var pwd = await bcrypt.hash(req.body.password, 5);
//     await JSON.stringify(client.query('SELECT id FROM "users" WHERE "email"=$1', [req.body.username], function (err, result) {
//       if (result.rows[0]) {
//         req.flash('warning', "This email address is already registered. <a href='/login'>Log in!</a>");
//         res.redirect('/join');
//       }
//       else {
//         client.query('INSERT INTO users (id, "firstName", "lastName", email, password) VALUES ($1, $2, $3, $4, $5)', [uuidv4(), req.body.firstName, req.body.lastName, req.body.username, pwd], function (err, result) {
//           if (err) { console.log(err); }
//           else {

//             client.query('COMMIT')
//             console.log(result)
//             req.flash('success', 'User created.')
//             res.redirect('/login');
//             return;
//           }
//         });


//       }

//     }));
//     client.release();
//   }
//   catch (e) { throw (e) }
// });

// app.get('../', function (req, res, next) {
//   if (req.isAuthenticated()) {
//     res.render('account', { title: "Account", userData: req.user, userData: req.user, messages: { danger: req.flash('danger'), warning: req.flash('warning'), success: req.flash('success') } });
//   }
//   else {
//     res.redirect('/login');
//   }
// });

// app.get('/login', function (req, res, next) {
//   if (req.isAuthenticated()) {
//     res.redirect('/account');
//   }
//   else {
//     res.render('login', { title: "Log in", userData: req.user, messages: { danger: req.flash('danger'), warning: req.flash('warning'), success: req.flash('success') } });
//   }

// });

// app.get('/logout', function (req, res) {

//   console.log(req.isAuthenticated());
//   req.logout();
//   console.log(req.isAuthenticated());
//   req.flash('success', "Logged out. See you soon!");
//   res.redirect('/');
// });

// app.post('/login', passport.authenticate('local', {
//   successRedirect: '/account',
//   failureRedirect: '/login',
//   failureFlash: true
// }), function (req, res) {
//   if (req.body.remember) {
//     req.session.cookie.maxAge = 30 * 24 * 60 * 60 * 1000; // Cookie expires after 30 days
//   } else {
//     req.session.cookie.expires = false; // Cookie expires at end of session
//   }
//   res.redirect('/');
// });

// passport.use('local', new LocalStrategy({ passReqToCallback: true }, (req, username, password, done) => {
//   loginAttempt();
//   async function loginAttempt() {

//     const client = await pool.connect()
//     try {
//       await client.query('BEGIN')
//       var currentAccountsData = await JSON.stringify(client.query('SELECT id, "firstName", "email", "password" FROM "users" WHERE "email"=$1', [username], function (err, result) {

//         if (err) {
//           return done(err)
//         }
//         if (result.rows[0] == null) {
//           req.flash('danger', "Oops. Incorrect login details.");
//           return done(null, false);
//         }
//         else {
//           bcrypt.compare(password, result.rows[0].password, function (err, check) {
//             if (err) {
//               console.log('Error while checking password');
//               return done();
//             }
//             else if (check) {
//               return done(null, [{ email: result.rows[0].email, firstName: result.rows[0].firstName }]);
//             }
//             else {
//               req.flash('danger', "Oops. Incorrect login details.");
//               return done(null, false);
//             }
//           });
//         }
//       }))
//     }
//     catch (e) { throw (e); }
//   };

// }
// ))

// passport.serializeUser(function (user, done) {
//   done(null, user);
// });

// passport.deserializeUser(function (user, done) {
//   done(null, user);
// });

module.exports = router;