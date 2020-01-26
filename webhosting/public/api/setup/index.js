const express = require('express'),
    router = express.Router(),
    fs = require('fs'),
    fse = require('fs-extra'),
    bcrypt = require('bcrypt'),
    path = require('path'),
    uglifycss = require('uglifycss'),
    common = require('../common.js')

/**
  * /api/setup
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
router.post('/', async (req, res) => {

    let body = req.body,
        email = body.email,
        password = body.password,
        html = body.html,
        template = body.template,
        variables = body.variables,
        json = body.json,
        editorHTML = body.editorHTML,
        file = '',
        source = '',
        content = '',
        page = '',
        files = [],
        hash = '',
        site = {}

    // check to see if a site already exists before builiding a new site
    if (fs.existsSync(`${global.appRoot}/index.html`)) {
        res.status(400).send('A site already exists')
    }
    else {

        // create the site    
        try {

            // create hash
            hash = await bcrypt.hash(password, 10)

            // create users for site
            site.users = []
            site.users.push({
                firstName: 'Default',
                lastName: 'User',
                email: email,
                password: hash
            })

            // setup directories
            fse.ensureDirSync(`${global.appRoot}/data/`)
            fse.ensureDirSync(`${global.appRoot}/site/`)
            fse.ensureDirSync(`${global.appRoot}/site/data/`)
            fse.ensureDirSync(`${global.appRoot}/site/components/`)
            fse.ensureDirSync(`${global.appRoot}/site/templates/`)
            fse.ensureDirSync(`${global.appRoot}/site/layouts/`)
            fse.ensureDirSync(`${global.appRoot}/site/css/`)
            fse.ensureDirSync(`${global.appRoot}/site/js/`)
            fse.ensureDirSync(`${global.appRoot}/site/images/`)

            // copy layouts, css, js, data
            fse.copySync(`${global.appRoot}/resources/site/layouts`, `${global.appRoot}/site/layouts`)
            fse.copySync(`${global.appRoot}/resources/site/components`, `${global.appRoot}/site/components`)
            fse.copySync(`${global.appRoot}/resources/site/css`, `${global.appRoot}/site/css`)
            fse.copySync(`${global.appRoot}/resources/site/js`, `${global.appRoot}/site/js`)
            fse.copySync(`${global.appRoot}/resources/site/data`, `${global.appRoot}/site/data`)

            // publish site json
            common.publishSiteJSON()

            // write variables
            file = `${global.appRoot}/site/css/variables.css`
            console.log(`[app] writing ${file}`)
            fs.writeFileSync(file, variables, 'utf8')

            files = fs.readdirSync(`${global.appRoot}/site/css/`)
            
            content = ''

            // combine css files
            for(let x=0; x<files.length; x++) {
                console.log(`[app] reading ${global.appRoot}/site/css/${files[x]}`);

                let css = fs.readFileSync(`${global.appRoot}/site/css/${files[x]}`, 'utf8')

                content += css
            }

            console.log('[content]' + content)

            // write site.all.css
            file = `${global.appRoot}/site/css/site.all.css`
            console.log(`[app] writing ${file}`)
            fs.writeFileSync(file, uglifycss.processString(content, { maxLineLen: 500, expandVars: false }), 'utf8')

            // write local site.json
            file = `${global.appRoot}/data/site.json`
            console.log(`[app] writing ${file}`)

            fs.writeFileSync(file, JSON.stringify(site), 'utf8')

            // write builder.json
            file = `${global.appRoot}/site/data/builder.json`
            console.log(`[app] writing ${file}`)
      
            fs.writeFileSync(file, JSON.stringify({
                                        'json': json,
                                        'variables': variables,
                                        'html': html,
                                        'editorHTML': editorHTML
                                    }), 'utf8')
            
            // write index.html
            file = `${global.appRoot}/site/index.html`
            console.log(`[app] writing ${file}`)

            fs.writeFileSync(file, html, 'utf8')

            // create about
            source = `${global.appRoot}/resources/site/placeholder/about.html`
            file = `${global.appRoot}/site/about.html`

            content = fs.readFileSync(source, 'utf8')

            page = template
            page = common.replaceAll(page, '{{page.title}}', 'About');
            page = common.replaceAll(page, '{{page.description}}', 'Learn more about us.');
            page = common.replaceAll(page, '{{page.keywords}}', '');
            page = common.replaceAll(page, '{{page.image}}', '');
            page = common.replaceAll(page, '{{version}}', '1');
            page = common.replaceAll(page, '{{page.customHeader}}', '');
            page = common.replaceAll(page, '{{page.customFooter}}', '');
            page = common.replaceAll(page, '{{page.content}}', content);

            // write about
            console.log(`[app] writing ${file}`)
            fs.writeFileSync(file, page, 'utf8')

            // create gallery
            source = `${global.appRoot}/resources/site/placeholder/gallery.html`
            file = `${global.appRoot}/site/gallery.html`

            content = fs.readFileSync(source, 'utf8')

            page = template
            page = common.replaceAll(page, '{{page.title}}', 'Gallery');
            page = common.replaceAll(page, '{{page.description}}', 'View our photos');
            page = common.replaceAll(page, '{{page.keywords}}', '');
            page = common.replaceAll(page, '{{page.image}}', '');
            page = common.replaceAll(page, '{{version}}', '1');
            page = common.replaceAll(page, '{{page.customHeader}}', '');
            page = common.replaceAll(page, '{{page.customFooter}}', '');
            page = common.replaceAll(page, '{{page.content}}', content);

            // write gallery
            console.log(`[app] writing ${file}`)
            fs.writeFileSync(file, page, 'utf8')

            // write default.html
            file = `${global.appRoot}/site/templates/default.html`
            console.log(`[app] writing ${file}`)
            fs.writeFileSync(file, template, 'utf8')

            res.status(200).send('Site created successfully')

        }
        catch(e) {
            console.log(e);
            res.status(400).send('Error creating site')
        }
    }

})

module.exports = router