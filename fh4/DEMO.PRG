//////////////////////////////////////////////////////////////////////
//
//  Demo.PRG
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2008. All rights reserved.         
//       Adaptation demo for MiniGui, Grigory Filatov, (á) 2008. All rights reserved.
//  
//  Contents:
//       Simple demo-application for "FastReport for [x]Harbour"
//      
//   
//////////////////////////////////////////////////////////////////////

#include "Minigui.ch"
#include "FastRepH.CH"
#include "lang_en.ch"
//#include "lang_ru.ch"


PROCEDURE Main
   LOCAL aTmp, x, n := GetTitleHeight() - GetBorderHeight()
   MEMVAR RepDir, DataDir, ResDir
   MEMVAR FrPrn, lShowCustName
   FIELD CustNo, Company, OrderNo, ItemNo, PartNo
   PRIVATE FrPrn, lShowCustName := .f.

   REQUEST DBFCDX

   RepDir := CurDrive() +":\"+ CurDir() + '\REPS\'
   DataDir := CurDrive() +":\"+ CurDir() + '\DATA\'
   ResDir := CurDrive() +":\"+ CurDir() + '\LANGRES\'

   SET DEFAULT TO "data\"

   IF ! AllFilesExist( { "CUSTA.NTX", "CUSTB.NTX" } )
      USE Customer EXCLUSIVE
      INDEX ON CustNo  TO CustA
      INDEX ON Company TO CustB
      CLOSE
   ENDIF

   IF ! AllFilesExist( { "ORDERSA.NTX", "ORDERSB.NTX" } )
      USE Orders EXCLUSIVE
      INDEX ON OrderNo   TO ORDERSA
      INDEX ON CustNo    TO ORDERSB
      CLOSE
   ENDIF

   IF ! AllFilesExist( { "itemsa.NTX", "itemsb.NTX", "itemsc.NTX" } )
      USE Items EXCLUSIVE
      INDEX ON str(OrderNo, 15)+str(ItemNo, 15)  TO itemsa
      INDEX ON OrderNo                           TO itemsb
      INDEX ON PartNo                            TO itemsc
      CLOSE
   ENDIF

   IF ! AllFilesExist( { "parts.NTX", } )
      USE Parts EXCLUSIVE
      INDEX ON PartNo TO parts
      CLOSE
   ENDIF


   SET DELETED ON


   USE Customer NEW
   SET INDEX TO CustA, CustB
   SET ORDER TO 2
   GO TOP

   USE Orders NEW
   SET INDEX TO ORDERSA, ORDERSB
   SET ORDER TO 2
   GO TOP

   USE Items NEW
   SET INDEX TO itemsa, itemsb, itemsc
   SET ORDER TO 2
   GO TOP

   USE Parts NEW
   SET INDEX TO Parts
   SET ORDER TO 1
   GO TOP


	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 800 HEIGHT 600 ;
		TITLE "CompuSoft Informática & Sistemas - Jair" ;
		ICON 1 ;
		MAIN ;
		NOMAXIMIZE NOSIZE ;
		ON RELEASE UnloadFr() ;
		FONT 'MS Sans Serif' SIZE 9

		DEFINE BUTTON Button_1
			ROW	540 - n
			COL	577
			WIDTH   200 
			HEIGHT  30
			CAPTION _cQuit
			ACTION	ReleaseAllWindows() 
			TOOLTIP _cQuit
			DEFAULT .T.
		END BUTTON

		DEFINE FRAME Frame_1	
			ROW 	40 - n
			COL	12
			CAPTION _cAct
			WIDTH  430 
			HEIGHT 50 
		END FRAME

		DEFINE RADIOGROUP Radio_1
			ROW	56 - n
			COL	32
			OPTIONS { _cShow , _cDesign , _cPrint, _cExport } 
			VALUE 1 
			WIDTH 94
			SPACING 6 
			TOOLTIP _cAct
			HORIZONTAL .T.
		END RADIOGROUP

		DEFINE LABEL Label_1
			ROW	530 - n
			COL	12
			WIDTH	520 
			HEIGHT	20
			VALUE	_cCopyright
		END LABEL

		DEFINE LABEL Label_2
			ROW	550 - n
			COL	12
			WIDTH	55
			HEIGHT	20
			VALUE	_cSale
		END LABEL

		DEFINE HYPERLINK Label_3
			ROW	550 - n
			COL	75
			WIDTH	300
			HEIGHT	20
			VALUE	_cSaleSite
			ADDRESS _cSaleSite
			HANDCURSOR .T.
		END HYPERLINK

		DEFINE BUTTON Button_2
			ROW	110 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cSmlList
			ACTION	DoSimpleList()
			TOOLTIP _cSmlList
		END BUTTON

		DEFINE BUTTON Button_3
			ROW	160 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cSLgroup
			ACTION	DoSimpleGroup()
			TOOLTIP _cSLgroup
		END BUTTON

		DEFINE BUTTON Button_4
			ROW	210 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cMCompl
			ACTION	DoMoreComplex()
			TOOLTIP _cMCompl
		END BUTTON

		DEFINE BUTTON Button_5
			ROW	260 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cUDS
			ACTION	DoUserDS()
			TOOLTIP _cUDS
		END BUTTON

		DEFINE BUTTON Button_6
			ROW	310 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cWA_DS
			ACTION	DoWAUserDS()
			TOOLTIP _cWA_DS
		END BUTTON

		DEFINE BUTTON Button_7
			ROW	360 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cAdo
			ACTION	DoADO()
			TOOLTIP _cAdo
		END BUTTON

		DEFINE BUTTON Button_8
			ROW	410 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cCalls
			ACTION	DoSomeCalls()
			TOOLTIP _cCalls
		END BUTTON

		DEFINE BUTTON Button_9
			ROW	460 - n
			COL	12
			WIDTH   200 
			HEIGHT  30
			CAPTION _cMComplFR
			ACTION	DoInFR_MoreComplex()
			TOOLTIP _cMComplFR
		END BUTTON

		DEFINE BUTTON Button_10
			ROW	460 - n
			COL	220
			WIDTH   200 
			HEIGHT  30
			CAPTION _cManualReport
			ACTION	DoManualReport()
			TOOLTIP _cManualReport
		END BUTTON

		DEFINE BUTTON Button_11
			ROW	110 - n
			COL	220
			WIDTH   200 
			HEIGHT  30
			CAPTION _cMemPict
			ACTION	DoMemPict()
			TOOLTIP _cMemPict
		END BUTTON

		DEFINE COMBOBOX Combo_1
			ROW	58 - n
			COL	480
			WIDTH   200 
			HEIGHT  150
			ITEMS	{}
			TOOLTIP _cSelLang
			ONCHANGE FrPrn:LoadLangRes(ResDir + Form_1.Combo_1.Item(Form_1.Combo_1.Value) + ".xml")
		END COMBOBOX

   aTmp := Directory(ResDir + "*.xml")
   FOR x := 1 TO Len(aTmp)
     Form_1.Combo_1.addItem(Substr(aTmp[x, 1], 1, Len(aTmp[x, 1]) - 4))
   NEXT   
     // Tradução para portugues 
     Form_1.Combo_1.Value := AScan( aTmp, {|e| e[1] = "Portugues.xml"} )

		DEFINE LABEL Label_4
			ROW	38 - n
			COL	480
			WIDTH	200
			HEIGHT	20
			VALUE	_cSelLang
		END LABEL

		DEFINE LABEL Label_5
			ROW	88 - n
			COL	490
			WIDTH	350
			HEIGHT	20
			VALUE	_cOthLang
		END LABEL

		DEFINE FRAME Frame_2
			ROW 	122 - n
			COL	480
			CAPTION _cLast
			WIDTH  300
			HEIGHT 218 
		END FRAME

		DEFINE LABEL Label_6
			ROW	146 - n
			COL	492
			WIDTH	40
			HEIGHT	24
			VALUE	_cName
		END LABEL

		DEFINE LABEL Label_7
			ROW	146 - n
			COL	534
			WIDTH	248
			HEIGHT	24
			VALUE	""
		END LABEL

		DEFINE LABEL Label_8
			ROW	170 - n
			COL	492
			WIDTH	84
			HEIGHT	24
			VALUE	_cDescr
		END LABEL

		DEFINE LABEL Label_9
			ROW	194 - n
			COL	492
			WIDTH	276
			HEIGHT	126
			VALUE	""
		END LABEL

		DEFINE FRAME Frame_3
			ROW 	350 - n
			COL	480
			CAPTION _cCState
			WIDTH  300
			HEIGHT 130
		END FRAME

		DEFINE LABEL Label_10
			ROW	380 - n
			COL	500
			WIDTH	250
			HEIGHT	20
			VALUE	_cNoRep
		END LABEL

		DEFINE LABEL Label_11
			ROW	400 - n
			COL	500
			WIDTH	250
			HEIGHT	60
			VALUE	""
		END LABEL

 //----------- Now load and init FastReport --------------------------------------

   FrPrn := frReportManager():new()

 //---------- Set the same icon for FastReport windows----------
   
   FrPrn:SetIcon(1)

 //---------- Set the same title for FastReport taskBar-window
   
   FrPrn:SetTitle(_cTitle)

 //-----------Set to disable main window when FastReport executes----------------------

