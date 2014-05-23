using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;


/*
 * Copied from madsny's AngularPartialsBundles project:
 * https://github.com/madsny/AngularPartialsBundles/blob/master/AngularTemplateBundles/AngularPartials.cs
 */
namespace WestBlueGolfLeagueWeb.Helpers
{
    public static class AngularHelpers
    {
        public static IHtmlString RenderTemplates(string path)
        {
            if (BundleTable.EnableOptimizations)
                return Scripts.Render(path);

            return null;
        }
    }
}