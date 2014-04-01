/*
 * Proyect: FastReport for [x]Harbour
 * Description: FastReport main class
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#include "error.ch"
#include "frh.ch"

#define CRLF   Chr( 13 ) + Chr( 10 )

/*
Errores:
100-199: Errores de carga de DLL
200-299: Errores de contexto incorrecto
300-399: Errores de uso incorrecto
*/

STATIC aReports  := {}
STATIC nLibLoads := 0

//------------------------------------------------------------------------------

FUNCTION FR_EventHandler( nInstance, nEvent, nCargo )

   LOCAL xRet

   IF nInstance > 0 .AND. nInstance <= Len( aReports ) .AND. aReports[ nInstance ] != NIL
      xRet := aReports[ nInstance ]:ProcessEvent( nEvent, nCargo )
   ENDIF

RETURN xRet

//------------------------------------------------------------------------------

FUNCTION FR_FreeLib()

   IF nLibLoads <= 0
      FR_FreeLibrary()
      RETURN .T.
   ENDIF

RETURN .F.

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFastReport FROM TFrObject

EXPORTED:
   VAR oEngineOptions
   VAR oPrintOptions
   VAR oPreviewOptions
   VAR oReportOptions

   VAR lAbortOnErrors INIT .T.
   VAR cResName       INIT ""
   VAR cResIco        INIT ""
   VAR cFRLicense     INIT ""
   VAR cXALicense     INIT ""
   VAR cTitle         INIT ""
   VAR cDllPath       INIT ""

   VAR aDatasets  INIT {}
   VAR nLastError INIT 0  READONLY
   VAR cLastError INIT "" READONLY

   VAR bOnBeforeCreate        // ( oSender ) // --> Nil
   VAR bOnEndPreview          // ( oSender ) // --> Nil
   VAR bOnAfterPrint          // ( oSender, cObject ) // --> Nil
   VAR bOnAfterPrintReport    // ( oSender ) // --> Nil
   VAR bOnBeforeConnect       // ( oSender, cObject ) // --> Nil
   VAR bOnBeforePrint         // ( oSender, cObject ) // --> Nil
   VAR bOnBeginDoc            // ( oSender ) // --> Nil
   VAR bOnClickObject         // ( oSender, cObjectm, nButton ) // --> Nil
   VAR bOnEndDoc              // ( oSender ) // --> Nil
   VAR bOnGetValue            // ( oSender, cVarName ) // --> Value
   VAR bOnMouseOverObject     // ( oSender, cObject ) // --> Nil
   VAR bOnPreview             // ( oSender ) // --> Nil
   VAR bOnPrintPage           // ( oSender, nCopyPage ) // --> Nil
   VAR bOnPrintReport         // ( oSender ) // --> Nil
   VAR bOnProgress            // ( oSender, nProgressType, nProgress ) // --> Nil
   VAR bOnProgressStart       // ( oSender, nProgressType, nProgress ) // --> Nil
   VAR bOnProgressStop        // ( oSender, nProgressType, nProgress ) // --> Nil
   VAR bOnBeforeLoad          // ( oSender ) // --> NIL
   VAR bOnAfterLoad           // ( oSender ) // --> NIL
   VAR bOnCreate              // ( oSender ) // --> NIL or xValue
   VAR bOnBtnSendMail         // ( oSender ) // --> NIL or xValue
   VAR bOnBtnPrint            // ( oSender ) // --> NIL or xValue
   VAR bOnBtnGenPdf           // ( oSender ) // --> NIL or xValue
   VAR bOnPageChanged         // ( oSender, nPage ) // --> NIL

   METHOD cFileName( cValue ) SETGET
   METHOD cLanguage( cValue ) SETGET

   METHOD New() // --> Self
   METHOD Create() // --> Self
   METHOD SetLicense( cFRLicense, cXALicense )// --> lSuccess
   METHOD DelError()  INLINE ( ::nLastError := 0, ::cLastError := "" ) // --> NIL
   METHOD GetErrors() // --> aErrors

   METHOD ShowReport( lKeepLastReport ) // -> lSuccess
   METHOD PrepareReport( lKeepLastReport ) // -> lSuccess
   METHOD DesignReport() // -> lSuccess

   METHOD LoadFromFile( cFile ) // -> cFile
   METHOD LoadFromResource(  cResource ) // -> cResource
   METHOD LoadFPFile( cFile ) INLINE ::LoadFromFile( cFile )  // -> cFile
   METHOD LoadFromString( cString ) // -> cFile

   METHOD SaveToFile( cFileName ) // -> lSuccess
   METHOD SaveToString( cString ) // -> lSuccess
   METHOD Clear() // -> lSuccess
   METHOD SaveToFPFile( cFileName ) // -> lSuccess
   METHOD LoadStyleSheetFromFile( cFileName ) // -> lSuccess
   METHOD LoadStyleSheetFromString( cString ) // -> lSuccess
   METHOD Print() // -> lSuccess
   METHOD SetTitle( cTitle ) // -> lSuccess
   METHOD SetIcon( cIcon ) // -> lSuccess
   METHOD DoExport( cFilter ) // -> lSuccess

   METHOD GetProperty( cObjetName, cProperty ) // -> xValue
   METHOD SetProperty( cObjName, cProperty, xValue ) // --> NIL

   METHOD AddArray( cName, aData, aFields ) // --> oDataset
   METHOD AddDbf( cName, aFields ) // --> oDataset
   METHOD DelDataset( oDataset ) // --> lSuccess

   METHOD SetMasterDetail( cMasterName, cDetailName, aFields )
   METHOD ClearMasterDetail( cMasterName, cDetailName ) // --> lSuccess

   METHOD LoadLangRes( cName ) // -> lSuccess
   METHOD LoadLangFile( cName ) // -> lSuccess

   METHOD AddFunction( cPrototype, cCategory, cDescription ) // --> lSuccess
   METHOD AddCategory( cCategory) // --> lSuccess
   METHOD AddVariable( cName, xValue ) // --> lSuccess
   METHOD SetVariable( cName, xValue ) // --> lSuccess
   METHOD GetVariable( cName ) INLINE( ::GetVariableC( cName ), ::GetCargo() ) // --> xValue
   METHOD DeleteVariable( cName ) // --> lSuccess
   METHOD DeleteCategory( cName ) // --> lSuccess
   METHOD Calc( cPascalExp ) // -->
   METHOD SetADOConnectStr( cName, cConnectstring ) // --> lSuccess

