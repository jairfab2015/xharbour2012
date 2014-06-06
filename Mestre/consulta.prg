#include "minigui.ch"
Memvar cBrowseTitulo, ABROWSEHEADERS, ABROWSECAMPOS, ABROWSEWIDTHS
Memvar NNUMRECCONSULTA, cFormAtivo, cAliasBrowse, cAliasTab, NNUMRECPRI, NORDERANTERIOR, cFiltroBrowse
Memvar CEMPRESA, CBROWSEPESQUISA, aBrowsePesquisa, ABROWSEINDEX, cOperacao, cAliasBrowseAnterior, cFiltro, cOperacaoAnterior

//-----------------------------------------------------------------------------------------------------------------------
procedure Consulta(pAliasConsulta, aTextDataTransfere, cLabelDataTransfere, lSomentePesquisa, nOrderIndex, nIndexador, aTransfExtra)
//-----------------------------------------------------------------------------------------------------------------------
Local i, nOrderAnterior:=(pAliasConsulta)->(IndexOrd())
Local nNumRecAnt:=recno() //Pega registro atual do grid, pois vai perder o foco do registro atual nas proximas linhas. Temos que voltar ao registro correto antes de salvar no edita.prg 
cOperacaoAnterior:=cOperacao
cOperacao:="CON"
cAliasBrowseAnterior:=cAliasBrowse
cAliasBrowse:=pAliasConsulta  //muda temporariamente cAliasBrowse, pois haver� um browse de consulta com banco de dados diferente do browse principal
if !lSomentePesquisa
   DeterminaCampos(pAliasConsulta,"CONSULTA")  //inicia todas as variaveis necess�rias para manipular o banco de dados em pauta
   DEFINE WINDOW FrmConsulta AT 0,0 WIDTH 320 HEIGHT 495 TITLE cBrowseTitulo MODAL NOSIZE NOSYSMENU
      DEFINE BROWSE BwsConsulta
         ROW    10
         COL    10                         
         WIDTH  300
         HEIGHT 330
         VALUE 0
         HEADERS aBrowseHeaders
         FIELDS aBrowseCampos
         WIDTHS aBrowseWidths
         WORKAREA &(pAliasConsulta)
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
         ONDBLCLICK Nil
         ONHEADCLICK &(aBrowseIndex)
      END BROWSE
      DEFINE LABEL LblPesquisa
         ROW    355
         COL    10
         WIDTH  60
         HEIGHT 20
         VALUE "Pesquisa"
         FONTNAME "Arial"
         FONTSIZE 9
      END LABEL
      DEFINE TEXTBOX TxtPesquisa
         ROW    353
         COL    70
         WIDTH  220
         HEIGHT 20
         FONTNAME "Arial"
         FONTSIZE 9
         ONCHANGE PesquisaArquivo()
         UPPERCASE .T.
         TABSTOP .T.
         VALUE ""
      END TEXTBOX
      DEFINE FRAME Frame_1
         ROW    385
         COL    10
         WIDTH  295
         HEIGHT 50
         FONTSIZE 9
         OPAQUE .T.
      END FRAME
      DEFINE BUTTON Button_1
         ROW    395
         COL    30
         WIDTH  100
         HEIGHT 28
         CAPTION "Transferir"
         ACTION TransfereRegistro(aTextDataTransfere, cLabelDataTransfere, lSomentePesquisa, nOrderIndex, nIndexador,aTransfExtra)
         FONTNAME "Arial"
         FONTSIZE 9
         TABSTOP .T.
      END BUTTON
      DEFINE BUTTON Button_2
         ROW    395
         COL    180
         WIDTH  100
         HEIGHT 28
         CAPTION "Sair"
         ACTION TransfereSai(pAliasConsulta, aTextDataTransfere)
         FONTNAME "Arial"
         FONTSIZE 9
         TABSTOP .T.
      END BUTTON
      DEFINE LABEL LblIndice
         ROW    436  
         COL    8
         WIDTH  300
         HEIGHT 60
         VALUE "EXPRESS�O DE BUSCA: "+alltrim(indexkey())
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
         TRANSPARENT .T.
      END LABEL
   END WINDOW
   CENTER WINDOW FrmConsulta
   Dbgotop()
   setproperty("FrmConsulta","BwsConsulta","Value", 1)

   FrmConsulta.BwsConsulta.SetFocus
   FrmConsulta.BwsConsulta.refresh
   ACTIVATE WINDOW FrmConsulta
else
   TransfereRegistro(aTextDataTransfere, cLabelDataTransfere, lSomentePesquisa, nOrderIndex, nIndexador,aTransfExtra)
endif

