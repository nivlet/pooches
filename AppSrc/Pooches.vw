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

        End_Procedure // OnClick
    End_Object    // oDeleteBtn

    Object oImportGrp is a Group
        Set Size to 58 211
        Set Location to 202 14
        Set peAnchors to anBottomLeftRight
        Set Label to "Import"

        Object oOpenImport is a OpenDialog
            Set Dialog_Caption to "Select a file"
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
                // JHS - Leave the rest of this to you.
            End_Procedure // OnClick
        End_Object    // oBrowse

        Object oImport_Btn is a Button
            Set Label to "Import"
            Set Location to 42 155
            Set peAnchors to anBottomRight

            Procedure OnClick

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

            End_Procedure // OnClick
        End_Object    // oReport

    End_Object    // oReportGrp

CD_End_Object    // oPoochesView
