/*
 * Proyect: FastReport for [x]Harbour
 * Description: Sample
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#include "error.ch"
#include "HbClass.ch"

#ifdef __XHARBOUR__
   REQUEST HB_GT_WIN
#endif

STATIC lDesign := .f.
REQUEST DBFCDX

CLASS TFastReport FROM XFastReport
  VAR cFRLicense INIT ""
  VAR cXALicense INIT ""
END CLASS


FUNCTION Main()

   SetMode( 25, 80 )
   ErrorBlock( {| oError | MyError( oError ) } )

   SET MESSAGE TO MaxRow() CENTER
   SET WRAP ON

   Menu()

RETURN NIL

//------------------------------------------------------------------------------

FUNCTION Menu()

   LOCAL nChoice, nOld

   nChoice := 1

   DO WHILE .T.

      CLS

      nOld := nChoice

      @ 0, 0 SAY PadC( "*** FastReport for [x]harbour ***", 80 ) color "N/W"

      @ 2, 2 PROMPT "1. Biolife"        MESSAGE "Dbf source with images"
      @ 3, 2 PROMPT "2. Array"          MESSAGE "Array source"
      @ 4, 2 PROMPT "3. Dbf Relations"  MESSAGE "Dbf source with relations (SET RELATION)"
      @ 5, 2 PROMPT "4. FR Relations"   MESSAGE "Dbf source with FastReport relations"
      @ 6, 2 PROMPT "5. ADO"            MESSAGE "ADO source"
      @ 7, 2 PROMPT "6. Sergey mode"    MESSAGE "Sergey compatibility using SetWorkArea() method"
      @ 9, 2 PROMPT "7. Change mode:"   MESSAGE "Changes between 'Design' and 'Preview' mode"

      @ 9, 18 SAY iif( lDesign, "Design mode", "Preview mode" ) COLOR "N/W"

      @ 12, 0 SAY "This small sample just tries to show how to use different data sources when "
      @ 13, 0 SAY "not using Xailer, but standard [x]Harbour code."
      @ 15, 0 SAY "In order to see more sophisticated reports run FRdemo.exe written in Xailer."
      @ 17, 0 SAY "(Those reports can also be easily accomplished with standard [x]Harbour code.)"

      MENU TO nChoice

      SWITCH nChoice
      CASE 0
         QUIT
      CASE 1
         BioLife()
         EXIT
      CASE 2
         ArrayPrint()
         EXIT
      CASE 3
         RelatDBFPrint()
         EXIT
      CASE 4
         RelatFRPrint()
         EXIT
      CASE 5
         AdoPrint()
         EXIT
      CASE 6
         Sergey()
         EXIT
      CASE 7
         lDesign := !lDesign
         nChoice := nOld
         EXIT
      END SWITCH

   ENDDO

RETURN NIL

//------------------------------------------------------------------------------

FUNCTION BioLife()

   LOCAL oReport

   CLS

   @ 0, 0 SAY PadC( "*** Biolife sample ***", 80 ) color "N/W"

   SetPos( 1, 0 )
   ? "Opening DBF ..."

   USE .\DATA\BIOLIFE SHARED VIA "DBFCDX"

   WITH OBJECT oReport := TFastReport():New()
      WITH OBJECT :AddDbf( "BIOLIFE" )
         :lLoadOnDemand := .t.
         :nMaxRecsOnDesign := 10
      END WITH
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  := {|| QOut( "Report preview window closed" ) }
      :Create()

      :cFilename := ".\Reports\Biolife.fr3"
      //:LoadFromFile( ".\Reports\Biolife.fr3" )
      //:LoadFromString( MemoRead(  ".\Reports\Biolife.fr3" ) )

      ? "Report description:"
      ? :oReportOptions:aDescription[ 1 ]

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   CLOSE ALL

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN NIL

//------------------------------------------------------------------------------

FUNCTION ArrayPrint()

   LOCAL oReport, cStruct

   cStruct := { "Name,C,100,0", "Length,N,15,0", "Date,D,8,0", "Time,C,10,0", "Type,C,1,0" }

   CLS

   @ 0, 0 SAY PadC( "*** Array sample ***", 80 ) color "N/W"

   SetPos( 1, 0 )
   ? "Calling Directory() function ..."

   WITH OBJECT oReport := TFastReport():New()
      :AddArray( "Dir", Directory( "*.*" ), cStruct )
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  :=  {|| QOut( "Report preview window closed" ) }
      :Create()

      :cFilename := ".\Reports\Array.fr3"

      ? :oReportOptions:aDescription[ 1 ]

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN NIL

//------------------------------------------------------------------------------

FUNCTION AdoPrint()

   LOCAL oReport
   LOCAL cConn

   cConn := [Provider=Microsoft.Jet.OLEDB.4.0;Password="";User ID=Admin;Data Source=.\Data\demo.mdb;Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False]

   CLS

   @ 0, 0 SAY PadC( "*** ADO sample ***", 80 ) color "N/W"

   SetPos( 1, 0 )

   WITH OBJECT oReport := TFastReport():New()
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  :=  {|| QOut( "Report preview window closed" ) }
      :Create()
      :cFilename := ".\Reports\Ado.fr3"

      ? :SetADOConnectStr("ADODatabase1", cConn )
      ? :oReportOptions:aDescription[ 1 ]

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN NIL


//------------------------------------------------------------------------------

FUNCTION RelatDBFPrint()

   LOCAL oReport
   FIELD CUSTNO

   CLS

   @ 0, 0 SAY PadC( "*** FastReport relation sample with SET RELATION ***", 80 ) color "N/W"

   SetPos( 1, 0 )
   ? "Opening DBFs ..."

   USE .\DATA\CUSTOMER SHARED VIA "DBFCDX" NEW
   SET ORDER TO TAG "CUSTNO"

   USE .\DATA\ORDERS SHARED VIA "DBFCDX" NEW
   SET RELATION TO CustNo INTO CUSTOMER

   WITH OBJECT oReport := TFastReport():New()
      :AddDbf( "ORDERS", { "Orders->*", "Customer->*" } )
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  :=  {|| QOut( "Report preview window closed" ) }
      :Create()
      :cFilename := ".\Reports\Relations2.fr3"
      ? :oReportOptions:aDescription[ 1 ]

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   CLOSE ALL

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN nil

//------------------------------------------------------------------------------

FUNCTION RelatFRPrint()

   LOCAL oReport, oCustomer, oOrders

   CLS

   @ 0, 0 SAY PadC( "*** FastReport internal relation sample ***", 80 ) color "N/W"

   SetPos( 1, 0 )
   ? "Opening DBFs ..."

   USE .\DATA\CUSTOMER SHARED VIA "DBFCDX" NEW
   USE .\DATA\ORDERS SHARED VIA "DBFCDX" NEW

   WITH OBJECT oReport := TFastReport():New()
      oCustomer := :AddDbf( "CUSTOMER", { "Customer->*" } )
      oOrders   := :AddDbf( "ORDERS", { "Orders->*" } )
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  :=  {|| QOut( "Report preview window closed" ) }
      oOrders:SetMaster( oCustomer, {"CUSTNO=CUSTNO"} )
      :Create()
      :cFilename := ".\Reports\Relations.fr3"
      ? :oReportOptions:aDescription[ 1 ]

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   CLOSE ALL

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN NIL

//------------------------------------------------------------------------------

FUNCTION Sergey()

   LOCAL oReport, oCustomer, oOrders

   CLS

   @ 0, 0 SAY PadC( "*** FastReport Sergey compatibility mode sample ***", 80 ) color "N/W"

   SetPos( 1, 0 )
   ? "Opening DBFs ..."

   USE .\DATA\CUSTOMER SHARED VIA "DBFCDX" NEW

   WITH OBJECT oReport := frReportManager():New()
      :SetWorkArea( "Customer" )
      :SetFieldAliases( "Customer", "Addr1=Address1;Addr2=Address2" )
//      :SetUserDataset( "Customer", "Custno;Company",;
//                       {|| Customer->(DBGoTop()) }, {|| Customer->(DbSkip()) }, ;
//                       NIL, {|| !Customer->(Eof()) },;
//                       {|f| Customer->(FieldGet( FieldPos( f ) ) ) } )
      :bOnAfterLoad   := {|| QOut( "Report loaded" ) }
      :bOnClickObject := {|oSender, cObject| QOut( "Mouse click on object: " + cObject ) }
      :bOnEndPreview  :=  {|| QOut( "Report preview window closed" ) }
      :bOnBtnSendMail := {|| Alert( "Email" ), 1 }
      :bOnBtnPrint    := {|| Alert( "Print" ), 1 }
      :bOnBtnGenPdf   := {|| Alert( "Gen PDF" ), 1 }
      :Create()
      :cFilename := ".\Reports\Sergey.fr3"
      :AddVariable( "Categoria", "Nombre", 123 )

      IF !lDesign
         :ShowReport()
      ELSE
         :DesignReport()
      ENDIF
      :End()
   END WITH

   CLOSE ALL

   ? ""
   ? "Push any key to continue."

   Inkey( 0 )

RETURN NIL

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

STATIC FUNCTION MyError( oError )

   LOCAL cMessage
   LOCAL cDOSError

   LOCAL aOptions
   LOCAL nChoice

   LOCAL n

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV .AND. ;
      oError:canSubstitute
      RETURN 0
   ENDIF

   // By default, retry on RDD lock error failure */
   IF oError:genCode == EG_LOCK .AND. ;
      oError:canRetry
      // oError:tries++
      RETURN .T.
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := ErrorMessage( oError )
   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + hb_ntos( oError:osCode ) + ")"
   ENDIF

   // Build buttons

   aOptions := {}

   AAdd( aOptions, "Quit" )

   IF oError:canRetry
      AAdd( aOptions, "Retry" )
   ENDIF

   IF oError:canDefault
      AAdd( aOptions, "Default" )
   ENDIF

   // Show alert box

   nChoice := 0
   DO WHILE nChoice == 0

      IF cDOSError == NIL
         nChoice := Alert( cMessage, aOptions )
      ELSE
         nChoice := Alert( cMessage + ";" + cDOSError, aOptions )
      ENDIF

   ENDDO

   IF ! Empty( nChoice )
      IF aOptions[ nChoice ] == "Break"
         Break( oError )
      ELSEIF aOptions[ nChoice ] == "Retry"
         RETURN .T.
      ELSEIF aOptions[ nChoice ] ==  "Default"
         RETURN .F.
      ENDIF
   ENDIF

   // "Quit" selected

   IF cDOSError != NIL
      cMessage += " " + cDOSError
   ENDIF

   OutErr( Chr( 13 ) + Chr( 10 ) )
   OutErr( cMessage )

   n := 1
   DO WHILE ! Empty( ProcName( ++n ) )

      OutErr( Chr( 13 ) + Chr( 10 ) )
      OutErr( "Called from " + ProcName( n ) + ;
         "(" + hb_ntos( ProcLine( n ) ) + ")  " )

   ENDDO

   ErrorLevel( 1 )
   Inkey( 0 )
   QUIT

RETURN .F.

//------------------------------------------------------------------------------

STATIC FUNCTION ErrorMessage( oError )

   // start error message
   LOCAL cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   // add subsystem name if available
   IF HB_ISSTRING( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF HB_ISNUMERIC( oError:subCode )
      cMessage += "/" + hb_ntos( oError:subCode )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF HB_ISSTRING( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE ! Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE ! Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

RETURN cMessage
