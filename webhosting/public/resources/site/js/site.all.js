var site = site || {};

// load editor / built-in libraries
if(window.location.href.indexOf('?edit=true') != -1) {
  document.write('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
  document.write('<link rel="stylesheet" href="/resources/editor/editor.css">');
  document.write('<script src="/resources/editor/editor.js"></script>');
  document.write('<script>editor.setup( {sortable: ".col", blocks: ".grid" });</script>')
}
else {

  /*!
  * Scroll Entrance (https://github.com/andycaygill/scroll-entrance)
  */
  !function(){entrance={},entrance.duration="1000",entrance.distance="200",entrance.heightOffset=200,entrance.isElemInView=function(e){var t=e.getBoundingClientRect();return t.top+entrance.heightOffset>=0&&t.top+entrance.heightOffset<=window.innerHeight||t.bottom+entrance.heightOffset>=0&&t.bottom+entrance.heightOffset<=window.innerHeight||t.top+entrance.heightOffset<0&&t.bottom+entrance.heightOffset>window.innerHeight},entrance.setInitialStyles=function(e){document.body.style.overflowX="hidden";var t=e.getAttribute("data-entrance"),n=e.getAttribute("data-entrance-delay");e.style.transition="all "+entrance.duration/1e3+"s ease",n&&(e.style.transitionDelay=n/1e3+"s"),"fade"==t&&(e.style.opacity="0"),"from-left"==t&&(e.style.opacity="0",e.style.transform="translate(-"+entrance.distance+"px, 0)"),"from-right"==t&&(e.style.opacity="0",e.style.transform="translate("+entrance.distance+"px, 0)"),"from-top"==t&&(e.style.opacity="0",e.style.transform="translate(0, -"+entrance.distance+"px)"),"from-bottom"==t&&(e.style.opacity="0",e.style.transform="translate(0, "+entrance.distance+"px)")},entrance.enter=function(e){e.style.visibility="visible",e.style.opacity="1",e.style.transform="translate(0, 0)",e.className+=" has-entered"},entrance.viewportChange=function(){Array.prototype.map.call(entrance.elements,function(e){if(entrance.isElemInView(e)){var t=e.classList.contains("has-entered");t||entrance.enter(e)}})},entrance.init=function(){entrance.elements=document.querySelectorAll("[data-entrance]"),Array.prototype.map.call(entrance.elements,function(e){entrance.setInitialStyles(e),entrance.isElemInView(e)&&addEventListener("load",function(){entrance.enter(e)},!1)})},addEventListener("DOMContentLoaded",entrance.init,!1),addEventListener("scroll",entrance.viewportChange,!1),addEventListener("resize",entrance.viewportChange,!1)}();

  /*!
  * accounting.js v0.4.2, copyright 2014 Open Exchange Rates, MIT license, http://openexchangerates.github.io/accounting.js
  */
  (function(p,z){function q(a){return!!(""===a||a&&a.charCodeAt&&a.substr)}function m(a){return u?u(a):"[object Array]"===v.call(a)}function r(a){return"[object Object]"===v.call(a)}function s(a,b){var d,a=a||{},b=b||{};for(d in b)b.hasOwnProperty(d)&&null==a[d]&&(a[d]=b[d]);return a}function j(a,b,d){var c=[],e,h;if(!a)return c;if(w&&a.map===w)return a.map(b,d);for(e=0,h=a.length;e<h;e++)c[e]=b.call(d,a[e],e,a);return c}function n(a,b){a=Math.round(Math.abs(a));return isNaN(a)?b:a}function x(a){var b=c.settings.currency.format;"function"===typeof a&&(a=a());return q(a)&&a.match("%v")?{pos:a,neg:a.replace("-","").replace("%v","-%v"),zero:a}:!a||!a.pos||!a.pos.match("%v")?!q(b)?b:c.settings.currency.format={pos:b,neg:b.replace("%v","-%v"),zero:b}:a}var c={version:"0.4.1",settings:{currency:{symbol:"$",format:"%s%v",decimal:".",thousand:",",precision:2,grouping:3},number:{precision:0,grouping:3,thousand:",",decimal:"."}}},w=Array.prototype.map,u=Array.isArray,v=Object.prototype.toString,o=c.unformat=c.parse=function(a,b){if(m(a))return j(a,function(a){return o(a,b)});a=a||0;if("number"===typeof a)return a;var b=b||".",c=RegExp("[^0-9-"+b+"]",["g"]),c=parseFloat((""+a).replace(/\((.*)\)/,"-$1").replace(c,"").replace(b,"."));return!isNaN(c)?c:0},y=c.toFixed=function(a,b){var b=n(b,c.settings.number.precision),d=Math.pow(10,b);return(Math.round(c.unformat(a)*d)/d).toFixed(b)},t=c.formatNumber=c.format=function(a,b,d,i){if(m(a))return j(a,function(a){return t(a,b,d,i)});var a=o(a),e=s(r(b)?b:{precision:b,thousand:d,decimal:i},c.settings.number),h=n(e.precision),f=0>a?"-":"",g=parseInt(y(Math.abs(a||0),h),10)+"",l=3<g.length?g.length%3:0;return f+(l?g.substr(0,l)+e.thousand:"")+g.substr(l).replace(/(\d{3})(?=\d)/g,"$1"+e.thousand)+(h?e.decimal+y(Math.abs(a),h).split(".")[1]:"")},A=c.formatMoney=function(a,b,d,i,e,h){if(m(a))return j(a,function(a){return A(a,b,d,i,e,h)});var a=o(a),f=s(r(b)?b:{symbol:b,precision:d,thousand:i,decimal:e,format:h},c.settings.currency),g=x(f.format);return(0<a?g.pos:0>a?g.neg:g.zero).replace("%s",f.symbol).replace("%v",t(Math.abs(a),n(f.precision),f.thousand,f.decimal))};c.formatColumn=function(a,b,d,i,e,h){if(!a)return[];var f=s(r(b)?b:{symbol:b,precision:d,thousand:i,decimal:e,format:h},c.settings.currency),g=x(f.format),l=g.pos.indexOf("%s")<g.pos.indexOf("%v")?!0:!1,k=0,a=j(a,function(a){if(m(a))return c.formatColumn(a,f);a=o(a);a=(0<a?g.pos:0>a?g.neg:g.zero).replace("%s",f.symbol).replace("%v",t(Math.abs(a),n(f.precision),f.thousand,f.decimal));if(a.length>k)k=a.length;return a});return j(a,function(a){return q(a)&&a.length<k?l?a.replace(f.symbol,f.symbol+Array(k-a.length+1).join(" ")):Array(k-a.length+1).join(" ")+a:a})};if("undefined"!==typeof exports){if("undefined"!==typeof module&&module.exports)exports=module.exports=c;exports.accounting=c}else"function"===typeof define&&define.amd?define([],function(){return c}):(c.noConflict=function(a){return function(){p.accounting=a;c.noConflict=z;return c}}(p.accounting),p.accounting=c)})(this);

  /* Siema (https://github.com/pawelgrzybek/siema) */
  !function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define("Siema",[],t):"object"==typeof exports?exports.Siema=t():e.Siema=t()}(this,function(){return function(e){function t(s){if(i[s])return i[s].exports;var r=i[s]={i:s,l:!1,exports:{}};return e[s].call(r.exports,r,r.exports,t),r.l=!0,r.exports}var i={};return t.m=e,t.c=i,t.i=function(e){return e},t.d=function(e,i,s){t.o(e,i)||Object.defineProperty(e,i,{configurable:!1,enumerable:!0,get:s})},t.n=function(e){var i=e&&e.__esModule?function(){return e.default}:function(){return e};return t.d(i,"a",i),i},t.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},t.p="",t(t.s=0)}([function(e,t,i){"use strict";function s(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var r="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},n=function(){function e(e,t){for(var i=0;i<t.length;i++){var s=t[i];s.enumerable=s.enumerable||!1,s.configurable=!0,"value"in s&&(s.writable=!0),Object.defineProperty(e,s.key,s)}}return function(t,i,s){return i&&e(t.prototype,i),s&&e(t,s),t}}(),o=function(){function e(t){var i=this;s(this,e),this.config=e.mergeSettings(t),this.selector="string"==typeof this.config.selector?document.querySelector(this.config.selector):this.config.selector,this.selectorWidth=this.selector.offsetWidth,this.innerElements=[].slice.call(this.selector.children),this.currentSlide=this.config.startIndex,this.transformProperty=e.webkitOrNot(),["resizeHandler","touchstartHandler","touchendHandler","touchmoveHandler","mousedownHandler","mouseupHandler","mouseleaveHandler","mousemoveHandler"].forEach(function(e){i[e]=i[e].bind(i)}),this.init()}return n(e,[{key:"init",value:function(){if(window.addEventListener("resize",this.resizeHandler),this.config.draggable&&(this.pointerDown=!1,this.drag={startX:0,endX:0,startY:0,letItGo:null},this.selector.addEventListener("touchstart",this.touchstartHandler,{passive:!0}),this.selector.addEventListener("touchend",this.touchendHandler),this.selector.addEventListener("touchmove",this.touchmoveHandler,{passive:!0}),this.selector.addEventListener("mousedown",this.mousedownHandler),this.selector.addEventListener("mouseup",this.mouseupHandler),this.selector.addEventListener("mouseleave",this.mouseleaveHandler),this.selector.addEventListener("mousemove",this.mousemoveHandler)),null===this.selector)throw new Error("Something wrong with your selector ðŸ˜­");this.resolveSlidesNumber(),this.selector.style.overflow="hidden",this.sliderFrame=document.createElement("div"),this.sliderFrame.style.width=this.selectorWidth/this.perPage*this.innerElements.length+"px",this.sliderFrame.style.webkitTransition="all "+this.config.duration+"ms "+this.config.easing,this.sliderFrame.style.transition="all "+this.config.duration+"ms "+this.config.easing,this.config.draggable&&(this.selector.style.cursor="-webkit-grab");for(var e=document.createDocumentFragment(),t=0;t<this.innerElements.length;t++){var i=document.createElement("div");i.style.cssFloat="left",i.style.float="left",i.style.width=100/this.innerElements.length+"%",i.appendChild(this.innerElements[t]),e.appendChild(i)}this.sliderFrame.appendChild(e),this.selector.innerHTML="",this.selector.appendChild(this.sliderFrame),this.slideToCurrent(),this.config.onInit.call(this)}},{key:"resolveSlidesNumber",value:function(){if("number"==typeof this.config.perPage)this.perPage=this.config.perPage;else if("object"===r(this.config.perPage)){this.perPage=1;for(var e in this.config.perPage)window.innerWidth>=e&&(this.perPage=this.config.perPage[e])}}},{key:"prev",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:1,t=arguments[1];if(!(this.innerElements.length<=this.perPage)){var i=this.currentSlide;0===this.currentSlide&&this.config.loop?this.currentSlide=this.innerElements.length-this.perPage:this.currentSlide=Math.max(this.currentSlide-e,0),i!==this.currentSlide&&(this.slideToCurrent(),this.config.onChange.call(this),t&&t.call(this))}}},{key:"next",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:1,t=arguments[1];if(!(this.innerElements.length<=this.perPage)){var i=this.currentSlide;this.currentSlide===this.innerElements.length-this.perPage&&this.config.loop?this.currentSlide=0:this.currentSlide=Math.min(this.currentSlide+e,this.innerElements.length-this.perPage),i!==this.currentSlide&&(this.slideToCurrent(),this.config.onChange.call(this),t&&t.call(this))}}},{key:"goTo",value:function(e,t){if(!(this.innerElements.length<=this.perPage)){var i=this.currentSlide;this.currentSlide=Math.min(Math.max(e,0),this.innerElements.length-this.perPage),i!==this.currentSlide&&(this.slideToCurrent(),this.config.onChange.call(this),t&&t.call(this))}}},{key:"slideToCurrent",value:function(){this.sliderFrame.style[this.transformProperty]="translate3d(-"+this.currentSlide*(this.selectorWidth/this.perPage)+"px, 0, 0)"}},{key:"updateAfterDrag",value:function(){var e=this.drag.endX-this.drag.startX,t=Math.abs(e),i=Math.ceil(t/(this.selectorWidth/this.perPage));e>0&&t>this.config.threshold&&this.innerElements.length>this.perPage?this.prev(i):e<0&&t>this.config.threshold&&this.innerElements.length>this.perPage&&this.next(i),this.slideToCurrent()}},{key:"resizeHandler",value:function(){this.resolveSlidesNumber(),this.selectorWidth=this.selector.offsetWidth,this.sliderFrame.style.width=this.selectorWidth/this.perPage*this.innerElements.length+"px",this.slideToCurrent()}},{key:"clearDrag",value:function(){this.drag={startX:0,endX:0,startY:0,letItGo:null}}},{key:"touchstartHandler",value:function(e){e.stopPropagation(),this.pointerDown=!0,this.drag.startX=e.touches[0].pageX,this.drag.startY=e.touches[0].pageY}},{key:"touchendHandler",value:function(e){e.stopPropagation(),this.pointerDown=!1,this.sliderFrame.style.webkitTransition="all "+this.config.duration+"ms "+this.config.easing,this.sliderFrame.style.transition="all "+this.config.duration+"ms "+this.config.easing,this.drag.endX&&this.updateAfterDrag(),this.clearDrag()}},{key:"touchmoveHandler",value:function(e){e.stopPropagation(),null===this.drag.letItGo&&(this.drag.letItGo=Math.abs(this.drag.startY-e.touches[0].pageY)<Math.abs(this.drag.startX-e.touches[0].pageX)),this.pointerDown&&this.drag.letItGo&&(this.drag.endX=e.touches[0].pageX,this.sliderFrame.style.webkitTransition="all 0ms "+this.config.easing,this.sliderFrame.style.transition="all 0ms "+this.config.easing,this.sliderFrame.style[this.transformProperty]="translate3d("+-1*(this.currentSlide*(this.selectorWidth/this.perPage)+(this.drag.startX-this.drag.endX))+"px, 0, 0)")}},{key:"mousedownHandler",value:function(e){e.preventDefault(),e.stopPropagation(),this.pointerDown=!0,this.drag.startX=e.pageX}},{key:"mouseupHandler",value:function(e){e.stopPropagation(),this.pointerDown=!1,this.selector.style.cursor="-webkit-grab",this.sliderFrame.style.webkitTransition="all "+this.config.duration+"ms "+this.config.easing,this.sliderFrame.style.transition="all "+this.config.duration+"ms "+this.config.easing,this.drag.endX&&this.updateAfterDrag(),this.clearDrag()}},{key:"mousemoveHandler",value:function(e){e.preventDefault(),this.pointerDown&&(this.drag.endX=e.pageX,this.selector.style.cursor="-webkit-grabbing",this.sliderFrame.style.webkitTransition="all 0ms "+this.config.easing,this.sliderFrame.style.transition="all 0ms "+this.config.easing,this.sliderFrame.style[this.transformProperty]="translate3d("+-1*(this.currentSlide*(this.selectorWidth/this.perPage)+(this.drag.startX-this.drag.endX))+"px, 0, 0)")}},{key:"mouseleaveHandler",value:function(e){this.pointerDown&&(this.pointerDown=!1,this.selector.style.cursor="-webkit-grab",this.drag.endX=e.pageX,this.sliderFrame.style.webkitTransition="all "+this.config.duration+"ms "+this.config.easing,this.sliderFrame.style.transition="all "+this.config.duration+"ms "+this.config.easing,this.updateAfterDrag(),this.clearDrag())}},{key:"updateFrame",value:function(){this.sliderFrame=document.createElement("div"),this.sliderFrame.style.width=this.selectorWidth/this.perPage*this.innerElements.length+"px",this.sliderFrame.style.webkitTransition="all "+this.config.duration+"ms "+this.config.easing,this.sliderFrame.style.transition="all "+this.config.duration+"ms "+this.config.easing,this.config.draggable&&(this.selector.style.cursor="-webkit-grab");for(var e=document.createDocumentFragment(),t=0;t<this.innerElements.length;t++){var i=document.createElement("div");i.style.cssFloat="left",i.style.float="left",i.style.width=100/this.innerElements.length+"%",i.appendChild(this.innerElements[t]),e.appendChild(i)}this.sliderFrame.appendChild(e),this.selector.innerHTML="",this.selector.appendChild(this.sliderFrame),this.slideToCurrent()}},{key:"remove",value:function(e,t){if(e<0||e>=this.innerElements.length)throw new Error("Item to remove doesn't exist ðŸ˜­");this.innerElements.splice(e,1),this.currentSlide=e<=this.currentSlide?this.currentSlide-1:this.currentSlide,this.updateFrame(),t&&t.call(this)}},{key:"insert",value:function(e,t,i){if(t<0||t>this.innerElements.length+1)throw new Error("Unable to inset it at this index ðŸ˜­");if(-1!==this.innerElements.indexOf(e))throw new Error("The same item in a carousel? Really? Nope ðŸ˜­");this.innerElements.splice(t,0,e),this.currentSlide=t<=this.currentSlide?this.currentSlide+1:this.currentSlide,this.updateFrame(),i&&i.call(this)}},{key:"prepend",value:function(e,t){this.insert(e,0),t&&t.call(this)}},{key:"append",value:function(e,t){this.insert(e,this.innerElements.length+1),t&&t.call(this)}},{key:"destroy",value:function(){var e=arguments.length>0&&void 0!==arguments[0]&&arguments[0],t=arguments[1];if(window.removeEventListener("resize",this.resizeHandler),this.selector.style.cursor="auto",this.selector.removeEventListener("touchstart",this.touchstartHandler),this.selector.removeEventListener("touchend",this.touchendHandler),this.selector.removeEventListener("touchmove",this.touchmoveHandler),this.selector.removeEventListener("mousedown",this.mousedownHandler),this.selector.removeEventListener("mouseup",this.mouseupHandler),this.selector.removeEventListener("mouseleave",this.mouseleaveHandler),this.selector.removeEventListener("mousemove",this.mousemoveHandler),e){for(var i=document.createDocumentFragment(),s=0;s<this.innerElements.length;s++)i.appendChild(this.innerElements[s]);this.selector.innerHTML="",this.selector.appendChild(i),this.selector.removeAttribute("style")}t&&t.call(this)}}],[{key:"mergeSettings",value:function(e){var t={selector:".siema",duration:200,easing:"ease-out",perPage:1,startIndex:0,draggable:!0,threshold:20,loop:!1,onInit:function(){},onChange:function(){}},i=e;for(var s in i)t[s]=i[s];return t}},{key:"webkitOrNot",value:function(){return"string"==typeof document.documentElement.style.transform?"transform":"WebkitTransform"}}]),e}();t.default=o,e.exports=t.default}])});


  /*
  * Shows a toast
  * Usage:
  * site.toast.show('success', 'Saved!', true);
  * site.toast.show('failure', 'Error!', true);
  * site.toast.show('loading', 'Loading...', false);
  */
  site.toast = (function() {

    'use strict';

    return {

      version: '0.0.1',

      /**
       * Creates the toast
       */
      setup: function() {

        var current;

        current = document.createElement('div');
        current.setAttribute('class', 'site-toast');
        current.innerHTML = 'Sample Toast';

        // append toast
        document.body.appendChild(current);

        return current;

      },

      /**
       * Shows the toast
       */
      show: function(status, text, autoHide) {

        var current;

        current = document.querySelector('.site-toast');

        if(current == null) {
          current = toast.setup();
        }

        current.removeAttribute('success');
        current.removeAttribute('failure');
        current.removeAttribute('loading');

        current.setAttribute('active', '');

        // add success/failure
        if (status == 'success') {
          current.setAttribute('success', '');

            text = '<span>' + text + '</span>';
        }
        else if (status == 'failure') {
          current.setAttribute('failure', '');

          text = '<span>' + text + '</span>';
        }
        else if (status == 'loading') {
          current.setAttribute('loading', '');

          text = '<svg class="loading-icon" width="38" height="38" viewBox="0 0 38 38" xmlns="http://www.w3.org/2000/svg" stroke="#fff">' +
                    '<g fill="none" fill-rule="evenodd">' +
                      '<g transform="translate(1 1)" stroke-width="2">' +
                          '<circle stroke-opacity=".5" cx="18" cy="18" r="18"/>' +
                          '<path d="M36 18c0-9.94-8.06-18-18-18">' +
                              '<animateTransform' +
                                  'attributeName="transform"' +
                                  'type="rotate"' +
                                  'from="0 18 18"' +
                                  'to="360 18 18"' +
                                  'dur="1s"' +
                                  'repeatCount="indefinite"/>' +
                          '</path>' +
                      '</g>' +
                  '</g>' +
              '</svg><span>' + text + '</span>'
        }

        // set text
        current.innerHTML = text;

        // enable persistent messages
        if(autoHide == true) {
          setTimeout(function() {
            current.removeAttribute('active');
          }, 1000);

        }

      }

    }

  })();

  site.toast.setup();

  /**
   * Handles plugins functionality for Fixture
   *
   */
  site.plugins = (function() {

    'use strict';

    return {

      setup:function(){

        // handle toggles
        let toggles = document.querySelectorAll('[site-toggle-active]');

        for(let x=0; x<toggles.length; x++) {
          toggles[x].addEventListener('click', function(e) {
            let el = e.target;

            if(el.hasAttribute('site-toggle-active') == false) {
              el = el.parentNode;
            }

            if(el) {
              let selector = el.getAttribute('site-toggle-active');
              let target = document.querySelector(selector);

              if(target) {
                if(target.hasAttribute('active')) {
                  target.removeAttribute('active');
                }
                else {
                  target.setAttribute('active', '');
                }
              }
            }

          });
        }

      },

      /**
       * Find the parent by a selector ref: http://stackoverflow.com/questions/14234560/javascript-how-to-get-parent-element-by-selector
       * @param {Array} config.sortable
       */
      findParentBySelector: function(elm, selector) {
        var all, cur;

        all = document.querySelectorAll(selector);
        cur = elm.parentNode;

        while (cur && !site.plugins.collectionHas(all, cur)) { //keep going up until you find a match
          cur = cur.parentNode; //go up
        }
        return cur; //will return null if not found
      },

      /**
       * Gets the query string paramger
       * @param {String} name
       * @param {String} url
       */
      getQueryStringParam: function(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
      },

      /**
       * Helper for findParentBySelecotr
       * @param {Array} config.sortable
       */
      collectionHas: function(a, b) { //helper function (see below)
        var i, len;

        len = a.length;

        for (i = 0; i < len; i += 1) {
          if (a[i] == b) {
            return true;
          }
        }
        return false;
      }

    }

  })();

  site.plugins.setup();

  /*
  * Handles forms for the site
  */
  site.form = (function() {

    'use strict';

    return {

      version: '0.0.1',
      siteId: '',
      formSubmitApiUrl: '',

      /**
       * Creates the lightbox
       */
      setup: function() {

        var form, forms, x, status, id, success, error, holder, siteKey, submit;

        // setup [site-form]
        forms = document.querySelectorAll('[site-widget=form]');

        // setup form
        if(forms.length > 0) {

          fetch('data/site.json')
            .then((resp) => resp.json())
            .then(function(data) {
              
                site.form.siteId = data.id;
                site.form.formSubmitApiUrl = data.formSubmitApiUrl;

              });

        }

        // setup form
        for(x=0; x<forms.length; x++) {
          forms[x].addEventListener('submit', site.form.submitForm);
        }

      },

      /**
       * checks for errors prior to submitting the form
       *
       */
      submitForm: function(e) {

        // pre-fill values
        var successMessage = 'Form submitted successfully!',
          errorMessage = 'There was a problem submitting your form.  Please try again.',
          destination = '',
          el = null;

        site.toast.show('loading', 'Submitting form...', false);

        e.preventDefault();

        var form, groups, data = [], x, hasError = false;

        // get reference to form
        form = e.target;

        // get success message
        el = form.querySelector('.success-message');

        if(el) {
          if(el.value != '') {
            successMessage = el.value;
          }
        }

        // get error message
        el = form.querySelector('.error-message');

        if(el) {
          if(el.value != '') {
            errorMessage = el.value;
          }
        }

        // get destination
        el = form.querySelector('.destination');

        if(el) {
          if(el.value != '') {
            destination = el.value;
          }
        }

        // select all inputs in the local DOM
        groups = form.querySelectorAll('.form-group');
        
        // walk through inputs
        for(x=0; x<groups.length; x++) {

          // get name, id, type
          let label = groups[x].querySelector('label') || '';
          let value = ''
          let name = '';

          // get label content
          if(label != '') {
            label = label.innerHTML;
          } 
          
          let input = groups[x].querySelector('input');
          let textarea = groups[x].querySelector('textarea');
          let select = groups[x].querySelector('select');
          let required = false;

          
          if(input) {
            value = input.value;
            name = input.getAttribute('name') || '';


            if(input.hasAttribute('required')) {
              required = true;
            }
          }

          if(textarea) {
            value = textarea.value;
            name = textarea.getAttribute('name') || '';

            if(textarea.hasAttribute('required')) {
              required = true;
            }
          }

          if(select) {
            value = select.value;
            name = select.getAttribute('name') || '';

            if(select.hasAttribute('required')) {
              required = true;
            }
          }

          // push data
          data.push({
            label: label,
            name: name,
            value: value
          });

        }

        // add submitted from
        data.push({
          label: 'Submitted From',
          name: 'submitted-from',
          value: window.location.href
        });

        // add date
        data.push({
          label: 'Submitted On',
          name: 'submitted-on',
          value: new Date().toLocaleDateString() + ' ' + new Date().toLocaleTimeString()
        });

        // add submitted from
        data.push({
          label: 'Site ID',
          name: 'siteId',
          value: site.form.siteId
        });

        // exit if error
        if(hasError == true) {
          // stop processing
          e.preventDefault();
          return false;
        }
        else {
          
          // post form
          var request = new XMLHttpRequest();
          request.open('POST', site.form.formSubmitApiUrl, true);
          request.setRequestHeader('Content-Type', 'application/json');
          request.send(JSON.stringify(data));

          request.onload = function() {
            if (request.status >= 200 && request.status < 400) {
              var resp = request.responseText;
              site.toast.show('success', successMessage, true);
              site.form.clearForm(e.target);

              console.log('[form] success');

              // handle destination
              if(destination != '') {
                location.href = destination;
              }

            } else {
              site.toast.show('error', errorMessage, true);
            }
          };
          
          request.onerror = function() {
            site.toast.show('error', errorMessage, true);
          };

          // stop processing
          e.preventDefault();
          return false;

        }

        

        return true;

      },

      /**
       * clears the form a form
       *
       */
      clearForm:function(form) {

        var els, x;

        // remove .has-error
        els = form.querySelectorAll('.has-error');

        for(x=0; x<els.length; x++){
          els[x].classList.remove('has-error');
        }

        // clear text fields
        els = form.querySelectorAll('input[type=text]');

        for(x=0; x<els.length; x++){
          els[x].value = '';
        }

        // clear text areas
        els = form.querySelectorAll('textarea');

        for(x=0; x<els.length; x++){
          els[x].value = '';
        }

        // reset selects
        els = form.querySelectorAll('select');

        for(x=0; x<els.length; x++){
          els[x].selectedIndex = 0;
        }

      }

    }

  })();

  site.form.setup();


  /*
  * Shows a lightbox
  * Usage:
  * <a href="path/to/image.png" title="Caption" site-lightbox><img src="path/to/thumb.png"></a>
  */
  site.lightbox = (function() {

    'use strict';

    return {

      version: '0.0.1',

      /**
       * Creates the lightbox
       */
      setup: function() {

        var lb, close, els, el, img, p, x;

        // create lighbox
        lb = document.createElement('div');
        lb.setAttribute('class', 'site-lightbox');

        lb.innerHTML = '<div class="site-lightbox-close" on-click="close">' +
            '<svg xmlns="http://www.w3.org/2000/svg" fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24">' +
              '<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>' +
              '<path d="M0 0h24v24H0z" fill="none"/>' +
            '</svg>' +
          '</div>' +
          '<div class="site-lightbox-body"><img><p>Sample Caption</p></div>';

        // append lightbox
        document.body.appendChild(lb);

        // handle close
        close = document.querySelector('.site-lightbox-close');

        close.addEventListener('click', function(e) {
          lb.removeAttribute('visible');
        });

        // get lightbox items
        els = document.querySelectorAll('[site-lightbox]');

        for(x=0; x<els.length; x++) {

          els[x].addEventListener('click', function(e) {

            e.preventDefault();

            el = e.target;

            if(el.nodeName === 'IMG') {
              el = site.plugins.findParentBySelector(el, '[site-lightbox]');
            }

            // show the lightbox
            lb.setAttribute('visible', '');

            // set image
            img = lb.querySelector('img');
            img.src = el.getAttribute('href');

            // set caption
            p = lb.querySelector('p');
            p.innerHTML = el.getAttribute('title');

          });

        }

      },

    }

  })();

  site.lightbox.setup();
  
  /*
   * Handles product images
   * Usage:
   */
  site.productImages = (function() {
    
    'use strict';

    return {

      version: '0.0.1',

      /**
       * Creates the productImages
       */
      setup: function() {
      
        var el, els, x, img;
        
        els = document.querySelectorAll('[site-product-secondary-image]');
        
        for(x=0; x<els.length; x++) {
          els[x].addEventListener('click', function(e) {
          
            var el = e.target, 
                container = el.closest('.site-product-images'),
                main = container.querySelector('[site-lightbox]');
                
            if(main && el) {
              img = main.querySelector('img');
              
              console.log(img);
              
              if(img) {
                main.setAttribute('href', el.parentNode.getAttribute('href') || '');
                main.setAttribute('title', el.parentNode.getAttribute('title') || '');
                img.setAttribute('src', el.getAttribute('src'));
              }
            
              
            }
  
            e.preventDefault();
            return false;
            
          });
        }
        // end for
      
      }
      
    }
  
  })();
  
  site.productImages.setup();
  
  /*
   * Handles product sku selection
   * Usage:
   */
  site.productSkus = (function() {
    
    'use strict';

    return {

      version: '0.0.1',

      /**
       * Creates the productSku selection
       */
      setup: function() {
      
        var el, els, x, img, y, z;
        
        els = document.querySelectorAll('.product-select-sku-item');
        
    
        for(x=0; x<els.length; x++) {
        
          if(x==0) {
            els[x].setAttribute('active', '');
          }

          els[x].addEventListener('click', function(e) {
          
            var el = e.target, 
                container = el.closest('[site-widget="product-buttons"]'),
                buttons = container.querySelectorAll('.purchase-button');
                
            // toggle active
            for(z=0; z<els.length; z++) {
              els[z].removeAttribute('active');
            }

            el.setAttribute('active', '');

            for(y=0; y<buttons.length; y++) {
              buttons[y].setAttribute('data-sku', el.getAttribute('data-sku'));
              buttons[y].setAttribute('data-sku-name', el.getAttribute('data-sku-name'));
              buttons[y].setAttribute('data-price', el.getAttribute('data-price'));
              buttons[y].setAttribute('data-image', el.getAttribute('data-image'));
            }
  
            e.preventDefault();
            return false;
            
          });
          // end click
         
        }
        // end for
      
      }
      // end setup
      
    }
  
  })();
  
  site.productSkus.setup();
  
  
  /*
  * Shows a searchbox
  * Usage:
  * <a site-search></a>
  */
  site.searchbox = (function() {

    'use strict';

    return {

      version: '0.0.1',

      /**
       * Creates the lightbox
       */
      setup: function() {

        var sb, close, els, el, form, img, p, x, y, term, results, ext, data;

        // create lighbox
        sb = document.createElement('div');
        sb.setAttribute('class', 'site-searchbox');

        sb.innerHTML = '<div class="site-searchbox-close" on-click="close">' +
            '<svg xmlns="http://www.w3.org/2000/svg" fill="#000000" height="24" viewBox="0 0 24 24" width="24">' +
              '<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>' +
              '<path d="M0 0h24v24H0z" fill="none"/>' +
            '</svg>' +
          '</div>' +
          '<form class="site-searchbox-form">' +
            '<input type="text" placeholder="Search">' +
            '<div class="site-search-results"></div>' +
          '</form>';

        // append lightbox
        document.body.appendChild(sb);

        // handle close
        close = document.querySelector('.site-searchbox-close');

        if(close !== null) {

          close.addEventListener('click', function(e) {
            sb.removeAttribute('visible');
          });

        }

        // get lightbox items
        els = document.querySelectorAll('[site-search], .site-search');

        for(x=0; x<els.length; x++) {

          els[x].addEventListener('click', function(e) {

            e.preventDefault();

            el = e.target;

            if(el.nodeName === 'IMG' || el.nodeName === 'SVG') {
              el = site.plugins.findParentBySelector(el, '[site-search]');

            }

            // show the lightbox
            sb.setAttribute('visible', '');


          });

        }

        // handle submit
        form = document.querySelector('.site-searchbox-form');

        if(form !== null) {

          form.addEventListener('submit', function(e) {

            e.preventDefault();

            term = form.querySelector('input[type=text]').value;
            results = document.querySelector('.site-search-results');

            // clear existing results
            results.innerHTML = '';

            // submit form
            var xhr = new XMLHttpRequest();

            // set URI
            var uri = 'data/pages.json';

            xhr.open('GET', encodeURI(uri));
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function() {

              if(xhr.status === 200){

                  // get data
                  data = JSON.parse(xhr.responseText);

                  ext = '';

                  // set class for data
                  for(x in data){

                    // pages are stored in objects
                    if(typeof(data[x]) == 'object'){

                      // check for results in non-includeOnly pages

                      // this is what will be returned
                      var result = {
                        name: data[x]['name'],
                        url: data[x]['url'],
                        description: data[x]['description']
                      }

                      // walk through data[x]
                      for(y in data[x]){

                        var text = data[x].text.toLowerCase();

                        // searh for the term
                        if(text.search(new RegExp(term.toLowerCase(), 'i')) != -1){

                          results.innerHTML += '<div class="site-search-result"><h2><a href="' + result.url + '">' + result.name + '</a></h2>' +
                                              '<small><a href="' + result.url + '">' + result.url + '</a></small>' +
                                              '<p>' + result.description + '</p></div>';


                          break;
                        }

                      }

                    }

                  }

                }

                else if(xhr.status !== 200){
                  console.log('[site.error] site-search component: failed post, xhr.status='+xhr.status);
                }
              };

              // send xhr
              xhr.send();



            });

        }


      }

    }

  })();

  site.searchbox.setup();

  /*
    * Slideshow
    * @author matt@matthewsmith.com
    * @ref: https://fixture.app
    */
  class Slideshow {
    
    constructor(el) {
      
      // holds reference to the parent element of the slideshow
      this.el = el;

      // set interval
      this.interval = null;
      
      // get container
      this.container = el.querySelector('.site-slideshow-container');
      
      // get menu
      this.menu = el.querySelector('.site-slideshow-menu');
      
      // set context
      var context = this;
      
      var duration = 200;
      
      if(this.el.hasAttribute('data-duration')) {
        duration = parseInt(context.el.getAttribute('data-duration'));
      }

      
      if(this.container) {

        // clear interval on interaction
        this.container.addEventListener('click', function(e) {
        
          if(context.interval) {
            console.log('[debug] clear interval');
            clearInterval(context.interval);
          }
        
        });

      }
    
      // holds reference to siema
      this.siema = new Siema({
        selector: this.container,
        duration: duration,
        easing: 'ease-out',
        perPage: 1,
        startIndex: 0,
        draggable: true,
        threshold: 20,
        loop: false,
        onInit: () => {
          if(context.el.hasAttribute('data-autoplay')) {
          
            var autoplay = parseInt(context.el.getAttribute('data-autoplay'));
            
            context.interval = setInterval(function() {
              context.siema.next();
            }, autoplay);
          }
        },
        onChange: () => {
          context.setSlideIndicator(context.siema.currentSlide);
        }
      });
      
      // setup jump points
      this.links = this.menu.querySelectorAll('a');
      
      for(var x=0; x<this.links.length; x++) {
        
        this.links[x].addEventListener('click', function(e) {
        
          context.gotoSlide(e.target.getAttribute('data-index'));
        
        });
        
      }
              
    }
    
    /**
     * Goes to specified slide
     */
    gotoSlide(i) {
  
      var els;
  
      this.siema.goTo(i);
  
      this.setSlideIndicator(i);
      
    }
    
    /*
      * Sets the slide indicator
      * int i
      */
    setSlideIndicator(i) {
    
      var els, x;
      
      // clear active
      els = this.menu.querySelectorAll('a');
  
      for(x=0; x<els.length; x++) {
        els[x].removeAttribute('active');
      }
  
      // set active
      els[i].setAttribute('active', '');
      
    }
      
  }
  
  /*
    * Slideshows
    * @author matt@matthewsmith.com
    * @ref: https://fixture.app
    */
  site.slideshow = (function() {

        'use strict';
    
          return {
    
              setup:function() {
    
                // setup .site-slideshow
                let slideshows = document.querySelectorAll('.site-slideshow'), x=0;
    
                 // setup form
                for(x=0; x<slideshows.length; x++) {
                
                    new Slideshow(slideshows[x]);
    
                }
    
              }
        }
    
    })();;
    
    site.slideshow.setup();

    // set links to current page active
    var links = document.querySelectorAll('a');
    var currentPage = document.querySelector('body').getAttribute('data-current-page') || '';
    
    for(x=0; x<links.length; x++) {
      if(links[x].getAttribute('href') == currentPage) {
        links[x].classList.add('active');
      }
    }

}