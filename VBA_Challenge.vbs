Attribute VB_Name = "VBA_Challenge"
Sub AllStocksAnalysisRefactored()

    'Asks user to input year for analysis
    yearValue = InputBox("What year would you like to run the analysis on?")
    
    'Begins timing of analysis
    Dim startTime As Single
    Dim endTime  As Single
    startTime = Timer
    
    'Formats the output sheet on All Stocks Analysis worksheet
    Worksheets("All Stocks Analysis").Activate
    Range("A1").Value = "All Stocks (" + yearValue + ")"
    Cells(3, 1).Value = "Ticker"
    Cells(3, 2).Value = "Total Daily Volume"
    Cells(3, 3).Value = "Return"

    'Initializes array of all tickers
    Dim tickers(12) As String
        tickers(0) = "AY"
        tickers(1) = "CSIQ"
        tickers(2) = "DQ"
        tickers(3) = "ENPH"
        tickers(4) = "FSLR"
        tickers(5) = "HASI"
        tickers(6) = "JKS"
        tickers(7) = "RUN"
        tickers(8) = "SEDG"
        tickers(9) = "SPWR"
        tickers(10) = "TERP"
        tickers(11) = "VSLR"
    
    'Activates worksheet to pull data from
    Worksheets(yearValue).Activate
    
    'Determines and defines number of rows in worksheet
    rowStart = 2
    rowEnd = Cells(Rows.Count, "A").End(xlUp).Row
    
    'Creates a ticker Index and initializes to zero
    tickerIndex = 0

    'Creates three output arrays
    Dim tickerVolumes(12) As Long
    Dim tickerStartingPrices(12) As Single
    Dim tickerEndingPrices(12) As Single

    'For loop to initialize the tickerVolumes to zero.
    'If the next row’s ticker doesn’t match, increase the tickerIndex.
    For i = 0 To 11
        tickerVolumes(i) = 0
        tickerStartingPrices(i) = 0
        tickerEndingPrices(i) = 0
    Next i

    'Loops over all the rows in the spreadsheet.
    'rowStart and rowEnd defined above
    For i = rowStart To rowEnd

        'Increase volume for current ticker
        tickerVolumes(tickerIndex) = tickerVolumes(tickerIndex) + Cells(i, 8).Value
    
        'Checks if the current row is the first row with the selected tickerIndex.
        If Cells(i, 1).Value = tickers(tickerIndex) And Cells(i - 1, 1).Value <> tickers(tickerIndex) Then
            tickerStartingPrices(tickerIndex) = Cells(i, 6).Value
        End If
    
        'Checks if the current row is the last row with the selected ticker
        If Cells(i, 1).Value = tickers(tickerIndex) And Cells(i + 1, 1).Value <> tickers(tickerIndex) Then
            tickerEndingPrices(tickerIndex) = Cells(i, 6).Value
        End If

        'Increases the tickerIndex.
        If Cells(i, 1).Value = tickers(tickerIndex) And Cells(i + 1, 1).Value <> tickers(tickerIndex) Then
            tickerIndex = tickerIndex + 1
        End If

    Next i

    'Loops through the ticker array to output the Ticker, Total Daily Volume, and Return.
    For i = 0 To 11
        Worksheets("All Stocks Analysis").Activate
        Cells(4 + i, 1).Value = tickers(i)
        Cells(4 + i, 2).Value = tickerVolumes(i)
        Cells(4 + i, 3).Value = tickerEndingPrices(i) / tickerStartingPrices(i) - 1
    Next i
    
    'Formatting of output sheet
    Worksheets("All Stocks Analysis").Activate
    Range("A3:C3").Font.FontStyle = "Bold"
    Range("A3:C3").Borders(xlEdgeBottom).LineStyle = xlContinuous
    Range("B4:B15").NumberFormat = "#,##0"
    Range("C4:C15").NumberFormat = "0.0%"
    Columns("B").AutoFit

    'Adds colors to Return column
    dataRowStart = 4
    dataRowEnd = 15

    For i = dataRowStart To dataRowEnd
        If Cells(i, 3) > 0 Then
            Cells(i, 3).Interior.Color = vbGreen
        ElseIf Cells(i, 3) < 0 Then
            Cells(i, 3).Interior.Color = vbRed
        Else
            Cells(i, 3).Interior.Color = xlNone
        End If
    Next i
 
    'Ends timer that started at the beginning of the sub
    endTime = Timer
    'Displays elapsed time
    MsgBox "This code ran in " & (endTime - startTime) & " seconds for the year " & (yearValue)

End Sub
