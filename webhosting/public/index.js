const express = require('express'),
    session = require("express-session"),
    setup = require('./api/setup'),
    page = require('./api/page'),
    image = require('./api/image'),
    file = require('./api/file'),
    menu = require('./api/menu'),
    form = require('./api/form'),
    user = require('./api/user'),
    app = express(),
    port = 3000,
    path = require('path'),
    bcrypt = require('bcrypt'),
    passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy,
    common = require('./api/common.js'),
    env = require('dotenv').config()

// set app root
global.appRoot = path.resolve(__dirname)

// setup passport (see https://github.com/passport/express-4.x-local-example/blob/master/server.js)
passport.use(new LocalStrategy(
    function(username, password, done) {

        let email = username,
            user = common.findUser(email)

        if(user == null) return done(null, false, { message: 'Incorrect username' })
        else {
            if(bcrypt.compareSync(password, user.password) == true) return done(null, user)
            else return done(null, false, { message: 'Incorrect password' })
        }

    }))

passport.serializeUser(function(user, done) {
        done(null, user.email);
    })

passport.deserializeUser(function(email, done) {
        let user = common.findUser(email)
        done(null, user);
    })

app.use(session({ secret: 'make it so', resave: false, saveUninitialized: false }));

// Initialize Passport and restore authentication state, if any, from the
// session.
app.use(require('body-parser').urlencoded({ extended: true }));
app.use(passport.initialize());
app.use(passport.session());

// handle login post
app.post('/login',
  passport.authenticate('local', { successRedirect: '/edit?page=/index.html',
                                   failureRedirect: '/login?error=true' }));

// setup public ui routes
app.use('/', express.static('site'))
app.use('/modules', express.static('modules'))
app.use('/setup', express.static('views/setup'))
app.use('/select', express.static('views/select'))
app.use('/login', express.static('views/login'))
app.use('/forgot', express.static('views/forgot'))
app.use('/reset', express.static('views/reset'))
app.use('/resources', express.static('resources'))

// authenticate 
var auth = function (req, res, next) {
    if(req.isAuthenticated())next()
    else res.redirect('/login')
}

// setup auth ui routes
app.get('/edit', 
    auth,
    function(req, res) {
        res.sendFile(path.join(__dirname + '/views/edit/index.html'))
    })

// setup api routes
app.use(express.json({limit: '50mb'}))

app.use('/api/setup', setup)
app.use('/api/page', page)
app.use('/api/image', image)
app.use('/api/file', file)
app.use('/api/menu', menu)
app.use('/api/form', form)
app.use('/api/user', user)

app.get('/', (req, res) => res.send(`<html>
    <head><title>Welcome to Triangulate</title></head>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,800&display=swap" rel="stylesheet">
    <link type="text/css" href="/resources/css/start.css" rel="stylesheet">
    <body>
        <p><img class="logo" src="/resources/triangulate-logo.svg"></p>
        <p>Thank you for building your site with Triangulate!  You can learn more about Triangulate at <a href="https://triangulate.io">triangulate.io</a>.</p>
        <p><a class="setup" href="setup">Setup your site now</a</p>
    </body>
</html>`))

app.listen(port, () => console.log(`Triangulate app listening on port ${port}!`))
