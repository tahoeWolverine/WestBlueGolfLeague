<% 'Input a player name and CalcHandicap will return:
   'the player's handicap, the weeks used to calculate the hadicap,
   'an array of weeks played, an array of scores, and an array of course par for each week played. %>	
<% Function CalcHandicap (Player, strYear) %>
<% 	Dim TopNum %>
<% 	Dim x %>
<% 	Dim z %>
<% 	Dim Highest %>
<% 	Dim HighestWeek %>
<% 	Dim StrokesOverPar %>
<% 	Dim Weeks %>
<%  Dim remainder %>
<%  Dim temp %>
<%  if CInt(strYear) >= 2011 then
		Call PopulateArrays11 (Player, strYear)
	elseif CInt(strYear) >= 2009 then
		Call PopulateArrays09 (Player, strYear)
	else
		Call PopulateArrays (Player, strYear)
	End If %>
<%  TopNum = UBound(ScoreArray) %>
<%  Hightest = 0 %>
<%  if CInt(strYear) < 2008 then %>
<%	iScoresToEval = 3 %>
<%  End If %>
<% 'Do we have more than iScoresToEval scores in the score array? %>
<%	If TopNum > iScoresToEval - 1 Then %>
<% 		For x = 0 to iScoresToEval %>
<% 			temp = ScoreArray(TopNum - x) - ParArray(TopNum - x) %>
<% 'You can only have a max score of 20 over! %>
<% 			If temp > 20 Then %>
<% 				temp = 20 %>
<% 			End If %>
<% 			StrokesOverPar = StrokesOverPar + temp %>
<% 			If Highest < (ScoreArray(TopNum - x) - ParArray(TopNum - x)) Then %>
<% 				Highest = (ScoreArray(TopNum - x) - ParArray(TopNum - x)) %>
<% 				HighestWeek = WeekArray(TopNum - x) %>
<% 			End If %>
<% 		Next %>
<% 		If Highest > 20 Then %>
<% 			Highest = 20 %>
<% 		End If %>
<% 		z = 0 %>
<%		FoundOne = "N" %>
<% 		For x = 0 to iScoresToEval %>
<% 			If ((WeekArray(TopNum - x) <> HighestWeek)) or (FoundOne = "Y") Then %>
<% 				WeeksUsed(z) = WeekArray(TopNum - x) %>
<% 				z = z + 1 %>
<%			Else %>
<%				FoundOne = "Y" %>
<% 			End If %>
<% 		Next %>
<%  	StrokesOverPar = StrokesOverPar - Highest %>
<%  	Weeks = iScoresToEval %>
<% 'Do we have just one score in the score array? %>
<% 	ElseIf TopNum = 0 Then  %>
<% 		StrokesOverPar = ScoreArray(0) - ParArray(0) %>
<% 'You can only have a max score of 20 over! %>
<% 		If StrokesOverPar > 20 Then %>
<% 			StrokesOverPar = 20 %>
<% 		End If %>
<%  	Weeks = 1 %>
<% 		WeeksUsed(0) = 0 %>
<% 'We must have between 1 - iScoresToEval scores in the score array. %>
<%  Else %>
<% 		For x = 0 to TopNum %>
<% 			temp = ScoreArray(x) %>
<%			temp = temp - ParArray(x) %>
<% 'You can only have a max score of 20 over! %>
<% 			If temp > 20 Then %>
<% 				temp = 20 %>
<% 			End If %>
<% 			StrokesOverPar = StrokesOverPar + temp %>
<% 			WeeksUsed(x) = x %>
<% 		Next %>
<% 		For x = 0 to TopNum %>
<% 			WeeksUsed(x) = WeekArray(x) %>
<% 		Next %>
<%  	Weeks = x %>
<% End If '70 %>
<% 
If StrokesOverPar >= 1 Then %>
	<%  remainder =  (StrokesOverPar / Weeks) - (StrokesOverPar \ Weeks) %>
	<% If remainder >= .5 Then %>
	<%  CalcHandicap = StrokesOverPar \ Weeks + 1 %>
	<% Else  %>
	<%  CalcHandicap = StrokesOverPar \ Weeks %>
	<% End If %>
