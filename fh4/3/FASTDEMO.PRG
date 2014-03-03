//////////////////////////////////////////////////////////////////////
//
//  FastDemo.PRG
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2006. All rights reserved.
//       Adaptation demo for console of [x]Harbour, Verchenko Andrey, (á) 2008. All rights reserved.
//
//  Contents:
//       Simple demo-application for "FastReport for [x]Harbour"
//
//
//////////////////////////////////////////////////////////////////////

#include "inkey.ch"
#include "getexit.ch"
#include "FastRepH.ch"
#include "lang_en.ch"
//#include "lang_ru.dos.ch"

#define DLL_STDCALL  32   // for run Dll

#define GE_BUTTON1   21
#define GE_BUTTON2   22
#define GE_BUTTON3   23
#define GE_BUTTON4   24
#define GE_BUTTON5   25
#define GE_BUTTON6   26
#define GE_BUTTON7   27
#define GE_BUTTON8   28
#define GE_BUTTON9   29
#define GE_BUTTON10  30
#define GE_BUTTON11  31
#define GE_BUTTON12  32


PROCEDURE DoFastDemo
   LOCAL aRet, cLang := "" , cFuncName, xFun, nFastAct := 0, cStrRun
   PRIVATE FrPrn, lShowCustName := .f.  // Obligatory variable

   PUBLIC RepDir, DataDir, ResDir



   M->RepDir  := CurDrive() + ":\" + CurDir() + '\REPS\'
   M->DataDir := CurDrive() + ":\" + CurDir() + '\DATA\'
   M->ResDir  := CurDrive() + ":\" + CurDir() + '\LANGRES\'

   Set DEFAULT TO ".\data\"

   MyCreateIndex()

   MyOpenDbfIndex()

   //----------- Now load and init FastReport --------------------------------------
   FrPrn := frReportManager():new()

   //---------- Set the same icon for FastReport windows----------
   FrPrn:SetIcon( 1 )

   //---------- Set the same title for FastReport taskBar-window
   FrPrn:SetTitle( _cTitle )

   //-----------Set to disable main window when FastReport executes----------------------
   //  FrPrn:SetVisualActions(FR_ACT_DISABLE);

   //-----------Set progress event handlers-----------------------------------------------
   FrPrn:SetEventHandler( "Report", "OnProgressStart", { | x, y | ShowProgress( x, y, 1 ) } )
   FrPrn:SetEventHandler( "Report", "OnProgressStop", { | x, y | ShowProgress( x, y, 2 ) } )
   FrPrn:SetEventHandler( "Report", "OnProgress", { | x, y | ShowProgress( x, y, 3 ) } )
   FrPrn:SetEventHandler( "Report", "OnBeforePrint", { | ObjName | ShowProcess( ObjName ) } )

   //-------- add XBase++ function to FastReport (see calls example)----------------------
   FrPrn:SetEventHandler( "Report", "OnUserFunction", { | FName, FParams | CallUserFunction( FName, FParams ) } )
   FrPrn:AddFunction( "function XBaseStr(nValue: Double, nLength: Variant = EmptyVar, nDecimals: Variant = EmptyVar): Variant", ;
                      "My Lovely Functions!", "It's a XBase Str() function!" )


   DO WHILE .T.

      aRet := MyQuestButton( cLang, nFastAct )

      IF Len( aRet ) == 0
         EXIT
      ELSE

         nFastAct := aRet[ 1 ]  ; nKey := aRet[ 2 ]  ; cFuncName := aRet[ 3 ]  ; cLang := aRet[ 4 ]

         IF At( "DLLCALL", Upper( cFuncName ) ) > 0
            // ------------ Command for xHarbour ------------------
            DllCall( "shell32.dll", DLL_STDCALL, "ShellExecuteA", NIL, "open", _cSaleSite, NIL, NIL, 1 )
  
            // ------------ Command for Harbour or xHarbour ------------------
            cStrRun := 'rundll32 url.dll, FileProtocolHandler "' + _cSaleSite + '"'
            //RUN (cStrRun )
        ELSE
            cFuncName := SubStr( cFuncName, 1, Len( cFuncName ) - 2 )
            xFun := Type( cFuncName + "()" )
            IF .NOT.( xFun == 'UI' .OR. xFun == 'UE' )
               Alert( 'Function ' + cFuncName + '() no in EXE file !' )
            ELSE
               &cFuncName( nFastAct )
            ENDIF
         ENDIF

      ENDIF // LEN(aRet) == 0

   ENDDO  // .T.

   //-------- Unload FastReport -------------------------------------------------------------
   FrPrn:DestroyFR()

   RETURN
