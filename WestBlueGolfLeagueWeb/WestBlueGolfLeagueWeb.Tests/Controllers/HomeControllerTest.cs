using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using WestBlueGolfLeagueWeb;
using WestBlueGolfLeagueWeb.Controllers;

namespace WestBlueGolfLeagueWeb.Tests.Controllers
{
    [TestClass]
    public class HomeControllerTest
    {
        [TestMethod]
        public async void Index()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            ViewResult result = await controller.Index() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
        }
    }
}
