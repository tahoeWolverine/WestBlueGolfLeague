<!-- #include virtual="/westblue/settings.asp" -->

<HTML>
<HEAD>
	<TITLE>West Blue Golf League - Update Scores</TITLE>
</HEAD>

<BODY bgcolor="white">
<%
'On Error Resume Next
Dim week
Dim EditFlag 
Dim aPlayers(7)
Dim match
EditFlag = LCase(request.querystring("edit"))
Set DBMS = Server.CreateObject("ADODB.Connection")
Set RS = Server.CreateObject("ADODB.RecordSet")
connectstr = connectstr & odbcName(strCurrentYear) & ";"
DBMS.Open connectstr

match = request.querystring("match")

RSstring = "SELECT * FROM MatchTable WHERE MatchID='" & match & "'"
RS.Open RSstring, DBMS, 1,3
If RS.EOF Then ' Validate match id
	response.write("<h2><center><font color=Green>Invalid Match</font></center></h2></body></html>")
	RS.Close
	DBMS.Close
	response.end
ElseIf RS("MatchComplete") = "Y" AND EditFlag <> "y" Then ' Validate that match has not already been entered
	response.write("<h2><center><font color=Green>Match Info Already Entered</font></center></h2></body></html>")
	RS.Close
	DBMS.Close
	response.end	
End If
RS.Close

if EditFlag = "y" then
	' First delete all results for these two teams for this week
	RSstring = "SELECT * FROM ResultsTable WHERE Week=" & request.querystring("Week") & " AND TeamID1='" & request.querystring("Team1") & "' AND TeamID2='" & request.querystring("Team2") & "'"
	RS.Open RSstring, DBMS, 1,3
	Do While Not RS.EOF
		RS.Delete
		RS.Update
		RS.MoveNext
	Loop
	RS.Close
end if

RS.Open "SELECT * FROM ResultsTable", DBMS,1,3
RS.AddNew
RS("Week") = request.querystring("Week")
RS("TeamID1") = request.querystring("Team1")
RS("PlayerName1") = request.querystring("player1a")
aPlayers(0) = request.querystring("player1a")
RS("Score1") = request.querystring("p1ascore")
RS("Points1") = request.querystring("p1apoints")
RS("TeamID2") = request.querystring("Team2") %>
<%
RS("PlayerName2") = request.querystring("player1b")
aPlayers(1) = request.querystring("player1b")
RS("Score2") = request.querystring("p1bscore")
RS("Points2") = request.querystring("p1bpoints")
'RS.MoveNext
RS.AddNew
RS("Week") = request.querystring("Week")
RS("TeamID1") = request.querystring("Team1")
RS("PlayerName1") = request.querystring("player2a")
aPlayers(2) = request.querystring("player2a")
RS("Score1") = request.querystring("p2ascore")
RS("Points1") = request.querystring("p2apoints")
RS("TeamID2") = request.querystring("Team2") %>
<%
RS("PlayerName2") = request.querystring("player2b")
aPlayers(3) = request.querystring("player2b")
RS("Score2") = request.querystring("p2bscore")
RS("Points2") = request.querystring("p2bpoints")
RS.AddNew
RS("Week") = request.querystring("Week")
RS("TeamID1") = request.querystring("Team1")
RS("PlayerName1") = request.querystring("player3a")
aPlayers(4) = request.querystring("player3a")
RS("Score1") = request.querystring("p3ascore")
RS("Points1") = request.querystring("p3apoints")
RS("TeamID2") = request.querystring("Team2") %>
<%
RS("PlayerName2") = request.querystring("player3b")
aPlayers(5) = request.querystring("player3b")
RS("Score2") = request.querystring("p3bscore")
RS("Points2") = request.querystring("p3bpoints")
RS.AddNew
RS("Week") = request.querystring("Week")
RS("TeamID1") = request.querystring("Team1")
RS("PlayerName1") = request.querystring("player4a")
aPlayers(6) = request.querystring("player4a")
RS("Score1") = request.querystring("p4ascore")
RS("Points1") = request.querystring("p4apoints")
RS("TeamID2") = request.querystring("Team2") %>
<%
RS("PlayerName2") = request.querystring("player4b")
aPlayers(7) = request.querystring("player4b")
RS("Score2") = request.querystring("p4bscore")
RS("Points2") = request.querystring("p4bpoints")
RS.Update
RS.Close
RS.Open "SELECT MatchComplete FROM MatchTable WHERE MatchID='" & request.querystring("match") & "'", DBMS,1,3
RS("MatchComplete") = "Y"
RS.AddNew
RS.Update
RS.Close
DBMS.Close

%>

<h2><center><font color="Green">Your scores have been successfully added.</font></center></h2>

</BODY>
</HTML>
