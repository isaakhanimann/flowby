var shared = {}

/*
 * Sends commands to the editor
 */
shared.sendCommand = function(command) {
    document.querySelector('#edit-frame').contentWindow.postMessage({
        'command': 'command',
        'text': command
    }, '*')
}

shared.sendUpdate = function(obj) {
    document.querySelector('#edit-frame').contentWindow.postMessage({
        'command': 'update',
        'obj': obj
      }, '*')
}

shared.sendAdd = function(obj) {
    document.querySelector('#edit-frame').contentWindow.postMessage({
        'command': 'add',
        'html': obj.html,
        'isLayout': obj.isLayout,
        'insertAfter': obj.insertAfter
      }, '*')
}

/*
  * Shows a toast
  * Usage:
  * app.toast.show('success', 'Saved!', true)
  * app.toast.show('failure', 'Error!', true)
  * app.toast.show('loading', 'Loading...', false)
  */
 shared.toast = (function() {

    return {

        version: '0.0.1',

        /**
         * Creates the toast
         */
        setup: function() {
            var current

            current = document.createElement('div')
            current.setAttribute('class', 'site-toast')
            current.innerHTML = 'Sample Toast'

            // append toast
            document.body.appendChild(current)

            return current
        },

        /**
         * Shows the toast
         */
        show: function(status, text, autoHide) {

            var current

            current = document.querySelector('.site-toast')

            if(current == null) {
                current = shared.toast.setup()
            }

            current.removeAttribute('success')
            current.removeAttribute('failure')
            current.removeAttribute('loading')

            current.setAttribute('active', '')

            // add success/failure
            if (status == 'success') {
                current.setAttribute('success', '')

                text = `<span>${text}</span>`
            }
            else if (status == 'failure') {
                current.setAttribute('failure', '')

                text = `<span>${text}</span>`
            }
            else if (status == 'loading') {
                current.setAttribute('loading', '')

                text = `<svg class="loading-icon" width="38" height="38" viewBox="0 0 38 38" xmlns="http://www.w3.org/2000/svg" stroke="#fff">
                         <g fill="none" fill-rule="evenodd">
                            <g transform="translate(1 1)" stroke-width="2">
                                <circle stroke-opacity=".5" cx="18" cy="18" r="18"/>
                                <path d="M36 18c0-9.94-8.06-18-18-18">
                                    <animateTransform
                                        attributeName="transform"
                                        type="rotate"
                                        from="0 18 18"
                                        to="360 18 18"
                                        dur="1s"
                                        repeatCount="indefinite"/>
                                </path>
                            </g>
                        </g>
                    </svg><span>${text}</span>`
            }

            // set text
            current.innerHTML = text

            // enable persistent messages
            if(autoHide == true) {
                setTimeout(function() {
                current.removeAttribute('active')
                }, 1000)

            }

        }

    }

})();