// Sergey compatibility methods
   METHOD ReportOptions()  INLINE ::oReportOptiosn
   METHOD PrintOptions()   INLINE ::oPrintOptions
   METHOD EngineOptions()  INLINE ::oEngineOptions
   METHOD PreviewOptions() INLINE ::oPreviewOptions

RESERVED:
   METHOD Free() // --> NIL
   METHOD ProcessEvent( nEvent, nCargo ) EXTERN FR_ProcessEvent

   // Used by TFrxDataset object
   METHOD AddFrDataSet( cName ) // -> nDBPos
   METHOD AddFrField( nDB, cField, nType, nLen ) // -> lSuccess
   METHOD AddFrRecord( nDB ) // -> lSuccess
   METHOD AddFrValue( nDB, cField, xValue )  // -> lSuccess
   METHOD SetDBComplete( nDB )  // -> lSuccess
   METHOD AddComplete( nDB ) INLINE Aadd( ::aDatasets, NIL ) // simulates dataset existence for manual testing
   METHOD ClearDB( nDB, lDelFields )
   METHOD SetDBName( nDB, cName )

   METHOD SetCargoB( cValue )
   METHOD frSetBounds( nLeft, nTop, nWidth, nHeight )
   METHOD Prepared() INLINE ::lPrepared

PROTECTED:
   VAR FcFileName     INIT ""
   VAR FcLanguage     INIT ""

   VAR pObject   INIT 0
   VAR cResData  INIT ""
   VAR nInstance INIT 0
   VAR lLicensed INIT .F.
   VAR lLoaded   INIT .F.
   VAR lPrepared INIT .F.

   METHOD Event( bVar, xPar1, xPar2, xPar3 ) INLINE IIF( bVar != NIL, Eval( bVar, Self, xPar1, xPar2, xPar3 ), )

   METHOD Initialize()
   METHOD UnInitialize()
   METHOD Installed() INLINE ( nLibLoads > 0 )
   METHOD BeforeLoad( lDesign )
   METHOD AfterLoad()
   METHOD LoadReport( lDesign )
   METHOD LoadFromFileC( cFileName )
   METHOD LoadFromResourceC( nResID, cResName )
   METHOD LoadFPFileC( cFileName )
   METHOD LoadFromStringC( cString )

   METHOD SetIconC( cResIco )
   METHOD LoadProperty( cObjetName, cProperty )
   METHOD ShowReportC( lKeepLastReport )
   METHOD PrepareReportC( lKeepLastReport )
   METHOD DesignReportC()
   METHOD AddVariableC( cVarName )
   METHOD SetVariableC( cVarName )
   METHOD GetVariableC( cVarName )

   METHOD GetCargo()
   METHOD SetCargo( xValue )
   METHOD PutProperty( cObject, cProperty, xValue )
   METHOD SetError( nError, cError )
   METHOD SetMasterDetailC( cMasterName, cDetailName, cMasterFields, cDetailFields )

   METHOD CalcC( cPascalExp )
   METHOD GetErrorsC()
   METHOD SetLanguage( cValue ) INLINE ::cLanguage := cValue
   METHOD DoExportC( cFilter )
   METHOD InitializeC()

