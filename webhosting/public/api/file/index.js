const express = require('express'),
    router = express.Router(),
    fs = require('fs'),
    fse = require('fs-extra'),
    cheerio = require('cheerio'),
    common = require('../common.js')

/**
  * /api/image/upload
  * @param {Object} req - http://expressjs.com/api.html#req
  * @param {Object} res - http://expressjs.com/api.html#res
  * @param {Object} next - required for middleware
  */
router.post('/upload', async (req, res) => {

    // auth
    if(!req.user) {
        res.status(400).send('Not authenticated')
        return
    }

    let name = req.body.name,
        size = req.body.size,
        type = req.body.type,
        image = req.body.image,
        thumb = req.body.thumb

    console.log(`[debug] upload name=${name}, size=${size}, type=${type}`)
    // console.log(blob)

    try {

        // make sure the directory is there
        fse.ensureDirSync(`${global.appRoot}/site/files/`)
        fse.ensureDirSync(`${global.appRoot}/site/files/small/`)

        // strip off the data: url prefix to get just the base64-encoded bytes
        let indexImage = image.indexOf('base64,'),
            dataImage = image.substring(indexImage+7, image.length-1)
            bufferImage = new Buffer(dataImage, 'base64'),
            indexThumb = thumb.indexOf('base64,'),
            dataThumb = thumb.substring(indexThumb+7, thumb.length-1)
            bufferThumb = new Buffer(dataThumb, 'base64'),
            imageLocation = `${global.appRoot}/site/files/${name}`,
            thumbLocation = `${global.appRoot}/site/files/small/${name}`

        // write image and thumb
        fs.writeFileSync(imageLocation, bufferImage)

        // write thumb if applicable
        if(thumb != null) {
            fs.writeFileSync(thumbLocation, bufferThumb)
        }

        // send 200       
        res.status(200).send('Image uploaded successfully')

    }
    catch(e) {
        console.log(e)
        res.status(400).send('There was an error saving the image')
    }

})

/**
  * /api/image/list
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

        let files = fs.readdirSync(`${global.appRoot}/site/files/`), json = []

        for(x=0; x<files.length; x++) {

            // get stats for file
            let stats = fs.statSync(`${global.appRoot}/site/files/${files[x]}`)

            if(stats.isFile()) {

                json.push({
                    name: files[x],
                    url: `files/${files[x]}`,
                    preview: `/files/${files[x]}`,
                    size: stats.size,
                    dt: stats.birthtimeMs,
                    dtFriendly: stats.birthtime
                })
            }
        }
        
        // send 200       
        res.setHeader('Content-Type', 'application/json')
        res.status(200).send(json)

    }
    catch(e) {
        res.status(400).send('There was an error listing the image')
    }

})

module.exports = router