<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<%	'Global Variables
	Dim TeamAArray ()
	Dim TeamBArray ()
	Dim TotalPointsAArray()
	Dim TotalPointsBArray()
	Dim WeeksAArray()
	Dim WeeksBArray()
	Dim AverageAArray()
	Dim AverageBArray()
	Dim PlayerCount
	Dim remainder
	Dim j
	Dim z
	Dim x
	Dim TotalScores
	Dim Team
%>
<HTML>
<HEAD>
	<TITLE>West Blue Golf League - 1999 Standings</TITLE>
</HEAD>

<BODY bgcolor="white"> 
<center><h2><font color="Green">1999 Standings</font></h2></center>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open "golf99"
Set RSA = Conn.Execute("SELECT TeamName,TeamID FROM TeamTable WHERE Division='A'")
Set RSB = Conn.Execute("SELECT TeamName,TeamID FROM TeamTable WHERE Division='B'")
j = 0
Do While Not RSA.EOF
	ReDim Preserve TotalPointsAArray(j)
	ReDim Preserve WeeksAArray(j)
	ReDim Preserve AverageAArray(j)
	TotalScores = 0
	PlayerCount = 0
	ReDim Preserve TeamAArray(j)
	TeamAArray (j) = RSA("TeamID")
	Set RS1 = Conn.Execute("SELECT Points1 FROM ResultsTable WHERE TeamID1='" & TeamAArray(j) & "'")	
	Do While Not RS1.EOF
		TotalPointsAArray(j) = TotalPointsAArray(j) + RS1("Points1")
		TotalScores = TotalScores + 1
		RS1.MoveNext
	Loop %>
<% 	Set RS2 = Conn.Execute("SELECT Points2 FROM ResultsTable WHERE TeamID2='" & TeamAArray(j) & "'")	
	Do While Not RS2.EOF
		TotalPointsAArray(j) = TotalPointsAArray(j) + RS2("Points2")
		TotalScores = TotalScores + 1
		RS2.MoveNext
	Loop
	Set RS = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamAArray(j) & "'")
	Do While Not RS.EOF
		PlayerCount = PlayerCount + 1
		RS.MoveNext
	Loop %>
	<% WeeksAArray(j) = (TotalScores - PlayerCount) \ 4
	   remainder = ((TotalScores - PlayerCount) / 4)- ((TotalScores - PlayerCount) \ 4) %>
	<% if (remainder > 0) then %>
	<% 		WeeksAArray(j) = WeeksAArray(j) + 1 %>
	<% end if %>
	<% If (WeeksAArray(j) = 0) then
		AverageAArray(j) = 0
	   Else
		AverageAArray(j) = TotalPointsAArray(j) / WeeksAArray(j)
	   End If 
	j = j + 1
	RSA.MoveNext
Loop
%>
<%
RS.Close
RS2.Close
RS1.Close
j = 0
Do While Not RSB.EOF
	ReDim Preserve TotalPointsBArray(j)
	ReDim Preserve WeeksBArray(j)
	ReDim Preserve AverageBArray(j)
	TotalScores = 0
	PlayerCount = 0
	ReDim Preserve TeamBArray(j)
	TeamBArray (j) = RSB("TeamID")
	Set RS1 = Conn.Execute("SELECT Points1 FROM ResultsTable WHERE TeamID1='" & TeamBArray(j) & "'")	
	Do While Not RS1.EOF
		TotalPointsBArray(j) = TotalPointsBArray(j) + RS1("Points1")
		TotalScores = TotalScores + 1
		RS1.MoveNext
	Loop %>
<% 	Set RS2 = Conn.Execute("SELECT Points2 FROM ResultsTable WHERE TeamID2='" & TeamBArray(j) & "'")	
	Do While Not RS2.EOF
		TotalPointsBArray(j) = TotalPointsBArray(j) + RS2("Points2")
		TotalScores = TotalScores + 1
		RS2.MoveNext
	Loop
	Set RS = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamBArray(j) & "'")
	Do While Not RS.EOF
		PlayerCount = PlayerCount + 1
		RS.MoveNext
	Loop %>
	<% WeeksBArray(j) = (TotalScores - PlayerCount) \ 4
	   remainder = ((TotalScores - PlayerCount) / 4)- ((TotalScores - PlayerCount) \ 4) %>
	<% if (remainder > 0) then %>
	<% 		WeeksBArray(j) = WeeksBArray(j) + 1 %>
	<% end if %>
	<% If (WeeksBArray(j) = 0) then
		AverageBArray(j) = 0
	   Else
		AverageBArray(j) = TotalPointsBArray(j) / WeeksBArray(j)
	   End If 
	j = j + 1
	RSB.MoveNext
