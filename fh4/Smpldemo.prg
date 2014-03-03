//////////////////////////////////////////////////////////////////////
//
//  SmplDemo.PRG
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2006. All rights reserved.
//
//  Contents:
//       Very simple demo-application for "FastReport for [x]Harbour"
//
//
//////////////////////////////////////////////////////////////////////


#include "inkey.ch"
#include "Achoice.ch"
#include "FastRepH.ch"
#include "hbextern.ch"
#include "lang_en.ch"


PROCEDURE Main
   LOCAL x
   MEMVAR RepDir, DataDir, ResDir
   MEMVAR FrPrn

   FIELD CustNo, Company, OrderNo, ItemNo, PartNo
   PRIVATE FrPrn, lShowCustName := .f.
   PRIVATE curAction := 1, curKey := 0, cLang, aLang

      SETMODE(24,79)
      CLS
      SET CURSOR OFF
      SET( _SET_EVENTMASK, INKEY_KEYBOARD )

   
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



 //----------- Now load and init FastReport --------------------------------------

   FrPrn := frReportManager():new()

 //---------- Set the same title for FastReport taskBar-window
   
   FrPrn:SetTitle(_cTitle)   

 //-----------Set progress event handlers-----------------------------------------------
   
   FrPrn:SetEventHandler("Report", "OnProgressStart", {|x,y|ShowProgress(x, y, 1)})
   FrPrn:SetEventHandler("Report", "OnProgressStop", {|x,y|ShowProgress(x, y, 2)})
   FrPrn:SetEventHandler("Report", "OnProgress", {|x,y|ShowProgress(x, y, 3)})
   FrPrn:SetEventHandler("Report", "OnBeforePrint", {|ObjName|ShowProcess(ObjName)})
 
   
 //-------- add function to FastReport (see calls example)----------------------
   FrPrn:SetEventHandler("Report", "OnUserFunction", {|FName, FParams| CallUserFunction(FName, FParams)})   
   FrPrn:AddFunction("function XBaseStr(nValue: Double, nLength: Variant = EmptyVar, nDecimals: Variant = EmptyVar): Variant",;
                     "My Lovely Functions!", "It's a XBase Str() function!")

   aLang := Directory(ResDir + "*.xml")
   FOR x := 1 TO Len(aLang)
     aLang[x] := Substr(aLang[x, 1], 1, Len(aLang[x, 1]) - 4)
   NEXT   
   cLang := "English"

   @ 5, 37, 14, 76  BOX "ÚÄ¿³ÙÄÀ³ " COLOR("15/0")
   @ 5, 40 SAY _cLast COLOR("3/0")

   @ 16, 37, 21, 76  BOX "ÚÄ¿³ÙÄÀ³ " COLOR("15/0")
   @ 16, 40 SAY _cCState COLOR("3/0")


   DO WHILE .T.
     
       RefreshScreen()

       curKey := GetCurKey()

       IF curKey == K_ESC
         EXIT
       ENDIF

   ENDDO


 //-------- Unload FastReport -------------------------------------------------------------

   FrPrn:DestroyFR()

   QUIT

RETURN  

FUNCTION GetCurKey()
LOCAL kKey, Sel, Scr

    kKey := Inkey(0)

    IF (kKey == K_TAB)
      IF (CurAction == 4)
        CurAction := 1
      ELSE
        CurAction := CurAction + 1
      ENDIF
      RETURN kKey
    ENDIF

    IF (kKey == 49)
      DoSimpleList()
      RETURN kKey
    ENDIF

    IF (kKey == 50)
      DoSimpleGroup()
      RETURN kKey
    ENDIF

    IF (kKey == 51)
      DoMoreComplex()
      RETURN kKey
    ENDIF

    IF (kKey == 52)
      DoUserDS()
      RETURN kKey
    ENDIF

    IF (kKey == 53)
      DoWAUserDS()
      RETURN kKey
    ENDIF

    IF (kKey == 54)
      DoADO()
      RETURN kKey
    ENDIF

    IF (kKey == 55)
      DoSomeCalls()
      RETURN kKey
    ENDIF

    IF (kKey == 56)
      DoInFR_MoreComplex()
      RETURN kKey
    ENDIF

    IF (kKey == 57)
      DoManualReport()
      RETURN kKey
    ENDIF

    IF (kKey == 48)
      DoMemPict()
      RETURN kKey
    ENDIF

    IF (kKey == K_F5)
      Scr := SAVESCREEN(3, 40, 9, 67)
      SetColor("2/10")
      Sel := achoice(3, 40, 9, 67, aLang)
      SetColor("15/0")
      RestScreen(3, 40, 9, 67, Scr)
      IF Sel > 0 
        CLang := aLang[Sel]
        FrPrn:LoadLangRes(ResDir + cLang + ".xml")
      ENDIF
      RETURN kKey
    ENDIF