//   FrPrn:SetVisualActions(FR_ACT_NONE)
   FrPrn:SetVisualActions(FR_ACT_USER, .F., {|| DoMethod('Form_1', 'Hide')}, {|| DoMethod('Form_1', 'Show')})

 //-----------Set progress event handlers-----------------------------------------------
   
   FrPrn:SetEventHandler("Report", "OnProgressStart", {|x,y|ShowProgress(x, y, 1)})
   FrPrn:SetEventHandler("Report", "OnProgressStop", {|x,y|ShowProgress(x, y, 2)})
   FrPrn:SetEventHandler("Report", "OnProgress", {|x,y|ShowProgress(x, y, 3)})
   FrPrn:SetEventHandler("Report", "OnBeforePrint", {|ObjName|ShowProcess(ObjName)})
 
   
 //-------- add function to FastReport (see calls example)----------------------
   FrPrn:SetEventHandler("Report", "OnUserFunction", {|FName, FParams| CallUserFunction(FName, FParams)})   
   FrPrn:AddFunction("function XBaseStr(nValue: Double, nLength: Variant = EmptyVar, nDecimals: Variant = EmptyVar): Variant",;
                     "My Lovely Functions!", "It's a XBase Str() function!")
 

     
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

RETURN


PROCEDURE UnloadFr()
 //-------- Unload FastReport -------------------------------------------------------------
   FrPrn:DestroyFR()

