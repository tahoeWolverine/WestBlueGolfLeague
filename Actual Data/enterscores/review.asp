<%
Dim p1apoints
Dim p2apoints
Dim p3apoints
Dim p4apoints

Dim p1bpoints
Dim p2bpoints
Dim p3bpoints
Dim p4bpoints

Dim p1ascore
Dim p2ascore
Dim p3ascore
Dim p4ascore

Dim p1bscore
Dim p2bscore
Dim p3bscore
Dim p4bscore

Dim player1a
Dim player2a
Dim player3a
Dim player4a

Dim player1b
Dim player2b
Dim player3b
Dim player4b

p1apoints = CINT(request.querystring("p1apoints"))
p2apoints = CINT(request.querystring("p2apoints"))
p3apoints = CINT(request.querystring("p3apoints"))
p4apoints = CINT(request.querystring("p4apoints"))

p1bpoints = CINT(request.querystring("p1bpoints"))
p2bpoints = CINT(request.querystring("p2bpoints"))
p3bpoints = CINT(request.querystring("p3bpoints"))
p4bpoints = CINT(request.querystring("p4bpoints"))

p1ascore = CINT(request.querystring("p1ascore"))
p2ascore = CINT(request.querystring("p2ascore"))
p3ascore = CINT(request.querystring("p3ascore"))
p4ascore = CINT(request.querystring("p4ascore"))

p1bscore = CINT(request.querystring("p1bscore"))
p2bscore = CINT(request.querystring("p2bscore"))
p3bscore = CINT(request.querystring("p3bscore"))
p4bscore = CINT(request.querystring("p4bscore"))

player1a = request.querystring("player1a") 
if player1a = "xx No Show xx" then
	p1apoints = 0
	p1ascore = 99
end if
player2a = request.querystring("player2a") 
if player2a = "xx No Show xx" then
	p2apoints = 0
	p2ascore = 99
end if
player3a = request.querystring("player3a") 
if player3a = "xx No Show xx" then
	p3apoints = 0
	p3ascore = 99
end if
player4a = request.querystring("player4a") 
if player4a = "xx No Show xx" then
	p4apoints = 0
	p4ascore = 99
end if

player1b = request.querystring("player1b") 
if player1b = "xx No Show xx" then
	p1bpoints = 0
	p1bscore = 99
end if
player2b = request.querystring("player2b") 
if player2b = "xx No Show xx" then
	p2bpoints = 0
	p2bscore = 99
end if
player3b = request.querystring("player3b") 
if player3b = "xx No Show xx" then
	p3bpoints = 0
	p3bscore = 99
end if
player4b = request.querystring("player4b")
if player4b = "xx No Show xx" then
	p4bpoints = 0
	p4bscore = 99
end if 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

<HTML>
<HEAD>
	<TITLE>West Blue Golf League - Review Scores</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green"><% If request.querystring("edit") = "y" then response.write("Edit") Else response.write("Enter") End If %> Scores</font></h2></center><br>
