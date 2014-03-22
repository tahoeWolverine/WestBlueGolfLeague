<!-- #include virtual="/westblue/settings.asp" -->
<%
Dim strYear
strYear = Request("Year")
%>
<HTML>
<HEAD>
	<TITLE>West Blue Golf League - <%= strYear %> Handicaps</TITLE>
</HEAD>

<BODY bgcolor="white">
<center><h2><font color="Green"><%= strYear %> Handicaps</font></h2></center>
<br>
<br>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
Set RS1 = Conn.Execute("SELECT PlayerName FROM PlayerTable ORDER BY PlayerName")
Set RS2 = Conn.Execute("SELECT TeamName,TeamID FROM TeamTable ORDER BY TeamName")
%>
<table cellspacing="2" cellpadding="2" width="100%">
<tr>
    <td>
		<table>
			<tr>
			    <th>
					<font color="Navy">Player</font>
				</th>		
			</tr>	
			<tr>
			    <td><form action="<%Response.write("cPlay.asp")%>" method="GET">
					<input type=hidden name=Year value=<%= strYear %>>
					<select name="player" size="1">
			   		<% Do While Not RS1.EOF %>
			   			<option value="<%  = RS1("PlayerName") %>"><%  = RS1("PlayerName") %>
			   		<% RS1.MoveNext
			   		Loop
			   		%>
			   		</select>
				</td>
			</tr>
			<tr>
			    <td align="center">
					<input type="Submit" name="Submit" value="Submit">
					</form>
				</td>		
			</tr>
		</table>
	</td>
    <td>
		<table>
			<tr>
			    <th>
					<font color="Navy">Team</font>
				</th>		
			</tr>	
			<tr>
			    <td>
					<form action="<%Response.write("cTeam.asp")%>" method="GET">
					<input type=hidden name=Year value=<%= strYear %>>
					<select name="team" size="1">
	   				<% Do While Not RS2.EOF %>
	   					<option value="<%  = RS2("TeamID") %>"><%  = RS2("TeamName") %>
	   				<% RS2.MoveNext
	   				Loop
	   				%>
	   				</select>
				</td>
			</tr>
			<tr>
			    <td align="center">
					<input type="Submit" name="Submit" value="Submit">
					</form>
				</td>		
			</tr>
		</table>
	</td>
	<td valign="top">
		<table>
			<tr>
			    <th>
					<font color="Navy">League</font>
				</th>		
			</tr>	
			<tr>
			    <td align="center">
					<a href="<%Response.write("cleague.asp?Year=" & strYear)%>">Entire League</a>
				</td>	
			</tr>

		</table>
	</td>
</tr>
</table>
<% RS1.Close
   RS2.Close
Conn.Close
%> 
<br>
<br>
<center>
<% PageFooter "handi", "Handicaps" %>
</center>
</BODY>
</HTML>