END CLASS

//------------------------------------------------------------------------------

METHOD cFileName( cValue ) CLASS XFastReport

   IF Pcount() > 0
      ::LoadFromFile( cValue )
      //::FcFileName := cValue
   ENDIF

RETURN ::FcFilename

//------------------------------------------------------------------------------

METHOD cLanguage( cValue ) CLASS XFastReport

   IF Pcount() > 0
      ::FcLanguage := cValue
      IF !Empty( ::FcLanguage )
         ::LoadLangRes( ::FcLanguage )
      ENDIF
   ENDIF

RETURN ::FcLanguage

//------------------------------------------------------------------------------

METHOD New( oParent ) CLASS XFastReport

   ::Super:New( oParent )

RETURN Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS XFastReport

   ::Super:Create( oParent )

   ::Event( ::bOnBeforeCreate )
   ::Initialize()
   ::Event( ::bOnCreate )

   // Set license

   IF !Empty( ::cFRLicense ) .AND. !Empty( ::cXALicense )
      ::lLicensed := ::SetLicense( ::cFRLicense, ::cXALicense )
   ENDIF

   // Set Language

   IF !Empty( ::cLanguage )
      ::LoadLangRes( ::cLanguage )
   ENDIF

RETURN Self

//------------------------------------------------------------------------------

METHOD Initialize() CLASS XFastReport

   LOCAL cDll, cVer

   IF ::nInstance > 0
      RETURN NIL
   ENDIF

   IF !Empty( ::cDllPath )
      cDll := ::cDllPath + "\frx.dll"
      IF !File( cDll )
         ::SetError( 100, "Fast-Report DLL not found: " + cDll )
         RETURN NIL
      ENDIF
   ELSE
      cDll := "frx.dll"
   ENDIF

   cVer := FR_DllFileVersion( cDll )

   IF cVer != FR_DLLVER
      ::SetError( 100, "Incorrect DLL version (" + cVer + ") . Should be: " + FR_DLLVER )
      RETURN NIL
   ENDIF

   ::nInstance := Len( aReports ) + 1

   IF ::InitializeC()
      AAdd( aReports, Self )
      nLibLoads ++
   ELSE
      ::nInstance := 0
   ENDIF

   ::oEngineOptions  := TFrEngineOptions():Create( Self )
   ::oPrintOptions   := TFrPrintOptions():Create( Self )
   ::oPreviewOptions := TFrPreviewOptions():Create( Self )
   ::oReportOptions  := TFrReportOptions():Create( Self )

RETURN NIL

//------------------------------------------------------------------------------

METHOD Free() CLASS XFastReport

   LOCAL oDS

   nLibLoads --

   ::UnInitialize()

   // Eliminamos datasets

   FOR EACH oDS IN ::aDatasets
      IF oDS != NIL
         oDS:End()
      ENDIF
   NEXT

   ::aDatasets := {}

   IF ::nInstance != 0
      IF Len( aReports ) <= ::nInstance
         aReports[ ::nInstance ] := NIL
      ENDIF
      ::nInstance := 0
   ENDIF

   ::lLoaded   := .F.
   ::lPrepared := .F.

RETURN NIL

//------------------------------------------------------------------------------
// Before loading the report file all datasets and its relations must be loaded

