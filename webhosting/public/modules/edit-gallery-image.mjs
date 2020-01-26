/*
 * Models the edit gallery image modal
 */
export class EditGalleryImageModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-gallery-image-modal" class="app-modal app-modal-priority">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-gallery-image-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Image</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Title</label>
                <input id="edit-gallery-image-title" type="text" maxlength="128" placeholder="" name="text">
              </div>

              <div class="app-modal-form-group" hidden>
                <label>Text</label>
                <input id="edit-gallery-image-text" type="text" maxlength="128" placeholder="" name="text">
              </div>

              <div class="app-modal-form-group">
                <label>Image <a id="edit-gallery-image-select-image">Select Image</a></label>
                <input id="edit-gallery-image-src" type="text" maxlength="128" placeholder="" name="text">
              </div>

              <div id="edit-gallery-image-href-group" class="app-modal-form-group">
                <label>Link <a id="edit-gallery-image-select-page">Select Page</a></label>
                <input id="edit-gallery-image-href" type="text" maxlength="128" placeholder="" name="text">
              </div>
        
          </div>  
    
          <div class="app-modal-actions">
            <button type="submit">Update</button>
          </div>
        
        
          </form>
          
        </div>
        </section>`

        this.image = {}
        this.index = 0

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-gallery-image-modal')
        this.form = this.modal.querySelector('form')
        this.type = 'gallery'

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // toggle modals
        var toggles = document.querySelectorAll('[toggle-edit-gallery-image-modal]');

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
        this.modal.querySelector('#edit-gallery-image-select-image').addEventListener('click', function(e) {
          if(context.type == 'gallery') {
            window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#edit-gallery-image-href', thumb: '#edit-gallery-image-src'}}))
          }
          else {
            window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#edit-gallery-image-src'}}))
          }

        })

        // handle select page
        this.modal.querySelector('#edit-gallery-image-select-page').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectPage', {detail: {target: '#edit-gallery-image-href'}}))
        })
    
        // listen for the editor event to show modal
        window.addEventListener('app.editGalleryImage', data => {

          console.log('[app.editGalleryImage] detail', data)

          context.image = data.detail.image
          context.type = data.detail.type
          context.index = data.detail.index

          document.querySelector('#edit-gallery-image-title').value = data.detail.image.title
          document.querySelector('#edit-gallery-image-text').value = data.detail.image.text
          document.querySelector('#edit-gallery-image-src').value = data.detail.image.src
          document.querySelector('#edit-gallery-image-href').value = data.detail.image.href

          if(context.type == 'gallery') {
            this.modal.querySelector('#edit-gallery-image-select-page').setAttribute('hidden' , '')
            this.modal.querySelector('#edit-gallery-image-href-group').removeAttribute('hidden')
          }
          else {
            this.modal.querySelector('#edit-gallery-image-select-page').removeAttribute('hidden')
            this.modal.querySelector('#edit-gallery-image-href-group').setAttribute('hidden', '')
          }

          this.toggleModal()

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

      // get field values
      this.image.title = document.querySelector('#edit-gallery-image-title').value 
      this.image.text = document.querySelector('#edit-gallery-image-text').value 
      this.image.src = document.querySelector('#edit-gallery-image-src').value 
      this.image.href = document.querySelector('#edit-gallery-image-href').value 
      this.image.display = '/' + document.querySelector('#edit-gallery-image-src').value 

      // edit field
      window.dispatchEvent(new CustomEvent('app.updateGalleryImage', {detail: {image: this.image, index: this.index}}))

      this.toggleModal()
    }
}