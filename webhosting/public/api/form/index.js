const express = require('express'),
    cors = require('cors'),
    router = express.Router(),
    emailjs = require('emailjs')


var opts = {
    origin: process.env.CORS_ORIGIN,
    optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
    }

/**
  * /api/form/submit
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
router.post('/submit', cors(opts), async (req, res) => {

    let data = req.body

    console.log('[debug] form submit', req.body)

    try {

        let html = '<table style="border-collapse: collapse; border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-top: 1px solid #ddd">',
        text = ''
    
        // parse params
        for(let x=0; x<data.length; x++) {

            html += `<tr>
                        <td style="margin: 0; padding: 10px; border-bottom: 1px solid #ddd; border-right: 1px solid #ddd;">${data[x].label}</td>
                        <td style="margin: 0; padding: 10px; border-bottom: 1px solid #ddd">${data[x].value}</td>
                    </tr>`
            text += `${data[x].label}: ${data[x].value}\n`    
        }
        
        html += '</table>'

        // connect to server, #ref: https://www.npmjs.com/package/emailjs
        var server  = emailjs.server.connect({
            user: process.env.SMTP_USERNAME, 
            password: process.env.SMTP_PASSWORD, 
            host: process.env.SMTP_HOST, 
            ssl: true
         })

        var message = {
           text: text,
           from: `${process.env.EMAIL_FROM} <${process.env.EMAIL_FROM_EMAIL}`,
           to: `${process.env.EMAIL_TO} <${process.env.EMAIL_TO_EMAIL}`,
           subject: process.env.FORM_SUBMISSION_SUBJECT,
           attachment:
           [
              {data: html, alternative: true}
           ]
        }

        // send the message and get a callback with an error or details of the message that was sent
        server.send(message, function(err, message) { console.log(err || message) })

        // send 200       
        res.status(200).send('Form submitted successfully')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error submitting the form')
    }

})

module.exports = router