METHOD BeforeLoad( lDesign ) CLASS XFastReport

   LOCAL oDataset
   LOCAL lModified

   IF lDesign == NIL
      lDesign := .T.
   ENDIF

   lModified := .F.

   // Datasets load

   FOR EACH oDataset IN ::aDatasets
      IF oDataset != NIL
         WITH OBJECT oDataset
            IF !:IsActive()
               :Build()
               lModified := .t.
            ENDIF
            IF :nLoaded == 0
               :Load( lDesign )
               lModified := .t.
            ELSEIF :nLoaded == 1 .AND. !lDesign
               :Load( lDesign )
            ENDIF
         END WITH
      ENDIF
   NEXT

   // Master-detail relations

   FOR EACH oDataset IN ::aDatasets
      IF oDataset != NIL
         WITH OBJECT oDataset
            IF :oDsMaster != NIL .AND. !Empty( :aRelationFields ) .AND. !:lMasterDetail
               ::SetMasterDetail( :oDsMaster:cName, :cName , :aRelationFields )
               :lMasterDetail := .t.
            ENDIF
         END WITH
      ENDIF
   NEXT

   ::Event( ::bOnBeforeLoad )

RETURN lModified

//------------------------------------------------------------------------------

METHOD AfterLoad() CLASS XFastReport

   LOCAL oDS, aProp, Value

   // Set title

   IF !Empty( ::cTitle )
      ::SetTitle( ::cTitle )
   ENDIF

   // Set icon

   IF !Empty( ::cResIco )
      ::SetIcon( ::cResIco )
   ENDIF

   // Set license

   IF !::lLicensed .AND. !Empty( ::cFRLicense ) .AND. !Empty( ::cXALicense )
      ::lLicensed := ::SetLicense( ::cFRLicense, ::cXALicense )
   ENDIF

   FOR EACH oDS IN ::aDatasets
      IF oDS != NIL
         oDS:AfterLoad()
      ENDIF
   NEXT

   ::oEngineOptions:AfterLoad()
   ::oPrintOptions:AfterLoad()
   ::oPreviewOptions:AfterLoad()
   ::oReportOptions:AfterLoad()

   ::Event( ::bOnAfterLoad )

RETURN nil

//------------------------------------------------------------------------------

METHOD LoadReport( lDesign ) CLASS XFastReport

   LOCAL cFile
   LOCAL lSuccess := .f.

   IF lDesign == NIL
      lDesign := .T.
   ENDIF

   IF ::lLoaded .or. !::lCreated
      RETURN .T.
   ENDIF

   ::Clear()
   ::BeforeLoad( lDesign )

   IF !Empty( ::cFilename )
      IF !( ":" $ ::cFilename )
         cFile := CurPath() + "\" + ::cFilename
      ELSE
         cFile := ::cFilename
      ENDIF
      IF File( cFile )
         IF Upper( FileExtension( cFile ) ) == "FR3"
            lSuccess := ::LoadFromFileC( cFile )
         ELSE
            lSuccess := ::LoadFPFileC( cFile )
         ENDIF
      ELSE
         ::SetError(  200, cFile + ": File not found on LoadFromFile()" )
      ENDIF
   ELSEIF !Empty( ::cResName )
      lSuccess := ::LoadFromResourceC( 0, ::cResName )
   ELSEIF !Empty( ::cResData )
      lSuccess := ::LoadFromStringC( ::cResData, .f. )
      ? "loadfromstring", lSuccess
   ENDIF

   ::lLoaded   := lSuccess
   ::lPrepared := .F.

   IF lSuccess
      ::AfterLoad()
   ENDIF

RETURN lSuccess

//------------------------------------------------------------------------------

METHOD SetError( nError, cText ) CLASS XFastReport

   LOCAL oError

   ::nLastError := nError
   ::cLastError := cText

   IF ::lAbortOnErrors
      WITH OBJECT oError := ErrorNew()
         :SubSystem   := "FASTREPORT"
         :SubCode     := nError
         :Severity    := ES_ERROR
         :Description := "TFastReport Error"
         :Operation   := ::cLastError
         Eval( ErrorBlock(), oError )
      END WITH
   ENDIF

RETURN NIL

//------------------------------------------------------------------------------

METHOD GetErrors() CLASS XFastReport

   LOCAL aErrors, cErrors

   ::LoadReport()

   cErrors := ::GetErrorsC()

   IF !Empty( cErrors )
      RETURN hb_atokens( cErrors, ";" )
   ENDIF

RETURN {}

//------------------------------------------------------------------------------

