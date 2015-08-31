<%
//----------------------------------------------------------------------
// <copyright file="Default.aspx" company="Accusoft Corporation">
// Copyright© 1996-2014 Accusoft Corporation.  All rights reserved.
// </copyright>
//----------------------------------------------------------------------
%>
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PCC .NET C# Sample Home</title>
        <link rel="stylesheet" href="splashPage.css" type="text/css" /> 
            <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script> window.jQuery || document.write('<script src="sample-assets/js/jquery-1.10.2.min.js"><\/script>');</script>
<script>
 
 
    (function () {
        window.request = function (obj, done) {
            obj = obj || {};
            obj.url = obj.url || '#';
            obj.method = obj.method || 'GET';
            obj.async = obj.async || true;
            obj.body = obj.body || null;

            var ajax = (window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");

            ajax.onreadystatechange = function () {
                if (ajax.readyState === 4 && ajax.status === 200) done(ajax.responseText);
            };

            ajax.open(obj.method, obj.url, obj.async);
            ajax.send((obj.method === "POST") ? obj.body : null);
        };
    }());

 
</script>
    </head>
    <body>
<div class="bg-skew"></div>
<div class="bg-colorbars">
	<div class="bg-colorbar primary-dark-bg"></div>
	<div class="bg-colorbar accent-bg-orange"></div>
	<div class="bg-colorbar accent-bg-faded-orange"></div>
	<div class="bg-colorbar accent-bg-blue"></div>
	<div class="bg-colorbar accent-bg-orange"></div>
</div>
<div class="container">
  <div class="masthead">
    <div class="logo">
      <a href="http://www.accusoft.com">
        <img src="sample-assets/img/accusoft_logo.png" width="200" height="46" alt="Accusoft">
      </a>
    </div>
    <div class="header">
      <h1>PCC Annotation List Demo</h1>
    </div>
  </div>
  <div class="main">
    <div class="viewer-picker">
      <h2>Select a Persona</h2>
      <ul class="viewer-list">
        <li><button data-persona-select='admin-persona' class="btn-large" id="select-admin-persona">Admin Persona</button></li>
        <li><button data-persona-select='user1-persona' class="btn-large" id="select-user1-persona">User One</button></li>
        <li><button data-persona-select='user2-persona' class="btn-large" id="select-user2-persona">User Two</button></li>
        <!-- <li><button data-viewer-select='book-reader' class="btn-large" id="select-book-reader">Book Reader</button></li> -->
      </ul>
    </div>
      <div class="persona-description">
          <p id="descriptions">
          </p>
      </div>
    <div class="document-picker">
      <h2>Select a Document</h2>
      <p id="sampleTitleText">Choose a document to load in the viewer from the list or drag one from your desktop in the drop zone below.</p>
      <ul class="file-list">
        <li><a data-document='WordDemoSample.doc'>Word Document</a></li>
        <li><a data-document='PdfDemoSample.pdf'>PDF Document</a></li>
        <li><a data-document='DxfDemoSample.dxf'>AutoCAD</a></li>
        <li><a data-document='TiffDemoSample.tif'>Multi-Page TIFF</a></li>
        <li><a data-document='JPegDemoSample.jpg'>JPEG</a></li>
        <li><button id="upload">Open File</button></li>
      </ul>
    </div>
    <div class="document-drop">

      <h2>Upload a Document</h2>
      <div class="dropp-zone">
            <div id="drop_zone" class="modal">
                <div id="dragdropText">Drag and Drop file here</div>
                <div id="clickText" >or click to select a file</div>
               <button id="dz_skip">Skip</button>
            </div>
            </div>
        </div>
    </div>
  </div>
<!-- </div> -->

</body>

    <script>
        var personas = {
            'admin-persona': '/full-viewer-sample/Default.aspx?user=admin',
            'user1-persona': '/full-viewer-sample/Default.aspx?user=user1',
            'user2-persona': '/full-viewer-sample/Default.aspx?user=user2'
        };

        var descriptions = {
            'admin-persona': 'The admin persona can view all other layers and will automatically load all layers for review, but can only modify their own layer.',
            'user1-persona': 'A generic persona that can only view and modify their own layer and the admin\'s comments on their layer. Will not load all layers for review.',
            'user2-persona': 'A second generic persona that can only view and modify their own layer and the admin\'s comments on their layer. Will not load all layers for review.'
        }

        var selectedPersona;

        $(document).ready(function() {
            $("[data-persona-select]").click(function(e) {
                var persona = $(e.target).data('persona-select');
                updateSelectedViewer(persona);
            });
        });

        function updateSelectedViewer(persona) {
            selectedPersona = personas[persona];

            $("a[data-document]").each(function(index, element) {
                var document = $(element).data("document"),
                    url = selectedPersona + "&document=" + document;

                $(element).attr('href', url);
            });

            window.localStorage.setItem('splash-page-sample-viewer', persona);

            // update appearance of buttons
            $("[data-persona-select]").removeClass('selected');
            $("[data-persona-select=" + persona + "]").addClass('selected');

            // update text
            $('#descriptions').text(descriptions[persona]);
        }

        var initialPersona = 'admin-persona';
        if (typeof window.localStorage !== 'undefined') {
            // attempt to read the last used viewer from local storage
            var storedViewer = window.localStorage.getItem('splash-page-sample-viewer');
            if (storedViewer && personas[storedViewer]) {
                initialPersona = storedViewer;
            }
        }
        updateSelectedViewer(initialPersona);

        (function () {
            var DropZone = function (opts) {
                //save scope
                var that = this;

                opts = opts || {};
                //TODO opts.url is required
                opts.done = opts.done || function () { };
                opts.id = opts.id || "drop_zone";
                opts.fallback = !!opts.fallback;

                this.opts = opts;

                //get dropzone
                this.DOM = document.getElementById(opts.id);

                //fallback event listener needed for older IE
                addEvent(that.DOM, "dragover", handleDragOver);
                addEvent(that.DOM, "drop", function (evt) { handleFileSelect(evt, that.opts); });

                //add show/hide ability
                this.show = function () { overlay.style.display = ''; /* removes inline style */ };
                this.hide = function () { overlay.style.display = 'none'; };
                //make sure this gets retriggered when dragging new file
                var overlay = document.querySelector(".dropp-zone");
                if (document.documentMode < 10) {
                    $("#dragdropText").text("Click to Upload document");
                    $("#clickText").text("or use 'skip' button to view default document.");
                    $("#sampleTitleText").text("Choose a document to load in the viewer from the list or upload one from your desktop in the upload zone below.");
                }
                var leaveTimer;
                var onLeave = function () {
                    //execute leave only if not followed by another enter
                    leaveTimer = setTimeout(function () {
                        that.hide();
                    }, 50);
                };
                var onEnter = function () {
                    //wait for leave to execute first
                    setTimeout(function () {
                        clearTimeout(leaveTimer);
                        that.show();
                    }, 5);
                };

                addEvent(document, "dragenter", onEnter);
                addEvent(document, "dragleave", onLeave);

                //manual select for a file upload
                var manualUpload = function () {
                    //create dummy file input
                    var file = document.createElement("input");
                    file.type = "file";

                    //modern browsers
                    if (window.FormData) {
                        //fix fallback for IE
                        file.style.display = "none";

                        //add file change handler
                        addEvent(file, "change", function (evt) {
                            handleFileSelect(evt, that.opts, file);
                        });

                        document.body.appendChild(file);

                        //activate file select
                        file.click();

                        document.body.removeChild(file);
                    }
                    //IE8/9
                    else {
                        //fallback to upload form
                        handleFileIE(file, opts, that.hide);
                    }
                };

                //add option to manually trigger upload
                this.upload = manualUpload;

                //fallback for native file selector
                if (opts.fallback) addEvent(that.DOM, 'click', manualUpload, false); /* */
            };

            function handleFileSelect(evt, opts, file) {
                evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;
                evt.preventDefault ? evt.preventDefault() : evt.returnValue = false;
                if (window.FormData) {
                var formData = new FormData();
                var files = (evt.dataTransfer) ? evt.dataTransfer.files : evt.target.files;
                formData.append("theFile", files[0]);

                sendForm(formData, opts);
            }
            }

            function sendForm(formData, opts) {
                //TODO better error handling
                var xhr = window.myReq = new XMLHttpRequest();
                xhr.open('POST', opts.url, true);
                xhr.onload = function (ev) {
                    opts.done(null, ev.target.response);
                };
                xhr.send(formData);
            }
            var uploadIFrame, overlay;
            //IE8/9 FormData fallback
            function handleFileIE(fileDOM, opts, hideFunction) {
                hideFunction();

                //Opening an iframe to make the request to
                if (!uploadIFrame) {
                    uploadIFrame = document.createElement('iframe');
                    uploadIFrame.id = 'IEframe';
                    uploadIFrame.name = 'IEframe';
                    uploadIFrame.style.display = 'none';

                    document.body.appendChild(uploadIFrame);

                    //create new modal
                    overlay = document.createElement('div');
                    overlay.className = 'dropp-zone';
                    var vc = document.createElement('div');
                    vc.className = 'vertical-center';
                    var modal = document.createElement('div');
                    modal.className = 'modal';

                    //create a new form
                    var form = document.createElement("form");
                    form.method = 'POST';
                    form.action = opts.url + '?f=jsonp&userAgent=' + escape(navigator.userAgent);
                    form.target = 'IEframe';
                    //For IE8 you need both. Obnoxious
                    form.encoding = form.enctype = "multipart/form-data";

                    //create file input element
                    fileDOM.id = "theFile";
                    fileDOM.name = "theFile";

                    //create Upload (form submit) button
                    var submit = document.createElement('button');
                    submit.value = 'Upload';
                    submit.innerHTML = 'Upload';

                    //create Skip button
                    var cancel = document.createElement('button');
                    cancel.innerHTML = 'Skip';
                    addEvent(cancel, 'click', function (evt) {
                        evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;
                        evt.preventDefault ? evt.preventDefault() : evt.returnValue = false;

                        cleanUp();

                        //execute callback with 'skip' error
                        opts.done('skip');
                    });

                    //nest all DOM elements
                    form.appendChild(fileDOM);
                    form.appendChild(submit);
                    form.appendChild(cancel);
                    modal.appendChild(form);

                    vc.appendChild(modal);
                    overlay.appendChild(vc);
                    document.body.appendChild(overlay);
                }

                function cleanUp() {
                    document.body.removeChild(uploadIFrame);
                    document.body.removeChild(overlay);
                }

                //add iFrame onload event
                addEvent(uploadIFrame, 'load', function () {
                    var content = uploadIFrame.contentWindow.res;
                    //console.log(content);
                    if (content && content.filename && content.filename !== "") {
                        //execute original callback
                        window.location.href = selectedViewerPath + "?document=" + content.filename;
                        opts.done(null, content);

                        cleanUp();
                    }
                });
            }

            //helper -- makes dragging a bit prettier
            function handleDragOver(evt) {
                evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;
                evt.preventDefault ? evt.preventDefault() : evt.returnValue = false;

                evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
            }

            //helper -- event listener fallback for IE8
            var addEvent = function addEvent(obj, event, handler) {
                if (obj.addEventListener) obj.addEventListener(event, handler, false);
                else if (obj.attachEvent) obj.attachEvent('on' + event, handler);
            };
            var removeEvent = function (obj, event, handler) {
                if (obj.removeEventListener) obj.removeEventListener(event, handler, false);
                else if (obj.detachEvent) obj.detachEvent('on' + event, handler);
            };

            //expose to window
            window.DropZone = DropZone;
        } ());
        (function () {
            //cross-browser event listeners
            var addEvent = function addEvent(obj, event, handler) {
                if (obj.addEventListener) obj.addEventListener(event, handler, false);
                else if (obj.attachEvent) obj.attachEvent('on' + event, handler);
            };
            var removeEvent = function (obj, event, handler) {
                if (obj.removeEventListener) obj.removeEventListener(event, handler, false);
                else if (obj.detachEvent) obj.detachEvent('on' + event, handler);
            };

            var dropzoneError = function (err) {
                switch (err) {
                    case 'skip':
                        window.location.href = selectedViewerPath + "?document=WordDemoSample.doc";
                        break;
                    default:
                        console.log('upload error', err);
                }
            };

            var fileUploadDone = function (err, resp) {
                if (err) {
                    dropzoneError(err);
                    return;
                }

                //TODO make sure JSON.parse works
                var data = (typeof resp === 'string') ? JSON.parse(resp) : resp;

                //save globals
                options = data.options;
                common = data.common;
                //vsID = data.viewingSessionId;
                var fileName = data.filename;


                //hide overlay
                dropzone && dropzone.hide();

                window.location.href = selectedViewerPath + "?document=" + fileName;
            };

            //create viewing session
            var createSessionByName = function (name) {
                request({
                    url: "DocUpload.ashx?document=" + name
                }, function (resp) {
                    fileUploadDone(null, resp);
                });
            };

            //create initialization dropzone
            var dropzone = new DropZone({
                url: 'DocUpload.ashx',
                fallback: true,
                done: fileUploadDone
            });

            //skip option for dropzone
            addEvent(document.getElementById('dz_skip'), 'click', function (ev) {
                //IE8 compatible cancel of event
                ev.stopPropagation ? ev.stopPropagation() : ev.cancelBubble = true;
                ev.preventDefault ? ev.preventDefault() : ev.returnValue = false;

                window.location.href = selectedViewerPath + "?document=WordDemoSample.doc";
            });

            document.querySelector('#upload').onclick = function () {
                dropzone.upload();
            };
        }());
    </script>
</html>
