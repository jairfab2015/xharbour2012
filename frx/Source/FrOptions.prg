/*
 * Proyect: FastReport for [x]Harbour
 * Description: FastReport options class
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#include "frh.ch"
#include "error.ch"

#define CRLF Chr( 13 ) + Chr( 10 )

#ifdef __XHARBOUR__
   #xtranslate PROPERTY <Property> [ INIT <Init> ] => ;
               s_oClass:AddData( "F" + <"Property">, [ <Init> ] )
#else
   #xtranslate PROPERTY <Property> [ INIT <Init> ] => ;
               oClass:AddData( "F" + <"Property">, [ <Init> ] )
#endif

//------------------------------------------------------------------------------

CLASS XFrOptions FROM TFrObject

EXPORTED:
   VAR oParent
   VAR cSection  INIT "dummy" READONLY

   METHOD New( oParent ) CONSTRUCTOR
   METHOD Create( oParent ) INLINE ::New( oParent )

RESERVED:
   METHOD AfterLoad()

PROTECTED:
   METHOD SetValue( cProperty, Value )
   METHOD GetValue( cProperty )

   ERROR HANDLER OnError( uParam )

END CLASS

//------------------------------------------------------------------------------

METHOD New( oParent ) CLASS XFrOptions

   ::oParent := oParent

RETURN Self

//------------------------------------------------------------------------------

METHOD OnError( uParam ) CLASS XFrOptions

   LOCAL oError
   LOCAL cVar
   LOCAL nError

   cVar := __GetMessage()

   IF Left( cVar, 1 ) == "_" // SET
      cVar := Substr( cVar, 2 )
      IF __objHasMsg( Self, "F" + cVar )
         RETURN ::SetValue( cVar, uParam )
      ENDIF
      nError := 1005
   ELSE
      IF __objHasMsg( Self, "F" + cVar )
         RETURN ::GetValue( cVar )
      ENDIF
      nError := 1004
   ENDIF

   oError := ErrorNew()
   oError:SubSystem   := "BASE"
   oError:SubCode     := nError
   oError:Severity    := ES_ERROR
   oError:Description := "Message not found"
   oError:Operation   := ::ClassName() + ":" + cVar
   oError:Args        := { uParam }

   Eval( ErrorBlock(), oError )

RETURN Nil

//------------------------------------------------------------------------------

METHOD AfterLoad() CLASS XFrOptions

   LOCAL oClone
   LOCAL aProperties, aMember
   LOCAL xValue, xInit
   LOCAL cVar

   aProperties := __objGetValueList( Self )
   oClone      := &(Self:Classname+"()")

   FOR EACH aMember IN aProperties
      cVar := aMember[ 1 ]
      IF Left( cVar, 1 ) == "F"
         xInit  := __objSendMsg( oClone, cVar )
         xValue := aMember[ 2 ]
         TRY
            IF !Empty( xValue ) .AND. !( xInit == xValue )
               __objSendMsg( Self, "_" + cVar, xValue )
            ENDIF
         CATCH
         END
      ENDIF
   NEXT

RETURN NIL

//------------------------------------------------------------------------------

METHOD SetValue( cProperty, Value ) CLASS XFrOptions

   LOCAL cTemp, cVal

   Value := __objSendMsg( Self, "_F" + cProperty, Value )

   IF ::oParent != NIL
      WITH OBJECT ::oParent
         IF :lCreated
            IF Upper( Left( cProperty, 1 ) ) != "A"
               :SetProperty( ::cSection, SubStr( cProperty, 2 ), Value )
            ELSEIF ValType( Value ) == "A"
               cTemp := "REPORT." + ::cSection + "." + SubStr( cProperty, 2 )
               :Calc( cTemp + ".Clear" )
               FOR EACH cVal IN Value
                  :Calc( cTemp + ".Add( '" + cVal + "')" )
               NEXT
            ENDIF
         ENDIF
      END WITH
   ENDIF

RETURN Value

//------------------------------------------------------------------------------

METHOD GetValue( cProperty ) CLASS XFrOptions

   LOCAL Value := __objSendMsg( Self, "F" + cProperty )

   IF ::oParent != NIL
      WITH OBJECT ::oParent
         IF :lCreated
            IF Upper( Left( cProperty, 1 ) ) != "A"
               Value := :GetProperty( ::cSection, SubStr( cProperty, 2 ) )
            ELSEIF ValType( Value ) == "A"
               //Value := :GetProperty( ::cSection, SubStr( cProperty, 2 ) + ".Text" )
               Value := :GetProperty( ::cSection, SubStr( cProperty, 2 ) )
               IF Valtype( Value ) == "C"
                  Value := hb_atokens( Value, CRLF )
               ELSE
                  Value := {}
               ENDIF
            ENDIF
         ENDIF
      END WITH
   ENDIF

RETURN Value

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFrEngineOptions FROM TFrOptions

EXPORTED:
   PROPERTY lConvertNulls    INIT .T.
   PROPERTY lDoublePass      INIT .T.
   PROPERTY lIgnoreDevByZero INIT .F.
   PROPERTY lPrintIfEmpty    INIT .T.
   PROPERTY nMaxMemSize      INIT 10
   PROPERTY cTempDir         INIT ""
   PROPERTY lUseFileCache    INIT .F.
   PROPERTY nNewSilentMode   INIT simMessageBoxes
   PROPERTY lSilentMode      INIT .F.

   VAR cSection INIT "EngineOptions" READONLY

// Sergey compatibility methods
   METHOD SetConvertNulls( lValue )  INLINE ::lConvertNulls := lValue
   METHOD SetDoublePass( lValue )    INLINE ::lDoublePass := lValue
   METHOD SetPrintIfEmpty( lValue )  INLINE ::lPrintIfEmpty := lValue
   METHOD SetSilentMode( lValue )    INLINE ::lSilentMode := lValue
   METHOD SetNewSilentMode( nValue ) INLINE ::nNewSilentMode := nValue
   METHOD SetMaxMemSize( nValue )    INLINE ::nMaxMemSize := nValue
   METHOD SetTempDir( cValue )       INLINE ::cTempDir := cValue
   METHOD SetUseFileCache( lValue )  INLINE ::lUseFileCache := lValue

END CLASS

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFrPreviewOptions FROM TFrOptions

EXPORTED:
   PROPERTY lAllowEdit           INIT .F.
   PROPERTY nButtons             INIT  4095
   PROPERTY lDoubleBuffered      INIT .T.
   PROPERTY lMaximized           INIT .T.
   PROPERTY lOutLineVisible      INIT .F.
   PROPERTY lOutLineExpand       INIT .T.
   PROPERTY nOutLineWidth        INIT 180
   PROPERTY lShowCaptions        INIT .F.
   PROPERTY nZoom                INIT 1.00
   PROPERTY nZoomMode            INIT zmDefault
   PROPERTY lModal               INIT .T.
   PROPERTY lPictureCacheInFile  INIT .F.

   VAR cSection INIT "PreviewOptions" READONLY

   METHOD SetBounds( nLeft, nTop, nWidth, nHeight )

// Sergey compatibility methods
   METHOD SetAllowEdit( lValue )          INLINE ::lAllowEdit := lValue
   METHOD SetButtons( nValue )            INLINE ::nButtons := nValue
   METHOD SetDoubleBuffered( lValue )     INLINE ::lDoubleBuffered := lValue
   METHOD SetMaximized( lValue )          INLINE ::lMaximized := lValue
   METHOD SetOutlineVisible( lValue )     INLINE ::lOutLineVisible := lValue
   METHOD SetOutlineExpand( lValue )      INLINE ::lOutLineExpand := lValue
   METHOD SetOutlineWidth( nValue )       INLINE ::nOutLineWidth := nValue
   METHOD SetShowCaptiosn( lValue )       INLINE ::lShowCaptions := lValue
   METHOD SetZoom( nValue )               INLINE ::nZoom := nValue
   METHOD SetZoomMode( nValue )           INLINE ::nZoomMode := nValue
   METHOD SetModal( lValue )              INLINE ::lModal := lValue
   METHOD SetPictureCacheInFile( lValue ) INLINE ::lPictureCacheInFile := lValue

END CLASS

//------------------------------------------------------------------------------

METHOD SetBounds( nLeft, nTop, nWidth, nHeight ) CLASS XFrPreviewOptions
RETURN ::oParent:frSetBounds(nLeft, nTop, nWidth, nHeight)

//------------------------------------------------------------------------------

CLASS XFrPrintOptions FROM TFrOptions

EXPORTED:
   PROPERTY nCopies        INIT   1
   PROPERTY lCollate       INIT .T.
   PROPERTY cPageNumbers   INIT  ""
   PROPERTY cPrinter       INIT  "Default"
   PROPERTY nPrintPages    INIT ppAll
   PROPERTY lShowDialog    INIT .T.
   PROPERTY lReverse       INIT .F.

   DATA cSection INIT "PrintOptions" READONLY
   METHOD ClearOptions()

// Sergey compatibility methods
   METHOD SetCopies( nValue )      INLINE ::nCopies := nValue
   METHOD SetPageNumbers( cValue ) INLINE ::cPageNumbers := cValue
   METHOD SetPrinter( cValue )     INLINE ::cPrinter := cValue
   METHOD SetPrintPages( nValue )  INLINE ::nPrintPages := nValue
   METHOD SetShowDialog( lValue )  INLINE ::lShowDialog := lValue
   METHOD SetReverse( lValue )     INLINE ::lReverse := lValue

END CLASS

//------------------------------------------------------------------------------

METHOD ClearOptions() CLASS XFrPrintOptions

   IF ::oParent != NIL .AND. ::oParent:lCreated
      ::oParent:Calc( "REPORT." + ::cSection + ".ClearOptions()" )
   ENDIF

RETURN NIL

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFrReportOptions FROM TFrOptions

EXPORTED:
   PROPERTY cAuthor           INIT  ""
   PROPERTY lCompressed       INIT .F.
   PROPERTY aDescription      INIT  {}
   PROPERTY cInitString       INIT  ""
   PROPERTY cName             INIT  ""
   PROPERTY cPassword         INIT  ""

   PROPERTY cVersionBuild     INIT  ""
   PROPERTY cVersionMajor     INIT  ""
   PROPERTY cVersionMinor     INIT  ""
   PROPERTY cVersionRelease   INIT  ""

   DATA cSection INIT "ReportOptions" READONLY

// Sergey compatibility methods
   METHOD SetAuthor( cValue )          INLINE ::cAuthor := cValue
   METHOD SetCompressed( lValue )      INLINE ::lCompressed := lValue
   METHOD SetCreateDate( dValue )      VIRTUAL //TODO
   METHOD SetLastChange( dValue )      VIRTUAL //TODO
   METHOD SetDescription( aValue )     INLINE ::aDescription := aValue
   METHOD SetInitString( cValue )      INLINE ::cInitString := cValue
   METHOD SetName( cValue )            INLINE ::cName := cValue
   METHOD SetPassword( cValue )        INLINE ::cPassword := cValue
   METHOD SetVersion( c1, c2, c3, c4 ) INLINE ;
          ::cVersionMajor := c1, ::cVersionMinor := c2,;
          ::cVersionRelease := c3, ::cVersionBuild := c4
END CLASS

//------------------------------------------------------------------------------