////////////////////////////////////////////////////////////////
FUNCTION MyQuestButton( cLang, nAct )
   LOCAL nI, aTmp, oCombo, nSpace := 28, aRet := { }, cLangAct
   LOCAL cButtonClr := "15/3,0/12,4/15,12/3", cButtCol := "0/15"
   LOCAL nVar := 1, aGroup := { } , getlist := { }
   LOCAL aFunct := { }, alButton[ 12 ], nExitState := GE_ESCAPE

   IF nAct > 0
      nVar := nAct
   ENDIF

   AFill( alButton, .F. )

   @  8, 35, 14, 74 BOX "ÚÄ¿³ÙÄÀ³ " COLOR( "0/15" )
   @  8, 35 + 1 SAY _cLast   COLOR( "0/15" )
   @  9, 35 + 2 SAY _cName  COLOR( "3/15" )
   @ 11, 35 + 2 SAY _cDescr COLOR( "3/15" )

   @ 15, 35, 19, 74 BOX "ÚÄ¿³ÙÄÀ³ " COLOR( "0/15" )
   @ 15, 35 + 1 SAY _cCState COLOR( "0/15" )

   oCombo := { }
   aTmp := Directory( M->ResDir + "*.xml" )
   FOR nI := 1 TO Len( aTmp )
      AAdd( oCombo , SubStr( aTmp[ nI, 1 ], 1, Len( aTmp[ nI, 1 ] ) - 4 ) )
   NEXT
   IF Len( cLang ) == 0
      cLangAct := oCombo[ 1 ]
   ELSE
      cLangAct := cLang
   ENDIF

   SetColor( "1/15,0/15,1/15,4/15,5/15,3/1,10/1,1/2" )

   FOR nI := 2 TO 10
      @ nI * 2  , 4 + nSpace SAY "Ü" COLOR( cButtCol )
      @ nI * 2 + 1, 3 SAY PadR( "ß", nSpace + 2, "ß" ) COLOR( cButtCol )
   NEXT

   // shadow button ManualBuild Report
   @ 20, 36 + 21 SAY "Ü" COLOR( cButtCol )
   @ 21, 36 SAY PadR( "ß", 22, "ß" ) COLOR( cButtCol )
   // shadow button Quit
   @ 22, 63 + 10 SAY "Ü" COLOR( cButtCol )
   @ 23, 64 SAY PadR( "ß", 8 + 2, "ß" ) COLOR( cButtCol )

   @ 22, 2 SAY _cCopyright COLOR( "0/15" )
   @ 23, 2 SAY _cSale      COLOR( "0/15" )

   AAdd( aGroup, RADIOBUTTON( 1, 02, '&' + _cShow  , '1' ) )
   AAdd( aGroup, RADIOBUTTON( 1, 19, '&' + _cDesign, '2' ) )
   AAdd( aGroup, RADIOBUTTON( 1, 38, '&' + _cPrint , '3' ) )
   AAdd( aGroup, RADIOBUTTON( 1, 56, '&' + _cExport, '4' ) )

   @ 0, 1, 2, 74 GET nVar RADIOGROUP aGroup ;
      CAPTION  " " + _cAct + " " ;
      COLOR ( "0/15,0/15,14/15" )

   @ 3, 35, 5, 74 BOX "ÚÄ¿³ÙÄÀ³ " COLOR( "0/15" )
   @ 3, 36 SAY " " + _cSelLang COLOR( "5/15" )
   @ 4, 40, 22, 74 GET cLangAct LISTBOX oCombo DROPDOWN CAPTION " "
   @ 6, 36 SAY MemoLine( _cOthLang, 34, 1 ) COLOR( "5/15" )
   @ 7, 36 SAY MemoLine( _cOthLang, 34, 2 ) COLOR( "5/15" )

   @ 4, 2 GET alButton[ 1 ]  PUSHBUTTON ;
      CAPTION PadC( _cSmlList, nSpace )        ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON1, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoSimpleList()" )

   @ 6, 2 GET alButton[ 2 ] PUSHBUTTON  ;
      CAPTION PadC( _cSLgroup, nSpace )        ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON2, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoSimpleGroup()" )

   @ 8, 2 GET alButton[ 3 ] PUSHBUTTON  ;
      CAPTION PadC( _cMCompl, nSpace )         ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON3, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoMoreComplex()" )

   @ 10, 2 GET alButton[ 4 ] PUSHBUTTON ;
      CAPTION PadC( _cUDS, nSpace )            ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON4, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoUserDS()" )

   @ 12, 2 GET alButton[ 5 ] PUSHBUTTON ;
      CAPTION PadC( _cWA_DS, nSpace )          ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON5, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoWAUserDS()" )

   @ 14, 2 GET alButton[ 6 ] PUSHBUTTON ;
      CAPTION PadC( _cAdo, nSpace )            ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON6, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoADO()" )

   @ 16, 2 GET alButton[ 7 ] PUSHBUTTON ;
      CAPTION PadC( _cCalls, nSpace )          ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON7, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoSomeCalls()" )

   @ 18, 2 GET alButton[ 8 ] PUSHBUTTON ;
      CAPTION PadC( _cMCompl, nSpace )          ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON8, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoInFR_MoreComplex()" )

   @ 20, 2 GET alButton[ 9 ] PUSHBUTTON ;
      CAPTION PadC( _cMemPict, nSpace )         ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON9, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoMemPict()" )

   @ 20, 35 GET alButton[ 10 ] PUSHBUTTON ;
      CAPTION PadC( _cManualReport, 20 )         ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON10, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "DoManualReport()" )

   @ 22, 63 GET alButton[ 11 ] PUSHBUTTON ;
      CAPTION PadC( _cQuit, 8 )                   ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON11, .t. } ;
      COLOR cButtonClr
   AAdd( aFunct, "QUIT()" )

   @ 23, 10 GET alButton[ 12 ] PUSHBUTTON ;
      CAPTION _cSaleSite                      ;
      STATE { || GetActive():exitState := GE_WRITE } ;
      WHEN  { || nExitState := GE_BUTTON12, .t. } ;
      COLOR "9/15,0/12,4/15,12/3"
   AAdd( aFunct, "DLLCALL()" )

   READ

   IF ( LastKey() == K_ESC ) .OR. nExitState == 31
      aRet := { }
   ELSE
      AAdd( aRet, nVar  )                       // aGroup[nVar,5]
      AAdd( aRet, nExitState - 20  )            // BUTTON
      AAdd( aRet, aFunct[ nExitState - 20 ]  )  // RUN FUNCTION
      AAdd( aRet, cLangAct  )                      // Lang

      IF cLangAct # cLang
         FrPrn:LoadLangRes( M->ResDir + cLangAct + ".xml" )
      ENDIF

   ENDIF

   CLEAR GETS

   RETURN aRet
