const express = require('express'),
    router = express.Router(),
    path = require('path'),
    fs = require('fs'),
    cheerio = require('cheerio'),
    common = require('../common.js')

/**
  * /api/page/save
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
router.post('/save', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body,
        content = body.html,
        url = body.url,
        template = 'default'

    console.log('[debug] save', req.body)

    try {

        // get existing page
        let html = fs.readFileSync(`${global.appRoot}/site/${url}`, 'utf8')

        // load html
        let $ = cheerio.load(html)

        // replace main
        $('[role="main"]').html(content)

        // save file
        fs.writeFileSync(`${global.appRoot}/site/${url}`, $.html(), 'utf8')

        // get page
        let page = common.retrievePage(url)

        console.log('[debug] page', page)

        // publish page
        if(page != null) {
            common.publishPage(page)

            // generate sitemap
            common.generateSiteMap()
        }
        
        // send 200       
        res.status(200).send('Page saved successfully')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/list
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.get('/list', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body

    console.log('[debug] list', req.body)

    try {

        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send(json)

    }
    catch(e) {
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/templates/list
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/templates/list', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body

    console.log('[debug] list templates', req.body)

    try {

        let files = fs.readdirSync(`${global.appRoot}/site/templates/`), arr = []

        for(let x=0; x<files.length; x++) {

            // get stats for file
            let stats = fs.statSync(`${global.appRoot}/site/templates/${files[x]}`),
                ext = path.extname(`${global.appRoot}/site/templates/${files[x]}`),
                template = ''

            if(stats.isFile()) {

                // check for image
                if(ext == '.html') {
                    template = files[x].replace('.html', '')

                    arr.push(template)
                }
            }
        }
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send(arr)

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error listing the templates')
    }

})

/**
  * /api/page/components/list
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/components/list', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body

    console.log('[debug] list components', req.body)

    try {

        let files = fs.readdirSync(`${global.appRoot}/site/components/`), arr = []

        for(let x=0; x<files.length; x++) {

            // get stats for file
            let stats = fs.statSync(`${global.appRoot}/site/components/${files[x]}`),
                ext = path.extname(`${global.appRoot}/site/components/${files[x]}`),
                component = ''

            if(stats.isFile()) {

                // check for image
                if(ext == '.html') {
                    component = files[x].replace('.html', '')

                    arr.push(component)
                }
            }
        }
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send(arr)

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error listing the components')
    }

})

/**
  * /api/page/retrieve
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/retrieve', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body,
        url = body.url

    console.log('[debug] list', req.body)

    try {

        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8'),
            objs = JSON.parse(json)

        for(let x=0; x<objs.length; x++) {
            if(objs[x].url == url) {
                // send 200       
                res.setHeader('Content-Type', 'application/json')
                res.status(200).send(JSON.stringify(objs[x]))
            }
        }
        
        res.status(400).send('No page found')

    }
    catch(e) {
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/elements.list
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.get('/elements/list', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let body = req.body

    console.log('[debug] list elemenets', req.body)

    try {

        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/elements.json`, 'utf8')
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send(json)

    }
    catch(e) {
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/add
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/add', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let user = common.findUser(req.user.email),
        firstName = "Default",
        lastName = "User"

    // set first and last name
    if(user.firstName) firstName = user.firstName
    if(user.lastName) lastName = user.lastName

    console.log('[debug] user', req.user)

    let body = req.body,
        name = body.name,
        url = body.url,
        type = body.type,
        description = body.description,
        template = 'default'

    // clear leading slash
    if (url.charAt(0) == "/") url = url.substr(1)

    // remove file extension
    if(url.indexOf('.htm') != -1) url = url.split('.').slice(0, -1).join('.')
    
    // add html extension
    url = url += '.html'

    console.log('[debug] save', req.body)

    try {
    
        // settings
        let settings = {
            "name": name,
            "callout": '',
            "description": description,
            "url": url,
            "type": type,
            "template": template,
            "text": "",
            "keywords": "",
            "tags": "",
            "image": "",
            "location": "",
            "language": "en",
            "direction": "ltr",
            "firstName": firstName,
            "lastName": lastName,
            "lastModifiedBy": firstName + ' ' + lastName,
            "lastModifiedDate": (new Date()).toUTCString(),
            "customHeader": "",
            "customFooter": ""
        }

        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')

        // read json
        let pages = JSON.parse(json)

        // check to see if page exists
        for(let x=0; x<pages.length; x++) {
            if(pages[x].url == url) {
                res.status(400).send('Page already exists')
                return
            }
        }

        // publish page
        common.publishPage(settings)

        // generate sitemap
        common.generateSiteMap()
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send('Ok')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/settings
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/settings', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let user = common.findUser(req.user.email),
        firstName = "Default",
        lastName = "User"

    // set first and last name
    if(user.firstName) firstName = user.firstName
    if(user.lastName) lastName = user.lastName

    console.log('[debug] user', req.user)

    let body = req.body,
        url = body.url,
        name = body.name,
        callout = body.callout,
        description = body.description,
        keywords = body.keywords,
        tags = body.tags,
        location = body.location,
        image = body.image,
        language = body.language,
        direction = body.direction,
        template = body.template,
        customHeader = body.customHeader,
        customFooter = body.customFooter,
        settings = null

    try {

        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8'),
            objs = JSON.parse(json)

        for(let x=0; x<objs.length; x++) {
            if(objs[x].url == url) {

                // set settings
                settings = objs[x]

                // update settings
                settings.name = name
                settings.callout = callout
                settings.description = description
                settings.keywords = keywords
                settings.tags = tags
                settings.location = location
                settings.image = image
                settings.language = language
                settings.direction = direction
                settings.template = template
                settings.customHeader = customHeader
                settings.customFooter = customFooter

                // republish
                common.publishPage(settings)

                // generate sitemap
                common.generateSiteMap()

                // send 200       
                res.setHeader('Content-Type', 'application/json')
                res.status(200).send(JSON.stringify(settings))
            }
        }
        
        res.status(400).send('No page found')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/page/remove
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
 router.post('/remove', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let user = common.findUser(req.user.email),
        firstName = "Default",
        lastName = "User"

    // set first and last name
    if(user.firstName) firstName = user.firstName
    if(user.lastName) lastName = user.lastName

    console.log('[debug] user', req.user)

    let body = req.body,
        url = body.url

    // clear leading slash
    if (url.charAt(0) == "/") url = url.substr(1)

    // remove file extension
    if(url.indexOf('.htm') != -1) url = url.split('.').slice(0, -1).join('.')
    
    // add html extension
    url = url += '.html'

    console.log('[debug] remove', req.body)

    try {
    
        // get json
        let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')

        // read json
        let pages = JSON.parse(json)

        // remove page
        for(let x=0; x<pages.length; x++) {
            if(pages[x].url == url) {
                pages.splice(x, 1);
            }
        }

        console.log('[debug] removing', `${global.appRoot}/site/${url}`)

        // remove file
        fs.unlinkSync(`${global.appRoot}/site/${url}`)

         // save json file
        fs.writeFileSync(`${global.appRoot}/site/data/pages.json`, JSON.stringify(pages), 'utf8')
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send('Ok')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the page')
    }

})

module.exports = router