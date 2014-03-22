<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables
	Dim Handicap 
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim Player
	Dim i
	Dim j
	Dim index
	Dim Found
	Dim intWeekCount
	Dim strYear
	strYear = Request("Year")
	Dim WeeksUsed()
	ReDim WeeksUsed(iScoresToEval)
	%>
	
<HTML>
<HEAD>
	<TITLE>West Blue Golf - Calculate Handicap</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green"><% Response.Write(Request.QueryString("Player") & " " & strYear & " Handicap")%></font></h2></center>
<center><font color="Green"><% Response.write("Current as of: " & date)%></font></center>
<!--#include file="handicap.asp"-->
<% Player =  Request.QueryString("Player") %>
<% Handicap = CalcHandicap(Player, CInt(strYear)) %>
<br>
<table cellspacing="5" cellpadding="2">
<tr align="center">
    <td align="right"><b><font color="Navy">Week:</font></b> </td>
	<%
	Set Conn = Server.CreateObject("ADODB.Connection")
	'Conn.Open odbcName(strYear)
	connectstr = connectstr & odbcName(strYear) & ";"
	Conn.Open connectstr
	Set RS1 = Conn.Execute("SELECT Week FROM WeekTable ORDER BY Week")
	%>
	<% DO While NOT RS1.EOF %>
	<td><b><font color="Navy"><%= RS1("Week") %></font></b></td>
	<% 	intWeekCount = intWeekCount + 1
		RS1.MoveNext
	   	Loop
	%>
	<td><b><font color="Navy">Handicap</font></b></td>
	<td><b><font color="Navy">WeeksUsed:</font></b></td>
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
<tr>
    <td align="right" nowrap><b><font color="Navy"><%= Player %>:</font></b> </td>
<% For j = 0 to intWeekCount-1 %>
	<% Found = "n" %>
	<% For i = 0 to UBound(WeekArray) %>
	<% 	if WeekArray(i) = j then %>
	<%  	Found = "y"%>
	<% 		index = i %>
	<% 		Exit For %>		
	<% 	End If %>
	<% Next %>
	<% if Found = "y" then %>
	<td nowrap><font color="Green"><%= ScoreArray(index) %></font></td>
	<% Else  %>
	<td></td>
	<% End If %>
<% Next %>
	<td align="center"><b><font color="Navy"><%=	Handicap %></font></b></td>
	<td align="center"><% For x = 0 to UBound(WeeksUsed) %>
		<font color="Green"><%= WeeksUsed(x) %></font>&nbsp;&nbsp;
		<% Next %></td>

</tr>
</table>

</BODY>
</HTML>