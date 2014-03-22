<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables
	Dim Handicap 
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim PlayerArray ()
	Dim PointsArray ()
	Dim i
	Dim j
	Dim x
	Dim y
	Dim index
	Dim Found
	Dim intWeekCount
	Dim strTeamName
	Dim strYear
	strYear = Request("Year")
	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
	%>
	
<HTML>
<HEAD>
	<TITLE>West Blue Golf - Calculate Team Handicap</TITLE>
</HEAD>

<BODY bgcolor="white"><br>
<!--#include file="handicap.asp"-->
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
Set RS = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & request("team") & "'")
strTeamName = RS("TeamName")
Set RS=Nothing
%>
<h2><center><font color="Green"><% Response.Write(strTeamName & " " & strYear & " Handicaps")%></font></center></h2>
<center><font color="Green"><% Response.write("Current as of: " & date)%></font></center>
<table cellspacing="5" cellpadding="2">
<tr align="center">
 	<td align="right"><b><font color="Navy">Week:</font></b> </td>
	<%
	Set RS1 = Conn.Execute("SELECT Week FROM WeekTable ORDER BY Week")
	%>
	<% DO While NOT RS1.EOF %>
	<td><b><font color="Navy"><%= RS1("Week") %></font></b></td>
	<% 	intWeekCount = intWeekCount + 1
		RS1.MoveNext
	   	Loop
	%>
	<td></td>
	<td><b><font color="Navy">Handicap</font></b></td>
	<td><b><font color="Navy">Weeks Used</font></b></td>
</tr>
<tr>
	<td align="right"><b><font color="Navy">Par:</font></b> </td>
<%
Set RS = Conn.Execute("SELECT Par FROM WeekTable ORDER BY Week")
%>
<% DO While NOT RS.EOF %>
<td><b><font color="Green"><%= RS("Par") %></font></b></td>
<% RS.MoveNext
   Loop
%>
<% RS.Close
   RS1.Close
Conn.Close
%>
	<td></td>
	<td></td>
</tr>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
Conn.Open connectstr
Set RS = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & Request.QueryString("team") & "'")
'Set RS = Conn.Execute("SELECT PlayerName FROM PlayerTable")
j = 0
Do While Not RS.EOF
	ReDim Preserve PlayerArray(j)
	PlayerArray (j) = RS("PlayerName")
	j = j + 1
	RS.MoveNext
Loop
RS.Close
Conn.Close
%>
<% For x = 0 to UBound(PlayerArray) %>
	<% For y = 0 to iScoresToEval - 1 %>
		<% WeeksUsed(y) = "" %>
	<% Next %>
	<% Handicap = 0 %>
	<% Handicap = CalcHandicap(PlayerArray(x), strYear) %>
	<tr>
	    <td align="right" nowrap><b><font color="Navy"><%= PlayerArray(x) %>: </font></b></td>
		<% For j = 0 to intWeekCount %>
			<% Found = "n" %>
			<% For i = 0 to UBound(WeekArray) %>
			<% 	if WeekArray(i) = j then %>
			<%  	Found = "y"%>
			<% 		index = i %>
			<% 		Exit For %>		
			<% 	End If %>
			<% Next %>
			<% if Found = "y" then %>
			<td><font color="Green"><%= ScoreArray(index) %></font></td>
			<% Else  %>
			<td></td>
			<% End If %>
		<% Next %>
		<td align="center"><font color="Navy"><b><%=	Handicap %></b></font></td>
		<td align="center" nowrap>
		<% For y = 0 to UBound(WeeksUsed) %>
			<font color="Green"><%= WeeksUsed(y) %></font>&nbsp;&nbsp;
		<% Next %>
		</td>
	</tr>
<% Next %>
</table>

</BODY>
</HTML>