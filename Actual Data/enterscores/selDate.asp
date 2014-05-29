<!-- #include virtual="/westblue/settings.asp" -->
<%
Dim Username
Dim Password

Username = Request.QueryString("Username")
Password = Request.QueryString("Password")
%>
<% If Username = "" Then %>
	<% Response.Redirect("password.html") %>
<% Else  %>
<%
	Set Conn = Server.CreateObject("ADODB.Connection")
	'Conn.Open odbcName(strCurrentYear)
	connectstr = connectstr & odbcName(strCurrentYear) & ";"
	Conn.Open connectstr
	SQLCheck = "SELECT Username FROM Password WHERE Username='" & username & "' and Password='" & Password & "'"
	Set RS = Conn.Execute(SQLCheck)
	If RS.EOF Then
	    RS.Close
		Conn.Close
		Response.Redirect "invpswd.html"
	End If
	RS.Close
	Conn.Close
 %>
<% End If %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
	<TITLE>Scores In</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green">Input Scores - Select Match Date</font></h2></center>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strCurrentYear)
connectstr = connectstr & odbcName(strCurrentYear) & ";"
Conn.Open connectstr
Set RS = Conn.Execute("SELECT Week, Par, Date FROM WeekTable ORDER By Week")
%>
<form name="pickweek" action="selMatch.asp" method="GET">
<br><br>
<center><font face="Times New Roman" color="Navy">Select Match Date</font></center><br>
<center>
<select name="week" size="1">
   	<% Do While Not RS.EOF %>
   	<option value="<%  = RS("Week") %>"><%  = RS("Date") %>	
  	<% RS.MoveNext
   	Loop
	Set RS=Nothing
	Set Conn=Nothing
   	%>
</select></center><br>
<br><br>
<center><input type="Submit" name="submit" value="Submit"> </center> 
</form>
</BODY>
</HTML>