<% Else  %>
	<% CalcHandicap = 0 %>
<% End If %>
<% End Function %>

<%
' ===================
' Populate Arrays 11 
' ===================
%>
<% Sub PopulateArrays11(ByVal Player, ByVal strYear)
	Dim TempScoreArray (17)
	Dim TempWeekArray (17)
	Dim TempParArray (17)
	Dim TempPointsArray (17)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCount
	Dim Week0Score
	ArrayCount = 0
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr

SQL1 = "SELECT Week0Score, Status FROM PlayerTable WHERE PlayerName='" & Player & "'"
Set RS = Conn.Execute(SQL1)
Week0Score = RS("Week0Score")
Status = CStr(RS("Status"))

SQL1 = "SELECT Week, Score1, Points1 FROM ResultsTable WHERE PlayerName1='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)

Do While Not RS.EOF
   	TempScoreArray(x) = RS("Score1")
	TempWeekArray(x) = RS("Week")
	TempPointsArray(x) = RS("Points1")
	x = x + 1
	ArrayCount = x
    RS.MoveNext
Loop

SQL2 = "SELECT Week, Score2, Points2 FROM ResultsTable Where PlayerName2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)

ReDim WeekArray(0)
ReDim ScoreArray(0)
ReDim PointsArray(0)
WeekArray(0) = 0
ScoreArray(0) = Week0Score
PointsArray(0) = 0
x = 1
y = 0
Do While Not RS.EOF
	If y >= ArrayCount Then
		ReDim Preserve WeekArray(x)
		ReDim Preserve ScoreArray(x)
		ReDim Preserve PointsArray(x)
		WeekArray(x) = RS("Week")
		ScoreArray(x) = RS("Score2")
		PointsArray(x) = RS("Points2")
		RS.MoveNext
		x = x + 1
	ElseIf TempWeekArray(y) > RS("Week") Then
		ReDim Preserve WeekArray(x)
		ReDim Preserve ScoreArray(x)
		ReDim Preserve PointsArray(x)						
		WeekArray(x) = RS("Week")
		ScoreArray(x) = RS("Score2")
		PointsArray(x) = RS("Points2")			
		RS.MoveNext
		x = x + 1
	Else
		Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week"))
			ReDim Preserve WeekArray (x)
			ReDim Preserve ScoreArray (x)
			ReDim Preserve PointsArray(x)			
			WeekArray(x) = TempWeekArray(y)
			ScoreArray(x) = TempScoreArray(y)
			PointsArray(x) = TempPointsArray(y)
			x = x + 1
			y = y + 1
		Loop
	End If
Loop
Do While (y < ArrayCount)
	ReDim Preserve WeekArray (x)
	ReDim Preserve ScoreArray (x)
	ReDim Preserve PointsArray(x)			
	WeekArray(x) = TempWeekArray(y)
	ScoreArray(x) = TempScoreArray(y)
	PointsArray(x) = TempPointsArray(y)		
	x = x + 1
	y = y + 1	
Loop
RS.Close
x = 0
if Status = "old" then
	For x = (UBound(WeekArray) + 1) to (iScoresToEval) 
		ReDim Preserve WeekArray (x) 
		ReDim Preserve ScoreArray (x) 
		ReDim Preserve PointsArray(x) 		
		WeekArray(x) = 0 
		ScoreArray(x) = Week0Score 
		PointsArray(x) = 0 
	Next 
end if

' Populate the Par array using the players WeekArray
for i = 0 to UBound(WeekArray)
	Set RS = Conn.Execute("SELECT Par FROM WeekTable WHERE Week=" & WeekArray(i))
 	ReDim Preserve ParArray(i)
	ParArray(i) = RS("Par") 
Next
RS.Close 
Conn.Close
%>
<% End Sub %>
<%
' ===================
' Populate Arrays 09 
' ===================
%>
<% Sub PopulateArrays09(ByVal Player, ByVal strYear)
	Dim TempScoreArray (17)
	Dim TempWeekArray (17)
	Dim TempParArray (17)
	Dim TempPointsArray (17)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCounter
	Dim Week0Score
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr

