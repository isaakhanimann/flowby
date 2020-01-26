/*
 * Models the edit element modal
 */
export class EditElementModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-element-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-element-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Element</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>ID</label>
                <input id="edit-element-id" type="text" maxlength="128" placeholder=""name="id">
              </div>
        
              <div class="app-modal-form-group">
                <label>CSS Class</label>
                <input id="edit-element-class" type="text" maxlength="128" placeholder="" name="cssclass">
              </div>

              <div class="app-modal-form-group">
                <label>HTML</label>
                <textarea id="edit-element-html" name="html" class="app-modal-big-textarea"></textarea>
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
        this.modal = document.querySelector('#edit-element-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-edit-element-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        this.form.addEventListener('submit', function(e) {
            e.preventDefault()
            context.edit()
            return false
        })

        window.addEventListener('editor.show', data => {

          console.log('[edit.element] detail', data.detail)

          if(data.detail.type == 'element') {

            context.properties = data.detail.properties
            context.attributes = data.detail.attributes

            document.querySelector('#edit-element-id').value = context.properties.id
            document.querySelector('#edit-element-class').value = context.properties.cssClass
            document.querySelector('#edit-element-html').value = context.properties.html
            

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
      this.properties.id = document.querySelector('#edit-element-id').value 
      this.properties.cssClass = document.querySelector('#edit-element-class').value 
      this.properties.html = document.querySelector('#edit-element-html').value 

      shared.sendUpdate({type: 'element', properties: this.properties, attributes: this.attributes})

      this.toggleModal()
    }
}