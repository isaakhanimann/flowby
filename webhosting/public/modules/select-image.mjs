import { Upload } from '/modules/upload.mjs'

/*
 * Models the select image modal
 */
export class SelectImageModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="select-image-modal" class="app-modal app-modal-priority-2">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-select-image-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

            <h2>Select Image</h2>

            <div id="app-upload" class="app-upload">Upload</div>
        
            <div class="app-modal-list app-modal-list-compressed"></div>

        </div>
        </section>`

        this.properties = {}
        this.attributes = {}
        this.target = null
        this.thumb = null

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#select-image-modal')

        let el = document.querySelector('#app-upload'),
            context = this

        let upload = new Upload(
            // upload el
            el, 
            "/api/file/upload", // url
            "POST",
            // complete
            function(file) {
                context.fillList()
            },
            // error
            function(status, text) {}
        );


        // fill list
        this.fillList()

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    fillList() {

        let data = {},
              context = this
        
        // clear list
        context.modal.querySelector('.app-modal-list').innerHTML = ''

        // post form
        var xhr = new XMLHttpRequest()
        xhr.open('GET', '/api/image/list', true)
        xhr.setRequestHeader('Content-Type', 'application/json')
        xhr.send(JSON.stringify(data))

        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 400) {
                let json = JSON.parse(xhr.responseText)

                json.forEach(i => {

                    let item = document.createElement('a')
                    item.setAttribute('class', 'app-modal-list-item app-modal-list-item-has-image')
                    item.setAttribute('data-url', i.url)
                    item.setAttribute('data-thumb', i.thumb)

                    item.innerHTML += `<h3>${i.name}</h3>
                                <p>${i.url}</p>
                                <img class="app-modal-list-item-image" src="${i.preview}">
                                <i class="material-icons">arrow_forward</i>`

                    context.modal.querySelector('.app-modal-list').appendChild(item)

                    // handle click of list item
                    item.addEventListener('click', function(e) {
                      if(context.target) {
                        document.querySelector(context.target).value = e.target.getAttribute('data-url')
                      }
                      if(context.thumb) {
                        document.querySelector(context.thumb).value = e.target.getAttribute('data-thumb')
                      }
                      context.toggleModal()
                    })
                });

                
            }
            else {
            }
        }
        // end xhr

    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // handle toggles
        var toggles = document.querySelectorAll('[toggle-select-image-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // listen for event to show modal
        window.addEventListener('app.selectImage', data => {
          console.log('[app.selectImage] detail', data.detail)
          context.target = data.detail.target || null
          context.thumb = data.detail.thumb || null
          context.toggleModal()
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

}