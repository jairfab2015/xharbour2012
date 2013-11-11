#include "hwgui.ch"
#include "inkeyw.ch"
#define CRLF          CHR(13)+CHR(10)  // PULO DE LINHA
*----------------------------------------------------------------------------*
*  Programa.: RhSefip8.Prg     Antigo RhSefip1.prg                           *
*  Data.....: 22.Dez.2005                                                    *
*  Analise..: Tony                                                           *
*  Objetivo.: Gera os registros no dbf, com informacoes para Cef e Inss      *
*----------------------------------------------------------------------------*
FUNCTION GeraSped()
LOCAL aMsg := { "Digite o mês de competência."                                           ,;
                "Digite o ano de competência."                                           ,;
                "Selecione o Tipo de arquivo e pressione <ENTER>"                        ,}
                 
PRIVATE aItens := { "1 Cadastro de funcionario  " ,;
                    "2 Eventos                  " ,;
                    "3 Pessoa Física Urbana     " ,;
                    "9 Todos                    "  }

PRIVATE HTAM := 600, VTAM := 200
PRIVATE lOk := .F.
PRIVATE oButton1, oButton2,  oLine1 ,  oLine2 
PRIVATE oMsgRod, cMsgRod := "", lMudou := .F., lFechaDireto := .F.
// COMBOS
PRIVATE nCombo     := 1, oCombo
PRIVATE oMesComp, vMesComp := 0, oAnoComp, vAnoComp := 0 ,vCategoria :=""
PRIVATE vDtCompI := CTOD(" / / "), vDtCompF := CTOD(" / / ")

*MSGSTOP('Em desenvolvimento.',"Aviso")
*RETURN .T.


*-- Checa se tem empresa selecionada --*
IF EmpresaX = SPACE(08)
   RhEmpres()
   IF EmpresaX = SPACE(08)
      RETURN .T.
   ENDIF
ENDIF


GerArqEsocial()

return .t. 


Save_Dbf()
SELECT Evento
Rest_Dbf()

INIT DIALOG oDlg TITLE " E-Social  SPED Folha " ICON oIcon ;
     AT 40,167 SIZE HTAM,VTAM CLIPPER NOEXIT  ;
     STYLE WS_POPUP+WS_CAPTION+DS_CENTER+WS_SYSMENU 
SetColorinFocus(.T.)

@ 010, 020  SAY  "Mês/Ano"           SIZE 190,20  STYLE SS_RIGHT
@ 010, 050  SAY  "Tipo de arquivo"   SIZE 190,20  STYLE SS_RIGHT

@ 240,018 GET oMesComp   VAR vMesComp     SIZE 30,24   PICTURE '99' ; 
          TOOLTIP "" ; 
          FONT oFontNorm ;  
          STYLE SS_RIGHT ;
          WHEN {|| FMsgRod1(aMsg[1]),.T.}              ;
          VALID{|| vMesComp > 0 .AND. vMesComp < 14    }
          
@ 275,020 SAY "/"  SIZE 15,20 STYLE SS_CENTER
@ 295,018 GET oAnoComp   VAR vAnoComp     SIZE 50,24   PICTURE '9999' ; 
          TOOLTIP "" ; 
          FONT oFontNorm ;  
          STYLE SS_RIGHT ;
          WHEN {|| FMsgRod1(aMsg[2]),.T.} ;
          VALID{|| fValSPED("vAnoComp") .and. lOk }
                    
          
@ 240,048 GET COMBOBOX oCombo  VAR nCombo ITEMS aItens SIZE 300,150 ;
          FONT oFontNorm ;
          WHEN  {|| FMsgRod1(aMsg[3]),.T.}      ;
          VALID {|| fValSPED("nCombo") .AND. lOk  }    
          

@ 0         , VTAM-70  LINE oLine1      LENGTH HTAM
@ HTAM-195  , VTAM-65  BUTTON oButton1  CAPTION "&Gera"     ON CLICK {||GerArqEsocial()} SIZE 90,30  STYLE WS_TABSTOP
@ HTAM-095  , VTAM-65  BUTTON oButton2  CAPTION "Cancela&r" ON CLICK {||EndDialog()}     SIZE 90,30  STYLE WS_TABSTOP
@ 0         , VTAM-30  LINE oLine2      LENGTH HTAM
@ 0         , VTAM-25  SAY oMsgRod      CAPTION cMsgRod       SIZE HTAM,20  COLOR x_DARKBLUE


ACTIVATE DIALOG oDlg 

fClear()

RETURN oDlg:lresult
*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*
*                                                                             *
*                                                                             *
*                                                                             *
*                                                                             *
*-----------------------------------------------------------------------------*
FUNCTION fValSPED(vCampo)

lOk := .T.
DO CASE 
   CASE vCampo == "vAnoComp"
   
        IF EMPTY(vAnoComp)
           lOk := .F.
        ELSE   
           IF vMesComp=13
              vDtCompI := CTOD("01/"+STR(vMesComp-1,2)+"/"+SUBSTR(STR(vAnoComp,4),3,2))
              vDtCompF := fUltDia(vDtCompI)
              vAnoMes  := IF( vMesComp=13, STR(vAnoComp,4)+STRZERO(vMesComp-1,2), STR(vAnoComp,4)+STRZERO(vMesComp,2) )
           ELSE
              vDtCompI := CTOD("01/"+STR(vMesComp,2)+"/"+SUBSTR(STR(vAnoComp,4),3,2))
              vDtCompF := fUltDia(vDtCompI)
              vAnoMes  := IF( vMesComp=13, STR(vAnoComp,4)+STRZERO(vMesComp-1,2), STR(vAnoComp,4)+STRZERO(vMesComp,2) )
           ENDIF
        ENDIF   

           
   CASE vCampo == "nCombo"
        vCategoria := SUBSTR(aItens[nCombo],1,1)


ENDCASE

RETURN lOk
*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*
*                                                                             *
*                                                                             *
*                                                                             *
*                                                                             *
*-----------------------------------------------------------------------------*
STATIC FUNCTION GerArqEsocial()
** faz O PROCESSAMENTO E GERACAO DO ARQUIVO AQUI ****
LOCAL oSocial

cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 
IF RIGHT(cPasta,1) != HB_OSpathseparator()
   cPasta += HB_OSpathseparator()
ENDIF


*--- Geracao do arquivo ---*
oSocial:= eSocial()
oSocial:Empresa := SUBSTR( EMPRESA->NOME, 1, 30 )
oSocial:DtVenc  := DATE()
oSocial:Open()
oSocial:Execute( )   //:add()



cPasta+=oSocial:NomeArq   // temporario para conferir se gerou o arquivo 
*--- Finaliza a geracao do arquivo ---*
oSocial:Close()   // Finaliza 



*--- abre o arquivo para o que foi gravado e mostra como mensagem ---*
*xTexto := MEMOREAD(cPasta)
*MSGSTOP(xTexto,cPasta )








fclear()
EndDialog()
RETURN .T.
*----------------------------------------------------------------------------*

