/*
 * Proyect: FastReport for [x]Harbour
 * Description: FastReport dataset connector class
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#include "frh.ch"

//------------------------------------------------------------------------------

CLASS XFrDataset FROM TFrObject

EXPORTED:
   VAR nMaxRecsOnDesign INIT 100
   VAR nLoaded          INIT 0   READONLY // 0 Not Loaded, 1 Design, 2 Normal
   VAR lLoadOnDemand    INIT .F.

   VAR bOnAfterLoad        // ( oSender ) // --> NIL
   VAR bOnClose            // ( oSender ) // --> NIL
   VAR bOnFirst            // ( oSender ) // --> NIL
   VAR bOnNext             // ( oSender ) // --> NIL
   VAR bOnOpen             // ( oSender ) // --> NIL
   VAR bOnPrior            // ( oSender ) // --> NIL
   VAR bOnCreate           // ( oSender ) // --> NIL

   METHOD oReport( oValue ) SETGET
   METHOD oDsMaster( oValue ) SETGET
   METHOD aRelationFields( aValue ) SETGET
   METHOD cName( cValue ) SETGET

   METHOD New( oParent )    CONSTRUCTOR
   METHOD Create( oParent ) CONSTRUCTOR
   METHOD Free()
   METHOD End() INLINE ::Free()

   METHOD Refresh()  INLINE ::Load()
   METHOD IsActive() INLINE ::nDbInstance > 0
   METHOD IsLoaded() INLINE ::nLoaded > 0
   METHOD SetMaster( oDsMaster, aFields ) INLINE ::oDsMaster :=  oDsMaster,;
                                                 ::aRelationFields := aFields
RESERVED: // To be used by friend classes
   VAR nDbInstance   INIT 0  READONLY
   VAR lMasterDetail INIT .F. // True if link done
   VAR lComplete     INIT .F.

   METHOD AfterLoad()      INLINE ::Event( ::bOnAfterLoad )
   METHOD Build()          VIRTUAL
   METHOD Load( lDesign )  INLINE ::nLoaded := IIF( lDesign, 1, 2 )
   METHOD RequestRecord()  INLINE ( ::SetDBComplete(), .F. )
   METHOD Event( bVar, xPar1, xPar2, xPar3 ) INLINE IIF( bVar != NIL, Eval( bVar, Self, xPar1, xPar2, xPar3 ), )

PROTECTED:
   VAR FoReport
   VAR FoDsMaster
   VAR FaRelationFields INIT {} // "DetField1=MasField1;...; DetFieldN=MasterFiedlN"
   VAR FcName
   VAR aFields  INIT {}
   VAR cDefName INIT "Data"

   METHOD SetReport( oReport )
   METHOD AddDataSet( cName )
   METHOD ClearDB( lDelFields )
   METHOD SetDBComplete() INLINE ( ::lComplete := .T., ::oReport:SetDBComplete( ::nDbInstance ) )
   METHOD AddField( cName, cType, nLen, lDec )
   METHOD AddRecord()
   METHOD AddValue( cField, xValue )
   METHOD GetBasicType( cType, lDec )

END CLASS

//------------------------------------------------------------------------------

METHOD oReport( oValue ) CLASS XFrDataset

   IF PCount() > 0
      IF ::FoReport != NIL
         ::ClearDB( .t. )
         ::FoReport:DelDataset( Self )
      ENDIF

      ::FoReport := oValue

      IF oValue != NIL .AND. ::lCreated
         AAdd( oValue:aDatasets, Self )
      ENDIF

   ENDIF

RETURN ::FoReport

//------------------------------------------------------------------------------

METHOD SetReport( oValue ) CLASS XFrDataset

   IF ::FoReport != NIL
      ::ClearDB( .t. )
      ::FoReport:DelDataset( Self )
   ENDIF

   ::FoReport := oValue

   IF oValue != NIL .AND. ::lCreated
      AAdd( oValue:aDatasets, Self )
   ENDIF

RETURN ::FoReport

//------------------------------------------------------------------------------

METHOD oDsMaster( oValue ) CLASS XFrDataset

   IF PCount() > 0
      IF ::FoDsMaster != NIL .AND. ::lMasterDetail
         ::oReport:ClearMasterDetail( ::FoDsMaster:cName, ::cName )
      ENDIF
      ::FoDsMaster := oValue
   ENDIF

RETURN ::FoDsMaster

//------------------------------------------------------------------------------

METHOD aRelationFields( aValue ) CLASS XFrDataset

   IF PCount() > 0
      ::FaRelationFields := aValue
   ENDIF

RETURN ::FaRelationFields

//------------------------------------------------------------------------------

METHOD cName( cValue ) CLASS XFrDataset

   LOCAL oDS
   LOCAL aValues := {}

   IF PCount() == 0
      IF Empty( ::FcName ) .AND. ::oReport != NIL
         FOR EACH oDS IN ::oReport:aDatasets
            IF oDS != NIL .AND. !( oDS == Self )
               AAdd( aValues, oDS:FcName )
            ENDIF
         NEXT
         ::FcName := ValidName( ::cDefName, aValues )
      ENDIF
      RETURN ::FcName
   ENDIF

   cValue := StrPattern( cValue, " :,.$!%&?-;{}@#()=*<>", .F. )

   IF ::oReport != NIL
      FOR EACH oDS IN ::oReport:aDatasets
         IF oDS != NIL .AND. !( oDS == Self )
            AAdd( aValues, oDS:cName )
         ENDIF
      NEXT
      cValue := ValidName( cValue, aValues )
   ENDIF

   IF !Empty( cValue )
      IF !::IsActive() .OR. ::oReport:SetDBName( ::nDbInstance, cValue )
         ::FcName := cValue
      ENDIF
   ELSE
      ::FcName := ""
   ENDIF

RETURN ::FcName

//------------------------------------------------------------------------------

METHOD New( oParent ) CLASS XFrDataset

   ::Super:New( oParent )

RETURN Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS XFrDataset

   ::Super:Create( oParent )

   IF ::oReport != NIL
      AAdd( ::oReport:aDatasets, Self )
   ENDIF

   ::Event( ::bOnCreate )

RETURN Self

//------------------------------------------------------------------------------

METHOD Free() CLASS XFrDataset

   ::SetReport()
   ::cName       := ""
   ::nDbInstance := 0
   ::nLoaded     := 0
   ::aFields     := {}

RETURN ::Super:Free()

//------------------------------------------------------------------------------

METHOD AddDataSet( cName ) CLASS XFrDataset

   IF cName != NIL
      ::cName := cName
   ENDIF

   IF ::nDbInstance > 0
      ::ClearDB( .T. )
   ENDIF

   ::nDbInstance := ::oReport:AddFrDataSet( ::cName )

RETURN !Empty( ::nDbInstance )

//------------------------------------------------------------------------------

METHOD ClearDB( lDelFields ) CLASS XFrDataset

   LOCAL lSuccess

   IF lDelFields == NIL
      lDelFields := .F.
   ENDIF

   lSuccess := ::oReport:ClearDB( ::nDbInstance, lDelFields )

   IF lDelFields
      ::nDbInstance := 0
      ::nLoaded     := 0
   ENDIF

RETURN lSuccess

//------------------------------------------------------------------------------

METHOD AddField( cName, cType, nLen, lDec ) CLASS XFrDataset

   LOCAL nType

   nType := ::GetBasicType( cType, lDec )
   cName := ValidName( cName, ::aFields )
   AAdd( ::aFields, cName )

   ::oReport:AddFrField( ::nDbInstance, cName, nType, nLen )

RETURN nType

//------------------------------------------------------------------------------

METHOD AddRecord() CLASS XFrDataset

RETURN ::oReport:AddFrRecord( ::nDbInstance )

//------------------------------------------------------------------------------

METHOD AddValue( cField, xValue ) CLASS XFrDataset

RETURN ::oReport:AddFrValue( ::nDbInstance, cField, xValue )

//------------------------------------------------------------------------------

METHOD GetBasicType( cType, lDec ) CLASS XFrDataset

   LOCAL nType

   IF cType == NIL
      cType := "C"
   ELSEIF Len( cType ) > 1
      IF Upper( cType ) == "MONEY" //Error ADS
         cType := "N"
      ELSE
         cType := "C"
      ENDIF
   ENDIF

   IF lDec == NIL
      lDec :=  .F.
   ENDIF

   SWITCH cType
   CASE "C"
      nType := PROPERTY_CADENA
      EXIT
   CASE "D"
   CASE "T"
   CASE "@"
      nType := PROPERTY_FECHA
      EXIT
   CASE "L"
      nType := PROPERTY_LOGICO
      EXIT
   CASE "N"
   CASE "+"
      nType := IIF( lDec, PROPERTY_NUMERO_DOBLE, PROPERTY_NUMERO_ENTERO )
      EXIT
   CASE "M"
   CASE "W"
      nType := PROPERTY_BLOB
      EXIT
   OTHERWISE
      nType := PROPERTY_BLOB
      EXIT
   END SWITCH

RETURN nType

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFrArrayDataset FROM TFrDataset

EXPORTED:
   VAR lLoadOnDemand INIT .f. READONLY
   METHOD aFields( aValue ) SETGET
   METHOD aData( aValue ) SETGET

RESERVED: // To be used by its friend classes
   METHOD Build( cName, oDataset )
   METHOD Load( lDesign )
   METHOD Free()

PROTECTED:
   VAR FaFields INIT {}
   VAR FaData   INIT {}
   VAR aNames
   VAR cDefName INIT "Array"

END CLASS

//------------------------------------------------------------------------------

METHOD aFields( aValue ) CLASS XFrArrayDataset

   LOCAL nFor

   IF PCount() > 0

      IF ::IsActive()
         ::ClearDB( .t. )
      ENDIF

      FOR nFor := 1 TO Len( aValue )
         IF ValType( aValue[ nFor ] ) == "A"
            aValue[ nFor ] := aValue[ nFor, 1 ] + "," + aValue[ nFor, 2 ] + "," + ;
                              LTrim(Str( aValue[ nFor, 3 ] ) ) + "," + ;
                              LTrim(Str( aValue[ nFor, 4 ] ) )
         ENDIF
      NEXT

      ::FaFields := aValue
   ENDIF

RETURN ::FaFields

//------------------------------------------------------------------------------

METHOD aData( aValue ) CLASS XFrArrayDataset

   IF PCount() > 0
      IF ::IsActive()
         ::ClearDB( .t. )
      ENDIF
      ::FaData := aValue
   ENDIF

RETURN ::FaData

//------------------------------------------------------------------------------

METHOD Free() CLASS XFrArrayDataset

   ::aFields := {}
   ::aData   := {}
   ::aNames  := {}

RETURN ::Super:Free()

//------------------------------------------------------------------------------

METHOD Build( cName, aData )  CLASS XFrArrayDataset

   LOCAL aInfo, aFields
   LOCAL cField, cType, nLen, nDec, nFor

   IF !Empty( aData )
      ::aData := aData
   ENDIF

   IF !Empty( cName )
      ::cName := cName
   ENDIF

   IF ::aFields == NIL
      ::aFields := {}
   ENDIF

   IF ::oReport == NIL .OR. Empty( ::aData ) .OR. ::IsActive()
      RETURN .F.
   ENDIF

   ::AddDataSet( ::cName )

   aInfo    := ::aData[ 1 ]
   aFields  := ::aFields
   ::aNames := {}

   FOR nFor := 1 TO Len( aInfo )

      IF Len( aFields ) >= nFor
         cField := hb_tokenGet( aFields[ nFor ], 1, "," )
         cType  := hb_tokenGet( aFields[ nFor ], 2, "," )
         nLen   := Val( hb_tokenGet( aFields[ nFor ], 3, "," ) )
         nDec   := Val( hb_tokenGet( aFields[ nFor ], 4, "," ) )
      ELSE
         cField := ""
         cType  := ""
         nLen   := 0
         nDec   := 0
      ENDIF

      IF cField == NIL
         cField := "Field" + LTrim( Str( nFor ) )
      ENDIF

      IF cType == NIL
         cType := ValType( aInfo[ nFor ] )
      ELSEIF Len( cType ) > 1
         IF Upper( cType ) == "MONEY" //Error ADS
            cType := "N"
         ELSE
            cType := "C"
         ENDIF
      ENDIF

      IF Empty( nLen ) .OR. Empty( nDec )
         SWITCH cType
         CASE "C"
         CASE "M"
         CASE "W"
            nLen := 65000
            EXIT
         CASE "N"
         CASE "+"
            nLen := 15
            nDec := 0
            IF aInfo[ nFor ] != Int( aInfo[ nFor ] )
               nDec := 4
            ENDIF
            EXIT
         CASE "L"
            nLen := 1
            nDec := 0
            EXIT
         CASE "D"
         CASE "T"
         CASE "@"
            nLen := 8
            nDec := 0
            EXIT
         END SWITCH
      ENDIF

      ::AddField( @cField, cType, nLen, nDec > 0 )
      AAdd( ::aNames, cField )

   NEXT

RETURN .T.

//------------------------------------------------------------------------------

METHOD Load( lDesign )  CLASS XFrArrayDataset

   LOCAL oRep, oField
   LOCAL aData, aRow, aNames, xValue
   LOCAL nDb, nPos, nMax

   IF lDesign == NIL
      lDesign := .F.
   ENDIF

   IF lDesign .AND. ::nMaxRecsOnDesign > 0
      nMax := ::nMaxRecsOnDesign
   ELSE
      lDesign := .F.
   ENDIF

   oRep   := ::oReport
   aData  := ::aData
   aNames := ::aNames
   nDb    := ::nDbInstance

   IF Empty( ::nDbInstance )
      RETURN .F.
   ENDIF

   ::ClearDB( .F. )

   /*
   Direct access to oReport for speed
   */

   FOR EACH aRow IN aData
      oRep:AddFrRecord( nDb )
      nPos := 1
      FOR EACH xValue IN aRow
         oRep:AddFrValue( nDb, aNames[ nPos++ ], xValue )
      NEXT
      IF lDesign .AND. nMax-- < 0
         EXIT
      ENDIF
   NEXT

   ::nLoaded := IIF( lDesign, 1, 2 )

