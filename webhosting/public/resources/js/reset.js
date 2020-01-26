/*
 * Model for the Reset page
 */
class Reset {

    /*
     * Initializes the model
     */
    constructor() {

        this.form = document.querySelector('form')

        // handle submit
        this.form.addEventListener('submit', function(e) {

            let email = document.querySelector('#reset-email').value,
                token = document.querySelector('#reset-token').value,
                password = document.querySelector('#reset-password').value,
                retype = document.querySelector('#reset-retype').value

            // check first
            if(password != retype) {
                shared.toast.show('failure', 'Password must match retype field', true)
            }
            else {

                let data = {
                    email: email,
                    token: token,
                    password: password
                },
                context = this

                shared.toast.show('loading', 'Updating password...', false)

                // post form
                var xhr = new XMLHttpRequest()
                xhr.open('POST', '/api/user/reset', true)
                xhr.setRequestHeader('Content-Type', 'application/json')
                xhr.send(JSON.stringify(data))

                xhr.onload = function() {
                    if (xhr.status >= 200 && xhr.status < 400) {
                        shared.toast.show('success', 'Password reset!', true)
                        location.href = '/login'
                    }
                    else {
                        shared.toast.show('failure', 'There was an error resetting your password.', true)
                    }
                }
                // end xhr
            }

            e.preventDefault()
            return false
        })
    }
}

new Reset()