RETURN kKey

FUNCTION GetActColor(nCl)
RETURN IF(nCl = CurAction, "0/15", "")


FUNCTION RefreshScreen()
    
    @ 1, 1, 3, 34 BOX "ÚÄ¿³ÙÄÀ³ " COLOR("15/0")

    @ 2, 2 SAY _cShow  COLOR(GetActColor(1))
    @ 2, 9 SAY _cDesign  COLOR(GetActColor(2))
    @ 2, 18 SAY _cPrint  COLOR(GetActColor(3))
    @ 2, 26 SAY _cExport  COLOR(GetActColor(4))

    @ 1, 4 SAY "FrAction (Tab -select)" COLOR("3/0")


    @ 5, 1, 21, 34 BOX "ÚÄ¿³ÙÄÀ³ " COLOR("15/0")
    @ 5, 4 SAY "Reports (select - Left symb)" COLOR("3/0")

    @ 7, 3 SAY "1 - " + _cSmlList 
    @ 8, 3 SAY "2 - " + _cSLgroup 
    @ 9, 3 SAY "3 - " + _cMCompl  
    @ 10, 3 SAY "4 - " + _cUDS     
    @ 11, 3 SAY "5 - " + _cWA_DS   
    @ 12, 3 SAY "6 - " + _cAdo     
    @ 13, 3 SAY "7 - " + _cCalls   
    @ 14, 3 SAY "8 - " + _cMComplFR    
    @ 15, 3 SAY "9 - " + _cManualReport
    @ 16, 3 SAY "0 - " + _cMemPict     


    @ 1, 37, 3, 76  BOX "ÚÄ¿³ÙÄÀ³ " COLOR("15/0")
    @ 1, 40 SAY "FastReport language (F5 -select)" COLOR("3/0")    
    @ 2, 40 SAY cLang COLOR("2/0")


    @ 22, 2 SAY _cCopyright COLOR("3/0")
    @ 23, 2 SAY _cSale + _cSaleSite COLOR("3/0")

    @ 23, 67 SAY "Esc - Exit"  COLOR("3/0")

                              
RETURN NIL


               
PROCEDURE DoFrAction(cFileName, lPrepared)     
PRIVATE cExpObj, cExpFile, lExpOpt := .t., lExpOpen := .t., cExtention, lNotOpened := .f.
        
   lPrepared := IF(lPrepared <> NIL, lPrepared, .f.)
   IF !lPrepared .and. (cFileName <> NIL)
     FrPrn:LoadFromFile(RepDir + cFileName)
   ENDIF

   ShowNameAndDescr()   
      
   DO CASE
     CASE (CurAction == 1)
        FrPrn:ShowReport()
     CASE (CurAction == 2)
        FrPrn:DesignReport()
     CASE (CurAction == 3)
        FrPrn:SetProperty("Report", "ShowProgress", .f.)
        IF !lPrepared 
          FrPrn:PrepareReport()
        ENDIF
        FrPrn:Print(.t.)
        FrPrn:SetProperty("Report", "ShowProgress", .t.)
     CASE (CurAction == 4)
        IF GetExportObject() 
          cExpFile := RepDir + "export"
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
          IF lExpOpen.and.lNotOpened 
            Alert(_cNoOpen)
          ENDIF
          FrPrn:SetProperty("Report", "ShowProgress", .t.)
        ENDIF
   ENDCASE

  @ 19, 39 SAY Space(36) COLOR("15/0")
  @ 20, 39 SAY Space(36) COLOR("15/0")
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
   lShowCustName  := .t.
   DoFrAction("md.fr3")
   lShowCustName  := .f.
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

  @ 18, 39 SAY Space(36) COLOR("15/0")
  @ 18, 39 SAY RES COLOR("15/0")

