/*
 * Models the edit gallery modal
 */
export class EditGalleryModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-gallery-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-gallery-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

            <form>
              <h2>Images</h2>

              <button id="button-add-gallery-image" class="app-modal-add-button">Add Image</button>
              
              <div class="app-modal-list"></div>            

              <div class="app-modal-actions">
                <button type="submit">Update</button>
              </div>
            </form>

        </div>
        </section>`

        this.properties = {}
        this.attributes = {}

        this.images = []
        this.target = null

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-gallery-modal')
        this.form = this.modal.querySelector('form')

        this.type = 'slideshow'
        
        // handle events
        this.setupEvents()
    }

    /*
     * Move item in array
     */
    move(from, to) {

        if (to >= this.images.length) {
            var k = to - this.images.length + 1;
            while (k--) {
                this.images.push(undefined);
            }
        }

        this.images.splice(to, 0, this.images.splice(from, 1)[0]);
    }

    /*
     * Removes an item from the array
     */
    remove(index) {
      this.images.splice(index, 1);
    }

    /*
     * Build HTML from images
     */
    buildHTML() {

      let html = '', image = '', menu = '<ul class="site-slideshow-menu">'

      if(this.type == 'slideshow') {
        html += '<div class="site-slideshow-container">'
      }
  
      for(let x=0; x < this.images.length; x++) {
  
        let title = this.images[x].title
        let description = this.images[x].description
        let index = x+1
  
        if(title == 'No caption') {
          title = ''
        }
  
        // set menu
        if(x==0) {
          menu += `<li><a data-index="${x}" active>${index}</a></li>`;
        }
        else {
          menu += `<li><a data-index="${x}">${index}</a></li>`;
        }
  
        // get image
        if(this.type == 'slideshow') {
  
          let caption = '';
  
          if(title != '') {
            caption = `<div class="site-slideshow-caption">
                            <h4>${title}</h4>
                          </div>`;
          }
  
          // slideshow
          image = `<div class="site-slideshow-image">
              <img src="${this.images[x].src}">
              ${caption}
            </div>`;
  
        }
        else if(this.type == 'card') {
  
          // card
          image = `<a class="site-card" href="${this.images[x].href}">
            <div class="site-card-image" style="background-image: url(${this.images[x].src})">
              <img src="${this.images[x].src}">
            </div>
            <div class="site-media-body">
              <h4>${title}</h4>
              <p>${this.images[x].text}</p>
            </div>
            </a>`;
  
        }
        else if(this.type == 'media') {
  
          let href = '';
  
          if(this.images[x].href.trim() != '') {
            href = `href="${this.images[x].href}"`
          }
  
          // media
          image = `<a class="site-media-element" ${href}>
              <div class="site-media-image">
                <img src="${this.images[x].src}">
              </div>
              <div class="site-media-body">
                <h4>${title}</h4>
                <p>${this.images[x].text}</p>
              </div>
            </a>`;
  
        }
        else if(this.type =='product-images') {
  
          // product
          if(x == 0) {
            image = `<div class="site-product-image">
              <a href="${this.images[x].href}" title="${title}" site-lightbox><img src="${this.images[x].src}"></a> 
              </div><div class="site-product-image">
              <a href="${this.images[x].href}" title="${title}" site-product-secondary-image><img src="${this.images[x].src}"></a> 
              </div>`;
          }
          else {
            image = `<div class="site-product-image">
              <a href="${this.images[x].href}" title="${title}" site-product-secondary-image><img src="${this.images[x].src}"></a> 
              </div>`
          }
  
        }
        else {
  
          // gallery
          image = `<div class="site-gallery-image">
            <a href="${this.images[x].href}" title="${title}" site-lightbox><img src="${this.images[x].src}"></a> 
            </div>`
  
        }
  
        html += image

      }

      menu += `</ul>`;

      if(this.type == 'slideshow') {
        html = html + '</div>' + menu;
      }

      return html

    }

    /*
     * Update the HTML
     */
    update() {
        let html = this.buildHTML()
        shared.sendUpdate({type: 'element', properties: {html: html}})
    }

    /*
     * Setup events
     */
    fillList() {

        let context = this,
            list = context.modal.querySelector('.app-modal-list')

        // clear images
        this.images = []

        // parse HTML
        this.parseHTML(this.properties.html)

        // update the list
        this.updateList()

    }

    /*
     * Update the list
     */
    updateList() {

      let context = this,
            list = context.modal.querySelector('.app-modal-list'),
            x = 0

      list.innerHTML = ''

      // bind array to html
      this.images.forEach(i => {

          let item = document.createElement('a')
          item.setAttribute('class', 'app-modal-sortable-item app-modal-sortable-item-has-image')

          item.innerHTML += `<i class="drag-handle material-icons">drag_handle</i>
                      <div class="app-modal-list-item-image"><img src="${i.display}"></div>
                      <h3>${i.title}</h3>
                      <p>${i.src}</p>
                      <i class="remove-item material-icons">remove_circle_outline</i>`

          list.appendChild(item)

          // handle click of list item
          item.addEventListener('click', function(e) {

              if(!e.target.classList.contains('drag-handle') && !e.target.classList.contains('remove-item')) {

                // get index
                let element = e.target,
                    index = Array.from(element.parentNode.children).indexOf(element)

                // edit image
                window.dispatchEvent(new CustomEvent('app.editGalleryImage', {detail: {image: context.images[index], type: context.type, index: context.index}}))

              }
              else if(e.target.classList.contains('remove-item')) {

                // get index
                let element = e.target.parentNode,
                    index = Array.from(element.parentNode.children).indexOf(element)

                // remove and update
                context.remove(index)
                context.updateList()

              }

          })
          
          x++

      });

      // make list sortable
      Sortable.create(list, {
          handle: '.drag-handle',
          onEnd: function (e) {
              context.move(e.oldIndex, e.newIndex)
          },

      })

    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // handle toggles
        var toggles = document.querySelectorAll('[toggle-edit-gallery-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // listen for the editor event to show modal
        window.addEventListener('app.updateGalleryImage', data => {

          // update image
          context.images[data.detail.index] = data.detail.image

          // update
          context.updateList()
          
        })

        // listen for event to show modal
        window.addEventListener('editor.event', data => {

            console.log('[edit.gallery] detail', data.detail)
  
            if(data.detail.type == 'widget' && data.detail.widget == 'gallery') {
              context.properties = data.detail.properties
              context.type = 'gallery'
              context.fillList()
              context.toggleModal()
            }
            else if(data.detail.type == 'widget' && data.detail.widget == 'slideshow') {
              context.properties = data.detail.properties
              context.type = 'slideshow'
              context.fillList()
              context.toggleModal()
            }

        })

        // handle form submission
        this.form.addEventListener('submit', function(e) {

          e.preventDefault()

          context.update()
          context.toggleModal()

          return false
        })

        // add button
        document.querySelector('#button-add-gallery-image').addEventListener('click', function(e) { 

          // set image
          let image = {
            type: this.type,
            src: "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNTAwcHgiIGhlaWdodD0iNTAwcHgiIHZpZXdCb3g9IjAgMCA1MDAgNTAwIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHN0eWxlPSJiYWNrZ3JvdW5kOiAjODg4ODg4OyI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDQ5LjIgKDUxMTYwKSAtIGh0dHA6Ly93d3cuYm9oZW1pYW5jb2RpbmcuY29tL3NrZXRjaCAtLT4KICAgIDx0aXRsZT5EZXNrdG9wIENvcHkgODwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxkZWZzPjwvZGVmcz4KICAgIDxnIGlkPSJEZXNrdG9wLUNvcHktOCIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZm9udC1mYW1pbHk9IkF2ZW5pck5leHQtUmVndWxhciwgQXZlbmlyIE5leHQiIGZvbnQtc2l6ZT0iNDgiIGZvbnQtd2VpZ2h0PSJub3JtYWwiPgogICAgICAgIDx0ZXh0IGlkPSJQbGFjZWhvbGRlciIgZmlsbD0iI0ZGRkZGRiI+CiAgICAgICAgICAgIDx0c3BhbiB4PSIxMTkuMTI4IiB5PSIyNjUiPlBsYWNlaG9sZGVyPC90c3Bhbj4KICAgICAgICA8L3RleHQ+CiAgICA8L2c+Cjwvc3ZnPg==",
            href: "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNTAwcHgiIGhlaWdodD0iNTAwcHgiIHZpZXdCb3g9IjAgMCA1MDAgNTAwIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHN0eWxlPSJiYWNrZ3JvdW5kOiAjODg4ODg4OyI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDQ5LjIgKDUxMTYwKSAtIGh0dHA6Ly93d3cuYm9oZW1pYW5jb2RpbmcuY29tL3NrZXRjaCAtLT4KICAgIDx0aXRsZT5EZXNrdG9wIENvcHkgODwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxkZWZzPjwvZGVmcz4KICAgIDxnIGlkPSJEZXNrdG9wLUNvcHktOCIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZm9udC1mYW1pbHk9IkF2ZW5pck5leHQtUmVndWxhciwgQXZlbmlyIE5leHQiIGZvbnQtc2l6ZT0iNDgiIGZvbnQtd2VpZ2h0PSJub3JtYWwiPgogICAgICAgIDx0ZXh0IGlkPSJQbGFjZWhvbGRlciIgZmlsbD0iI0ZGRkZGRiI+CiAgICAgICAgICAgIDx0c3BhbiB4PSIxMTkuMTI4IiB5PSIyNjUiPlBsYWNlaG9sZGVyPC90c3Bhbj4KICAgICAgICA8L3RleHQ+CiAgICA8L2c+Cjwvc3ZnPg==",
            title: "Placeholder caption",
            display: "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNTAwcHgiIGhlaWdodD0iNTAwcHgiIHZpZXdCb3g9IjAgMCA1MDAgNTAwIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHN0eWxlPSJiYWNrZ3JvdW5kOiAjODg4ODg4OyI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDQ5LjIgKDUxMTYwKSAtIGh0dHA6Ly93d3cuYm9oZW1pYW5jb2RpbmcuY29tL3NrZXRjaCAtLT4KICAgIDx0aXRsZT5EZXNrdG9wIENvcHkgODwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxkZWZzPjwvZGVmcz4KICAgIDxnIGlkPSJEZXNrdG9wLUNvcHktOCIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZm9udC1mYW1pbHk9IkF2ZW5pck5leHQtUmVndWxhciwgQXZlbmlyIE5leHQiIGZvbnQtc2l6ZT0iNDgiIGZvbnQtd2VpZ2h0PSJub3JtYWwiPgogICAgICAgIDx0ZXh0IGlkPSJQbGFjZWhvbGRlciIgZmlsbD0iI0ZGRkZGRiI+CiAgICAgICAgICAgIDx0c3BhbiB4PSIxMTkuMTI4IiB5PSIyNjUiPlBsYWNlaG9sZGVyPC90c3Bhbj4KICAgICAgICA8L3RleHQ+CiAgICA8L2c+Cjwvc3ZnPg==",
            text: ""
          }

          // push image
          context.images.push(image);

          // update ui
          context.updateList()

          e.preventDefault()
        })

    }

    /*
     * Toggles the slide-in modal
     */
    toggleModal() {
        if(this.modal.hasAttribute('active')) {
           this.modal.removeAttribute('active')     
        }
        else {
            this.modal.setAttribute('active', '')
        }
    }

  /**
   * Parses the HTML into usable form images
   * <div class="site-gallery-image">
   * <a href="#" title="" site-lightbox=""><img src="images/sample.png"></a> 
   * </div>
   */
  parseHTML(html) {

    let parser = new DOMParser();
    let doc = parser.parseFromString(html, 'text/html');
    let el = null;

    // get images
    let links = doc.querySelectorAll('a');
    let images = doc.querySelectorAll('img');
    let h4s = doc.querySelectorAll('h4');
    let texts = doc.querySelectorAll('p');
    let x = 0;

    if(this.type =='product-images') {
      x=1;
    }

    for(x; x<images.length; x++) {

      let title = '', href = '', display = '', text = '', src = this.placeholder;
      
      if(links[x]) {
        title = links[x].getAttribute('title') || 'No caption';
        href = links[x].getAttribute('href') || '#';
      }

      if(h4s[x]) {
        title = h4s[x].innerHTML;
      }

      if(images[x]) {
        src = images[x].getAttribute('src')  || this.placeholder;
      }

      if(texts[x]) {
        text = texts[x].innerHTML;
      }

      display = src;

      // make sure the image is not an external image or data uri
      if(src.indexOf('http://') == -1 && src.indexOf('https://') == -1 && src.indexOf('data:') == -1) {
        display = '/' + src;
      }

      // get image
      let image = {
        type: this.type,
        src: src,
        href: href,
        title: title,
        display: display,
        text: text
      };

      console.log('[image]', image)

      // push image
      this.images.push(image)

    }

  }

}