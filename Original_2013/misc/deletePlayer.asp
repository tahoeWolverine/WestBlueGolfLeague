<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables
response.write "hello world"
DIM PlayerName
PlayerName = request.querystring("player")

' Connect to target database
Set TargetConn = Server.CreateObject("ADODB.Connection")
Set RS2 = Server.CreateObject("ADODB.RecordSet")

connectstr = connectstr & odbcName(strCurrentYear) & ";"
RSstring = "SELECT * FROM PlayerTable WHERE PlayerName='" & PlayerName & "'"

TargetConn.Open connectstr
RS2.Open RSstring, TargetConn,1,3
RS2.Delete
RS2.UPDATE
RS2.CLOSE
TargetConn.Close
Response.redirect "EditPlayers.asp"
%>
