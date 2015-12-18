<%@ WebHandler Language="C#" Class="markupHandler" %>

using System;
using System.Web;
using System.Text.RegularExpressions;
using Pcc;

public class markupHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        MarkupLayers layers = new MarkupLayers();

        // If the username query string is empty
        if (context.Request.QueryString["user"] != null)
        {
            User.setName(context.Request.QueryString["user"]);
        }

        Regex regex = new Regex("^/MarkupLayers/(?<ViewingSessionId>[^/]+)(/)?((?!/)(?<LayerRecordId>[^/]+))?$");
        Match match = regex.Match(context.Request.PathInfo);

        layers.ProcessRequest(context, match);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}