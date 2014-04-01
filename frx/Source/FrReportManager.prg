/*
 * Proyect: FastReport for [x]Harbour
 * Description: FastReport Sergey compatibility class
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#include "frh.ch"

#define FR_RB_FIRST      0
#define FR_RB_CURRENT    1

#define FR_RE_LAST       0
#define FR_RE_CURRENT    1
#define FR_RE_COUNT      2

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS frReportManager FROM TFastReport

   METHOD New( cFile ) CONSTRUCTOR
   METHOD Init() INLINE ::New()
   METHOD DestroyFR() INLINE ::End()
   METHOD AddVariable( cCategory, cName, xValue )
   METHOD SetWorkArea( cAlias, nArea, lOem, aRangeParams )  // --> oDataset
   METHOD SetFieldAliases( cAlias, cFieldAliases )          // --> lSuccess
   METHOD SetUserDataset( cAlias, cFields, bGotop, bSkipPlus1,;
                          bSkipMinus1, bCheckEof, bGetValue ) // --> oDataset

END CLASS

//------------------------------------------------------------------------------

METHOD New( cFile ) CLASS frReportManager

   ::Super:New()

   IF !Empty( cFile )
      ::cFileName := cFile
   ENDIF

RETURN Self

//------------------------------------------------------------------------------

METHOD SetWorkArea( cAlias, nArea, lOem, aRangeParams ) CLASS frReportManager

   LOCAL aNames, aData, aRow
   LOCAL cOldAlias
   LOCAL nCount, nRecno, nLastRec, nFor, nlen
   LOCAL xValue

   IF lOem == NIL
      lOem := .F.
   ENDIF

   cOldAlias := Alias()
   nCount    := 0
   nLastRec  := 0

   IF Select( cAlias ) == 0
      Select( cOldAlias )
      ::SetError( 301, "Alias " + cAlias + " not available." )
      RETURN NIL
   ELSE
      DBSelectArea( cAlias )
   ENDIF

   nRecno := Recno()

   IF Empty( aRangeParams )
      GO TOP
   ELSE
      IF aRangeParams[ 1 ] == FR_RB_FIRST
         GO TOP
      ENDIF
      IF Len( aRangeParams ) > 1
         IF aRangeParams[ 2 ] == FR_RE_CURRENT
            nLastRec := nRecno
         ELSEIF aRangeParams[ 2 ] == FR_RE_COUNT .AND. Len( aRangeParams ) > 2
            nCount := aRangeParams[ 3 ]
         ENDIF
      ENDIF
   ENDIF

   aNames := DBStruct()
   aData  := {}
   nlen   := Len( aNames )

   DO WHILE !Eof()

      aRow := Array( nlen )

      FOR nFor := 1 TO nlen
         xValue := FieldGet( nFor )
         IF lOem .AND. FieldType( nFor ) == "C"
            xValue := FR_OEMToAnsi( xValue )
         ENDIF
         aRow[ nFor ] := xValue
      NEXT

      AAdd( aData, aRow )

      IF nCount > 0
         nCount--
         IF nCount <= 0
            EXIT
         ENDIF
      ENDIF

      IF nLastRec != 0 .AND. nLastRec == RecNo()
         EXIT
      ENDIF

      SKIP

   ENDDO

   DBGoTo( nRecno )

   DbSelectArea( cOldAlias )

RETURN ::AddArray( cAlias, aData, aNames )

//------------------------------------------------------------------------------
// RealField1=Alias1;...;RealFieldN=AliasN

METHOD SetFieldAliases( cAlias, cFieldAliases ) CLASS frReportManager

   LOCAL oDataset
   LOCAL aRels
   LOCAL cRel, cField
   LOCAL nAt, nFor, nLen

   cAlias := Upper( cAlias )

   nAt := Ascan( ::aDatasets, {|v| Upper( v:cName ) == cAlias } )

   IF nAt == 0
      ::SetError( 301, "Alias " + cAlias + " not found in report datasets" )
      RETURN .F.
   ENDIF

   oDataset := ::aDatasets[ nAt ]

   IF oDataset:IsLoaded()
      ::SetError( 301, "Dataset already loaded. Field aliases must be set before load." )
      RETURN .F.
   ENDIF

   aRels := {}
   cRel  := hb_tokenGet( cFieldAliases, 1, ";" )
   nAt   := 2

   DO WHILE !Empty( cRel )
      AAdd( aRels, { Upper( hb_tokenGet( cRel, 1, "=" ) ), hb_tokenGet( cRel, 2, "=" ) } )
      cRel := hb_tokenGet( cFieldAliases, nAt ++, ";" )
   ENDDO

   nLen := Len( aRels )

   WITH OBJECT oDataset
      FOR nFor := 1 TO nLen
         nAt := AScan( :aFields, {|v| Upper( hb_tokenGet( v, 1, "," ) ) == aRels[ nFor, 1 ] } )
         IF nAt > 0
             cField := Upper( :aFields[ nAt ] )
            :aFields[ nAt ] := StrTran( cField, aRels[ nFor, 1 ], aRels[ nFor, 2 ] )
         ELSE
            ::SetError( 301, "Field " + aRels[ nFor, 1 ] + " not found in dataset." )
            RETURN .F.
         ENDIF
      NEXT
   END WITH

RETURN .T.

//------------------------------------------------------------------------------

METHOD SetUserDataset( cAlias, cFields, bGotop, bSkipPlus1, bSkipMinus1,;
                       bCheckEof, bGetValue ) CLASS frReportManager


   LOCAL aFields, aData, aRow, aNames
   LOCAL xValue
   LOCAL cField, cType
   LOCAL nAt, nLen, nDec, nFor

   aFields := {}
   aNames  := {}
   aData   := {}
   cField  := hb_tokenGet( cFields, 1, ";" )
   nAt     := 2

   Eval( bGotop )

   DO WHILE !Empty( cField )
      xValue := Eval( bGetValue, cField )
      cType  := ValType( xValue )
      SWITCH cType
      CASE "C"
          nLen := Max( Len( xValue ), 250 )
          nDec := 0
          EXIT
      CASE "D"
          nLen := 8
          nDec := 0
          EXIT
      CASE "N"
          nLen := 20
          nDec := 5
          EXIT
      CASE "L"
          nLen := 1
          nDec := 0
          EXIT
      END SWITCH
      AAdd( aFields, cField + "," + cType + "," + ;
                     LTrim( Str( nLen ) ) + "," + LTrim( Str( nDec ) ) )
      AAdd( aNames, cField )
      cField := hb_tokenGet( cFields, nAt ++, ";" )
   ENDDO

   nLen := Len( aFields )

   DO WHILE Eval( bCheckEof )
      aRow := Array( nLen )
      FOR nFor := 1 TO nLen
         aRow[ nFor ] := Eval( bGetValue, aNames[ nFor ] )
      NEXT
      AAdd( aData, aRow )
      Eval( bSkipPlus1 )
   ENDDO

RETURN ::AddArray( cAlias, aData, aFields )

//------------------------------------------------------------------------------

METHOD AddVariable( cCategory, cName, xValue ) CLASS frReportManager

   IF !::AddCategory( cCategory )
      // TODO: Select Category (Exists on FR???)
   ENDIF

RETURN ::Super:AddVariable( cName, xValue )
