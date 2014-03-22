<!-- #include virtual="/westblue/settings.asp" -->
<% 'This code checks to see if the user selected a valid match for the selected week.
dim wk
wk = CInt(Request.QueryString("week"))
'CStr()
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
SQLWeekCheck1 = "SELECT week FROM MatchList where week=" & wk & " and Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
Set RS = Conn.Execute(SQLWeekCheck1)
SQLWeekCheck2 = "SELECT week FROM MatchList where week=" & wk & " and Team1='" & Request.QueryString("team2") & "' and Team2='" & Request.QueryString("team1") & "'"
Set RS3 = Conn.Execute(SQLWeekCheck2)
If RS.EOF and RS3.EOF Then
    RS.Close
	RS3.Close
	Conn.Close
	Response.Redirect "badmatch.html"
End If
RS.Close
RS3.Close
 %>
<% 	' This code checks to see if the databse already contains an entry for the two selected teams
	' for the selected week.
SQLWeekCheck1 = "SELECT week FROM ResultsList where week=" & wk & " and Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
'SQLWeekCheck1 = "SELECT week FROM ResultsList where Team1='" & Request.QueryString("team1") & "' and Team2='" & Request.QueryString("team2") & "'"
Set RS = Conn.Execute(SQLWeekCheck1)
If Not RS.EOF Then
    RS.Close
	Conn.Close
	Response.Redirect "exists.html"
End If
RS.Close
%>
<%
' This code also checks to see if the database already contains an entry for the two selected teams
' for the selected week.
SQLWeekCheck2 = "SELECT week FROM ResultsList where week=" & wk & " and Team1='" & Request.QueryString("team2") & "' and Team2='" & Request.QueryString("team1") & "'"
Set RS1 = Conn.Execute(SQLWeekCheck2)
If Not RS1.EOF Then
    RS1.Close
	Conn.Close
	Response.Redirect "exists.html"
End If
RS1.Close
%>
<%
Set RS2 = Conn.Execute("SELECT Date FROM WeekList Where week=" & wk &"")
Dim Diff
Diff = DateDiff("d", Date, RS2("Date")) %>
<% 'If (Diff >= 0) Then %>
<% 'RS2.Close
   'Conn.Close %>
<% 'Response.Redirect "early.html" %>
<% 'End If %>
<%
RS2.Close
Conn.Close
 %>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual InterDev 1.0">
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Document Title</TITLE>
<script language="JavaScript">
function validateFields()
{
	var RC
	
	RC = formComplete()
	if (RC == false)
	{
		return false
	}
	
	RC = validPlayers()
	if (RC == false)
	{
		return false
	}
	
	for (x = 4; x <= 25; x = x+3)
	{
		RC = validateScores(x)
		if (RC == false) 
		{
			return false
		}
	}
	
	for (x = 5; x <= 26; x = x+3)
	{
		RC = validatePoints(x)
		if (RC == false) 
		{
			return false
		}
	}
	return true
}

function formComplete()
{
	if ((document.enterscores.p1ascore.value == "") ||
		(document.enterscores.p1bscore.value == "") ||
		(document.enterscores.p2ascore.value == "") ||
		(document.enterscores.p2bscore.value == "") ||
		(document.enterscores.p3ascore.value == "") ||
		(document.enterscores.p3bscore.value == "") ||
		(document.enterscores.p4ascore.value == "") ||
		(document.enterscores.p4bscore.value == "") ||
		(document.enterscores.p1apoints.value == "") ||
		(document.enterscores.p1bpoints.value == "") ||
		(document.enterscores.p2apoints.value == "") ||
		(document.enterscores.p2bpoints.value == "") ||
		(document.enterscores.p3apoints.value == "") ||
		(document.enterscores.p3bpoints.value == "") ||
		(document.enterscores.p4apoints.value == "") ||
		(document.enterscores.p4bpoints.value == ""))
	{
		alert("Please complete the entire form.")
		return false
	}
	return true
}

function validPlayers()
{
	if ((document.enterscores.player1a.selectedIndex == document.enterscores.player2a.selectedIndex) ||
		(document.enterscores.player1a.selectedIndex == document.enterscores.player3a.selectedIndex) ||	
		(document.enterscores.player1a.selectedIndex == document.enterscores.player4a.selectedIndex) ||
		(document.enterscores.player2a.selectedIndex == document.enterscores.player3a.selectedIndex) ||
		(document.enterscores.player2a.selectedIndex == document.enterscores.player4a.selectedIndex) ||
		(document.enterscores.player3a.selectedIndex == document.enterscores.player4a.selectedIndex) ||
		(document.enterscores.player1b.selectedIndex == document.enterscores.player2b.selectedIndex) ||
		(document.enterscores.player1b.selectedIndex == document.enterscores.player3b.selectedIndex) ||	
		(document.enterscores.player1b.selectedIndex == document.enterscores.player4b.selectedIndex) ||
		(document.enterscores.player2b.selectedIndex == document.enterscores.player3b.selectedIndex) ||
		(document.enterscores.player2b.selectedIndex == document.enterscores.player4b.selectedIndex) ||
		(document.enterscores.player3b.selectedIndex == document.enterscores.player4b.selectedIndex))
	{
		alert("You have selected duplicate players, please select another.")
		return false	
	}
	return true
}

