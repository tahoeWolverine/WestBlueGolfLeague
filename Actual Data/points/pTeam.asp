<!-- #include virtual="/westblue/settings.asp" -->
<!-- #include file="pointsinclude.asp" -->
<%	'Global Variables
	Dim Handicap 
	Dim PointsArray ()
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim Player
	Dim pTotalPoints
	Dim tTotalPoints1 (18)
	Dim tTotalPoints2 (18)
	Dim TotalTeamPoints
	Dim TotalTeamWeeks
	Dim tAverage
	Dim SubPoints
	Dim SubAverage
	Dim SubWeeks
	Dim TotalSubPoints
	Dim teamName
	Dim pAverage
	Dim i
	Dim j
	Dim index
	Dim Found
	Dim strYear
	strYear = Request("Year")
	%>
<HTML>
<HEAD>
	<TITLE>West Blue Golf - Calculate Team Points</TITLE>
</HEAD>

<BODY bgcolor="white"><br>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
Set RS = Conn.Execute("SELECT TeamName FROM TeamTable WHERE TeamID='" & Ucase(Request.QueryString("team")) & "'")
teamName = RS("TeamName")
RS.Close
Conn.Close
%>
<h2><center><font color="Green"><% Response.Write(teamName & " " & strYear & " Points")%></font></center></h2><br>
<table cellspacing="5" cellpadding="2">
<tr align="center">
    <td align="right"><b><font color="Navy">Week:</font></b> </td>
	<%
	Set Conn = Server.CreateObject("ADODB.Connection")
	'Conn.Open odbcName(strYear)
	Conn.Open connectstr
	Set RS1 = Conn.Execute("SELECT Week FROM WeekTable ORDER BY Week")
	%>
	<% DO While NOT RS1.EOF %>
	<td><b><font color="Navy"><%= RS1("Week") %></font></b></td>
	<% RS1.MoveNext
	   Loop
	%>
	<!--<td></td>-->
	<td><b><font color="Navy">Total Points</font></b></td>
	<td><b><font color="Navy">Average Points</font></b></td>
</tr>
<tr>
<td align="right"><b><font color="Navy">Par: </font></b></td>
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
</tr>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
Conn.Open connectstr
Set RS = Conn.Execute("SELECT PlayerName FROM PlayerTable WHERE TeamID='" & Ucase(Request.QueryString("team")) & "'")
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
	<% pAverage = GetTeamPoints(Ucase(Request.QueryString("team")), PlayerArray(x), strYear) %>
	<tr>
	    <td align="right" nowrap><b><font color="Navy"><%= PlayerArray(x) %>: </font></b></td>
		<% For j = 0 to 18 %>
			<% Found = "n" %>
			<% For i = 0 to UBound(WeekArray) %>
			<% 	if WeekArray(i) = j then %>
			<%  	Found = "y"%>
			<% 		index = i %>
			<% 		Exit For %>		
			<% 	End If %>
			<% Next %>
			<% if Found = "y" then %>
				<% tTotalPoints1(j) = tTotalPoints1(j) + PointsArray(index) %>
			<td align="center"><font color="Green"><%= PointsArray(index) %></font></td>
			<% Else  %>
			<td></td>
			<% End If %>
		<% Next %>
		<!--<td></td>-->
		<td align="center"><font color="Navy"><b><%= pTotalPoints %></b></font></td>
		<td align="center">
			<font color="Green"><%= pAverage %></font>&nbsp;&nbsp;
		</td>
	</tr>
<% Next %>
	<tr>
		<td align="right"><b><font color="Navy">Subs:</font></b></td>
		<% 'Conn.Open odbcName(strYear)
			Conn.Open connectstr
           tTotalPoints2(0) = 0
		   SubWeeks = 0 %>
		<td align="center"><font color="Green"><%= tTotalPoints2(0) %></font></td>
		<% For j = 1 to 18 
			SubPoints = 0
			SQL1 = "SELECT Points1 FROM ResultsTable where TeamID1='" & Ucase(Request.QueryString("team")) & "' and Week=" & j &"" 
			Set RS = Conn.Execute(SQL1)
			SQL2 = "SELECT Points2 FROM ResultsTable where TeamID2='" & Ucase(Request.QueryString("team")) & "' and Week=" & j &"" 
			Set RS2 = Conn.Execute(SQL2)
			Do While Not RS.EOF 
				tTotalPoints2(j) = tTotalPoints2(j) + RS("Points1") 
   		        RS.MoveNext
   			Loop
			Do While Not RS2.EOF
				tTotalPoints2(j) = tTotalPoints2(j) + RS2("Points2")
				RS2.MoveNext
   				Loop
			RS.Close
			RS2.Close
			SubPoints = tTotalPoints2(j) - tTotalPoints1(j) %>
		<%	if SubPoints > 0 then %>
		<%		SubWeeks = SubWeeks + 1 
			End If %>
		<%	TotalSubPoints = TotalSubPoints + SubPoints %>
			<% If SubPoints > 0 Then %>
				<td align="center"><font color="Green"><%= SubPoints %></font></td>
			<% Else  %>
				<td></td>
			<% End If %>
		<% Next %>
		<% Conn.Close %>
		<!--<td></td>-->
		<td align="center"><b><font color="Navy"><%= TotalSubPoints %></font></b></td>
		<td align="center">
			<% If SubWeeks = 0 Then %>
			<% 		SubAverage = 0
			   Else
			   		SubAverage = TotalSubPoints / SubWeeks
			   End If %>
			<font color="Green"><%= FormatNumber(SubAverage,1) %></font>
			
		</td>
	</tr>
	<tr>
			<td align="right"><b><font color="Navy">Totals:</font></b></td>
		<% For j = 0 to 18 %>
			<td align="center"><font color="Green"><%= tTotalPoints2(j) %></font></td>
			<% If tTotalPoints2(j) > 0 Then %>
			<% 	TotalTeamWeeks = TotalTeamWeeks + 1 %>
			<% End If %>
			<% TotalTeamPoints = TotalTeamPoints + tTotalPoints2(j) %>
		<% Next %>
			<td align="center"><b><font color="Navy"><%= TotalTeamPoints %></font></b></td>
			<td align="center">
			<% If TotalTeamPoints > 0 Then %>
			<% 	tAverage = TotalTeamPoints / TotalTeamWeeks %>
			<% Else  %>
			<%  tAverage = 0 %>
			<% End If %>
			<font color="Green"><%= FormatNumber(tAverage, 2) %></font></td>
	</tr>
</table>
</BODY>
</HTML>