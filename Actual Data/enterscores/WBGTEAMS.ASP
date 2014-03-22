<!-- #include virtual="/westblue/settings.asp" -->
<%
Dim Username
Dim Password

Username = Request.QueryString("Username")
Password = Request.QueryString("Password")
%>
<% If Username = "" Then %>
	<% Response.Redirect("password.html") %>
<% Else  %>
<%
	Set Conn = Server.CreateObject("ADODB.Connection")
	'Conn.Open odbcName(strCurrentYear)
	connectstr = connectstr & odbcName(strCurrentYear) & ";"
	Conn.Open connectstr
	SQLCheck = "SELECT Username FROM Password WHERE Username='" & username & "' and Password='" & Password & "'"
	Set RS = Conn.Execute(SQLCheck)
	If RS.EOF Then
	    RS.Close
		Conn.Close
		Response.Redirect "invpswd.html"
	End If
	RS.Close
	Conn.Close
 %>
<% End If %>

<HTML>
<HEAD>
	<TITLE>Scores In</TITLE>
<script language="JavaScript">

function areTeamsEqual()
{
	var team1
	var team2
	
	if (document.pickteams.team1.selectedIndex == document.pickteams.team2.selectedIndex)
	{
		alert("You selected the same team twice, please pick another")
		document.pickteams.team1.focus()
		return false
	}
	return true
}
</script>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green">Input Scores - Select Teams</font></h2></center>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
'Set RS = Conn.Execute("SELECT * FROM WeekList")
'Set RS = Conn.Execute("SELECT * FROM WeekList where Week=10")
'Set RS = Conn.Execute("SELECT Week, Date FROM WeekList where Week='10'")
Set RS = Conn.Execute("SELECT Week, Date FROM WeekList")
%>

<form name="pickteams" action="WBGScores.asp" method="GET" onSubmit="return areTeamsEqual()">
<br><br>
<center><font face="Times New Roman" color="Navy">Match Date</font></center><br>
<center>
<select name="week" size="1">
   	<% Do While Not RS.EOF %>
   	<option value="<%  = RS("Week") %>"><%  = RS("Date") %>	
  	<% RS.MoveNext
   	Loop
   	%>
</select></center><br>
<table cellspacing="2" cellpadding="2" width="100%">
<tr>
	<td align="center">
		<font face="Times New Roman" color="Navy">Team 1</font>
	</td>
	<td></td>
	<td align="center">
		<font face="Times New Roman" color="Navy">Team 2</font>
	</td>
</tr>
<tr>
    <td align="center">
		<%
		Set RS = Conn.Execute("SELECT Team FROM TeamList")
		%>
		<select name="team1" size="1">
	   	<% Do While Not RS.EOF %>
	   		<option value="<%  = RS("Team") %>"><%  = RS("Team") %>
	   	<% RS.MoveNext
	   	Loop
	   	%>
	   	</select>
	</td>
    <td align="center">
		<h2><font color="Green">vs.</font></h2>
	</td>
    <td align="center">
		<%
		Set RS = Conn.Execute("SELECT Team FROM TeamList")
		%>
		<select name="team2" size="1">
	   	<% Do While Not RS.EOF %>
	   		<option value="<%  = RS("Team") %>"><%  = RS("Team") %>
	   	<% RS.MoveNext
	   	Loop
	   	%>
		<% RS.Close
		Conn.Close
		%>
	   	</select>
	</td>
</tr>
</table>
<br><br>
<center><input type="Submit" name="submit" value="Submit"> </center> 
</form>
</BODY>
</HTML>
