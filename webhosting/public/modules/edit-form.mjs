/*
 * Models the edit form modal
 */
export class EditFormModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-form-modal" class="app-modal app-modal-priority">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-form-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

            <h2>Form</h2>

            <ul class="app-modal-tabs">
              <li active><a data-tab="edit-form-fields">Fields</a></li>
              <li><a data-tab="edit-form-settings">Settings</a></li>
            </ul>

            <form>

            <div id="edit-form-fields" class="app-modal-tab">

              <button id="button-add-form-field" class="app-modal-add-button">Add Form Field</button>
            
              <div class="app-modal-list app-modal-list-has-tabs"></div> 
              
              <div class="app-modal-actions">
                <button type="submit">Update</button>
              </div>

            </div>

            <div id="edit-form-settings" class="app-modal-tab" hidden>

                <div class="app-modal-form app-modal-form-has-tabs">
            
                  <div class="app-modal-form-group">
                    <label>Success Message</label>
                    <input id="edit-form-success-message" type="text" maxlength="256" placeholder="" name="text">
                  </div>

                  <div class="app-modal-form-group">
                    <label>Error Message</label>
                    <input id="edit-form-error-message" type="text" maxlength="256" placeholder="" name="text">
                  </div>

                  <div class="app-modal-form-group">
                    <label>Button Label</label>
                    <input id="edit-form-button-label" type="text" maxlength="256" placeholder="" name="text">
                  </div>

                  <div class="app-modal-form-group">
                    <label>Destination <a id="edit-form-select-page">Select Page</a></label>
                    <input id="edit-form-destination" type="text" maxlength="256" placeholder="" name="text">
                  </div>

                </div>

                <div class="app-modal-actions">
                  <button type="submit">Update</button>
                </div>
              
            </div>

            </form>

        </div>
        </section>`

        this.properties = {}
        this.attributes = {}
        this.settings = {
          buttonLabel: 'Submit',
          successMessage: 'You have successfully submitted your form!',
          errorMessage: 'You have an error in your form.',
          destination: null
        }
        this.fields = []
        this.target = null

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-form-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
    }

    /*
     * Move item in array
     */
    move(from, to) {

        if (to >= this.fields.length) {
            var k = to - this.fields.length + 1;
            while (k--) {
                this.fields.push(undefined);
            }
        }

        this.fields.splice(to, 0, this.fields.splice(from, 1)[0]);
    }

    /*
     * Removes an item from the array
     */
    remove(index) {
      this.fields.splice(index, 1);
    }

    /*
     * Build HTML from fields
     */
    buildHTML() {

        let html = '';

        for(let x=0; x < this.fields.length; x++) {

            let field = '', id = '', cssClass = '', options = '', required = '';

            // create an id from the label
            id = this.fields[x].label.toLowerCase().replace(/[^a-zA-Z ]/g, "");
            id = id.trim();
            id = id.replace(/\s+/g, '-');

            // setup the css clss
            this.fields[x].cssClass = this.fields[x].cssClass.replace(/form-group/g, '').trim();
            
            if(this.fields[x].cssClass != '') {
                cssClass = ' ' + cssClass;
            }

            if(this.fields[x].required == true) {
              required = ' required'
            }

            // build field
            if(this.fields[x].type == 'select') {

                // build options
                for(let y=0; y <this.fields[x].options.length; y++) {
                options += `<option value="${this.fields[x].options[y].value}">${this.fields[x].options[y].text}</option>`;
                }

                field = `<div class="form-group${cssClass}">
                            <label>${this.fields[x].label}</label>
                            <select name="${id}" ${required}>${options}</select>
                            <small>${this.fields[x].helperText}</small>
                            </div>`;

            }
            else if(this.fields[x].type == 'checkbox-list') {

                // build options
                for(let y=0; y <this.fields[x].options.length; y++) {
                options += `<label><input name="${id}" value="${this.fields[x].options[y].value}" data-text="${this.fields[x].options[y].text}" type="checkbox">${this.fields[x].options[y].text}</label>`;
                }

                field = `<div class="form-group${cssClass}">
                            <label>${this.fields[x].label}</label>
                            <div class="checkbox-list">${options}</div>
                            <small>${this.fields[x].helperText}</small>
                            </div>`;

            }
            else if(this.fields[x].type == 'textarea') {

                field = `<div class="form-group${cssClass}">
                            <label>${this.fields[x].label}</label>
                            <textarea name="${id}" ${required}></textarea>
                            <small>${this.fields[x].helperText}</small>
                            </div>`;

            }
            else {

                field = `<div class="form-group${cssClass}">
                            <label>${this.fields[x].label}</label>
                            <input name="${id}" type="${this.fields[x].type}" ${required} placeholder="${this.fields[x].placeholder}">
                            <small>${this.fields[x].helperText}</small>
                            </div>`;

            }

            html += field;

        }

        // add inputs
        html += `<input type="submit" class="button" value="${this.settings.buttonLabel}">
                <input type="hidden" class="success-message" value="${this.settings.successMessage}">
                <input type="hidden" class="error-message" value="${this.settings.errorMessage}">
                <input type="hidden" class="destination" value="${this.settings.destination}">`;

        return html;

    }

    /*
     * Update the HTML
     */
    update() {
        let html = this.buildHTML()
        shared.sendUpdate({type: 'element', properties: {html: html}})
    }

    /*
     * Setup events
     */
    fillList() {

        let context = this,
            list = context.modal.querySelector('.app-modal-list')

        // clear fields
        this.fields = []

        // parse HTML
        this.parseHTML(this.properties.html)

        // update the list
        this.updateList()

    }

    /*
     * Update the list
     */
    updateList() {

      let context = this,
            list = context.modal.querySelector('.app-modal-list'),
            x = 0

      list.innerHTML = ''

      // bind array to html
      this.fields.forEach(i => {

          let item = document.createElement('a')
          item.setAttribute('class', 'app-modal-sortable-item')

          item.innerHTML += `<i class="drag-handle material-icons">drag_handle</i>
                      <h3>${i.label}</h3>
                      <p>${i.type}</p>
                      <i class="remove-item material-icons">remove_circle_outline</i>`

          list.appendChild(item)

          // handle click of list item
          item.addEventListener('click', function(e) {

              if(!e.target.classList.contains('drag-handle') && !e.target.classList.contains('remove-item')) {

                // get index
                let element = e.target,
                    index = Array.from(element.parentNode.children).indexOf(element)

                // edit field
                window.dispatchEvent(new CustomEvent('app.editField', {detail: {field: context.fields[index], index: index}}))

              }
              else if(e.target.classList.contains('remove-item')) {

                // get index
                let element = e.target.parentNode,
                    index = Array.from(element.parentNode.children).indexOf(element)

                // remove and update
                context.remove(index)
                context.updateList()

              }

          })
          
          x++

      });

      // make list sortable
      Sortable.create(list, {
          handle: '.drag-handle',
          onEnd: function (e) {
              context.move(e.oldIndex, e.newIndex)
              //context.updateList()
          },

      })

    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // handle toggles
        var toggles = document.querySelectorAll('[toggle-edit-form-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // listen for the editor event to show modal
        window.addEventListener('app.updateField', data => {

          // update field
          context.fields[data.detail.index] = data.detail.field

          // update
          context.updateList()
          
        })

        // handle select page
        this.modal.querySelector('#edit-form-select-page').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectPage', {detail: {target: '#edit-form-destination'}}))
        })

        // listen for event to show modal
        window.addEventListener('editor.event', data => {

            console.log('[edit.form] detail', data.detail)
  
            if(data.detail.type == 'widget' && data.detail.widget == 'form') {
              context.properties = data.detail.properties
              context.fillList()
              context.toggleModal()
            }
          })

        // handle form submission
        this.form.addEventListener('submit', function(e) {

            e.preventDefault()

            context.settings.buttonLabel = context.modal.querySelector('#edit-form-button-label').value
            context.settings.successMessage = context.modal.querySelector('#edit-form-success-message').value
            context.settings.errorMessage = context.modal.querySelector('#edit-form-error-message').value
            context.settings.destination = context.modal.querySelector('#edit-form-destination').value

            context.update()
            context.toggleModal()

            return false
        })

        // add button
        document.querySelector('#button-add-form-field').addEventListener('click', function(e) { 

          // get fields
          let field = {
            id: 'new-field',
            label: 'New Field',
            type: 'text',
            required: false,
            options: [],
            helperText: '',
            placeholder: '',
            cssClass: ''
          };

          // push fields
          context.fields.push(field);

          // update ui
          context.updateList()

          e.preventDefault()
        })

        // setup tabs
        this.modal.querySelector('.app-modal-tabs').addEventListener('click', function(e) { 

          // switch active tab
          let lis = context.modal.querySelectorAll('.app-modal-tabs li')
          for(let x=0; x<lis.length; x++) lis[x].removeAttribute('active')

          e.target.parentNode.setAttribute('active', '')

          // switch active content
          let tabs = context.modal.querySelectorAll('.app-modal-tab')
          for(let x=0; x<tabs.length; x++) tabs[x].setAttribute('hidden', '')

          context.modal.querySelector(`#${e.target.getAttribute('data-tab')}`).removeAttribute('hidden')
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

    /**
   * Parses the HTML into usable form fields
   * <div class="form-group">
   *  <label>Sample</label>
   *  <input type="text">
   *  <small>Helper Text</small>
   * </div>
   *  <input type="submit" class="button" value="Get in touch">
   *  <input type="hidden" class="success-message" value="">
   *  <input type="hidden" class="error-message" value="">
   *  <input type="hidden" class="destination" value="">
   */
  parseHTML(html) {

    let parser = new DOMParser();
    let doc = parser.parseFromString(html, 'text/html');
    let el = null;

    // get submit
    el = doc.querySelector('input[type=submit]');

    if(el) {
      this.settings.buttonLabel = el.getAttribute('value') || ''
    }

    // get success message
    el = doc.querySelector('.success-message');

    if(el) {
      this.settings.successMessage = el.getAttribute('value') || ''
    }

    // get error message
    el = doc.querySelector('.error-message');

    if(el) {
      this.settings.errorMessage = el.getAttribute('value') || ''
    }

    // get destination
    el = doc.querySelector('.destination');

    if(el) {
      this.settings.destination = el.getAttribute('value') || ''
    }

    // set values
    this.modal.querySelector('#edit-form-button-label').value = this.settings.buttonLabel
    this.modal.querySelector('#edit-form-success-message').value = this.settings.successMessage
    this.modal.querySelector('#edit-form-error-message').value = this.settings.errorMessage
    this.modal.querySelector('#edit-form-destination').value = this.settings.destination

    // get form groups
    let groups = doc.querySelectorAll('.form-group');

    for(let x=0; x<groups.length; x++) {

      let type = '', required = false, placeholder = '', options = [], helperText = '';

      // get label & inputs
      let label = groups[x].querySelector('label');
      let input = groups[x].querySelector('input');
      let textarea = groups[x].querySelector('textarea');
      let select = groups[x].querySelector('select');
      let checkboxlist = groups[x].querySelector('.checkbox-list');
      let small = groups[x].querySelector('small');

      // get helpertext
      if(small) {
        helperText = small.innerHTML;
      }
      
      // handle input
      if(input) {
        type = input.getAttribute('type') || 'text';
        placeholder = input.getAttribute('placeholder') || '';
        
        if(input.hasAttribute('required')) {
          required = true;
        }
      }

      // handle textarea
      if(textarea) {
        type = 'textarea';
        
        if(textarea.hasAttribute('required')) {
          required = true;
        }
      }

      // handle select
      if(select) {
        type = 'select';
        
        for(let y=0; y < select.options.length; y++) {
          options.push({
            text: select.options[y].text,
            value: select.options[y].value
          })
        }

        if(select.hasAttribute('required')) {
          required = true;
        }
      }

      // handle checkbox list
      if(checkboxlist) {
        type = 'checkbox-list';

        let items = checkboxlist.querySelectorAll('input[type=checkbox]');
        
        for(let y=0; y < items.length; y++) {
          options.push({
            text: items[y].getAttribute('data-text'),
            value: items[y].getAttribute('value')
          })
        }

      }

      // create id
      let id = label.innerText.toLowerCase().replace(/ /g, '-');
      id = id.replace(/[^a-zA-Z ]/g, "");

      // get fields
      let field = {
        id: id,
        label: label.innerHTML,
        type: type,
        required: required,
        options: options,
        helperText: helperText,
        placeholder: placeholder,
        cssClass: groups[x].className
      };

      // push fields
      this.fields.push(field);

    }

  }

}