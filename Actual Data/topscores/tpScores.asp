<!-- #include virtual="/westblue/settings.asp" -->
<%
Dim strYear
strYear = Request("Year")
%>

<HTML>
<HEAD>
	<TITLE>West Blue Golf - <%= strYear %> Top Scores</TITLE>
</HEAD>

<BODY bgcolor="white">
<center>
<% PageFooter "tpScores", "Top Scores" %>
</center>
<h2><center><font color="Green"><% Response.write(strYear & " Top 25 Scores")%></font></center></h2>
<!--<center><a href="tpscores99.htm">1999 Top Scores</a></center><br>
<center><a href="tpscores98.html">1998 Top Scores</a></center><br>
<center><a href="tpscores97.html">1997 Top Scores</a></center>-->
<br>
<%
Dim TopScores ()
Dim TopPlayers ()
Dim TopWeeks ()
Dim strCourseArray ()
Dim j
Dim x
Dim temp
Dim TotalScores

j = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr

SQL1 = "SELECT Week, PlayerName1, Score1 FROM ResultsTable ORDER BY Score1" 
Set RS = Conn.Execute(SQL1)
SQL2 = "SELECT Week, PlayerName2, Score2 FROM ResultsTable ORDER BY Score2"
Set RS2 = Conn.Execute(SQL2)

Do While Not RS.EOF 
	if RS("Week") > 0 Then
	 	ReDim Preserve TopScores(j)
		ReDim Preserve TopPlayers(j)
		ReDim Preserve TopWeeks(j)
		TopScores(j) = TopScores(j) + RS("Score1")
		TopPlayers(j) = RS("PlayerName1")
		TopWeeks(j) = RS("Week")
		j = j + 1
	End If
   	RS.MoveNext 
Loop

Do While Not RS2.EOF
	if RS2("Week") > 0 Then
		ReDim Preserve TopScores(j)
		ReDim Preserve TopPlayers(j)
		ReDim Preserve TopWeeks(j)
		TopScores(j) = TopScores(j) + RS2("Score2")
		TopPlayers(j) = RS2("PlayerName2")
		TopWeeks(j) = RS2("Week")
		j = j + 1
	End If
   	RS2.MoveNext
Loop 

if int(strYear) >= 2009 then
	' Read in course array, this only works from 2009 forward
	j = 0
	SQL1 = "Select Course, Week FROM WeekTable ORDER BY Week"
	Set RS = Conn.Execute(SQL1)
	Do While Not RS.EOF 
		if RS("Week") > 0 Then
			ReDim Preserve strCourseArray(j)
			strCourseArray(j) = RS("Course")
			j = j + 1
		End If
   		RS.MoveNext 
	Loop
end if

RS.Close 
RS2.Close

Conn.Close
if j = 0 then
	Response.Write("No Scores Have Been Entered Yet</body></html>")
	Response.End
end if

' Sort the TopScores Array 
j = UBound(TopScores)
TotalScores = j
j = j - 1
do while (j >= 0)
	x = 0
	do while (x <= j)
 		if (TopScores(x) > TopScores(x+1)) then
 			temp = TopScores(x)
			TopScores(x) = TopScores(x+1)
			TopScores(x+1) = temp
			temp = TopPlayers(x)
			TopPlayers(x) = TopPlayers(x+1)
			TopPlayers(x+1) = temp
			temp = TopWeeks(x)
			TopWeeks(x) = TopWeeks(x+1)
			TopWeeks(x+1) = temp
		end if
 		x=x+1 
	loop
	j = j - 1	
loop
%>
<table width="75%%">
<tr>
	<th align="left"><font color="Navy">Player</font></th>
	<th><font color="Navy">Score</font></th>
	<th><font color="Navy">Week</font></th>
	<% if int(strYear) >= 2009 then %>
	<th><font color="Navy">Course</font></th>
	<% end if %>
</tr>
<% 	If TotalScores > 24 Then
		TotalScores = 24
	End IF
For j = 0 to TotalScores %>
<tr>
	<td align="left"><font color="Green"><%= TopPlayers(j) %></font></td>
	<td align="center"><font color="Green"><%= TopScores(j) %></font></td>
	<td align="center"><font color="Green"><%= TopWeeks(j) %></font></td>
	<% if int(strYear) >= 2009 then %>
	<td align="center"><font color="Green"><%= strCourseArray(TopWeeks(j)- 1) %></font></td>
	<% end if %>
</tr>
<% Next %>
</table>
<br>
</BODY>
</HTML>