RETURN .T.

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS XFrDbfDataset FROM TFrDataset

EXPORTED:
   METHOD aFields( aValue ) SETGET

RESERVED: // To be used by its friend classes
   METHOD Build( cName, oDataset )
   METHOD Load( lDesign )
   METHOD RequestRecord()
   METHOD Free()

PROTECTED:
   VAR FaFields INIT {}
   VAR aNames
   VAR cAlias
   VAR cDefName INIT "Dbf"

END CLASS

//------------------------------------------------------------------------------

METHOD aFields( aValue ) CLASS XFrDbfDataset

   IF PCount() > 0
      IF ::IsActive()
         ::ClearDB( .t. )
      ENDIF
      IF aValue == NIL
         aValue := { "*" }
      ELSEIF ValType( aValue ) == "C"
         aValue := { aValue }
      ENDIF
      ::FaFields := aValue
   ENDIF

RETURN ::FaFields

//------------------------------------------------------------------------------

METHOD Free() CLASS XFrDbfDataset

   ::aFields := {}
   ::aNames  := {}

RETURN ::Super:Free()

//------------------------------------------------------------------------------

METHOD Build( cName, aFields ) CLASS XFrDbfDataset

   LOCAL cAlias, cField, cType, cFrName
   LOCAL nLen, nDec, nFor

   IF !Empty( aFields )
      ::aFields := aFields
   ENDIF

   IF !Empty( cName )
      ::cName := cName
   ENDIF

   IF ::oReport == NIL .OR. Empty( ::aFields ) .OR. ::IsActive()
      RETURN .F.
   ENDIF

   ::AddDataSet( ::cName )

   aFields  := CheckMarks( ::aFields )

   ::aNames := {}

   FOR nFor := 1 TO Len( aFields )

      cField := aFields[ nFor ]

      IF GetFieldInfo( @cField, @cAlias, @cType, @nLen, @nDec, @cFrName )
         IF nFor == 1
            ::cAlias   := cAlias
            ::cDefName := cAlias
         ENDIF
         ::AddField( @cFrName, cType, nLen, nDec > 0 )
         AAdd( ::aNames, { cFrName, FieldWBlock( cField, Select( cAlias ) ) } )
      ENDIF

   NEXT

