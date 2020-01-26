/*
 * Models the edit menu item modal
 */
export class EditMenuItemModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-menu-item-modal" class="app-modal app-modal-priority">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-menu-item-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Menu Item</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Label</label>
                <input id="edit-menu-item-label" type="text" maxlength="128" placeholder="">
              </div>

              <div class="app-modal-form-group">
                <label>URL <a id="edit-menu-item-select-page">Select Page</a></label>
                <input id="edit-menu-item-url" type="text" maxlength="256" placeholder="">
              </div>

              <div class="app-modal-form-group">
                <label>CSS Class</label>
                <input id="edit-menu-item-css-class" type="text" maxlength="128" placeholder="">
              </div>

              <div class="app-modal-form-group">
                <label>Nested</label>
                <select id="edit-menu-item-nested"
                  name="required">
                  <option value="true">Yes</option>
                  <option value="false">No</option>
                </select>
                <small>Sets whether the menu item is shown in a dropdwon</small>
              </div>

              <div class="app-modal-form-group">
                <label>Target</label>
                <input id="edit-menu-item-target" type="text" maxlength="128" placeholder="">
              </div>
        
          </div>  
    
          <div class="app-modal-actions">
            <button type="submit">Update</button>
          </div>
        
        
          </form>
          
        </div>
        </section>`

        this.item = {}
        this.index = 0

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-menu-item-modal')
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
        var toggles = document.querySelectorAll('[toggle-edit-menu-item-modal]');

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
        this.modal.querySelector('#edit-menu-item-select-page').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectPage', {detail: {target: '#edit-menu-item-url'}}))
        })

        // listen for the editor event to show modal
        window.addEventListener('app.editMenuItem', data => {

          console.log('[app.editMenuItem] detail', data)

          let options = ''

          context.item = data.detail.item
          context.index = data.detail.index

          document.querySelector('#edit-menu-item-label').value = data.detail.item.label
          document.querySelector('#edit-menu-item-url').value = data.detail.item.url
          document.querySelector('#edit-menu-item-css-class').value = data.detail.item.cssClass
          document.querySelector('#edit-menu-item-nested').value = data.detail.item.nested
          document.querySelector('#edit-menu-item-target').value = data.detail.item.target

          this.toggleModal()

        })
    }

    /*
     * Toggles the modal
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

      let options = []

      // get field values
      this.item.label = document.querySelector('#edit-menu-item-label').value
      this.item.url = document.querySelector('#edit-menu-item-url').value
      this.item.cssClass = document.querySelector('#edit-menu-item-css-class').value
      this.item.nested = document.querySelector('#edit-menu-item-nested').value
      this.item.target = document.querySelector('#edit-menu-item-target').value

      // edit field
      window.dispatchEvent(new CustomEvent('app.updateMenuItem', {detail: {item: this.item, index: this.index}}))

      this.toggleModal()
    }
}