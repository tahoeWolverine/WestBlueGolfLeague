<!-- #include virtual="/westblue/settings.asp" -->
<%
Dim Team1Points
Dim Team2Points
Dim Team1Score
Dim Team2Score
Dim OldTeam1
Dim skipOnce
Dim strYear
strYear = Request("Year")
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
Set RS = Conn.Execute("SELECT TeamID1, PlayerName1, Score1, Points1, TeamID2, PlayerName2, Score2, Points2 FROM ResultsTable WHERE Week=" & Request.QueryString("Week") & " ORDER BY TEAMID1")
If RS.EOF Then
	RS.Close
	Conn.Close
	Response.Redirect("early2.html")
End If
%>

<HTML>
<HEAD>
	<TITLE>West Blue Golf League - <%= strYear %> Weekly Results</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><font color="Green"><h2><%Response.write(strYear & " Week " & Request.QueryString("Week") & " Match Results")%></h2></font></center>
<table width="100%">
<% DO While NOT RS.EOF %>
<% If (OldTeam1 <> RS("TeamID1")) Then %>
	<% Team1Points = 0
	   Team2Points = 0
	   Team1Score = 0
	   Team2Score = 0 %>
	<% OldTeam1 = RS("TeamID1") %> 
	<% Set RS2 = Conn.Execute("SELECT Points1, Score1 FROM ResultsTable WHERE Week=" & Request.QueryString("Week") & " and TeamID1='" & RS("TeamID1") & "' ORDER BY TeamID1") %>
	<% DO While NOT RS2.EOF
		Team1Points = Team1Points + RS2("Points1")
		Team1Score = Team1Score + RS2("Score1")
	 %>
	<% RS2.MoveNext
	   Loop
	%>
	<% RS2.Close %>
	<% Set RS3 = Conn.Execute("SELECT Points2, Score2 FROM ResultsTable WHERE Week=" & Request.QueryString("Week") & " and TeamID2='" & RS("TeamID2") & "'") %>
	<% DO While NOT RS3.EOF
		Team2Points = Team2Points + RS3("Points2")
		Team2Score = Team2Score + RS3("Score2")
	 %>
	<% RS3.MoveNext
	   Loop
	%>
	<% RS3.Close %>
	<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	</tr>

	<tr>
		<th align="left">
			<font color="Navy"><b>Player/Team</b></font>
		</th>
		<th>
			<font color="Navy"><b>Score</b></font>
		</th>
		<th>
			<font color="Navy"><b>Points</b></font>
		</th>
		<td></td>
		<th align="left">
			<font color="Navy"><b>Player/Team</b></font>
		</th>
		<th>
			<font color="Navy"><b>Score</b></font>
		</th>
		<th>
			<font color="Navy"><b>Points</b></font>
		</th>
	</tr>
	<tr>
<% 	Set RS4 = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & RS("TeamID1") & "'") %>
		<td><font color="Green"><%= RS4("TeamName") %></font></td>
		<td align="center"><font color="Green"><%= Team1Score %></font></td>
		<td align="center"><font color="Green"><%= Team1Points %></font></td>
		<td></td>
<% 	RS4.Close %>
<% 	Set RS4 = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & RS("TeamID2") & "'") %>
		<td><font color="Green"><%= RS4("TeamName") %></font></td>
		<td align="center"><font color="Green"><%= Team2Score %></font></td>
		<td align="center"><font color="Green"><%= Team2Points %></font></td>
	</tr>
<% 	RS4.Close %>

<% End If %>
	<tr>
		<td>
			<font color="Green"><%= RS("PlayerName1") %></font>
		</td>
		<td align="center">
			<font color="Green"><%= RS("Score1") %></font>
		</td>
		<td align="center">
			<font color="Green"><%= RS("Points1") %></font>
		</td>
		<td><font color="Navy"><a href="/edit/wEdit.asp?week=<%= Request.QueryString("Week")%>&Team1=<%= RS("TeamID1") %>&Team2=<%= RS("TeamID2") %>">vs.</a></font></td>
		<td>
			<font color="Green"><%= RS("PlayerName2") %></font>
		</td>
		<td align="center">
			<font color="Green"><%= RS("Score2") %></font>
		</td>
		<td align="center">
			<font color="Green"><%= RS("Points2") %></font>
		</td>
	</tr>

<% ldTeam1 = RS("TeamID1")
   RS.MoveNext
   Loop
%>
<% RS.Close
   Conn.Close
%>
</table>

</BODY>
</HTML>
