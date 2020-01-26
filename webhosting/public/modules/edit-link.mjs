/*
 * Models the edit link modal
 */
export class EditLinkModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-link-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-link-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Link</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Text</label>
                <input id="edit-link-text" type="text" maxlength="128" placeholder=""name="text">
              </div>
        
              <div class="app-modal-form-group">
                <label>Link <a id="edit-link-select-page">Select Page</a></label>
                <input id="edit-link-href" type="text" maxlength="128" placeholder="" name="href">
              </div>

              <div class="app-modal-form-group">
                <label>ID</label>
                <input id="edit-link-id" type="text" maxlength="128" placeholder=""name="id">
              </div>

              <div class="app-modal-form-group">
                <label>CSS Class</label>
                <input id="edit-link-class" type="text" maxlength="128" placeholder="" name="cssclass">
              </div>

              <div class="app-modal-form-group">
                <label>Target</label>
                <input id="edit-link-target" type="text" maxlength="128" placeholder="" name="target">
              </div>

              <div class="app-modal-form-group">
                <label>Title</label>
                <input id="edit-link-title" type="text" maxlength="128" placeholder="" name="title">
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
        this.modal = document.querySelector('#edit-link-modal')
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
        var toggles = document.querySelectorAll('[toggle-edit-link-modal]');

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

        // handle select page
        this.modal.querySelector('#edit-link-select-page').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectPage', {detail: {target: '#edit-link-href'}}))
        })

        // listen for the editor event to show modal
        window.addEventListener('editor.event', data => {

          console.log('[edit.link] detail', data.detail)

          if(data.detail.type == 'link') {

            context.properties = data.detail.properties
            context.attributes = data.detail.attributes

            document.querySelector('#edit-link-id').value = context.properties.id
            document.querySelector('#edit-link-class').value = context.properties.cssClass
            document.querySelector('#edit-link-text').value = context.properties.html
            document.querySelector('#edit-link-href').value = context.properties.href
            document.querySelector('#edit-link-title').value = context.properties.title
            document.querySelector('#edit-link-target').value = context.properties.target
            

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

      this.properties.id = document.querySelector('#edit-link-id').value
      this.properties.cssClass = document.querySelector('#edit-link-class').value
      this.properties.html = document.querySelector('#edit-link-text').value
      this.properties.href = document.querySelector('#edit-link-href').value
      this.properties.title = document.querySelector('#edit-link-title').value
      this.properties.target = document.querySelector('#edit-link-target').value

      shared.sendUpdate({type: 'link', properties: this.properties})

      this.toggleModal()
    }
}