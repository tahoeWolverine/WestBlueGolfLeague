SELECT
`Project2`.`id1` AS `id`, 
`Project2`.`id2` AS `id1`, 
`Project2`.`id` AS `id2`, 
`Project2`.`playoffType`, 
`Project2`.`weekId`, 
`Project2`.`matchComplete`, 
`Project2`.`startTimeId`, 
`Project2`.`matchId`, 
`Project2`.`matchOrder`, 
`Project2`.`matchupType`, 
`Project2`.`C2` AS `C1`, 
`Project2`.`id3`, 
`Project2`.`teamMatchupId`, 
`Project2`.`matchOrder1`, 
`Project2`.`C1` AS `C2`, 
`Project2`.`id4`, 
`Project2`.`priorHandicap`, 
`Project2`.`score`, 
`Project2`.`scoreVariant`, 
`Project2`.`points`, 
`Project2`.`teamId`, 
`Project2`.`playerId`, 
`Project2`.`matchId1`, 
`Project2`.`yearId`, 
`Project2`.`id5`, 
`Project2`.`name`, 
`Project2`.`currentHandicap`, 
`Project2`.`favorite`, 
`Project2`.`validPlayer`, 
`Project2`.`modifiedDate`
FROM (SELECT
`Limit1`.`id`, 
`Limit1`.`playoffType`, 
`Limit1`.`weekId`, 
`Limit1`.`matchComplete`, 
`Limit1`.`startTimeId`, 
`Limit1`.`matchId`, 
`Limit1`.`matchOrder`, 
`Limit1`.`matchupType`, 
`Limit1`.`id1`, 
`Limit1`.`id2`, 
`Join4`.`id` AS `id3`, 
`Join4`.`teamMatchupId`, 
`Join4`.`matchOrder` AS `matchOrder1`, 
`Join4`.`ID1` AS `id4`, 
`Join4`.`priorHandicap`, 
`Join4`.`score`, 
`Join4`.`scoreVariant`, 
`Join4`.`points`, 
`Join4`.`teamId`, 
`Join4`.`playerId`, 
`Join4`.`matchId` AS `matchId1`, 
`Join4`.`yearId`, 
`Join4`.`ID11` AS `id5`, 
`Join4`.`name`, 
`Join4`.`currentHandicap`, 
`Join4`.`favorite`, 
`Join4`.`validPlayer`, 
`Join4`.`modifiedDate`, 
CASE WHEN (`Join4`.`id` IS  NULL) THEN (NULL)  WHEN (`Join4`.`ID1` IS  NULL) THEN (NULL)  ELSE (1) END AS `C1`, 
CASE WHEN (`Join4`.`id` IS  NULL) THEN (NULL)  ELSE (1) END AS `C2`
FROM (SELECT
`Extent1`.`id`, 
`Extent1`.`playoffType`, 
`Extent1`.`weekId`, 
`Extent1`.`matchComplete`, 
`Extent1`.`startTimeId`, 
`Extent1`.`matchId`, 
`Extent1`.`matchOrder`, 
`Extent1`.`matchupType`, 
`Extent2`.`id` AS `id1`, 
`Extent3`.`id` AS `id2`
FROM `teammatchup` AS `Extent1` INNER JOIN `week` AS `Extent2` ON `Extent1`.`weekId` = `Extent2`.`id` INNER JOIN `year` AS `Extent3` ON `Extent2`.`yearId` = `Extent3`.`id`
 WHERE ((`Extent1`.`weekId` = @p__linq__0) AND (`Extent3`.`value` = @p__linq__1)) AND (`Extent1`.`id` = @p__linq__2) LIMIT 1) AS `Limit1` LEFT OUTER JOIN (SELECT
`Extent4`.`id`, 
`Extent4`.`teamMatchupId`, 
`Extent4`.`matchOrder`, 
`Join3`.`id` AS `ID1`, 
`Join3`.`priorHandicap`, 
`Join3`.`score`, 
`Join3`.`scoreVariant`, 
`Join3`.`points`, 
`Join3`.`teamId`, 
`Join3`.`playerId`, 
`Join3`.`matchId`, 
`Join3`.`yearId`, 
`Join3`.`ID1` AS `ID11`, 
`Join3`.`name`, 
`Join3`.`currentHandicap`, 
`Join3`.`favorite`, 
`Join3`.`validPlayer`, 
`Join3`.`modifiedDate`
FROM `match` AS `Extent4` LEFT OUTER JOIN (SELECT
`Extent5`.`id`, 
`Extent5`.`priorHandicap`, 
`Extent5`.`score`, 
`Extent5`.`scoreVariant`, 
`Extent5`.`points`, 
`Extent5`.`teamId`, 
`Extent5`.`playerId`, 
`Extent5`.`matchId`, 
`Extent5`.`yearId`, 
`Extent6`.`id` AS `ID1`, 
`Extent6`.`name`, 
`Extent6`.`currentHandicap`, 
`Extent6`.`favorite`, 
`Extent6`.`validPlayer`, 
`Extent6`.`modifiedDate`
FROM `result` AS `Extent5` INNER JOIN `player` AS `Extent6` ON `Extent5`.`playerId` = `Extent6`.`id`) AS `Join3` ON `Extent4`.`id` = `Join3`.`matchId`) AS `Join4` ON `Limit1`.`id` = `Join4`.`teamMatchupId`) AS `Project2`
 ORDER BY 