RETURN


PROCEDURE DoFrAction(cFileName, lPrepared)     
LOCAL nAction := Form_1.Radio_1.Value, lNotOpened := .f.
PRIVATE cExpObj, cExpFile, lExpOpt, lExpOpen, cExtention
   lPrepared := IF(lPrepared <> NIL, lPrepared, .f.)
   IF !lPrepared .and. (cFileName <> NIL)
     FrPrn:LoadFromFile(RepDir + cFileName)
   ENDIF

   Form_1.Label_7.Value := FrPrn:ReportOptions:SetName()
   Form_1.Label_9.Value := FrPrn:ReportOptions:SetDescription()
      
   DO CASE
     CASE nAction == 1
        FrPrn:ShowReport()
     CASE nAction == 2
        FrPrn:DesignReport()
     CASE nAction == 3
        FrPrn:SetProperty("Report", "ShowProgress", .f.)
        IF !lPrepared 
          FrPrn:PrepareReport()
        ENDIF
        FrPrn:Print(.t.)
        FrPrn:SetProperty("Report", "ShowProgress", .t.)
     CASE nAction == 4
        IF GetExportObject() 
          FrPrn:SetProperty("Report", "ShowProgress", .f.)
          IF !lPrepared 
            FrPrn:PrepareReport()
          ENDIF
          FrPrn:SetProperty(cExpObj, "ShowDialog", lExpOpt)
          IF (cExpObj = "MailExport").and.!lExpOpt 
             FrPrn:SetProperty(cExpObj, "ShowDialog", .t.)
          ENDIF
          IF AScan({"XLSExport","XMLExport"},  cExpObj) > 0                   
             FrPrn:SetProperty(cExpObj, "OpenExcelAfterExport", lExpOpen)
          ELSE
            IF AScan({"BMPExport", "TIFFExport", "JPEGExport", "GIFExport",;
                      "DotMatrixExport", "TXTExport"},  cExpObj) > 0
               lNotOpened := .t.
            ELSE
               FrPrn:SetProperty(cExpObj, "OpenAfterExport", lExpOpen)
            ENDIF
          ENDIF          
          IF lExpOpen .and. !lNotOpened
            IF cExpObj <> "SimpleTextExport"
              cExtention := "." + Left(cExpObj, 3)
            ELSE
              cExtention := ".TXT"
            ENDIF
            IF Right(cExpFile, 4) <> cExtention
              cExpFile := cExpFile + cExtention
            ENDIF                      
          ENDIF
          FrPrn:SetProperty(cExpObj, "FileName", cExpFile)          
          FrPrn:DoExport(cExpObj)
          IF lExpOpen .and. lNotOpened 
            MsgBox(_cNoOpen, "Warning")
          ENDIF
          FrPrn:SetProperty("Report", "ShowProgress", .t.)
        ENDIF
   ENDCASE
   Form_1.Label_11.Value := ""
