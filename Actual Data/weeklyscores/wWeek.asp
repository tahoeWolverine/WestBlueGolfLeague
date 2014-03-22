<!-- #include virtual="/westblue/settings.asp" -->

<HTML>
<HEAD>
	<TITLE>West Blue Golf League - Weekly Results</TITLE>
</HEAD>

<BODY bgcolor="white"><br>
<% for i = UBound(strYearsArray) - 1 to 0 step -1 %>
<center><h2><font color="Green"><%= strYearsArray(i)%> Weekly Results</font></h2></center>

<center>
<form action="wTeam.asp" method="GET">
<input type=hidden name=Year value=<%= strYearsArray(i) %>>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open  odbcName(strYearsArray(i))
dim connectstr2
connectstr2 = connectstr & odbcName(strYearsArray(i)) & ";"
Conn.Open connectstr2
Set RS = Conn.Execute("SELECT Week, Par, Date FROM WeekTable ORDER By Week")
%>
<font color="Navy">Select a week: </font>
<select name="week" size="1">
	<% Do While Not RS.EOF %>
   	<% if RS("Week") = "1" then %>
	<option selected value="<%  = RS("Week") %>"><%  = RS("Date") %>	
	<% else %>
	<option value="<%  = RS("Week") %>"><%  = RS("Date") %>	
	<% end if %>
  	<% RS.MoveNext
   	Loop
	Set RS=Nothing
	Set Conn=Nothing
   	%>
</select>
<br><br><input type="Submit" name="submit" value="Submit">
</form>
</center><br><br>
<% next %>
<!--<center><h2><font color="Green">1999 Weekly Results</font></h2></center>

<center>
<form action="wTeam99.asp" method="GET">
<font color="Navy">Select a week: </font><select name="week" size="1">
   <option value="1">Week1
   <option value="2">Week2
   <option value="3">Week3
   <option value="4">Week4
   <option value="5">Week5
   <option value="6">Week6
   <option value="7">Week7
   <option value="8">Week8
   <option value="9">Week9
   <option value="10">Week10
   <option value="11">Week11
   <option value="12">Week12
   <option value="13">Week13
   <option value="14">Week14
   <option value="15">Week15
   <option value="16">Week16
   <option value="17">Week17
   <option value="18">Week18
   </select><br><br>
   <input type="Submit" name="submit" value="Submit">
</form>
</center><br><br>
<center><h2><font color="Green">1998 Weekly Results</font></h2></center>

<center>
<form action="wTeam98.asp" method="GET">
<font color="Navy">Select a week: </font><select name="week" size="1">
   <option value="1">Week1 - April 28
   <option value="2">Week2 - May 5
   <option value="3">Week3 - May 12
   <option value="4">Week4 - May 19
   <option value="5">Week5 - May 26
   <option value="6">Week6 - June 2
   <option value="7">Week7 - June 9
   <option value="8">Week8 - June 16
   <option value="9">Week9 - June 23
   <option value="10">Week10 - June 30
   <option value="11">Week11 - July 7
   <option value="12">Week12 - July 14
   <option value="13">Week13 - July 21
   <option value="14">Week14 - July 28
   <option value="15">Week15 - Aug 4
   <option value="16">Week16 - Aug 11</select><br><br>
   <input type="Submit" name="submit" value="Submit">
</form>
</center><br><br>
<center><h2><font color="Green">1997 Weekly Results</font></h2></center>

<center>
<form action="wTeam97.asp" method="GET">
<font color="Navy">Select a week: </font><select name="week" size="1">
   <option value="1">Week1
   <option value="2">Week2
   <option value="3">Week3
   <option value="4">Week4
   <option value="5">Week5
   <option value="6">Week6
   <option value="7">Week7
   <option value="9">Week9
   <option value="10">Week10
   <option value="12">Week12
   <option value="13">Week13
   <option value="14">Week14
   <option value="15">Week15
   <option value="16">Week16</select><br><br>
   <input type="Submit" name="submit" value="Submit">
</form>-->
</center>
</BODY>
</HTML>
