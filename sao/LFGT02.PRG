#include "inkey.ch"
#include "hbgtinfo.ch"

/********** * * * * *
ConfigurarAmbiente()
*/
PROCEDURE ConfigurarAmbiente()

INIT Function AppSetup()
WVT_Core()
WVT_Utils()
Request WVT_SETCODEPAGE
Request HB_LANG_PT
Request HB_CODEPAGE_PT850
Request DESCEND
	 
HB_LANGSELECT("PT")
HB_SETCODEPAGE( "PT255" )
	 
*SETMODE(maxrow(),maxcol())
SETMODE(25,84)
	 
WVT_SetCodePage(255)
	
WVT_SetAltF4Close(.F. )

*HB_GtInfo( HB_GTI_FONTNAME, "Lucida Console" )
*HB_GtInfo( HB_GTI_ISFULLSCREEN, .T. )
*HB_GtInfo( HB_GTI_ALTENTER, .T. )


*--- Ativa o mouse --*
SET EVENTMASK TO 159
Set(40 ,159)

WVT_ObjList := {}
WVT_Stack   := {}
nWidth      := Wvt_GetScreenWidth()
 
AtivaVideo()
 
Wvt_SetTitle( " Sistema Livro Fiscal")


RETURN

FUNCTION AtivaVideo()
***************************************
* Ativa modo de janela maximizada
 
_cFONT := "COURIER NEW"
npeso  := 300 //IIF( PFN_BOLD = "S",600,300)
nsize  := 0   //IIF( PFN_BOLD = "S",1,0)
 
DO CASE

   CASE HB_GTINFO(GTI_DESKTOPWIDTH) > 1430 .AND.;
        HB_GTINFO(GTI_DESKTOPHEIGHT) >800
        Wvt_SETFONT(_cFont,31,-18,npeso,2)
 
   CASE HB_GTINFO(GTI_DESKTOPWIDTH) >= 1360 .AND.;
        HB_GTINFO(GTI_DESKTOPHEIGHT) >720
        IF _cFONT = "COURIER NEW"
           WVT_SETFONT(_cFont,28,-17,npeso,2)
        ELSE
           WVT_SETFONT(_cFont,28,-15,npeso,2)
        ENDIF
 
   CASE HB_GTINFO(GTI_DESKTOPWIDTH) > 1270 .AND.;
        HB_GTINFO(GTI_DESKTOPHEIGHT) >720
 
        IF _cFONT = "COURIER NEW"
           WVT_SETFONT(_cFont,29,-16,npeso,2)
        ELSE
           WVT_SETFONT(_cFont,28,-15,npeso,2)
        ENDIF
 
   CASE HB_GTINFO(GTI_DESKTOPWIDTH) > 1270
        IF _cFONT="COURIER NEW"
                   *28*16 CORRETO
           WVT_SETFONT(_cFont,27,-16,npeso,nsize*4)
        ELSE
           WVT_SETFONT(_cFont,27,-16-nsize,npeso,nsize*4)
        ENDIF
 
   CASE HB_GTINFO(GTI_DESKTOPWIDTH) > 1023
 
        IF _cFONT="COURIER NEW"
           WVT_SETFONT(_cFont,28,-13,npeso,2)
        ELSE
           WVT_SETFONT(_cFont,28,-13-nsize,npeso,nsize*4)
        ENDIF
 
   CASE HB_GTINFO(GTI_DESKTOPWIDTH) > 799
        IF "XP"$os()
           WVT_SETFONT(_cFont,22,10-nsize,npeso,nsize*4)
        ELSE
           IF _cFONT="COURIER NEW"
                         * ALTURA ,LARGURA
                WVT_SETFONT(_cFont,20,-10,npeso,nsize*4) //IIF(PFN_BOLD="S",4,0))
           ELSE
                WVT_SETFONT(_cFont,22,-10,npeso,nsize*4) //IIF(PFN_BOLD="S",4,0))
           ENDIF
        ENDIF
        
  OTHERWISE
      WVT_SETFONT(_cFont,17,8-nsize,npeso,IIF(PFN_BOLD="S",4,0))     // negrito

ENDCASE

RETURN .T.