`Project2`.`id1` ASC, 
`Project2`.`id2` ASC, 
`Project2`.`id` ASC, 
`Project2`.`C2` ASC, 
`Project2`.`id3` ASC, 
`Project2`.`C1` ASC


-- p__linq__0: '309' (Type = Int32, IsNullable = false)

-- p__linq__1: '2015' (Type = Int32, IsNullable = false)

-- p__linq__2: '1175' (Type = Int32, IsNullable = false)



SELECT `Project2`.`id1` AS `id`, 
       `Project2`.`id2` AS `id1`, 
       `Project2`.`id`  AS `id2`, 
       `Project2`.`playofftype`, 
       `Project2`.`weekid`, 
       `Project2`.`matchcomplete`, 
       `Project2`.`starttimeid`, 
       `Project2`.`matchid`, 
       `Project2`.`matchorder`, 
       `Project2`.`matchuptype`, 
       `Project2`.`c2`  AS `C1`, 
       `Project2`.`id3`, 
       `Project2`.`teammatchupid`, 
       `Project2`.`matchorder1`, 
       `Project2`.`c1`  AS `C2`, 
       `Project2`.`id4`, 
       `Project2`.`priorhandicap`, 
       `Project2`.`score`, 
       `Project2`.`scorevariant`, 
       `Project2`.`points`, 
       `Project2`.`teamid`, 
       `Project2`.`playerid`, 
       `Project2`.`matchid1`, 
       `Project2`.`yearid`, 
       `Project2`.`id5`, 
       `Project2`.`name`, 
       `Project2`.`currenthandicap`, 
       `Project2`.`favorite`, 
       `Project2`.`validplayer`, 
       `Project2`.`modifieddate` 
