<%@ WebHandler Language="C#" Class="Convert" Debug="true" %>

using System.Web;
using Pcc;

/// <summary>
/// Maps the requested URL to the appropriate method.
/// </summary>
public class Convert : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        PrizmApplicationServices.ForwardRequest(HttpContext.Current, context.Request.PathInfo);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
