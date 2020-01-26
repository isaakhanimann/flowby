const fs = require('fs'),
      fse = require('fs-extra'),
      handlebars = require('handlebars'),
      cheerio = require('cheerio'),
      pretty = require('pretty'),
      sm = require('sitemap')

/**
  * Common application functions
  */
module.exports = {

    /**
     * Creates a unique id
     * @param {String} length - the length of the id to make
     */
    makeid: function(length) {
        var text = "";
        var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      
        for (var i = 0; i < length; i++)
          text += possible.charAt(Math.floor(Math.random() * possible.length));
      
        return text;
    },

    /**
     * Replace all occurences of a string in a string
     * @param {String} str - the starting string
     * @param {String} search - the search string
     * @param {String} replacement - the string to replace
     */
    replaceAll: function(str, search, replacement) {
        return str.replace(new RegExp(search, 'g'), replacement);
    },
    
    /**
     * Finds a user
     * @param {String} email
     */
    findUser: function(email) {

      try{
        let json = fs.readFileSync(`${global.appRoot}/data/site.json`, 'utf8'),
            obj = JSON.parse(json)

        for(let x=0; x<obj.users.length; x++) {
          if(obj.users[x].email == email) return obj.users[x]
        }

      }
      catch(e) {
        return null
      }

    },

    // generate an id for the new sku
    makeid: function(length) {
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
      for (var i = 0; i < length; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    
      return text;
    },

    /**
     * Creates a reset token for a given email
     * @param {String} email
     */
    createResetTokenForUser: function(email, token) {

      try{
        let json = fs.readFileSync(`${global.appRoot}/data/site.json`, 'utf8'),
            obj = JSON.parse(json)

        for(let x=0; x<obj.users.length; x++) {
          if(obj.users[x].email == email) {
            obj.users[x].token = token

            fs.writeFileSync(`${global.appRoot}/data/site.json`, JSON.stringify(obj), 'utf8')

            return token
          }
        }

      }
      catch(e) {
        console.log(e)
        return null
      }

    },

    /**
     * Creates a reset token for a given email
     * @param {String} email
     */
    updatePassword: function(email, hash) {

      try{
        let json = fs.readFileSync(`${global.appRoot}/data/site.json`, 'utf8'),
            obj = JSON.parse(json)

        for(let x=0; x<obj.users.length; x++) {
          if(obj.users[x].email == email) {

            // clear token
            delete obj.users[x].token

            // update password
            obj.users[x].password = hash
            
            // update file
            fs.writeFileSync(`${global.appRoot}/data/site.json`, JSON.stringify(obj), 'utf8')
          }
        }

      }
      catch(e) {
        console.log(e)
        return null
      }

    },

    /**
     * Publishes site json
     * @param {String} email
     */
    publishSiteJSON: function() {

      let site = {}

      site.id = process.env.SITE_ID
      site.formSubmitApiUrl = process.env.FORM_SUBMIT_URL

      // setup directories
      fse.ensureDirSync(`${global.appRoot}/site/data/`)

      // save JSON file
      fs.writeFileSync(`${global.appRoot}/site/data/site.json`, JSON.stringify(site), 'utf8')

    },

    /**
     * Retrieves pages
     * @param {String} email
     */
    retrievePages: function() {

      let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')

      return JSON.parse(json)

    },

    /**
     * Retrieves a page for a given url
     * @param {String} url
     */
    retrievePage: function(url) {
      // get json
      let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8'),
      objs = JSON.parse(json)

      for(let x=0; x<objs.length; x++) {
        if(objs[x].url == url) {
            return objs[x]
        }
      }

      return null
    },

    /**
     * Generates a sitemap
     */
    generateSiteMap: function() {

      // create sitemap (get sitemap)
      let sitemap = sm.createSitemap ({
        hostname: process.env.SITE_URL,
        cacheTime: 600000
      })

      // get json
      let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')

      // read json
      let pages = JSON.parse(json)

      // add pages to sitemap
      pages.forEach(page => {
        sitemap.add({url: page.url})
      })

      // save html file
      fs.writeFileSync(`${global.appRoot}/site/sitemap.xml`, sitemap.toString(), 'utf8')

    },

    /**
     * Publishes a page
     * @param {String} page
     */
    publishPage: function(page) {

      let newPage = true,
          html = '',
          content = '',
          $ = null,
          parts = page.url.split('/'),
          base = '',
          currentPage = null

      // setup the base
      if(parts.length > 1) {
          for(let x=1; x<parts.length; x++) {
              base += '../';
          }
      }

      // get json
      let json = fs.readFileSync(`${global.appRoot}/site/data/pages.json`, 'utf8')

      // read json
      let pages = JSON.parse(json)

      // check to see if page exists
      for(let x=0; x<pages.length; x++) {
          if(pages[x].url == page.url) {
              newPage = false
              pages[x] = page
              currentPage = page
          }
      }

      if(newPage == true) {

        currentPage = page
        
        // add page
        pages.push(page)

        // get default content from layouts 
        content = fs.readFileSync(`${global.appRoot}/site/layouts/${page.type}.html`, 'utf8')
      }
      else {

        // get content from existing page
        let temp = fs.readFileSync(`${global.appRoot}/site/${page.url}`, 'utf8'),
            $ = cheerio.load(temp)

        // get content
        content = $('[role="main"]').html()
      }

      // retrieve template
      html = fs.readFileSync(`${global.appRoot}/site/templates/${page.template}.html`, 'utf8')

      // replace all meta data
      html = html.replace(/{{page.content}}/g, content)
      html = html.replace(/{{page.title}}/g, page.name)
      html = html.replace(/{{page.name}}/g, page.name)
      html = html.replace(/{{page.url}}/g, page.url)
      html = html.replace(/{{page.description}}/g, page.description)
      html = html.replace(/{{page.keywords}}/g, page.keywords)
      html = html.replace(/{{page.tags}}/g, page.tags)
      html = html.replace(/{{page.image}}/g, page.image)
      html = html.replace(/{{page.location}}/g, page.location)
      html = html.replace(/{{page.language}}/g, page.language)
      html = html.replace(/{{page.direction}}/g, page.direction)
      html = html.replace(/{{page.firstName}}/g, page.firstName)
      html = html.replace(/{{page.lastName}}/g, page.lastName)
      html = html.replace(/{{page.lastModifiedBy}}/g, page.firstName + ' ' + page.lastName)
      html = html.replace(/{{page.lastModifiedDate}}/g, (new Date()).toUTCString())
      html = html.replace(/{{page.customHeader}}/g, '')
      html = html.replace(/{{page.customFooter}}/g, '')
      html = html.replace(/{{version}}/g, Date.now())

      // load into $
      $ = cheerio.load(html);

      // set base value
      $('base').attr('href', base);

      console.log('[app] before components')

      // find site components
      $('[site-component]').each(function(i, element) {

        // get component type
        let type = $(element).attr('site-component')

        console.log('[app] found component type=' + type)

        try{
          let component = fs.readFileSync(`${global.appRoot}/site/components/${type}.html`, 'utf8')

          // sort pages by date modified
          pages.sort(function(a, b) {
              a = new Date(a.lastModifiedDate);
              b = new Date(b.lastModifiedDate);
              return a>b ? -1 : a<b ? 1 : 0;
          });

          // data to load into handlebars
          let data = {
              'hello': 'hello from handlebars',
              'attributes': element.attribs,
              'pages': pages,
              'currentPage': currentPage
          }

          // get component content
          let c = '';
                                                    
          try {

              handlebars.registerHelper('startsWith', function(prefix, str, options) {
                  var args = [].slice.call(arguments)
                  options = args.pop()
                  
                  str = str.toString()
                  
                  if (str.indexOf(prefix) === 0) {
                    return options.fn(this)
                  }
                  if (typeof options.inverse === 'function') {
                    return options.inverse(this)
                  }
                  return ''
              });

              handlebars.registerHelper('is', function(a, b, options) {
                  return (a == b) ? options.fn(this) : options.inverse(this)
              });

              let template = handlebars.compile(component)
              c = template(data)
          }
          catch(e) {
            c = 'Component template failed to compile.'
            console.log('[error]', e)
          }

          $(element).html(c)

        }
        catch(e) {
          console.log('[app] could not find component')
          console.log('[error]', e)
        }

      })
      // end $('[site-component]').each
      
      // save content
      html = $.html()

      // clean html
      html = pretty(html, {ocd: true})

      // get directory
      let dir = page.url.substring(0, page.url.lastIndexOf("/")+1)

      console.log('[debug] directory', `${global.appRoot}/site/${dir}`)

      // make sure it exists
      fse.ensureDirSync(`${global.appRoot}/site/${dir}`)

      console.log('[debug] file', `${global.appRoot}/site/${page.url}`)

      // save html file
      fs.writeFileSync(`${global.appRoot}/site/${page.url}`, html, 'utf8')

      // save json file
      fs.writeFileSync(`${global.appRoot}/site/data/pages.json`, JSON.stringify(pages), 'utf8')

    }

    
};