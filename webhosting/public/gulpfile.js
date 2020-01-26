var gulp = require('gulp'),
    concat = require('gulp-concat'),
    minifyCss = require('gulp-minify-css'),
    env = require('dotenv').config(),
    path = require('path'),
    fs = require('fs'),
    fse = require('fs-extra')


// copy and combine css files
gulp.task('css-app', function(done) {

    let location = 'resources/site/css'

    // concat css
    gulp.src([`${location}/variables.css`, `${location}/custom.css`, `${location}/footer.css`, `${location}/header.css`, `${location}/hero.css`, `${location}/layout.css`, `${location}/site.css`, `${location}/top.css`, `${location}/widgets.css`])
        .pipe(concat('site.all.css'))
        .pipe(minifyCss())
        .pipe(gulp.dest(location))

    done()
  
  })


// copy and combine js files
gulp.task('js-app', function(done) {

    let location = 'resources/site/js'

    // concat js
    gulp.src([`${location}/widgets.js`])
        .pipe(concat('site.all.js'))
        .pipe(gulp.dest(location))
  
    done()
  
  })


// copy and combine css files
gulp.task('css-site', function(done) {

    let location = 'site/css'

    // concat css
    gulp.src([`${location}/variables.css`, `${location}/custom.css`, `${location}/footer.css`, `${location}/header.css`, `${location}/hero.css`, `${location}/layout.css`, `${location}/site.css`, `${location}/top.css`, `${location}/widgets.css`])
        .pipe(concat('site.all.css'))
        .pipe(minifyCss())
        .pipe(gulp.dest(location))

    done()
  
  })


// copy and combine js files
gulp.task('js-site', function(done) {

    let location = 'site/js'

    // concat js
    gulp.src([`${location}/widgets.js`])
        .pipe(concat('site.all.js'))
        .pipe(gulp.dest(location))
  
    done()
  
  })

// create json file
gulp.task('json-site', function(done) {

  let site = {},
      appRoot = path.resolve(__dirname)

  site.id = process.env.SITE_ID
  site.formSubmitApiUrl = process.env.FORM_SUBMIT_URL

  // setup directories
  fse.ensureDirSync(`${appRoot}/site/data/`)

  // save JSON file
  fs.writeFileSync(`${appRoot}/site/data/site.json`, JSON.stringify(site), 'utf8')

  done()

})


// default -> site
gulp.task('default', gulp.parallel('css-site', 'js-site', 'json-site'))

// site
gulp.task('site', gulp.parallel('css-site', 'js-site', 'json-site'))

// app
gulp.task('app', gulp.parallel('css-app', 'js-app'))

