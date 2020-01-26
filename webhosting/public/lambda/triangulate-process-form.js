/*
 Lambda to process Triangulate form and send email. Requires an API Gateway endpoint, a valid SES configuration, 
 and the following environment variables:
 * SENDER_EMAIL
 * RECEIVER_EMAIL
 * SUBJECT
 */
const aws = require('aws-sdk'),
      ses = new aws.SES({ region: 'us-east-1' });

exports.handler = async (event, context, callback) => {
    
    let data = JSON.parse(event.body),
        SENDER = process.env.SENDER_EMAIL,
        receivers = []
    
    receivers.push(process.env.RECEIVER_EMAIL)

    console.log('[debug] form submit', data)

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
        
        console.log('html', html)
        console.log('text', text)
        console.log('receivers', receivers)
        console.log('sender', SENDER)
        
        // send email using ses
        var params = {
            Destination: {
                ToAddresses: receivers
            },
            Message: {
                Body: {
                    Text: {
                        Data: text,
                        Charset: 'UTF-8'
                    },
                    Html: {
                        Data: html,
                        Charset: 'UTF-8'
                    },
                },
                Subject: {
                    Data: process.env.SUBJECT,
                    Charset: 'UTF-8'
                }
            },
            Source: SENDER
        }
        
        console.log('before send', params)
    
        // send email
        const response = await ses.sendEmail(params).promise();

        console.log('after send', response)
        
        // send 200
        callback(null, {
                "isBase64Encoded": false,
                "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
                "statusCode": 200,
                "body": "{\"result\": \"Success.\"}"
            })
        
    }
    catch(e) {
        console.log('error', e)
        
        callback(null, {
            "isBase64Encoded": false,
            "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
            "statusCode": 400,
            "body": "{\"result\": \"Error submitting form.\"}"
        })
    }
    
    console.log('exit')
    
};
