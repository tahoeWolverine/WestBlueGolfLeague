<!-- #include virtual="/westblue/settings.asp" -->
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual InterDev 1.0">
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">

<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Nannette Thacker -->
<!-- http://www.shiningstar.net -->
<!-- Begin
function checkNumeric(objName,minval, maxval,comma,period,hyphen)
{
	var numberfield = objName;
	if (chkNumeric(objName,minval,maxval,comma,period,hyphen) == false)
	{
		numberfield.select();
		numberfield.focus();
		return false;
	}
	else
	{
		return true;
	}
}

function chkNumeric(objName,minval,maxval,comma,period,hyphen)
{
// only allow 0-9 be entered, plus any values passed
// (can be in any order, and don't have to be comma, period, or hyphen)
// if all numbers allow commas, periods, hyphens or whatever,
// just hard code it here and take out the passed parameters
var checkOK = "0123456789" + comma + period + hyphen;
var checkStr = objName;
var allValid = true;
var decPoints = 0;
var allNum = "";

for (i = 0;  i < checkStr.value.length;  i++)
{
ch = checkStr.value.charAt(i);
for (j = 0;  j < checkOK.length;  j++)
if (ch == checkOK.charAt(j))
break;
if (j == checkOK.length)
{
allValid = false;
break;
}
if (ch != ",")
allNum += ch;
}
if (!allValid)
{	
alertsay = "Please enter only these values \""
alertsay = alertsay + checkOK + "\" in the \"" + checkStr.name + "\" field."
alert(alertsay);
return (false);
}

// set the minimum and maximum
var chkVal = allNum;
var prsVal = parseInt(allNum);
if (chkVal != "" && !(prsVal >= minval && prsVal <= maxval))
{
alertsay = "Please enter a value greater than or "
alertsay = alertsay + "equal to \"" + minval + "\" and less than or "
alertsay = alertsay + "equal to \"" + maxval + "\" in the \"" + checkStr.name + "\" field."
alert(alertsay);
return (false);
}
}

//  End -->

function validateFormOnSubmit(theForm)
{
	var reason="";

	reason += validateEmpty(theForm.player1a);
	reason += validateEmpty(theForm.player2a);
	reason += validateEmpty(theForm.player3a);
	reason += validateEmpty(theForm.player4a);
	reason += validateEmpty(theForm.player1b);
	reason += validateEmpty(theForm.player2b);
	reason += validateEmpty(theForm.player3b);
	reason += validateEmpty(theForm.player4b);
	reason += validateEmpty(theForm.p1ascore);
	reason += validateEmpty(theForm.p2ascore);
	reason += validateEmpty(theForm.p3ascore);
	reason += validateEmpty(theForm.p4ascore);
	reason += validateEmpty(theForm.p1bscore);
	reason += validateEmpty(theForm.p2bscore);
	reason += validateEmpty(theForm.p3bscore);
	reason += validateEmpty(theForm.p4bscore);
	reason += validateEmpty(theForm.p1apoints);
	reason += validateEmpty(theForm.p2apoints);
	reason += validateEmpty(theForm.p3apoints);
	reason += validateEmpty(theForm.p4apoints);
	reason += validateEmpty(theForm.p1bpoints);
	reason += validateEmpty(theForm.p2bpoints);
	reason += validateEmpty(theForm.p3bpoints);
	reason += validateEmpty(theForm.p4bpoints);

	if (reason != "") {
		alert("Some fields need correction:\n" + reason);
		return false;
	}
	return true;
}

function validateEmpty(fld) 
{
	var error="";

	if (fld.value.length == 0) {
		fld.style.background = 'Yellow';
		error = "The required field has not been filled in: " + fld.id + "\n";
	} else {
		fld.style.background = 'White';
	}
	return error;
}
</script>

<TITLE>Edit Scores</TITLE>
</HEAD>
<BODY bgcolor="white">
<%
Dim teamID1
Dim teamName1
Dim teamID2
Dim teamName2
Dim SQLQuery
Dim playerTeam1() '100
Dim playerTeam2()

Dim PlayerName1()
Dim PlayerName2()
Dim Score1()
Dim Score2()
Dim Points1()
Dim Points2()
Dim allPlayers()
Dim EditFlag

EditFlag = "n"
EditFlag = Request.QueryString("edit") 
Set Conn = Server.CreateObject("ADODB.Connection")
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

x = 0
y = 0
If EditFlag = "y" then
	SQLQuery = "SELECT PlayerName1, PlayerName2, Score1, Score2, Points1, Points2 FROM ResultsTable WHERE Week=" & request.querystring("Week") & " AND TeamID1='" & teamID1 & "' AND TeamID2='" & teamID2 & "'"
	Set RS = Conn.Execute(SQLQuery)
	Do While Not RS.EOF
		Redim preserve PlayerName1(x)
		PlayerName1(x) = RS("PlayerName1")
		Redim preserve PlayerName2(x)
		PlayerName2(x) = RS("PlayerName2")
		Redim preserve Score1(x)
		Score1(x) = RS("Score1")
		Redim preserve Score2(x)
		Score2(x) = RS("Score2")
		Redim preserve Points1(x)
		Points1(x) = RS("Points1")
		Redim preserve Points2(x)
		Points2(x) = RS("Points2")
		x = x + 1
		RS.MoveNext
	Loop
	Set RS=Nothing
	x = 0
