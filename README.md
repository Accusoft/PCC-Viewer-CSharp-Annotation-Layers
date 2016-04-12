# PrizmDoc Annotation Layers Sample:

This is a demo that illustrates what we believe is the most common use case for layered annotations. The viewer itself still has no concept of a "user" or how one user might differ from another. This is primarily because the viewer does not perform authentication or user validation internally. 

Instead, we can enforce some idea of user ownership by restricting which layers can or cannot load. In this demo, we are working with the assumption that all users will  create and own only one annotation layer per document and we identify that layer by the user’s name. A user will only be able to see their own layer and any comments left by the "admin" user on their layer. We have also created an ‘admin user’ for the purpose of reviewing multiple layers. The admin user will have their own layer which will store their comments and they can view all other layers created for the given document. The admin view for a document will also toggle on the option to automatically load all layers for a given document. All other users will have the option to load layers, that they are permitted to review, on demand.

For clarity, this demo uses URL query parameters to differentiate between different users. This is not a secure method and has no authentication. Instead, this demo is intended to illustrate the strategies and the places where the base sample code can be adapted to fit a particular business or workflow need. To that end, using a query parameter instead of session-based authentication allows a developer to quickly switch back and forth between different users and quickly verify which persona they are currently viewing, as well as avoiding the extra complications associated with the increased security that would be present in a production environment. Like other demos in this series, this is intended as a teaching tool and is not intended to be deployable code.  

### Setup

#### Requirements

This demo code requires Microsoft .NET Framework 4.0, IIS, ASP.NET 4.0 and the lastest version of the PrizmDoc Client and Server installers.

Additionally, you will need to edit the "full-viewer-sample\viewer-webtier\pcc.config" file to indicate a valid PrizmDoc Server instance. By default, this sample will attempt to use the PrizmDoc Server located at “localhost:18681”.

#### Installation

First, make any changes to the configuration file located at "full-viewer-sample\viewer-webtier\pcc.config". Typical changes include indicating a working PrizmDoc Server instance and changing the location for the Markup, Markup Layer, and Imagestamp directories. By default, the demo will use directories that are located within the full-viewer-sample directory. Please make sure those directories exist and that the full-viewer-sample application has read and write access.

##### From the IIS Manager

* Right-click on "Default Web Site" and select “Add application”.

* Set the alias to "full-viewer-sample" and provide the physical path to the full-viewer-sample directory.

* Click "OK".

* Repeat this process for the splash application and the "splash" directory.

To use the sample, browse for the splash application at "localhost/splash", select a user persona and then select or upload a document.

##### Modify the relevant PAS config file

* Depending on which OS is running PAS and where PAS was installed, a different file will have to be modified.

* Add the following to override the default PAS routes:
```
routeHandlers.GetMarkupLayers.url: "http://localhost/full-viewer-sample/viewer-webtier/markupHandler.ashx"
routeHandlers.CreateMarkupLayer.url: "http://localhost/full-viewer-sample/viewer-webtier/markupHandler.ashx"
routeHandlers.GetMarkupLayer.url: "http://localhost/full-viewer-sample/viewer-webtier/markupHandler.ashx"
routeHandlers.UpdateMarkupLayer.url: "http://localhost/full-viewer-sample/viewer-webtier/markupHandler.ashx"
routeHandlers.DeleteMarkupLayer.url: "http://localhost/full-viewer-sample/viewer-webtier/markupHandler.ashx"
```

##### Verify the pcc.config settings

This file is located in `full-viewer-sample\viewer-webtier` and contains the settings to indicate how this application can contact PAS as well as the PrizmDoc Server. Verify that those settings match the settings for your envrionment.


### Changes from default sample

There are a few minor changes to enable this database insertion/loading sample.

* New global property ("User") added to track the current user’s name.

* Change to automatically set the current layer name immediately after the viewer is created (if the user did not previously own a valid layer for the current document).

* Added the cleanList method to HTTPMarkupLayers class to return a list of layers based on the current user.

# Support and Purchasing

For questions or support please visit our [website](https://www.accusoft.com/support/) or contact our Support team directly at support@accusoft.com.

For purchasing information please visit the [PrizmDoc](https://www.accusoft.com/products/prizm-content-connect-pcc/overview/) main page or contact our Sales team directly at sales@accusoft.com