////////////////////////////////////////////////////////////////
PROCEDURE DoFrAction( cFileName, lPrepared, nFastAction )
   LOCAL cDescription, cNameRep
   PRIVATE cExpObj, cExpFile, lExpOpt, lExpOpen, cExtention, lNotOpened := .f.

   lPrepared := IIf( lPrepared <> NIL, lPrepared, .f. )
   IF ! lPrepared .and. ( cFileName <> NIL )
      FrPrn:LoadFromFile( M->RepDir + cFileName )
   ENDIF

   cNameRep := FrPrn:ReportOptions:SetName()
   cDescription := FrPrn:ReportOptions:SetDescription()
   @ 10, 37 SAY PadR( cNameRep, 37 )  COLOR( "0/15" )
   @ 12, 37 SAY PadR( MemoLine( cDescription, 37, 1 ), 37 ) COLOR( "0/15" )
   @ 13, 37 SAY PadR( MemoLine( cDescription, 37, 2 ), 37 ) COLOR( "0/15" )

   nFastAction := IIf( nFastAction <> NIL, nFastAction, 0 )
   DO CASE
   CASE nFastAction == 0
      Alert( "Not param nFastAction ! nFastAction:=0 ....." )
   CASE nFastAction == 1
      FrPrn:ShowReport()
   CASE nFastAction == 2
      FrPrn:DesignReport()
   CASE nFastAction == 3
      FrPrn:SetProperty( "Report", "ShowProgress", .f. )
      IF ! lPrepared
         FrPrn:PrepareReport()
      ENDIF
      FrPrn:Print( .t. )
      FrPrn:SetProperty( "Report", "ShowProgress", .t. )
   CASE nFastAction == 4
      IF MyGetExportObject()
         FrPrn:SetProperty( "Report", "ShowProgress", .f. )
         IF ! lPrepared
            FrPrn:PrepareReport()
         ENDIF
         FrPrn:SetProperty( cExpObj, "ShowDialog", lExpOpt )
         IF ( cExpObj = "MailExport" ) .and. ! lExpOpt
            FrPrn:SetProperty( cExpObj, "ShowDialog", .t. )
         ENDIF
         IF AScan( { "XLSExport", "XMLExport" },  cExpObj ) > 0
            FrPrn:SetProperty( cExpObj, "OpenExcelAfterExport", lExpOpen )
         ELSE
            IF AScan( { "BMPExport", "TIFFExport", "JPEGExport", "GIFExport", ;
                        "DotMatrixExport", "TXTExport" },  cExpObj ) > 0
               lNotOpened := .t.
            ELSE
               FrPrn:SetProperty( cExpObj, "OpenAfterExport", lExpOpen )
            ENDIF
         ENDIF
         IF lExpOpen.and. ! lNotOpened
            IF cExpObj <> "SimpleTextExport"
               cExtention := "." + Left( cExpObj, 3 )
            ELSE
               cExtention := ".TXT"
            ENDIF
            IF Right( cExpFile, 4 ) <> cExtention
               cExpFile := cExpFile + cExtention
            ENDIF
         ENDIF
         FrPrn:SetProperty( cExpObj, "FileName", cExpFile )
         FrPrn:DoExport( cExpObj )
         IF lExpOpen.and.lNotOpened
            MsgBox( _cNoOpen )
         ENDIF
         FrPrn:SetProperty( "Report", "ShowProgress", .t. )
      ENDIF
   ENDCASE

   RETURN
