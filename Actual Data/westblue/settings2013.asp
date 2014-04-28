<%

Dim strCurrentYear
strCurrentYear = "2013"

Dim iScoresToEval
iScoresToEval = 4

Dim dsn_name, connectstr, sDSNDir, DBQ
dsn_name = "file.dsn"
DBQ = "DBQ=" & Server.MapPath("\access_db\")
sDSNDir = Server.MapPath("\westblue\_dsn\")
connectstr = "filedsn=" & sDSNDir & "\" & dsn_name & ";" & DBQ & "\"

Dim strYearsArray (15)
strYearsArray(0) = ("1999")
strYearsArray(1) = ("2000")
strYearsArray(2) = ("2001")
strYearsArray(3) = ("2002")
strYearsArray(4) = ("2003")
strYearsArray(5) = ("2004")
strYearsArray(6) = ("2005")
strYearsArray(7) = ("2006")
strYearsArray(8) = ("2007")
strYearsArray(9) = ("2008")
strYearsArray(10) = ("2009")
strYearsArray(11) = ("2010")
strYearsArray(12) = ("2011")
strYearsArray(13) = ("2012")
strYearsArray(14) = ("2013")
%>

<%
sub PageFooter (byVal strPagePrefix, byVal strTitleText)

for i = UBound(strYearsArray) - 1 to 0 step -1  %>
	<a href="<%Response.write(strPagePrefix & ".asp?Year=" & strYearsArray(i))%>"><%Response.write(strYearsArray(i) & " " & strTitleText)%></a>&nbsp;&nbsp;&nbsp;
<% next %>
<% end sub %>
<%
function odbcName(byVal strYear)

Select Case strYear
	Case ("2013")
	odbcName = "golf13.mdb"	
	Case ("2012")
	odbcName = "golf12.mdb"	
	Case ("2011")
	odbcName = "golf11.mdb"
	Case ("2010")
	odbcName = "golf10.mdb"
	Case ("2009")
	odbcName = "golf09.mdb"
	Case ("2008")
	odbcName = "golf08.mdb"
	Case ("2007")
	odbcName = "golf07.mdb"
	Case ("2006")
	odbcName = "golf06.mdb"
	Case ("2005")
	odbcName = "golf05.mdb"
	Case ("2004")
	odbcName = "golf04.mdb"
	Case ("2003")
	odbcName = "golf03.mdb"
	Case ("2002")
	odbcName = "golf02.mdb"
	Case ("2001")
	odbcName = "golf01.mdb"
	Case ("2000")
	odbcName = "golf00.mdb"
	Case ("1999")
	odbcName = "golf99.mdb"
	Case ("1998")
	odbcName = "wbgdb.mdb"
	Case ("1997")
	odbcName = "wbg1997.mdb"
End Select
end function
%>
