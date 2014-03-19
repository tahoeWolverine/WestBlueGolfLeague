using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(WestBlueGolfLeagueWeb.Startup))]
namespace WestBlueGolfLeagueWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
