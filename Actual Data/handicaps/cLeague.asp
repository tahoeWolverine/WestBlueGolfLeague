<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables
	Dim Handicap 
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim PlayerArray ()
	Dim PointsArray ()
	Dim TeamArray ()
	Dim TeamIDArray ()
	Dim i
	Dim j
	Dim x
	Dim y
	Dim index
	Dim Found
	Dim strYear
	strYear = Request("Year")
	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
%>
<HTML>
<HEAD>
	<TITLE><%= strYear %> League Handicaps</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green"><% Response.write(strYear & " League Handicaps")%></font></h2></center>
<center><font color="Green"><% Response.write("Current as of: " & date)%></font></center>
<!--#include file="handicap.asp"-->
<%
Dim ColCount
Dim Team
Dim TeamID
ColCount = 1
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
Set RS = Conn.Execute("SELECT TeamName,TeamID FROM TeamTable")
j = 0
Do While Not RS.EOF
	ReDim Preserve TeamArray(j)
	TeamArray (j) = RS("TeamName")
	ReDim Preserve TeamIDArray(j)
	TeamIDArray (j) = RS("TeamID")
	j = j + 1
	RS.MoveNext
Loop
RS.Close
Conn.Close
%>
<table cellspacing="2" cellpadding="2" width="100%">
<tr>
<% For z = 0 to UBound(TeamArray) %>
	<% Team = TeamArray(z) %>
	<% TeamID = TeamIDArray(z) %>
	<% If (ColCount <= 3) Then %>
	    <td valign="top">
			<b><font color="Navy"><%= Team %></font></b>
			<%
			Set Conn = Server.CreateObject("ADODB.Connection")
			'Conn.Open odbcName(strYear)
			Conn.Open connectstr			
			Set RS1 = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID & "'")
			j = 0
			Do While Not RS1.EOF
				ReDim Preserve PlayerArray(j)
				PlayerArray (j) = RS1("PlayerName")
				j = j + 1
				RS1.MoveNext
			Loop
			RS1.Close
			Conn.Close
			%>
			<table>
			<% For x = 0 to UBound(PlayerArray) %>
				
				<% 	Handicap = CalcHandicap(PlayerArray(x), CInt(strYear)) %>
	
				<tr>
				    <td align="left"><font color="Green"><%= PlayerArray(x) %></font>&nbsp;&nbsp;&nbsp; </td>
					<td align="right">
					<font color="Navy"><%= Handicap %></font>
					</td>
				</tr>
			<% Next %>
			</table>
		</td>
		<% ColCount = ColCount + 1 %>
	<% Else  %>
	<% 	ColCount = 1 %>
		</tr>
		<tr>		
	    <td valign="top">
			<b><font color="Navy"><%= Team %></font></b>
			<%
			Set Conn = Server.CreateObject("ADODB.Connection")
			'Conn.Open odbcName(strYear)
			Conn.Open connectstr			
			Set RS1 = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & TeamID & "'")
			j = 0
			Do While Not RS1.EOF
				ReDim Preserve PlayerArray(j)
				PlayerArray (j) = RS1("PlayerName")
				j = j + 1
				RS1.MoveNext
			Loop
			RS1.Close
			Conn.Close			
			%>
			<table>
			<% For x = 0 to UBound(PlayerArray) %>

				<% 	Handicap = CalcHandicap(PlayerArray(x), CInt(strYear)) %>

				<tr>
				    <td align="left"><font color="Green"><%= PlayerArray(x) %></font>&nbsp;&nbsp;&nbsp;</td>
					<td align="right">
					<font color="Navy"><%= Handicap %></font>
					</td>
				</tr>
			<% Next %>
			</table>
		</td>
		<% ColCount = ColCount + 1 %>			
	<% End If %>
<% Next %>
</tr>
</table><br>


</BODY>
</HTML>