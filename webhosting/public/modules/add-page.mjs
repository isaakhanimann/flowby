/*
 * Models the add page modal
 */
export class AddPageModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="add-page-modal" class="app-modal">
            
          <div class="app-modal-container">

            <a class="app-modal-close" toggle-add-page-modal>
                <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>
        
            <form>
        
              <h2>Add Page</h2>
        
              <div class="app-modal-form">
        
                <div id="select-page-type" class="app-modal-image-select">
        
                    <a data-type="page" active>
                      <i class="material-icons">font_download</i>
                      <span>Page</span>
                    </a>

                    <a data-type="post">
                      <i class="material-icons">description</i>
                      <span>Post</span>
                    </a>

                    <a data-type="gallery">
                      <i class="material-icons">insert_photo</i>
                      <span>Gallery</span>
                    </a>

                    <a data-type="form">
                      <i class="material-icons">radio_button_checked</i>
                      <span>Form</span>
                    </a>
                  
                </div>
        
                <div class="app-modal-form-group">
                  <label>* Name</label>
                  <input id="app-add-page-name" type="text" maxlength="128" required name="name">
                </div>
        
                <div class="app-modal-form-group">
                  <div class="input-group">
                    <label>* URL</label>
                    <input id="app-add-page-url" type="text" maxlength="128" placeholder="new-page" required name="url">
                    <span class="postfix">.html</span>
                  </div>
                  <small>Your URL should not contain special characters or spaces.  You can use a hyphen or underscore to delineate words.</small>
                </div>
        
                <div class="app-modal-form-group">
                  <label>Description</label>
                  <textarea id="app-add-page-description" name="description"></textarea>
                </div>
        
              </div>
        
              <div class="app-modal-actions">
                <button type="submit">Add Page</button>
              </div>
        
            </form>
        
          </div>
        </section>`

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#add-page-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.type = 'page'
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-add-page-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        var selects = document.querySelectorAll('#select-page-type a')

        for(let x=0; x<selects.length; x++) {
            selects[x].addEventListener('click', function(e) { 
                context.type = e.target.getAttribute('data-type')

                let name = document.querySelector('#app-add-page-name').value,
                    url = context.type + '/' + name.toLowerCase().replace(/ /g,"-").replace(/[`~!@#$%^&*()_|+=?;:'",.<>\{\}\[\]\\\/]/gi, '');

                document.querySelector('#app-add-page-url').value = url   
                document.querySelector('#select-page-type a[active]').removeAttribute('active')
                e.target.setAttribute('active', '')
            })
        }

        this.form.addEventListener('submit', function(e) {
            context.add()
            e.preventDefault()
            return false
        })

        document.querySelector('#app-add-page-name').addEventListener('keyup', function(e) {
            let name = document.querySelector('#app-add-page-name').value,
                url = context.type + '/' + name.toLowerCase().replace(/ /g,"-").replace(/[`~!@#$%^&*()_|+=?;:'",.<>\{\}\[\]\\\/]/gi, '');

            document.querySelector('#app-add-page-url').value = url 
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

    /*
     * Adds the page
     */
    add() {

        // set data
        let data = {
                name: document.querySelector('#app-add-page-name').value,
                url: document.querySelector('#app-add-page-url').value,
                description: document.querySelector('#app-add-page-description').value,
                type: this.type
            }, 
            context = this

        shared.toast.show('loading', 'Adding page...', false)

        // post form
        var xhr = new XMLHttpRequest()
        xhr.open('POST', '/api/page/add', true)
        xhr.setRequestHeader('Content-Type', 'application/json')
        xhr.send(JSON.stringify(data))

        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 400) {
                shared.toast.show('success', 'Page added successfully!', true)
                location.href = `/edit?page=/${data.url}.html`
            }
            else {
                shared.toast.show('failure', 'There was an error saving the file', true)
            }
        }
    }
}