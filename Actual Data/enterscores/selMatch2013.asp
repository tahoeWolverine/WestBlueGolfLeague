<!-- #include virtual="/westblue/settings.asp" -->
<HTML>
<HEAD>
	<TITLE>Scores In</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green">Input Scores - Select Match</font></h2></center>
<center><h3><font color="Green">(or click Edit to modify a match)</font></h3></center>

<%
Dim strWeek
Dim sqlQuery
Dim TeamID1
Dim TeamID2

strWeek = request("week")
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
conn.Open connectstr
sqlQuery = "SELECT MatchComplete, MatchID, TeamID1, TeamID2 FROM MatchTable WHERE Week=" & strWeek
Set RS = Conn.Execute(sqlQuery)
%>

<form name="pickmatch" action="EditScores.asp" method="GET">
<br><br>

<center>
   	<% Do While Not RS.EOF %>
	<% TeamID1 = RS("TeamID1") %>
	<% TeamID2 = RS("TeamID2") %>
	<% sqlQuery = "SELECT TeamName FROM TeamTable WHERE TeamID='" & TeamID1 & "'" %>
	<% Set RS2 = Conn.Execute(sqlQuery) %>
	<% sqlQuery = "SELECT TeamName FROM TeamTable WHERE TeamID='" & TeamID2 & "'" %>
	<% Set RS3 = Conn.Execute(sqlQuery) %>
	<% if RS("MatchComplete") = "Y" then %>
	<font color="navy"><%=RS2("TeamName") %> vs. <%=RS3("TeamName") %> <a href=EditScores.asp?edit=y&match=<%=RS("MatchID") %>&week=<%=strWeek%>>(Edit)</a></font>
	<% else %>
	<input type="Radio" name="match" value=<%= RS("MatchID") %>>
	<font color="navy"><%=RS2("TeamName") %> vs. <%=RS3("TeamName") %></font>
	<% end if %>
	<br>
  	<% 
	Set RS2=Nothing
	Set RS3=Nothing
	RS.MoveNext
   	Loop
	Set RS=Nothing
	Set Conn=Nothing
   	%>
</select></center><br>
<br><br>
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<center><input type="Submit" name="submit" value="Submit"> </center> 
</form>
</BODY>
</HTML>


