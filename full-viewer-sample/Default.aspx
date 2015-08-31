<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%@ Import Namespace="PccViewer.WebTier.Core" %>
<%        
    // Create a ViewingSession based on the document defined in the query parameter
    // Example: ?document=sample.doc
    string viewingSessionId = string.Empty;
    string originalDocumentName = string.Empty;

    string documentQueryParameter = string.Empty;
	string layerID = string.Empty;
    bool isAdmin = false;

    if (Request.QueryString["document"] == null)
    {
        documentQueryParameter = "PdfDemoSample.pdf";
    }
    else
    {
        documentQueryParameter = Request.QueryString["document"];
    }
	
	 if (Request.QueryString["user"] != null)
    {
        PccViewer.WebTier.Core.User.setName(Request.QueryString["user"]);
    }
    else
    {
        // In a real application we would take some other action. 
        // For the demo's sake, we'll assume user1 as defined in the global User.name
    }

    // Check if user is admin
    if (PccViewer.WebTier.Core.User.name == "admin")
    {
        isAdmin = true;
    }

    originalDocumentName = documentQueryParameter;

    CreateSession createSession = new CreateSession();
    viewingSessionId = createSession.fromDocumentName(originalDocumentName); 
    
    // markupLayers contains a list of all valid markup files for the currently viewed document
    // We will iterate over this 
    MarkupLayers markupLayers = new MarkupLayers();
    List<Dictionary<string, object>> layers = markupLayers.getLayers(viewingSessionId);

    // Find this user persona's layer
    for (int i = 0; i < layers.Count; i++)
    {
        if (layers[i]["name"].ToString() == PccViewer.WebTier.Core.User.name)
        {
            layerID = layers[i]["layerRecordId"].ToString();
        }
    }

    // If the current user hasn't created a layer for this document we have  to use the current layer ID
    // and edit the layer name as soon as the viewer is initialized
%>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    
    <title>PCC HTML5 .NET C# Sample</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon" />

    <link rel="stylesheet" href="viewer-assets/css/normalize.min.css">
    <link rel="stylesheet" href="viewer-assets/css/viewercontrol.css">
    <link rel="stylesheet" href="viewer-assets/css/viewer.css">

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="viewer-assets/js/jquery-1.10.2.min.js"><\/script>');</script>
    <script src="viewer-assets/js/underscore.min.js"></script>
    <script src="viewer-assets/js/jquery.hotkeys.min.js"></script>

    <!--[if lt IE 9]>
        <link rel="stylesheet" href="viewer-assets/css/legacy.css">
        <script src="viewer-assets/js/html5shiv.js"></script>
    <![endif]-->

    <script src="//pcc-assets.accusoft.com/v10.3/js/viewercontrol.js"></script>
    <script src="//pcc-assets.accusoft.com/v10.3/js/viewer.js"></script>
</head>
<body>
    <div id="viewer1"></div>
    
    <div id="attachments" style="display:none;">
        <b>Attachments:</b>
        <p id="attachmentList">
        </p>
    </div>
       
    <script type="text/javascript">
        var viewerControl = '';
        var viewingSessionId = '<%=HttpUtility.JavaScriptStringEncode(viewingSessionId)%>';
        var languageJson = '<%=languageJson%>';
        var languageItems = jQuery.parseJSON(languageJson);
        var htmlTemplates = <%=htmlTemplates%>;
        var searchTerms = <%=searchJson%>;
        var redactionReasons = <%=redactionReasons%>;
        var originalDocumentName = '<%=originalDocumentName%>';
        var layerId = '<%=layerID%>';
        var loadAllLayers = <%=isAdmin.ToString().ToLower()%>;

        var pluginOptions = {
            documentID: viewingSessionId,
            language: languageItems,
            
            annotationsMode: "LayeredAnnotations",
            documentDisplayName: originalDocumentName,
			imageHandlerUrl: "viewer-webtier/pcc.ashx",
            immediateActionMenuMode: "hover",
            predefinedSearch: searchTerms,
            template: htmlTemplates,
            redactionReasons: redactionReasons,
			signatureCategories: "Signature,Initials,Title",
			resourcePath: "viewer-assets/img",
            uiElements: {
                download: true,
                fullScreenOnInit: true,
                advancedSearch:true
            },
            editableMarkupLayerSource: "LayerRecordId",
            lockEditableMarkupLayer: true,
            autoLoadAllLayers: loadAllLayers,
            editableMarkupLayerValue: layerId
        };
        
        function processAttachments() {
            // The following javascript will process any attachments for the
            // email message document types (.EML and .MSG).
            
            var countOfAttachmentsRequests = 0;

            function receiveAttachments (data, textStatus, jqXHR) {
                if (data == null || data.status != 'complete') {
                    // The request is not complete yet, try again after a short delay.
                    setTimeout(requestAttachments, countOfAttachmentsRequests * 1000);
                }

                if (data.attachments.length > 0) {
                    var links = '';
                    for (var i = 0; i < data.attachments.length; i++) {
                        var attachment = data.attachments[i];
                        links += '<a href="?viewingSessionId=' + attachment.viewingSessionId + '" target="blank">' + attachment.displayName + '</a><br/>';
                    }

                    $('#attachmentList').html(links);
                    $('#attachments').show();
                }
            }

            function requestAttachments () {
                if (countOfAttachmentsRequests < 10) {
                    countOfAttachmentsRequests++;
                    $.ajax('viewer-webtier/pcc.ashx/ViewingSession/u' + viewingSessionId + '/Attachments', { dataType: 'json' })
                        .done(receiveAttachments)
                        .fail(requestAttachments);
                }
            }
        }
        
        $(document).ready(function () {
            var viewerControl = $("#viewer1").pccViewer(pluginOptions).viewerControl;
                
            // Check if the document has any attachments
            setTimeout(processAttachments, 500);

            // For a user persona that does not have a layer defined we need to create a layer based on their user persona
            if (layerId.length <= 0) {
                // Get the current layer
                var thisLayer = viewerControl.getActiveMarkupLayer();
                // Set name to current persona
                thisLayer.setName('<%=PccViewer.WebTier.Core.User.name%>');
            }

        });
    </script>
</body>
</html>
