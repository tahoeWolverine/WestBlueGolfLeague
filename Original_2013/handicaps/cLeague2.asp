<% response.write "hello world"
response.end %>

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
	Dim strCopyYear
	strCopyYear = null
	strCopyYear = Request("CopyYear")
	Dim strYear
	strYear = Request("Year")
	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
	response.end
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
response.end
Dim ColCount
Dim Team
Dim TeamID
ColCount = 1
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
if strCopyYear = null then
	' if CopyYear is not valued establish connection to current years database to retrieve teams, players and handicaps
	connectstr = connectstr & odbcName(strYear) & ";"
else
	' else connect the CopyYear database to retrieve teams, players and handicaps
	connectstr = connectstr & odbcName(strCopyYear) & ";"
	%><center><h2><font color="Green"><% Response.write("Copying handicaps from: " & strCopyYear)%></font></h2></center><%
end if
Conn.Open connectstr
Set RS = Conn.Execute("SELECT TeamName,TeamID FROM TeamTable")
j = 0
' Get team information
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
response.end
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
			' Get players for each team
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
			<% For x = 0 to UBound(PlayerArray %>
				<% ' Get each players handicap
				Handicap = CalcHandicap(PlayerArray(x), CInt(strYear)) %>
	
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
			' Get each player
			Do While Not RS1.EOF
				ReDim Preserve PlayerArray(j)
				PlayerArray (j) = RS1("PlayerName")
				j = j + 1
				RS1.MoveNext
			Loop
			RS1.Close
			Conn.Close	
			
			'if strCopyYear = null then
				' Over ride Year in order to retrieve handicaps for previous year
				'strYear = strCopyYear
				' Connect to this years database
				'Set Conn2 = Server.CreateObject("ADODB.Connection")
				'connectstr2 = ""
				'connectstr2 = connectstr2 & odbcName(strYear) & ";"
				'Conn2.Open connectstr2
				'Conn2.close
			'end if
					
			%>
			<table>
			<% For x = 0 to UBound(PlayerArray) %>
				<% ' Get each players handicap
				Handicap = CalcHandicap(PlayerArray(x), CInt(strYear)) %>

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
<% Next 
'Conn2.close
%>
</tr>
</table><br>


</BODY>
</HTML>