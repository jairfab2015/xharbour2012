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
#include "lang_en.ch"
//#include "lang_ru.dos.ch"

INIT PROCEDURE Init()

      REQUEST DBFCDX
      REQUEST DBFNTX
      RDDSETDEFAULT( 'DBFCDX' )
      RDDSETDEFAULT( 'DBFNTX' )

   #ifndef  _lang_ru_ch
   #else

      REQUEST HB_CODEPAGE_RU866
      HB_SETCODEPAGE( "RU866" )
      REQUEST HB_LANG_RU866
      HB_LANGSELECT( "RU866" )

   #endif

      SET SCOREBOARD OFF
      SET TALK OFF
      SET DELETED ON

      SETMODE(24,76)
      SETCOLOR("1/15")
      CLS
      SET CURSOR OFF
      SET( _SET_EVENTMASK, INKEY_ALL )

      //---------- windows title and icon for xHarbour -----------
      GTInfo( 26, HB_OEMTOANSI( _cTitle ) )
      GTInfo( 28, "Main_ICO" )

RETURN

EXIT PROCEDURE Exit()

      CLOSE ALL
      SETCOLOR("14/0")
      CLS
      ?
      ? "Close "+ _cTitle
      ?
      ? _cCopyright
      ? _cSaleSite
      ?
      ?
      ? "      Adaptation demo for console of [x]Harbour, Verchenko Andrey, (á) 2008."
      ? "                                                        All rights reserved."
      INKEY(3)
RETURN


PROCEDURE Main

  DoFastDemo()

  QUIT
RETURN
