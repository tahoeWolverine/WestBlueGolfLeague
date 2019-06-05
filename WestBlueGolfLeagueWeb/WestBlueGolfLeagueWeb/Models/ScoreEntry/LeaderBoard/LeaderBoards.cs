using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard
{
    public static class LeaderBoards
    {
        private static int priorityCounter = 1;

        public static readonly List<PlayerLeaderBoard> PlayerBoards = new
            List<PlayerLeaderBoard>
                {
                    new PlayerLeaderBoard( "Best Score", "player_best_score", LeaderBoardFormat.Default, (p, year, r) => p.LowRoundForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Best Net Score", "player_net_best_score", LeaderBoardFormat.Net, (p, year, r) => p.LowNetForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Handicap", "player_handicap", LeaderBoardFormat.Net, (p, year, r) => p.FinishingHandicapInYear(year), priorityCounter++),

                    new PlayerLeaderBoard( "Average Points", "player_avg_points", LeaderBoardFormat.Default, (p, year, r) => p.AveragePointsInYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Win/Loss Ratio", "player_win_loss_ratio", LeaderBoardFormat.Ratio, (p, year, r) => p.RecordRatioForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Season Improvement", "player_season_improvement", LeaderBoardFormat.Net, (p, year, r) => p.ImprovedInYear(year), priorityCounter++),

                    new PlayerLeaderBoard( "Avg. Opp. Score", "player_avg_opp_score", LeaderBoardFormat.Default, (p, year, r) => p.AverageOpponentScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Avg. Opp. Net Score", "player_avg_opp_net_score", LeaderBoardFormat.Net, (p, year, r) => p.AverageOpponentNetScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Average Score", "player_avg_score", LeaderBoardFormat.Default, (p, year, r) => p.AverageScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Average Net Score", "player_avg_net_score", LeaderBoardFormat.Net, (p, year, r) => p.AverageNetScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Points in a Match", "player_points_in_match", LeaderBoardFormat.Default, (p, year, r) => p.MostPointsInMatchForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Points", "player_total_points", LeaderBoardFormat.Default, (p, year, r) => p.TotalPointsForYear(year), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Wins", "player_total_wins", LeaderBoardFormat.Default, (p, year, r) => p.RecordForYear(year, r)[0], priorityCounter++, false),

                    new PlayerLeaderBoard( "Avg. Margin of Victory", "player_avg_margin_victory", LeaderBoardFormat.Default, (p, year, r) => p.AverageMarginOfVictoryForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Avg. Margin of Net Victory", "player_avg_margin_net_victory", LeaderBoardFormat.Net, (p, year, r) => p.AverageMarginOfNetVictoryForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Rounds", "player_total_rounds_for_year", LeaderBoardFormat.Default, (p, year, r) => p.TotalRoundsForYear(year, r), priorityCounter++, false),
                };


        private static int teamPriorityCounter = 1;

        public static readonly List<TeamLeaderBoard> TeamBoards =
            new List<TeamLeaderBoard>
                {
                    new TeamLeaderBoard("Team Ranking", "team_ranking", LeaderBoardFormat.Default, (t, year, r) => t.TotalPointsForYear(year), teamPriorityCounter++, false),
                    new TeamLeaderBoard("Team Ranking - First Half", "team_ranking_1st", LeaderBoardFormat.Default, (t, year, r) => t.TotalPointsForFirstHalf(year), teamPriorityCounter++, false),
                    new TeamLeaderBoard("Team Ranking - Second Half", "team_ranking_2nd", LeaderBoardFormat.Default, (t, year, r) => t.TotalPointsForSecondHalf(year), teamPriorityCounter++, false),

                    new TeamLeaderBoard("Average Handicap", "team_avg_handicap", LeaderBoardFormat.Default, (t, year, r) => t.AverageHandicapForYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Win/Loss Ratio", "team_win_loss_ratio", LeaderBoardFormat.Ratio, (t, year, r) => t.RecordRatioForYear(year), teamPriorityCounter++, false),

                    new TeamLeaderBoard("Season Improvement", "team_season_improvement", LeaderBoardFormat.Net, (t, year, r) => t.ImprovedInYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Avg. Opp. Score", "team_avg_opp_score", LeaderBoardFormat.Default, (t, year, r) => t.AverageOpponentScoreForYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Avg. Opp. Net Score", "team_avg_opp_net_score", LeaderBoardFormat.Net, (t, year, r) => t.AverageOpponentNetScoreForYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Average Score", "team_avg_score", LeaderBoardFormat.Default, (t, year, r) => t.AverageScoreForYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Average Net Score", "team_avg_net_score", LeaderBoardFormat.Net, (t, year, r) => t.AverageNetScoreForYear(year), teamPriorityCounter++),

                    new TeamLeaderBoard("Ind. W/L Ratio", "team_ind_win_loss_record", LeaderBoardFormat.Ratio, (t, year, r) => t.IndividualRecordRatioForYear(year), teamPriorityCounter++, false),

                    new TeamLeaderBoard("Total Match Wins", "team_total_match_wins", LeaderBoardFormat.Default, (t, year, r) => t.IndividualRecordForYear(year)[0], teamPriorityCounter++, false),

                    new TeamLeaderBoard("Points in a Week", "team_most_points_in_week", LeaderBoardFormat.Default, (t, year, r) => t.MostPointsInWeekForYear(year), teamPriorityCounter++, false),

                    new TeamLeaderBoard("Avg. Margin of Victory", "team_avg_margin_victory", LeaderBoardFormat.Default, (t, year, r) => t.AverageMarginOfVictoryForYear(year), teamPriorityCounter++, false),

                    new TeamLeaderBoard("Avg. Margin of Net Victory", "team_avg_margin_net_victory", LeaderBoardFormat.Net, (t, year, r) => t.AverageMarginOfNetVictoryForYear(year), teamPriorityCounter++, false),
                };
    }
}