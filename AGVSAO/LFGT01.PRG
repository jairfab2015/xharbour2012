#include "inkey.ch"
#include "hbgtinfo.ch"

/********** * * * * *
ConfigurarAmbiente()
*/
PROCEDURE ConfigurarAmbiente()
lOCAL	c := SaveScreen( 0, 0, MaxRow(), MaxCol() )
LOCAL aFonte := {}
LOCAL nAlt, nLar
wvw_SetCodePage( 0, 255 )
wvw_SetTitle( 0, "Sistemas Contabilidade" )
*wvw_Size_Ready( .t. )
wvw_EnableMaximize( 0, .t. )
wvw_SetFont( 0 , "Consolas", 24, 11, 100, 4 )
SETMODE( 25, 84 ) // 20,70 
*--- Ativa o mouse --*
SET EVENTMASK TO 159
Set(40 ,159)


FOR i:=1 TO 20
	wvw_SetFont(0,"Consolas",i*2,i,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont(0,"Consolas",nAlt,nLar,100,4)
FOR i:=1 TO 10
	wvw_SetFont(0,"Consolas",nAlt+1,nLar,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont(0,"Consolas",nAlt,nLar,100,4)

FOR i:=1 TO 10
	wvw_SetFont(0,"Consolas",nAlt,nLar+i,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont( 0, "Consolas", nAlt, nLar, 100,4 )
	
wvw_settitle(0, "Sistemas Contabilidade" )
wvw_sbdestroy(0)

IF wvw_sbcreate(0) > 0

   IF WVW_SBAddPart(,"Resolução: " + ALLTRIM(STR(wvw_maxmaxrow())) +'x'+ ALLTRIM(STR(wvw_maxmaxcol())) ) > 0
      WVW_SBSetText(, 1, "Resolução: " + ALLTRIM(STR(wvw_maxmaxrow())) +'x'+ ALLTRIM(STR(wvw_maxmaxcol())) )
   ENDIF

   IF WVW_SBAddPart(,"Usuario: " + GetEnv("USERNAME") ) > 0
      WVW_SBSetText(, 2, "Usuario: " + GetEnv("USERNAME") )
   ENDIF

   IF WVW_SBAddPart(, "99/99/9999" ) > 0
      SET CENTURY ON
      WVW_SBSetText(, 3, DTOC(DATE()) )
      SET CENTURY OFF
   ENDIF

   WVW_SBSetText(, 0, "Sistemas Contabilidade")

ENDIF


wvw_noclose(.T.)
WVW_Maximize()

RETURN