RETURN .T.

//------------------------------------------------------------------------------

METHOD Load( lDesign )  CLASS XFrDbfDataset

   LOCAL oRep, xValue
   LOCAL aNames
   LOCAL cOldAlias
   LOCAL nDb, nRecno, nLen, nFor, nMax
   LOCAL lCmp

   IF lDesign == NIL
      lDesign := .F.
   ENDIF

   IF ::lLoadOnDemand
      nMax := Max( ::nMaxRecsOnDesign, 10 )
      lCmp := .f.
   ELSEIF lDesign .AND. ::nMaxRecsOnDesign > 0
      nMax := ::nMaxRecsOnDesign
      lCmp := .f.
   ELSE
      lCmp := .t.
   ENDIF

   oRep   := ::oReport
   aNames := ::aNames
   nDb    := ::nDbInstance
   nLen   := Len( aNames )

   IF Empty( ::nDbInstance )
      RETURN .F.
   ENDIF

   ::ClearDB()

   /*
   Direct access to oReport for speed
   */

   cOldAlias := Alias()

   IF Select( ::cAlias ) == 0
      Select( cOldAlias )
      RETURN .F.
   ELSE
      DBSelectArea( ::cAlias )
   ENDIF

   IF lCmp
      nRecno := Recno()
   ENDIF

   GO TOP

   DO WHILE !Eof() .AND. ( lCmp .OR. nMax-- > 0 )
      oRep:AddFrRecord( nDb )
      FOR nFor := 1 TO nLen
         xValue := Eval( aNames[ nFor, 2 ] )
         oRep:AddFrValue( nDb, aNames[ nFor, 1 ], xValue )
      NEXT
      SKIP
   ENDDO

   IF lCmp
      ::SetDBComplete()
      DBGoTo( nRecno )
   ENDIF

   DbSelectArea( cOldAlias )

   ::nLoaded := IIF( lDesign, 1, 2 )