Loop %>
<%
RS.Close
RS2.Close
RS1.Close
RSB.Close
Conn.Close
%>
<% ' Sort the AArrays based on the Average 
j = UBound(AverageAArray)
j = j - 1
do while (j >= 0) %>
<%	x = 0
	do while (x <= j) %>
<% 		if (AverageAArray(x) > AverageAArray(x+1)) then %>
<% 			temp = AverageAArray(x)
			AverageAArray(x) = AverageAArray(x+1)
			AverageAArray(x+1) = temp
			temp = TotalPointsAArray(x)
			TotalPointsAArray(x) = TotalPointsAArray(x+1)
			TotalPointsAArray(x+1) = temp
			temp = WeeksAArray(x)
			WeeksAArray(x) = WeeksAArray(x+1)
			WeeksAArray(x+1) = temp
			temp = TeamAArray(x)
			TeamAArray(x) = TeamAArray(x+1)
			TeamAArray(x+1) = temp
		end if
 		x=x+1 
	loop
	j = j - 1	
loop
%>


<% ' Sort the BArrays based on the Average 
j = UBound(AverageBArray)
j = j - 1
do while (j >= 0) %>
<%	x = 0
	do while (x <= j) %>
<% 		if (AverageBArray(x) > AverageBArray(x+1)) then %>
<% 			temp = AverageBArray(x)
			AverageBArray(x) = AverageBArray(x+1)
			AverageBArray(x+1) = temp
			temp = TotalPointsBArray(x)
			TotalPointsBArray(x) = TotalPointsBArray(x+1)
			TotalPointsBArray(x+1) = temp
			temp = WeeksBArray(x)
			WeeksBArray(x) = WeeksBArray(x+1)
			WeeksBArray(x+1) = temp
			temp = TeamBArray(x)
			TeamBArray(x) = TeamBArray(x+1)
			TeamBArray(x+1) = temp
		end if
 		x=x+1 
	loop
	j = j - 1	
loop %>

<table cellspacing="8" cellpadding="5" width="100%">

<tr>
    <td>		
		<table>
			<tr>
			    <td>
					<b><font color="Navy">Division A</font></b>
				</td>
				<td>
					<b><font color="Navy">Pts</font></b>
				</td>
			    <td>
					<b><font color="Navy">Wks</font></b>
				</td>
			    <td>
					<b><font color="Navy">Avg</font></b>
				</td>
			</tr>
			<%
			Set Conn = Server.CreateObject("ADODB.Connection")
			Conn.Open "golf99"
			%>
			<% For z = UBound(TeamAArray) to 0 step - 1 %>
				<% Team = TeamAArray(z) %>
				<tr>
			    <td valign="top">
					<%	Set RSA = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & team & "'") %>
					
					<b><font color="Green"><%= RSA("TeamName") %></font></b>
					<% RSA.Close %>
				</td>
				<td align="center">
					<font color="Navy"><%= TotalPointsAArray(z) %></font>
				</td>
				<td align="center">
					<font color="Navy"><%= WeeksAArray(z) %></font>
				</td>
				<td>
					<font color="Navy"><%= FormatNumber(AverageAArray(z),2) %></font>
				</td>						
				</tr>
			<% Next %>
		</table>
	</td>
    <td valign="top">
		<table>
			<tr>
			    <td>
					<b><font color="Navy">Division B</font></b>
				</td>
				<td>
					<b><font color="Navy">Pts</font></b>
				</td>
			    <td>
					<b><font color="Navy">Wks</font></b>
				</td>
			    <td>
					<b><font color="Navy">Avg</font></b>
				</td>
			</tr>		
			<% For z = UBound(TeamBArray) to 0 step -1 %>
				<% Team = TeamBArray(z) %>
				<tr>
			    <td valign="top">
					<%	Set RSA = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & team & "'") %>
					
					<b><font color="Green"><%= RSA("TeamName") %></font></b>
					<% RSA.Close %>
				</td>
				<td align="center">
					<font color="Navy"><%= TotalPointsBArray(z) %></font>
				</td>
				<td align="center">
					<font color="Navy"><%= WeeksBArray(z) %></font>
				</td>
				<td>
					<font color="Navy"><%= FormatNumber(AverageBArray(z),2) %></font>
				</td>						
				</tr>
			<% Next %>
		</table>
	</td>
</tr>
</table>
<br><br>
<center><a href="stand98.htm">1998 Final Standings</a></center><br>
<center><a href="stand97.html">1997 Final Standings</a></center>
</BODY>
</HTML>