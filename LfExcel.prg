*--------------------------------------------------------------------*
* Geracao dos arquivos eSocial                                       *
* Este progeto pode gerar 48 arquivos, atualmente estou invocando    *
* a classe para gerar apenas um arquivo, mas pode ser gerados individual   
*--------------------------------------------------------------------*
#define CRLF CHR(13)+CHR(10)
#command DEFAULT <param> := <val> [, <paramn> := <valn> ];
         => ;
         <param> := IIF(<param> = NIL, <val>, <param> ) ;
         [; <paramn> := IIF(<paramn> = NIL, <valn>, <paramn> ) ]

#include "hbclass.ch"
#include "fileio.ch"
#include "common.ch"
#Translate StoD(<p>) => CTOD(RIGHT(<p>, 2) + "/" + SUBSTR(<p>, 5, 2) + "/" + LEFT(<p>, 4))

*function Main()
FUNCTION GerArq002()
**  exemplo de utilizacao ***

EMPRESAX  := "SOFTLOGIC"

cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 
IF RIGHT(cPasta,1) != HB_OSpathseparator()
   cPasta += HB_OSpathseparator()
ENDIF

*--- Geracao do arquivo ---*
oSocial:= eSocial()
*--- Cadastro da empresa ---* 
oSocial:NomeArq:="JAIR.XLS"

oSocial:Open()

oSocial:Execute( )  // GRAVA DETALHES DO RELATORIO 
oSocial:Execute( )

cPasta+=oSocial:NomeArq
*--- Finaliza a geracao do arquivo ---*
oSocial:Close()   // Finaliza 

msgstop(cPasta,"Aviso Nome do arquivo para efeito de teste..")

return nil 
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*  Geracao de arquivo E-SOCIAL                                                 *
*                                                                              *
* -----------------------------------------------------------------------------*
CLASS eSocial

   DATA cLine                INIT "" PROTECTED
   DATA nSeqReg              INIT 2  PROTECTED 
   DATA cFillTrailer         INIT "" PROTECTED
   DATA DtEmis               INIT DATE()
   DATA DtVenc               INIT DATE()
   DATA cData                
   DATA NomeArq              INIT "JAIR.XLS"
   DATA Destino              INIT ""
   DATA nHandle              INIT ""
   
   DATA vTitulo              INIT "JAIR  MMM"
   DATA DTLAN                INIT DATE()

   METHOD New() CONSTRUCTOR
   METHOD Execute( )
   METHOD OPEN()
   
   METHOD Line()
   METHOD CLOSE()

ENDCLASS
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Execute( ) CLASS eSocial
Conta_Cre := '12222'
RefCta := '125466-222'
TxtTxt :="CONTA "
Nudoc  := "12542"
valor  := 1350.42

*--- Inicializa as variaves ---*
*::aS1100 := Hash()                         //Registro S-1100 - eSocial Mensal - Abertura 
*::aS1100["indSubstPatronal"]   := "1"    //24 E N 1-1 001 - Indicativo de Substituição:
*::aS1100["percAliqPatronal"]   := "0"    //25 E N 1-1 005 2 Informar ZERO se {indSubstPatronal} = 1. Caso contrário,
               xdata := LEFT(DTOC(DATE()),5)
::cLine := '<tr>'
::Line()
::cLine := '<td ALIGN="LEFT"  valign="top">'  +xData                                   + '</td>'
::Line()
::cLine := '<td ALIGN="LEFT"  valign="top">'  +conta_Cre                               + '</td>'
::Line()
::cLine := '<td ALIGN="LEFT"  valign="top">'  +RefCta                                  + '</td>'
::Line()
::cLine := '<td ALIGN="LEFT"  valign="top">'  +TxtTxt                                  + '</td>'
::Line()
::cLine := '<td ALIGN="LEFT"  valign="top">'  +Nudoc                                   +' </td>'
::Line()
::cLine := '<td ALIGN="RIGHT" valign="top"> </td>'
::Line()
::cLine := '<td ALIGN="RIGHT" valign="top">'  +TRANSFORM(valor,"@E 99,999,999,999.99") + '</td>'
::Line()
::cLine := '</tr>'
::Line()


RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD CLOSE() CLASS eSocial
::cLine := "</table>"
::Line()
::cLine := "</body>"
::Line()
::cLine := "</html>"
::Line()
FCLOSE(::nHandle)
RETURN Self
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Grava a linha para arquivo txt                                               *
* -----------------------------------------------------------------------------*
METHOD Line() CLASS eSocial

