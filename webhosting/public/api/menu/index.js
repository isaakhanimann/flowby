const express = require('express'),
    router = express.Router(),
    fs = require('fs'),
    common = require('../common.js')

/**
  * /api/menu/save
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
        type = body.type,
        html = body.html

    console.log('[debug] save', req.body)

    try {

        // save file
        fs.writeFileSync(`${global.appRoot}/site/components/menu-${type}.html`, html, 'utf8')

        // republish pages
        let pages = common.retrievePages()

        pages.forEach(page => {
            common.publishPage(page)
        });
        
        // generate sitemap
        common.generateSiteMap()

        // send 200       
        res.status(200).send('Page saved successfully')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the page')
    }

})

/**
  * /api/menu/retrieve
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
        type = body.type

    console.log('[debug] retrieve', req.body)

    try {

        // get json
        let html = fs.readFileSync(`${global.appRoot}/site/components/menu-${type}.html`, 'utf8')

        res.setHeader('Content-Type', 'text/html')
        res.status(200).send(html)

    }
    catch(e) {
        res.status(400).send('There was an error saving the page')
    }

})

module.exports = router