else

	sqlQuery = "SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID1 & "' ORDER BY PlayerName"
	Set RS = Conn.Execute(sqlQuery)
	Do While Not RS.EOF
		Redim preserve playerTeam1(x)
		playerTeam1(x) = RS("PlayerName")
		x=x+1
	RS.MoveNext
	Loop
	Set RS=Nothing

	sqlQuery = "SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID2 & "' ORDER BY PlayerName"
	Set RS = Conn.Execute(sqlQuery)
	Do While Not RS.EOF	
		Redim preserve playerTeam2(y)
		playerTeam2(y) = RS("PlayerName")
		y=y+1
	RS.MoveNext
	Loop
	Set RS=Nothing

end if

Redim preserve playerTeam1(x)
playerTeam1(x) = "xx No Show xx"
x=x+2
sqlQuery = "SELECT PlayerName FROM PlayerTable ORDER BY PlayerName"
Set RS = Conn.Execute(sqlQuery)
Do While Not RS.EOF
	Redim preserve playerTeam1(x)
	playerTeam1(x) = RS("PlayerName")
	x=x+1
RS.MoveNext	
Loop
Set RS=Nothing

Redim preserve playerTeam2(y)
playerTeam2(y) = "xx No Show xx"
y=y+2
sqlQuery = "SELECT PlayerName FROM PlayerTable ORDER BY PlayerName"
Set RS = Conn.Execute(sqlQuery)
Do While Not RS.EOF	'200
	Redim preserve playerTeam2(y)
	playerTeam2(y) = RS("PlayerName")
	y=y+1
RS.MoveNext
Loop
Set RS=Nothing
x = 0
y = 0
Conn.Close

%>
<center><h2><font color="Green"><% if EditFlag = "y" then response.write("Edit") else response.write("Enter") end if %> Scores</font></h2></center>
<form name="enterscores" onsubmit="return validateFormOnSubmit(this)" action="review.asp" method="GET">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="teamID1" value="<%= teamID1 %>">
<input type="Hidden" name="match" value="<%= Request.QueryString("match") %>">
<input type="Hidden" name="teamID2" value="<%= teamID2 %>">
<input type="Hidden" name="edit" value="<%= EditFlag %>">
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= TeamName1 %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>
		</tr>
<% Dim y
for y = 0 to 3 %>
		<tr>
		    <td>
			<font color="Green">Player <%= y+1 %>:</font><select id="Player<%= y+1%>" name="player<%= y+1%>a" size="1">

			<% 	i = 0
				For i = 0 to UBound(playerTeam1) %>
					<option value="<%= playerTeam1(i) %>"
					<% if EditFlag = "y" then %>
						<% if playerTeam1(i) = PlayerName1(y) then Response.write(" Selected") end if %>
					<% end if %>
					><%= playerTeam1(i) %>
			<%	next %>
		   </select>
		   </td>
		    <td align="right"><input id="Player<%= y+1%>Score" onBlur="checkNumeric(this,0,100,'','','');" type="Text" name="p<%= y+1%>ascore" size="3" maxlength="3" value="<% if EditFlag = "y" then response.write(CInt(Score1(y))) end if %>"></td>
		    <td align="right"><input id="Player<%= y+1%>Points" onBlur="checkNumeric(this,0,24,'','','');" type="Text" name="p<%= y+1%>apoints" size="3" maxlength="3" value="<%  if EditFlag = "y" then response.write(CInt(Points1(y))) end if %>"></td>	
		</tr>
<% next %>

		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= TeamName2 %></font></th>
			<th align="center"><font color="Navy">Score</font></th>
			<th align="center"><font color="Navy">Points</font></th>	
		</tr>
<% y = 0
for y = 0 to 3 %>
		<tr>
		    <td><font color="Green">Player <%= y + 1 %>:</font><select id="Player<%= y+1%>" name="player<%= y+1%>b" size="1">

			<% 	i = 0
				For i = 0 to UBound(playerTeam2) %>
					<option value="<%= playerTeam2(i) %>"
					<% if EditFlag = "y" then %>
						<% if playerTeam2(i) = PlayerName2(y) then Response.write(" Selected") end if %>
					<% end if %>
					><%= playerTeam2(i) %>
			<%	next %>
		   </select></td>
		    <td align="right"><input id="Player<%= y+1%>Score" onBlur="checkNumeric(this,0,100,'','','');" type="Text" name="p<%= y+1%>bscore" size="3" maxlength="3" value="<% if EditFlag = "y" then response.write(CInt(Score2(y))) end if  %>"></td>
		    <td align="right"><input id="Player<%= y+1%>Points" onBlur="checkNumeric(this,0,24,'','','');" type="Text" name="p<%= y+1%>bpoints" size="3" maxlength="3" value="<% if EditFlag = "y" then response.write(CInt(Points2(y))) end if  %>"></td>
		</tr>
<% next %>
		</table>
	</td>
</tr>
</table>

<br> 
<center><input type="Submit" name="submit" value="Submit Scores"> <input type="reset"></center></form>
<center><h3><font color="Green">Note: If your match had a "No Show" or a "Non-League Sub", select "xx No Show xx", set Score to 99 and Points to 0.</font></h3></center>


</BODY>
</HTML>