RETURN

PROCEDURE DoSimpleList()
   FrPrn:SetWorkArea("Customers", 1)
   FrPrn:SetFieldAliases("Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact")
   lShowCustName := .t.
   DoFrAction("1.fr3")
   FrPrn:ClearDataSets()
   lShowCustName := .f.
RETURN

PROCEDURE DoSimpleGroup()
   FrPrn:SetWorkArea("Customers", 1)
   FrPrn:SetFieldAliases("Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact")
   lShowCustName := .t.
   DoFrAction("2gr.fr3")
   FrPrn:ClearDataSets()
   lShowCustName := .f.
RETURN

PROCEDURE DoMoreComplex()
   Select Items
   SET ORDER TO 2
   lShowCustName := .t.   
   FrPrn:SetWorkArea("Customers", 1)
   FrPrn:SetFieldAliases("Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact")  
   FrPrn:SetWorkArea("Orders", 2)
   FrPrn:SetWorkArea("Items", 3)
   FrPrn:SetWorkArea("Parts", 4)           
   FrPrn:SetMasterDetail("Customers", "Orders", {||Customer->CustNo})      
   FrPrn:SetMasterDetail("Orders", "Items", {||Orders->OrderNo})         
   DbSetRelation(4,  {||PartNo})
   FrPrn:SetResyncPair("Items", "Parts")
   DoFrAction("4.fr3")
   FrPrn:ClearDataSets()       
   Select Items
   DbClearRelation()
   lShowCustName := .f.
RETURN

PROCEDURE DoInFR_MoreComplex()
   DoFrAction("md.fr3")
RETURN


