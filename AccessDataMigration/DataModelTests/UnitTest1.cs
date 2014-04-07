using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Should;
using Should.Fluent;

namespace DataModelTests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            var one = 1;

            one.Should().Equal(1);
        }

        [TestMethod]
        public void TestMethod2()
        {
            var one = 1;

            one.Should().Equal(1);
        }
    }
}
