/*
 * Models the edit menu modal
 */
export class EditMenuModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-menu-modal" class="app-modal app-modal-priority">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-menu-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

            <h2>Menu</h2>

            <ul class="app-modal-tabs">
              <li active><a data-tab="primary">Primary</a></li>
              <li><a data-tab="footer">Footer</a></li>
            </ul>

            <form>

            <div class="app-modal-tab">

              <button id="button-add-menu-item" class="app-modal-add-button">Add Menu Item</button>
            
              <div class="app-modal-list app-modal-list-has-tabs"></div>            

            </div>

            <div class="app-modal-actions">
              <button type="submit">Update</button>
            </div>

            </form>

        </div>
        </section>`

        this.type = 'primary'

        this.items = []
        this.target = null

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-menu-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
        this.fillList()
    }

    /*
     * Move item in array
     */
    move(from, to) {

        if (to >= this.items.length) {
            var k = to - this.items.length + 1;
            while (k--) {
                this.items.push(undefined);
            }
        }

        this.items.splice(to, 0, this.items.splice(from, 1)[0]);
    }

    /*
     * Removes an item from the array
     */
    remove(index) {
      this.items.splice(index, 1);
    }

    /*
     * Build HTML from fields
     */
    buildHTML() {

        let html = '<nav><ul>',
          parentFlag = false,
          newParent = true,
          items = this.items

        for(let x=0; x < items.length; x++) {

          let label = items[x].label,
            url = items[x].url,
            cssClass = items[x].cssClass,
            nested = items[x].nested,
            target = items[x].target,
            next = x+1

          // set parent flag
          if(next < items.length) {
            if(items[next].nested == true && newParent == true) {
              parentFlag = true
            }
          }

          // create a new parent
          if(newParent == true && parentFlag == true) {

            html += `<li>
                      <a class="${cssClass}" href="${url}" target="${target}">${label}</a>
                      <ul>`
            newParent = false

          }
          else { // create a dropdown or standard item

            html += `<li><a class="${cssClass}" href="${url}" target="${target}">${label}</a></li>`

          }

          // set parent flag
          if(next < items.length) {

            // end parent
            if(items[next].nested == false && parentFlag == true) {
              html += `</ul></li>`
              parentFlag = false
              newParent = true
            }

          }
          else {

            // end parent
            if (parentFlag == true) {
                html += `</ul>`
                parentFlag = false
                newParent= true
            }

          }

        }

        html += '</ul></nav>'

        return html;

    }

    /*
     * Update the HTML
     */
    update() {

      let data = {
        type: this.type,
        html: this.buildHTML()
      }

      shared.toast.show('loading', 'Saving menu...', false)

      // post update
      var xhr = new XMLHttpRequest()
      xhr.open('POST', '/api/menu/save', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              shared.toast.show('success', 'Menu updated successfully!', true)
              context.updateList()
              context.toggleModal()
          }
          else {
              shared.toast.show('failure', 'There was an error updating the menu', true)
          }
      }
      // end xhr

    }

    /*
     * Setup events
     */
    fillList() {

        let context = this,
            list = context.modal.querySelector('.app-modal-list')

        // clear fields
        this.items = []

        let data = {
                type: this.type
              }

        // retrieve menu
        var xhr = new XMLHttpRequest()
        xhr.open('POST', '/api/menu/retrieve', true)
        xhr.setRequestHeader('Content-Type', 'application/json')
        xhr.send(JSON.stringify(data))

        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 400) {
                context.parseHTML(xhr.responseText)
                context.updateList()
            }
            else {
                // error retrieving menu
            }
        }
        // end xhr

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
      this.items.forEach(i => {

          let item = document.createElement('a'), label = ''
          item.setAttribute('class', 'app-modal-sortable-item')

          if(i.label.indexOf('<') == -1) {
            label = i.label
          }
          else {
            label = '[HTML]'
          }

          item.innerHTML += `<i class="drag-handle material-icons">drag_handle</i>
                      <h3>${label}</h3>
                      <p>${i.url}</p>
                      <i class="remove-item material-icons">remove_circle_outline</i>`

          list.appendChild(item)

          // handle click of list item
          item.addEventListener('click', function(e) {

              if(!e.target.classList.contains('drag-handle') && !e.target.classList.contains('remove-item')) {

                // get index
                let element = e.target,
                    index = Array.from(element.parentNode.children).indexOf(element)

                // edit field
                window.dispatchEvent(new CustomEvent('app.editMenuItem', {detail: {item: context.items[index], index: index}}))

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
          },

      })

    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // handle toggles
        var toggles = document.querySelectorAll('[toggle-edit-menu-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // listen for the editor event to show modal
        window.addEventListener('app.updateMenuItem', data => {

          // update field
          context.items[data.detail.index] = data.detail.item

          // update
          context.updateList()
          
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

            context.update()
            context.toggleModal()

            return false
        })

        // add button
        document.querySelector('#button-add-menu-item').addEventListener('click', function(e) { 

          // new item
          let item = {
            label: 'New Menu Item',
            url: '#',
            cssClass: '',
            nested: false,
            target: ''
          };

          // push fields
          context.items.push(item);

          // update ui
          context.updateList()

          e.preventDefault()
        })

        // setup tabs
        this.modal.querySelector('.app-modal-tabs').addEventListener('click', function(e) { 

          if(e.target.nodeName.toUpperCase() == 'A') {

            // switch active tab
            let lis = context.modal.querySelectorAll('.app-modal-tabs li')
            for(let x=0; x<lis.length; x++) lis[x].removeAttribute('active')

            e.target.parentNode.setAttribute('active', '')

            context.type = e.target.getAttribute('data-tab')
            context.fillList()

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

      let parser = new DOMParser()
      let doc = parser.parseFromString(html, "text/html")
      let links = doc.querySelectorAll('a')
      let arr = []

      for(let x=0; x < links.length; x++) {

        let label = links[x].innerHTML
        let href = links[x].getAttribute('href') || ''
        let cssClass = links[x].getAttribute('class') || ''
        let link = links[x]
        let nested = false
        let target = links[x].getAttribute('target') || '';

        if(link.closest('ul').parentNode.nodeName.toUpperCase() == 'LI') {
          nested = true;
        }

        arr.push({
            label: label,
            url: href,
            cssClass: cssClass,
            nested: nested,
            target: target
          });

      }
      
      this.items = arr;

    }

}