////////////////////////////////////////////////////////////////
FUNCTION DoSimpleList( nFastAction )
   FrPrn:SetWorkArea( "Customers", 1 )
   FrPrn:SetFieldAliases( "Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact" )
   lShowCustName := .t.
*   DoFrAction( "1.fr3",, nFastAction )
   DoFrAction( "21.fr3",, 2 )
   FrPrn:ClearDataSets()
   lShowCustName := .f.
   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION DoSimpleGroup( nFastAction )
   FrPrn:SetWorkArea( "Customers", 1 )
   FrPrn:SetFieldAliases( "Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact" )
   lShowCustName := .t.
   DoFrAction( "2gr.fr3",, nFastAction )
   FrPrn:ClearDataSets()
   lShowCustName := .f.
   RETURN
////////////////////////////////////////////////////////////////
PROCEDURE DoMoreComplex( nFastAction )
   Select Items
   Set ORDER TO 2
   lShowCustName := .t.
   FrPrn:SetWorkArea( "Customers", 1 )
   FrPrn:SetFieldAliases( "Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone;Fax;Contact" )
   FrPrn:SetWorkArea( "Orders", 2 )
   FrPrn:SetWorkArea( "Items", 3 )
   FrPrn:SetWorkArea( "Parts", 4 )
   FrPrn:SetMasterDetail( "Customers", "Orders", { || Customer->CustNo } )
   FrPrn:SetMasterDetail( "Orders", "Items", { || Orders->OrderNo } )
   DBSetRelation( 4,  { || PartNo } )
   FrPrn:SetResyncPair( "Items", "Parts" )
   DoFrAction( "4.fr3",, nFastAction )
   FrPrn:ClearDataSets()
   Select Items
   DBClearRelation()
   lShowCustName := .f.
   RETURN
