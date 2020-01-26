/*
 * Models the edit image modal
 */
export class EditImageModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-image-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-image-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Image</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Source <a id="edit-image-select-image">Select Image</a></label>
                <input id="edit-image-src" type="text" maxlength="128" placeholder="" name="src">
              </div>

              <div class="app-modal-form-group">
                <label>ID</label>
                <input id="edit-image-id" type="text" maxlength="128" placeholder=""name="id">
              </div>

              <div class="app-modal-form-group">
                <label>CSS Class</label>
                <input id="edit-image-class" type="text" maxlength="128" placeholder="" name="cssclass">
              </div>

              <div class="app-modal-form-group">
                <label>Link <a id="edit-image-select-page">Select Page</a></label>
                <input id="edit-image-link" type="text" maxlength="128" placeholder="" name="link">
              </div>

              <div class="app-modal-form-group">
                <label>Alternate Text</label>
                <input id="edit-image-alt" type="text" maxlength="128" placeholder="" name="alt">
              </div>

              <div class="app-modal-form-group">
                <label>Title</label>
                <input id="edit-image-title" type="text" maxlength="128" placeholder="" name="title">
              </div>
        
            </div>  
        
            <div class="app-modal-actions">
              <button type="submit">Update</button>
            </div>
        
          </form>
          
        </div>
        </section>`

        this.properties = {}
        this.attributes = {}

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-image-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // toggle modals
        var toggles = document.querySelectorAll('[toggle-edit-image-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // handle form submission
        this.form.addEventListener('submit', function(e) {
            e.preventDefault()
            context.edit()
            return false
        })

        // handle select image
        this.modal.querySelector('#edit-image-select-image').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#edit-image-src'}}))
        })

        // handle select page
        this.modal.querySelector('#edit-image-select-page').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectPage', {detail: {target: '#edit-image-link'}}))
        })

        // listen for the editor event to show modal
        window.addEventListener('editor.event', data => {

          console.log('[edit.image] detail', data.detail)

          if(data.detail.type == 'image') {

            context.properties = data.detail.properties
            context.attributes = data.detail.attributes

            document.querySelector('#edit-image-src').value = context.properties.src
            document.querySelector('#edit-image-id').value = context.properties.id
            document.querySelector('#edit-image-class').value = context.properties.cssClass
            document.querySelector('#edit-image-link').value = context.properties.parentHref
            document.querySelector('#edit-image-alt').value = context.properties.alt
            document.querySelector('#edit-image-title').value = context.properties.title

            context.toggleModal()
          }
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
     * Edits the element
     */
    edit() {

      this.properties.src = document.querySelector('#edit-image-src').value
      this.properties.id = document.querySelector('#edit-image-id').value
      this.properties.cssClass = document.querySelector('#edit-image-class').value
      this.properties.parentHref = document.querySelector('#edit-image-link').value
      this.properties.alt = document.querySelector('#edit-image-alt').value
      this.properties.title = document.querySelector('#edit-image-title').value

      shared.sendUpdate({type: 'image', properties: this.properties})

      this.toggleModal()
    }
}