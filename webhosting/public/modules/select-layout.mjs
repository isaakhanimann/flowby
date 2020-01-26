/*
 * Model for the Edit page
 */
export class SelectLayout {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<div id="modal-select-layout" class="app-fullscreen-modal">
                        <button id="modal-select-layout-close" class="app-fullscreen-modal-close"><img src="https://s3.amazonaws.com/resources.fixture.app/builder/resources/close.svg"></button>
                        <iframe id="modal-select-layout-frame" class="app-fullscreen-modal-frame"></iframe>
                    </div>`

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.version = 2
        this.buttonAddLayout = document.querySelector('#button-add-layout')
        this.modalSelectLayout = document.querySelector('#modal-select-layout')
        this.modalSelectLayoutFrame = document.querySelector('#modal-select-layout-frame')
        this.modalSelectLayoutClose = document.querySelector('#modal-select-layout-close')
        this.selectLayoutUrl = '/select/index.html'

        // handle events
        this.setupEvents()
        this.setupFrameListener()
    }

    /*
     * Setup the events for the page
     */
    setupEvents() {

        let context = this;

        // handle select layout
        this.buttonAddLayout.addEventListener('click', function(e) {
            context.modalSelectLayout.setAttribute('active', '');
            context.modalSelectLayoutFrame.src = `${context.selectLayoutUrl}?&version=${context.version}`;
        })

        this.modalSelectLayoutClose.addEventListener('click', function(e) {
            context.modalSelectLayout.removeAttribute('active');
        })
    }

    /*
     * Setup frame listener
     */
    setupFrameListener() {

        let context = this

        window.addEventListener('message', message => {
            if(message.data) {
                if(message.data.command == 'add-block') {
                    shared.sendAdd({type: 'add', html: message.data.data, isLayout: true, insertAfter: true})
                    context.modalSelectLayout.removeAttribute('active');
                }
            }
        }) 

    }
    

}