# Triangulate

Triangulate is a fun way to build fast, beautiful, and reliable static websites.  It is not only an amazing static site generator, but it also allows you to manage your site after it is created.  Triangulate is built entirely in JavaScript.  It uses module based JavaScript on the client and Express JS on the backend.  Triangulatetakes a component based approach to building websites.  So, there are no themes built into Triangulate.  Rather, we give you an awesome theme builder to pick and choose a site design that suits your taste.

### Status

Version: 8.0.0 (stable)

### Installation

```
# create site directory
mkdir my-site
cd my-site

# clone repo
git clone https://github.com/madoublet/triangulate .

# install dependencies
npm install

# setup .env
cp .env.sample .env

# start app
npm start
```

### Creating your site

Navigate to https://localhost:3000 and follow the instructions to create your site

### Editing your site

Once your site is created, navigate to https://localhost:3000/edit

### Change Settings
```
nano .env
gulp
```

### Update CSS/JS (after creating your site)
```
# switch to css directory
cd site/css

# edit css
nano variables.css

# build site.all.css
gulp

# switch to js directory
cd site/js

# edit js
nano widgets.js

# build site.all.js
gulp
```

### Contribute

There are a number of ways you can support and contribute to Triangulate.  Learn more at https://triangulate.io/contribute.html

### Help and Support

For support tag questions on Stack Overflow with triangulate: https://stackoverflow.com/questions/tagged/triangulate
Submit bugs and issues at https://github.com/madoublet/triangulate/issues
Email feature requests to matt@matthewsmith.com