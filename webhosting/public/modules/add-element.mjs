/*
 * Models the add element modal
 */
export class AddElementModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="add-element-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-add-element-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Add Element</h2>
        
            <div class="app-modal-form">

              <div id="select-element" class="app-modal-image-select"></div>
        
            </div>  
        
            <div class="app-modal-actions"></div>
        
          </form>
          
        </div>
        </section>`

        this.properties = {}
        this.attributes = {}
        this.items = []

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#add-element-modal')
        this.form = this.modal.querySelector('form')

        // fill 
        this.fillList()

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    fillList() {

      let data = {},
            context = this

      // post form
      var xhr = new XMLHttpRequest()
      xhr.open('GET', '/api/page/elements/list', true)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(data))

      xhr.onload = function() {
          if (xhr.status >= 200 && xhr.status < 400) {
              let json = JSON.parse(xhr.responseText),
                  index = 0

              // set items
              context.items = json

              json.forEach(i => {

                  if(i.type == 'item') {
                    let item = document.createElement('a')
                    item.setAttribute('data-index', index)

                    if(i.image) {
                      item.innerHTML += `<img src="${i.image}"><span>${i.title}</span>`
                    }
                    else if(i.icon) {
                      item.innerHTML += `<i class="material-icons">${i.icon}</i><span>${i.title}</span>`
                    }

                    context.modal.querySelector('.app-modal-image-select').appendChild(item)

                    // handle click of list item
                    item.addEventListener('click', function(e) {
               
                      let index = e.target.getAttribute('data-index')

                      // add html
                      context.add(context.items[index].html)
                      
                    })
                  }
                  else if(i.type == 'separator') {
                    let item = document.createElement('h3')
                    item.innerHTML = i.title
                    context.modal.querySelector('.app-modal-image-select').appendChild(item)
                  }

                  index++

              });

              
          }
          else {
              
          }
      }
      // end xhr

  }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-add-element-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        
        window.addEventListener('editor.event', data => {

          console.log('[add.element] detail', data.detail)

          if(data.detail.type == 'add') {
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
     * Adds the element
     */
    add(html) {
      // this.onUpdate.emit({type: 'add', html: html, isLayout: element.isLayout, insertAfter: this.insertAfter});
      shared.sendAdd({type: 'add', html: html, isLayout: false, insertAfter: true})

      this.toggleModal()
    }
}