SQL1 = "SELECT Week0Score FROM PlayerTable WHERE PlayerName='" & Player & "'"
Set RS = Conn.Execute(SQL1)
Week0Score = RS("Week0Score")

SQL1 = "SELECT Week, Score1, Points1 FROM ResultsTable WHERE PlayerName1='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
   		<% TempScoreArray(x) = RS("Score1")  %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<% SQL2 = "SELECT Week, Score2, Points2 FROM ResultsTable Where PlayerName2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	ReDim WeekArray(0)
   		ReDim ScoreArray(0)
		ReDim PointsArray(0)
   		WeekArray(0) = 0
   		ScoreArray(0) = Week0Score
		PointsArray(0) = 0
   		x = 1
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve ScoreArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%	ScoreArray(x) = TempScoreArray(y) '150 %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve ScoreArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%	ScoreArray(x) = TempScoreArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close %>
<% ' Populate the Par array using the players WeekArray
Set RS = Conn.Execute("SELECT Par, Week FROM WeekTable ORDER BY Week")
Do While Not RS.EOF
	for i = 0 to UBound(WeekArray) '171
	 	if (WeekArray(i) = RS("Week")) Then
		 	ReDim Preserve ParArray(i)
			ParArray(i) = RS("Par")
		End If
	Next
	RS.MoveNext
Loop
RS.Close 
Conn.Close
%>
<% End Sub %>
<%
' ===================
' Populate Arrays 
' ===================
%>
<% Sub PopulateArrays(ByVal Player, ByVal strYear)
	Dim TempScoreArray (17)
	Dim TempWeekArray (17)
	Dim TempParArray (17)
	Dim TempPointsArray (17)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCounter
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'if strYear = "1999" then 100
'	Conn.Open "golf99"
'else
'	Conn.Open "golf00"
'end if
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
SQL1 = "SELECT Week, Score1, Points1 FROM ResultsTable WHERE PlayerName1='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
   		<% TempScoreArray(x) = RS("Score1")  %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<% SQL2 = "SELECT Week, Score2, Points2 FROM ResultsTable Where PlayerName2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	x = 0
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve ScoreArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%	ScoreArray(x) = TempScoreArray(y) '150 %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve ScoreArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%	ScoreArray(x) = TempScoreArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close %>
<% ' Populate the Par array using the players WeekArray
Set RS = Conn.Execute("SELECT Par, Week FROM WeekTable ORDER BY Week")
Do While Not RS.EOF
	for i = 0 to UBound(WeekArray) '171
	 	if (WeekArray(i) = RS("Week")) Then
		 	ReDim Preserve ParArray(i)
			ParArray(i) = RS("Par")
		End If
	Next
	RS.MoveNext
Loop
RS.Close 
Conn.Close
%>
<% End Sub %>
<%
' ===================
' Populate 98 Arrays 
' ===================
%>
<% Sub Populate98Arrays(Player)
	Dim TempScoreArray (15)
	Dim TempWeekArray (15)
	Dim TempParArray (15)
	Dim TempPointsArray (15)	
    Dim x 
	Dim y
	Dim i
	Dim wk
	Dim ArrayCount
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
SQL1 = "SELECT Week, Score1, Points1 FROM ResultsList where Player1='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
   		<% TempScoreArray(x) = RS("Score1")  %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<% SQL2 = "SELECT Week, Score2, Points2 FROM ResultsList where Player2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	x = 0
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve ScoreArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%	ScoreArray(x) = TempScoreArray(y) %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve ScoreArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%	ScoreArray(x) = TempScoreArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close %>
<% ' Populate the Par array using the players WeekArray
'Set RS = Conn.Execute("SELECT Par FROM WeekList WHERE Week='" & wk & "'")
Set RS = Conn.Execute("SELECT Par, Week FROM WeekList ORDER BY Week")
'for i = 0 to UBound(WeekArray)
Do While Not RS.EOF
	for i = 0 to UBound(WeekArray)
	 	if (WeekArray(i) = RS("Week")) Then
		 	ReDim Preserve ParArray(i)
			ParArray(i) = RS("Par")
		End If
	Next
	RS.MoveNext