RETURN .T.

//------------------------------------------------------------------------------

METHOD RequestRecord()  CLASS XFrDbfDataset

   LOCAL oRep, xValue
   LOCAL aNames
   LOCAL nDb, nLen, nFor
   LOCAL lRet

   oRep   := ::oReport
   aNames := ::aNames
   nDb    := ::nDbInstance
   nLen   := Len( aNames )
   lRet   := .F.

   IF !(::cAlias)->( Eof() )
      oRep:AddFrRecord( nDb )
      FOR nFor := 1 TO nLen
         xValue := Eval( aNames[ nFor, 2 ] )
         oRep:AddFrValue( nDb, aNames[ nFor, 1 ], xValue )
      NEXT
      lRet := .T.
      (::cAlias)->( DbSkip() )
   ENDIF

   IF (::cAlias)->( Eof() )
      ::SetDBComplete()
   ENDIF

RETURN lRet

//------------------------------------------------------------------------------

STATIC FUNCTION GetFieldInfo( cField, cAlias, cType, nLen, nDec, cName )

   LOCAL cOldAlias
   LOCAL nAt, nPos

   nAt := At( "->", cField )

   IF nAt = 0
      cAlias := Alias()
   ELSE
      cAlias := Left( cField, nAt - 1 )
      cField := SubStr( cField, nAt + 2 )
   ENDIF

   IF Empty( cAlias )
      RETURN .f.
   ENDIF

   nAt := At( " AS ", Upper( cField ) )

   IF nAt > 0
      cName  := SubStr( cField, nAt + 4 )
      cField := Left( cField, nAt - 1 )
   ELSE
      cName := cField
   ENDIF

   cOldAlias := Alias()

   IF Select( cAlias ) == 0
      Select( cOldAlias )
      RETURN .f.
   ELSE
      DBSelectArea( cAlias )
   ENDIF

   nPos := FieldPos( cField )

   IF Empty( nPos )
      DbSelectArea( cOldAlias )
      RETURN .f.
   ENDIF

   cType := FieldType( nPos )
   nLen  := FieldLen( nPos )
   nDec  := FieldDec( nPos )

   DbSelectArea( cOldAlias )