PROCEDURE MyManualReport()
  FrPrn:SetDefaultFontProperty("Name", "Times New Roman")
  FrPrn:SetDefaultFontProperty("Size", 16)
  
  tmp_Name := FrPrn:MemoAt("Some memo with bottom frame ...", 30, 30, 300, 50)  
  FrPrn:SetManualObjProperty(tmp_Name + ".Frame", "Typ", "[ftBottom]")

  FrPrn:LineAt(30, 200, 100, 100)
  FrPrn:MemoAt("<-- It's a some line ...", 200, 250, 350, 50)

  FrPrn:PictureAt(DataDir + "logo.bmp" , 30, 400, 300, 300)
  FrPrn:MemoAt("<-- It's a some picture ...", 350, 420, 320, 50)

  FrPrn:NewPage()

  FrPrn:MemoAt("It's a second page..................", 30, 30, 100, 1000)
RETURN

PROCEDURE DoManualReport()
  FrPrn:StartManualBuild({||MyManualReport()}, FR_LANDSCAPE, , FR_PIXELS)
  DoFrAction()
RETURN

PROCEDURE DoMemPict()
    
    USE ( DataDir + "Biolife.dbf" ) VIA "DBFCDX" NEW
    GO TOP
    
    FrPrn:SetWorkArea("Biolife", 5)
    DoFrAction("9new.fr3")
    
    CLOSE BioLife

RETURN

PROCEDURE DoUserDS()
PRIVATE aDir, I := 1, DirName := "C:\*.*"
   aDir := Directory(DirName)  
   FrPrn:SetUserDataSet("Dir", "F_NAME;F_SIZE;F_CREATION_DATE",;
                                {||I := 1}, {||I := I + 1}, ;
                                {||I := I - 1}, {||I > Len(aDir)},;
                                {|aField|xx := IF(aField="F_NAME",1, IF(aField="F_SIZE", 2, 3)) , aDir[I, xx]})

   DoFrAction("6.fr3")
   FrPrn:ClearDataSets()
RETURN


FUNCTION GetDSValue(cField)
LOCAL RES 
   DO CASE 
      CASE cField == "PartNo"
         RETURN Parts->PartNo
      CASE cField == "Part"
         RETURN Parts->Descriptio
      CASE cField == "Total qty"
         SELECT Items
         OrdScope(0, Parts->PartNo)
         OrdScope(1, Parts->PartNo)
         SUM QTY TO RES
         RETURN RES
      CASE cField == "Price"
         RETURN Parts->ListPrice
   ENDCASE
RETURN NIL


PROCEDURE DoWAUserDS()
   SELECT Items
   SET ORDER TO 3      
   FrPrn:SetUserDataSet("Parts in oders", "PartNo;Part;Total qty;Price",;
                     {|| Parts->( DbGoTop() )} ,;
                     {|| Parts->( DbSkip(1) )},;
                     {|| Parts->( DbSkip(-1) )},;
                     {|| Parts->( Eof() )},;                 
                     {|cField| GetDSValue(cField)})

   DoFrAction("9.fr3")
   SELECT Items
   OrdScope(0, nil)
   OrdScope(1, nil)
   FrPrn:ClearDataSets()
RETURN



PROCEDURE DoADO()
   FrPrn:LoadFromFile(RepDir + "24.fr3")
   FrPrn:SetADOConnectPartStr("ADODatabase1", "Data Source", DataDir + "demo.mdb")
   DoFrAction()
RETURN

PROCEDURE DoSomeCalls()
   FrPrn:LoadFromFile(RepDir + "7.fr3")
   FrPrn:AddVariable("My Lovely Vars", "My and only my var", 10)
   FrPrn:AddVariable("My Lovely Vars", "test", 100.25)
   FrPrn:AddVariable("My Lovely Vars", "test1", "'Test'")
   FrPrn:AddVariable("My Lovely Vars", "test2", ctod("01/01/2007"))
   DoFrAction()
RETURN