////////////////////////////////////////////////////////////////
PROCEDURE DoInFR_MoreComplex( nFastAction )
   DoFrAction( "md.fr3",, nFastAction )
   RETURN
////////////////////////////////////////////////////////////////
PROCEDURE MyManualReport( )
   FrPrn:SetDefaultFontProperty( "Name", "Times New Roman" )
   FrPrn:SetDefaultFontProperty( "Size", 16 )

   tmp_Name := FrPrn:MemoAt( "Some memo with bottom frame ...", 30, 30, 300, 50 )
   FrPrn:SetManualObjProperty( tmp_Name + ".Frame", "Typ", "[ftBottom]" )

   FrPrn:LineAt( 30, 200, 100, 100 )
   FrPrn:MemoAt( "<-- It's a some line ...", 200, 250, 350, 50 )

   FrPrn:PictureAt( M->DataDir + "logo.bmp" , 30, 400, 300, 300 )
   FrPrn:MemoAt( "<-- It's a some picture ...", 350, 420, 320, 50 )

   FrPrn:NewPage()

   FrPrn:MemoAt( "It's a second page..................", 30, 30, 100, 1000 )
   RETURN
////////////////////////////////////////////////////////////////
FUNCTION DoManualReport( nFastAction )
   FrPrn:StartManualBuild( { || MyManualReport() }, FR_LANDSCAPE, , FR_PIXELS )
   DoFrAction(,, nFastAction )
   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION DoMemPict( nFastAction )

   USE ( "Biolife.dbf" ) VIA "DBFCDX" NEW
   GO TOP

   FrPrn:SetWorkArea( "Biolife", 5 )
   DoFrAction( "9new.fr3",, nFastAction )

   CLOSE BioLife

   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION DoUserDS( nFastAction )
   PRIVATE ADir, I := 1, DirName := "C:\*.*"
   ADir := Directory( DirName )
   FrPrn:SetUserDataSet( "Dir", "F_NAME;F_SIZE;F_CREATION_DATE", ;
                         { || I := 1 }, { || I := I + 1 }, ;
                         { || I := I - 1 }, { || I > Len( ADir ) }, ;
                         { | aField | xx := IF( aField = "F_NAME", 1, IF( aField = "F_SIZE", 2, 3 ) ) , ADir[ I, xx ] } )

 *  DoFrAction( "6.fr3",, nFastAction )
   DoFrAction( "20.fr3",, 2 )
   FrPrn:ClearDataSets()
   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION GetDSValue( cField )
   LOCAL RES
   DO CASE
   CASE cField == "PartNo"
      RETURN Parts->PartNo
   CASE cField == "Part"
      RETURN Parts->Descriptio
   CASE cField == "Total qty"
      Select Items
      OrdScope( 0, Parts->PartNo )
      OrdScope( 1, Parts->PartNo )
      SUM QTY TO RES
      RETURN RES
   CASE cField == "Price"
      RETURN Parts->ListPrice
   ENDCASE
   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION DoWAUserDS( nFastAction )
   Select Items
   Set ORDER TO 3
   FrPrn:SetUserDataSet( "Parts in oders", "PartNo;Part;Total qty;Price", ;
                         { || Parts->( DBGoTop() ) } , ;
                         { || Parts->( DBSkip( 1 ) ) }, ;
                         { || Parts->( DBSkip( - 1 ) ) }, ;
                         { || Parts->( Eof() ) }, ;
                         { | cField | GetDSValue( cField ) } )

   DoFrAction( "9.fr3",, nFastAction )
   Select Items
   OrdScope( 0, nil )
   OrdScope( 1, nil )
   FrPrn:ClearDataSets()
   RETURN NIL
////////////////////////////////////////////////////////////////
PROCEDURE DoADO( nFastAction )
   FrPrn:LoadFromFile( M->RepDir + "24.fr3" )
   FrPrn:SetADOConnectPartStr( "ADODatabase1", "Data Source", M->DataDir + "demo.mdb" )
   DoFrAction(,, nFastAction )
   RETURN
