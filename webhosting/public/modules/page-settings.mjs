/*
 * Models the page settings modal
 */
export class PageSettingsModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="page-settings-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-page-settings-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Page Settings</h2>
        
            <div class="app-modal-form">
        
            <div class="app-modal-form-group">
              <label>* Name</label>
              <input id="page-settings-name" type="text" maxlength="128" required name="name">
            </div>
    
            <div class="app-modal-form-group">
              <label>Callout</label>
              <input id="page-settings-callout" type="text" maxlength="128" name="callout">
            </div>
    
            <div class="app-modal-form-group">
              <label>Description</label>
              <input id="page-settings-description" type="text" maxlength="128" name="description">
            </div>
    
            <div class="app-modal-form-group">
              <label>Keywords</label>
              <input id="page-settings-keywords" type="text" maxlength="128" name="keywords">
            </div>
    
            <div class="app-modal-form-group">
              <label>Tags</label>
              <input id="page-settings-tags" type="text" maxlength="128" name="tags">
            </div>
              
            <div class="app-modal-form-group">
              <label>Location</label>
              <input id="page-settings-location" type="text" maxlength="128" name="location">
            </div>
              
            <div class="app-modal-form-group">
              <label>Image <a id="page-settings-select-image">Select</a></label>
              <input id="page-settings-image" type="text" maxlength="128" name="photo">
            </div>
    
            <div class="app-modal-form-group">
              <label>Language</label>
              <select id="page-settings-language" name="language">
                <option value="en">English (en)</option>
                <option value="es">Español (es)</option>
                <option value="fr">Français (fr)</option>
                <option value="gr">Ελληνικά (gr)</option>
                <option value="ru">Русский (ru)</option>
              </select>
            </div>
    
            <div class="app-modal-form-group">
              <label>Direction</label>
              <select id="page-settings-direction" name="direction">
                <option value="ltr">Left-to-Right</option>
                <option value="rtl">Right-to-Left</option>
              </select>
            </div>
    
            <div class="app-modal-form-group">
              <label>Template</label>
              <select id="page-settings-template" name="template"></select>
            </div>
    
            <div class="app-modal-form-group">
              <label>Custom Header</label>
              <textarea id="page-settings-custom-header" name="customHeader"></textarea>
            </div>
    
            <div class="app-modal-form-group">
              <label>Custom Footer</label>
              <textarea id="page-settings-custom-footer" name="customFooter"></textarea>
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
        this.modal = document.querySelector('#page-settings-modal')
        this.form = this.modal.querySelector('form')

        const params = new URLSearchParams(window.location.search)
        this.url = params.get('page') || 'index.html'

        // remove leading /
        this.url = (this.url[0] == '/') ? this.url.substr(1) : this.url

        // handle events
        this.setup()
        this.setupEvents()
    }

    /*
     * Setup the data
     */
    setup() {

      let data = {},
            context = this
      
      // post form
      var xhr = new XMLHttpRequest()
      xhr.open('POST', '/api/page/templates/list', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              let arr = JSON.parse(xhr.responseText)

              // fill array
              for(let x=0; x<arr.length; x++) {
                let option = document.createElement("option");
                option.text = arr[x].charAt(0).toUpperCase() + arr[x].substr(1).toLowerCase();
                option.value = arr[x]

                context.modal.querySelector('#page-settings-template').appendChild(option)
              }

              context.fill()
              
          }
      }
      // end xhr
    }

    /*
     * Fill page settings
     */
    fill() {

      let data = { url: this.url},
            context = this
      
      // post form
      var xhr = new XMLHttpRequest()
      xhr.open('POST', '/api/page/retrieve', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              let obj = JSON.parse(xhr.responseText)

              context.modal.querySelector('#page-settings-name').value = obj.name || ''
              context.modal.querySelector('#page-settings-callout').value = obj.callout || ''
              context.modal.querySelector('#page-settings-description').value = obj.description || ''
              context.modal.querySelector('#page-settings-keywords').value = obj.keywords || ''
              context.modal.querySelector('#page-settings-tags').value = obj.tags || ''
              context.modal.querySelector('#page-settings-location').value = obj.location || ''
              context.modal.querySelector('#page-settings-image').value = obj.image || ''
              context.modal.querySelector('#page-settings-language').value = obj.language || ''
              context.modal.querySelector('#page-settings-direction').value = obj.direction || ''
              context.modal.querySelector('#page-settings-template').value = obj.template || 'default'
              context.modal.querySelector('#page-settings-custom-header').value = obj.customHeader || ''
              context.modal.querySelector('#page-settings-custom-footer').value = obj.customFooter || ''
              
          }
      }
      // end xhr

  }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-page-settings-modal]');

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

        // handle select image
        this.modal.querySelector('#page-settings-select-image').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#page-settings-image'}}))
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
     * Edits the settings
     */
    edit() {

      let data = {
        url: this.url,
        name: this.modal.querySelector('#page-settings-name').value,
        callout: this.modal.querySelector('#page-settings-callout').value,
        description: this.modal.querySelector('#page-settings-description').value,
        keywords: this.modal.querySelector('#page-settings-keywords').value,
        tags: this.modal.querySelector('#page-settings-tags').value,
        location: this.modal.querySelector('#page-settings-location').value,
        image: this.modal.querySelector('#page-settings-image').value,
        language: this.modal.querySelector('#page-settings-language').value,
        direction: this.modal.querySelector('#page-settings-direction').value,
        template: this.modal.querySelector('#page-settings-template').value,
        customHeader: this.modal.querySelector('#page-settings-custom-header').value,
        customFooter: this.modal.querySelector('#page-settings-custom-footer').value
      }, 
      context = this

      // post form
      var xhr = new XMLHttpRequest()
      xhr.open('POST', '/api/page/settings', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      shared.toast.show('loading', 'Updating settings...', false)

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              shared.toast.show('success', 'Settings updated successfully!', true)
              context.toggleModal()
          }
          else {
              shared.toast.show('failure', 'There was an error updating the settings.', true)
          }
      }
      // end xhr
      
    }
}