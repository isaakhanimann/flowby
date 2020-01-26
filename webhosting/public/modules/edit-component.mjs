/*
 * Models the edit component modal
 */
export class EditComponentModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-component-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-component-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Component</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Component</label>
                <select id="edit-component" name="component"></select>
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
        this.modal = document.querySelector('#edit-component-modal')
        this.form = this.modal.querySelector('form')

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
      xhr.open('POST', '/api/page/components/list', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              let arr = JSON.parse(xhr.responseText)

              // fill array
              for(let x=0; x<arr.length; x++) {
                let option = document.createElement("option");
                let text = arr[x].replace(/-/g, ' ')

                option.text = text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
                option.value = arr[x]

                context.modal.querySelector('#edit-component').appendChild(option)
              }
              
          }
      }
      // end xhr
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // toggle modals
        var toggles = document.querySelectorAll('[toggle-edit-component-modal]');

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

        // listen for the editor event to show modal
        window.addEventListener('editor.event', data => {

          console.log('[edit.component] component', data.detail)

          if(data.detail.type == 'component') {

            context.modal.querySelector('#edit-component').value = data.detail.component

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

      let component = this.modal.querySelector('#edit-component').value

      shared.sendUpdate({type: 'component', component: component})

      this.toggleModal()
    }
}