using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AccessExport;
using AccessExport.Entities;
using Should;
using Should.Fluent;

namespace DataModelTests
{
    [TestClass]
    public class ResultsTests : DataModelTestBase
    {
        private Player englert;


        [TestInitialize]
        public void Init()
        {
            this.englert = DataModel.Players.First(x => string.Equals("Jim Englert", x.Name));
        }

        [TestMethod]
        public void ResultsCount2013()
        {
            var results = englert.AllResults.Where(x => x.Year.Value == 2013);

            results.Count().ShouldEqual(7);
        }
    }
}
