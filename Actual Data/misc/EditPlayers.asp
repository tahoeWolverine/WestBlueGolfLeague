<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables

	Dim Handicap 
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim PlayerArray ()
	Dim AllPlayersArray ()
	Dim PointsArray ()
	Dim TeamArray ()
	Dim TeamIDArray ()
	Dim Team
	Dim TeamID
	Dim i
	Dim j
	Dim x
	Dim y
	Dim a
	Dim TotalCopied
	TotalCopied = 0
	Dim index
	Dim Found

	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
%>
<HTML>
<HEAD>
	<TITLE>Edit Team Rosters</TITLE>
</HEAD>

<BODY bgcolor="white">
<!--#include virtual="/handicaps/handicap.asp"-->
<%
' Connect to source database
Set SourceConn = Server.CreateObject("ADODB.Connection")
connectstr = connectstr & odbcName(strCurrentYear) & ";"
SourceConn.Open connectstr
%>
<center><h2><font color="Green"><% Response.write("Editing players for: " & strCurrentYear)%></font></h2></center><%


' Select all current teams
Set RS = SourceConn.Execute("SELECT TeamName,TeamID FROM TeamTable ORDER BY TeamID")
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

a = 0
For z = 0 to UBound(TeamArray)
	Team = TeamArray(z)
	TeamID = TeamIDArray(z)
	Response.write "<b>Team Name: " & Team & "</b><br>" 
	Response.write "<b>Team Number: " & TeamID & "</b><br>" 
	' Get players for each team	from source database
	Set RS1 = SourceConn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID & "'")
	j = 0
	Do While Not RS1.EOF
		ReDim Preserve PlayerArray(j)
		ReDim Preserve AllPlayersArray(a)
		PlayerArray (j) = RS1("PlayerName")
		AllPlayersArray (a) = PlayerArray (j)
		Handicap = CalcHandicap(PlayerArray(j), CInt(strCurrentYear))
		Response.write "NAME: " & PlayerArray(j) & "    " & "HDCP: " & Handicap & "<br>"
		j = j + 1
		a = a + 1
		RS1.MoveNext
	Loop
	RS1.Close
	Response.write "<br>" 
 Next 
 SourceConn.Close
 %>
	
<b>Enter a new player:</b>
<FORM action="addPlayer.asp" method="GET">
Team: <Select name="TeamID">
	<% For z = 0 to UBOUND(TeamArray) %>
	<option value="<%= TeamIDArray(z) %>"><%= TeamArray(z) %>
	<% Next %>
</select>
<br>
Player Name: <input type="Text" name="PlayerName">&nbsp;&nbsp;&nbsp;Existing Player: <input type="Checkbox" name="Existing">&nbsp;(Check only for team-to-team transfers of an existing player)<br>
Handicap (0-20): <input type="Text" name="Handicap"><br>
<input type="Submit" name="Submit" value="Submit">&nbsp;&nbsp;&nbsp;<input type="reset">
</FORM> Note: To transfer an existing player from one team to another, first delete the player from their existing team. Then add them to their new team and check "Existing Player".
<br><br>
<b>Selete an existing player to delete:</b>
<FORM action="deletePlayer.asp" method="GET">
	Player Name: <select name="player" size="1">
 		<% For z = 0 to UBound(AllPlayersArray) %>
 			<option value="<%= AllPlayersArray(z) %>"><%= AllPlayersArray(z) %>
 		<% Next	%>
 		</select>
	<input type="Submit" name="Delete" value="Delete">&nbsp;&nbsp;&nbsp;<input type="reset">
</FORM>
</Body>
</HTML>
<% Response.end %>