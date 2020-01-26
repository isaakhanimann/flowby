const express = require('express'),
    router = express.Router(),
    emailjs = require('emailjs'),
    bcrypt = require('bcrypt'),
    common = require('../common.js')

/**
  * /api/user/forgot
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
router.post('/forgot', async (req, res) => {

    let body = req.body,
        email = body.email

    try {

        let user = common.findUser(email)
            
        if(user != null) {

            token = common.createResetTokenForUser(user.email, common.makeid(10))

            if(token != null) {

                let html = `<h2>Reset your Password</h2><p>Use the following token to reset your password: ${token}</p>`,
                    text = `Reset your password: Use the following token to reset your password: ${token}`
            
                // connect to server, #ref: https://www.npmjs.com/package/emailjs
                var server  = emailjs.server.connect({
                    user: process.env.SMTP_USERNAME, 
                    password: process.env.SMTP_PASSWORD, 
                    host: process.env.SMTP_HOST, 
                    ssl: true
                })

                var message = {
                    text: text,
                    from: `${process.env.EMAIL_FROM} <${process.env.EMAIL_FROM_EMAIL}>`,
                    to: `${user.firstName} ${user.lastName} <${user.email}>`,
                    subject: process.env.RESET_SUBJECT,
                    attachment:
                    [
                        {data: html, alternative: true}
                    ]
                }

                // send the message and get a callback with an error or details of the message that was sent
                server.send(message, function(err, message) { console.log(err || message) })

                // send 200       
                res.status(200).send('Email sent')
            }
            else {
                res.status(400).send('There was an error sending the email')
            }
        }
        else {
            res.status(400).send('There was an error sending the email')
        }

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error sending the email')
    }

})

/**
  * /api/user/reset
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/reset', async (req, res) => {

    let body = req.body,
        email = body.email,
        token = body.token,
        password = body.password

    try {

        let user = common.findUser(email)

        if(user != null) {

            // make sure the token is not empty and it equals the stored token
            if(token != '' && (user.token == token)) {

                let hash = await bcrypt.hash(password, 10)

                common.updatePassword(email, hash)

                let html = `<h2>Password Updated</h2><p>Your password has been updated.  If this is an error please contact your administrator.</p>`,
                    text = `Password Updated: Your password has been updated.  If this is an error please contact your administrator.`
            
                // connect to server, #ref: https://www.npmjs.com/package/emailjs
                var server  = emailjs.server.connect({
                    user: process.env.SMTP_USERNAME, 
                    password: process.env.SMTP_PASSWORD, 
                    host: process.env.SMTP_HOST, 
                    ssl: true
                })

                var message = {
                    text: text,
                    from: `${process.env.EMAIL_FROM} <${process.env.EMAIL_FROM_EMAIL}>`,
                    to: `${user.firstName} ${user.lastName} <${user.email}>`,
                    subject: process.env.RESET_SUBJECT,
                    attachment:
                    [
                        {data: html, alternative: true}
                    ]
                }

                // send the message and get a callback with an error or details of the message that was sent
                server.send(message, function(err, message) { console.log(err || message) })

                // send 200       
                res.status(200).send('Email sent')
            }
            else {
                res.status(400).send('There was an error resetting your password')
            }
        }
        else {
            res.status(400).send('There was an error resetting your password')
        }

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error resetting your password')
    }

})

module.exports = router