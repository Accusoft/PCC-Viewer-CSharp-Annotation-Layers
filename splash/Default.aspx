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
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PrizmDoc .NET C# Sample Home</title>
        <link href="http://fonts.googleapis.com/css?family=Raleway:300,400" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="assets/css/splash.css" type="text/css" />
        <link rel="stylesheet" href="assets/css/fontello.css" type="text/css" />
        <link rel="icon" type="image/png" href="assets/img/favicon.ico" />
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script> window.jQuery || document.write('<script src="assets/js/jquery-1.10.2.min.js"><\/script>');</script>
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
        <header class="page-header" role="banner">
            <div class="container">
                <div class="branding">
                    <div class="logo">
                        <a href="https://www.accusoft.com">
                            <img src="assets/img/accusoft_logo.png" alt="Accusoft">
                        </a>
                    </div>
                </div>
                <div class="product-name">
                    <h1>PrizmDoc</h1>
                </div>
            </div>
        </header>
        <div class="title-bar">
            <div class="container">
                <h2>PrizmDoc <span>Annotation List Demo</span></h2>
            </div>
        </div>
        <div class="choose-viewer">
            <div class="container">
                <h3>Select a Persona</h3>
                <div class="control-wrapper">
                    <div class="segmented-control">
                        <button type="button" id="select-admin-persona" data-persona-select="admin-persona" class="selected">
                            <i class="icon-ok-circled"></i>
                            Admin Persona
                        </button>
                        <button type="button" id="select-user1-persona" data-persona-select="user1-persona">
                            <i class="icon-ok-circled"></i>
                            User One
                        </button>
                        <button type="button" id="select-user2-persona" data-persona-select="user2-persona" >
                            <i class="icon-ok-circled"></i>
                            User Two
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
          <div class="main">
            <div class="viewer-picker">
              <div class="choose-document">
                  <p id="descriptions">
                  </p>
              </div>
            <div class="choose-document">
                    <h3>select a document</h3>
                    <div class="instructions">       
                        <p><em>Choose a document to load in the viewer from the list or drag one from your desktop in the drop zone below.</em></p>
                    </div>
                    <div class="container">
                        <ul class="document-list">
                            <li><a data-document="WordDemoSample.doc">Word Document</a></li>
							<li><a data-document="ExcelDemoSample.xlsx">Excel Document</a></li>
							<li><a data-document="PdfDemoSample.pdf">PDF Document</a></li>
							<li><a data-document="DxfDemoSample.dxf">AutoCAD</a></li>
							<li><a data-document="TiffDemoSample.tif">Multi-Page TIFF</a></li>
							<li><a data-document="JPegDemoSample.jpg">JPEG</a></li>
							<li><a data-document="EmailDemoSample.eml">Email</a></li>
                        </ul>
                        <div class="upload-zone">
                            <h3>upload a document</h3>
                            <div class="upload-button">
                                <button class="btn" id="upload">Upload</button></a>
                            </div>                    
                            <div class="drop-zone" id="drop_zone">
                                <p><span id="dragdropText">Drag and drop a file here</span>
                                <br> 
                                <span id="clickText">or click to select a file</span></p>
                                <button class="btn btn-small" id="dz_skip">Skip</button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </body>

    <script>
        var personas = {
            'admin-persona': '../full-viewer-sample/Default.aspx?user=admin',
            'user1-persona': '../full-viewer-sample/Default.aspx?user=user1',
            'user2-persona': '../full-viewer-sample/Default.aspx?user=user2'
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
                updateSelectedPersona(persona);
            });
        });

        function updateSelectedPersona(persona) {
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
        updateSelectedPersona(initialPersona);
    </script>
    <script type="text/javascript" src="assets/js/splash-config.js"></script>
    <script type="text/javascript" src="assets/js/main-splash.js"></script>
</html>
