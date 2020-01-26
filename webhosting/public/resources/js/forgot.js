/*
 * Model for the Forgot page
 */
class Forgot {

    /*
     * Initializes the model
     */
    constructor() {

        this.form = document.querySelector('form')

        // handle submit
        this.form.addEventListener('submit', function(e) {

            shared.toast.show('loading', 'Sending reset email...', false)

            let data = {
                email: document.querySelector('#forgot-email').value
            },
            context = this

            // post form
            var xhr = new XMLHttpRequest()
            xhr.open('POST', '/api/user/forgot', true)
            xhr.setRequestHeader('Content-Type', 'application/json')
            xhr.send(JSON.stringify(data))

            xhr.onload = function() {
                if (xhr.status >= 200 && xhr.status < 400) {
                    shared.toast.show('success', 'Email sent!', true)
                    location.href = '/reset'
                }
                else {
                    shared.toast.show('failure', 'There was an error reseting your password.', true)
                }
            }
            // end xhr

            e.preventDefault()
            return false
        })
    }
}

new Forgot()