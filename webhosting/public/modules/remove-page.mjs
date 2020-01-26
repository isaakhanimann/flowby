/*
 * Models the remove page modal
 */
export class RemovePageModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="remove-page-modal" class="app-modal">
            
          <div class="app-modal-container">

            <a class="app-modal-close" toggle-remove-page-modal>
                <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>
        
            <form>
        
              <h2>Remove Page</h2>
        
              <div class="app-modal-form">
        
                <p class="long-text">Are you sure you want to remove page <b id="remove-page-url"></b>?</p>
        
              </div>
        
              <div class="app-modal-actions">
                <button type="submit">Remove Page</button>
              </div>
        
            </form>
        
          </div>
        </section>`

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#remove-page-modal')
        this.form = this.modal.querySelector('form')

        // get current url
        const params = new URLSearchParams(window.location.search)
        this.url = params.get('page') || 'index.html'

        // remove leading /
        this.url = (this.url[0] == '/') ? this.url.substr(1) : this.url
        this.urlToBeRemoved = ''

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        var toggles = document.querySelectorAll('[toggle-remove-page-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        this.form.addEventListener('submit', function(e) {
            context.remove()
            e.preventDefault()
            return false
        })

        // listen for event to show modal
        window.addEventListener('app.removePage', data => {
          console.log('[app.selectPage] removePage', data.detail)
          context.urlToBeRemoved = data.detail.url || null
          document.querySelector('#remove-page-url').innerHTML = data.detail.url
          context.toggleModal()
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
     * Adds the page
     */
    remove() {

        // set data
        let data = {
                url: this.urlToBeRemoved,
            }, 
            context = this

        shared.toast.show('loading', 'Removing page...', false)

        // post form
        var xhr = new XMLHttpRequest()
        xhr.open('POST', '/api/page/remove', true)
        xhr.setRequestHeader('Content-Type', 'application/json')
        xhr.send(JSON.stringify(data))

        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 400) {
                shared.toast.show('success', 'Page removed successfully!', true)
                location.href = `/edit?page=/index.html`
            }
            else {
                shared.toast.show('failure', 'There was an error removing the page', true)
            }
        }
    }
}