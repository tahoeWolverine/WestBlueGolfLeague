<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables

' This program can be used to populate the PlayerTable for a new season
' To execute, first make sure the new database is created and the PlayerTable is emptied
' Then run the following URL in your browser: http://www.westbluegolfleage.com/misc/CopyPlayers.asp?Year=2013&CopyYear=2012
' Make sure that Year is set to the new year and CopyYear is set to the previous year
	Dim Handicap 
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim PlayerArray ()
	Dim PointsArray ()
	Dim TeamArray ()
	Dim TeamIDArray ()
	Dim Team
	Dim TeamID
	Dim i
	Dim j
	Dim x
	Dim y
	Dim TotalCopied
	TotalCopied = 0
	Dim index
	Dim Found
	Dim strCopyYear
	strCopyYear = null
	strCopyYear = Request("CopyYear")
	Dim strNewYear
	strNewYear = Request("Year")
	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
%>
<HTML>
<HEAD>
	<TITLE>Copy League Handicaps</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green">Populating Starting Handicaps</font></h2></center>
<!--#include virtual="/handicaps/handicap.asp"-->
<%

' Connect to source database
Set SourceConn = Server.CreateObject("ADODB.Connection")
connectstr1 = connectstr & odbcName(strCopyYear) & ";"
SourceConn.Open connectstr1

' Connect to target database
Set TargetConn = Server.CreateObject("ADODB.Connection")
connectstr2 = connectstr & odbcName(strNewYear) & ";"
TargetConn.Open connectstr2

%>
<center><h2><font color="Green"><% Response.write("Copying handicaps from: " & strCopyYear & " into " & strNewYear)%></font></h2></center><%


' Select all current teams
Set RS = SourceConn.Execute("SELECT TeamName,TeamID FROM TeamTable")
j = 0
' Get team information from source database
Do While Not RS.EOF
	ReDim Preserve TeamArray(j)
	TeamArray (j) = RS("TeamName")
	ReDim Preserve TeamIDArray(j)
	TeamIDArray (j) = RS("TeamID")
	j = j + 1
	RS.MoveNext
Loop
RS.Close

Set RS2 = Server.CreateObject("ADODB.RecordSet")
RS2.Open "SELECT * FROM PlayerTable", TargetConn,1,3

For z = 0 to UBound(TeamArray)
	Team = TeamArray(z)
	TeamID = TeamIDArray(z)
	Response.write "<b>" & Team & "</b><br>" 
	' Get players for each team	from source database
	Set RS1 = SourceConn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID & "'")
	j = 0
	Do While Not RS1.EOF
		ReDim Preserve PlayerArray(j)
		PlayerArray (j) = RS1("PlayerName")
		Handicap = CalcHandicap(PlayerArray(j), CInt(strCopyYear))
		RS2.AddNew
		RS2("PlayerName") = PlayerArray(j)
		RS2("TeamID") = TeamID
		RS2("Week0Score") = CINT(Handicap) + 36
		RS2("Status") = "OLD"
		RS2.UPDATE
		Response.write PlayerArray(j) & " " & Handicap & "<br>"
		j = j + 1
		RS1.MoveNext
	Loop
	RS1.Close
	
	TotalCopied = TotalCopied + j
	Response.write "<br>" 

 Next 
 RS2.Close
 SourceConn.Close
 TargetConn.Close
 Response.write "Total # of Players Copied: " & TotalCopied 
 %>
</Body>
</HTML>
<% Response.end %>