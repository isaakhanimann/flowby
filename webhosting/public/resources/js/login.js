/*
 * Model for the Login page
 */
class Login {

    /*
     * Initializes the model
     */
    constructor() {

        this.form = document.querySelector('form')

        // check for error
        const params = new URLSearchParams(window.location.search)

        if(params.get('error')) {
            shared.toast.show('failure', 'There was an error logging in. Please try again.', true)
        }

        // handle submit
        this.form.addEventListener('submit', function(e) {

            shared.toast.show('loading', 'Logging in...', false)

        })
    }
}

new Login()