function validateScores(index)
{
	var theScore = new String(document.enterscores.elements[index].value)
	var theChar

	for (var i = 0; i < theScore.length; i++)
	{
		theChar = theScore.charAt(i)
		if (!isDigit(theChar))
		{
			alert("Your score can only contain digits.")
			document.enterscores.elements[index].focus()
			document.enterscores.elements[index].select()
			return false	
		}
	}
	return true
}

function isDigit(theDigit)
{
	digitArray = new Array('0','1','2','3','4','5','6','7','8','9')
	for (j = 0; j < digitArray.length; j++)
		if (theDigit == digitArray[j])
			return true
	return false
}
function validatePoints(index)
{
	var thePoints = new String(document.enterscores.elements[index].value)
	var theChar

	if ((thePoints < 0) || (thePoints > 24))
	{
		alert("You can only score between 0 and 24 points.")
		document.enterscores.elements[index].focus()
		document.enterscores.elements[index].select()
		return false
	}
	
	for (var i = 0; i < thePoints.length; i++)
	{
		theChar = thePoints.charAt(i)
		if (!isDigit(theChar))
		{
			alert("Your points can only contain digits.")
			document.enterscores.elements[index].focus()
			document.enterscores.elements[index].select()
			return false	
		}
	}
	return true
}

</script>
</HEAD>
<BODY bgcolor="white">
<center><h2><font color="Green">Input Scores</font></h2></center>
<br><br>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
Conn.Open connectstr
'Set RS = Conn.Execute("SELECT * FROM WeekList")
'Set RS = Conn.Execute("SELECT * FROM WeekList where Week=10")
'Set RS = Conn.Execute("SELECT Week, Date FROM WeekList where Week='10'")
SQLteam1 = "SELECT Player FROM PlayerList where Team='" & Ucase(Request.QueryString("team1")) & "'"
SQLteam2 = "SELECT Player FROM PlayerList where Team='" & Ucase(Request.QueryString("team2")) & "'"
Set RS = Conn.Execute(SQLteam1)
Set RS2 = Conn.Execute(SQLteam2)
'Set RS = Conn.Execute("SELECT Week, Date FROM WeekList")
%>

<form name="enterscores" action="review.asp" method="GET" onSubmit="return validateFields()">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="team1" value="<%= request.querystring("team1") %>">
<input type="Hidden" name="team2" value="<%= request.querystring("team2") %>">
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("team1") %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>
		</tr>
		<tr>
		    <td>
			<font color="Green">Player 1:</font><select name="player1a" size="1">
		   <% Do While Not RS.EOF %>
		   		<option value="<%  = RS("Player") %>"><%  = RS("Player") %>
		   <% RS.MoveNext
		   Loop
		   %>
		   </select>
		   </td>
		    <td align="right"><input type="Text" name="p1ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2a" size="1">
			<% Set RS = Conn.Execute(SQLteam1) %>	
		   <% Do While Not RS.EOF %>
		   		<option value="<%  = RS("Player") %>"><%  = RS("Player") %>
		   <% RS.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p2ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3a" size="1">
			<% Set RS = Conn.Execute(SQLteam1) %>	
		   <% Do While Not RS.EOF %>
		   		<option value="<%  = RS("Player") %>"><%  = RS("Player") %>
		   <% RS.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p3ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 4:</font><select name="player4a" size="1">
			<% Set RS = Conn.Execute(SQLteam1) %>	
		   <% Do While Not RS.EOF %>
		   		<option value="<%  = RS("Player") %>"><%  = RS("Player") %>
		   <% RS.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p4ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p4apoints" size="3" maxlength="3"></td>	
		</tr>
		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("team2") %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>	
		</tr>
		<tr>
		    <td><font color="Green">Player 1:</font><select name="player1b" size="1">
		   <% Do While Not RS2.EOF %>
		   		<option value="<%  = RS2("Player") %>"><%  = RS2("Player") %>
		   <% RS2.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p1bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1bpoints" size="3" maxlength="3"></td>
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2b" size="1">
			<% Set RS2 = Conn.Execute(SQLteam2) %>	
		   <% Do While Not RS2.EOF %>
		   		<option value="<%  = RS2("Player") %>"><%  = RS2("Player") %>
		   <% RS2.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p2bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3b" size="1">
			<% Set RS2 = Conn.Execute(SQLteam2) %>	
		   <% Do While Not RS2.EOF %>
		   		<option value="<%  = RS2("Player") %>"><%  = RS2("Player") %>
		   <% RS2.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p3bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>  
		    <td><font color="Green">Player 4:</font><select name="player4b" size="1">
			<% Set RS2 = Conn.Execute(SQLteam2) %>	
		   <% Do While Not RS2.EOF %>
		   		<option value="<%  = RS2("Player") %>"><%  = RS2("Player") %>
		   <% RS2.MoveNext
		   Loop
		   %>
		   </select></td>
		    <td align="right"><input type="Text" name="p4bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p4bpoints" size="3" maxlength="3"></td>	
		</tr>
		</table>
	</td>
</tr>
</table>
<% RS.Close
Conn.Close
%>
<br> 
<center><input type="Submit" name="submit" value="Submit Scores"> <input type="reset"></center></form>
<br><br>
<form name="subscores" action="subscores.asp" method="GET">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="team1" value="<%= request.querystring("team1") %>">
<input type="Hidden" name="team2" value="<%= request.querystring("team2") %>">
<font color="Navy">Note:</font>  <font color="green">If you used a sub, or had a no-show, click "Sub Scores" for a different form.</font><br>
<input type="Submit" name="subscores" value="Sub Scores">
</form>
</BODY>
</HTML>
