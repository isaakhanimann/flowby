/*
 * Model for the Edit page
 */
export class Edit {

    /*
     * Initializes the model
     */
    constructor() {

        this.frame = document.querySelector('#edit-frame')
        this.url = '/index.html'
        this.viewPage = document.querySelector('#view-page')
        this.viewMobile = document.querySelector('#view-mobile')
        this.viewSettings = document.querySelector('#view-settings')
        this.publish = document.querySelector('#publish')
        this.modalSelectBlock = document.querySelector('#modal-select-block')

        const params = new URLSearchParams(window.location.search)
        
        this.url = params.get('page') || '/index.html'

        if(this.url != '') {
            this.frame.src = `${this.url}?edit=true`
        }

        this.setupEvents()
        this.setupFrameListener()
    }

    /*
     * Setup the events for the page
     */
    setupEvents() {

        let context = this;

        this.viewPage.setAttribute('href', this.url)
        this.viewPage.setAttribute('target', '_blank')

        // view mobile
        this.viewMobile.addEventListener('click', function(e) {

            if(context.viewMobile.hasAttribute('active')) {
                context.viewMobile.removeAttribute('active')
                context.frame.removeAttribute('mobile')
            }
            else {
                context.viewMobile.setAttribute('active', '')
                context.frame.setAttribute('mobile', '')
            }

        })

        // publish
        this.publish.addEventListener('click', function(e) {
            context.frame.contentWindow.postMessage({'command': 'save'}, '*'); 
        })
    }

    /*
     * Setup frame listener
     */
    setupFrameListener() {
        window.addEventListener('message', message => {

            console.log(message)

            if(message.data) {
                if(message.data.command == 'save') {
                    this.save(message.data.data)
                }
                else if(message.data.command == 'editor-loaded') {
                    this.frame.setAttribute('active', '')
                }
                else if(message.data.command == 'show') {
                    window.dispatchEvent(new CustomEvent('editor.show', {detail: message.data}))
                }
                else if(message.data.type && message.data.properties) {
                    window.dispatchEvent(new CustomEvent('editor.event', {detail: message.data}))
                }
            }
         })
    }

    /*
     * Save HTML
     */
    save(html) {

        // remove leading /
        let url = (this.url[0] == '/') ? this.url.substr(1) : this.url

        // set data
        let data = {
            html: html,
            url: url
        }

        shared.toast.show('loading', 'Saving page...', false)

        // post form
        var xhr = new XMLHttpRequest()
        xhr.open('POST', '/api/page/save', true)
        xhr.setRequestHeader('Content-Type', 'application/json')
        xhr.send(JSON.stringify(data))

        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 400) {
                shared.toast.show('success', 'Page saved successfully!', true)
                location.reload()
            }
            else {
                shared.toast.show('failure', 'There was an error saving the page', true)
            }
        }
    }
}