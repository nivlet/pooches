Use dfClient.pkg
Use DataDict.pkg
Use dfTable.pkg
Use Windows.pkg
Use File_dlg.Pkg

Use cPoochDataDictionary.dd

DEFERRED_VIEW Activate_oPoochesView FOR ;
;
Object oPoochesView is a dbView
    Object oPooch_DD is a cPoochDataDictionary
    End_Object

    Property String psMBLabel "Pooches"
    
    Set Border_Style to Border_Thick
    Set Location to 10 10
    Set Size to 272 468

    Set Main_DD to oPooch_DD
    Set Server to oPooch_DD
    Set Label to "Pooches"

    Object oPooch_Grid is a dbGrid
        Set Main_File to Pooch.File_Number
        Set Size to 166 443
        Set Location to 7 12
        Set peAnchors to anAll
        Set Wrap_State to TRUE

        Begin_Row
            Entry_Item Pooch.Name
            Entry_Item Pooch.Breed
            Entry_Item Pooch.Age
            Entry_Item Pooch.Create_date
            Entry_Item Pooch.Create_time
            Entry_Item Pooch.Change_date
            Entry_Item Pooch.Change_time
        End_Row

        Set Form_Width   item 0 to 62
        Set Header_Label item 0 to "Name"

        Set Form_Width   item 1 to 100
        Set Header_Label item 1 to "Breed"

        Set Form_Width   item 2 to 40
        Set Header_Label item 2 to "Age"

        Set Form_Width   item 3 to 50
        Set Header_Label item 3 to "Create Date"

        Set Form_Width   item 4 to 58
        Set Header_Label item 4 to "Create Time"

        Set Form_Width   item 5 to 60
        Set Header_Label item 5 to "Change Date"

        Set Form_Width   item 6 to 60
        Set Header_Label item 6 to "Change Time"
        Set peResizeColumn to rcAll

    End_Object    // oPooch_Grid

    Object oDeleteBtn is a Button
        Set Label to "Delete All"
        Set Location to 182 123
        Set peAnchors to anBottomLeft

        Procedure OnClick
            Integer iFail
            
            Get DeleteAllDogs to iFail
            If (not(iFail)) Send Beginning_of_Data to oPooch_Grid
        End_Procedure // OnClick
    End_Object    // oDeleteBtn

    Object oImportGrp is a Group
        Set Size to 58 211
        Set Location to 202 14
        Set peAnchors to anBottomLeftRight
        Set Label to "Import"

        Object oOpenImport is a OpenDialog
            Set Dialog_Caption to "Select a file"
            Set Filter_String to "Comma Separated Value|*.csv"
        End_Object    // oOpenImport

        Object oInputPath is a Form
            Set Label to "Input File (.csv)"
            Set Size to 13 141
            Set Location to 20 4
            Set peAnchors to anLeftRight
            Set Label_Col_Offset to 0
            Set Label_Justification_Mode to jMode_Top
        End_Object    // oInputPath

        Object oBrowse is a Button
            Set Label to "Browse"
            Set Location to 18 154
            Set peAnchors to anBottomRight


            Procedure OnClick
                Boolean bOk
                
                Get Show_Dialog of oOpenImport To bOk
                
                If (bOk) Begin
                    Set Value of oInputPath to (File_Name(oOpenImport))
                End
            End_Procedure // OnClick
        End_Object    // oBrowse

        Object oImport_Btn is a Button
            Set Label to "Import"
            Set Location to 42 155
            Set peAnchors to anBottomRight

            Procedure OnClick
                Boolean bFail
                
                Get ImportDogs (Value(oInputPath)) to bFail
            End_Procedure // OnClick
        End_Object    // oImport_Btn

    End_Object    // oImportGrp

    Object oReportGrp is a Group
        Set Size to 75 210
        Set Location to 185 242
        Set peAnchors to anBottomRight
        Set Label to "Report"
        
        Object oOutputFile is a Form
            Set Label to "Output File Name"
            Set Size to 13 85
            Set Location to 18 109
            Set peAnchors to anBottomRight
            Set Label_Col_Offset to 0
            Set Label_Justification_Mode to jMode_Top
        End_Object    // oOutputFile

        Object oTextBox1 is a TextBox
            Set Size to 10 50
            Set Location to 32 111
            Set Label to '(Folder same as input file.)'
        End_Object

        Object oReport is a Button
            Set Label to "Report"
            Set Location to 52 142
            Set peAnchors to anBottomRight

            Procedure OnClick
                String sOutputPath
                
                Get GetOutputPath to sOutputPath
                
                Send GenerateReport sOutputPath
            End_Procedure // OnClick
        End_Object    // oReport

        Object oRadioGroup1 is a RadioGroup
            Set Location to 14 13
            Set Size to 54 85
            Set Label to 'Sort by'
        
            Object oRadioName is a Radio
                Set Label to "Name Breed Age"
                Set Size to 10 65
                Set Location to 10 5
            End_Object
        
            Object oRadioBreed is a Radio
                Set Label to "Breed Name Age"
                Set Size to 10 65
                Set Location to 25 5
            End_Object
        
            Object oRadioAge is a Radio
                Set Label to "Age Breed Name"
                Set Size to 10 65
                Set Location to 40 5
            End_Object
        
            Procedure Notify_Select_State Integer iToItem Integer iFromItem
                Forward Send Notify_Select_State iToItem iFromItem
                //for augmentation
            End_Procedure
        
            //If you set Current_Radio, you must set it AFTER the
            //radio objects have been created AND AFTER Notify_Select_State has been
            //created. i.e. Set in bottom-code of object at the end!!
        
            //Set Current_Radio To 0
        
        End_Object

    End_Object    // oReportGrp

    Function DeleteAllDogs Returns Integer
        Integer iRetVal iResponse
        String sMsg
        Boolean bFound
        
        Move 0 to iRetVal

        Move "Are you sure you want to delete all dogs?" to sMsg
        Move (YesNo_Box(sMsg, "Pooches", MB_DEFBUTTON2)) to iResponse
        
        If (iResponse = MBR_Yes) Begin
            Repeat
                Lock
                    Find GT POOCH by Recnum
                    Move (Found) to bFound
                    If (bFound) Begin
                        Delete POOCH  
                    End
                Unlock
            Until (not(bFound))
        End
        Else Move 1 to iRetVal

        Function_Return iRetVal
    End_Function
    
    Function ImportDogs String sInputPath Returns Integer
        Integer iInputChannel iAge
        String sName sBreed sMsg
        Boolean bFail
        
        If (sInputPath = "") Begin
            Send Stop_Box "You must specify an input file path." (psMBLabel(Self))
            Move True to bFail  
        End        
        
        If (not(bFail)) Begin
            Get Seq_New_Channel to iInputChannel
            
            If (iInputChannel = DF_SEQ_CHANNEL_NOT_AVAILABLE) Begin
                Send Stop_Box "No file channel available for input." (psMBLabel(Self))
                Move True to bFail
            End
        End
        
        If (not(bFail)) Begin
            Direct_Input channel iInputChannel sInputPath
            If (not(SeqEof)) Begin
                Repeat
                    Read channel iInputChannel sName sBreed iAge
                    Readln
                    
                    If (sName <> "") Begin
                        Send AddDog sName sBreed iAge
                    End
                Until (SeqEof)
            End
            Else Begin
                Move (sInputPath + " is not a valid input path.") to sMsg
                Send Stop_Box sMsg (psMBLabel(Self))
                Move True to bFail
            End
            Close_Input channel iInputChannel
            Send Seq_Release_Channel iInputChannel
        End
        
        Function_Return bFail
    End_Function
    
    Procedure AddDog String sName String sBreed Integer iAge
        Boolean bFail
        
        Move False to bFail
        
        Send Clear of oPooch_DD
        Move sName to POOCH.NAME
        Find EQ POOCH by Index.1
        If (not(Found)) Begin
            Set Field_Changed_Value of oPooch_DD Field POOCH.NAME to sName
            Set Field_Changed_Value of oPooch_DD Field POOCH.BREED to sBreed
            Set Field_Changed_Value of oPooch_DD Field POOCH.AGE to iAge
            Get Request_Validate of oPooch_DD to bFail
            If (not(bFail)) Send Request_Save of oPooch_DD
        End 
    End_Procedure
    
    Function GetOutputPath Returns String
        String sFileName sFilePath sCompletePath
        Integer iRightPos
        
        Move (Value(oOutputFile)) to sFileName
        
        If (sFileName <> "") Begin
            Move (Value(oInputPath)) to sFilePath
            Move (RightPos("\", sFilePath)) to iRightPos
            Move (Left(sFilePath, iRightPos)) to sFilePath
            Move (sFilePath + sFileName) to sCompletePath
        End
               
        Function_Return sCompletePath
    End_Function
    
    Procedure GenerateReport String sOutputPath
        String sMsg
        String[] asSortArray
        Integer iCount iOutputChannel iLoopCnt
        Boolean bFound bFail
        
        If (sOutputPath = "") Begin
            Send Stop_Box "You must specify an output filename." (psMBLabel(Self))
            Move True to bFail
        End
        
        If (not(bFail)) Begin
            Get Seq_New_Channel to iOutputChannel
            
            If (iOutputChannel = DF_SEQ_CHANNEL_NOT_AVAILABLE) Begin
                Send Stop_Box "No file channel available for output." (psMBLabel(Self))
                Move True to bFail
            End
        End
        
        If (not(bFail)) Begin
            Direct_Output channel iOutputChannel sOutputPath
            If (not(SeqEof)) Begin        
                Clear POOCH
                Move 0 to iCount
                
                // get records and prep for sort
                Repeat
                    Find GT POOCH by RecNum
                    Move (Found) to bFound
                    If (bFound) Begin
                        Get BuildSortString POOCH.NAME POOCH.BREED POOCH.AGE to asSortArray[iCount]
                        Increment iCount
                    End
                Until (not(bFound))
                
                // sort
                If (SizeOfArray(asSortArray)) Begin
                    Move (SortArray(asSortArray)) to asSortArray
                End
                
                // write to file
                Decrement iCount
                For iLoopCnt from 0 to iCount
                    Writeln channel iOutputChannel asSortArray[iLoopCnt]
                Loop
            End
            Else Begin
                Move (sOutputPath + " is not a valid output path.") to sMsg
                Send Stop_Box sMsg (psMBLabel(Self))
                Move True to bFail                
            End
            Close_Output channel iOutputChannel
            Send Seq_Release_Channel iOutputChannel
            Send Info_Box ("Report written to " + sOutputPath) (psMBLabel(Self))
        End        
                
    End_Procedure
    
    Function BuildSortString String sName String sBreed Integer iAge Returns String
        String sRetString sAge
        
        Move (String(iAge)) to sAge
        If (Length(sAge) = 1) Move (" " + sAge) to sAge
        
        Case Begin
            Case (Checked_State(oRadioName))
                Move (sName + "  " + sBreed + "  " + sAge) to sRetString
                Case Break
            Case (Checked_State(oRadioBreed))
                Move (sBreed + "  " + sName + "  " + sAge) to sRetString
                Case Break
            Case (Checked_State(oRadioAge))
                Move (sAge + "  " + sBreed + "  " + sName) to sRetString
                Case Break
        Case End
        
        Function_Return sRetString
    End_Function
    
CD_End_Object    // oPoochesView