FROM   (SELECT `Limit1`.`id`, 
               `Limit1`.`playofftype`, 
               `Limit1`.`weekid`, 
               `Limit1`.`matchcomplete`, 
               `Limit1`.`starttimeid`, 
               `Limit1`.`matchid`, 
               `Limit1`.`matchorder`, 
               `Limit1`.`matchuptype`, 
               `Limit1`.`id1`, 
               `Limit1`.`id2`, 
               `Join4`.`id`         AS `id3`, 
               `Join4`.`teammatchupid`, 
               `Join4`.`matchorder` AS `matchOrder1`, 
               `Join4`.`id1`        AS `id4`, 
               `Join4`.`priorhandicap`, 
               `Join4`.`score`, 
               `Join4`.`scorevariant`, 
               `Join4`.`points`, 
               `Join4`.`teamid`, 
               `Join4`.`playerid`, 
               `Join4`.`matchid`    AS `matchId1`, 
               `Join4`.`yearid`, 
               `Join4`.`id11`       AS `id5`, 
               `Join4`.`name`, 
               `Join4`.`currenthandicap`, 
               `Join4`.`favorite`, 
               `Join4`.`validplayer`, 
               `Join4`.`modifieddate`, 
               CASE 
                 WHEN ( `Join4`.`id` IS NULL ) THEN ( NULL ) 
                 WHEN ( `Join4`.`id1` IS NULL ) THEN ( NULL ) 
                 ELSE ( 1 ) 
               end                  AS `C1`, 
               CASE 
                 WHEN ( `Join4`.`id` IS NULL ) THEN ( NULL ) 
                 ELSE ( 1 ) 
               end                  AS `C2` 
        FROM   (SELECT `Extent1`.`id`, 
                       `Extent1`.`playofftype`, 
                       `Extent1`.`weekid`, 
                       `Extent1`.`matchcomplete`, 
                       `Extent1`.`starttimeid`, 
                       `Extent1`.`matchid`, 
                       `Extent1`.`matchorder`, 
                       `Extent1`.`matchuptype`, 
                       `Extent2`.`id` AS `id1`, 
                       `Extent3`.`id` AS `id2` 
                FROM   `teammatchup` AS `Extent1` 
                       INNER JOIN `week` AS `Extent2` 
                               ON `Extent1`.`weekid` = `Extent2`.`id` 
                       INNER JOIN `year` AS `Extent3` 
                               ON `Extent2`.`yearid` = `Extent3`.`id` 
                WHERE  ( ( `Extent1`.`weekid` = 309 ) 
                         AND ( `Extent3`.`value` = '2015' ) ) 
                       AND ( `Extent1`.`id` = 1175 ) 
                LIMIT  1) AS `Limit1` 
               LEFT OUTER JOIN (SELECT `Extent4`.`id`, 
                                       `Extent4`.`teammatchupid`, 
                                       `Extent4`.`matchorder`, 
                                       `Join3`.`id`  AS `ID1`, 
                                       `Join3`.`priorhandicap`, 
                                       `Join3`.`score`, 
                                       `Join3`.`scorevariant`, 
                                       `Join3`.`points`, 
                                       `Join3`.`teamid`, 
                                       `Join3`.`playerid`, 
                                       `Join3`.`matchid`, 
                                       `Join3`.`yearid`, 
                                       `Join3`.`id1` AS `ID11`, 
                                       `Join3`.`name`, 
                                       `Join3`.`currenthandicap`, 
                                       `Join3`.`favorite`, 
                                       `Join3`.`validplayer`, 
                                       `Join3`.`modifieddate` 
                                FROM   `match` AS `Extent4` 
                                       LEFT OUTER JOIN (SELECT `Extent5`.`id`, 
       `Extent5`.`priorhandicap`, 
       `Extent5`.`score`, 
       `Extent5`.`scorevariant`, 
       `Extent5`.`points`, 
       `Extent5`.`teamid`, 
       `Extent5`.`playerid`, 
       `Extent5`.`matchid`, 
       `Extent5`.`yearid`, 
       `Extent6`.`id` AS `ID1`, 
       `Extent6`.`name`, 
       `Extent6`.`currenthandicap`, 
       `Extent6`.`favorite`, 
       `Extent6`.`validplayer`, 
       `Extent6`.`modifieddate` 
       FROM   `result` AS `Extent5` 
       INNER JOIN `player` AS `Extent6` 
               ON `Extent5`.`playerid` 
                  = 
       `Extent6`.`id`) AS 
                            `Join3` 
       ON `Extent4`.`id` = `Join3`.`matchid`) AS 
       `Join4` 
       ON `Limit1`.`id` = `Join4`.`teammatchupid`) AS `Project2` 
ORDER  BY `Project2`.`id1` ASC, 
          `Project2`.`id2` ASC, 
          `Project2`.`id` ASC, 
          `Project2`.`c2` ASC, 
          `Project2`.`id3` ASC, 
          `Project2`.`c1` ASC 














SELECT
`Extent2`.`id`, 
`Extent2`.`teamName`, 
`Extent2`.`validTeam`, 
`Extent2`.`modifiedDate`
FROM `teammatchuptoteam` AS `Extent1` INNER JOIN `team` AS `Extent2` ON `Extent1`.`teamId` = `Extent2`.`id`
 WHERE `Extent1`.`teamMatchupId` = @EntityKeyValue1


-- EntityKeyValue1: '1175' (Type = Int32, IsNullable = false)
 
 
 
 
 