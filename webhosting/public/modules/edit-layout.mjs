/*
 * Models the edit layout modal
 */
export class EditLayoutModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-layout-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-layout-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Layout</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>ID</label>
                <input id="edit-layout-id" type="text" maxlength="128" placeholder=""name="id">
              </div>
        
              <div class="app-modal-form-group">
                <label>CSS Class</label>
                <input id="edit-layout-class" type="text" maxlength="128" placeholder="" name="cssclass">
              </div>

              <div class="app-modal-form-group">
                <label>Width</label>
                <select id="edit-layout-width" name="horizontalPadding">
                    <option value="default">Default</option>
                    <option value="full">Full</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                <label>Background Image <a id="edit-layout-select-image">Select Image</a></label>
                <input id="edit-layout-background-image" type="text" maxlength="128" placeholder="" name="backgroundImage">
              </div>

              <div class="app-modal-form-group">
                <label>Background Size</label>
                <select id="edit-layout-background-size" name="backgroundSize">
                    <option></option>
                    <option value="cover">Cover</option>
                    <option value="auto">Auto</option>
                    <option value="contain">Contain</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                <label>Background Position</label>
                <select id="edit-layout-background-position" name="backgroundPosition">
                    <option value=""></option>
                    <option value="center center">Center Center</option>
                    <option value="top left">Top Left</option>
                    <option value="top center">Top Center</option>
                    <option value="top right">Top Right</option>
                    <option value="center left">Center Left</option>
                    <option value="center center">Center Center</option>
                    <option value="center right">Center Right</option>
                    <option value="left left">Left Left</option>
                    <option value="left center">Left Center</option>
                    <option value="left right">Left Right</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                  <label>Background Repeat</label>
                  <select id="edit-layout-background-repeat" name="backgroundRepeat">
                      <option value=""></option>
                      <option value="no-repeat">No-Repeat</option>
                      <option value="repeat">Repeat</option>
                      <option value="repeat-x">Repeat-X</option>
                      <option value="repeat-y">Repeat-Y</option>
                  </select>
              </div>

              <div class="app-modal-form-group">
                <div class="color-picker-group">
                  <label>Background Color <a>Reset</a></label>
                  <div class="color-picker-wrapper">
                    <input type="color" id="edit-layout-background-color" name="backgroundColor">
                  </div>
                </div>
              </div>

              <div class="app-modal-form-group">
                <label>Horizontal Padding (left and right)</label>
                <select id="edit-layout-horizontal-padding" name="horizontalPadding">
                    <option value="none">None</option>
                    <option value="small">Small</option>
                    <option value="medium">Medium</option>
                    <option value="large">Large</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                <label>Vertical Padding (top and bottom)</label>
                <select id="edit-layout-vertical-padding" name="verticalPadding">
                    <option value="none">None</option>
                    <option value="small">Small</option>
                    <option value="medium">Medium</option>
                    <option value="large">Large</option>
                    <option value="xlarge">X-Large</option>
                    <option value="xxlarge">XX-Large</option>
                    <option value="xxxlarge">XXXX-Large</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                <label>Vertical Padding (top only)</label>
                <select id="edit-layout-top-vertical-padding" name="topVerticalPadding">
                  <option value="none">None</option>
                  <option value="small">Small</option>
                  <option value="medium">Medium</option>
                  <option value="large">Large</option>
                  <option value="xlarge">X-Large</option>
                  <option value="xxlarge">XX-Large</option>
                  <option value="xxxlarge">XXXX-Large</option>
                </select>
              </div>

              <div class="app-modal-form-group">
                <label>Vertical Padding (bottom only)</label>
                <select id="edit-layout-bottom-vertical-padding" name="bottomVerticalPadding">
                  <option value="none">None</option>
                  <option value="small">Small</option>
                  <option value="medium">Medium</option>
                  <option value="large">Large</option>
                  <option value="xlarge">X-Large</option>
                  <option value="xxlarge">XX-Large</option>
                  <option value="xxxlarge">XXXX-Large</option>
                </select>
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

        this.colorChanged = false

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-layout-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-edit-layout-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // handle select image
        this.modal.querySelector('#edit-layout-select-image').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#edit-layout-background-image'}}))
        })

        this.form.addEventListener('submit', function(e) {
            e.preventDefault()
            context.edit()
            return false
        })

        // check color change
        document.querySelector('#edit-layout-background-color').addEventListener('change', function(e) {
          context.colorChanged = true
        })

        // handle editor event
        window.addEventListener('editor.event', data => {

          console.log('[edit.layout] detail', data.detail)

          if(data.detail.type == 'block') {

            context.properties = data.detail.properties
            context.attributes = data.detail.attributes

            document.querySelector('#edit-layout-id').value = context.properties.id
            document.querySelector('#edit-layout-class').value = context.properties.cssClass
            document.querySelector('#edit-layout-width').value = context.properties.width
            document.querySelector('#edit-layout-horizontal-padding').value = context.properties.horizontalPadding
            document.querySelector('#edit-layout-vertical-padding').value = context.properties.verticalPadding
            document.querySelector('#edit-layout-top-vertical-padding').value = context.properties.topVerticalPadding
            document.querySelector('#edit-layout-bottom-vertical-padding').value = context.properties.bottomVerticalPadding
            document.querySelector('#edit-layout-background-image').value = context.properties.backgroundImage
            document.querySelector('#edit-layout-background-color').value = context.properties.backgroundColor
            document.querySelector('#edit-layout-background-position').value = context.properties.backgroundPosition
            document.querySelector('#edit-layout-background-repeat').value = context.properties.backgroundRepeat
            document.querySelector('#edit-layout-background-size').value = context.properties.backgroundSize
            
            context.toggleModal()
          }
        })
    }

    /*
     * Toggles the slide-in modal
     */
    toggleModal() {

        this.colorChanged = false

        if(this.modal.hasAttribute('active')) {
           this.modal.removeAttribute('active')     
        }
        else {
            this.modal.setAttribute('active', '')
        }
    }

    /*
     * Edits the layout
     */
    edit() {
      this.properties.id = document.querySelector('#edit-layout-id').value 
      this.properties.cssClass = document.querySelector('#edit-layout-class').value 

      let color = ''

      if(this.colorChanged == true) {
        color = document.querySelector('#edit-layout-background-color').value
      }

      this.properties.width = document.querySelector('#edit-layout-width').value
      this.properties.horizontalPadding = document.querySelector('#edit-layout-horizontal-padding').value
      this.properties.verticalPadding = document.querySelector('#edit-layout-vertical-padding').value
      this.properties.topVerticalPadding = document.querySelector('#edit-layout-top-vertical-padding').value
      this.properties.bottomVerticalPadding = document.querySelector('#edit-layout-bottom-vertical-padding').value
      this.properties.backgroundImage = document.querySelector('#edit-layout-background-image').value
      this.properties.backgroundColor = color
      this.properties.backgroundPosition = document.querySelector('#edit-layout-background-position').value
      this.properties.backgroundRepeat = document.querySelector('#edit-layout-background-repeat').value
      this.properties.backgroundSize = document.querySelector('#edit-layout-background-size').value

      shared.sendUpdate({type: 'block', properties: this.properties, attributes: this.attributes})

      this.toggleModal()
    }
}