////////////////////////////////////////////////////////////////
PROCEDURE DoSomeCalls( nFastAction )
   FrPrn:LoadFromFile( M->RepDir + "7.fr3" )
   FrPrn:AddVariable( "My Lovely Vars", "My and only my var", 10 )
   FrPrn:AddVariable( "My Lovely Vars", "test", 100.25 )
   FrPrn:AddVariable( "My Lovely Vars", "test1", "'Test'" )
   FrPrn:AddVariable( "My Lovely Vars", "test2", CToD( "01/01/2007" ) )
   DoFrAction(,, nFastAction )
   RETURN
////////////////////////////////////////////////////////////////
FUNCTION MyGetExportObject()
   LOCAL cColor1 := "15/1" , cColor2 := "11/1", cColorAll := "14/1,15/1,12/1,3/14,14/1,3/1,10/1,1/2"
   LOCAL cColor3 := "0/15,1/14", cButtonClr := "15/3,0/12,4/15,12/3", cButtCol := "0/1"
   LOCAL oDlg, lExit, lExport, cPath, nVar := 1, cText
   LOCAL lQuit := .F. , lExp := .F. , lVal1 := .F. , lVal2 := .F.
   LOCAL aGroup := { }, getlist := { }, nExitState := GE_ESCAPE
   LOCAL aExpList := { "PDFExport", "HTMLExport", "RTFExport", "CSVExport", ;
         "XLSExport", "DotMatrixExport", "BMPExport", "JPEGExport", ;
         "TXTExport", "TIFFExport", "GIFExport", ;
         "SimpleTextExport", "MailExport", "XMLExport" }

   FOR x := 1 TO Len( aExpList )
      cText := SubStr( aExpList[ x ], 1, At( "Export", aExpList[ x ] ) - 1 ) + " - Export"
      AAdd( aGroup, RADIOBUTTON( 1 + x, 16, cText, Str( x, 2 ) ) )
   NEXT

   oDlg := SaveScreen(,,,, )
   @ 1, 12, MaxRow(), MaxCol() - 8 BOX "         " COLOR( "15/0" )
   @ 0, 10, MaxRow() - 1, MaxCol() - 10 BOX "         " COLOR( cColor1 )
   @ 0, 11, MaxRow() - 1, MaxCol() - 11 BOX "ÚÄ¿³ÙÄÀ³ " COLOR( cColor1 )
   @ 0, 35 SAY " " + _cExp + " " COLOR( cColor1 )

   lExport := .F.
   lExit := .F.
   DO WHILE ! lExit

      SetColor( cColorAll )

      @ 2, 14, 15, 40 BOX "         " COLOR( "1/15" )
      @ 1, 13, 16, 41 GET nVar RADIOGROUP aGroup ;
         CAPTION  " " + _cSelExp + " " COLOR ( "14/1,11/1,13/1" )

      @ MaxRow() - 6, 13 SAY _cFileName COLOR( cColor2 )
      cPath := M->RepDir + 'export' + Space( 25 )
      @ MaxRow() - 5, 13 GET cPath PICTURE "@S52 " + Replicate( "x", 66 ) COLOR( cColor3 )

      @ MaxRow() - 3, 20 GET lVal1 CHECKBOX CAPTION _cAddDialog
      @ MaxRow() - 2, 20 GET lVal2 CHECKBOX CAPTION _cOpenD

      @ 5, 52 GET lExp PUSHBUTTON CAPTION PadC( _cExp, 8 ) ;
         STATE { || GetActive():exitState := GE_WRITE } ;
         WHEN  { || nExitState := GE_WRITE, .t. } ;
         COLOR cButtonClr
      // shadow button
      @ 5, 62 SAY "Ü" COLOR( cButtCol )
      @ 6, 53 SAY PadR( "ß", 10, "ß" ) COLOR( cButtCol )

      @ 8, 52 GET lQuit PUSHBUTTON CAPTION PadC( _cQuit, 8 ) ;
         STATE { || GetActive():exitState := GE_ESCAPE } ;
         WHEN  { || nExitState := GE_ESCAPE, .t. } ;
         COLOR cButtonClr
      // shadow button
      @ 8, 62 SAY "Ü" COLOR( cButtCol )
      @ 9, 53 SAY PadR( "ß", 10, "ß" ) COLOR( cButtCol )

      READ

      IF ( LastKey() == K_ESC ) .OR. nExitState == GE_ESCAPE
         lExit   := .T.
      ELSE
         lExit   := .T.
         lExport := .T.
      ENDIF

   ENDDO
   CLEAR GETS

   IF lExport
      cExpObj  := aExpList[ nVar ]
      cExpFile := AllTrim( cPath )
      lExpOpt  := lVal1
      lExpOpen := lVal2
   ENDIF

   RestScreen(,,,, oDlg )

   RETURN lExport
