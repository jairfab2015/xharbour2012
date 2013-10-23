#include "windows.ch"
#include "guilib.ch"
#include "inkey.ch"
#include "hwgui.ch"
#include "common.ch"
#include "hbdll.ch"

***************
FUNCTION MAIN()
***************
PRIVATE fEmail,btnbl,btn2

INIT DIALOG fEmail;
CLIPPER NOEXIT;
TITLE "Envio de E-mail";
AT 0,0 SIZE 800,505;
STYLE DS_CENTER + WS_VISIBLE + WS_CAPTION + WS_SYSMENU

aFiles   := {"eu.txt"}
cSubject := "Assuto do Teste 2"
aQuem    := "gralak@hotmail.com.br"
cMsg     := "Aki vai o Corpo da Mensagem do Email com SSL"
cServerIp:= "smtp.live.com"
cFrom    := "gralak@hotmail.com"
cUser    := "gralak@hotmail.com"
cPass    := "123456"
vPORTSMTP:= 25

aCC      := "jairfab@gmail.com"
aBCC     := "jfab2007@yahoo.com"
lCONF    := .F.
lSSL     := .T.

@ 430,465  BUTTON btnbl CAPTION "&Email" SIZE 100, 28 ;
TOOLTIP "Enviar o Email";
ON CLICK {||CONFIG_MAIL(aFiles,cSubject,aQuem,cMsg,cServerIp,cFrom,cUser,cPass,vPORTSMTP,aCC,aBCC,lCONF,lSSL)};
STYLE WS_TABSTOP

@ 230,465  BUTTON btn2 CAPTION "&Email G" SIZE 100, 28 ;
TOOLTIP "Enviar o Email";
ON CLICK {||envia_email_pos()};
STYLE WS_TABSTOP


ACTIVATE DIALOG fEmail
RETURN nil


**********************************************************************************************************
FUNCTION CONFIG_MAIL(aFiles,cSubject,aQuem,cMsg,cServerIp,cFrom,cUser,cPass,vPORTSMTP,aCC,aBCC,lCONF,lSSL)
**********************************************************************************************************
local lRet := .f.
local oCfg, oError
local lAut  := .t.

  TRY
    oCfg := CREATEOBJECT( "CDO.Configuration" )
      WITH OBJECT oCfg:Fields
           :Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver"             ):Value := cServerIp
           :Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport"         ):Value := vPORTSMTP
           :Item( "http://schemas.microsoft.com/cdo/configuration/sendusing"              ):Value := 2
           :Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate"       ):Value := lAut
           :Item( "http://schemas.microsoft.com/cdo/configuration/smtpusessl"             ):Value := lSSL
           :Item( "http://schemas.microsoft.com/cdo/configuration/sendusername"           ):Value := alltrim(cUser)
           :Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword"           ):Value := alltrim(cPass)
           //:Item( "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"  ):Value := 30
              :Update()
      END WITH
      lRet := .t.
  CATCH oError
    MsgInfo( "NÆo Foi poss¡vel Enviar o e-Mail!"  +HB_OsNewLine()+ ;
             "Error: "     + Transform(oError:GenCode,   nil) + ";" +HB_OsNewLine()+ ;
             "SubC: "      + Transform(oError:SubCode,   nil) + ";" +HB_OsNewLine()+ ;
             "OSCode: "    + Transform(oError:OsCode,    nil) + ";" +HB_OsNewLine()+ ;
             "SubSystem: " + Transform(oError:SubSystem, nil) + ";" +HB_OsNewLine()+ ;
             "Mensaje: "   + oError:Description, "Aten‡Æo" )

  END
  //--> FIM DAS CONFIGURA€OES.
  if lRet
     lRet := Envia_Mail(oCfg,cFrom,aQuem,aFiles,cSubject,cMsg,aCC,aBCC,lCONF)
  endif

Return lRet

********************************************************************************
Function Envia_Mail(oCfg,cFrom,cDest,aFiles,cSubject,cMsg,aCC,aBCC,vEMAIL_CONF)
********************************************************************************
  local aTo := {"jairfab@ig.com.br"}
  local lRet := .f.
  local nEle, oError

  aTo      := { cDest } //--> PARA
  nEle := 1

   for i:=1 to len(aTo)
       TRY
         oMsg := CREATEOBJECT ( "CDO.Message" )
           WITH OBJECT oMsg
                :Configuration = oCfg
                :From = cFrom
                :To = aTo[i]
                :Cc = aCC
                :BCC = aBCC
                :Subject = cSubject
                :TextBody = cMsg
                For x := 1 To Len( aFiles )
                    :AddAttachment(AllTrim(aFiles[x]))
                Next
                IF vEMAIL_CONF=.T.
                   :Fields( "urn:schemas:mailheader:disposition-notification-to" ):Value := cFrom
                   :Fields:update()
                ENDIF
                :Send()
           END WITH
           lRet := .t.
       CATCH oError
           MsgInfo("NÆo Foi Poss¡vel Enviar," +HB_OsNewLine()+;
                         "a Mensagem: "             +HB_OsNewLine()+;
                               cSubject                   +HB_OsNewLine()+;
                               "p/ o eMail: " + aTo[i] +HB_OsNewLine()+;
                   " - Erro: " + + oError:Description , "Aten‡Æo" )
           lRet := .f.
       END
   next

Return lRet


