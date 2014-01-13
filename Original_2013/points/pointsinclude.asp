<% 'Input a player name and year and GetPlayerPoints return:
   'the player's weekly points scored, their total points and their average weekly points
%>	
<% Function GetPlayerPoints (Player, strYear) 
 	Dim TopNum 
 	Dim x 
    Dim Average %>

<%
   PopulatePlayerArrays Player, strYear
   TotalPoints = 0
   TopNum = UBound(PointsArray)
   For x = 0 to TopNum
	TotalPoints = TotalPoints + PointsArray(x)
   Next
   if TotalPoints > 0 then %>
<%   	Average = TotalPoints / TopNum
   end if    
   GetPlayerPoints = FormatNumber(Average,1)
   End Function
%>

<% 'Input a player name and year and GetPlayerPoints return:
   'the player's weekly points scored, their total points and their average weekly points
%>	
<% Function GetTeamPoints (Team, Player, strYear) 
 	Dim TopNum 
 	Dim x 
    Dim Average %>

<%
   PopulateTeamArrays Team, Player, strYear
   pTotalPoints = 0
   TopNum = UBound(PointsArray)
   For x = 0 to TopNum
	pTotalPoints = pTotalPoints + PointsArray(x)
   Next
   if pTotalPoints > 0 then %>
<%   	Average = pTotalPoints / TopNum
   end if    
   GetTeamPoints = FormatNumber(Average,1)
   End Function
%>

<% Sub PopulatePlayerArrays(ByVal Player, ByVal strYear)
	On Error Resume Next
	Dim TempWeekArray (18)
	Dim TempPointsArray (18)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCounter, connectstr2
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr2 = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr2
'if (strYear = "1997") Then
'	Conn.Open "wbg1997"
'	SQL1 = "SELECT Week, Points1 FROM WeeklyResults where Player1='" & Player & "' ORDER BY Week" 
'Elseif (strYear = "1998") Then
'	Conn.Open "wbgdb"
'	SQL1 = "SELECT Week, Points1 FROM ResultsList where Player1='" & Player & "' ORDER BY Week"
'Elseif (strYear = "1999") Then
'	Conn.Open "golf99"
'	SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' ORDER BY Week"
'Elseif (strYear = "2000") Then
'	Conn.Open "golf00"
'	SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' ORDER BY Week"
'End If 
SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<%  'if (strYear = "1997") Then
'	SQL2 = "SELECT Week, Points2 FROM WeeklyResults where Player2='" & Player & "' ORDER BY Week" 
'Elseif (strYear = "1998") Then
'	SQL2 = "SELECT Week, Points2 FROM ResultsList where Player2='" & Player & "' ORDER BY Week"
'Elseif (strYear = "1999") Then
'	SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' ORDER BY Week"
'Else
'	SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' ORDER BY Week"
'End If
ReDim Preserve WeekArray(0)
ReDim Preserve PointsArray(0)
WeekArray(0) = 0
PointsArray(0) = 0
SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	x = 1
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close
Conn.Close
%>
<% End Sub %>

<% Sub PopulateTeamArrays(ByVal Team, ByVal Player, ByVal strYear)
	Dim TempWeekArray (18)
	Dim TempPointsArray (18)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCounter, connectstr2
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr2 = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr2
'if (strYear = "1997") Then
'	Conn.Open "wbg1997"
'	SQL1 = "SELECT Week, Points1 FROM WeeklyResults where Player1='" & Player & "' and Team1='" & Team & "' ORDER BY Week" 
'Elseif (strYear = "1998") Then
'	Conn.Open "wbgdb"
'	SQL1 = "SELECT Week, Points1 FROM ResultsList where Player1='" & Player & "' and Team1='" & Team & "' ORDER BY Week"
'Elseif (strYear = "1999") Then
'	Conn.Open "golf99"
'	SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' and TeamID1='" & Team & "' ORDER BY Week"
'Else
'	Conn.Open "golf00"
'	SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' and TeamID1='" & Team & "' ORDER BY Week"
'End If 
SQL1 = "SELECT Week, Points1 FROM ResultsTable where PlayerName1='" & Player & "' and TeamID1='" & Team & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<% '  if (strYear = "1997") Then
'	SQL2 = "SELECT Week, Points2 FROM WeeklyResults where Player2='" & Player & "' and Team2='" & Team & "' ORDER BY Week" 
'Elseif (strYear = "1998") Then
'	SQL2 = "SELECT Week, Points2 FROM ResultsList where Player2='" & Player & "' and Team2='" & Team & "' ORDER BY Week"
'Elseif (strYear = "1999") Then
'	SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' and TeamID2='" & Team & "' ORDER BY Week"
'Else
'	SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' and TeamID2='" & Team & "' ORDER BY Week"
'End If
ReDim Preserve WeekArray(0)
ReDim Preserve PointsArray(0)
WeekArray(0) = 0
PointsArray(0) = 0
SQL2 = "SELECT Week, Points2 FROM ResultsTable where PlayerName2='" & Player & "' and TeamID2='" & Team & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	x = 1
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close
Conn.Close
%>
<% End Sub %>