*::cLine := UPPER(::cLine)
FWRITE(::nHandle,::cLine+CRLF)
::cLine := ""

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*
* -----------------------------------------------------------------------------*
METHOD new() CLASS eSocial

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
* Criacao do arquivo txt                                                       *
* -----------------------------------------------------------------------------*
METHOD OPEN() CLASS eSocial

LOCAL NomeArquivo:=""

LOCAL nI := 1 , cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 

::cData := STRZERO(DAY(::DtEmis),2)+STRZERO(MONTH(::DtEmis),2)+RIGHT(STR(YEAR(::DtEmis)),2)

*--- Nome do arquivo ---*
IF EMPTY(::NomeArq)
   ::NomeArq := "ES"+RIGHT(STR(YEAR(::DtEmis)),2)+STRZERO(MONTH(::DtEmis),2)+STRZERO(DAY(::DtEmis),2)+".XML"
ENDIF 


IF EMPTY(::Destino)
   cPasta := ALLTRIM(cPasta)
   IF RIGHT(cPasta,1) != HB_OSpathseparator()
      cPasta += HB_OSpathseparator()
   ENDIF

   IF !IsDirectory(cPASTA)
      MAKEDIR(ALLTRIM(cPASTA))
   ENDIF
   ::Destino := cPASTA

   IF !IsDirectory(cPASTA)
      MAKEDIR(ALLTRIM(cPASTA))
   ENDIF
ELSE 

   *--- Verifica se tem a pasta, se nao tem cria ---*
   IF !IsDirectory(::Destino)
      MAKEDIR(ALLTRIM(::Destino))
   ENDIF
   
ENDIF


*--- Ja tem o arquivo, neste caso apaga para cria um novo arquivo ---*
NomeArquivo := ::Destino+::NomeArq

IF FILE(NomeArquivo)
   FERASE(NomeArquivo)
ENDIF 

*--- Cria o arquivo txt ---*
::nHandle := FCREATE(::Destino+::NomeArq,FC_NORMAL)


::cLine := ""
IF ::nHandle < 0  // Header

ELSE 

   ::cLine := '<html>'
   ::Line()
   ::cLine := '<body>'
   ::Line()
   ::cLine := '<table border="0">'
   ::Line()
   ::vTitulo := "DIÁRIO GERAL"
   ::vTitulo += "    -    "+UPPER(ALLTRIM(Ext_Mes(MONTH(::dtlan))))+"/"+STR(YEAR(::dtlan),4)
   ::cLine :=  '<caption><H3><b>'+::vTitulo+'</b></H3></caption>'
   ::Line()
   ::cLine :=   '<tr>'
   ::Line()
//   ::cLine :=  '<td align="LEFT" colspan="9"><font color="#0000FF"><h5><b>'+ALLTRIM(EMPRESAX)+' - '+PARAM2->NOME+'</b></td>'
   ::cLine :=  '<td align="LEFT" colspan="9"><font color="#0000FF"><h5><b>'+ALLTRIM(EMPRESAX)+'</b></td>'
   ::Line()
   ::cLine :=  '</tr>'
   ::Line()
   ::cLine :=  '<tr> </tr>'
   ::Line()
   ::cLine := '<tr>'
   ::Line()
   ::cLine := '<th ALIGN="LEFT">DIA</th>'
   ::Line()
   ::cLine := '<th ALIGN="LEFT">CONTA</th>'
   ::Line()
   ::cLine := '<th ALIGN="LEFT">REFERÊNCIA</th>'
   ::Line()
   ::cLine := '<th ALIGN="LEFT">HISTORICO</th>'
   ::Line()
   ::cLine := '<th ALIGN="LEFT">NUDOC</th>'
   ::Line()
   ::cLine := '<th align="RIGHT">DÉBITO</th>'
   ::Line()
   ::cLine := '<th align="RIGHT">CRÉDITO</th>'
   ::Line()
   ::cLine := '</tr>'
   ::Line()

ENDIF

RETURN ::nHandle
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
FUNCTION FormatData(dData)

cResultado := SUBSTR(DTOS(dData),7,2)+"/"+SUBSTR(DTOS(dData),5,2)+"/"+SUBSTR(DTOS(dData),1,4)

RETURN(cResultado)

*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
FUNCTION fDataDMA(dData)

cResultado := SUBSTR(DTOS(dData),7,2)+SUBSTR(DTOS(dData),5,2)+SUBSTR(DTOS(dData),1,4)

RETURN(cResultado)


