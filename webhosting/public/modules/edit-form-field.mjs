/*
 * Models the edit form field modal
 */
export class EditFormFieldModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-form-field-modal" class="app-modal app-modal-priority">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-form-field-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Form Field</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Label</label>
                <input id="edit-form-field-label" type="text" maxlength="128" placeholder=""name="text">
              </div>

              <div class="app-modal-form-group">
                <label>Type</label>
                <select id="edit-form-field-type" name="type">
                  <option value="text">Text</option>
                  <option value="email">Email</option>
                  <option value="number">Number</option>
                  <option value="url">URL</option>
                  <option value="tel">Telephone</option>
                  <option value="date">Date</option>
                  <option value="time">Time</option>
                  <option value="textarea">Textarea</option>
                  <option value="select">Select List</option>
                  <option value="checkbox-list">Check List</option>
                </select>
            </div>

            <div id="edit-form-field-options-group" class="app-modal-form-group">  
              <label>Options</label>
              <input id="edit-form-field-options" type="text" placeholder="Option 1, Option 2, Option 3"
                name="options">
              <small>Comma separated list of selectable options in the list.</small>
            </div>

            <div class="app-modal-form-group">
              <label>Required</label>
              <select id="edit-form-field-required"
                name="required">
                <option value="true">Yes</option>
                <option value="false">No</option>
              </select>
              <small>Sets whether the form requires the field to be submitted.</small>
            </div>

            <div class="app-modal-form-group">  
              <label>Helper Text</label>
              <input id="edit-form-field-helper-text" type="text" maxlength="128" placeholder=""
                name="helperText">
              <small>(optional) Sets the text that shows beneath the field.  Used to aid in completing the form.</small>
            </div>

            <div class="app-modal-form-group">  
              <label>Placeholder Text</label>
              <input id="edit-form-field-placeholder" type="text" maxlength="128" placeholder=""
                name="placeholder">
              <small>(optional) Sets the text that shows in the field.  Used to instruct how to fill out the field.</small>
            </div>

            <div class="app-modal-form-group">  
                <label>ID</label>
                <input id="edit-form-field-id" type="text" maxlength="128" placeholder=""
                  name="id">
                <small>(optional) Sets the HTML id attribute.</small>
              </div>

            <div class="app-modal-form-group">  
              <label>CSS Class</label>
              <input id="edit-form-field-css-class" type="text" maxlength="128" placeholder=""
                name="cssclass">
              <small>(optional) Sets the HTML class attribute.</small>
            </div>
        
          </div>  
    
          <div class="app-modal-actions">
            <button type="submit">Update</button>
          </div>
        
        
          </form>
          
        </div>
        </section>`

        this.field = {}
        this.index = 0

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-form-field-modal')
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
        var toggles = document.querySelectorAll('[toggle-edit-form-field-modal]');

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

        // hide/show options
        document.querySelector('#edit-form-field-type').addEventListener('change', function(e) {

          if(e.target.value == 'select' || e.target.value == 'checkbox-list') {
            document.querySelector('#edit-form-field-options-group').removeAttribute('hidden')
          }
          else {
            document.querySelector('#edit-form-field-options-group').setAttribute('hidden', '')
          }
        })

        // listen for the editor event to show modal
        window.addEventListener('app.editField', data => {

          console.log('[app.editField] detail', data)

          let options = ''

          context.field = data.detail.field
          context.index = data.detail.index

          if(Array.isArray(data.detail.field.options)) {

              for(let x=0; x< data.detail.field.options.length; x++) {
                options += data.detail.field.options[x].text + ', ';
              }
        
              if(options.length > 0) {
                options = options.slice(0, -2);
              }

          }

          document.querySelector('#edit-form-field-label').value = data.detail.field.label
          document.querySelector('#edit-form-field-type').value = data.detail.field.type
          document.querySelector('#edit-form-field-options').value = options
          document.querySelector('#edit-form-field-required').value = data.detail.field.required
          document.querySelector('#edit-form-field-helper-text').value = data.detail.field.helperText
          document.querySelector('#edit-form-field-placeholder').value = data.detail.field.placeholder
          document.querySelector('#edit-form-field-id').value = data.detail.field.id
          document.querySelector('#edit-form-field-css-class').value = data.detail.field.cssClass

          if(data.detail.field.type != 'select' && data.detail.field.type != 'checkbox-list') {
            document.querySelector('#edit-form-field-options-group').setAttribute('hidden', '')
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

      let options = [];

      if(document.querySelector('#edit-form-field-options').value.length > 0) {
        let arr = document.querySelector('#edit-form-field-options').value.split(',')

        // build options
        for(let x=0; x<arr.length; x++) {

          // get text and value
          let text = arr[x].trim();
          let value = text.toLowerCase().replace(/ /g, '-');
          value = value.replace(/[^a-zA-Z ]/g, "");

          // create optinos
          options.push({
            text: text,
            value: value
          });
        }

      }

      // get field values
      this.field.label = document.querySelector('#edit-form-field-label').value
      this.field.type = document.querySelector('#edit-form-field-type').value
      this.field.options = options
      this.field.required = (document.querySelector('#edit-form-field-required').value.toLowerCase() == 'true')
      this.field.helperText = document.querySelector('#edit-form-field-helper-text').value
      this.field.placeholder = document.querySelector('#edit-form-field-placeholder').value
      this.field.id = document.querySelector('#edit-form-field-id').value
      this.field.cssClass = document.querySelector('#edit-form-field-css-class').value

      // edit field
      window.dispatchEvent(new CustomEvent('app.updateField', {detail: {field: this.field, index: this.index}}))

      this.toggleModal()
    }
}