METHOD ShowReport( lKeepLastReport ) CLASS XFastReport

   IF lKeepLastReport == NIL
      lKeepLastReport := .F.
   ENDIF

   IF !::lCreated
      ::Create()
   ENDIF

   ::LoadReport( .F. )
   ::ShowReportC( lKeepLastReport )
   ::lPrepared := .T.

RETURN ::lPrepared

//------------------------------------------------------------------------------

METHOD PrepareReport( lKeepLastReport ) CLASS XFastReport

   IF lKeepLastReport == NIL
      lKeepLastReport := .F.
   ENDIF

   IF !::lCreated
      ::Create()
   ENDIF

   IF !::lPrepared
      ::LoadReport( .F. )
      ::lPrepared := ::PrepareReportC( lKeepLastReport )
   ENDIF

RETURN ::lPrepared

//------------------------------------------------------------------------------

METHOD DesignReport() CLASS XFastReport

   IF !::lCreated
      ::Create()
   ENDIF

   ::LoadReport( .T. )

RETURN ::DesignReportC()

//------------------------------------------------------------------------------

METHOD DoExport( cFilter ) CLASS XFastReport

   ::PrepareReport()

RETURN ::DoExportC( cFilter )

//------------------------------------------------------------------------------

METHOD LoadFromFile( cFilename ) CLASS XFastReport

   ::FcFilename := cFilename
   ::cResname   := ""
   ::cResData   := ""
   ::lLoaded    := .F.
   ::lPrepared  := .F.

RETURN ::LoadReport()

//------------------------------------------------------------------------------

METHOD LoadFromResource( cResource ) CLASS XFastReport

   ::cResName   := cResource
   ::FcFileName := ""
   ::cResData   := ""
   ::lLoaded    := .F.
   ::lPrepared  := .F.

RETURN ::LoadReport()

//------------------------------------------------------------------------------

METHOD LoadFromString( cString ) CLASS XFastReport

   ::cResData   := cString
   ::FcFileName := ""
   ::cResName   := ""
   ::lLoaded    := .F.
   ::lPrepared  := .F.

RETURN ::LoadReport()

//------------------------------------------------------------------------------

METHOD SetIcon( cResource ) CLASS XFastReport

//   ::LoadReport()

RETURN ::SetIconC( cResource )

//------------------------------------------------------------------------------

METHOD GetProperty( cObjName, cProperty ) CLASS XFastReport

   ::LoadReport()
   ::LoadProperty( cObjName, cProperty )

RETURN ::GetCargo()

//------------------------------------------------------------------------------

METHOD SetProperty( cObjName, cProperty, xValue ) CLASS XFastReport

   LOCAL cValue, cLine
   LOCAL nLen, nFrom

   SWITCH ValType( xValue )
   CASE "A"
      cValue := ""
      AEval( xValue, {|v| cValue += "'" + ToString( v ) + "'" + CRLF } )
      EXIT
   CASE "C"
      IF At( CRLF, xValue ) == 0
         cValue := "'" + xValue + "'"
      ELSE
         nFrom  := 1
         nLen   := Len( xValue )
         cValue := ""
         DO WHILE nFrom <= nLen
            cLine := ReadLine( xValue, @nFrom )
            cValue += "'" + cLine + "'" + CRLF
         ENDDO
      ENDIF
      EXIT
   CASE "N"
      nLen   := IIF( xValue == Int( xValue ), 0, 4 )
      cValue := LTrim( Str( xValue, 15, nLen  ) )
      EXIT
   CASE "L"
      cValue := IIF( xValue, "True", "False" )
      EXIT
   CASE "D"
      cValue := "'" + DToC( xValue ) + "'"
      EXIT
   END SWITCH

   ::LoadReport()

RETURN ::PutProperty( cObjName, cProperty, cValue )

//------------------------------------------------------------------------------

METHOD AddArray( cName, aData, aFields ) CLASS XFastReport

   LOCAL oDS

   WITH OBJECT oDS := TFrArrayDataset():New( ::oParent )
      :oReport := Self
      :cName   := cName
      :aData   := aData
      :aFields := aFields
      :Create()
   END WITH

   ::lLoaded   := .F.
   ::lPrepared := .F.

RETURN oDS

//------------------------------------------------------------------------------

METHOD AddDbf( cName, aFields ) CLASS XFastReport

   LOCAL oDS

   WITH OBJECT oDS := TFrDbfDataset():New( ::oParent )
      :oReport := Self
      :cName   := cName
      :aFields := aFields
      :Create()
   END WITH

   ::lLoaded   := .F.
   ::lPrepared := .F.