RETURN .t.

//------------------------------------------------------------------------------

STATIC FUNCTION CheckMarks( aFields )

   LOCAL aList := {}, aInfo, aTemp
   LOCAL cField, cAlias
   LOCAL nAt

   FOR EACH cField IN aFields
      IF Right( cField, 1 ) == "*"
         IF ( nAt := At( "->", cField ) ) > 0
            cAlias := Left( cField, nAt - 1 )
            aInfo  := (cAlias)->( DBStruct() )
            cAlias += "->"
         ELSE
            cAlias := ""
            aInfo  := DBStruct()
         ENDIF
         FOR EACH aTemp IN aInfo
            AAdd( aList, cAlias + aTemp[ 1 ] )
         NEXT
      ELSE
         AAdd( aList, cField )
      ENDIF
   NEXT

RETURN aList

//------------------------------------------------------------------------------

STATIC FUNCTION ValidName( cName, aNames )

   LOCAL nVal, nPos, nLen

   DO WHILE Ascan( aNames, {|v| Upper( v ) == Upper( cName ) } ) > 0

      nLen := nPos := Len( cName )
      nVal := 0

      DO WHILE nPos > 0 .AND. IsDigit( Substr( cName, nPos, 1 ) )
         nPos --
      ENDDO

      IF nPos < nLen
         nVal  := Val( Substr( cName, nPos + 1 ) )
         cName := Substr( cName, 1, nPos )
      ENDIF

      cName += lTrim( Str( ++ nVal ) )

   ENDDO

RETURN cName

//------------------------------------------------------------------------------

STATIC FUNCTION StrPattern( cString, cPattern, lInc )  // --> cString

   LOCAL cStr := ""
   LOCAL cChr := ""
   LOCAL nlen := Len( cString )
   LOCAL nAt  := 1
   LOCAL lIn

   cPattern := Upper( cPattern )

   DO WHILE nAt <= nlen
      cChr := Substr( cString, nAt, 1 )
      lIn := Upper( cChr ) $ cPattern
      IF ( lIn .AND. lInc ) .OR. ( ! lIn .AND. ! lInc )
         cStr += cChr
      ENDIF
      nAt++
   ENDDO

RETURN cStr
