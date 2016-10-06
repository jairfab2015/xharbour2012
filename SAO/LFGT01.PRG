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
wvw_SetTitle( 0, " Sistema Contabilidade" )

wvw_EnableMaximize( 0, .t. )
WVW_SetIcon( ,1001)   

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
	
wvw_settitle(0, " Sistema Contabilidade" )
wvw_sbdestroy(0)


wvw_noclose(.T.)
WVW_Maximize()

RETURN



