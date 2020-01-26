var site = site || {};

/*
  * Shows a toast
  * Usage:
  * site.toast.show('success', 'Saved!', true);
  * site.toast.show('failure', 'Error!', true);
  * site.toast.show('loading', 'Loading...', false);
  */
 site.toast = (function() {

    'use strict';

    return {

        version: '0.0.1',

        /**
         * Creates the toast
         */
        setup: function() {

        var current;

        current = document.createElement('div');
        current.setAttribute('class', 'site-toast');
        current.innerHTML = 'Sample Toast';

        // append toast
        document.body.appendChild(current);

        return current;

        },

        /**
         * Shows the toast
         */
        show: function(status, text, autoHide) {

        var current;

        current = document.querySelector('.site-toast');

        if(current == null) {
            current = toast.setup();
        }

        current.removeAttribute('success');
        current.removeAttribute('failure');
        current.removeAttribute('loading');

        current.setAttribute('active', '');

        // add success/failure
        if (status == 'success') {
            current.setAttribute('success', '');

            text = '<span>' + text + '</span>';
        }
        else if (status == 'failure') {
            current.setAttribute('failure', '');

            text = '<span>' + text + '</span>';
        }
        else if (status == 'loading') {
            current.setAttribute('loading', '');

            text = '<svg class="loading-icon" width="38" height="38" viewBox="0 0 38 38" xmlns="http://www.w3.org/2000/svg" stroke="#fff">' +
                    '<g fill="none" fill-rule="evenodd">' +
                        '<g transform="translate(1 1)" stroke-width="2">' +
                            '<circle stroke-opacity=".5" cx="18" cy="18" r="18"/>' +
                            '<path d="M36 18c0-9.94-8.06-18-18-18">' +
                                '<animateTransform' +
                                    'attributeName="transform"' +
                                    'type="rotate"' +
                                    'from="0 18 18"' +
                                    'to="360 18 18"' +
                                    'dur="1s"' +
                                    'repeatCount="indefinite"/>' +
                            '</path>' +
                        '</g>' +
                    '</g>' +
                '</svg><span>' + text + '</span>'
        }

        // set text
        current.innerHTML = text;

        // enable persistent messages
        if(autoHide == true) {
            setTimeout(function() {
            current.removeAttribute('active');
            }, 1000);

        }

        }

    }

})();

site.toast.setup();

/*
 * Sets up the builder app
 */
