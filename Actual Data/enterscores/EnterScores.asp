<!-- #include virtual="/westblue/settings.asp" -->
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
	
	//RC = validPlayers()
	//if (RC == false)
	//{
	//	return false
	//}
	
	//for (x = 4; x <= 25; x = x+3)
	//{
		//RC = validateScores(x)
		//if (RC == false) 
		//{
			//return false
		//}
	//}
	
	//for (x = 5; x <= 26; x = x+3)
	//{
		//RC = validatePoints(x)
		//if (RC == false) 
	//	{
			//return false
		//}
	//}
	//return true
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

//	for (var i = 0; i < theScore.length; i++)
//	{
//		theChar = theScore.charAt(i)
//		if (!isDigit(theChar))
//		{
//			alert("Your score can only contain digits.")
//			document.enterscores.elements[index].focus()
//			document.enterscores.elements[index].select()
//			return false	
//		}
//	}
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
<%
Dim teamID1
Dim teamName1
Dim playerTeam1()
Dim teamID2
Dim teamName2
Dim playerTeam2()
Dim SQLQuery

Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
SQLQuery = "SELECT TeamID1, TeamID2 FROM MatchTable where MatchID='" & Request.QueryString("match") & "'"
Set RS = Conn.Execute(SQLQuery)
teamID1 = RS("TeamID1")
teamID2 = RS("TeamID2")
Set RS=Nothing

sqlQuery = "SELECT TeamName FROM TeamTable WHERE TeamID='" & TeamID1 & "'" 
Set RS = Conn.Execute(sqlQuery)
teamName1 = RS("TeamName")
Set RS=Nothing

sqlQuery = "SELECT TeamName FROM TeamTable WHERE TeamID='" & TeamID2 & "'"
Set RS = Conn.Execute(sqlQuery)
teamName2 = RS("TeamName")
Set RS=Nothing

sqlQuery = "SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID1 & "' ORDER BY PlayerName"
Set RS = Conn.Execute(sqlQuery)
x = 0
Do While Not RS.EOF
	Redim preserve playerTeam1(x)
	playerTeam1(x) = RS("PlayerName")
	x=x+1
RS.MoveNext
Loop
Set RS=Nothing

sqlQuery = "SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID2 & "' ORDER BY PlayerName"
Set RS = Conn.Execute(sqlQuery)
x = 0
Do While Not RS.EOF	
	Redim preserve playerTeam2(x)
	playerTeam2(x) = RS("PlayerName")
	x=x+1
RS.MoveNext
Loop
Set RS=Nothing
Conn.Close
%>
<center><h2><font color="Green">Input Scores</font></h2></center>
<br><br>
<form name="subscores" action="subscores.asp" method="GET">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="teamID1" value="<%= teamID1 %>">
<input type="Hidden" name="teamID2" value="<%= teamID2 %>">
<input type="Hidden" name="teamName1" value="<%= teamName1 %>">
<input type="Hidden" name="teamName2" value="<%= teamName2 %>">
<input type="Hidden" name="match" value="<%= Request.QueryString("match") %>">
<font color="Navy">Note:</font>  <font color="green">If you used a sub from another team in the league, or had a no-show, click "Sub Scores" for a different form.</font><br>
<input type="Submit" name="subscores" value="Sub Scores">
</form>
<br><br>
<font color="Navy">Note:</font>  <font color="green">If you used a sub from another league, select "Non-Leauge Sub" as the player.</font><br>

<form name="enterscores" action="review.asp" method="GET" onSubmit="return validateFields()">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="teamID1" value="<%= teamID1 %>">
<input type="Hidden" name="match" value="<%= Request.QueryString("match") %>">
<input type="Hidden" name="teamID2" value="<%= teamID2 %>">
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= TeamName1 %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>
		</tr>
		<tr>
		    <td>
			<font color="Green">Player 1:</font><select name="player1a" size="1">
		   <% for i = 0 to UBound(playerTeam1) %>
		   		<option value="<%= playerTeam1(i) %>"><%= playerTeam1(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select>
		   </td>
		    <td align="right"><input type="Text" name="p1ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2a" size="1">
		   <% for i = 0 to UBound(playerTeam1) %>
		   		<option value="<%= playerTeam1(i) %>"><%= playerTeam1(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p2ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3a" size="1">
		   <% for i = 0 to UBound(playerTeam1) %>
		   		<option value="<%= playerTeam1(i) %>"><%= playerTeam1(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p3ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 4:</font><select name="player4a" size="1">
		   <% for i = 0 to UBound(playerTeam1) %>
		   		<option value="<%= playerTeam1(i) %>"><%= playerTeam1(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p4ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p4apoints" size="3" maxlength="3"></td>	
		</tr>
		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= TeamName2 %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>	
		</tr>
		<tr>
		    <td><font color="Green">Player 1:</font><select name="player1b" size="1">
		   <% for i = 0 to UBound(playerTeam2) %>
		   		<option value="<%= playerTeam2(i) %>"><%= playerTeam2(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p1bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1bpoints" size="3" maxlength="3"></td>
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2b" size="1">
		   <% for i = 0 to UBound(playerTeam2) %>
		   		<option value="<%= playerTeam2(i) %>"><%= playerTeam2(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p2bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3b" size="1">
		   <% for i = 0 to UBound(playerTeam2) %>
		   		<option value="<%= playerTeam2(i) %>"><%= playerTeam2(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p3bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>  
		    <td><font color="Green">Player 4:</font><select name="player4b" size="1">
		   <% for i = 0 to UBound(playerTeam2) %>
		   		<option value="<%= playerTeam2(i) %>"><%= playerTeam2(i) %>
		   <% next %>
		   <option value="Non-League Sub">Non-League Sub
		   </select></td>
		    <td align="right"><input type="Text" name="p4bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p4bpoints" size="3" maxlength="3"></td>	
		</tr>
		</table>
	</td>
</tr>
</table>

<br> 
<center><input type="Submit" name="submit" value="Submit Scores"> <input type="reset"></center></form>

</BODY>
</HTML>