RETURN

PROCEDURE ShowProcess(sObjectName)
LOCAL cRes, cRes2 := ""
  IF lShowCustName 
    cRes := "Proc: " + Trim((1)->Company) + " " + sObjectName
  ELSE
    cRes := "Proc: " + sObjectName
  ENDIF


  IF (Len(cRes) > 36)
    cRes2 := SUBSTR(cRes, 37, Len(cRes))
    cRes := SUBSTR(cRes, 1, 36)
    IF Len(cRes2) > 36
      cRes2 := SUBSTR(cRes2, 1, 33) + "..."
    ENDIF
  ENDIF


  @ 19, 39 SAY Space(36) COLOR("15/0")
  @ 20, 39 SAY Space(36) COLOR("15/0")
  @ 19, 39 SAY cRes COLOR("15/0")
  IF cRes2 <> "" 
    @ 20, 39 SAY cRes2 COLOR("15/0")
  ENDIF
RETURN

FUNCTION CallUserFunction(FName, FParams)
LOCAL RES
  IF (FName == "XBASESTR")
    RES := Str(FParams[1], FParams[2], FParams[3])    
  ENDIF
RETURN RES


FUNCTION GetDelimArr(cStr)
LOCAL x, I := 0, Beg := 1, Ar := {}, cChar

   
   FOR x := 1 TO LEN(cStr)          
     I := I + 1
     cChar := SubStr(cStr, x, 1)
     IF cChar == Chr(13) 
       AAdd(Ar, Substr(cStr, beg, x - beg))
       beg := x + 2
       I := 0
     ELSE       
       IF (I > 35)
         AAdd(Ar, Substr(cStr, beg, I))
         beg := x + 1
         I := 0
       ENDIF
     ENDIF    
   NEXT
    
  AAdd(Ar, SubStr(cStr, beg, Len(cStr)))
 
RETURN Ar

FUNCTION ShowNameAndDescr()
LOCAL NN :={}, DD := {}, x 

   NN := GetDelimArr(FrPrn:ReportOptions:SetName())
   DD := GetDelimArr(FrPrn:ReportOptions:SetDescription())   
   
   @ 6, 40 SAY "Name:" COLOR("3/0")
   @ 7, 39 SAY Space(36) COLOR("15/0") 
   @ 8, 39 SAY Space(36) COLOR("15/0")   
   
   @ 7, 39 SAY NN[1] COLOR("15/0")   
   IF Len(NN) > 1 
      @ 8, 39 SAY NN[2] COLOR("15/0")
   ENDIF

   @ 9, 40 SAY "Description:" COLOR("3/0")
   @ 10, 39 SAY Space(36) COLOR("15/0") 
   @ 11, 39 SAY Space(36) COLOR("15/0")   
   @ 12, 39 SAY Space(36) COLOR("15/0")   
   @ 13, 39 SAY Space(36) COLOR("15/0")   

   FOR x := 1 TO Min(Len(DD), 4)
     @ 9 + x, 39 SAY LTrim(DD[x]) COLOR("15/0")   
   NEXT

RETURN NIL

FUNCTION GetExportObject()
   LOCAL Scr, Sel := 0, lExport := .F.
   LOCAL aExpList := {"PDFExport", "HTMLExport", "RTFExport", "CSVExport",;
                      "XLSExport", "DotMatrixExport", "BMPExport", "JPEGExport",;
                      "TXTExport", "TIFFExport", "GIFExport",;
                      "SimpleTextExport", "MailExport", "XMLExport"}

   Scr := SAVESCREEN(4, 20, 18, 50)
   SetColor("2/10")
   Sel := achoice(4, 20, 18, 50, aExpList)
   SetColor("15/0")
   RestScreen(4, 20, 18, 50, Scr)
   IF Sel > 0 
      cExpObj := aExpList[Sel]
      lExport := .t.
   ENDIF
RETURN lExport


/*
 * Check if all files of the array 'aFiles' exist
 */

FUNCTION AllFilesExist( aFiles )
   LOCAL lExist := .T., i:=0, imax := Len(aFiles)

   DO WHILE ++i <= imax .AND. lExist
      lExist := File( aFiles[i] )
   ENDDO
RETURN lExist