var app = {

    el: null,
    src: '/select/index.html',

    header: '',
    content: '',
    footer: '',

    /*
     * Setup the app
     */
    setup: function() {

        // get blocks
        let blocks = document.querySelectorAll('.builder-block'),
            version = document.querySelector('body').getAttribute('data-version'),
            pickers = document.querySelectorAll('.color-picker-wrapper input'),
            modal = document.querySelector('#modal-select-block'),
            getStartedModal = document.querySelector('#app-get-started'),
            setupModal = document.querySelector('#app-setup'),
            iframe = document.querySelector('#modal-frame'),
            close = document.querySelector('#modal-select-block-close'),
            closeGetStarted = document.querySelector('#app-get-started-close'),
            closeSetup = document.querySelector('#app-setup-close'),
            buildButton = document.querySelector('#build-button'),
            createButton = document.querySelector('#create-button');

        // show bottom on scroll
        window.addEventListener("scroll", function(e){
            if(window.scrollY > 400) {
                document.querySelector('#builder-bottom').setAttribute('active', '');
            }
            else {
                document.querySelector('#builder-bottom').removeAttribute('active');
            }
        });

        for(let x=0; x<blocks.length; x++) {

            // handle click event
            blocks[x].addEventListener('click', function(e) {
                app.el = e.target;
                modal.setAttribute('active', '');
                let type = app.el.getAttribute('data-type');
                iframe.src = `${app.src}?filter=${type}&version=${version}`;

                // set status
                document.querySelector(`#builder-status-${app.el.id}`).setAttribute('active', '');

                // check if the page is ready to be built
                let isReady = true,
                    links = document.querySelectorAll('.builder-status a');

                for(let y=0; y<links.length; y++) {
                    if(!links[y].hasAttribute('active')) {
                        isReady = false;
                    }
                }

                if(isReady) {
                    buildButton.removeAttribute('disabled');
                }
            });

            // handle click event
            blocks[x].addEventListener('mouseover', function(e) {

                let type = e.target.getAttribute('data-type') || '',
                    index = Array.prototype.indexOf.call(e.target.parentNode.children, e.target);


                // hide all the information sections
                let infos = document.querySelectorAll('.builder-information');

                for(let y=0; y<infos.length; y++) {
                    infos[y].removeAttribute('active');
                    iframe.src = '';
                }

                // show info
                let info = document.querySelector(`.builder-information[data-type="${type}"]`);

                if(info) {
                    let top = 50;

                    if(e.target.offsetTop > 100) {
                        top = (e.target.offsetTop * 0.7) - (index * 5);
                    }

                    info.setAttribute('active', '');
                    info.style.top = top + 'px';
                }

            });
        }
        // end for

        for(let x=0; x<pickers.length; x++) {

            // handle change
            pickers[x].addEventListener('change', function(e) {

                var input = e.target,
                    color = e.target.value,
                    parent = e.target.parentNode,
                    variable = parent.getAttribute('data-variable'),
                    root = document.querySelector('.builder-block-container');
                
                console.log(root);

                // set parent
                parent.setAttribute('style', `background-color: ${color}`);

                // set variable
                root.style.setProperty(variable, color);

                console.log('variable=' + variable + ' color=' + color);


            });

        }
        // end for
        
        // setup close buttons
        close.addEventListener('click', function(e) {
            app.el = null;
            modal.removeAttribute('active');
            iframe.src = '';
        });

        closeGetStarted.addEventListener('click', function(e) {
            getStartedModal.removeAttribute('active');
        });

        closeSetup.addEventListener('click', function() {
            setupModal.removeAttribute('active');
        });

        // setup build button
        buildButton.addEventListener('click', function(e) {

            // check for disabled
            if(buildButton.hasAttribute('disabled')) {
                return;
            }

            setupModal.setAttribute('active', '');

        });
        // end create site

        console.log(createButton);

        // setup build button
        createButton.addEventListener('click', function(e) {

            let email = document.querySelector('#email').value,
                password = document.querySelector('#password').value

            // set data
            let data = {
                email: email,
                password: password,
                html: app.buildHTML(),
                template: app.buildTemplate(),
                variables: app.buildVariables(),
                json: app.buildSiteJSON(),
                editorHTML: app.getEditorHTML()
            };

            // get elements
            let preview = document.querySelector('#preview-your-site'),
                editSite = document.querySelector('#edit-site'),
                loading = document.querySelector('#create-button-loading');


            // show loading
            loading.setAttribute('active', '');
            createButton.setAttribute('disabled', '');
            createButton.innerHTML = 'Creating site...';

            // post form
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '/api/setup', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify(data));

            xhr.onload = function() {
                if (xhr.status >= 200 && xhr.status < 400) {
                    console.log(`[debug] ${xhr.responseText}`);
                    loading.removeAttribute('active');
                    createButton.removeAttribute('disabled');
                    createButton.innerHTML = 'Create your Site';

                    // set next steps
                    setupModal.removeAttribute('active');
                    getStartedModal.setAttribute('active', '');
                    preview.setAttribute('href', `/index.html`);
                    editSite.setAttribute('href', `/edit?page=/index.html`);
                }
                else {
                    site.toast.show('failure', 'There was a problem creating your site.', true);
                    loading.removeAttribute('active');
                    createButton.removeAttribute('disabled');
                    createButton.innerHTML = 'Create your Site';
                }
            };

        });
        // end create site

        // listen for message
        window.addEventListener('message', function(e) {
            let message = e.data;

            console.log(message);

            if(message) {

                if(message.command == 'add-block') {
                    app.el.innerHTML = message.data;

                    if(app.el.hasAttribute('data-class')) {
                        let els = app.el.querySelectorAll('.grid');

                        for(let x=0; x<els.length; x++) {
                            els[x].classList.add(app.el.getAttribute('data-class'));
                        }
                    }

                    if(app.el.hasAttribute('data-class-2')) {
                        let els = app.el.querySelectorAll('.grid');

                        for(let x=0; x<els.length; x++) {
                            els[x].classList.add(app.el.getAttribute('data-class-2'));
                        }
                    }


                    modal.removeAttribute('active');
                }

            }
            // check for message

        });
        // end listen for message

    },
    // end setup

    /*
     * Build editor HTML
     */
    getEditorHTML: function () {
        let editorHTML = document.querySelector('#editor-container');

        return editorHTML.innerHTML;
    },

    /*
     * Build site.json
     */
    buildSiteJSON: function () {

        let backgroundColor = document.querySelector('#background-color').value,
            alternateBackgroundColor = document.querySelector('#alternate-background-color').value,
            headlineColor = document.querySelector('#headline-color').value,
            textColor = document.querySelector('#text-color').value,
            linkColor = document.querySelector('#link-color').value,
            highlightColor = document.querySelector('#highlight-color').value,
            topBackgroundColor = document.querySelector('#top-background-color').value,
            topTextColor = document.querySelector('#top-text-color').value,
            headerBackgroundColor = document.querySelector('#header-background-color').value,
            heroBackgroundColor = document.querySelector('#hero-background-color').value,
            heroTextColor = document.querySelector('#hero-text-color').value,
            navigationBackgroundColor = document.querySelector('#navigation-background-color').value,
            navigationTextColor = document.querySelector('#navigation-text-color').value,
            footerBackgroundColor = document.querySelector('#footer-background-color').value,
            footerTextColor = document.querySelector('#footer-text-color').value;

        return `{
    "customizations": [
        {
            "name": "",
            "type": "title"
        },
        {
            "id": "logo",
            "name": "Logo",
            "value": "https://s3.amazonaws.com/resources.fixture.app/media/logo.svg",
            "type": "image"
        },
        {
            "id": "icon",
            "name": "Icon",
            "value": "https://s3.amazonaws.com/resources.fixture.app/media/icon.png",
            "type": "image"
        },
        {
            "id": "font-family",
            "name": "Font Family",
            "value": "system",
            "type": "font"
        },
        {
            "id": "text-size",
            "name": "Text Size",
            "value": "15px",
            "type": "text-size"
        },
        {
            "name": "Site",
            "type": "title"
        },
        {
            "id": "background-color",
            "name": "Background",
            "value": "${backgroundColor}",
            "type": "color"
        },
        {
            "id": "alternate-background-color",
            "name": "Alternate",
            "value": "${alternateBackgroundColor}",
            "type": "color"
        },
        {
            "id": "headline-color",
            "name": "Headline",
            "value": "${headlineColor}",
            "type": "color"
        },
        {
            "id": "text-color",
            "name": "Text",
            "value": "${textColor}",
            "type": "color"
        },
        {
            "id": "link-color",
            "name": "Link",
            "value": "${linkColor}",
            "type": "color"
        },
        {
            "id": "highlight-color",
            "name": "Highlight",
            "value": "${highlightColor}",
            "type": "color"
        },
        {
            "name": "Top",
            "type": "title"
        },
        {
            "id": "top-background-color",
            "name": "Background",
            "value": "${topBackgroundColor}",
            "type": "color"
        },
        {
            "id": "top-text-color",
            "name": "Text",
            "value": "${topTextColor}",
            "type": "color"
        },
        {
            "name": "Header",
            "type": "title"
        },
        {
            "id": "header-background-color",
            "name": "Background",
            "value": "${headerBackgroundColor}",
            "type": "color"
        },
        {
            "name": "Hero",
            "type": "title"
        },
        {
            "id": "hero-background-color",
            "name": "Background",
            "value": "${heroBackgroundColor}",
            "type": "color"
        },
        {
            "id": "hero-text-color",
            "name": "Text",
            "value": "${heroTextColor}",
            "type": "color"
        },
        {
            "name": "Navigation",
            "type": "title"
        },
        {
            "id": "navigation-background-color",
            "name": "Background",
            "value": "${navigationBackgroundColor}",
            "type": "color"
        },
        {
            "id": "navigation-text-color",
            "name": "Text",
            "value": "${navigationTextColor}",
            "type": "color"
        },
        {
            "name": "Footer",
            "type": "title"
        },
        {
            "id": "footer-background-color",
            "name": "Background",
            "value": "${footerBackgroundColor}",
            "type": "color"
        },
        {
            "id": "footer-text-color",
            "name": "Text",
            "value": "${footerTextColor}",
            "type": "color"
        }
    ]
}`;

    },

    /*
     * Build variables.css
     */
    buildVariables: function () {

        let backgroundColor = document.querySelector('#background-color').value,
            alternateBackgroundColor = document.querySelector('#alternate-background-color').value,
            headlineColor = document.querySelector('#headline-color').value,
            textColor = document.querySelector('#text-color').value,
            linkColor = document.querySelector('#link-color').value,
            highlightColor = document.querySelector('#highlight-color').value,
            topBackgroundColor = document.querySelector('#top-background-color').value,
            topTextColor = document.querySelector('#top-text-color').value,
            headerBackgroundColor = document.querySelector('#header-background-color').value,
            heroBackgroundColor = document.querySelector('#hero-background-color').value,
            heroTextColor = document.querySelector('#hero-text-color').value,
            navigationBackgroundColor = document.querySelector('#navigation-background-color').value,
            navigationTextColor = document.querySelector('#navigation-text-color').value,
            footerBackgroundColor = document.querySelector('#footer-background-color').value,
            footerTextColor = document.querySelector('#footer-text-color').value;

        return `:root {

    --font-family: "Source Sans Pro", "Helvetica Neue", Arial, sans-serif;
    --text-size: 15px;
    
    --background-color: ${backgroundColor};
    --alternate-background-color: ${alternateBackgroundColor};
    --headline-color: ${headlineColor};
    --text-color: ${textColor};
    --link-color: ${linkColor};
    --highlight-color: ${highlightColor};
    
    --top-background-color: ${topBackgroundColor};
    --top-text-color: ${topTextColor};

    --header-background-color: ${headerBackgroundColor};

    --hero-background-color: ${heroBackgroundColor};
    --hero-text-color: ${heroTextColor};

    --navigation-background-color: ${navigationBackgroundColor};
    --navigation-text-color: ${navigationTextColor};

    --footer-background-color: ${footerBackgroundColor};
    --footer-text-color: ${footerTextColor};
}`;

    },

    /*
     * Build HTML
     */
    buildHTML: function() {

        // get top
        let top = document.querySelector('.builder-block[data-type="top"]').innerHTML;

        // get header
        let header = document.querySelector('.builder-block[data-type="header"]').innerHTML;

        // get footer
        let footer = document.querySelector('.builder-block[data-type="footer"]').innerHTML;

        // get content
        let parts = document.querySelectorAll('.builder-block[data-type="hero"], .builder-block[data-type="social-proof"], .builder-block[data-type="details"]'), content = '';

        for(let x=0; x<parts.length; x++) { 
            content += parts[x].innerHTML;
        }

        // build html
        return `<!DOCTYPE html>
    <html lang="en" dir="ltr">
    
    <head>
        <title>Home</title>
    
        <!-- meta -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="description" content="Welcome to our site.">
        <meta name="keywords" content="">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
    
        <!-- set base -->
        <base href="">
    
        <!-- open graph -->
        <meta property="og:url" content="">
        <meta property="og:type" content="website">
        <meta property="og:title" content="">
        <meta property="og:description" content="">
        <meta property="og:image" content="">
    
        <!-- icons -->
        <link site-icon="" href="files/icon.png" rel="icon">
        <link site-icon="" href="files/icon.png" rel="apple-touch-icon">

    
        <!-- css -->
        <link type="text/css" href="css/site.all.css" rel="stylesheet">
    
    </head>
    <body data-lastmodified="" data-template="default" data-tags="">
        ${top}
        ${header}
        <main class="content" role="main">${content}</main>
        ${footer}
    </body>

<script src="js/site.all.js"></script>

</html>`;

    },

    /*
     * Build HTML
     */
    buildTemplate: function() {

        // get top
        let top = document.querySelector('.builder-block[data-type="top"]').innerHTML;

        // get header
        let header = document.querySelector('.builder-block[data-type="header"]').innerHTML;

        // get footer
        let footer = document.querySelector('.builder-block[data-type="footer"]').innerHTML;

        // build html
        return `<!DOCTYPE html>
    <html lang="en" dir="ltr">
    
    <head>
        <title>{{page.title}}</title>
    
        <!-- meta -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="description" content="{{page.description}}">
        <meta name="keywords" content="{{page.keywords}}">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">

        <!-- set base -->
        <base href="">

        <!-- open graph -->
        <meta property="og:url" content="">
        <meta property="og:type" content="website">
        <meta property="og:title" content="{{page.title}}">
        <meta property="og:description" content="{{page.description}}">
        <meta property="og:image" content="{{page.image}}">

        <!-- icons -->
        <link site-icon="" href="files/icon.png" rel="icon">
        <link site-icon="" href="files/icon.png" rel="apple-touch-icon">

        <!-- css -->
        <link type="text/css" href="css/site.all.css?v={{version}}" rel="stylesheet">

        {{page.customHeader}}
    
    </head>
    <body data-lastmodified="" data-template="default" data-tags="">
        ${top}
        ${header}
        <main class="container" role="main">
            {{page.content}}
        </main>
        ${footer}
    </body>

<script src="js/site.all.js?v={{version}}"></script>

{{page.customFooter}}

</html>`;

    }

}

app.setup();

