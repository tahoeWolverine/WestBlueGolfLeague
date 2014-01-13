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
<center><h2><font color="Green">Input Sub Scores</font></h2></center>
<br><br>
<%
Dim playerNames()
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
SQLteam1 = "SELECT PlayerName FROM PlayerTable ORDER BY PlayerName"
Set RS = Conn.Execute(SQLteam1)
x = 0
Do While Not RS.EOF
	Redim preserve playerNames(x)
	playerNames(x) = RS("PlayerName")
	x=x+1
RS.MoveNext
Loop
RS.Close
Conn.Close
%>

<form name="enterscores" action="review.asp" method="GET" onSubmit="return validateFields()">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="teamID1" value="<%= request.querystring("teamID1") %>">
<input type="Hidden" name="teamID2" value="<%= request.querystring("teamID2") %>">
<input type="Hidden" name="match" value="<%= request.querystring("match") %>">
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("teamName1") %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>
		</tr>
		<tr>
		    <td>
			<font color="Green">Player 1:</font><select name="player1a" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select>
		   </td>
		    <td align="right"><input type="Text" name="p1ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2a" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX		   
		   </select></td>
		    <td align="right"><input type="Text" name="p2ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3a" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select></td>
		    <td align="right"><input type="Text" name="p3ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3apoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 4:</font><select name="player4a" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select></td>
		    <td align="right"><input type="Text" name="p4ascore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p4apoints" size="3" maxlength="3"></td>	
		</tr>
		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("teamName2") %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>	
		</tr>
		<tr>
		    <td><font color="Green">Player 1:</font><select name="player1b" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select></td>
		    <td align="right"><input type="Text" name="p1bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p1bpoints" size="3" maxlength="3"></td>
		</tr>
		<tr>
		    <td><font color="Green">Player 2:</font><select name="player2b" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select></td>
		    <td align="right"><input type="Text" name="p2bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p2bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>
		    <td><font color="Green">Player 3:</font><select name="player3b" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
		   </select></td>
		    <td align="right"><input type="Text" name="p3bscore" size="3" maxlength="3"></td>
		    <td align="right"><input type="Text" name="p3bpoints" size="3" maxlength="3"></td>	
		</tr>
		<tr>  
		    <td><font color="Green">Player 4:</font><select name="player4b" size="1">
			<% for i = 0 to UBound(playerNames) %>
				<option value="<%= playerNames(i) %>"><%= playerNames(i) %>
			<% next %>
		   <option value="xxxxxx">XXX No Show XXX
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
<br><br>
<font color="Navy">Directions:</font>
<font color="Green"><ol>
<li>Each player select box contains the entire league roster.  You should be able to find your sub.
<li>Your subs points will be applied to your teams totals.
<li>For No Shows select "xxx No Show xxx".
<li>For No Shows enter a score of 99 and 0 points.
</ol></font>
</BODY>
</HTML>