RETURN oDS

//------------------------------------------------------------------------------

METHOD DelDataset( oDataset ) CLASS XFastReport

   LOCAL nAt

   nAt := AScan( ::aDatasets, {|v| v != NIL .AND. v == oDataset } )

   IF nAt > 0
      ::aDatasets[ nAt ] := NIL
   ENDIF

   ::lLoaded   := .F.
   ::lPrepared := .F.

RETURN nAt > 0

//------------------------------------------------------------------------------

METHOD SetMasterDetail( cMasterName, cDetailName, aFields ) CLASS XFastReport

   LOCAL cMasterFields, cDetailFields
   LOCAL cValue, cTemp1, cTemp2
   LOCAL nFor

   cDetailFields := ""
   cMasterFields := ""

   FOR nFor := 1 TO Len( aFields )
      cValue := aFields[ nFor ]
      cTemp1 := hb_tokenGet( cValue, 1, "=" )
      cTemp2 := hb_tokenGet( cValue, 2, "=" )
      IF Empty( cTemp2 )
         cTemp2 = cTemp1
      ENDIF
      cDetailFields += cTemp1
      cMasterFields += cTemp2
      IF nFor < Len( aFields )
         cDetailFields += ";"
         cMasterFields += ";"
      ENDIF
   NEXT nFor

RETURN ::SetMasterDetailC( cMasterName, cDetailName, cMasterFields, cDetailFields )

//------------------------------------------------------------------------------

METHOD SetVariable( cName, xValue ) CLASS XFastReport

   IF ValType( xValue ) == "C"
      xValue := "'" + xValue + "'"
   ENDIF

   ::LoadReport()
   ::SetCargo( xValue )

RETURN ::SetVariableC( cName )

//------------------------------------------------------------------------------

METHOD AddVariable( cName, xValue ) CLASS XFastReport

   IF ValType( xValue ) == "C"
      xValue := "'" + xValue + "'"
   ENDIF

   ::LoadReport()
   ::SetCargo( xValue )

RETURN ::AddVariableC( cName )

//------------------------------------------------------------------------------

METHOD Calc( cPascalExp ) CLASS XFastReport

   ::LoadReport()

   IF ::CalcC( cPascalExp )
      RETURN ::GetCargo()
   ENDIF

RETURN Nil

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------

STATIC FUNCTION FileExtension( cFileName ) // --> cExtension

   LOCAL cExtension
   LOCAL nAtPoint, nAtSlash

   cExtension := ""
   nAtPoint   := Rat( ".", cFileName )
   nAtSlash   := Rat( "\", cFileName )

   IF nAtPoint > 0 .AND. nAtPoint > nAtSlash
      cExtension := Substr( cFileName, nAtPoint + 1 )
   ENDIF

RETURN cExtension

//--------------------------------------------------------------------------

STATIC FUNCTION ReadLine( cText, nFrom, cSep )

   LOCAL cLine
   LOCAL nAt, nLen

   IF nFrom == NIL
      nFrom := 1
   ENDIF

   IF cSep == NIL
      cSep := CRLF
   ENDIF

   nLen  := Len( cText )

   IF nFrom > nLen
      nFrom := 0
      RETURN ""
   ENDIF

   nAt := hb_At( cSep, cText, nFrom )

   IF nAt == 0
      cLine := Substr( cText, nFrom )
      nFrom := nLen + 1
   ELSE
      cLine := Substr( cText, nFrom, nAt - nFrom  )
      nFrom := nAt + Len( cSep )
   ENDIF

RETURN cLine

//--------------------------------------------------------------------------

STATIC FUNCTION ToString( xValue )

   LOCAL cRet := "<Error>"

   SWITCH ValType( xValue )
   CASE "C"
      cRet := xValue
      EXIT
   CASE "N"
      cRet := LTrim( Str( xValue, 15, set( _SET_DECIMALS ) ) )
      EXIT
   CASE "D"
   CASE "T"
      cRet := DToC( xValue )
      EXIT
   CASE "L"
      cRet := IIF( xValue, ".T.", ".F." )
      EXIT
   CASE "A"
      cRet := "{ Array }"
      EXIT
   CASE "B"
      cRet := "{|| Block }"
      EXIT
   END SWITCH

RETURN cRet