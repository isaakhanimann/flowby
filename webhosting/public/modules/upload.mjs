/*
 * Upload - S3 Upload for the Fixture application
 * @author matt@matthewsmith.com
 * @ref: https://fixture.app
 * Based on https://codepen.io/joezimjs/pen/yPWQbd
 */
export class Upload {

    constructor(el, url, method, fnComplete, fnError) {

        let maxWidth = 1700;
        let resizableImages = ['image/jpeg', 'image/png', 'image/tiff', 'image/webp', 'image/bmp'];
        let supportedTypes = ['image/jpeg', 'image/png', 'image/tiff', 'image/webp', 'image/bmp', 'image/gif', 'image/svg+xml',
                            'video/mp4', 'audio/aac', 'audio/wav', 'audio/webm', 'video/webm',
                            'application/pdf'];

        // generate an id
        function makeid(length) {
        var text = "";
        var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        
        for (var i = 0; i < length; i++)
            text += possible.charAt(Math.floor(Math.random() * possible.length));
        
        return text;
        }

        let id = makeid(4);

        // inject html
        el.innerHTML = `
<form class="app-upload-form">
<input id="upload-file-${id}" type="file" multiple>
<label class="app-upload-button" for="upload-file-${id}">Tap or drag files here to upload</label>
</form>
<progress class="app-upload-progress-bar" max="100" value="0"></progress>
<div class="app-upload-gallery" /></div>      
`;
        // get elements
        let progressBar = el.querySelector('.app-upload-progress-bar'),
            input = el.querySelector('input[type=file]'),
            gallery = el.querySelector('.app-upload-gallery');

        // Prevent default drag behaviors
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            el.addEventListener(eventName, preventDefaults, false);
            document.body.addEventListener(eventName, preventDefaults, false);
        });

        // Highlight drop area when item is dragged over it
        ['dragenter', 'dragover'].forEach(eventName => {
            el.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            el.addEventListener(eventName, unhighlight, false);
        });

        // Handle dropped files
        el.addEventListener('drop', handleDrop, false);
        
        // handle clicked files
        input.addEventListener('change', function() {
            console.log(this.files);

            let files = this.files;
            handleFiles(files);
        }, false);

        /*
         * Prevent default function behaivor
         */
        function preventDefaults (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        /*
         * Highlight drop area
         */
        function highlight(e) {
            el.classList.add('highlight');
        }

        /*
         * Unhighlight drop area
         */
        function unhighlight(e) {
            el.classList.remove('active');
        }

        /*
         * Handle file drop
         */
        function handleDrop(e) {
            var dt = e.dataTransfer;
            var files = dt.files;

            handleFiles(files);
        }

        let uploadProgress = [];

        /*
         * Initialize progress
         */
        function initializeProgress(numFiles) {
            progressBar.value = 0;
            uploadProgress = [];

            for(let i = numFiles; i > 0; i--) {
                uploadProgress.push(0);
            }
        }

        /*
         * Update progress
         */
        function updateProgress(fileNumber, percent) {
            uploadProgress[fileNumber] = percent;
            let total = uploadProgress.reduce((tot, curr) => tot + curr, 0) / uploadProgress.length;
            console.debug('update', fileNumber, percent, total);
            progressBar.value = total;
        }

        /*
         * Handle files
         */
        function handleFiles(files) {

            console.log('[debug] handle files');
            console.log(files);

            files = [...files];
            initializeProgress(files.length);
            
            // determine if file is supported
            files.forEach(previewFile);
        }

        /*
         * Resizes images using pica
         */
        function resizeImage(container, file, maxWidth, done) {

            console.log(file)

            let reader = new FileReader(),
                ext = file.name.split('.').pop();
            
            reader.readAsDataURL(file)
            reader.onloadend = function() {
                
                let img = document.createElement("img"),
                    natural = document.createElement("canvas"),
                    thumb = document.createElement("canvas"),
                    resized = document.createElement("canvas");

                // set src
                img.src = reader.result;

                img.onload = function() {
                    var height = img.height,
                        width = img.width,
                        resizeWidth = img.width,
                        resizeHeight = img.height;

                    if(width > maxWidth) {
                        resizeWidth = maxWidth;
                    }

                    resizeHeight = (resizeWidth/width) * height;

                    // set thumb
                    if(width > height) {
                        thumb.setAttribute('width', 250);
                        thumb.setAttribute('height', ((250/width) * height))
                    } 
                    else {
                        thumb.setAttribute('width', (250/height) * width)
                        thumb.setAttribute('height', 250); 
                    }                
                    
                    // set canvas width
                    resized.setAttribute('width', resizeWidth)
                    resized.setAttribute('height', resizeHeight)

                    // set natural image
                    natural.setAttribute('width', width)
                    natural.setAttribute('height', height)

                    // draw the image
                    thumb.getContext('2d').drawImage(img, 0, 0)
                    resized.getContext('2d').drawImage(img, 0, 0)
                    natural.getContext('2d').drawImage(img, 0, 0)

                    // resize jpgs and pngs
                    if(ext.toLowerCase() == 'png' || ext.toLowerCase() == 'jpg') {
                        uploadBlob(file, resized.toDataURL(), thumb.toDataURL(), 0)
                    }
                    else {
                        let url = natural.toDataURL()
                        uploadBlob(file, url, url, 0)
                    }
        

                    /*
                    const p = pica();

                    console.log('before resize', file)
                    
                    // resize img
                    p.resize(img, canvas)
                        .then(result => {

                            // resize thumb
                            p.resize(img, thumb)
                                .then(result => {
                                    
                                })

                        });*/

                    

                }
                // end onload
                
            }
            // end reader.onloadend
        }

        /*
         * Preview file and resize (if image/*)
         */
        function previewFile(file, index) {

            // determine if file is supported
            if(supportedTypes.indexOf(file.type) > -1) {

                // see if it is a resizable image
                if(resizableImages.indexOf(file.type) > -1) {

                    let f = "";

                    // create container to hold image
                    var container = document.createElement('div');
                    container.setAttribute('class', 'app-upload-container');
                    container.innerHTML = `
                        <div class="app-upload-container-image"><span>Retrieving image...</span></div>
                    `;
                
                    document.body.appendChild(container);
                    
                    var imageContainer = container.querySelector('.app-upload-container-image');
                    imageContainer.setAttribute('data-file-type', file.type);

                    resizeImage(container, file, maxWidth, function(canvas) {
                        
                        container.querySelector('span').remove();
                        canvas.setAttribute('class', 'app-upload-canvas');
                        imageContainer.appendChild(canvas);

                    });
                    // end resize
                }
                else {
                    
                    function getBase64(file) {
                        var reader = new FileReader();
                        reader.readAsDataURL(file);
                        reader.onload = function () {
                            console.log(reader.result);

                            let thumb = null
                            
                            if(file.type.indexOf('images/') != -1) {
                                thumb = reader.result
                            }

                            uploadBlob(file, reader.result, reader.result, 0)
                        };
                        reader.onerror = function (error) {
                            console.log('Error: ', error);
                        };
                    }          
                    
                    getBase64(file)

                    
                }
            }
            // end supported check

        }

        /*
         * Upload blob data
         */
        function uploadBlob(file, image, thumb, index) {

            var xhr = new XMLHttpRequest()

            var data = {
                name: file.name,
                size: file.size,
                type: file.type,
                image: image,
                thumb: thumb
            }
            
            console.log('uploadBlob.data', data)

            xhr.open(method, url, true);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest')

            // Update progress (can be used to show progress indicator)
            xhr.upload.addEventListener("progress", function(e) {
                updateProgress(index, (e.loaded * 100.0 / e.total) || 100)
            });

            xhr.addEventListener('readystatechange', function(e) {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    updateProgress(index, 100)
                    fnComplete(file)
                }
                else if (xhr.readyState == 4 && xhr.status != 200) {
                    fnError(xhr.status, xhr.responseText)
                }
            });

            // send blob
            xhr.setRequestHeader('Content-Type', 'application/json')
            xhr.send(JSON.stringify(data))
        }

    }

}