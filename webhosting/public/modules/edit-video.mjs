/*
 * Models the edit video modal
 */
export class EditVideoModal {

    /*
     * Initializes the model
     */
    constructor() {

        // setup view
        this.view = `<section id="edit-video-modal" class="app-modal">
        <div class="app-modal-container">
        
            <a class="app-modal-close" toggle-edit-video-modal>
              <svg width="100%" height="100%" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet"><g><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"></path></g></svg>
            </a>

          <form>

            <h2>Edit Video</h2>
        
            <div class="app-modal-form">
        
              <div class="app-modal-form-group">
                <label>Source <a id="edit-video-select-video">Select Video</a></label>
                <input id="edit-video-src" type="text" maxlength="128" placeholder="" name="src">
              </div>

              <div class="app-modal-form-group">
                <label>Poster <a id="edit-video-select-image">Select Poster</a></label>
                <input id="edit-video-poster" type="text" maxlength="128" placeholder="" name="src">
              </div>

              <div class="app-modal-form-group">
                <label>Autoplay video?</label>
                <select id="edit-video-autoplay" name="autoplay">
                  <option value="true">Yes</option>
                  <option value="false">No</option>
                </select>
              </div>
        
              <div class="app-modal-form-group">
                <label>Loop video?</label>
                <select id="edit-video-loop" name="loop">
                  <option value="true">Yes</option>
                  <option value="false">No</option>
                </select>
              </div>
        
              <div class="app-modal-form-group">
                <label>Show video controls?</label>
                <select id="edit-video-controls" name="controls">
                  <option value="true">Yes</option>
                  <option value="false">No</option>
                </select>
              </div>
        
            </div>  
        
            <div class="app-modal-actions">
              <button type="submit">Update</button>
            </div>
        
          </form>
          
        </div>
        </section>`

        this.properties = {}
        this.attributes = {}

        this.autoplay = false
        this.controls = true
        this.loop = true
        this.src = ''
        this.poster = ''

        // append view to DOM
        document.body.insertAdjacentHTML('beforeend', this.view)

        // setup private variables
        this.modal = document.querySelector('#edit-video-modal')
        this.form = this.modal.querySelector('form')

        // handle events
        this.setupEvents()
    }

    /*
     * Setup events
     */
    setupEvents() {
        var context = this

        // toggle modals
        var toggles = document.querySelectorAll('[toggle-edit-video-modal]');

        for(let x=0; x<toggles.length; x++) {
            toggles[x].addEventListener('click', function(e) { 
                context.toggleModal()
            })
        }

        // handle form submission
        this.form.addEventListener('submit', function(e) {
            e.preventDefault()
            context.edit()
            return false
        })

        // handle select image
        this.modal.querySelector('#edit-video-select-image').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectImage', {detail: {target: '#edit-video-poster'}}))
        })

        // handle select image
        this.modal.querySelector('#edit-video-select-video').addEventListener('click', function(e) {
          window.dispatchEvent(new CustomEvent('app.selectFile', {detail: {target: '#edit-video-src'}}))
        })

        // listen for the editor event to show modal
        window.addEventListener('editor.event', data => {

          console.log('[edit.image] detail', data.detail)

          if(data.detail.type == 'widget' && data.detail.widget == 'video') {

            // parse HTML
            this.parseHTML(data.detail.properties.html)

            // set inputs
            document.querySelector('#edit-video-src').value = this.src
            document.querySelector('#edit-video-poster').value = this.poster
            document.querySelector('#edit-video-autoplay').value = this.autoplay
            document.querySelector('#edit-video-controls').value = this.controls
            document.querySelector('#edit-video-loop').value = this.loop

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
     * Edits the element
     */
    edit() {

      this.src = document.querySelector('#edit-video-src').value || ''
      this.poster = document.querySelector('#edit-video-poster').value || ''
      this.autoplay = (document.querySelector('#edit-video-autoplay').value == 'true')
      this.controls = (document.querySelector('#edit-video-controls').value == 'true')
      this.loop = (document.querySelector('#edit-video-loop').value == 'true')

      let html = this.buildHTML()
      shared.sendUpdate({type: 'element', properties: {html: html}})

      this.toggleModal()
    }

    /**
   * Builds HTML from the fields
   * <video controls="" autoplay="" class="responsive-video">
   *      <source src="" type="video/mp4">
   *       Your browser does not support the video tag.
   *  </video>
   */
  buildHTML() {

    let attribs = '';

    if(this.autoplay == true) {
      attribs += 'autoplay ';
    }

    if(this.controls == true) {
      attribs += 'controls ';
    }

    if(this.loop == true) {
      attribs += 'loop ';
    }

    attribs = attribs.trim();


    return `<video poster="${this.poster}" ${attribs} class="responsive-video">
              <source src="${this.src}" type="video/mp4">
              Your browser does not support the video tag.
            </video>`;

  }

  /**
   * Parses the HTML into usable form fields
   */
  parseHTML(html) {

    let parser = new DOMParser();
    let doc = parser.parseFromString(html, 'text/html');
    let el = null, src = null;

    console.log('[html]', html)

    // get button
    el = doc.querySelector('video')
    src = doc.querySelector('source')


    console.log('[video]', el)

    if(el.hasAttribute('autoplay')) {
      this.autoplay = true
    }

    if(el.hasAttribute('loop')) {
      this.loop = true
    }

    if(el.hasAttribute('controls')) {
      this.controls = true
    }

    this.poster = el.getAttribute('poster') || ''
    this.src = src.getAttribute('src') || ''

  }

}