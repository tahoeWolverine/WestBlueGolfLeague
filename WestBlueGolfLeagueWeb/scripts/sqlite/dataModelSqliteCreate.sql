-- Creator:       MySQL Workbench 6.0.9/ExportSQLite plugin 2009.12.02
-- Author:        Polaris
-- Caption:       New Model
-- Project:       Name of the project
-- Changed:       2014-04-19 10:33
-- Created:       2014-03-21 20:47
PRAGMA foreign_keys = OFF;

-- Schema: westbluegolf
BEGIN;
CREATE TABLE "team"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "teamName" VARCHAR(120) NOT NULL,
  "validTeam" BOOL NOT NULL,
  "modifiedDate" DATETIME
);
CREATE INDEX "team.teamNameIndex1" ON "team"("teamName");
CREATE TABLE "course"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "name" VARCHAR(120) NOT NULL,
  "par" INTEGER NOT NULL,
  "address" VARCHAR(80)
);
CREATE INDEX "course.courseName1" ON "course"("name");
CREATE TABLE "leaderBoard"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "name" VARCHAR(100) NOT NULL,
  "isPlayerBoard" BOOL NOT NULL,
  "priority" INTEGER NOT NULL,
  "key" VARCHAR(50) NOT NULL
);
CREATE INDEX "leaderBoard.lookup" ON "leaderBoard"("key");
CREATE TABLE "year"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "value" INTEGER NOT NULL,
  "isComplete" BOOL NOT NULL
);
CREATE INDEX "year.yearValue" ON "year"("value");
CREATE TABLE "startTime"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "time" VARCHAR(45) NOT NULL,
  "startTime" DATETIME NOT NULL
);
CREATE TABLE "dataMigration"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "dataMigrationDate" DATETIME NOT NULL,
  "notes" VARCHAR(200),
  "yearId" INTEGER NOT NULL,
  CONSTRAINT "fk_dataMigration_year1"
    FOREIGN KEY("yearId")
    REFERENCES "year"("id")
);
CREATE INDEX "dataMigration.fk_dataMigration_year1_idx" ON "dataMigration"("yearId");
CREATE TABLE "pairing"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "pairingText" VARCHAR(45)
);
CREATE TABLE "user"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "username" VARCHAR(100) NOT NULL,
  "passwordHash" VARCHAR(200) NOT NULL,
  "salt" VARCHAR(45) NOT NULL,
  "dateAdded" DATETIME NOT NULL,
  "email" VARCHAR(120)
);
INSERT INTO "user"("id","username","passwordHash","salt","dateAdded","email") VALUES(1, 'admin', '4AE41260B4CA1A93852A3F05CE1D90D85DE30224CD0539331BAD671E4A1D1A00', '839202910', '2014-04-19', 'polaris878@gmail.com');
CREATE TABLE "player"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "name" VARCHAR(120) NOT NULL,
  "currentHandicap" INTEGER NOT NULL,
  "favorite" BOOL NOT NULL,
  "teamId" INTEGER NOT NULL,
  "validPlayer" BOOL NOT NULL,
  "modifiedDate" DATETIME,
  CONSTRAINT "fk_player_team"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE INDEX "player.fk_player_team_idx" ON "player"("teamId");