nNumRecConsulta:=recno() //guarda o registro selecionado na consulta, pois, embora j� tenha transferido para os campos de edicao, vai perder o foco do registro correto quando der o Determinacampos() logo abaixo. Isso foi necess�rio para transferir dados dos componentes ListBoxDuo, uma vez que eles pegam valores de acordo com o BD vigente.

cOperacao:=cOperacaoAnterior

*DeterminaCampos(cAliasTab,if(cOperacao="INC","BROWSE","TAB"))  //volta ao ambiente do DB anterior (seja no Grid ou no Browse, pois a fun��o consulta � chamada tanto pela edi��o do browse quanto do grid).
DeterminaCampos(cAliasTab,"TAB")  //volta ao ambiente do DB anterior (seja no Grid ou no Browse, pois a fun��o consulta � chamada tanto pela edi��o do browse quanto do grid).

(pAliasConsulta)->(dbgoto(nNumRecConsulta)) //volta para o registro selecionado pelo operador na consulta

if !empty(aTransfExtra) //vamos transferir os dados automaticamente para alguns campos, se houver indica��o para isso.
   for i = 1 to len(aTransfExtra) //esta rotina estava junto com a procedure TransfereRegistro(), e estava funcionando bem com os campos texto. Mas para o ListBoxduo, somente ap�s voltar o DeterminaCampos do BD original � que a transferencia funciona.
      if aTransfExtra[i,1]="LISTBOXDUO"
         PreencheListBoxDuo(aTransfExtra[i,2], "CONSULTA")  //indica que � "CONSULTA", pois sen�o os ListboxDuos ficam desabilitados
      else
         setproperty(cFormAtivo, aTransfExtra[i,1],"Value", &(aTransfExtra[i,2])) //aqui s�o transferidos os campos Textos
      endif   
   next i
endif
cAliasBrowse:=cAliasBrowseAnterior

(cAliasBrowse)->(dbgoto(nNumRecPri)) //volta ao registro inicial no Browse. Esta cl�usula � v�lida quando a consulta � chamada pela edi��o do grid, pois normalmente o browse perde o foco inicial. nNumRecPri � definida no m�dulo Mestre.Prg como sendo public.
dbgoto(nNumRecAnt)  //certifica-se que o recno do DB anterior no grid � o mesmo do in�cio, no caso de altera��o ou dele��o do registro no grid. Esta cl�usula deve vir sempre depois de voltar ao registro no browse principal 

Return

//-------------------------------------------------------------------------------------------------------------------------
procedure TransfereRegistro(aTextDataTransfere, cLabelDataTransfere, lSomentePesquisa, nOrderIndex, nIndexador, aTransfExtra)
//-------------------------------------------------------------------------------------------------------------------------
if lSomentePesquisa
   nOrderAnterior:=IndexOrd()
   dbsetorder(nOrderIndex)
   if !dbseek(cEmpresa+GetProperty(cFormAtivo, aTextDataTransfere[1],"value"))
   endif
   dbsetorder(nOrderAnterior)
endif
setproperty(cFormAtivo, "Label_99"+cFormAtivo+strzero(nIndexador,2,0),"Value", &(cLabelDataTransfere))
setproperty(cFormAtivo, aTextDataTransfere[1],"Value", &(aTextDataTransfere[2]))
cAliasBrowse:=cAliasBrowseAnterior //volta alias anterior
if !lSomentePesquisa
   FrmConsulta.Release
   SETFOCUS &(aTextDataTransfere[1]) of &(cFormAtivo)
endif
Return

//-------------------------------------------------------------------------------------------------------
Static Procedure PesquisaArquivo()
//-------------------------------------------------------------------------------------------------------
cFiltro:=alltrim(FrmConsulta.txtPesquisa.value)
dbsetfilter({|| &(aBrowsePesquisa[indexord()])=cFiltro},"&(aBrowsePesquisa[indexord()])=cFiltro")
dbgotop()
setproperty("FrmConsulta","BwsConsulta","Value", 1)
FrmConsulta.BwsConsulta.refresh
dbsetfilter()
return

//-------------------------------------------------------------------------------------------------------------------------
procedure TransfereSai(pAliasConsulta, aTextDataTransfere)
//-------------------------------------------------------------------------------------------------------------------------
nOrderAnterior:=(pAliasConsulta)->(IndexOrd())
(pAliasConsulta)->(dbsetorder(1))
if !(pAliasConsulta)->(dbseek(cEmpresa+GetProperty(cFormAtivo, aTextDataTransfere[1],"value")))
endif
(pAliasConsulta)->(dbsetorder(nOrderAnterior))
cAliasBrowse:=cAliasBrowseAnterior //volta alias anterior
frmconsulta.release
return

//eof
