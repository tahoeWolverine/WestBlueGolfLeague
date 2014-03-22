<!-- #include virtual="/westblue/settings.asp" -->
<!-- #include file="pointsinclude.asp" -->
<%	'Global Variables
	Dim Handicap 
	Dim PointsArray ()
	Dim ScoreArray ()
	Dim WeekArray ()
	Dim ParArray ()
	Dim Player
	Dim TotalPoints
	Dim AveragePoints
	Dim i
	Dim j
	Dim index
	Dim Found
	Dim strYear
	strYear = Request("Year")
	%>
	
<HTML>
<HEAD>
	<TITLE>West Blue Golf - <%= strYear %> Player Points</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green"><% Response.Write(Request.QueryString("Player") & " " & strYear & " Points")%></font></h2></center>

<% Player =  Request.QueryString("Player") %>
<% AveragePoints = GetPlayerPoints(Player, strYear) %>
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
	<% RS1.MoveNext
	   Loop
	%>
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
<tr>
    <td align="right" nowrap><b><font color="Navy"><%= Player %>:</font></b> </td>
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
	<td align="center"><font color="Green"><%= PointsArray(index) %></font></td>
	<% Else  %>
	<td></td>
	<% End If %>
<% Next %>
	<td align="center"><b><font color="Navy"><%= TotalPoints %></font></b></td>
	<td align="center"><font color="Green"><%= AveragePoints %></font>&nbsp;&nbsp;</td>

</tr>
</table>

</BODY>
</HTML>