FUNCTION GetExportObject()
   LOCAL lExport := .F., n := GetTitleHeight() - GetBorderHeight()
   LOCAL aExpList := {"PDFExport", "HTMLExport", "RTFExport", "CSVExport",;
                      "XLSExport", "DotMatrixExport", "BMPExport", "JPEGExport",;
                      "TXTExport", "TIFFExport", "GIFExport",;
                      "SimpleTextExport", "MailExport", "XMLExport"}

	DEFINE WINDOW Form_2 ;
		AT 0,0 ;
		WIDTH 440 HEIGHT 340 ;
		TITLE _cExp ;
		ICON 1 ;
		MODAL ;
		NOSIZE ;
		ON RELEASE OnExpRelease(lExport, aExpList) ;
		FONT 'MS Sans Serif' SIZE 9

		DEFINE LISTBOX List_1	
			ROW	48 - n
			COL	12
			WIDTH	288 
			HEIGHT	180 
			ITEMS	aExpList
			VALUE	1
			ONDBLCLICK Form_2.Button_1.OnClick
		END LISTBOX

		DEFINE BUTTON Button_1
			ROW	48 - n
			COL	324
			WIDTH   96
			HEIGHT  36
			CAPTION _cExp
			ACTION	{|| lExport := .T., Form_2.Release }
			TOOLTIP _cQuit
		END BUTTON

		DEFINE TEXTBOX Text_1
			ROW	254 - n
			COL	12
			WIDTH   288
			HEIGHT  22
			VALUE RepDir + 'export' 
		END TEXTBOX

		DEFINE LABEL Label_1
			ROW	34 - n
			COL	12
			WIDTH	276
			HEIGHT	14
			VALUE	_cSelExp
		END LABEL

		DEFINE LABEL Label_2
			ROW	240 - n
			COL	12
			WIDTH	156
			HEIGHT	14
			VALUE	_cFileName
		END LABEL

		DEFINE CHECKBOX Check_1
			ROW	284 - n
			COL	12
			WIDTH	288
			HEIGHT	20
			CAPTION _cAddDialog 
			VALUE .T. 
		END CHECKBOX

		DEFINE CHECKBOX Check_2
			ROW	304 - n
			COL	12
			WIDTH	288
			HEIGHT	20
			CAPTION _cOpenD
			VALUE .T. 
		END CHECKBOX

	END WINDOW

	CENTER WINDOW Form_2

	ACTIVATE WINDOW Form_2

RETURN lExport

PROCEDURE OnExpRelease(lExport, aExpList)
   IF lExport 
      cExpObj := aExpList[Form_2.List_1.Value]
      cExpFile := Form_2.Text_1.Value
      lExpOpt := Form_2.Check_1.Value
      lExpOpen := Form_2.Check_2.Value
   ENDIF
RETURN


//----------


PROCEDURE ShowProgress(x, y, z)
LOCAL Res  
  DO CASE 
      CASE x == 0 
         Res := "Prepare "
      CASE x == 1 
         Res := "Export "
      CASE x == 2 
         Res := "Printing "
  ENDCASE

  DO CASE 
      CASE z == 1 
         Res := Res + "Started"
      CASE z == 2 
         Res := Res + "Finished"
      CASE z == 3 
         Res := Res + " - " + Str(y)
  ENDCASE  
  Form_1.Label_10.Value := Res
RETURN

PROCEDURE ShowProcess(sObjectName)
LOCAL cRes
  IF lShowCustName 
    cRes := "Proccessing - " + Trim((1)->Company) + " " + sObjectName
  ELSE
    cRes := "Proccessing - " + " " + sObjectName
  ENDIF
  Form_1.Label_11.Value := cRes
RETURN

FUNCTION CallUserFunction(FName, FParams)
LOCAL RES
  IF (FName == "XBASESTR")
    RES := Str(FParams[1], FParams[2], FParams[3])    
  ENDIF
RETURN RES


/*
 * Check if all files of the array 'aFiles' exist
*/
FUNCTION AllFilesExist( aFiles )
   LOCAL lExist := .T., i:=0, imax := Len(aFiles)

   DO WHILE ++i <= imax .AND. lExist
      lExist := File( aFiles[i] )
   ENDDO
RETURN lExist


//------------ Include "FastRepH.prg"
//#Include "FastRepH.prg"
