using AccessExport.Entities;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Should;
using Should.Fluent;

namespace AccessExport
{
    class Program
    {
        // TODO: Move this in to testing project.
        public static void DoValidate(DataModel dataModel) 
        {
            var peteMohs = dataModel.Players.First(x => string.Equals("Pete Mohs", x.Name, StringComparison.OrdinalIgnoreCase));
            var jaysonWalberg = dataModel.Players.First(x => string.Equals("Jayson Walberg", x.Name, StringComparison.OrdinalIgnoreCase));
            var brianSchwartz = dataModel.Players.First(x => string.Equals("Brian Schwartz", x.Name, StringComparison.OrdinalIgnoreCase));

            var bushwoodsFinest = dataModel.Teams.First(x => string.Equals(x.Name, "Bushwoods Finest", StringComparison.OrdinalIgnoreCase));
            var yearDataForBushwoods2013 = dataModel.YearDatas.Where(x => x.Year.Value == 2013 && x.Player.Team.Id == bushwoodsFinest.Id);

            int peteHandicap = yearDataForBushwoods2013.First(x => x.Player.Id == peteMohs.Id).FinishingHandicap;
            int jaysonHandicap = yearDataForBushwoods2013.First(x => x.Player.Id == jaysonWalberg.Id).FinishingHandicap;
            int brianHandicap = yearDataForBushwoods2013.First(x => x.Player.Id == brianSchwartz.Id).FinishingHandicap;

            Console.WriteLine(Convert.ToString(11 == peteHandicap) + " : " + Convert.ToString(peteHandicap));
            Console.WriteLine(Convert.ToString(7 == jaysonHandicap) + " : " + Convert.ToString(jaysonHandicap));
            Console.WriteLine(Convert.ToString(12 == brianHandicap) + " : " + Convert.ToString(brianHandicap));
            //peteMohs.Team.Id.Should().Equal(1);
        }

        static void Main(string[] args)
        {
            var dmb = new DataModelBuilder();

            var dataModel = dmb.CreateDataModel();

            // Do some validating on our data model.
            DoValidate(dataModel);

            var mysqlGenerator = new MySqlGenerator();

            var dataModelInserts = mysqlGenerator.Generate(dataModel);

            //Console.WriteLine(dataModelInserts);
        }
    }
}