Loop
RS.Close 
Conn.Close
%>
<% End Sub %>
<%
' ===================
' Populate 97 Arrays 
' ===================
%>
<% Sub Populate97Arrays(Player)
	Dim TempScoreArray (15)
	Dim TempWeekArray (15)
	Dim TempParArray (15)
	Dim TempPointsArray (15)	
    Dim x 
	Dim y
	Dim ArrayCounter
	x = 0
Set Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open odbcName(strYear)
connectstr = connectstr & odbcName(strYear) & ";"
Conn.Open connectstr
SQL1 = "SELECT Week, Score1, Points1, Par FROM WeeklyResults where Player1='" & Player & "' ORDER BY Week"
'SQL1 = "SELECT Week, Score1, Par FROM WeeklyResults where Player1='" & Ucase(Request.QueryString("Player")) & "' ORDER BY Week"
'SQL2 = "SELECT Week, Score2 FROM WeeklyResults where Player2='" & Ucase(Request.QueryString("Player")) & "' ORDER BY Week desc"
Set RS = Conn.Execute(SQL1)
%>
   <% Do While Not RS.EOF %>
   		<% TempScoreArray(x) = RS("Score1")  %>
		<% TempWeekArray(x) = RS("Week") %>
		<% TempParArray(x) = RS("Par") %>
		<% TempPointsArray(x) = RS("Points1") %>
		<% x = x + 1 %>
		<% ArrayCount = x %>
   <% RS.MoveNext
   Loop
   %>
<% SQL2 = "SELECT Week, Score2, Points2, Par FROM WeeklyResults where Player2='" & Player & "' ORDER BY Week"
Set RS = Conn.Execute(SQL2)
%>
   <%	x = 0
   		y = 0
   		Do While Not RS.EOF %>
			<% If y >= ArrayCount Then  %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve ParArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>
			<% 		ParArray(x) = RS("Par") %>
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
   			<% ElseIf TempWeekArray(y) > RS("Week") Then %>
			<% 		ReDim Preserve WeekArray(x) %>
			<% 		ReDim Preserve ScoreArray(x) %>
			<% 		ReDim Preserve ParArray(x) %>
			<% 		ReDim Preserve PointsArray(x) %>						
			<%		WeekArray(x) = RS("Week") %>
			<%		ScoreArray(x) = RS("Score2") %>
			<% 		PointsArray(x) = RS("Points2") %>			
			<% 		ParArray(x) = RS("Par") %>			
			<% 		RS.MoveNext %>
			<% 		x = x + 1 %>
			<% Else  %>
				<% Do While (y < ArrayCount) and (TempWeekArray(y) < RS("Week")) %>
					<% 	ReDim Preserve WeekArray (x) %>
					<% 	ReDim Preserve ScoreArray (x) %>
					<% 	ReDim Preserve PointsArray(x) %>			
					<% 	ReDim Preserve ParArray (x) %>				
					<%	WeekArray(x) = TempWeekArray(y) %>
					<%	ScoreArray(x) = TempScoreArray(y) %>
					<%  PointsArray(x) = TempPointsArray(y) %>
					<%	ParArray(x) = TempParArray(y) %>	
					<%  x = x + 1 %>
					<%  y = y + 1 %>
				<% Loop %>
			<% End If %>
   		<% Loop %>
		<% Do While (y < ArrayCount) %>
			<% 	ReDim Preserve WeekArray (x) %>
			<% 	ReDim Preserve ScoreArray (x) %>
			<% 	ReDim Preserve PointsArray(x) %>			
			<% 	ReDim Preserve ParArray (x) %>				
			<%	WeekArray(x) = TempWeekArray(y) %>
			<%	ScoreArray(x) = TempScoreArray(y) %>
			<%  PointsArray(x) = TempPointsArray(y) %>			
			<%	ParArray(x) = TempParArray(y) %>
			<%  x = x + 1 %>
			<%  y = y + 1 %>		
		<% Loop %>
<% RS.Close
Conn.Close
%> 

<% End Sub %>