CREATE INDEX "player.playerName1" ON "player"("name");
CREATE TABLE "week"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "date" DATE NOT NULL,
  "courseId" INTEGER NOT NULL,
  "yearId" INTEGER NOT NULL,
  "isBadData" BOOL NOT NULL,
  "seasonIndex" INTEGER NOT NULL,
  CONSTRAINT "fk_week_course1"
    FOREIGN KEY("courseId")
    REFERENCES "course"("id"),
  CONSTRAINT "fk_week_year1"
    FOREIGN KEY("yearId")
    REFERENCES "year"("id")
);
CREATE INDEX "week.fk_week_course1_idx" ON "week"("courseId");
CREATE INDEX "week.fk_week_year1_idx" ON "week"("yearId");
CREATE TABLE "teamMatchup"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "status" VARCHAR(45),
  "weekId" INTEGER NOT NULL,
  "matchComplete" BOOL NOT NULL,
  "startTimeId" INTEGER,
  "matchId" INTEGER,
  "pairingId" INTEGER,
  CONSTRAINT "fk_team_matchup_week1"
    FOREIGN KEY("weekId")
    REFERENCES "week"("id"),
  CONSTRAINT "fk_team_matchup_start_times1"
    FOREIGN KEY("startTimeId")
    REFERENCES "startTime"("id"),
  CONSTRAINT "fk_teamMatchup_pairings1"
    FOREIGN KEY("pairingId")
    REFERENCES "pairing"("id")
);
CREATE INDEX "teamMatchup.fk_team_matchup_week1_idx" ON "teamMatchup"("weekId");
CREATE INDEX "teamMatchup.fk_team_matchup_start_times1_idx" ON "teamMatchup"("startTimeId");
CREATE INDEX "teamMatchup.fk_teamMatchup_pairings1_idx" ON "teamMatchup"("pairingId");
CREATE TABLE "matchup"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "teamMatchupId" INTEGER NOT NULL,
  CONSTRAINT "fk_matchup_team_matchup1"
    FOREIGN KEY("teamMatchupId")
    REFERENCES "teamMatchup"("id")
);
CREATE INDEX "matchup.fk_matchup_team_matchup1_idx" ON "matchup"("teamMatchupId");
CREATE TABLE "playerYearData"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "isRookie" BOOL NOT NULL,
  "startingHandicap" INTEGER NOT NULL,
  "finishingHandicap" INTEGER NOT NULL,
  "playerId" INTEGER NOT NULL,
  "yearId" INTEGER NOT NULL,
  CONSTRAINT "fk_player_year_data_player1"
    FOREIGN KEY("playerId")
    REFERENCES "player"("id"),
  CONSTRAINT "fk_player_year_data_year1"
    FOREIGN KEY("yearId")
    REFERENCES "year"("id")
);
CREATE INDEX "playerYearData.fk_player_year_data_player1_idx" ON "playerYearData"("playerId");
CREATE INDEX "playerYearData.fk_player_year_data_year1_idx" ON "playerYearData"("yearId");
CREATE TABLE "leaderBoardData"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "rank" INTEGER NOT NULL,
  "value" DOUBLE NOT NULL,
  "leaderBoardId" INTEGER NOT NULL,
  "yearId" INTEGER NOT NULL,
  "isPlayer" BOOL NOT NULL,
  "teamId" INTEGER,
  "playerId" INTEGER,
  "detail" VARCHAR(100),
  CONSTRAINT "fk_leader_board_data_leader_board1"
    FOREIGN KEY("leaderBoardId")
    REFERENCES "leaderBoard"("id"),
  CONSTRAINT "fk_leader_board_data_year1"
    FOREIGN KEY("yearId")
    REFERENCES "year"("id"),
  CONSTRAINT "fk_leaderBoardData_team1"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id"),
  CONSTRAINT "fk_leaderBoardData_player1"
    FOREIGN KEY("playerId")
    REFERENCES "player"("id")
);
CREATE INDEX "leaderBoardData.fk_leader_board_data_leader_board1_idx" ON "leaderBoardData"("leaderBoardId");
CREATE INDEX "leaderBoardData.fk_leader_board_data_year1_idx" ON "leaderBoardData"("yearId");
CREATE INDEX "leaderBoardData.fk_leaderBoardData_team1_idx" ON "leaderBoardData"("teamId");
CREATE INDEX "leaderBoardData.fk_leaderBoardData_player1_idx" ON "leaderBoardData"("playerId");
CREATE TABLE "matchupToPlayer"(
  "playerId" INTEGER NOT NULL,
  "matchupId" INTEGER NOT NULL,
  PRIMARY KEY("playerId","matchupId"),
  CONSTRAINT "fk_matchupToPlayer_player1"
    FOREIGN KEY("playerId")
    REFERENCES "player"("id"),
  CONSTRAINT "fk_matchupToPlayer_matchup1"
    FOREIGN KEY("matchupId")
    REFERENCES "matchup"("id")
);
CREATE INDEX "matchupToPlayer.fk_matchupToPlayer_player1_idx" ON "matchupToPlayer"("playerId");
CREATE INDEX "matchupToPlayer.fk_matchupToPlayer_matchup1_idx" ON "matchupToPlayer"("matchupId");
CREATE TABLE "teamMatchupToTeam"(
  "teamMatchupId" INTEGER NOT NULL,
  "teamId" INTEGER NOT NULL,
  PRIMARY KEY("teamMatchupId","teamId"),
  CONSTRAINT "fk_teamMatchupToTeam_teamMatchup1"
    FOREIGN KEY("teamMatchupId")
    REFERENCES "teamMatchup"("id"),
  CONSTRAINT "fk_teamMatchupToTeam_team1"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
);
CREATE INDEX "teamMatchupToTeam.fk_teamMatchupToTeam_teamMatchup1_idx" ON "teamMatchupToTeam"("teamMatchupId");
CREATE INDEX "teamMatchupToTeam.fk_teamMatchupToTeam_team1_idx" ON "teamMatchupToTeam"("teamId");
CREATE TABLE "result"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "priorHandicap" INTEGER NOT NULL,
  "score" INTEGER NOT NULL,
  "points" INTEGER NOT NULL,
  "teamId" INTEGER NOT NULL,
  "playerId" INTEGER NOT NULL,
  "matchupId" INTEGER NOT NULL,
  "yearId" INTEGER NOT NULL,
  CONSTRAINT "fk_result_team1"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id"),
  CONSTRAINT "fk_result_player1"
    FOREIGN KEY("playerId")
    REFERENCES "player"("id"),
  CONSTRAINT "fk_result_matchup1"
    FOREIGN KEY("matchupId")
    REFERENCES "matchup"("id"),
  CONSTRAINT "fk_result_year1"
    FOREIGN KEY("yearId")
    REFERENCES "year"("id")
);
CREATE INDEX "result.fk_result_team1_idx" ON "result"("teamId");
CREATE INDEX "result.fk_result_player1_idx" ON "result"("playerId");
CREATE INDEX "result.fk_result_matchup1_idx" ON "result"("matchupId");
CREATE INDEX "result.fk_result_year1_idx" ON "result"("yearId");
COMMIT;