////////////////////////////////////////////////////////////////
PROCEDURE ShowProgress( x, y, z )
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
      Res := Res + " - " + Str( y )
   ENDCASE

   @ 16, 37 SAY PadC( Res, 37 ) COLOR( "4/15" )

   RETURN
////////////////////////////////////////////////////////////////
PROCEDURE ShowProcess( sObjectName )
   LOCAL cRes

   IF lShowCustName
      cRes := "Proccessing - " + Trim( ( 1 ) ->Company ) + " " + sObjectName
   ELSE
      cRes := "Proccessing - " + " " + sObjectName
   ENDIF
   @ 17, 37 SAY PadC( MemoLine( cRes, 37, 2 ), 37 ) COLOR( "1/15" )
   @ 18, 37 SAY PadC( MemoLine( cRes, 37, 3 ), 37 ) COLOR( "1/15" )

   RETURN
////////////////////////////////////////////////////////////////
FUNCTION CallUserFunction( FName, FParams )
   LOCAL RES
   IF ( FName == "XBASESTR" )
      RES := Str( FParams[ 1 ], FParams[ 2 ], FParams[ 3 ] )
   ENDIF
   RETURN RES
////////////////////////////////////////////////////////////////
/*
 * Create Index Files
 */
FUNCTION  MyCreateIndex()

   IF ! AllFilesExist( { "CUSTA.NTX", "CUSTB.NTX" } )
      USE Customer EXCLUSIVE
      INDEX ON CustNo  TO CustA
      INDEX ON Company TO CustB
      CLOSE DATABASE
   ENDIF

   IF ! AllFilesExist( { "ORDERSA.NTX", "ORDERSB.NTX" } )
      USE Orders EXCLUSIVE
      INDEX ON OrderNo   TO ORDERSA
      INDEX ON CustNo    TO ORDERSB
      CLOSE DATABASE
   ENDIF

   IF ! AllFilesExist( { "itemsa.NTX", "itemsb.NTX", "itemsc.NTX" } )
      USE Items EXCLUSIVE
      INDEX ON Str( OrderNo, 15 ) + Str( ItemNo, 15 )  TO itemsa
      INDEX ON OrderNo                           TO itemsb
      INDEX ON PartNo                            TO itemsc
      CLOSE DATABASE
   ENDIF

   IF ! AllFilesExist( { "parts.NTX", } )
      USE Parts EXCLUSIVE
      INDEX ON PartNo TO parts
      CLOSE DATABASE
   ENDIF

   RETURN NIL
////////////////////////////////////////////////////////////////
/*
 * Check if all files of the array 'aFiles' exist
 */
FUNCTION AllFilesExist( aFiles )
   LOCAL lExist := .T., i := 0, imax := Len( aFiles )

   DO WHILE ++ i <= imax .AND. lExist
      lExist := File( aFiles[ i ] )
   ENDDO
   RETURN lExist
////////////////////////////////////////////////////////////////
/*
 * Open DBF-files and INDEX-files
 */
FUNCTION MyOpenDbfIndex()

   USE Customer NEW
   Set INDEX TO CustA, CustB
   Set ORDER TO 2
   GO TOP

   USE Orders NEW
   Set INDEX TO ORDERSA, ORDERSB
   Set ORDER TO 2
   GO TOP

   USE Items NEW
   Set INDEX TO itemsa, itemsb, itemsc
   Set ORDER TO 2
   GO TOP

   USE Parts NEW
   Set INDEX TO Parts
   Set ORDER TO 1
   GO TOP

   RETURN NIL
////////////////////////////////////////////////////////////////
FUNCTION MSGBOX( cMess )
   Alert( cMess )
   RETURN NIL