<center><h2><font color="Navy">Please verify your entries.</font></h2></center>
<br><br>
<b><font color="Navy">Week:</font>  <font color="Green"><%= request.querystring("week") %></font></b>
<table align="center" cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("team1") %></font></th>
			<th align="center"><font color="Navy"><%= (p1apoints + p2apoints + p3apoints + p4apoints) %></font></th>
			<th align="center"></th>	
		</tr>
		<tr>
		   	<td><font color="Navy">Player 1:</font> <font color="Green"><%= player1a %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p1ascore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p1apoints %></font></td>
		</tr>
		<tr>
		   	<td><font color="Navy">Player 2:</font> <font color="Green"><%= player2a %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p2ascore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p2apoints %></font></td>
		</tr>
		<tr>
		   	<td><font color="Navy">Player 3:</font> <font color="Green"><%= player3a %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p3ascore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p3apoints %></font></td>
		</tr>
		<tr>  
		    <td><font color="Navy">Player 4:</font> <font color="Green"><%= player4a %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p4ascore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p4apoints %></font></td>	
		</tr>
		</table>
	</td>
    <td>
		<table cellspacing="2" cellpadding="2">
		<tr>
		    <th align="center"><font color="Navy"><%= request.querystring("team2") %></font></th>
			<th align="center"><font color="Navy"><%= CInt(p1bpoints + p2bpoints + p3bpoints + p4bpoints) %></font></th>	
			<th align="center"></th>
		</tr>
		<tr>
		   	<td><font color="Navy">Player 1:</font> <font color="Green"><%= player1b %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p1bscore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p1bpoints %></font></td>
		</tr>
		<tr>
		   	<td><font color="Navy">Player 2:</font> <font color="Green"><%= player2b %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p2bscore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p2bpoints %></font></td>
		</tr>
		<tr>
		   	<td><font color="Navy">Player 3:</font> <font color="Green"><%= player3b %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p3bscore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p3bpoints %></font></td>
		</tr>
		<tr>  
		    <td><font color="Navy">Player 4:</font> <font color="Green"><%= player4b %></font></td>
		    <td><font color="Navy">Score:</font> <font color="Green"><%= p4bscore %></font></td>
		    <td><font color="Navy">Points:</font> <font color="Green"><%= p4bpoints %></font></td>	
		</tr>
		</table>
	</td>
</tr>
</table>
<form action="addscore.asp" method="GET">
<input type="Hidden" name="edit" value="<%= request.querystring("edit") %>">
<input type="Hidden" name="week" value="<%= request.querystring("week") %>">
<input type="Hidden" name="team1" value="<%= request.querystring("teamID1") %>">
<input type="Hidden" name="team2" value="<%= request.querystring("teamID2") %>">
<input type="Hidden" name="player1a" value="<%= player1a %>">
<input type="Hidden" name="p1ascore" value="<%= p1ascore %>">
<input type="Hidden" name="p1apoints" value="<%= p1apoints %>">
<input type="Hidden" name="player1b" value="<%= player1b %>">
<input type="Hidden" name="p1bscore" value="<%= p1bscore %>">
<input type="Hidden" name="p1bpoints" value="<%= p1bpoints %>">
<input type="Hidden" name="player2a" value="<%= player2a %>">
<input type="Hidden" name="p2ascore" value="<%= p2ascore %>">
<input type="Hidden" name="p2apoints" value="<%= p2apoints %>">
<input type="Hidden" name="player2b" value="<%= player2b %>">
<input type="Hidden" name="p2bscore" value="<%= p2bscore %>">
<input type="Hidden" name="p2bpoints" value="<%= p2bpoints %>">
<input type="Hidden" name="player3a" value="<%= player3a %>">
<input type="Hidden" name="p3ascore" value="<%= p3ascore %>">
<input type="Hidden" name="p3apoints" value="<%= p3apoints %>">
<input type="Hidden" name="player3b" value="<%= player3b %>">
<input type="Hidden" name="p3bscore" value="<%= p3bscore %>">
<input type="Hidden" name="p3bpoints" value="<%= p3bpoints %>">
<input type="Hidden" name="player4a" value="<%= player4a %>">
<input type="Hidden" name="p4ascore" value="<%= p4ascore %>">
<input type="Hidden" name="p4apoints" value="<%= p4apoints %>">
<input type="Hidden" name="player4b" value="<%= player4b %>">
<input type="Hidden" name="p4bscore" value="<%= p4bscore %>">
<input type="Hidden" name="p4bpoints" value="<%= p4bpoints %>">
<input type="Hidden" name="match" value="<%= Request.QueryString("match") %>">
<br><br>
<font color="Green">Press</font> <font color="Navy">Continue</font> <font color="Green">to accept your entries, or use your browser's back button to re-enter your scores.</font>
<br><br>
<input type="Submit" name="Submit" value="Continue">
<br>

</form>

</BODY>
</HTML>
