using AccessExport;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModelTests
{
    [TestClass]
    public class DataModelTestBase
    {
        protected static DataModel DataModel { get; private set; }

        [AssemblyInitialize]
        public static void Init(TestContext testContext)
        {
            var dm = new DataModelBuilder();
            string databaseDir = @"..\..\..\..\Actual Data\access_db";

            DataModelTestBase.DataModel = dm.CreateDataModel(databaseDir);
        }
    }
}
