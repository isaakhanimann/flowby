/**
 * Respond Edit is a simple, web-based editor for static HTML sites. Learn more at respondcms.com Download from Github at github.com/madoublet/editor
 * @author: Matthew Smith
 */
var editor = editor || {};

editor = (function() {

  'use strict';

  return {

    // set whether the content has changed
    hasChanged: false,
    changedCallback: null,

    // set debug messages
    debug: false,

    // init menu
    menu: [],

    // path to editor library
    path: '/editor/',

    // path to stylesheet
    stylesheet: ['editor-min.css'],

    // pointers to selected elements
    current: {
      container: null,
      node: null,
      block: null,
      parent: null,
      element: null,
      image: null,
      menuItem: null,
      linkSelection: '',
      menu: null
    },

    // handles text selection
    selection: null,

    /**
     * Sets the editor to a changed state and dispatches event
     */
    setChanged: function(msg) {
      window.parent.postMessage({
          type: 'editorChanged',
          properties: []
        }, '*');
    },

    /**
     * Set as active
     */
    setActive: function() {

      // set [editor-active] on body
      document.querySelector('body').setAttribute('editor-active', '');

    },

    /**
     * Setup content editable element
     */
    setContentEditable: function() {

      var x, els;

      // setup [contentEditable=true]
      els = document.querySelectorAll(
        '[editor-element] p, [editor-element] h1, [editor-element] h2, [editor-element] h3, [editor-element] h4, [editor-element] h5, p[editor-element], [editor] h1[editor-element], [editor] h2[editor-element], h3[editor-element], h4[editor-element], h5[editor-element], span[editor-element], ul[editor-element] li, ol[editor-element] li, table[editor-element] td, table[editor-element] th, blockquote[editor-element], pre[editor-element]'
      );

      for (x = 0; x < els.length; x += 1) {

        // add attribute
        els[x].setAttribute('contentEditable', 'true');

      }

    },

    /**
     * Sets up empty
     * @param {Array} sortable
     */
    setupEmpty: function() {

      var x, sortable, els;

      els = document.querySelectorAll('[editor-sortable]');

      // walk through sortable clases
      for (x = 0; x < els.length; x += 1) {

        if(els[x].firstElementChild === null){
          els[x].setAttribute('editor-empty', 'true');
        }
        else {
          els[x].removeAttribute('editor-empty');
        }

      }

    },

    /**
     * Sets up block
     * @param {Array} sortable
     */
    setupBlocks: function() {

      var x, els, y, div, blocks, el, next, previous, span;

      blocks = editor.config.blocks;

      // setup sortable classes
      els = document.querySelectorAll('[editor] ' + blocks);

      // set [data-editor-sortable=true]
      for (y = 0; y < els.length; y += 1) {

        // setup blocks
        if(els[y].querySelector('.editor-block-menu') === null) {

          els[y].setAttribute('editor-block', '');

          // create element menu
          div = document.createElement('x-respond-menu');
          div.setAttribute('class', 'editor-block-menu');
          div.setAttribute('contentEditable', 'false');

          // create up
          span = document.createElement('x-respond-menu-item');
          span.setAttribute('class', 'editor-block-menu-item editor-block-up');
          span.innerHTML = '<x-respond-menu-icon class="material-icons">arrow_upward</x-respond-menu-icon>';

          // append the handle to the wrapper
          div.appendChild(span);

          let text = "Layout";

          if (els[y].classList.contains('one-column')) {
            text = "1 Column Layout";
          }
          else if (els[y].classList.contains('two-column')) {
            text = "2 Column Layout";
          }
          else if (els[y].classList.contains('three-column')) {
            text = "3 Column Layout";
          }
          else if (els[y].classList.contains('four-column')) {
            text = "4 Column Layout";
          }

          // create edit
          span = document.createElement('x-respond-menu-item');
          span.setAttribute('class', 'editor-block-menu-item editor-block-edit');
          span.innerHTML = text;

          div.appendChild(span);

          // create down
          span = document.createElement('x-respond-menu-item');
          span.setAttribute('class', 'editor-block-menu-item editor-block-down');
          span.innerHTML = '<x-respond-menu-icon class="material-icons">arrow_downward</x-respond-menu-icon>';

          // append the handle to the wrapper
          div.appendChild(span);

          els[y].appendChild(div);

        }

      }

    },

    /**
     * Sets up the element
     * @param {DOMElement} el
     */
    setupElement: function(el) {

      // set element
      el.setAttribute('editor-element', '');

    },

    /**
     * Hides the element menu
     * @param {DOMElement} el
     */
    hideElementMenu: function() {
      editor.current.menu.removeAttribute('active');
    },

    /**
     * Adds an element menu to a given element
     * @param {DOMElement} el
     */
    setupElementMenu: function(el) {

      var menu, span;

      // create element menu
      menu = document.createElement('x-respond-menu');
      menu.setAttribute('class', 'editor-element-menu');
      menu.setAttribute('contentEditable', 'false');

      // create add
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-add');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">add</x-respond-menu-icon>';

      span.addEventListener('click', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;
        
        if(editor.current.node) {

            // post message to app
            window.parent.postMessage({
              type: 'add',
              properties: {
                id: editor.current.node.id,
                cssClass: editor.current.node.className,
                html: editor.current.node.innerHTML
              },
              attributes: []
            }, '*');

        }

      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create edit
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-edit');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">create</x-respond-menu-icon>';

      span.addEventListener('click', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;

        if(editor.current.node) {

          // show widget or element menu
          if(editor.current.node.getAttribute('site-widget')) {

            // post message to app
            window.parent.postMessage({
              type: 'widget',
              widget: editor.current.node.getAttribute('site-widget'),
              properties: {
                id: editor.current.node.id,
                cssClass: editor.current.node.className,
                html: editor.current.node.innerHTML
              },
              attributes: []
            }, '*');

          }
          else if(editor.current.node.hasAttribute('site-component')) {

            // post message to app
            window.parent.postMessage({
              type: 'component',
              component: editor.current.node.getAttribute('site-component'),
              properties: {
                id: editor.current.node.id,
                cssClass: editor.current.node.className,
                html: editor.current.node.innerHTML
              },
              attributes: []
            }, '*');

          }
          else {
            editor.showElementMenu();
          }

        }

      });

      // append to menu
      menu.appendChild(span);

      // create remove
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-remove');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">remove_circle_outline</x-respond-menu-icon>';

      span.addEventListener('click', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;
        
        if(editor.current.node) {

          // remove parent if all child elements are gone
          let parent = editor.findParentBySelector(editor.current.node, '[editor-block]');
          let blocks = document.querySelectorAll('[editor-block]');
          let element = editor.current.node;

          if(element.hasAttribute('site-widget')) {

            // determine if element has id
            let child = element.querySelector('[data-id]');

            if(child) {
              let id = child.getAttribute('data-id');

              // post message to app
              window.parent.postMessage({
                type: 'remove',
                widget: element.getAttribute('site-widget'),
                id: id
              }, '*');
            }

          }

          // remove the element
          editor.current.node.remove();

          // hide the element menu
          editor.hideElementMenu();

          // remove the parent if all the elements have been removed and it is not the last element
          if(parent) {
            let els = parent.querySelectorAll('[editor-element]');

            if(els.length == 0 && blocks.length > 1) {
              parent.remove();
            }
          } 
        }

      });

      // append to menu
      menu.appendChild(span);

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-up');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">arrow_upward</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;

        if(el.previousElementSibling) {
          el.parentNode.insertBefore(el, el.previousElementSibling);
        }
        else {

          let col = el.parentNode;
          let block = el.parentNode.parentNode;

          let hasMoved = false;

          // check if there is a col that the el can move to
          if(col) {

            if(col.previousElementSibling) {

              if(col.previousElementSibling.classList.contains('col')) {

                col.previousElementSibling.appendChild(el);
                hasMoved = true;

              }
              // end [editor-block] check

            }
            // end sibling check
          }
          
          if(block && hasMoved == false) {
            if(block.previousElementSibling) {

              if(block.previousElementSibling.hasAttribute('editor-block')) {

                let cols = block.previousElementSibling.querySelectorAll('.col');

                if(cols.length > 0) {
                  cols[cols.length-1].appendChild(el);
                }

              }
              // end [editor-block] check

            }
            // end sibling check
          
          }
          // end block check

        }

      });

      // append to menu
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-up');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">arrow_downward</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;

        if(el.nextElementSibling) {
          el.nextElementSibling.parentNode.insertBefore(el.nextElementSibling, el);
        }
        else {

          let col = el.parentNode;
          let block = el.parentNode.parentNode;
          let hasMoved = false;

          // check if there is a col that the el can move to
          if(col) {

            if(col.nextElementSibling) {

              if(col.nextElementSibling.classList.contains('col')) {

                col.nextElementSibling.insertBefore(el, col.nextElementSibling.firstChild);
                hasMoved = true;

              }
              // end [editor-block] check

            }
            // end sibling check
          }

          // check if there is a block that the el can move to
          if(block && hasMoved == false) {
            if(block.nextElementSibling) {

              if(block.nextElementSibling.hasAttribute('editor-block')) {

                let cols = block.nextElementSibling.querySelectorAll('.col');

                if(cols.length > 0) {
                  cols[0].insertBefore(el, cols[0].firstChild);
                }

              }
              // end [editor-block] check

            }
            // end sibling check
          
          }
          // end block check

        }


      });

      // append to menu
      menu.appendChild(span);

      // create a handle
      span = document.createElement('span');
      span.setAttribute('class', 'editor-element-separator');
      span.innerHTML = '';

      // append to menu
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-bold');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_bold</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {
        editor.execCommand('BOLD');
      });

      // append to menu
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-italic');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_italic</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {
        editor.execCommand('ITALIC');
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-underline');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_underline</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {
        editor.execCommand('UNDERLINE');
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-link');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">link</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {
        editor.execCommand('LINK');
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('span');
      span.setAttribute('class', 'editor-element-separator');
      span.innerHTML = '';

      // append to menu
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-left-align');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_align_left</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;
        let style = el.getAttribute('style') || '';

        style = style.replace('text-align: center;', '');
        style = style.replace('text-align: left;', '');
        style = style.replace('text-align: right;', '');

        el.setAttribute('data-text-alignment', 'left');
        style = 'text-align: left;' + style;
        el.setAttribute('style', style);
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-left-center');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_align_center</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;
        let style = el.getAttribute('style') || '';

        style = style.replace('text-align: center;', '');
        style = style.replace('text-align: left;', '');
        style = style.replace('text-align: right;', '');

        el.setAttribute('data-text-alignment', 'center');
        style = 'text-align: center;' + style;
        el.setAttribute('style', style);
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create a handle
      span = document.createElement('x-respond-menu-item');
      span.setAttribute('class', 'editor-element-menu-item editor-left-center');
      span.innerHTML = '<x-respond-menu-icon class="material-icons">format_align_right</x-respond-menu-icon>';

      span.addEventListener('mousedown', function(e) {

        let el = document.querySelector('[current-editor-element]');
        editor.current.node = el;
        let style = el.getAttribute('style') || '';

        style = style.replace('text-align: center;', '');
        style = style.replace('text-align: left;', '');
        style = style.replace('text-align: right;', '');

        el.setAttribute('data-text-alignment', 'right');
        style = 'text-align: right; ' + style;
        el.setAttribute('style', style);
      });

      // append the handle to the wrapper
      menu.appendChild(span);

      // create title
      span = document.createElement('x-respond-menu-title');
      span.setAttribute('class', 'editor-element-menu-title');
      span.innerHTML = '';

      // append the handle to the wrapper
      menu.appendChild(span);

      // append the handle to the wrapper
      el.appendChild(menu);

      // set menu
      editor.current.menu = menu;


    },

    /**
     * Adds a editor-sortable class to any selector in the sortable array, enables sorting
     * @param {Array} sortable
     */
    setupSortable: function() {

      var x, y, els, div, span, el, item, menu, sortable, a;

      sortable = editor.config.sortable;

      // walk through sortable clases
      for (x = 0; x < sortable.length; x += 1) {

        // setup sortable classes
        els = document.querySelectorAll('[editor] ' + sortable[x]);

        // set [data-editor-sortable=true]
        for (y = 0; y < els.length; y += 1) {

          // add attribute
          els[y].setAttribute('editor-sortable', '');

        }

      }

      // wrap elements in the sortable class
      els = document.querySelectorAll('[editor-sortable] > *');

      // wrap editable items
      for (y = 0; y < els.length; y += 1) {

        editor.setupElement(els[y]);

      }

      // set the display of empty columns
      editor.setupEmpty();

    },

    /*
     * executes a command
     */
    execCommand: function(command) {

      editor.setChanged('command executed: ' + command);

      var text, html, block = editor.current.block, element = editor.current.node;

      if(command.toUpperCase() == 'LINK') {
        // add link html
        text = editor.getSelectedText();
        html = '<a>' + text + '</a>';

        editor.current.linkSelection = html;

        document.execCommand("insertHTML", false, html);

        editor.current.linkSelection = '';

        // shows/manages the link dialog
        editor.showLinkDialog();
      }
      else if(command.toUpperCase() == 'ELEMENT.REMOVE') {

        if(element != null) {
          element.remove();
        }
      }
      else if(command.toUpperCase() == 'BLOCK.REMOVE') {
        block.remove();
        editor.setupBlocks();
      }
      else if(command.toUpperCase() == 'BLOCK.MOVEUP') {
        if(block.previousElementSibling != null) {

          if(block.previousElementSibling.hasAttribute('editor-block') === true) {
            block.parentNode.insertBefore(block, block.previousElementSibling);
          }

        }

        editor.setupBlocks();
      }
      else if(command.toUpperCase() == 'BLOCK.MOVEDOWN') {
        if(block.nextElementSibling != null) {

          if(block.nextElementSibling.hasAttribute('editor-block') === true) {
            block.nextElementSibling.parentNode.insertBefore(block.nextElementSibling, block);
          }

        }

        editor.setupBlocks();
      }
      else {
        document.execCommand(command, false, null);
      }

    },

    /**
     * Updates the UI with the attributes
     * obj = { properties: {id, cssClass, html, alt, title, src}, attributes: { custom1, custom2, custom3 } }
     */
    update: function(obj) {

      editor.setChanged('ui updated');

      let el = editor.current.node, currentValue;

      if(obj.type == null || obj.type == 'undefined') {
        obj.type = 'element';
      }

      // set component
      if(obj.type == 'component') {

        el.setAttribute('site-component', obj.component);
      }

      // set el to the current link
      if(obj.type == 'link') {
        el = editor.currLink;
      }

      // set el to the current block
      if(obj.type == 'block') {
        el = editor.current.block;
      }

      if(obj.type == 'add-block') {

        editor.appendBlock(obj.properties.html);
        return;

      }

      if(obj.properties != null && obj.properties != undefined) {

        var style = '';

        Object.keys(obj.properties).forEach(function(key,index) {

            if(key == 'id') {

              if(obj.properties.id != '') {
                el.id = obj.properties.id || '';
              }
              else {
                el.removeAttribute('id');
              }

            }
            else if(key == 'cssClass') {

              if(obj.properties.cssClass != '') {
                el.className = obj.properties.cssClass || '';
              }
              else {
                el.removeAttribute('class');
              }

            }
            else if(key == 'html') {
              if(obj.properties.html != undefined) {
                el.innerHTML = obj.properties.html || ''
              }
            }
            else if(key == 'alt') {

              if(obj.properties.alt != '') {
                el.alt = obj.properties.alt || '';
              }
              else {
                el.removeAttribute('alt');
              }

            }
            else if(key == 'title') {

              if(obj.properties.title != '') {
                el.title = obj.properties.title || '';
              }
              else {
                el.removeAttribute('title');
              }

            }
            else if(key == 'src') {
              el.src = obj.properties.src || '';
            }
            else if(key == 'srcset') {
              el.setAttribute('srcset', obj.properties.srcset || '');
            }
            else if(key == 'target') {

              if(obj.properties.target != '') {
                el.setAttribute('target', (obj.properties.target || ''));
              }
              else {
                el.removeAttribute('target');
              }

            }
            else if(key == 'parentHref') {
              
              // do not set href if it is empty
              if(obj.properties.parentHref != '') {

                // change href of A
                if(el.parentNode.nodeName.toUpperCase() == 'A') {
                  el.parentNode.href = obj.properties.parentHref;
                }
                else { // add new A
                  var img = el.parentNode.innerHTML;
                  el.parentNode.innerHTML = '<a href="' + obj.properties.parentHref + '">' + img + '</a>';
                }
              }
              else {
                // remove A if blank
                if(el.parentNode.nodeName.toUpperCase() == 'A') {
                  var img = el.parentNode.innerHTML;
                  el.parentNode.parentNode.innerHTML = img;
                }
              }
            }
            else if(key == 'href') {
              el.href = obj.properties.href || '';
            }
            else if(key == 'backgroundImage') {
              if(obj.properties.backgroundImage != '') {
                el.setAttribute('data-background-image', obj.properties.backgroundImage);
                style += 'background-image: url("' + obj.properties.backgroundImage + '");';
              }
              else {
                el.removeAttribute('data-background-image');
              }
            }
            else if(key == 'backgroundColor') {
              if(obj.properties.backgroundColor != '') {
                el.setAttribute('data-background-color', obj.properties.backgroundColor);
                style += 'background-color: ' + obj.properties.backgroundColor + ';';
              }
              else {
                el.removeAttribute('data-background-color');
              }
            }
            else if(key == 'backgroundSize') {
              if(obj.properties.backgroundSize != '') {
                el.setAttribute('data-background-size', obj.properties.backgroundSize);
                style += 'background-size: ' + obj.properties.backgroundSize + ';';
              }
              else {
                el.removeAttribute('data-background-size');
              }
            }
            else if(key == 'backgroundPosition') {
              if(obj.properties.backgroundPosition != '') {
                el.setAttribute('data-background-position', obj.properties.backgroundPosition);
                style += 'background-position: ' + obj.properties.backgroundPosition + ';';
              }
              else {
                el.removeAttribute('data-background-position');
              }
            }
            else if(key == 'backgroundRepeat') {
              if(obj.properties.backgroundRepeat != '') {
                el.setAttribute('data-background-repeat', obj.properties.backgroundRepeat);
                style += 'background-repeat: ' + obj.properties.backgroundRepeat + ';';
              }
              else {
                el.removeAttribute('data-background-repeat');
              }
            }
            else if(key == 'textColor') {
              if(obj.properties.textColor != '') {
                el.setAttribute('data-text-color', obj.properties.textColor);
                style += 'color: ' + obj.properties.textColor + ';';
              }
              else {
                el.removeAttribute('data-text-color');
              }
            }
            else if(key == 'textAlignment') {
              if(obj.properties.textAlignment != '') {
                el.setAttribute('data-text-alignment', obj.properties.textAlignment);
                style += 'text-align: ' + obj.properties.textAlignment + ';';
              }
              else {
                el.removeAttribute('data-text-alignment');
              }
            }
            else if(key == 'textShadowColor') {
              if(obj.properties.textShadowColor != '') {
                el.setAttribute('data-text-shadow-color', obj.properties.textShadowColor);
              }
              else {
                el.removeAttribute('data-text-shadow-color');
              }
            }
            else if(key == 'textShadowHorizontal') {
              if(obj.properties.textShadowHorizontal != '') {
                el.setAttribute('data-text-shadow-horizontal', obj.properties.textShadowHorizontal);
              }
              else {
                el.removeAttribute('data-text-shadow-horizontal');
              }
            }
            else if(key == 'textShadowVertical') {
              if(obj.properties.textShadowVertical != '') {
                el.setAttribute('data-text-shadow-vertical', obj.properties.textShadowVertical);
              }
              else {
                el.removeAttribute('data-text-shadow-vertical');
              }
            }
            else if(key == 'textShadowBlur') {
              if(obj.properties.textShadowBlur != '') {
                el.setAttribute('data-text-shadow-blur', obj.properties.textShadowBlur);
              }
              else {
                el.removeAttribute('data-text-shadow-blur');
              }
            }
            else if(key == 'width') {
              if(obj.properties.width != '') {
                el.setAttribute('data-width', obj.properties.width);
              }
              else {
                el.removeAttribute('data-width');
              }
            }
            else if(key == 'horizontalPadding') {
              if(obj.properties.horizontalPadding != '' && obj.properties.horizontalPadding != 'none') {
                el.setAttribute('data-horizontal-padding', obj.properties.horizontalPadding);
              }
              else {
                el.removeAttribute('data-horizontal-padding');
              }
            }
            else if(key == 'verticalPadding') {
              if(obj.properties.verticalPadding != '' && obj.properties.verticalPadding != 'none') {
                el.setAttribute('data-vertical-padding', obj.properties.verticalPadding);
              }
              else {
                el.removeAttribute('data-vertical-padding');
              }
            }
            else if(key == 'topVerticalPadding') {
              if(obj.properties.topVerticalPadding != '' && obj.properties.topVerticalPadding != 'none') {
                el.setAttribute('data-top-vertical-padding', obj.properties.topVerticalPadding);
              }
              else {
                el.removeAttribute('data-top-vertical-padding');
              }
            }
            else if(key == 'bottomVerticalPadding') {
              if(obj.properties.bottomVerticalPadding != '' && obj.properties.bottomVerticalPadding != 'none') {
                el.setAttribute('data-bottom-vertical-padding', obj.properties.bottomVerticalPadding);
              }
              else {
                el.removeAttribute('data-bottom-vertical-padding');
              }
            }

          });
      }

      if((el.getAttribute('data-text-shadow-color') || '') != '') {
        var shadow = 'text-shadow: ';
        shadow += (el.getAttribute('data-text-shadow-horizontal') || '1') + 'px ';
        shadow += (el.getAttribute('data-text-shadow-vertical') || '1') + 'px ';
        shadow += (el.getAttribute('data-text-shadow-blur') || '1') + 'px ';
        shadow += (el.getAttribute('data-text-shadow-color') || '#555') + ';';

        style += shadow;
      }

      el.style = style;

      if(obj.attributes != null && obj.attributes != undefined) {
        Object.keys(obj.attributes).forEach(function(key,index) {

            currentValue = el.getAttribute(obj.attributes[index].attr);

            // set attribute
            el.setAttribute(obj.attributes[index].attr, obj.attributes[index].value);

            // call change
            if(editor.current.menuItem.change != undefined) {
              editor.current.menuItem.change(obj.attributes[index].attr, obj.attributes[index].value, currentValue);
            }

        });
      }

    },

    /**
      * Saves the content
      */
    save: function() {

      var html, xhr;

      html = editor.retrieveChanges();

      // post data back to the parent
      window.parent.postMessage({
        command: 'save',
        data: html
      }, '*');

    },


    /**
     * Create menu
     */
    createMenu: function() {

      var x, item, a, div;

      // setup menu
      var menu = [
        {
          selector: "table[rows]",
          attributes: [
            {
              attr: 'rows',
              label: 'Rows',
              type: 'select',
              values: ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
            }  ,
            {
              attr: 'columns',
              label: 'Columns',
              type: 'select',
              values: ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
            }
          ],
          change: function(attr, newValue, oldValue) {

            var x, y, rows, curr_rows, columns, curr_columns, toBeAdded,
              toBeRemoved, table, trs, th, tr, td, tbody;

            table = editor.current.node;

            // get new
            columns = table.getAttribute('columns');
            rows = table.getAttribute('rows');

            // get curr
            curr_columns = table.querySelectorAll('thead tr:first-child th').length;
            curr_rows = table.querySelectorAll('tbody tr').length;

            // handle adding/remove columns
            if (columns > curr_columns) { // add columns

              toBeAdded = columns - curr_columns;

              var trs = table.getElementsByTagName('tr');

              // walk through table
              for (x = 0; x < trs.length; x += 1) {

                // add columns
                for (y = 0; y < toBeAdded; y += 1) {
                  if (trs[x].parentNode.nodeName == 'THEAD') {

                    th = document.createElement('th');
                    th.setAttribute('contentEditable', 'true');
                    th.innerHTML = 'New Header';

                    trs[x].appendChild(th);
                  } else {
                    td = document.createElement('td');
                    td.setAttribute('contentEditable', 'true');
                    td.innerHTML = 'New Row';

                    trs[x].appendChild(td);
                  }
                }
              }

            } else if (columns < curr_columns) { // remove columns

              toBeRemoved = curr_columns - columns;

              var trs = table.getElementsByTagName('tr');

              // walk through table
              for (x = 0; x < trs.length; x += 1) {

                // remove columns
                for (y = 0; y < toBeRemoved; y += 1) {
                  if (trs[x].parentNode.nodeName == 'THEAD') {
                    trs[x].querySelector('th:last-child').remove();
                  } else {
                    trs[x].querySelector('td:last-child').remove();
                  }
                }
              }

            }

            // handle adding/removing rows
            if (rows > curr_rows) { // add rows

              toBeAdded = rows - curr_rows;

              // add rows
              for (y = 0; y < toBeAdded; y += 1) {
                tr = document.createElement('tr');

                for (x = 0; x < columns; x += 1) {
                  td = document.createElement('td');
                  td.setAttribute('contentEditable', 'true');
                  td.innerHTML = 'New Row';
                  tr.appendChild(td);
                }

                tbody = table.getElementsByTagName('tbody')[0];
                tbody.appendChild(tr);
              }

            } else if (rows < curr_rows) { // remove columns

              toBeRemoved = curr_rows - rows;

              // remove rows
              for (y = 0; y < toBeRemoved; y += 1) {
                tr = table.querySelector('tbody tr:last-child');

                if (tr !== null) {
                  tr.remove();
                }
              }

            }

          }
        },
        {
          selector: "[site-widget=form]",
          placeholder: "<i class=\"material-icons\">radio_button_checked</i> <span>Form</span>"
        },
        {
          selector: "[site-widget=gallery]",
          placeholder: "<i class=\"material-icons\">collections</i> <span>Gallery</span>"
        },
        {
          selector: "[site-widget=slideshow]",
          placeholder: "<i class=\"material-icons\">slideshow</i> <span>Slideshow</span>"
        },
        {
          selector: "[site-widget=card]",
          placeholder: "<i class=\"material-icons\">view_weekend</i> <span>Card</span>"
        },
        {
          selector: "[site-widget=media]",
          placeholder: "<i class=\"material-icons\">art_track</i> <span>Media</span>"
        },
        {
          selector: "[site-widget=video]",
          placeholder: "<i class=\"material-icons\">local_movies</i> <span>Video</span>"
        },
        {
          selector: "[site-widget=subscribe]",
          placeholder: "<i class=\"material-icons\">repeat</i> <span>Subscribe</span>"
        },
        {
          selector: "[site-widget=\"buy-now\"]",
          placeholder: "<i class=\"material-icons\">attach_money</i> <span>Buy Now</span>"
        },
        {
          selector: "[site-widget=\"add-to-cart\"]",
          placeholder: "<i class=\"material-icons\">add_shopping_cart</i> <span>Add To Cart</span>"
        }
        ];

      editor.menu = menu.concat(editor.menu);
    },
    
    /**
     * Shows the element menu
     */
    showElementMenu: function() {

      // set current node
      var element = editor.current.node, x, title, selector, attributes = [];

      if(element == null) { return };

      // see if the element matches a plugin selector
      for (x = 0; x < editor.menu.length; x += 1) {
        if (element.matches(editor.menu[x].selector)) {
          title = editor.menu[x].title;
          selector = editor.menu[x].selector;

          // get null or not defined
          if(editor.menu[x].attributes != null && editor.menu[x].attributes != undefined) {
            attributes = editor.menu[x].attributes;
          }

          editor.current.menuItem = editor.menu[x];
        }
      }

      // get current values for each attribute
      for (x = 0; x < attributes.length; x++) {
        attributes[x].value = element.getAttribute(attributes[x].attr) || '';
      }

      // get the html of the element
      let html = element.innerHTML;

      // get background image, background color
      var backgroundImage = element.getAttribute('data-background-image') || '';
      var backgroundColor = element.getAttribute('data-background-color') || '';
      var backgroundSize = element.getAttribute('data-background-size') || '';
      var backgroundPosition = element.getAttribute('data-background-position') || '';
      var backgroundRepeat = element.getAttribute('data-background-repeat') || '';
      var textColor = element.getAttribute('data-text-color') || '';
      var textAlignment = element.getAttribute('data-text-alignment') || '';
      var textShadowColor = element.getAttribute('data-text-shadow-color') || '';
      var textShadowHorizontal = element.getAttribute('data-text-shadow-horizontal') || '';
      var textShadowVertical = element.getAttribute('data-text-shadow-vertical') || '';
      var textShadowBlur = element.getAttribute('data-text-shadow-blur') || '';

      window.parent.postMessage({
        command: 'show',
        type: 'element',
        selector: selector,
        title: title,
        properties: {
          id: element.id,
          cssClass: element.className,
          backgroundImage: backgroundImage,
          backgroundColor: backgroundColor,
          backgroundSize: backgroundSize,
          backgroundPosition: backgroundPosition,
          backgroundRepeat: backgroundRepeat,
          textColor: textColor,
          textAlignment: textAlignment,
          textShadowColor: textShadowColor,
          textShadowHorizontal: textShadowHorizontal,
          textShadowVertical: textShadowVertical,
          textShadowBlur: textShadowBlur,
          html: html
        },
        attributes: attributes
      }, '*');


    },

    /**
     * Shows the block menu
     */
    showBlockMenu: function(el) {

      var block = el;

      if(block !== null) {

        // set current node to block
        editor.current.block = block;

        // get background image, background color
        var backgroundImage = block.getAttribute('data-background-image') || '';
        var backgroundColor = block.getAttribute('data-background-color') || '';
        var backgroundSize = block.getAttribute('data-background-size') || '';
        var backgroundPosition = block.getAttribute('data-background-position') || '';
        var backgroundRepeat = block.getAttribute('data-background-repeat') || '';
        var width = block.getAttribute('data-width') || 'default';
        var horizontalPadding = block.getAttribute('data-horizontal-padding') || 'none';
        var verticalPadding = block.getAttribute('data-vertical-padding') || 'none';
        var topVerticalPadding = block.getAttribute('data-top-vertical-padding') || 'none';
        var bottomVerticalPadding = block.getAttribute('data-bottom-vertical-padding') || 'none';

        // post message to app
        window.parent.postMessage({
          type: 'block',
          selector: '.block',
          title: 'Block',
          properties: {
            id: block.id,
            cssClass: block.className,
            backgroundImage: backgroundImage,
            backgroundColor: backgroundColor,
            backgroundSize: backgroundSize,
            backgroundPosition: backgroundPosition,
            backgroundRepeat: backgroundRepeat,
            width: width,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            topVerticalPadding: topVerticalPadding,
            bottomVerticalPadding: bottomVerticalPadding
          },
          attributes: []
        }, '*');

      }
    },

    /**
     * Enable the element menu
     */
    enableElementMenu: function() {
      document.querySelector('.editor-element-menu').setAttribute('active', '');
    },

    /**
     * Disable element menu
     */
    disableElementMenu: function() {

      if(document.querySelector('[current-editor-element]') == null) {
        document.querySelector('.editor-element-menu').removeAttribute('active');
      }

    },

    /**
     * Setup contentEditable events for the editor
     */
    setupContentEditableEvents: function() {

      var x, y, z, arr, edits, isEditable, configs, isConfig, el, html,li, parent, els, isDefault, removeElement, element, modal, body, attr, div, label, control, option, menuItem, els, text, block;

      // clean pasted text, #ref: http://bit.ly/1Tr8IR3
      document.addEventListener('paste', function(e) {

        if(e.target.nodeName == 'TEXTAREA') {
          // do nothing
        }
        else {
          // cancel paste
          e.preventDefault();

          // get text representation of clipboard
          var text = e.clipboardData.getData("text/plain");

          // insert text manually
          document.execCommand("insertHTML", false, text);
        }

      });


      // get contentEditable elements
      arr = document.querySelectorAll('body');

      for (x = 0; x < arr.length; x += 1) {

        // delegate focusout to remove menu on blur
        ['focusout'].forEach(function(e) {

          arr[x].addEventListener(e, function(e) {
            editor.disableElementMenu();
          })

        });

        // delegate hover to show menu
        ['mouseover'].forEach(function(e) {

          arr[x].addEventListener(e, function(e) {

            element = null;

            if (e.target.hasAttribute('editor-element')) {
              element = e.target;
              
              // get value of text node
              var text = editor.getTextNodeValue(element);

            }
            else {
              element = editor.findParentBySelector(e.target, '[editor-element]');

              if(element) {
                // get value of text node
                var text = editor.getTextNodeValue(element);
              }
            }

            if(element) {
              //editor.current.node = element;
              //editor.setupElement(element);
            }
          })

        });

        // delegate CLICK, FOCUS event
        ['click', 'focus'].forEach(function(e) {

          arr[x].addEventListener(e, function(e) {

            let els = document.querySelectorAll('[editor-element-focused]');

            if(e.target.nodeName.toUpperCase() == 'X-RESPOND-MENU-ITEM' ||
                e.target.nodeName.toUpperCase() == 'X-RESPOND-MENU-ICON') {
              for(let y=0; y<els.length; y++) {
                // get value of text node
                var text = editor.getTextNodeValue(els[y]);
              }
            }
            else {
              for(let y=0; y<els.length; y++) {
                els[y].removeAttribute('editor-element-focused');
                // get value of text node
                var text = editor.getTextNodeValue(els[y]);
              }
            }

            if (e.target.hasAttribute('editor-element')) {
              element = e.target;
              
              // get value of text node
              var text = editor.getTextNodeValue(element);

              element.setAttribute('editor-element-focused', '');

              var grid = editor.findParentBySelector(element, '.grid');
              var firstClass = grid.classList.item(0);

              document.querySelector('x-respond-menu-title').innerHTML = '.' + firstClass + ' > ' + element.nodeName.toLowerCase();

              editor.enableElementMenu(element);

            }
            else {
              element = editor.findParentBySelector(e.target, '[editor-element]');

              if(element) {
                // get value of text node
                var text = editor.getTextNodeValue(element);

                element.setAttribute('editor-element-focused', '');

                var grid = editor.findParentBySelector(element, '.grid');
                var firstClass = grid.classList.item(0);

                document.querySelector('x-respond-menu-title').innerHTML = '.' + firstClass + ' > ' + element.nodeName.toLowerCase();

              }

              editor.enableElementMenu(element);
              
            }

            if(e.target.nodeName.toUpperCase() != 'X-RESPOND-MENU-ITEM' &&
                e.target.nodeName.toUpperCase() != 'X-RESPOND-MENU-ICON') {
              // remove all current elements
              els = document.querySelectorAll('[current-editor-element]');

              for (y = 0; y < els.length; y += 1) {
                els[y].removeAttribute('current-editor-element');
              }

              // set current element
              if (element) {
                editor.current.node = element;
                element.setAttribute('current-editor-element', 'true');
              }
            }

            // handle links
            if (e.target.nodeName == 'A') {

                // hide .editor-config
                edits = document.querySelectorAll('[editor]');

                // determines whether the element is a configuration
                isEditable = false;

                for (x = 0; x < edits.length; x += 1) {

                  if (edits[x].contains(e.target) === true) {
                    isEditable = true;
                  }

                }

                if (isEditable) {
                  editor.showLinkDialog();
                  e.preventDefault();
                }
            }
            else if (e.target.nodeName == 'IMG') {
              
              let parent = editor.findParentBySelector(e.target, '[site-component], [site-widget]');

                if(parent == null) {

                  editor.current.node = e.target;
                  editor.current.image = e.target;
                  element = e.target;

                  let parentHref = element.parentNode.getAttribute('href') || '';

                  window.parent.postMessage({
                    type: 'image',
                    selector: 'img',
                    title: 'Image',
                    properties: {
                      id: element.id,
                      cssClass: element.className,
                      src: element.getAttribute('src'),
                      srcset: element.getAttribute('srcset') || '',
                      parentHref: parentHref,
                      alt: element.getAttribute('alt'),
                      title: element.getAttribute('title')
                    },
                    attributes: []
                  }, '*');

                  e.preventDefault();

                }
                else {
                  e.preventDefault();
                }

            }
            else if(e.target.hasAttribute('site-widget')) {

              let element = e.target;

                // post message to app
                window.parent.postMessage({
                  type: 'widget',
                  widget: element.getAttribute('site-widget'),
                  properties: {
                    id: element.id,
                    cssClass: element.className,
                    html: element.innerHTML
                  },
                  attributes: []
                }, '*');

                e.preventDefault();

            }
            else if(e.target.hasAttribute('site-component')) {

                // post message to app
                window.parent.postMessage({
                  type: 'component',
                  component: element.getAttribute('site-component'),
                  properties: {
                    id: element.id,
                    cssClass: element.className,
                    html: element.innerHTML
                  },
                  attributes: []
                }, '*');

                e.preventDefault();

            }
            else if (e.target.classList.contains('editor-block-edit')) {
              let block = editor.findParentBySelector(e.target, '[editor-block]');

              editor.showBlockMenu(block);
            }
            else if (e.target.nodeName.toUpperCase() == 'X-RESPOND-MENU-ITEM' || e.target.nodeName.toUpperCase() == 'X-RESPOND-MENU-ICON') {

              let action = e.target;
              
              if(e.target.nodeName.toUpperCase() == 'X-RESPOND-MENU-ICON') {
                action = e.target.parentNode;
              } 

              // handle block actions
              if(action.classList.contains('editor-block-up')) {
                let block = editor.findParentBySelector(e.target, '[editor-block]');
                
                if(block) {
                  editor.current.block = block;
                  editor.execCommand('BLOCK.MOVEUP');
                }
              }
              else if(action.classList.contains('editor-block-down')) {
                let block = editor.findParentBySelector(e.target, '[editor-block]');
                
                if(block) {
                  editor.current.block = block;
                  editor.execCommand('BLOCK.MOVEDOWN');
                }
              }

            }
            else if (editor.findParentBySelector(e.target, '[site-component]') !== null) {

                var parentNode = editor.findParentBySelector(e.target, '[site-component]');

                // get current node
                editor.current.node = parentNode;

            }
            else if (editor.findParentBySelector(e.target, '[site-plugin]') !== null) {

              var parentNode = editor.findParentBySelector(e.target, '[site-plugin]');

              // get current node
              editor.current.node = parentNode;

          }
            else if (e.target.hasAttribute('contentEditable')) {

              editor.current.node = e.target;

              if(editor.current.node.nodeName == 'TH' || editor.current.node.nodeName == 'TD') {
                var parentNode = editor.findParentBySelector(e.target, '.table');

                if(parentNode != null) {
                  editor.current.node = parentNode;
                }
              }

              if(editor.current.node.nodeName == 'LI') {
                var parentNode = editor.findParentBySelector(e.target, 'ul');

                if(parentNode != null) {
                  editor.current.node = parentNode;
                }

                var parentNode = editor.findParentBySelector(e.target, 'ol');

                if(parentNode != null) {
                  editor.current.node = parentNode;
                }
              }

            }
            else if (e.target.className == 'dz-hidden-input') {
              // do nothing
            }
            else {
              // hide .editor-config
              configs = document.querySelectorAll(
                '.editor-config, .editor-menu'
              );

              // determines whether the element is a configuration
              isConfig = false;

              for (x = 0; x < configs.length; x += 1) {

                if (configs[x].contains(e.target) === true) {
                  isConfig = true;
                }

              }

              // hide if not in config
              if (isConfig === false) {

                for (x = 0; x < configs.length; x += 1) {
                  configs[x].removeAttribute('visible');
                }

              }
            }

          });

        });


        // delegate INPUT event
        ['input'].forEach(function(e) {
          arr[x].addEventListener(e, function(e) {

            if (e.target.hasAttribute('contentEditable')) {

              el = e.target;

              while (el !== null) {

                var node = el.childNodes[0];

                if (editor.debug === true) {
                  console.log('input event');
                  console.log(el.nodeName);
                }

                html = el.innerHTML;

                // strip out &nbsps
                html = editor.replaceAll(html, '&nbsp;', ' ');

                // trim
                html = html.trim();

                // set to null
                el = null;
              }

            }


          });

        });

        // delegate keydown event
        ['keydown'].forEach(function(e) {
          arr[x].addEventListener(e, function(e) {

            editor.setChanged('[keyed]');

            if (e.target.hasAttribute('contentEditable')) {

              el = e.target;

              // ENTER key
              if (e.keyCode === 13) {

                // console.log('[enter] key pressed, node=' + el.nodeName);

                if (el.nodeName == 'LI') {

                  // console.log('[enter] LI!');

                  // create LI
                  li = document.createElement('li');
                  li.setAttribute('contentEditable', true);

                  // append LI
                  el.parentNode.appendChild(li);

                  el.parentNode.lastChild.focus();

                  e.preventDefault();
                  e.stopPropagation();

                }
                else if (el.nodeName == 'P') {

                  var node = editor.append('<p>Tap to update</p>', true);

                  editor.current.node = node;

                  editor.setupElement(node);

                  e.preventDefault();
                  e.stopPropagation();

                }

              }

              // DELETE key
              if (e.keyCode === 8) {

                if (el.nodeName == 'LI') {

                  if (el.innerHTML === '') {

                    if (el.previousSibling !== null) {

                      parent = el.parentNode;

                      el.remove();

                      parent.lastChild.focus();
                    }

                    e.preventDefault();
                    e.stopPropagation();
                  }

                } // end LI

              }

            }


          });

        });

      }

    },

    /**
     * Returns the value of the text node
     */
    getTextNodeValue: function(el) {

      if(el == null) {
        return;
      }

      var text = '';

      for (var i = 0; i < el.childNodes.length; i++) {
          var curNode = el.childNodes[i];
          var whitespace = /^\s*$/;

          if(curNode === undefined) {
            text = "";
            break;
          }

          if (curNode.nodeName === "#text" && !(whitespace.test(curNode.nodeValue))) {
              text = curNode.nodeValue;
              break;
          }
      }

      return text.trim();

    },

    /**
     * Selects element contents
     */
    selectElementContents: function(el) {
      var range, sel;

      range = document.createRange();
      range.selectNodeContents(el);
      sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    },

    /**
     * Appends items to the editor
     */
    append: function(html, insertAfter) {

      if(insertAfter == null || insertAfter == undefined) {
        insertAfter = false;
      }

      editor.setChanged('item appended');

      var x, newNode, node, firstChild;

      // create a new node
      newNode = document.createElement('div');
      newNode.innerHTML = html;

      // get new new node
      newNode = newNode.childNodes[0];
      newNode.setAttribute('editor-element', '');

      // get existing node
      node = document.querySelector('[editor-sortable] [data-selector]');

      if (node === null) {

        if (editor.current.node !== null) {

          if(insertAfter == false) {
            // insert before current node
            editor.current.node.parentNode.insertBefore(newNode, editor.current.node);
          }
          else {
            editor.current.node.parentNode.insertBefore(newNode, editor.current.node.nextSibling);
          }

        }

      }
      else {
        // replace existing node with newNode
        node.parentNode.replaceChild(newNode, node);
      }

      var types = 'p, h1, h2, h3, h4, h5, li, td, th, blockquote, pre';

      // set editable children
      var editable = newNode.querySelectorAll(types);

      for (x = 0; x < editable.length; x += 1) {
        editable[x].setAttribute('contentEditable', 'true');
      }

      if (types.indexOf(newNode.nodeName.toLowerCase()) != -1) {
        newNode.setAttribute('contentEditable', 'true');
      }

      // select element
      function selectElementContents(el) {
        var range = document.createRange();
        range.selectNodeContents(el);
        var sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
      }

      // focus on first element
      if (editable.length > 0) {

        editable[0].focus();
        selectElementContents(editable[0]);

        // select editable contents, #ref: http://bit.ly/1jxd8er
        editor.selectElementContents(editable[0]);
      }
      else {

        if(newNode.matches(types)) {

          newNode.focus();
          editor.selectElementContents(newNode);

        }

      }

      return newNode;

    },

    /**
     * Duplicates a block and appends it to the editor
     */
    duplicateBlock: function(current, position) {

      var x, newNode, node, firstChild;

      // create a new node
      newNode = current.cloneNode(true);

      // create new node in mirror
      if (position == 'before') {

        // insert element
        current.parentNode.insertBefore(newNode, current);

      }

      // re-init sortable
      editor.setupSortable();

      return newNode;

    },

    /**
     * Appends blocks to the editor
     */
    appendBlock: function(html) {

      editor.setChanged('block appended');

      var el = document.querySelector('[editor]'), x, newNode, node, firstChild;

      // create a new node
      newNode = document.createElement('div');
      newNode.innerHTML = html;

      // get new new node
      newNode = newNode.childNodes[0];

      // append to the end of the editor
      el.appendChild(newNode);

      // setup contentEditable
      var types = 'p, h1, h2, h3, h4, h5, li, td, th, blockquote, pre';

      // set editable children
      var editable = newNode.querySelectorAll(types);

      for (x = 0; x < editable.length; x += 1) {
        editable[x].setAttribute('contentEditable', 'true');
      }

      if (types.indexOf(newNode.nodeName.toLowerCase()) != -1) {
        newNode.setAttribute('contentEditable', 'true');
      }

      // re-init sortable
      editor.setupSortable();

      // setup blocks
      editor.setupBlocks();

      // scroll to bottom
      window.scrollTo(0,document.body.scrollHeight);

      return newNode;

    },

    /**
     * Sets up the link dialog
     */
    showLinkDialog: function() {

      var id, cssClass, href, target, title, link, element;

      // get selected link
      editor.currLink = editor.getLinkFromSelection();

      // populate link values
      if (editor.currLink !== null) {

        element = editor.currLink;

        // pass message to parent window
        window.parent.postMessage({
          type: 'link',
          selector: 'a',
          title: 'Link',
          properties: {
            id: element.id || '',
            cssClass: element.className,
            href: element.getAttribute('href'),
            target: element.getAttribute('target'),
            title: element.getAttribute('title'),
            html: element.innerHTML
          },
          attributes: []
        }, '*');

      }

    },

    /**
     * Executes a function by its name and applies arguments
     * @param {String} functionName
     * @param {String} context
     */
    executeFunctionByName: function(functionName, context /*, args */ ) {

      var i, args, namespaces, func;

      args = [].slice.call(arguments).splice(2);
      namespaces = functionName.split(".");

      func = namespaces.pop();
      for (i = 0; i < namespaces.length; i++) {
        context = context[namespaces[i]];
      }

      return context[func].apply(this, args);
    },

    /**
     * Retrieves selected text
     */
    getSelectedText: function() {

      var text = "";
      if (window.getSelection) {
        text = window.getSelection().toString();
      } else if (document.selection && document.selection.type !=
        "Control") {
        text = document.selection.createRange().text;
      }
      return text;
    },

    /**
     * Saves text selection
     */
    saveSelection: function() {

      var ranges, i, sel, len;

      if (window.getSelection) {
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
          ranges = [];
          len = sel.rangeCount;
          for (i = 0; i < len; i += 1) {
            ranges.push(sel.getRangeAt(i));
          }
          return ranges;
        }
      } else if (document.selection && document.selection.createRange) {
        return document.selection.createRange();
      }
      return null;
    },

    /**
     * Retrieve a link from the selection
     */
    getLinkFromSelection: function() {

      var parent, selection, range, div, links;

      parent = null;

      if (document.selection) {
        parent = document.selection.createRange().parentElement();
      } else {
        selection = window.getSelection();
        if (selection.rangeCount > 0) {
          parent = selection.getRangeAt(0).startContainer.parentNode;
        }
      }

      if (parent !== null) {
        if (parent.tagName == 'A') {
          return parent;
        }
      }

      if (window.getSelection) {
        selection = window.getSelection();

        if (selection.rangeCount > 0) {
          range = selection.getRangeAt(0);
          div = document.createElement('DIV');
          div.appendChild(range.cloneContents());
          links = div.getElementsByTagName("A");

          if (links.length > 0) {
            return links[0];
          } else {
            return null;
          }

        }
      }

      return null;
    },

    /**
     * Restore the selection
     * @param {?} savedSelection
     */
    restoreSelection: function(savedSel) {
      var i, len, sel;

      if (savedSel) {
        if (window.getSelection) {
          sel = window.getSelection();
          sel.removeAllRanges();
          len = savedSel.length;
          for (i = 0; i < len; i += 1) {
            sel.addRange(savedSel[i]);
          }
        } else if (document.selection && savedSel.select) {
          savedSel.select();
        }
      }
    },

    /**
     * Retrieves a QS by name
     * @param {String} name
     */
    getQueryStringByName: function(name) {

      var regexS, regex, results;

      name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
      regexS = "[\\?&]" + name + "=([^&#]*)";
      regex = new RegExp(regexS);
      results = regex.exec(window.location.href);

      if (results === null) {
        return '';
      } else {
        return decodeURIComponent(results[1].replace(/\+/g, " "));
      }
    },

    /**
     * Retrieve changes
     */
    retrieveChanges: function() {

      var x, y, data, els, el, refs, actions, html;

      data = [];

      el = document.querySelector('[editor]')

      if (el) {

        // remove action
        actions = el.querySelectorAll('.editor-edit');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove action
        actions = el.querySelectorAll('.editor-move');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove action
        actions = el.querySelectorAll('.editor-properties');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove action
        actions = el.querySelectorAll('.editor-remove');

        for(y=0; y<actions.length; y++) {

          // remove child
          actions[y].parentNode.removeChild(actions[y]);

        }

        // remove action
        actions = el.querySelectorAll('.editor-add');

        for(y=0; y<actions.length; y++) {

          // remove child
          actions[y].parentNode.removeChild(actions[y]);

        }

        // remove block menus
        actions = el.querySelectorAll('.editor-block-menu');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove placeholders
        actions = el.querySelectorAll('.editor-placeholder');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove block menus
        actions = el.querySelectorAll('.editor-element-menu');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove text menus
        actions = el.querySelectorAll('.editor-text-menu');

        for(y=0; y<actions.length; y++) {
          actions[y].parentNode.removeChild(actions[y]);
        }

        // remove attributes
        actions = el.querySelectorAll('[editor-block]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('editor-block');
        }

        // remove attributes
        actions = el.querySelectorAll('[editor-element]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('editor-element');
        }

        // remove editor-element-focused
        actions = el.querySelectorAll('[editor-element-focused]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('editor-element-focused');
        }

        // remove attributes
        actions = el.querySelectorAll('[editor-sortable]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('editor-sortable');
        }

        // remove attributes
        actions = el.querySelectorAll('[editor-empty]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('editor-empty');
        }

        // remove attributes
        actions = el.querySelectorAll('[contenteditable]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('contenteditable');
        }

        // remove attributes
        actions = el.querySelectorAll('[current-editor-element]');

        for(y=0; y<actions.length; y++) {
          actions[y].removeAttribute('current-editor-element');
        }

        // get html
        html = el.innerHTML;

        // cleanup empty attributs
        html = editor.replaceAll(html, 'id=""', '');
        html = editor.replaceAll(html, 'class=""', '');
        html = editor.replaceAll(html, 'data-text-color=""', '');
        html = editor.replaceAll(html, 'data-text-shadow-color=""', '');
        html = editor.replaceAll(html, 'data-text-shadow-horizontal=""', '');
        html = editor.replaceAll(html, 'data-text-shadow-vertical=""', '');
        html = editor.replaceAll(html, 'data-text-shadow-blur=""', '');
        html = editor.replaceAll(html, 'draggable="true"', '');
        html = editor.replaceAll(html, 'draggable="false"', '');
        html = editor.replaceAll(html, 'style=""', '');
        html = editor.replaceAll(html, 'respond-plugin=""', 'respond-plugin');
        html = html.replace(/  +/g, ' ');

      }

      return html;

    },

    /**
     * Setup the editor
     * @param {Array} incoming
     */
    setup: function(incoming) {

      var main, body, attr, stylesheet, sortable, url, blocks;

      // get body
      body = document.querySelector('body');

      // main
      main = document.querySelector('[role=main]');
      main.setAttribute('editor', 'true');
      main.setAttribute('style', 'padding-top: 40px;');


      // register dom elements
      if(window.customElements) {
        window.customElements.define('x-respond-menu', class extends HTMLElement {});
        window.customElements.define('x-respond-menu-item', class extends HTMLElement {});
        window.customElements.define('x-respond-menu-label', class extends HTMLElement {});
        window.customElements.define('x-respond-menu-icon', class extends HTMLElement {});
      }
      else if(document.registerElement) {
        document.registerElement('x-respond-menu');
        document.registerElement('x-respond-menu-item');
        document.registerElement('x-respond-menu-label');
        document.registerElement('x-respond-menu-icon');
      }

      // production
      sortable = ['.sortable'];
      url = null;
      blocks = [];

      // get attributes
      if(body != null) {

        if(incoming.path) {
          path = incoming.path;
        }

        // setup sortable
        if(incoming.sortable) {

          if(incoming.sortable != '') {
            sortable = incoming.sortable.split(',');
          }

        }

        // setup blocks
        if(incoming.blocks) {

          if(incoming.blocks != '') {
            blocks = incoming.blocks.split(',');
          }

        }

        // setup editable
        if(incoming.editable) {

          if(incoming.editable != '') {
            editable = incoming.editable.split(',');
          }

        }

      }

      // setup config
      var config = {
        sortable: sortable,
        blocks: blocks
      };

      // set url
      if (url != null) {
        config.url = url;
      }

      // setup editor
      editor.setupEditor(config);

      // setup message handling
      editor.setupMessageHandler();

    },

    /**
     * Setup the message handler to receive messages from the app;
     */
    setupMessageHandler: function() {

      window.addEventListener('message', function(event) {

        console.log('editor.message', event);

        if(event.data.command) {

          if(event.data.command == 'save') {
            editor.save();
          }
          else if(event.data.command == 'command') {
            editor.execCommand(event.data.text);
          }
          else if(event.data.command == 'update') {
            editor.update(event.data.obj);
          }
          else if(event.data.command == 'reload') {
            location.reload();
          }
          else if(event.data.command == 'add') {

            let html = event.data.html;
            let isLayout = event.data.isLayout;
            let insertAfter = (event.data.insertAfter == 'true');

            if(isLayout == true) {
              editor.appendBlock(html);
            }
            else {
              let node = editor.append(html, insertAfter);
              
              // setup contextual menu
              editor.setupElement(node);
              //editor.setupPlaceholder();
            }

          }

        }

      });

    },

    /**
     * Setup the editor
     * @param {Array} config.sortable
     */
    setupEditor: function(config) {

      var x, style;

      // save config
      editor.config = config;

      // set path
      if (config.path != null) {
        editor.path = config.path;
      }

      // create container
      editor.current.container = document.createElement('div');
      editor.current.container.setAttribute('class', 'editor-container');
      editor.current.container.setAttribute('id', 'editor-container');

      // set url
      if (config.url !== null) {
        editor.url = config.url;
      }

      // append container to body
      document.body.appendChild(editor.current.container);

      // set default auth
      var obj = {
        credentials: 'include'
      }

      // enable token based auth
      if(editor.useToken) {

        // set obj headers
        obj = {
          headers: {}
        };

        obj.headers[editor.authHeader] = editor.authHeaderPrefix + ' ' + localStorage.getItem(editor.tokenName);
      }

      // init editor
      editor.setActive();
      editor.setupSortable();
      editor.setupElementMenu(document.body);
      editor.setupBlocks();
      editor.setContentEditable();
      editor.setupContentEditableEvents();
      editor.createMenu(config.path);
      // editor.setupPlaceholder();

      // setup loaded event
      var event = new Event('editor.loaded');
      document.dispatchEvent(event);

      // post data back to the parent
      window.parent.postMessage({
        command: 'editor-loaded'
      }, '*');


    },

    /**
     * Replace all occurrences of a string
     * @param {String} src - Source string (e.g. haystack)
     * @param {String} stringToFind - String to find (e.g. needle)
     * @param {String} stringToReplace - String to replacr
     */
    replaceAll: function(src, stringToFind, stringToReplace) {

      var temp, index;

      temp = src;
      index = temp.indexOf(stringToFind);

      while (index != -1) {
        temp = temp.replace(stringToFind, stringToReplace);
        index = temp.indexOf(stringToFind);
      }

      return temp;
    },

    /**
     * Find the parent by a selector ref: http://stackoverflow.com/questions/14234560/javascript-how-to-get-parent-element-by-selector
     * @param {Array} config.sortable
     */
    findParentBySelector: function(elm, selector) {
      var all, cur;

      all = document.querySelectorAll(selector);
      cur = elm.parentNode;

      while (cur && !editor.collectionHas(all, cur)) { //keep going up until you find a match
        cur = cur.parentNode; //go up
      }
      return cur; //will return null if not found
    },

    /**
     * Helper for findParentBySelecotr
     * @param {Array} config.sortable
     */
    collectionHas: function(a, b) { //helper function (see below)
      var i, len;

      len = a.length;

      for (i = 0; i < len; i += 1) {
        if (a[i] == b) {
          return true;
        }
      }
      return false;
    }

  };

}());