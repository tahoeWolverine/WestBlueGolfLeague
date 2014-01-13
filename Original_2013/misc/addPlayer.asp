<!-- #include virtual="/westblue/settings.asp" -->
<%	'Global Variables
'response.end
DIM Handicap
Handicap = CINT(request("Handicap"))
If Handicap > 20 then
	Handicap = 56
Else
	Handicap = Handicap + 36
End If
DIM PlayerName
PlayerName = request("PlayerName")
DIM TeamID
TeamID = request("TeamID")

' Connect to target database
Set TargetConn = Server.CreateObject("ADODB.Connection")
connectstr = connectstr & odbcName(strCurrentYear) & ";"
TargetConn.Open connectstr

Set RS2 = Server.CreateObject("ADODB.RecordSet")
RS2.Open "SELECT * FROM PlayerTable", TargetConn,1,3
RS2.AddNew
RS2("PlayerName") = PlayerName
RS2("TeamID") = TeamID
RS2("Week0Score") = Handicap
If request("existing") = "on" then
	RS2("Status") = "OLD"
Else
	RS2("Status") = "NEW"
End If
RS2.UPDATE
RS2.CLOSE
TargetConn.Close
Response.redirect "EditPlayers.asp"
%>
