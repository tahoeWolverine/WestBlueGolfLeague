using System.Web.Optimization;

namespace HtmlBundling
{
    /*
     * Copied from omeganet's AngularJS-HTML-Bundling project:
     * https://github.com/omeganet/AngularJS-HTML-Bundling
     * 
     * Blog: http://code.dortikum.net/2014/04/13/bundling-angularjs-html-pages-with-asp-net/
     */
    public class AngularJsHtmlBundle : Bundle
    {
        public AngularJsHtmlBundle(string virtualPath)
            : base(virtualPath, null, new[] { (IBundleTransform)new AngularJsHtmlCombine() })
        {
        }
    }
}