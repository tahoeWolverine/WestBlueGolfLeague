<!-- #include virtual="/westblue/settings.asp" -->

<HTML>
<HEAD>
	<TITLE>West Blue Golf League - Display Week</TITLE>
</HEAD>

<BODY bgcolor="white">
<%= Request.ServerVariables("QUERY_STRING") %>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
SQL = "SELECT * FROM ResultsList WHERE week='" & Request.QueryString("week") & "' and Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
'SQLWeekCheck = "SELECT week FROM ResultsList where week='" & Request.QueryString("week") & "' and Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
Set RS = Conn.Execute(SQL)
%>
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><%= request.querystring("team1") %></th>
			<th align="center">Score</th>
			<th align="center">Points</th>
		</tr>
	   <% Do While Not RS.EOF %>
		<tr>
		    <td>
			Player: <%= RS("Player1") %>
		   </td>
		    <td align="right">Score: <%= RS("Score1") %></td>
		    <td align="right">Points: <%= RS("Points1") %></td>	
		</tr>
	   <% RS.MoveNext
	   Loop
	   %>
		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><%= request.querystring("team2") %></th>
			<th align="center">Score</th>
			<th align="center">Points</th>	
		</tr>
		<% SQL = "SELECT Player2, Score2, Points2 FROM ResultsList where week='" & Request.QueryString("week") & "' and Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
		   Set RS = Conn.Execute(SQL) %>
		<% Do While Not RS.EOF %>
		<tr>
		    <td>Player: <%= RS("Player2") %></td>
		    <td>Score: <%= RS("Score2") %></td>
		    <td>Points: <%= RS("Points2") %></td>	
		</tr>
	   <% RS.MoveNext
	   Loop
	   %>
		</table>
	</td>
</tr>
</table>
<% RS.Close
Conn.Close %>
</BODY>
</HTML>
