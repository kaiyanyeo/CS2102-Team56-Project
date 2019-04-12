const sql_queries = require('../sql');

const passport = require('passport');
const bcrypt = require('bcrypt');
const LocalStrategy = require('passport-local').Strategy;

const authMiddleware = require('./middleware');
const antiMiddleware = require('./antimiddle');

// Postgre SQL Connection
const { Pool } = require('pg');
// const pool = new Pool({
//     connectionString: process.env.DATABASE_URL,
//     //ssl: true
// });
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'project',
    //   password: '********',
    port: 5432,
})

function findUser(username, callback) {
    pool.query(sql_queries.query.auth_user, [username], (err, data) => {
        if (err) {
            console.error("Cannot find user");
            console.log("Cannot find user", err);
            return callback(null);
        }

        if (data.rows.length == 0) {
            console.error("Account does not exist?");
            console.log("Account does not exist?");
            return callback(null);
        } else if (data.rows.length == 1) {
            // user object attaches to the original request as req.user
            return callback(null, {
                username: data.rows[0].username,
                passwordHash: data.rows[0].pword,
                firstname: data.rows[0].firstname,
                lastname: data.rows[0].lastname
            });
        } else {
            console.error("More than one user?");
            console.log("More than one user?");
            return callback(null);
        }
    });
}

passport.serializeUser(function (user, done) {
    // saved to session
    // req.session.passport.user = {username:...}
    done(null, user.username);
})

passport.deserializeUser(function (username, done) {
    findUser(username, done);
})

function initPassport() {
    passport.use(new LocalStrategy(
        (username, password, done) => {
            findUser(username, (err, user) => {
                if (err) {
                    return done(err);
                }

                // User not found
                if (!user) {
                    return done(null, false);
                }

                // Always use hashed passwords and fixed time comparison
                bcrypt.compare(password, user.passwordHash, (err, isValid) => {
                    if (err) {
                        return done(err);
                    }
                    if (!isValid) {
                        return done(null, false);
                    }
                    console.log('bcrypt valid');
                    return done(null, user);
                })
            })
        }
    ));

    passport.authMiddleware = authMiddleware;
    passport.antiMiddleware = antiMiddleware;
    passport.findUser = findUser;
}

module.exports = initPassport;