#include "minigui.ch"

DECLARE WINDOW Principe
DECLARE WINDOW BrowseWindow
DECLARE WINDOW Seleciona

Memvar aColor, aColors, cFormAtivo, lSohGeral, cAlunoAtual, cChamadaAtual, nQtNotaAzul, nQtNotaVerm, c_Port, c_Path, c_Addr, c_STR_Con, c_Nome
Memvar bColumnColor1, bColumnColor2, bColumnColor3, bColumnColor4, bColumnColor5, bColumnColor6, nNumrecPri, cSetorCodigo, nContaAlunosImporta
Memvar bColumnColor7, bColumnColor8, bColumnColor9, bColumnColor10, bColumnColor11, bColumnColor12, cAlunoCodigo, nContaAlunosTurma
Memvar bColumnColor13, bColumnColor14, bColumnColor15, bColumnColor16, bColumnColor17, bColumnColor18, cSetorDescri, nContaNotasImportadas, nContaCapabime
Memvar bColumnColor19, bColumnColor20, bColumnColor21, bColumnColor22, bColumnColor23, bColumnColor24, lNaoExiste, aDbfNomes
Memvar bColumnColor25, bColumnColor26, bColumnColor27, bColumnColor28, bColumnColor29, bColumnColor30, nComboItemCount
Memvar aLabelsEdit, aCamposEdit, aCamposTip, aExecutaAntesExclusao, cFuncionarioMaster, cFormAnterior, arq, nCampo, nTamArq
Memvar aBrowseCampos, aBrowseHeaders, aBrowseWidths, aBrowseIndex, aExecutaAposExclusao, cFiltroBrowse
Memvar aGridCampos, aGridHeaders, aGridWidths, aGridColValid, aGridColWhen, lAlteraGrid, lAlteraCtrls, cAliasTab, cCaracter, cCampo
Memvar aGridPesquisa, bgridBotoes, cBrowseTitulo, cBrowsePesquisa, aBrowsePesquisa, aList, aTab, aExecutaIncAlt, bExecutaAntesIncAlt
Memvar aBotoesFuncoes, cEmpresa, aGridColumnControl, pCampo1, cCodFuncionario, tInicial, nGridColumnLock
Memvar cCodCargo, aRelatTab, aRelatBrowse, cAliasBrowse, cAnoLetivoAtual, cBimestreAtual, nTabPage, nLinha, i, c_PastaFotos
Memvar CNOTA5BIM, CNOTA4BIM, CNOTA3BIM, CNOTA2BIM, CNOTA1BIM, NTOTALBIMPROFCLASSE, NTOTALBIMNOTACLASSE, nPrimeiroEspaco, nSegundoEspaco, nTerceiroEspaco
Memvar NTOTALANUALPROFALUNO, NTOTALANUALNOTAALUNO, NTOTALANUALPROFCLASSE, NTOTALANUALNOTACLASSE, cRegNumeroBimAtual
Memvar NTOTALANUALALUNOFALTAS, CFALTAS5BIM, CFALTAS4BIM, CFALTAS3BIM, CFALTAS2BIM, CFALTAS1BIM, dDtLimBimAtual, bColor, cPrimeiroNome, cSegundoNome, cTerceiroNome
Memvar NCONTAPROFATRIBUICAO, NTOTALBIMPROF, NTOTALBIMALUNONOTAS, dDtIniBimAtual, cConsitemMemoField, cAnoMostraNotas, nTurmasRecAnter
Memvar lMencaoA, lMencaoAA, lMencaoB, lMencaoC, lMencaoD, lMencaoE, lMencaoF, lMencaoG, lMencaoH, lMencaoI, lMencaoJ, lMencaoK, lMencaoL
Memvar aDbfStru01, aDbfStru02, aDbfStru03, aDbfStru04, aDbfStru05, aDbfStru06, aDbfStru07, aDbfStru08, aDbfStru09, aDbfStru10, aDbfStru11, aDbfStru12
Memvar aDbfStru13, aDbfStru14, aDbfStru15, aDbfStru16, aDbfStru17, aDbfStru18, aDbfStru19, aDbfStru20, aDbfStru21, aDbfStru22, aDbfStru23, aDbfStru24
Memvar aDbfStru25, aDbfStru26, aDbfStru27, aDbfStru28
//---------------------------------------------------------------------------
Procedure Reindexa()  //abre os arquivos para reindexação (se já não estiverem abertos por outra instância do programa)
//---------------------------------------------------------------------------
msginfo("Reindexando tabelas. Tecle ENTER e aguarde nova janela...")

Set StatusBar ProgressItem Of Principe Range To 0, 27
dbcloseall()

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"GABARITO","GABARITO",.F.,.F.)
INDEX ON GABARITO->GAB_EMPR+GABARITO->GAB_AVAL                                      TAG TAG1 TO &(c_STR_Con+"GABARITO.CDX")
INDEX ON GABARITO->GAB_EMPR+GABARITO->GAB_ANO+GABARITO->GAB_BIME+GABARITO->GAB_ALUN TAG TAG2 TO &(c_STR_Con+"GABARITO.CDX")
Set StatusBar ProgressItem Of Principe Position To 1

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"MENCOES","MENCOES",.F.,.F.)
INDEX ON MENCOES->MEN_EMPRE+MENCOES->MEN_CODIGO                  TAG TAG1 TO &(c_STR_Con+"MENCOES.CDX")
INDEX ON MENCOES->MEN_EMPRE+MENCOES->MEN_TIPO+MENCOES->MEN_LETRA TAG TAG2 TO &(c_STR_Con+"MENCOES.CDX")
Set StatusBar ProgressItem Of Principe Position To 2

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CAPABIME","CAPABIME",.F.,.F.)
INDEX ON CAPABIME->CAP_EMPR+CAPABIME->CAP_CODIGO                                                                             TAG TAG1 TO &(c_STR_Con+"CAPABIME.CDX")
INDEX ON CAPABIME->CAP_EMPR+CAPABIME->CAP_SETOR+CAPABIME->CAP_FUNCIO+CAPABIME->CAP_CARGO+CAPABIME->CAP_ANO+CAPABIME->CAP_BIM TAG TAG2 TO &(c_STR_Con+"CAPABIME.CDX")
Set StatusBar ProgressItem Of Principe Position To 3

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"RESULTAV","RESULTAV",.F.,.F.)
INDEX ON RESULTAV->RES_EMPRES+RESULTAV->RES_CODIGO                     TAG TAG1 TO &(c_STR_Con+"RESULTAV.CDX")
INDEX ON RESULTAV->RES_EMPRES+RESULTAV->RES_AVALIA+RESULTAV->RES_ALUNO TAG TAG2 TO &(c_STR_Con+"RESULTAV.CDX")
Set StatusBar ProgressItem Of Principe Position To 4

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"AVALIAR","AVALIAR",.F.,.F.)
INDEX ON AVALIAR->AV_EMPRE+AVALIAR->AV_ANO+AVALIAR->AV_BIM+AVALIAR->AV_CODIGO TAG TAG1 TO &(c_STR_Con+"AVALIAR.CDX")
Set StatusBar ProgressItem Of Principe Position To 5

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"AVALQUES","AVALQUES",.F.,.F.)
INDEX ON AVALQUES->AVQ_EMPRE+AVALQUES->AVQ_CODIGO                     TAG TAG1 TO &(c_STR_Con+"AVALQUES.CDX")
INDEX ON AVALQUES->AVQ_EMPRE+AVALQUES->AVQ_AVALIA+AVALQUES->AVQ_ORDEM TAG TAG2 TO &(c_STR_Con+"AVALQUES.CDX")
Set StatusBar ProgressItem Of Principe Position To 6

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"OCORREAL","OCORREAL",.F.,.F.)
INDEX ON OCORREAL->OCCAL_EMPR+OCORREAL->OCCAL_CODI TAG TAG1 TO &(c_STR_Con+"OCORREAL.CDX")
INDEX ON OCORREAL->OCCAL_EMPR+OCORREAL->OCCAL_ALUN TAG TAG2 TO &(c_STR_Con+"OCORREAL.CDX")
Set StatusBar ProgressItem Of Principe Position To 7

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"ANOLETIV","ANOLETIV",.F.,.F.)
INDEX ON ANOLETIV->ANO_EMPRES+ANOLETIV->ANO_CODIGO TAG TAG1 TO &(c_STR_Con+"ANOLETIV.CDX")
INDEX ON ANOLETIV->ANO_EMPRES+ANOLETIV->ANO_ANO    TAG TAG2 TO &(c_STR_Con+"ANOLETIV.CDX")
Set StatusBar ProgressItem Of Principe Position To 8

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADTELA","CADTELA",.F.,.F.)
INDEX ON CADTELA->TELA_EMPR+CADTELA->TELA_NOME TAG TAG1 TO &(c_STR_Con+"CADTELA.CDX")
INDEX ON CADTELA->TELA_EMPR+CADTELA->TELA_CODI TAG TAG2 TO &(c_STR_Con+"CADTELA.CDX")
Set StatusBar ProgressItem Of Principe Position To 9

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADITTLA","CADITTLA",.F.,.F.)
INDEX ON CADITTLA->ITTL_EMPR+CADITTLA->ITTL_CODI TAG TAG1 TO &(c_STR_Con+"CADITTLA.CDX")
INDEX ON CADITTLA->ITTL_EMPR+CADITTLA->ITTL_TELA TAG TAG2 TO &(c_STR_Con+"CADITTLA.CDX")
Set StatusBar ProgressItem Of Principe Position To 10

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADCAMPO","CADCAMPO",.F.,.F.)
INDEX ON CADCAMPO->CAMP_EMPRE+CADCAMPO->CAMP_CODI   TAG TAG1 TO &(c_STR_Con+"CADCAMPO.CDX")
INDEX ON CADCAMPO->CAMP_EMPRE+CADCAMPO->CAMP_BDADO  TAG TAG2 TO &(c_STR_Con+"CADCAMPO.CDX")
Set StatusBar ProgressItem Of Principe Position To 11

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADBDADO","CADBDADO",.F.,.F.)
INDEX ON CADBDADO->BD_EMPRESA+CADBDADO->BD_NOME   TAG TAG1 TO &(c_STR_Con+"CADBDADO.CDX")
INDEX ON CADBDADO->BD_EMPRESA+CADBDADO->BD_CODIGO TAG TAG2 TO &(c_STR_Con+"CADBDADO.CDX")
Set StatusBar ProgressItem Of Principe Position To 12

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADINDEX","CADINDEX",.F.,.F.)
INDEX ON CADINDEX->IDX_EMPRES+CADINDEX->IDX_NOME    TAG TAG1 TO &(c_STR_Con+"CADINDEX.CDX")
INDEX ON CADINDEX->IDX_EMPRES+CADINDEX->IDX_CODIGO  TAG TAG2 TO &(c_STR_Con+"CADINDEX.CDX")
Set StatusBar ProgressItem Of Principe Position To 13

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"ALUNOS","ALUNOS",.F.,.F.)
INDEX ON ALUNOS->ALU_EMPRE+ALUNOS->ALU_CODIGO TAG TAG1 TO &(c_STR_Con+"ALUNOS.CDX") 
INDEX ON ALUNOS->ALU_EMPRE+ALUNOS->ALU_NOME   TAG TAG2 TO &(c_STR_Con+"ALUNOS.CDX")
INDEX ON ALUNOS->ALU_EMPRE+ALUNOS->ALU_SETOR  TAG TAG3 TO &(c_STR_Con+"ALUNOS.CDX")
Set StatusBar ProgressItem Of Principe Position To 14

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"SETOR","SETOR",.F.,.F.)
INDEX ON SETOR->SET_EMPRE+SETOR->SET_CODIGO                  TAG TAG1 TO &(c_STR_Con+"SETOR.CDX")
INDEX ON SETOR->SET_EMPRE+SETOR->SET_DESCRI+SETOR->SET_ANO   TAG TAG2 TO &(c_STR_Con+"SETOR.CDX")                      
INDEX ON SETOR->SET_EMPRE+SETOR->SET_PRODUT                  TAG TAG3 TO &(c_STR_Con+"SETOR.CDX")
Set StatusBar ProgressItem Of Principe Position To 15

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"ATRIBUIR","ATRIBUIR",.F.,.F.)
INDEX ON ATRIBUIR->ATR_EMPRE+ATRIBUIR->ATR_CODIGO                    TAG TAG1 TO &(c_STR_Con+"ATRIBUIR.CDX")
INDEX ON ATRIBUIR->ATR_EMPRE+ATRIBUIR->ATR_SETOR+ATRIBUIR->ATR_ORDEM TAG TAG2 TO &(c_STR_Con+"ATRIBUIR.CDX")
INDEX ON ATRIBUIR->ATR_EMPRE+ATRIBUIR->ATR_SETOR+ATRIBUIR->ATR_FUNCIO+ATRIBUIR->ATR_CARGO TAG TAG3 TO &(c_STR_Con+"ATRIBUIR.CDX")
INDEX ON ATRIBUIR->ATR_EMPRE+ATRIBUIR->ATR_FUNCIO                    TAG TAG4 TO &(c_STR_Con+"ATRIBUIR.CDX")
Set StatusBar ProgressItem Of Principe Position To 16

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"TURMAS","TURMAS",.F.,.F.)
INDEX ON TURMAS->TUR_EMPRE+TURMAS->TUR_CODIGO                                                     TAG TAG1 TO &(c_STR_Con+"TURMAS.CDX")
INDEX ON TURMAS->TUR_EMPRE+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_CHAMAD+TURMAS->TUR_ALUNO TAG TAG2 TO &(c_STR_Con+"TURMAS.CDX")
INDEX ON TURMAS->TUR_EMPRE+TURMAS->TUR_ALUNO+TURMAS->TUR_CHAMAD+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_STATUS TAG TAG3 TO &(c_STR_Con+"TURMAS.CDX")
INDEX ON TURMAS->TUR_EMPRE+TURMAS->TUR_ALUNO+TURMAS->TUR_ANO+TURMAS->TUR_STATUS                   TAG TAG4 TO &(c_STR_Con+"TURMAS.CDX")
Set StatusBar ProgressItem Of Principe Position To 17

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"NOTAS","NOTAS",.F.,.F.)
INDEX ON NOTAS->NOT_EMPRE+NOTAS->NOT_SETOR+NOTAS->NOT_FUNCIO+NOTAS->NOT_CARGO+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_CHAMAD+NOTAS->NOT_ALUNO TAG TAG1 TO &(c_STR_Con+"NOTAS.CDX")
INDEX ON NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR                                                                       TAG TAG2 TO &(c_STR_Con+"NOTAS.CDX")
INDEX ON NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_SETOR                                                                                      TAG TAG3 TO &(c_STR_Con+"NOTAS.CDX")
INDEX ON NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_ALUNO+NOTAS->NOT_CARGO+NOTAS->NOT_CHAMAD                                    TAG TAG4 TO &(c_STR_Con+"NOTAS.CDX")
INDEX ON NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR+NOTAS->NOT_ALUNO+NOTAS->NOT_CHAMAD                                    TAG TAG5 TO &(c_STR_Con+"NOTAS.CDX")
Set StatusBar ProgressItem Of Principe Position To 18

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"EMPRESA","EMPRESA",.F.,.F.)
INDEX ON EMPRESA->EMP_CODIGO TAG TAG1 TO &(c_STR_Con+"EMPRESA.CDX")
INDEX ON EMPRESA->EMP_NOME   TAG TAG2 TO &(c_STR_Con+"EMPRESA.CDX")
Set StatusBar ProgressItem Of Principe Position To 19

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CARGOS","CARGOS",.F.,.F.)
INDEX ON CARGOS->CAR_EMPRE+CARGOS->CAR_CODIGO TAG TAG1 TO &(c_STR_Con+"CARGOS.CDX")
INDEX ON CARGOS->CAR_EMPRE+CARGOS->CAR_DESCRI TAG TAG2 TO &(c_STR_Con+"CARGOS.CDX")
dbsetorder(2)
Set StatusBar ProgressItem Of Principe Position To 20

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"FUNCIONA","FUNCIONA",.F.,.F.)
INDEX ON FUNCIONA->FUN_EMPRE+FUNCIONA->FUN_CODIGO TAG TAG1 TO &(c_STR_Con+"FUNCIONA.CDX")
INDEX ON FUNCIONA->FUN_EMPRE+FUNCIONA->FUN_NOME   TAG TAG2 TO &(c_STR_Con+"FUNCIONA.CDX")
Set StatusBar ProgressItem Of Principe Position To 21

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CONSELHO","CONSELHO",.F.,.F.)
INDEX ON CONSELHO->CON_EMPRE+CONSELHO->CON_CODIGO                                    TAG TAG1 TO &(c_STR_Con+"CONSELHO.CDX")
INDEX ON CONSELHO->CON_EMPRE+CONSELHO->CON_ANO+CONSELHO->CON_SETOR+CONSELHO->CON_BIM TAG TAG2 TO &(c_STR_Con+"CONSELHO.CDX")
INDEX ON CONSELHO->CON_EMPRE+CONSELHO->CON_BIM                                       TAG TAG3 TO &(c_STR_Con+"CONSELHO.CDX")
INDEX ON CONSELHO->CON_EMPRE+CONSELHO->CON_SETOR                                     TAG TAG4 TO &(c_STR_Con+"CONSELHO.CDX")
Set StatusBar ProgressItem Of Principe Position To 22

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CONSITEM","CONSITEM",.F.,.F.)
INDEX ON CONSITEM->CIT_EMPRE+CONSITEM->CIT_CODIGO+CONSITEM->CIT_ALUNO                      TAG TAG1 TO &(c_STR_Con+"CONSITEM.CDX")
INDEX ON CONSITEM->CIT_EMPRE+CONSITEM->CIT_CONSE+CONSITEM->CIT_CHAMAD+CONSITEM->CIT_ALUNO  TAG TAG2 TO &(c_STR_Con+"CONSITEM.CDX")
Set StatusBar ProgressItem Of Principe Position To 23

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"PRODUTOS","PRODUTOS",.F.,.F.)
INDEX ON PRODUTOS->PRO_EMPRE+PRODUTOS->PRO_CODIGO TAG TAG1 TO &(c_STR_Con+"PRODUTOS.CDX")
INDEX ON PRODUTOS->PRO_EMPRE+PRODUTOS->PRO_DESCRI TAG TAG2 TO &(c_STR_Con+"PRODUTOS.CDX")
Set StatusBar ProgressItem Of Principe Position To 24

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CONTRATO","CONTRATO",.F.,.F.)
INDEX ON CONTRATO->CONTR_EMPR+CONTRATO->CONTR_CODI TAG TAG1 TO &(c_STR_Con+"CONTRATO.CDX")
INDEX ON CONTRATO->CONTR_EMPR+CONTRATO->CONTR_NUME TAG TAG2 TO &(c_STR_Con+"CONTRATO.CDX")
INDEX ON CONTRATO->CONTR_EMPR+CONTRATO->CONTR_ALU  TAG TAG3 TO &(c_STR_Con+"CONTRATO.CDX")
Set StatusBar ProgressItem Of Principe Position To 25

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"HORARIOS","HORARIOS",.F.,.F.)
INDEX ON HORARIOS->HOR_EMPRE+HORARIOS->HOR_CODIGO TAG TAG1 TO &(c_STR_Con+"HORARIOS.CDX")
Set StatusBar ProgressItem Of Principe Position To 26

DBUSEAREA(.T., "DBFCDX", c_STR_Con+"CADTELIT","CADTELIT",.F.,.F.)
INDEX ON CADTELIT->TEDT_TELA  TAG TAG1 TO &(c_STR_Con+"CADTLIT.CDX")
Set StatusBar ProgressItem Of Principe Position To 27

msginfo("Fim de reindexação.")
Set StatusBar ProgressItem Of Principe Position To 0

DbCloseall()
AbrirCompartilhado()

return

//---------------------------------------------------------------------------
Procedure AbrirCompartilhado()   // o normal é sempre trabalhar com os arquivos compartilhados
//---------------------------------------------------------------------------
Local c_Nome
if CriaDbfs(.t.) //somente verifica se dbfs existem 
   CriaDbfs(.f.)  //se não existem então cria-os
endif   
dbcloseall()
c_Nome:=hb_socketResolveAddr(c_Addr) //"mestre.zapto.org")
if !NETIO_CONNECT(c_Nome,c_Port)  //   c_Addr:="10.112.61.249"   //    "10.112.61.249"      //   10.107.95.157   //10.107.95.147
   if !NETIO_CONNECT(c_Addr, c_Port)
	    MsgStop("NÃO ENCONTREI CONEXÃO PARA BANCO DE DADOS. ENDEREÇO:"+c_Nome+" - ALTERE IP E/OU PORTA NO CONFIG.INI. PROGRAMA SERÁ ENCERRADO.") 
      close all
      quit
   endif     
else
   MsgExclamation("Conexão com Banco de Dados efetuada com sucesso! Endereço: "+c_Nome)
endif

Set StatusBar ProgressItem Of Principe Range To 0, 25

USE &(c_STR_Con+"CAPABIME") VIA "DBFCDX" SHARED NEW
CAPABIME->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 1
USE &(c_STR_Con+"MENCOES") VIA "DBFCDX" SHARED NEW
MENCOES->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 2

USE &(c_STR_Con+"GABARITO") VIA "DBFCDX" SHARED NEW
GABARITO->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 3

USE &(c_STR_Con+"RESULTAV") VIA "DBFCDX" SHARED NEW
RESULTAV->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 4

USE &(c_STR_Con+"AVALIAR") VIA "DBFCDX" SHARED NEW
AVALIAR->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 5
USE &(c_STR_Con+"AVALQUES") VIA "DBFCDX" SHARED NEW
AVALQUES->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 6
USE &(c_STR_Con+"OCORREAL") VIA "DBFCDX" SHARED NEW
OCORREAL->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 7
USE &(c_STR_Con+"ANOLETIV") VIA "DBFCDX" SHARED NEW
ANOLETIV->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 8
USE &(c_STR_Con+"CADTELA") VIA "DBFCDX" SHARED NEW
CADTELA->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 9
USE &(c_STR_Con+"CADITTLA") VIA "DBFCDX" SHARED NEW
CADITTLA->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 10
USE &(c_STR_Con+"CADCAMPO") VIA "DBFCDX" SHARED NEW
CADCAMPO->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 11
USE &(c_STR_Con+"CADBDADO") VIA "DBFCDX" SHARED NEW
CADBDADO->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 12
USE &(c_STR_Con+"CADINDEX") VIA "DBFCDX" SHARED NEW
CADINDEX->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 13
USE &(c_STR_Con+"ALUNOS") VIA "DBFCDX" SHARED NEW
ALUNOS->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 14
USE &(c_STR_Con+"SETOR") VIA "DBFCDX" SHARED NEW
SETOR->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 15
USE &(c_STR_Con+"ATRIBUIR") VIA "DBFCDX" SHARED NEW
ATRIBUIR->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 16
USE &(c_STR_Con+"NOTAS") VIA "DBFCDX" SHARED NEW
NOTAS->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 17
USE &(c_STR_Con+"EMPRESA") VIA "DBFCDX" SHARED NEW
EMPRESA->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 18
USE &(c_STR_Con+"FUNCIONA") VIA "DBFCDX" SHARED NEW
FUNCIONA->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 19
USE &(c_STR_Con+"CARGOS") VIA "DBFCDX" SHARED NEW
CARGOS->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 20
USE &(c_STR_Con+"CONSELHO") VIA "DBFCDX" SHARED NEW
CONSELHO->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 21
USE &(c_STR_Con+"CONSITEM") VIA "DBFCDX" SHARED NEW
CONSITEM->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 22
USE &(c_STR_Con+"PRODUTOS") VIA "DBFCDX" SHARED NEW
PRODUTOS->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 23
USE &(c_STR_Con+"CONTRATO") VIA "DBFCDX" SHARED NEW
CONTRATO->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 24
USE &(c_STR_Con+"HORARIOS") VIA "DBFCDX" SHARED NEW
HORARIOS->(DBSETORDER(1))
Set StatusBar ProgressItem Of Principe Position To 25
USE &(c_STR_Con+"TURMAS") VIA "DBFCDX" SHARED NEW
TURMAS->(DBSETORDER(2))
Set StatusBar ProgressItem Of Principe Position To 0
return

//---------------------------------------------------------------------------
Function LimpaRelacoes()  //todas as vezes que um novo dbf é selecionado para edição devemos limpar as relações já existentes (veja função DeterminaCampos())
//---------------------------------------------------------------------------
CADTELA->(DBCLEARRELATION())
CADITTLA->(DBCLEARRELATION())
CADCAMPO->(DBCLEARRELATION())
ANOLETIV->(DBCLEARRELATION())
ALUNOS->(DBCLEARRELATION())
EMPRESA->(DBCLEARRELATION())
SETOR->(DBCLEARRELATION())
CARGOS->(DBCLEARRELATION())
FUNCIONA->(DBCLEARRELATION())
ATRIBUIR->(DBCLEARRELATION())
NOTAS->(DBCLEARRELATION())
CONSELHO->(DBCLEARRELATION())
CONSITEM->(DBCLEARRELATION())
TURMAS->(DBCLEARRELATION())
OCORREAL->(DBCLEARRELATION())
PRODUTOS->(DBCLEARRELATION())
AVALIAR->(DBCLEARRELATION())
AVALQUES->(DBCLEARRELATION())
RESULTAV->(DBCLEARRELATION())
CAPABIME->(DBCLEARRELATION())
MENCOES->(DBCLEARRELATION())
return .t.

//---------------------------------------------------------------------------
Procedure DeterminaCampos(cDBF, pOrigem)
//---------------------------------------------------------------------------
// Na variável aCamposTip, se os dados do Combo vierem de um arquivo DBF deve ser declarado o conteudo da variavel assim:
// {"COMBO",.T.,"JUSTIFIC","JUS_DESC"}
// Pode ser ainda colocada uma expressão do tipo
// {"COMBO",.T.,"JUSTIFIC","ALLTRIM(JUS_DESC)+' '+ALLTRIM(JUS_TIPO)"}
// senão, se for informado pelo programador, assim, com parametros pre-definidos:
// {"COMBO",.F.,"{'DÍVIDA','REMÉDIO','CASAMENTO'}"}

// A variavel aTAb que aparece em todas as definicoes de area de trabalho abaixo serve para armazenar as informações de cada
// tab relacionadas ao arquivo no browse principe. Para cada area de trabalho deve haver um vetor com as seguintes posicoes:
// Primeira posição: o alias da area de trabalha relacionada ao tab
// Segunda posição : o filtro para separar os registros no grid relacionado ao registro principal selecionado no browse.
// Terceira posição: o nome que aparecerá na aba do tab
// Quarta posição  : {campo de onde será copiado valor, campo onde será colado} = quantos campos forem necessários, separados por virgula
// que serão preenchidos automaticamente quando pressionado o botão "Novo" no grid
//       Cada posição desse vetor terá um outro vetor com dois seguintes dados:
//       - Primeira posição: Valor que será transferido para o campo de edição (pode ser uma variável da memória ou um campo
//         de algum dbf relacionado
//       - Segunda posição : Campo do DBF que está relacionado com o campo de edição, para onde será transferido o valor.

// aAtalhoDeFuncoes não está pronto. No momento serve para guardar as funcoes que serão usadas na criação das janelas do 
// sistema. Na criação das janelas tem declarado a tecla que será usada (F2 por exemplo) apontando para uma das posições de
// aAtalhoDeFuncoes. O correto é verificar quais teclas deverão ser usadas com as funcoes declaradas em aBotoesFuncoes

// aBrowseIndex guarda a ordem do indice que será ativada quando clicado no cabeçalho de qualquer coluna do Browse principe.
// Note que os elementos desse vetor devem estar na mesma ordem que as colunas do browse.

// bGrideBotoes é um bloco de código para os botão do Grid (Novo, Alterar, Deletar). Esse bloco de código, se retornar 
// verdadeiro, mantem os botões habilitados, senão desabilita-os (isso é útil para o caso de um determinado registro do banco de dado (um funcionário, por exemplo) não poder modificar os dados do grid).

// aBrowsePesquisa é um vetor usado na consulta.prg (funcao PesquisaArquivo() e serve para determinar qual o campo que vai ser filtrado quando operador digitar parte do valor do campo
// Todos os arquivos devem ter essa variavel declarada, pois pode ser usada quando for passivel do botão de pesquisa ao lado do campo texto                 

if empty(pOrigem);pOrigem:="BROWSE";endif
select &cDBF
bColumnColor1:= {|| {0,0,0}}; bColumnColor2:= {|| {0,0,0}}; bColumnColor3:= {|| {0,0,0}}; bColumnColor4:= {|| {0,0,0}}; bColumnColor5:= {|| {0,0,0}}; bColumnColor6:= {|| {0,0,0}}; bColumnColor7:= {|| {0,0,0}}; bColumnColor8:= {|| {0,0,0}}; bColumnColor9:= {|| {0,0,0}}; bColumnColor10:= {|| {0,0,0}}; bColumnColor11:= {|| {0,0,0}}; bColumnColor12:= {|| {0,0,0}}; bColumnColor13:= {|| {0,0,0}}; bColumnColor14:= {|| {0,0,0}}; bColumnColor15:= {|| {0,0,0}}  //resseta cores das colunas do grid para as cores normais
bColumnColor16:= {|| {0,0,0}}; bColumnColor17:= {|| {0,0,0}}; bColumnColor18:= {|| {0,0,0}}; bColumnColor19:= {|| {0,0,0}}; bColumnColor20:= {|| {0,0,0}}; bColumnColor21:= {|| {0,0,0}}; bColumnColor22:= {|| {0,0,0}}; bColumnColor23:= {|| {0,0,0}}; bColumnColor24:= {|| {0,0,0}}; bColumnColor25:= {|| {0,0,0}}; bColumnColor26:= {|| {0,0,0}}; bColumnColor27:= {|| {0,0,0}}; bColumnColor28:= {|| {0,0,0}}; bColumnColor29:= {|| {0,0,0}}; bColumnColor30:= {|| {0,0,0}}

do case
  case upper(cDbf) == "MENCOES"   //cadastro de menções para o conselho de classe
      aLabelsEdit:={'CÓDIGO','LETRA','DESCRIÇÃO','TIPO'}
      aCamposEdit:={"mencoes->men_codigo", "mencoes->men_letra","mencoes->men_descri","mencoes->men_tipo"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""},{"COMBO",.F.,"{'CAUSAS','ENCAMINHAMENTOS','OUTRAS'}"}} 
      aBrowseCampos:={'mencoes->men_codigo','mencoes->men_letra','mencoes->men_descri'}
      aBrowseHeaders:={'Codigo','Letra','Descrição'}
      aBrowseWidths:={53,53,153}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      aGridCampos:="{capabime->cap_codigo,capabime->cap_setor,capabime->cap_ano,capabime->cap_bim,capabime->cap_funcio,capabime->cap_cargo,capabime->(str(recno()))}"
      aGridHeaders:={'Codigo','Letra','Descrição',''}
      aGridWidths:={53,53,153,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.f.}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Menções do Conselho'
      cBrowsePesquisa:='mencoes->men_codigo'
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "CAPABIME"   //cadastro de dados do bimestre por turma (aulas previstas e aulas dadas)
      aLabelsEdit:={'CÓDIGO','SETOR','ANO','BIM','FUNCIONÁRIO','CARGO','AULAS PREVISTAS','AULAS DADAS'}
      aCamposEdit:={"capabime->cap_codigo", "capabime->cap_setor","capabime->cap_ano","capabime->cap_bim", "capabime->cap_funcio","capabime->cap_cargo","capabime->cap_aulapr","capabime->cap_aulada"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"SETOR","SET_CODIGO","SET_DESCRI","SET_ANO"},"",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"FUNCIONA","FUN_CODIGO","FUN_NOME",""},"",""},{"TEXT",{"CARGOS","CAR_CODIGO","CAR_DESCRI",""},"",""}, {"TEXT","","",""}, {"TEXT","","",""}} 
      aBrowseCampos:={'capabime->cap_codigo','capabime->cap_setor','capabime->cap_ano','capabime->cap_bim','capabime->cap_funcio','capabime->cap_cargo'}
      aBrowseHeaders:={'Codigo','Setor','Ano','Bimestre','Professor','Cargo'}
      aBrowseWidths:={53,53,53,53,53,53}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      aGridCampos:="{capabime->cap_codigo,capabime->cap_setor,capabime->cap_ano,capabime->cap_bim,capabime->cap_funcio,capabime->cap_cargo,capabime->(str(recno()))}"
      aGridHeaders:={'Codigo','Setor','Ano','Bimestre','Professor','Cargo',''}
      aGridWidths:={53,53,53,53,53,53,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.f.},{||.f.},{||.f.},{||.f.}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Aulas Dadas'
      cBrowsePesquisa:='capabime->cap_codigo'
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
      funciona->(dbsetorder(1))
      cargos->(dbsetorder(1))
      dbsetrelat("funciona",{|| cEmpresa+capabime->cap_funcio}, "cEmpresa+capabime->cap_funcio")
      dbsetrelat("cargos"  ,{|| cEmpresa+capabime->cap_cargo} , "cEmpresa+capabime->cap_cargo")
  case upper(cDbf) == "AVALIAR"   //cadastro de avaliaçoes (provoes)
      aLabelsEdit:={'CÓDIGO','DESCRIÇÃO','ANO','Bim','Nro.Questões','Nota Máxima','Data Aplicação','Pontua qdo. Assinalada', 'Setor'}
      aCamposEdit:={"avaliar->av_codigo", "avaliar->av_descri","avaliar->av_ano","avaliar->av_bim", "avaliar->av_nroques","avaliar->av_notamax","avaliar->av_dtaplic","avaliar->av_tipcorr","avaliar->av_setor"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"DATA",""}, {"COMBO",.F.,"{'APENAS A OPÇÃO REQUERIDA', 'QUALQUER OPÇÃO, INCLUSIVE MÚLTIPLAS/EM BRANCO','QUALQUER OPÇÃO, EXCETO MÚLTIPLAS/BRANCO','TODAS AS OPÇÕES REQUERIDAS','QUALQUER UMA DAS OPÇÕES REQUERIDAS'}"}, {"LSTBOXDUO",}} 
      aBrowseCampos:={'avaliar->av_bim','avaliar->av_codigo','avaliar->av_descri','avaliar->av_setor'}
      aBrowseHeaders:={'Bimestre','Codigo','Descrição','Setor'}
      aBrowseWidths:={53,53,175,50}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{avaliar->av_codigo,avaliar->av_descri, avaliar->(str(recno()))}"
      aGridHeaders:={'Cod.','Descrição',''}
      aGridWidths:={45,96,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='AVALIAÇÕES'
      cBrowsePesquisa:='avaliar->av_codigo'
      aList:={"setor", "setor", {|| setor->set_ehaula }, {|| setor->set_codigo+"-"+setor->set_descri}}
      aTab:={{"AVALQUES","avalques->avq_avalia == avaliar->av_codigo","Questões",{{"avaliar->av_codigo","avalques->avq_avalia"}}}, {"RESULTAV","resultav->res_avalia == avaliar->av_codigo","Resultados",{{"avaliar->av_codigo","resultav->res_avalia"}}}, {"GABARITO","gabarito->gab_aval==avaliar->av_codigo","Gabaritos",{{"avaliar->av_codigo","gabarito->gab_aval"}}}}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
      setor->(dbsetorder(1))            
      dbsetrelat("setor" ,{|| cEmpresa+avaliar->av_setor} , "cEmpresa+avaliar->av_setor")
  case upper(cDbf) == "AVALQUES"   //questoes das avaliações (provoes)
      aLabelsEdit:={'Código','Avaliação','Ordem','Resposta','Valor','Grupo Soma','Pontua qdo.Assinalada'}
      aCamposEdit:={"avalques->avq_codigo", "avalques->avq_avalia", "avalques->avq_ordem","avalques->avq_respo","avalques->avq_valor", "avalques->avq_grupo", "avalques->avq_tpcorr"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"AVALIAR","AV_CODIGO","AV_DESCRI",""},"",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","","999999.99999"}, {"TEXT","","",""},{"COMBO",.F.,"{'APENAS A OPÇÃO REQUERIDA', 'QUALQUER OPÇÃO, INCLUSIVE MÚLTIPLAS/EM BRANCO','QUALQUER OPÇÃO, EXCETO MÚLTIPLAS/BRANCO','TODAS AS OPÇÕES REQUERIDAS','QUALQUER UMA DAS OPÇÕES REQUERIDAS','QUESTÃO CANCELADA'}"}} 
      aBrowseCampos:={'avalques->avq_codigo','avalques->avq_avalia'}
      aBrowseHeaders:={'Codigo','Avaliação'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{avalques->avq_codigo,avalques->avq_ordem, str(avalques->avq_valor),avalques->avq_respo, avalques->avq_tpcorr, avalques->avq_grupo, avalques->(str(recno()))}"
      aGridHeaders:={'Cod.','Ord.','Valor','Respo','Tipo Correção (Soma Ponto)','Grupo',''}
      aGridWidths:={45,33,62,42,157,45,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{|| ProximoReg("Grd_01")},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.t.},{||.f.},{||.t.},{||.f.}}
      aGridColumnControl:={{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      nGridColumnLock:=2
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Questões das Avaliações'
      cBrowsePesquisa:='avalques->avq_codigo'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| VerificaNotaAvaliacao()}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| VerificaNotaAvaliacao()}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Pop Questões',{|| PopulaQuestoesAvaliacao()}},{'Proc Gabarito',{|| ProcessaGabarito()}},{'Salva Questões',{|| SalvaQuestoesGrid()}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "GABARITO"   //gabarito das avaliações (provoes)
      aLabelsEdit:={'Ano','Bimestre','Cod.Aluno','Nome','Avaliação','Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q19','Q20','Q21','Q22','Q23','Q24','Q25','Q26','Q27','Q28','Q29','Q30','Q31','Q32','Q33','Q34','Q35','Q36','Q37','Q38','Q39','Q40','Q41','Q42','Q43','Q44','Q45','Q46','Q47','Q48','Q49','Q50','Q51','Q52','Q53','Q54','Q55','Q56','Q57','Q58','Q59','Q60'}
      aCamposEdit:={"gabarito->gab_ano", "gabarito->gab_bime", "gabarito->gab_alun", "gabarito->gab_nome", "gabarito->gab_aval", "gabarito->q1", "gabarito->q2", "gabarito->q3", "gabarito->q4", "gabarito->q5", "gabarito->q6", "gabarito->q7", "gabarito->q8", "gabarito->q9", "gabarito->q10", "gabarito->q11", "gabarito->q12", "gabarito->q13", "gabarito->q14", "gabarito->q15", "gabarito->q16", "gabarito->q17", "gabarito->q18", "gabarito->q19", "gabarito->q20", "gabarito->q21", "gabarito->q22", "gabarito->q23", "gabarito->q24", "gabarito->q25", "gabarito->q26", "gabarito->q27", "gabarito->q28", "gabarito->q29", "gabarito->q30", "gabarito->q31", "gabarito->q32", "gabarito->q33", "gabarito->q34", "gabarito->q35", "gabarito->q36", "gabarito->q37", "gabarito->q38", "gabarito->q39", "gabarito->q40", "gabarito->q41", "gabarito->q42", "gabarito->q43", "gabarito->q44", "gabarito->q45", "gabarito->q46", "gabarito->q47", "gabarito->q48", "gabarito->q49", "gabarito->q50", "gabarito->q51", "gabarito->q52", "gabarito->q53", "gabarito->q54", "gabarito->q55", "gabarito->q56", "gabarito->q57", "gabarito->q58", "gabarito->q59", "gabarito->q60"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}} 
      aBrowseCampos:={'gabarito->gab_ano','gabarito->gab_bime','gabarito->gab_alun','gabarito->gab_nome'}
      aBrowseHeaders:={'Ano','Bimestre','Cod.Aluno','Nome'}
      aBrowseWidths:={53,53,53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{gabarito->gab_ano, gabarito->gab_bime,gabarito->gab_alun, gabarito->gab_nome, gabarito->(str(recno()))}"
      aGridHeaders:={'Ano','Bimes','Cod.Aluno','Nome',''}
      aGridWidths:={45,50,57,230,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.f.},{||.f.}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      aGridColumnControl:={{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      cBrowseTitulo:='Gabarito das Avaliações'
      cBrowsePesquisa:='gabarito->gab_alun'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "RESULTAV"   //resultado das avaliações (provoes)
      aLabelsEdit:={'Código','Avaliação','Aluno','Result.Geral','Result.Grupo 01','Result.Grupo 02','Result.Grupo3','Result.Grupo4','Result.Grupo5','Result.Grupo6','Result.Grupo7','Result.Grupo8','Result.Grupo9','Result.Grupo10','Result.Grupo11','Result.Grupo12','Result.Grupo13','Result.Grupo14','Result.Grupo15','Result.Grupo16','Result.Grupo17','Result.Grupo18','Result.Grupo19','Result.Grupo20','ID.Grupo01','ID.Grupo02','ID.Grupo03','ID.Grupo04','ID.Grupo05','ID.Grupo06','ID.Grupo07','ID.Grupo08','ID.Grupo09','ID.Grupo010','ID.Grupo011','ID.Grupo012','ID.Grupo013','ID.Grupo014','ID.Grupo015','ID.Grupo016','ID.Grupo017','ID.Grupo018','ID.Grupo019','ID.Grupo020'}
      aCamposEdit:={"resultav->res_codigo", "resultav->res_avalia", "resultav->res_aluno","resultav->res_geral","resultav->res_grup01","resultav->res_grup02","resultav->res_grup03","resultav->res_grup04","resultav->res_grup05","resultav->res_grup06","resultav->res_grup07","resultav->res_grup08","resultav->res_grup09","resultav->res_grup10","resultav->res_grup11","resultav->res_grup12","resultav->res_grup13","resultav->res_grup14","resultav->res_grup15","resultav->res_grup16","resultav->res_grup17","resultav->res_grup18","resultav->res_grup19","resultav->res_grup20","resultav->res_nome01","resultav->res_nome02","resultav->res_nome03","resultav->res_nome04","resultav->res_nome05","resultav->res_nome06","resultav->res_nome07","resultav->res_nome08","resultav->res_nome09","resultav->res_nome10","resultav->res_nome11","resultav->res_nome12","resultav->res_nome13","resultav->res_nome14","resultav->res_nome15","resultav->res_nome16","resultav->res_nome17","resultav->res_nome18","resultav->res_nome19","resultav->res_nome20"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"AVALIAR","AV_CODIGO","AV_DESCRI",""},"",""}, {"TEXT",{"ALUNOS","ALU_CODIGO","ALU_NOME",""},"",""}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","","99999.99999"}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'resultav->res_codigo','resultav->res_avalia',"resultav->res_grup10",'resultav->res_aluno'}
      aBrowseHeaders:={'Codigo','Avaliação','Aluno'}
      aBrowseWidths:={53,53,53}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      aGridCampos:="{resultav->res_codigo,resultav->res_avalia, resultav->res_aluno, substr(alunos->alu_nome,1,30), str(resultav->res_geral), resultav->(str(recno()))}"
      aGridHeaders:={'Cod.','Avaliação','Aluno','Nome','Nota Geral',''}
      aGridWidths:={45,55,53,160,70,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.f.},{||.f.},{||.f.}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      aGridColumnControl:={{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      cBrowseTitulo:='Resultado das Avaliações'
      cBrowsePesquisa:='resultav->res_codigo'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Res.Aval.',{|| imprimir("AVALIACAO")}},{'Devol.Aluno',{|| imprimir("DEVOLUTIVA")}},{'Anal.Prof.',{|| imprimir("PROFESSOR")}},{'',{|| .t.}},{'',{|| .t.}}}
      alunos->(DBSETORDER(1))  //ordem de código do sistema
      dbsetrelat("alunos" ,{|| cEmpresa+resultav->res_aluno}, "cEmpresa+resultav->res_aluno")
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
  case upper(cDbf) == "CADTELA"
      aLabelsEdit:={'Código','Nome'}
      aCamposEdit:={"cadtela->tela_codi", "cadtela->tela_nome"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'cadtela->tela_codi', 'cadtela->tela_nome'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{cadtela->tela_codi}"
      aGridHeaders:={'codi'}
      aGridWidths:={50}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      aGridColValid:={{||.t.}}
      aGridColWhen:={{||.f.}}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='TELAS'
      cBrowsePesquisa:='cadtela->tela_codi'
      aList:={}
      aTab:={{"cadittla","cadittla->ittl_tela == cadtela->tela_codi","Campos",{{"cadtela->tela_codi","cadittla->ittl_tela"}}}}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "CADITTLA"
      aLabelsEdit:={'Código','Tela','Campo','Ativo','Ordem','Tipo Controle','Máscara','Parâmetro 1','Parâmetro 2','Parâmetro 3','Parâmetro 4','Parâmetro 5'}
      aCamposEdit:={"cadittla->ittl_codi", "cadittla->ittl_tela", "cadittla->ittl_campo", "cadittla->ittl_ativo","cadittla->ittl_ordem","cadittla->ittl_tpctr","cadittla->ittl_Masca","cadittla->ittl_Para1","cadittla->ittl_Para2","cadittla->ittl_Para3","cadittla->ittl_Para4","cadittla->ittl_Para5"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"CADCAMPO","CAMP_CODI","CAMP_NOME",""},"",""}, {"CHKBOX",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'cadtela->tela_codi', 'cadtela->tela_nome'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{cadittla->ittl_codi, cadittla->ittl_tela, cadittla->ittl_campo, cadittla->ittl_ordem, str(cadittla->(recno()))}"
      aGridHeaders:={'Código','Tela','Campo','Ordem',''}
      aGridWidths:={50,50,85,50,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CAMPOS'
      cBrowsePesquisa:='cadittla->ittl_codi'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "CADBDADO"
      aLabelsEdit:={'Código','Nome','Alias','Índice Principal','Definição'}
      aCamposEdit:={"cadbdado->bd_codigo", "cadbdado->bd_nome", "cadbdado->bd_alias", "cadbdado->bd_idxprin", "cadbdado->bd_define"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"MEMO",""}}
      aBrowseCampos:={'cadbdado->bd_codigo', 'cadbdado->bd_nome', 'cadbdado->bd_alias'}
      aBrowseHeaders:={'Codigo','Nome','Alias'}
      aBrowseWidths:={53,100,100}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{}"
      aGridHeaders:={}
      aGridWidths:={}
      aGridPesquisa:="{}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='BANCO DE DADOS'
      cBrowsePesquisa:='cadbdado->bd_nome'
      aTab:={{"cadcampo","cadcampo->camp_bdado == cadbdado->bd_codigo","Campos",{{"cadbdado->bd_codigo","cadcampo->camp_bdado"}}},{"cadindex","cadindex->idx_bdado == cadbdado->bd_codigo","Indices",{{"cadbdado->bd_codigo","cadindex->idx_bdado"}}}}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "CADCAMPO"
      aLabelsEdit:={'Código','Banco de Dados','Nome','Tipo','Tamanho','Decimal','Rótulo'}
      aCamposEdit:={"cadcampo->camp_codi", "cadcampo->camp_bdado", "cadcampo->camp_nome", "cadcampo->camp_tipo", "cadcampo->camp_taman", "cadcampo->camp_decim", "cadcampo->camp_rotul"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'cadcampo->camp_codi', 'cadcampo->camp_bdado', 'cadcampo->camp_nome'}
      aBrowseHeaders:={'Codigo','Alias','Nome'}
      aBrowseWidths:={53,100,100}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{cadcampo->camp_codi, cadcampo->camp_bdado, cadcampo->camp_nome, str(cadcampo->(recno()))}"
      aGridHeaders:={'Código','Tela','Nome',''}
      aGridWidths:={50,50,50,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CAMPOS'
      cBrowsePesquisa:='cadcampo->camp_bdado'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "CADINDEX"
      aLabelsEdit:={'Código','Banco de Dados','Tag','Expressão'}
      aCamposEdit:={"cadindex->idx_codigo", "cadindex->idx_bdado", "cadindex->idx_tag", "cadindex->idx_expres"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'cadindex->idx_codigo', 'cadindex->idx_bdado','cadindex->idx_tag'}
      aBrowseHeaders:={'Codigo','Bco.Dados','Tag'}
      aBrowseWidths:={53,100,100}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{{cadindex->idx_codigo, cadindex->idx_bdado, cadindex->idx_tag, str(cadcampo->(recno()))}}"
      aGridHeaders:={'Código','Bco.Dados','Tag',''}
      aGridWidths:={50,50,50,0}
      aGridPesquisa:="{'Dep Cod','Tag'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ÍNDICES'
      cBrowsePesquisa:='cadindex->idx_bdado'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ASSOCIA"
      aLabelsEdit:={'Código','Nome','Tipo','Data','Série','Foto'}
      aCamposEdit:={"associa->ass_codi", "associa->ass_nome", "associa->ass_tipo", "associa->ass_data", "associa->ass_seri", "associa->ass_foto"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"DATA",""}, {"TEXT","","",""}, {"TEXTIMAGE",""}}
      aBrowseCampos:={'associa->ass_codi','associa->ass_nome'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ASSOCIADOS'
      cBrowsePesquisa:='associa->ass_nome'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "EMPREST"
      aLabelsEdit:={'Código','Livro','Associado','Data Empréstimo','Devolver em','Devolvido em'}
      aCamposEdit:={"emprest->emp_codi", "emprest->emp_livr", "emprest->emp_asso", "emprest->emp_dtem", "emprest->emp_dtdv", "emprest->emp_devo"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"ASSOCIA","ASS_CODI","ASS_NOME",""},"",""}, {"DATA",""}, {"DATA",""}, {"DATA",""}}
      aBrowseCampos:={'emprest->emp_codi','emprest->emp_livr','empresti->emp_asso'}
      aBrowseHeaders:={'Codigo','Livro','Associado'}
      aBrowseWidths:={53,53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif 
      cBrowseTitulo:='EMPRÉSTIMOS'
      cBrowsePesquisa:='emprest->emp_livr'
      aGridCampos:="{emprest->emp_codi,emprest->emp_livr,emprest->emp_asso,associa->ass_nome,str(emprest->(recno()))}"
      aGridHeaders:={'Cod.','Livro','Ass.Cód.','Ass.Nome',''}
      aGridWidths:={40,70,70,130,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      aList:={}
      aTab:={}
      dbsetrelat("associa",{|| emprest->emp_asso}, "emprest->emp_asso")
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "FUNCIONA"
      aLabelsEdit:={'Código','Nome','Apelido','Senha','Foto'}
      aCamposEdit:={"funciona->fun_codigo","funciona->fun_nome","funciona->fun_alcunh","funciona->fun_senha","funciona->fun_foto"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXTIMAGE",""}}
      aBrowseCampos:={'funciona->fun_codigo','funciona->fun_nome'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='FUNCIONÁRIOS'
      cBrowsePesquisa:='funciona->fun_nome'
      aBrowsePesquisa:={'funciona->fun_codigo','funciona->fun_nome'}
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
  case upper(cDbf) == "OCORREAL"
      aLabelsEdit:={'Código','Aluno','Turma','Ocorrência','Data Início','Data Fim','Observação'}
      aCamposEdit:={"ocorreal->occal_codi", "ocorreal->occal_alun", "ocorreal->occal_seto","ocorreal->occal_ocor","ocorreal->occal_dtin","ocorreal->occal_dtfi","ocorreal->occal_obse"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"SETOR","SET_CODIGO","SET_DESCRI","SET_ANO"},"",""}, {"COMBO",.F.,"{'MATRICULADO(A)','TRANSFERIDO(A)','REMANEJADO(A)','ABANDONO','RECLASSIFICADO'}"}, {"DATA",""}, {"DATA",""}, {"TEXT","","",""}} 
      aBrowseCampos:={'ocorreal->occal_codi','ocorreal->occal_alun'}
      aBrowseHeaders:={'Codigo','Aluno'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{ocorreal->occal_codi,ocorreal->occal_ocor,setor->set_descri,dtoc(ocorreal->occal_dtin),dtoc(ocorreal->occal_dtfi),ocorreal->occal_obse, str(ocorreal->(recno()))}"
      aGridHeaders:={'Cod.','Ocorrência','Setor','Data Início','Data Fim','Observação',''}
      aGridWidths:={45,96,45,72,72,62,0}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{||.t.},{||.t.}}
      aGridColWhen:={{||.f.},{||.t.},{||.T.},{||.T.},{||.T.},{||.f.},{||.f.}}
      aGridColumnControl:={{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='HISTÓRICOS DOS ALUNOS'
      cBrowsePesquisa:='ocorreal->occal_alun'
      aList:={}
      aTab:={}
      aExecutaIncAlt:={{|| PoeStatusTurma("INCALT")}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| PoeStatusTurma("EXC")}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
      setor->(dbsetorder(1))
      dbsetrelat("setor" ,{|| cEmpresa+ocorreal->occal_seto} , "cEmpresa+ocorreal->occal_seto")
   case upper(cDbf) == "PRODUTOS"
      aLabelsEdit:={'Código','Descrição','Tipo','Qtde.Bimestres'}
      aCamposEdit:={"produtos->pro_codigo", "produtos->pro_descri", "produtos->pro_tipo", "produtos->pro_qtdbim"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"COMBO",.F.,"{'EFI','EFII','EM','EJA','INT'}"}, {"TEXT","","",""}}
      aBrowseCampos:={'produtos->pro_codigo','produtos->pro_descri','produtos->pro_tipo'}
      aBrowseHeaders:={'Codigo','Descrição','Tipo'}
      aBrowseWidths:={53,100,53}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CURSOS'
      cBrowsePesquisa:='produtos->pro_descri'
      aTab:={}
      aList:={"produtos", "produtos", {|| .t.}, {|| alltrim(produtos->pro_codigo)+"-"+alltrim(produtos->pro_descri)}}
      produtos->(ordscope(0, cEmpresa))
      aExecutaIncAlt:={{|| SomaProd()}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "HORARIOS"
      aLabelsEdit:={'Código','Curso','Dia','Hora Início','Hora Fim'}
      aCamposEdit:={"horarios->hor_codigo","horarios->hor_produt", "horarios->hor_dia", "horarios->hor_ini", "horarios->hor_fim"}
      aCamposTip:={{"TEXT","","",""},{"TEXT",{"PRODUTOS","PRO_CODIGO","PRO_DESCRI",""},"",""},{"COMBO",.F.,"{'SEG','TER','QUA','QUI','SEX','SÁB','DOM'}"},{"TEXT","","","99:99"},{"TEXT","","","99:99"}}
      aBrowseCampos:={'horarios->hor_codigo','hor_produt','horarios->hor_dia','horarios->hor_ini', 'horarios->hor_fim'}
      aBrowseHeaders:={'Codigo','Curso','Dia','Hora Inicio','Hora Fim'}
      aBrowseWidths:={53,70,60,60,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')} , { || poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='HORÁRIOS'
      cBrowsePesquisa:='horarios->hor_codigo'
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ALUNOS"
      aLabelsEdit:={'Código','Nome','R.A.','RG Aluno','CPF Aluno','Nascimento','Sexo','Endereço','Número','Complemento','Bairro','Cidade','U.F.','Cep','Telefone','Celular','E-mail','Mãe','Pai','Foto'}
      aCamposEdit:={"alunos->alu_codigo","alunos->alu_nome","alunos->alu_ra","alunos->alu_rgnral","alunos->alu_cpfalu","alunos->alu_nasc","alunos->alu_sexo","alunos->alu_end","alunos->alu_nro","alunos->alu_bairro","alunos->alu_cidade","alunos->alu_estado","alunos->alu_cep","alunos->alu_tel","alunos->alu_cel","alunos->alu_email","alunos->alu_mae","alunos->alu_pai","alunos->alu_foto"}
      aCamposTip:={{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"DATA",""},{"COMBO",.F.,"{'M','F'}"},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"COMBO",.F., "{'SP','RJ','MS','AM','PR','MG','RS','SC','MT','RO','PI','PE','BA','CE','MA','ES','RN','RR','TO','PA','AL','AC'}"},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXTIMAGE",""}}
      aBrowseCampos:={'alunos->alu_codigo','alunos->alu_nome','setor->set_descri'}
      aBrowseHeaders:={'Codigo', 'Nome', 'Setor'}
      aBrowseWidths:={46,168,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')},{|| poeordem(cAliasBrowse, '2', 'LblIndice')},{|| poeordem(cAliasBrowse, '3', 'LblIndice')}}"
      aGridCampos:="{turmas->tur_codigo,turmas->tur_setor,alunos->alu_empre+alunos->alu_nome,str(turmas->(recno()))}"
      aGridHeaders:={'Cod.','Setor','aluno',''}
      aGridWidths:={55,35,140,0}
      aGridColumnControl:="{{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}"
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ALUNOS & HISTÓRICOS'
      aBrowsePesquisa:={'alunos->alu_codigo','alunos->alu_nome'}
      aTab:={{"OCORREAL","ocorreal->occal_alun == alunos->alu_codigo","OCORRÊNCIAS",{{"alunos->alu_codigo","ocorreal->occal_alun"},{"alunos->alu_setor","ocorreal->occal_seto"}}}}
      aList:={}
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
         turmas->(dbsetorder(3)) //indice de codigo de aluno
         setor->(dbsetorder(1))
         dbsetrelat("turmas",{|| cEmpresa+alunos->alu_codigo}, "cEmpresa+alunos->alu_codigo")
         dbsetrelat("setor" ,{|| cEmpresa+alunos->alu_setor} , "cEmpresa+alunos->alu_setor")
      endif
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| VerifDuplicidadeNome(getproperty("TabWindow","Text_"+cFormAtivo+"02","Value"))}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Mostra Imagem', {|| MostraFotoAluno()}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "SETOR"
      aLabelsEdit:={'Código','Descrição','Ano','Sala', 'Fechado','É sala de aula','Período','Curso','Prof.Coordenador'}
      aCamposEdit:={"setor->set_codigo", "setor->set_descri", "setor->set_ano", "setor->set_sala", "setor->set_fechad", "setor->set_ehAula", "setor->set_period", "setor->set_produt", "setor->set_procoo"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","","!!!"}, {"TEXT","","",""}, {"TEXT","","",""}, {"CHKBOX",""}, {"CHKBOX",""}, {"COMBO",.F.,"{'MANHÃ','TARDE','NOITE','INTEGRAL'}"}, {"TEXT",{"PRODUTOS","PRO_CODIGO","PRO_DESCRI",""},"",""}, {"TEXT",{"FUNCIONA","FUN_CODIGO","FUN_NOME",""},"",""}}
      aBrowseCampos:={'setor->set_codigo','setor->set_descri','produtos->pro_descri'}
      aBrowseHeaders:={'Codigo','Série','Curso'}
      aBrowseWidths:={53,120,120}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}, { || poeordem(cAliasBrowse, '3', 'LblIndice')}}"
      aGridCampos:="{turmas->tur_codigo,turmas->tur_setor,alunos->alu_empre+alunos->alu_nome,str(turmas->(recno()))}"
      aGridHeaders:={'Cod.','Setor','aluno',''}
      aGridWidths:={55,35,140,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| VerifAtribuir(cCodFuncionario, cCodCargo)}
      cBrowseTitulo:='SETORES & ATRIBUIÇÕES & TURMAS & NOTAS'
      cBrowsePesquisa:='setor->set_descri'
      if pOrigem = "BROWSE"
         cFiltroBrowse:='setor->set_ano=cAnoLetivoAtual'  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aTab:={{"ATRIBUIR", "atribuir->atr_setor == setor->set_codigo","Atribuição",{{"setor->set_codigo","atribuir->atr_setor"}}},{"TURMAS", "turmas->tur_setor == setor->set_codigo","Turmas",{{"setor->set_codigo","turmas->tur_setor"},{"cAnoLetivoAtual","turmas->tur_ano"}}},{"NOTAS", "notas->not_bim = cBimestreAtual .and. notas->not_ano = cAnoLetivoAtual .and. notas->not_cargo = cCodCargo","Notas",{{"setor->set_codigo+cCodFuncionario","notas->not_setor+notas->not_funcio"}}}, {"CAPABIME", "capabime->cap_setor == setor->set_codigo .and. capabime->cap_bim == cBimestreAtual","Aulas Dadas",{{"setor->set_codigo","capabime->cap_setor"},{"cAnoLetivoAtual","capabime->cap_ano"},{"cBimestreAtual","capabime->cap_bim"}}}} 
      aList:={"horarios", "horarios", {|| .t.}, {|| alltrim(horarios->hor_codigo)+"-"+substr(horarios->hor_dia,1,3)+"-"+horarios->hor_ini+"/"+horarios->hor_fim}}
      produtos->(DBSETORDER(1))  //ordem de código do sistema
      cargos->(DBSETORDER(1))  //ordem de código do sistema
      funciona->(DBSETORDER(1))  //ordem de código do sistema
      alunos->(DBSETORDER(1))  //ordem de código do sistema
      alunos->(dbskip(1))
      atribuir->(dbsetorder(2))  //ordem do código do sistema do setor
      turmas->(dbsetorder(2))    //ordem de setor
      contrato->(dbsetorder(3))    //ordem de número do aluno
      dbsetrelat("turmas"   ,{|| cEmpresa+setor->set_codigo}, "cEmpresa+setor->set_codigo")
      dbsetrelat("atribuir" ,{|| cEmpresa+setor->set_codigo}, "cEmpresa+setor->set_codigo")
      dbsetrelat("produtos" ,{|| cEmpresa+setor->set_produt}, "cEmpresa+setor->set_produt")
      dbsetrelat("funciona" ,{|| cEmpresa+atribuir->atr_funcio}, "cEmpresa+atribuir->atr_funcio")
      dbsetrelat("cargos"   ,{|| cEmpresa+atribuir->atr_cargo} , "cEmpresa+atribuir->atr_cargo")
      dbsetrelat("alunos"   ,{|| cEmpresa+turmas->tur_aluno }, "cEmpresa+turmas->tur_aluno" )
      dbsetrelat("contrato" ,{|| cEmpresa+alunos->alu_codigo}, "cEmpresa+aluno->alu_codigo")
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| VerifItemRelacionado("SETOR","ATRIBUIR","SET_CODIGO")},{|| VerifItemRelacionado("SETOR","TURMAS","SET_CODIGO")},{|| VerifItemRelacionado("SETOR","NOTAS","SET_CODIGO")}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "CONTRATO"
      aLabelsEdit:={'Código','Numero','Aluno','Dt Inicio','Dt Fim','Curso','Carga Horária','Valor','Nº Parcelas','Valor Parcela','Dia Vcto','Testem 1','RG. Test.1','Testem 2','RG Test 2','Texto','Observação'}
      aCamposEdit:={"contrato->contr_codi","contrato->contr_nume","contrato->contr_alu","contrato->contr_dtin","contrato->contr_dtfi","contrato->contr_prod","contrato->contr_hora","contrato->contr_valo", "contrato->contr_npar", "contrato->contr_vlpa","contrato->contr_divc","contrato->contr_tes1","contrato->contr_rgt1","contrato->contr_tes2","contrato->contr_rgt2","contrato->contr_text","contrato->contr_obse"}
      aCamposTip:={{"TEXT","","",""},{"TEXT","","",""},{"TEXT",{"ALUNOS","ALU_CODIGO","ALU_NOME",""},"",""},{"DATA",""},{"DATA",""},{"TEXT",{"PRODUTOS","PRO_CODIGO","PRO_DESCRI",{{"TEXT_08","PRODUTOS->PRO_PRECO"},{"TEXT_07","PRODUTOS->PRO_HORAS"}}},"",""},{"TEXT","","",""},{"TEXT","","","9999999999999.99"},{"TEXT","","",""},{"TEXT","","","999999999.99"},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"MEMO",""},{"MEMO",""}}
      aBrowseCampos:={'contrato->contr_codi','contrato->contr_nume','contrato->contr_prod'}
      aBrowseHeaders:={'Codigo','Número','Curso'}
      aBrowseWidths:={46,168,150}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')},{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{turmas->tur_codigo,turmas->tur_setor,alunos->alu_empre+alunos->alu_nome,str(turmas->(recno()))}"
      aGridHeaders:={'kod.','xetor','maluno',''}
      aGridWidths:={55,35,140,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CONTRATOS'
      cBrowsePesquisa:='contrato->contr_codi'
      aTab:={{"PAGAMENT", "pagament->pag_contra == contrato->contr_nume",   "Paga",{{"contrato->contr_nume","pagament->pag_contra"}}}}
      aList:={}
      alunos->(DBSETORDER(1))  //ordem de código
      dbsetrelat("alunos",{|| contrato->contr_alu}, "contrato->contr_alu")
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "CARGOS"
      aLabelsEdit:={'Código','Descrição','Descr.Resumida','Comp.Curricular'}
      aCamposEdit:={"cargos->car_codigo", "cargos->car_descri", "cargos->car_resumo","cargos->car_compon"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'cargos->car_codigo','cargos->car_descri'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada. 
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CARGOS'
      cBrowsePesquisa:='cargos->car_descri'
      aBrowsePesquisa:={'cargos->car_codigo','cargos->car_descri'}
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}      
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "EMPRESA"
      aLabelsEdit:={'Código','Nome','Rua','Número','Complemento','Bairro','Cidade','Estado','Telefone','Logotipo'}
      aCamposEdit:={"empresa->emp_codigo", "empresa->emp_nome", "empresa->emp_rua","empresa->emp_numero","empresa->emp_comple","empresa->emp_bairro","empresa->emp_cidade","empresa->emp_estado","empresa->emp_tel","empresa->emp_logo"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"COMBO",.F., "{'SP','RJ','MS','AM','PR','MG','RS','SC','MT','RO','PI','PE','BA','CE','MA','ES','RN','RR','TO','PA','AL','AC'}"}, {"TEXT","","",""}, {"TEXTIMAGE",""}}
      aBrowseCampos:={'empresa->emp_codigo','empresa->emp_nome'}
      aBrowseHeaders:={'Codigo','Nome'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:={}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ESCOLAS & ANOS LETIVOS'
      cBrowsePesquisa:='empresa->emp_nome'
      aTab:={} //{{"ANOLETIV", "anoletiv->ano_empres = empresa->emp_codigo", "ANO LETIVO",{{"empresa->emp_codigo","anoletiv->ano_empres"}}}}
      aList:={}
      aExecutaIncAlt:={|| .t.}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ANOLETIV"
      aLabelsEdit:={'Código','Ano','Ínício 1º Bim','Fim 1º Bim','Dt.Limite 1º Bim.','Início 2º Bim','Fim 2º Bim','Dt.Limite 2º Bim.','Início 3º Bim','Fim 3º Bim','Dt.Limite 3º Bim.','Início 4º Bim','Fim 4º Bim','Dt.Limite 4º Bim.'}
      aCamposEdit:={"anoletiv->ano_codigo","anoletiv->ano_ano","anoletiv->ano_in1bim","anoletiv->ano_fi1bim","anoletiv->ano_li1bim","anoletiv->ano_in2bim","anoletiv->ano_fi2bim","anoletiv->ano_li2bim","anoletiv->ano_in3bim","anoletiv->ano_fi3bim","anoletiv->ano_li3bim","anoletiv->ano_in4bim","anoletiv->ano_fi4bim","anoletiv->ano_li4bim"}
      aCamposTip:={{"TEXT","","",""},{"TEXT","","",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""},{"DATA",""}}
      aBrowseCampos:={'anoletiv->ano_codigo','anoletiv->ano_ano'}
      aBrowseHeaders:={'Codigo','Ano'}
      aBrowseWidths:={46,46}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')},{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{anoletiv->ano_codigo,anoletiv->ano_ano,anoletiv->ano_qtdial,str(anoletiv->(recno()))}"
      aGridHeaders:={'Cod.','Ano','Qtd.Dias Letivos',''}
      aGridWidths:={55,55,95,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      aGridColWhen:={{||.f.},{||.f.},{||.f.},{||.f.}}
      aGridColValid:={{||.t.},{||.t.},{||.t.},{||.t.}}
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ANOS LETIVOS'
      cBrowsePesquisa:='anoletiv->ano_codigo'
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ACERVO"
      aLabelsEdit:={'Tombo','Título','Autor','Editor','Classificação','Páginas','Edição','Ano','Inclusão','Disponível','Descrição'}
      aCamposEdit:={"acervo->bib_tombo", "acervo->bib_titulo", "acervo->bib_autor", "acervo->bib_editor", "acervo->bib_classi", "acervo->bib_pagina", "acervo->bib_edicao", "acervo->bib_ano", "acervo->bib_dtincl", "acervo->bib_dispon", "acervo->bib_descri"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"MEMO",""}}
      aBrowseCampos:={'acervo->bib_tombo','acervo->bib_titulo'}
      aBrowseHeaders:={'Codigo','Titulo'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      cBrowsePesquisa:='acervo->bib_titulo'
      cBrowseTitulo:='Cadastro do Acervo'
      aTab:={{"EMPREST", "emprest->emp_livr = acervo->bib_tombo","Empréstimos",{{"acervo->bib_tombo","emprest->emp_livr"}}}}
      aList:={}
      aRelatTab:={{"emprest",1,{|| acervo->bib_tombo},"acervo->bib_tombo"}}
      aRelatBrowse:={} 
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ATRIBUIR"
      aLabelsEdit:={'Código','Setor','Ordem','Funcionário','Cargo'}
      aCamposEdit:={"atribuir->atr_codigo", "atribuir->atr_setor", "atribuir->atr_ordem", "atribuir->atr_funcio", "atribuir->atr_cargo"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"SETOR","SET_CODIGO","SET_DESCRI",""},"",""}, {"TEXT","","",""}, {"TEXT",{"FUNCIONA","FUN_CODIGO","FUN_NOME",""},"",""}, {"TEXT",{"CARGOS","CAR_CODIGO","CAR_DESCRI",""},"",""}}
      aBrowseCampos:={'atribuir->atr_codigo','setor->set_descri','atribuir->atr_ordem','funciona->fun_nome','cargos->car_descri'}
      aBrowseHeaders:={'Codigo','Setor','Ordem','Funcionário','Cargos'}
      aBrowseWidths:={49,60,49,100,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif 
      aGridCampos:="{atribuir->atr_codigo,atribuir->atr_ordem,cargos->car_descri,funciona->fun_nome,cargos->car_codigo,funciona->fun_codigo,str(atribuir->(recno()))}"
      aGridHeaders:={'Cod.','Ordem','Cargo','Funcionário','Cod.Cargo','Cod.Func.',''}
      aGridWidths:={52,45,140,150,50,50,0}
      aGridColWhen:= {{||.f.},{|| IdAlteraCampo(.t.,"ORDEM DE MATERIAS")},{|| .f.},{||.f.},{||.f.},{||.f.},{||.f.}}    
      aGridColValid:={{||.t.},{||.t.},{|| .t.},{||.t.},{||.t.},{||.t.},{||.t.}}    
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| VerifAtribuir(cCodFuncionario, cCodCargo)}
      cBrowseTitulo:='ATRIBUIÇÕES'
      cBrowsePesquisa:='atribuir->atr_nome'
      cargos->(DBSETORDER(1))  //ordem de código do sistema
      funciona->(DBSETORDER(1))  //ordem de código do sistema
      dbsetrelat("funciona" ,{|| cEmpresa+atribuir->atr_funcio}, "cEmpresa+atribuir->atr_funcio")
      dbsetrelat("cargos"   ,{|| cEmpresa+atribuir->atr_cargo} , "cEmpresa+atribuir->atr_cargo")
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Copia Atribuir',{|| CopiaAtribuicao()}},{'Salva Ordem',{|| salvaOrdemAtribuir()}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "TURMAS"
      aLabelsEdit:={'Código','Ano','Setor','Aluno','Nº Chamada','Status','Data','Observação'}
      aCamposEdit:={"turmas->tur_codigo", "turmas->tur_ano", "turmas->tur_setor", "turmas->tur_aluno","turmas->tur_chamad","turmas->tur_status","turmas->tur_datast","turmas->tur_observ"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"ALUNOS","ALU_CODIGO","ALU_NOME",""},"",""},{"TEXT","","",""}, {"COMBO",.F.,"{'MATRICULADO(A)','TRANSFERIDO(A)','REMANEJADO(A)','ABANDONO','RECLASSIFICADO'}"},{"DATA",""},{"TEXT","","",""}}
      aBrowseCampos:={'turmas->tur_codigo','setor->set_descri','alunos->alu_nome'}
      aBrowseHeaders:={'Codigo','Setor','Aluno'}
      aBrowseWidths:={49,60,100}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')} , { || poeordem(cAliasBrowse, '2', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      aGridCampos:="{turmas->tur_codigo,alunos->alu_nome,turmas->tur_chamad,turmas->tur_status,dtoc(turmas->tur_datast),turmas->tur_observ,str(turmas->(recno()))}"
      aGridHeaders:={'','Aluno','Nº','Status','Data','Observação',''}
      aGridWidths:={0,105,29,105,75,95,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| VerifAtribuir(cCodFuncionario, cCodCargo)}
      cBrowseTitulo:='TURMAS'
      cBrowsePesquisa:='turmas->tur_codigo'
      aTab:={}
      aList:={}
      turmas->(dbsetorder(2)) //turma + setor + chamada
      alunos->(dbsetorder(1))  //ordem de código do sistema
      dbsetrelat("alunos" ,{|| cEmpresa+turmas->tur_aluno}, "cEmpresa+turmas->tur_aluno")
      aExecutaIncAlt:={{|| PoeTurmaAluno("INCALT")},{|| CriaEventoAluno()}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| PoeTurmaAluno("EXC")}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Insere Foto',{|| NovoLocalizaImg()}}, {'List Chamad',{|| imprimir("LISTACLASSE")}},{'Mostra Foto',{|| MostraFotoAluno()}},{'Remaneja',{|| RemanejaAluno()}},{'',{|| .t.}}}
  case upper(cDbf) == "NOTAS"
      aLabelsEdit:={'Código','Setor','Aluno','Nº Chamada','Bimestre','Ano (9999)','Cargo','Nota','Faltas','Compensadas','Funcionário'}
      aCamposEdit:={"notas->not_codigo", "notas->not_setor", "notas->not_aluno", "notas->not_chamad", "notas->not_bim","notas->not_ano","notas->not_cargo","notas->not_nota","notas->not_faltas","notas->not_compen","notas->not_funcio"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"SETOR","SET_CODIGO","SET_DESCRI",""},"",""}, {"TEXT",{"ALUNOS","ALU_CODIGO","ALU_NOME",""},"",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"CARGOS","CAR_CODIGO","CAR_DESCRI",""},"",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"FUNCIONA","FUN_CODIGO","FUN_NOME",""},"",""}}
      aBrowseCampos:={'notas->not_codigo','notas->not_aluno'}
      aBrowseHeaders:={'Codigo','Aluno'}
      aBrowseWidths:={53,200}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{substr(alunos->alu_nome,1,20),notas->not_chamad, notas->not_nota,notas->not_faltas,notas->not_compen,turmas->tur_status,dtoc(turmas->tur_datast),turmas->tur_aluno,str(notas->(recno()))}" 
      aGridHeaders:={'Aluno','Nº','Nota','Faltas','Compensadas','Status','Data','',''}
      aGridWidths:={105,30,40,44,44,105,75,0,0}
      aGridColWhen:= {{||.f.},{||.f.},{|| verifStatusAluno()},{||.t.},{||.t.},{||.f.},{||.f.},{||.f.},{||.f.}}    
      aGridColValid:={{||.t.},{||.t.},{|| val(this.cellvalue)<=10 .and. IdAlteraCampo(.t.,"NOTAS")},{||.t.},{|| ProximoReg("Grd_03")},{||.t.},{||.t.},{||.t.},{||.t.}}    
      aGridPesquisa:="{'Cod'}"
      aGridColumnControl:={{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      nGridColumnLock:=2
      bGridBotoes:={|| VerifAtribuir(cCodFuncionario, cCodCargo)}
      cBrowseTitulo:='NOTAS'
      cBrowsePesquisa:='notas->not_aluno'
      aTab:={}
      aList:={}
      notas->(Dbsetorder(1))
      ALUNOS->(DBSETORDER(1))
      CARGOS->(DBSETORDER(1))
      TURMAS->(DBSETORDER(2))  //empresa+setor+chamada+ALUNO - o setor foi incluído no índice, pois quando remanejado para outra turma, sempre pegava o primeiro registro encontrado, ou seja, o registro da turma anterior do aluno, antes da remoção.
      FUNCIONA->(DBSETORDER(1))
      PRODUTOS->(DBSETORDER(1))
      dbsetrelat("ALUNOS"  ,{|| cEmpresa+notas->not_aluno }, "cEmpresa+notas->not_aluno")
      dbsetrelat("TURMAS"  ,{|| cEmpresa+setor->set_codigo+cAnoLetivoAtual+notas->not_chamad+notas->not_aluno}, "cEmpresa+setor->set_codigo+cAnoLetivoAtual+notas->not_chamad+notas->not_aluno")
      dbsetrelat("cargos"  ,{|| cEmpresa+notas->not_cargo }, "cEmpresa+notas->not_cargo")
      dbsetrelat("funciona",{|| cEmpresa+notas->not_funcio}, "cEmpresa+notas->not_funcio")
      dbsetrelat("produtos",{|| cEmpresa+setor->set_produt}, "cEmpresa+setor->set_produt")
      bColumnColor3:={|| if(val(this.cellvalue)>4,{0,0,255},{255,0,0})}  //muda coluna 3 (médias) para vermelho se menor que 5 e azul se maior que 4	
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Pop.Notas',{|| PopulaNotas()}},{'Salva Notas',{|| SalvaNotasGrid()}},{'Tot.Aulas',{|| LancaTotalAulas()}},{'Mostra Notas',{|| MostraNotas(.t.)}},{'Conceit.Final',{|| ConceitoFinal()}}}
   case upper(cDbf) == "CONSELHO"
      aLabelsEdit:={'CÓDIGO','ANO','BIMESTRE','SETOR','PRESIDENTE','DATA','TEMPO','FECHADO','FUNCIONÁRIOS','OBSERVAÇÃO'}
      aCamposEdit:={"conselho->con_codigo", "conselho->con_ano", "conselho->con_bim","conselho->con_setor","conselho->con_coorde","conselho->con_data","conselho->con_tempo","conselho->con_fecha","conselho->con_funcio","conselho->con_observ"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT",{"SETOR","SET_CODIGO","SET_DESCRI",{{"LISTBOXDUO",9}}},"",""}, {"TEXT",{"FUNCIONA","FUN_CODIGO","FUN_NOME",""},"",""}, {"DATA",""}, {"TEXT","","",""}, {"CHKBOX",""}, {"LSTBOXDUO",""}, {"MEMO",""}}
      aBrowseCampos:={'conselho->con_codigo','setor->set_descri','conselho->con_ano','conselho->con_bim','produtos->pro_tipo'}
      aBrowseHeaders:={'Codigo','Turma','Ano','Bimestre','Curso'}
      aBrowseWidths:={53,60,60,60,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')},{|| poeordem(cAliasBrowse, '4', 'LblIndice')}}"
      cFiltroBrowse:='conselho->con_ano=cAnoLetivoAtual'  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      if pOrigem = "BROWSE"
         LimpaRelacoes()  //zera todas os set relations estabelecidos  anteriormente
      endif
      aGridCampos:="{}"
      aGridHeaders:={}
      aGridWidths:={}
      aGridPesquisa:="{}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='CONSELHOS'
      cBrowsePesquisa:='conselho->con_aluno'
      aTab:={{"CONSITEM", "consitem->cit_conse == conselho->con_codigo","ITENS DO CONSELHO", {{"conselho->con_codigo", "consitem->cit_conse"}}}} 
      aList:={"ATRIBUIR", "funciona", {|| atribuir->atr_setor = setor->set_codigo}, {|| funciona->fun_codigo+"-"+funciona->fun_nome}}
      produtos->(DBSETORDER(1))  //ordem de código do sistema
      setor->(dbsetorder(1)) //ordem de código
      funciona->(dbsetorder(1)) // ordem de código
      dbsetrelat("setor", {|| cEmpresa+conselho->con_setor }, "cEmpresa+conselho->con_setor")
      dbsetrelat("produtos" ,{|| cEmpresa+setor->set_produt}, "cEmpresa+setor->set_produt")
      atribuir->(dbsetrelat("funciona",{|| cEmpresa+atribuir->atr_funcio}, "cEmpresa+atribuir->atr_funcio"))
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| VerifItemRelacionado("CONSELHO","CONSITEM","CON_CODIGO")}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "CONSITEM"
      aLabelsEdit:={'CÓDIGO','CONSELHO','ALUNO','CHAMADA','ANO','BIMESTRE'}
      aCamposEdit:={"consitem->cit_codigo", "consitem->cit_conse", "consitem->cit_aluno", "consitem->cit_chamad","consitem->cit_ano", "consitem->cit_bim"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'consitem->cit_codigo','consitem->cit_aluno','consitem->cit_ano','consitem->cit_bim'}
      aBrowseHeaders:={'Codigo','Aluno','Ano','Bimestre'}
      aBrowseWidths:={53,60,60,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
      endif
      aGridCampos:="{consitem->cit_chamad, substr(alunos->alu_nome,1,40), consitem->cit_ano, consitem->cit_bim, str(consitem->(recno()))}"
      aGridHeaders:={'Nº','Aluno','Ano','Bim.',''}
      aGridWidths:={50,150,50,50,0}
      aGridPesquisa:="{'Cod'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Itens Conselho'
      cBrowsePesquisa:='consitem->cit_codigo'
      aTab:={}
      aList:={"atribuir", "funciona", {|| atribuir->atr_setor = conselho->con_setor}, {|| alltrim(funciona->fun_codigo)+"-"+funciona->fun_nome}}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'Pop.Conselho',{|| PopulaItemConselho()}},{'Mostra Consel',{|| MostraConselho()}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
      alunos->(dbsetorder(1)) //ordem de código
      dbsetrelat("alunos", {|| cEmpresa+consitem->cit_aluno }, "cEmpresa+consitem->citaluno")
   case upper(cDbf) == "FINANCIA"
      aLabelsEdit:={'Código','Conta','Dt.Lança','Dt.Venc.','Valor','Dt.Paga.','Vlr.Pago','Responsável','Descrição','Participantes'}
      aCamposEdit:={"financia->lan_codi", "financia->lan_cont", "financia->lan_dtlc","financia->lan_dtvc","financia->lan_valo","financia->lan_dtpg","financia->lan_vlpg","financia->lan_qupg","financia->lan_desc","financia->lan_part"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT",{"CONTA","CTA_CODI","CTA_DESC",""},"",""}, {"DATA",""}, {"DATA",""}, {"TEXT","","",""}, {"DATA",""}, {"TEXT","","",""}, {"TEXT",{"PAGADOR","PGD_CODI","PGD_NOME",""},"",""}, {"TEXT","","",""}, {"LSTBOXDUO",{""}}}
      aBrowseCampos:={'conta->cta_estr','financia->lan_valo','financia->lan_dtvc','financia->lan_qupg'}
      aBrowseHeaders:={'Conta','Valor','Vencimento','Quem Paga'}
      aBrowseWidths:={65,60,60,70}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{}"
      aGridHeaders:={}
      aGridWidths:={}
      aGridPesquisa:="{'Cod'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Lançamentos Financeiros'
      cBrowsePesquisa:='financia->lan_cont'
      aTab:={}
      aList:={"pagador", "pagador", {|| .t.}, {|| alltrim(pagador->pgd_codi)+"-"+pagador->pgd_nome}}
      dbsetrelat("conta", {|| financia->lan_cont }, "financia->lan_cont")
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "CONTA"
      aLabelsEdit:={'Código','Estrutura','Descr.','Ds.Reduz.','Déb/Créd.'}
      aCamposEdit:={"conta->cta_codi", "conta->cta_estr", "conta->cta_desc","conta->cta_dsrd","conta->cta_dbcr"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'conta->cta_estr','conta->cta_desc'}
      aBrowseHeaders:={'Estrutura','Descrição'}
      aBrowseWidths:={73,160}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '2', 'LblIndice')},{|| poeordem(cAliasBrowse, '3', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{}"
      aGridHeaders:={}
      aGridWidths:={}
      aGridPesquisa:="{'Cod'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='Contas Financeiras'
      cBrowsePesquisa:='conta->cta_estr'
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "PAGADOR"
      aLabelsEdit:={'Código','Referência','Nome'}
      aCamposEdit:={"pagador->pgd_codi", "pagador->pgd_refe", "pagador->pgd_nome"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"TEXT","","",""}}
      aBrowseCampos:={'pagador->pgd_refe','pagador->pgd_nome'}
      aBrowseHeaders:={'Referência','Nome'}
      aBrowseWidths:={53,60}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{}"
      aGridHeaders:={}
      aGridWidths:={}
      aGridPesquisa:="{'Cod'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='PAGADORES'
      cBrowsePesquisa:='pagador->pgd_refe'
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "PAGAMENT"
      aLabelsEdit:={'Código','Contrato','Data','Forma','Docto','Valor','Para'}
      aCamposEdit:={"pagament->pag_codigo","pagament->pag_contra","pagament->pag_data","pagament->pag_forma","pagament->pag_docto","pagament->pag_valor","pagament->pag_bompar"}
      aCamposTip:={{"TEXT","","",""}, {"TEXT","","",""}, {"DATA",""}, {"COMBO",.F.,"{'DINHEIRO','CHEQUE','BOLETO','CARTÃO CRÉDITO','CARTÃO DÉBITO'}"}, {"TEXT","","",""}, {"TEXT","","",""}, {"DATA",""}}
      aBrowseCampos:={}
      aBrowseHeaders:={}
      aBrowseWidths:={}
      aBrowseIndex:="{}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{pagament->pag_codigo,pagament->pag_contra,dtoc(pagament->pag_data),pagament->pag_forma,pagament->pag_docto,str(pagament->pag_valor),dtoc(pagament->pag_bompar),str(pagament->(recno()))}"
      aGridHeaders:={'Código','Contrato','Data','Forma','Docto','Valor','Para',''}
      aGridWidths:={50,133,50,50,50,50,50,0}
      aGridPesquisa:="{'Cod'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='PAGAMENTOS'
      cBrowsePesquisa:='pagador->pgd_refe'
      aTab:={} 
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "REFEICAO"
      aLabelsEdit:={'Código','Data','Alimento','Medida','Caloria','Qtde'}
      aCamposEdit:={"refeicao->ref_codigo", "refeicao->ref_data","refeicao->ref_alimen", "refeicao->ref_medida","refeicao->ref_calor","refeicao->ref_qtde"}
      aCamposTip:={{"TEXT","","",""}, {"DATA",""}, {"TEXT",{"ALIMENTO","ALI_CODIGO","ALI_DESCRI",{{"TEXT_"+cFormAtivo+"04","ALIMENTO->ALI_MEDIDA"},{"TEXT_"+cFormAtivo+"05","ALIMENTO->ALI_CALOR"}}},"",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""}}
      aBrowseCampos:={'refeicao->ref_codigo','refeicao->ref_alimen','refeicao->ref_qtde'}
      aBrowseHeaders:={'Codigo','Alimento','Qtde'}
      aBrowseWidths:={53,120,120}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{refeicao->ref_codigo,refeicao->ref_alimen,refeicao->ref_qtde,str(turmas->(recno()))}"
      aGridHeaders:={'Cod.','Alimento','Qtde.',''}
      aGridWidths:={55,35,140,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='REFEIÇÕES'
      cBrowsePesquisa:='refeicao->ref_alimen'
      aTab:={}
      aList:={}
      alimento->(DBSETORDER(1))  //ordem de código do sistema
      dbsetrelat("alimento"   ,{|| cEmpresa+refeicao->ref_codigo}, "cEmpresa+refeicao->ref_codigo")
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
   case upper(cDbf) == "ALIMENTO"
      aLabelsEdit:={'Código','Grupo','Descricao','Medida','Caloria'}
      aCamposEdit:={"alimento->ali_codigo", "alimento->ali_grupo", "alimento->ali_descri", "alimento->ali_medida","alimento->ali_calor"}
      aCamposTip:={{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""},{"TEXT","","",""}}
      aBrowseCampos:={'alimento->ali_codigo','alimento->ali_descri','alimento->ali_medida'}
      aBrowseHeaders:={'Codigo','Descrição','Medida'}
      aBrowseWidths:={53,120,120}
      aBrowseIndex:="{{|| poeordem(cAliasBrowse, '1', 'LblIndice')}}"
      if pOrigem = "BROWSE"
         cFiltroBrowse:=''  //filtro para o banco de dados principal. Muda este filtro apenas se a primeira aba estiver ativa, a fim de evitar que o filtro seja zerado indevidamente quando ativada alguma outra aba relacionada.
         LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
      endif
      aGridCampos:="{alimento->ali_codigo,alimento->ali_descri,alimento->ali_calor,str(turmas->(recno()))}"
      aGridHeaders:={'Cod.','Descrição','Caloria',''}
      aGridWidths:={55,35,140,0}
      aGridPesquisa:="{'Dep Cod','Nome'}"
      bGridBotoes:={|| .t.}
      cBrowseTitulo:='ALIMENTOS'
      cBrowsePesquisa:='alimento->ali_codigo'
      aTab:={}
      aList:={}
      aExecutaIncAlt:={{|| .t.}}
      bExecutaAntesIncAlt:={|| .t.}
      aExecutaAposExclusao:={{|| .t.}}
      aExecutaAntesExclusao:={{|| .t.}}
      aBotoesFuncoes:={{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}},{'',{|| .t.}}}
endcase
dbgotop()
return

//---------------------------------------------------------------------------
procedure pagamento()
//---------------------------------------------------------------------------
replace empresti->emp_sald with (empresti->emp_sald - pagament->pag_valo)
return

//---------------------------------------------------------------------------
procedure MostraFotoAluno()
//---------------------------------------------------------------------------
local aIndice:={}
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0)
local nPos := GetProperty ("TabWindow", cControle, "Value")
local aRet := GetProperty ("TabWindow", cControle, 'Item', nPos )

if empty(nPos) //se não foi selecionado um registro no grid
   msginfo("Selecione antes um registro para mostrar imagem do aluno.")
   return
endif

nPos:=len(&(aGridCampos)) //pega ultimo valor do grid onde se encontra o recno()
dbgoto(val(aRet[nPos]))

DEFINE WINDOW FrmImagem AT 0,0 WIDTH 300 HEIGHT 370 TITLE "Foto do(a) Aluno(a)" MODAL NOSIZE
  DEFINE IMAGE ImgAluno
     ROW    10
     COL    35
     WIDTH  200
     HEIGHT 225
     PICTURE rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto)
     TRANSPARENT .T.
  END IMAGE
  DEFINE LABEL Label_Nome
     ROW    245
     COL    25
     WIDTH  350
     HEIGHT 40
     VALUE alunos->alu_nome
     FONTNAME "Arial"
     FONTSIZE 10
     FONTBOLD .F.
     TRANSPARENT .T.
  END LABEL
  DEFINE LABEL Label_dados
     ROW    265
     COL    25
     WIDTH  250
     HEIGHT 40
     VALUE "Série: "+alltrim(setor->set_descri)+" - Nº."+turmas->tur_chamad 
     FONTNAME "Arial"
     FONTSIZE 10
     FONTBOLD .F.
     TRANSPARENT .T.
  END LABEL
END WINDOW
CENTER WINDOW FrmImagem
ACTIVATE WINDOW FrmImagem
Return

//---------------------------------------------------------------------------
function PopulaNotas()
//---------------------------------------------------------------------------
Local cSetorCodigo:=setor->set_codigo, cTurmacodigo:=turmas->tur_codigo, nSetorPonteiro:=setor->(recno()), nTurmaPonteiro:=turmas->(recno()),i,nTotalMediaAnual:=0

if (cCodFuncionario = cFuncionarioMaster) //não permite que funcionario master popule notas. Esse funcionario não pode ter aulas atribuídas.
   msgStop("O administrador do sistema não pode popular notas porque ele não pode ter aulas atribuídas. Se você tem aulas atribuídas, troque o código do usuário master para outro funcionário sem atribuição de aulas, como o Diretor ou o Coordenador.")
   return .f.
endif

if !setor->set_ehaula
   msgStop("Não pode popular nota para este setor. Se esse setor for sala de aula, marque 'É sala de aula' no cadastro do setor.")
   return .f.
endif

produtos->(dbsetorder(1)) //ordem de código
if !produtos->(dbseek(cEmpresa+setor->set_produt))  //o curso é imprescindível, pois através dele sabemos quantos bimestre tem o curso para podermos popular notas do conceito final
   msgstop("Curso = "+setor->set_produt+" não encontrado. Verifique.")
   return .f.
endif   

if msgyesno("Confirma popular notas para o "+if(val(cBimestreAtual)>=(val(produtos->pro_qtdbim)+1),"Conceito Final", cBimestreAtual+"º Bimestre")+" desta série? Obs. Os registros existentes não serão alterados.","",.f.)
   LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
   turmas->(dbsetorder(2)) //ordem de setor
   turmas->(dbseek(cEmpresa+cSetorCodigo))
   do while !Turmas->(eof()) .and. turmas->tur_setor = cSetorCodigo 
      nTotalMediaAnual:=0
      if (val(produtos->pro_qtdbim)=4 .and. cBimestreAtual = "5") .or. (val(produtos->pro_qtdbim)=2 .and. cBimestreAtual = "3")
         for i = 1 to val(produtos->pro_qtdbim)
            notas->(dbseek(cEmpresa+turmas->tur_setor+cCodFuncionario+cCodCargo+cAnoLetivoAtual+strzero(i,1,0)+turmas->tur_chamad+turmas->tur_aluno))
            nTotalMediaAnual+=val(notas->not_nota)
         next i   
      endif
      if !notas->(dbseek(cEmpresa+turmas->tur_setor+cCodFuncionario+cCodCargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno)) 
          notas->(dbappend())
          replace notas->not_empre  with cEmpresa
          replace notas->not_codigo with strzero(notas->(recno()),6,0)
          replace notas->not_aluno  with turmas->tur_aluno
          replace notas->not_setor  with cSetorCodigo
          replace notas->not_bim    with cBimestreAtual
          replace notas->not_ano    with cAnoLetivoAtual
          replace notas->not_cargo  with cCodCargo
          replace notas->not_funcio with cCodFuncionario
          replace notas->not_chamad with turmas->tur_chamad
          if (val(produtos->pro_qtdbim)=4 .and. cBimestreAtual = "5") .or. (val(produtos->pro_qtdbim)=2 .and. cBimestreAtual = "3")
             if !(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) .or. alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual)) 
                replace notas->not_nota with strzero(round(nTotalMediaAnual/val(produtos->pro_qtdbim),1),1,0)
             endif
          endif   
      endif
      turmas->(dbskip(1))
   enddo   
   Determinacampos("NOTAS","FUNCAO")
   RefreshGrid(nTabPage)
else
   return .f.
endif
return .t.

//---------------------------------------------------------------------------
procedure PopulaItemConselho()
//---------------------------------------------------------------------------
Local cSetorCodigo:=conselho->con_setor, cTurmacodigo:=turmas->tur_codigo, nSetorPonteiro:=setor->(recno()), nTurmaPonteiro:=turmas->(recno())
consitem->(dbsetorder(2))
if msgyesno("CONFIRMA POPULAR ÍTENS DO CONSELHO PARA ESTA SÉRIE? OBS.: OS REGISTROS EXISTENTES NÃO SERÃO ALTERADOS.","",.f.)
   Turmas->(dbgotop())
   Do while !Turmas->(eof())
      if turmas->tur_setor = cSetorCodigo
         if !consitem->(dbseek(cEmpresa+conselho->con_codigo+turmas->tur_chamad+turmas->tur_aluno)) 
             consitem->(dbappend())
             replace consitem->cit_empre  with cEmpresa
             replace consitem->cit_codigo with strzero(consitem->(recno()),6,0)
             replace consitem->cit_conse  with conselho->con_codigo
             replace consitem->cit_aluno  with turmas->tur_aluno
             replace consitem->cit_chamad with turmas->tur_chamad
             replace consitem->cit_bim    with cBimestreAtual
             replace consitem->cit_ano    with cAnoLetivoAtual
         endif
      endif
      turmas->(dbskip(1))
   enddo   
   RefreshGrid(nTabPage)
endif
Return

//---------------------------------------------------------------------------
Procedure MostraConselho()
//---------------------------------------------------------------------------
Local aList:={"atribuir", "funciona", {|| atribuir->atr_setor = conselho->con_setor}, {|| alltrim(funciona->fun_codigo)+"-"+funciona->fun_nome}}
Private lAlteraGrid:=lAlteraCtrls:=.f., tInicial:= Seconds() 
Private bColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , { 219,219,219 } , { 255,255,255 } ) }	
Private cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:="-", cRegNumeroBimAtual:=""
Private nTotalAnualAlunoFaltas:=nTotalAnualNotaClasse:=nTotalAnualProfClasse:=nTotalAnualNotaAluno:=nTotalAnualProfAluno:=nTotalBimNotaClasse:=nTotalBimProfClasse:=0
Private cConsitemMemoField:="", nQtNotaAzul:=nQtNotaVerm:=0
Private lMencaoA, lMencaoAA, lMencaoB, lMencaoC, lMencaoD, lMencaoE, lMencaoF, lMencaoG, lMencaoH, lMencaoI, lMencaoJ, lMencaoK, lMencaoL
if !consitem->(dbseek(cEmpresa+conselho->con_codigo))
   msgExclamation("ITEM DO CONSELHO NÃO ENCONTRADO. FAVOR POPULAR ITENS DO CONSELHO.")
   return
endif

if !(conselho->con_bim = cBimestreAtual)
   msgExclamation("CONSELHO SELECIONADO NÃO CORRESPONDE AO BIMESTRE ATUAL. FAVOR CRIAR NOVO CONSELHO.")
   return
endif

bColumnColor2:=bColumnColor4:=bColumnColor6:=bColumnColor8:=bColumnColor10:={|| if(val(this.cellvalue)>4,{0,0,255},{255,0,0})}  //muda coluna 3 (médias) para vermelho se menor que 5 e azul se maior que 4	
turmas->(dbsetorder(3)) //ordem de aluno
notas->(dbsetorder(1)) //empresa+setor+ano+bimestre --> esse é o único índice de Notas
produtos->(dbsetorder(1))
atribuir->(dbsetorder(2))
mencoes->(dbsetorder(1))
DEFINE WINDOW FrmConselho AT 10,5 WIDTH 810 HEIGHT 610 MODAL /*BACKCOLOR {229,229,229}*/  NOCAPTION
   *ON KEY F8 ACTION MOSTRANOTAS(.f.)   //mostra notas do ano anterior
   DEFINE LABEL LblNomeTela
      ROW    01
      COL    202
      WIDTH  420
      HEIGHT 40
      VALUE "Conselho de Classe - "+cBimestreAtual+"º Bimestre de "+cAnoLetivoAtual
      FONTNAME "Arial"
      FONTSIZE 15
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE TIMER Timer_1 INTERVAL 1000 ACTION minutos(substr(time(),1,5))
   DEFINE LABEL lblTimer
      ROW    01
      COL    720
      WIDTH  80
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE IMAGE Cronometro
      ROW    01
      COL    682
      picture "TIMER"
      WIDTH  35
      HEIGHT 35
   END IMAGE   
   DEFINE LABEL LblIDSetor01
      ROW    23
      COL    200
      WIDTH  50
      HEIGHT 40
      VALUE "Setor: "
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      VISIBLE .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor02
      ROW    23
      COL    253
      WIDTH  50
      HEIGHT 40
      VALUE alltrim(setor->set_descri)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      VISIBLE .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor03
      ROW    23
      COL    300
      WIDTH  62
      HEIGHT 40
      VALUE "Sala: "
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor04
      ROW    23
      COL    347
      WIDTH  62
      HEIGHT 40
      VALUE alltrim(setor->set_sala)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor05
      ROW    23
      COL    390
      WIDTH  70
      HEIGHT 40
      VALUE "Período: "
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor06
      ROW    23
      COL    461
      WIDTH  62
      HEIGHT 40
      VALUE alltrim(setor->set_period)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor07
      ROW    23
      COL    545
      WIDTH  62
      HEIGHT 40
      VALUE "Tipo: "
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor08
      ROW    23
      COL    590
      WIDTH  62
      HEIGHT 40
      VALUE alltrim(produtos->pro_descri)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T.
   END LABEL
   DEFINE FRAME Frame_1
      ROW    40
      COL    01
      WIDTH  798
      HEIGHT 559
      OPAQUE .T.
   END FRAME
   DEFINE FRAME Frame_2
      ROW    42
      COL    03
      WIDTH  792
      HEIGHT 95
      OPAQUE .T.
   END FRAME
   DEFINE LABEL LblProfs
      ROW    45
      COL    05
      WIDTH  100
      HEIGHT 20
      VALUE "PROFESSORES:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE IMAGE Prof01
      ROW    60
      COL    08
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
    END IMAGE
   DEFINE LABEL LblProf01
      ROW    122
      COL    09
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}  
   END LABEL
   DEFINE FRAME FrameProf01
      ROW    58
      COL    07
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof02
      ROW    60
      COL    64
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf02
      ROW    122
      COL    65
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf02
      ROW    58
      COL    63
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof03
      ROW    60
      COL    120
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf03
      ROW    122
      COL    121
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf03
      ROW    58
      COL    119
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof04
      ROW    60
      COL    176
      WIDTH  50
      HEIGHT 73
      STRETCH .T.   
   END IMAGE
   DEFINE LABEL LblProf04
      ROW    122
      COL    177
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf04
      ROW    58
      COL    175
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof05
      ROW    60
      COL    232
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf05
      ROW    122
      COL    232.5
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf05
      ROW    58
      COL    231            
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof06
      ROW    60
      COL    288
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf06
      ROW    122
      COL    288
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf06
      ROW    58
      COL    287
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof07
      ROW    60
      COL    344
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf07
      ROW    122
      COL    344
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf07
      ROW    58
      COL    343
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof08
      ROW    60
      COL    400
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf08
      ROW    122
      COL    400
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf08
      ROW    58
      COL    399
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof09
      ROW    60
      COL    456
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf09
      ROW    122
      COL    456
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf09
      ROW    58
      COL    455
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof10
      ROW    60
      COL    512
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf10
      ROW    122
      COL    512
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf10
      ROW    58
      COL    511
      WIDTH  53 
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof11
      ROW    60
      COL    568
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf11
      ROW    122
      COL    568
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf11
      ROW    58
      COL    567
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof12
      ROW    60
      COL    624
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf12
      ROW    122
      COL    624
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf12
      ROW    58
      COL    623
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof13
      ROW    60
      COL    680
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf13
      ROW    122
      COL    680
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf13
      ROW    58
      COL    679
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE Prof14
      ROW    60
      COL    735
      WIDTH  50
      HEIGHT 73
      STRETCH .T.
   END IMAGE
   DEFINE LABEL LblProf14
      ROW    122
      COL    735
      WIDTH  50
      HEIGHT 10
      FONTNAME "Arial"
      FONTSIZE 7
      FONTBOLD .T.
      *BACKCOLOR {229,229,229}
   END LABEL
   DEFINE FRAME FrameProf14
      ROW    58
      COL    734
      WIDTH  53
      HEIGHT 77
   END FRAME
   DEFINE IMAGE SetaProfCoord
      ROW    37
      COL    12
      WIDTH  15
      HEIGHT 15
      PICTURE "SETABAIXO"
   END IMAGE
   DEFINE FRAME Frame_3
      ROW    137
      COL    03
      WIDTH  191
      HEIGHT 360
   END FRAME 
   DEFINE IMAGE ImgAluno
      ROW    141
      COL    05
      WIDTH  185
      HEIGHT 255
      STRETCH .T.
      PICTURE rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto)
   END IMAGE
   DEFINE LABEL LblIDAluno
      ROW    400
      COL    05
      WIDTH  186
      HEIGHT 15 
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
      ALIGNMENT CENTER
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblIDChamada
      ROW    417
      COL    70
      WIDTH  80
      HEIGHT 20
      VALUE "Nº: "+substr(turmas->tur_chamad,1,2)
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblIdade
      ROW    440
      COL    40
      WIDTH  120
      HEIGHT 20
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblStatus
      ROW    460
      COL    04
      WIDTH  186
      HEIGHT 34
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE TEXTBOX txtNotas1Bim
      ROW    140
      COL    234
      WIDTH  57
      HEIGHT 18
      VALUE "  1º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas2Bim
      ROW    140
      COL    290
      WIDTH  57
      HEIGHT 18
      VALUE "  2º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas3Bim
      ROW    140
      COL    346
      WIDTH  57
      HEIGHT 18
      VALUE "  3º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas4Bim
      ROW    140
      COL    402
      WIDTH  57
      HEIGHT 18
      VALUE "  4º BIM  "
      READONLY .T.
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas5Bim
      ROW    140
      COL    458
      WIDTH  29
      HEIGHT 18
      VALUE "  5º "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtAulasPrevistasDadas
      ROW    140
      COL    486
      WIDTH  65
      HEIGHT 18
      VALUE "  AULAS"
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtMencoes
      ROW    140
      COL    550
      WIDTH  241
      HEIGHT 18
      VALUE "    CAUSAS E ENCAMINHAMENTOS "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL

   DEFINE GRID Grd_Notas
      ROW 156
      COL 195
      WIDTH  598
      HEIGHT 278
      VALUE 0
      ALLOWEDIT .T.
      LOCKCOLUMNS 1 
      MULTISELECT .T.
      ITEMS nil
      HEADERS {'Mat','N','F','N','F','N','F','N','F','N','PR','DA','','a','b','c','d','e','f','g','h','i','j','k','l','','','','',''}
      WIDTHS {38,28,28,28,28,28,28,28,28,28,32,32,0,20,20,20,20,20,20,20,20,20,20,20,20,0,0,0,0,0}
      FONTNAME "Verdana"
      FONTSIZE 8.5
      FONTBOLD .T.
      COLUMNVALID {{||.t.},;
      {|| val(this.cellvalue)<=10},;
      {||.t.},;
      {|| val(this.cellvalue)<=10},;
      {||.t.},;
      {|| val(this.cellvalue)<=10},;
      {||.t.},;
      {|| val(this.cellvalue)<=10},;
      {||.t.},;
      {|| val(this.cellvalue)<=10},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.}} //valida os dados inputados pelo operador
      COLUMNWHEN {{||.f.},;
      if(cBimestreAtual="1",{||.t.},{||.f.}),;
      if(cBimestreAtual="1",{||.t.},{||.f.}),;
      if(cBimestreAtual="2",{||.t.},{||.f.}),;
      if(cBimestreAtual="2",{||.t.},{||.f.}),;
      if(cBimestreAtual="3" .or. (cBimestreAtual="2" .and. val(produtos->pro_qtdbim)=val(cBimestreAtual)),{||.t.},{||.f.}),;
      if(cBimestreAtual="3" .or. (cBimestreAtual="2" .and. val(produtos->pro_qtdbim)=val(cBimestreAtual)),{||.t.},{||.f.}),;
      if(cBimestreAtual="4",{||.t.},{||.f.}),;
      if(cBimestreAtual="4",{||.t.},{||.f.}),;
      if(cBimestreAtual="4",{||.t.},{||.f.}),;
      {||.t.},;
      {||.t.},;
      {||.f.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.t.},;
      {||.f.},;
      {||.f.},;
      {||.f.},;
      {||.f.},;
      {||.f.}} // quais colunas serão editáveis
      DYNAMICFORECOLOR {bColumnColor1,bColumnColor2,bColumnColor3,bColumnColor4,bColumnColor5,bColumnColor6,bColumnColor7,bColumnColor8,bColumnColor9,bColumnColor10,bColumnColor11,bColumnColor12,bColumnColor13,bColumnColor14,bColumnColor15,bColumnColor16,bColumnColor17,bColumnColor18,bColumnColor19,bColumnColor20,bColumnColor21,bColumnColor22,bColumnColor23,bColumnColor24,bColumnColor25,bColumnColor26,bColumnColor27,bColumnColor28,bColumnColor29,bColumnColor30} //diz qual a cor de cada coluna do grid, mudada no módulo funções
      DYNAMICBACKCOLOR { bColor , bColor , bColor , bColor , bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor, bColor}
      COLUMNCONTROLS {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'CHECKBOX','s','·'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
      ONCHANGE (lAlteraGrid:=.t.)   
      ON HEADCLICK {{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| MARCATODOS(14)},{|| MARCATODOS(15)},{|| MARCATODOS(16)},{|| MARCATODOS(17)},{|| MARCATODOS(18)},{|| MARCATODOS(19)},{|| MARCATODOS(20)},{|| MARCATODOS(21)},{|| MARCATODOS(22)},{|| MARCATODOS(23)},{|| MARCATODOS(24)},{|| MARCATODOS(25)},{|| .F.},{|| .F.},{|| .F.},{|| .F.},{|| .F.}}  
   END GRID   
   DEFINE FRAME FrameTotalFaltas
      ROW    440
      COL    198
      WIDTH  61
      HEIGHT 89
   END FRAME 
   DEFINE FRAME FrameTotalFaltasBim
      ROW    455
      COL    200
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE FRAME FrameTotalFaltasAno
      ROW    491
      COL    200
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE LABEL LblTotalFaltasBimestreTitulo
      ROW    443
      COL    204
      WIDTH  60
      HEIGHT 15
      VALUE "FALTAS"
      FONTNAME "Verdana"
      FONTSIZE 8.5
      FONTBOLD .T.
      FONTCOLOR {97,97,97}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblTotalFaltasBimestre
      ROW    456
      COL    200
      WIDTH  60
      HEIGHT 15
      VALUE "BIMESTR"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblTotalFaltasAno
      ROW    493
      COL    212
      WIDTH  60
      HEIGHT 20
      VALUE "ANO"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblTotalFaltasBimestre01
      ROW    471
      COL    214
      WIDTH  30
      HEIGHT 17
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblTotalFaltasAno01
      ROW    507
      COL    214
      WIDTH  30
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL
   DEFINE FRAME FrameMedias
      ROW    440
      COL    263
      WIDTH  61
      HEIGHT 89
   END FRAME 
   DEFINE FRAME FrameMediaAluno
      ROW    455
      COL    265
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE FRAME FrameMediaClasse
      ROW    491
      COL    265
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE LABEL LblMediaAlunoTitulo
      ROW    443
      COL    266
      WIDTH  60
      HEIGHT 15
      VALUE "MÉD.BIM"
      FONTNAME "Verdana"
      FONTSIZE 8.5
      FONTBOLD .T.
      FONTCOLOR {97,97,97}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblMediaAluno
      ROW    456
      COL    270
      WIDTH  60
      HEIGHT 15
      VALUE "ALUNO"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblMediaClasse
      ROW    493
      COL    270
      WIDTH  60
      HEIGHT 20
      VALUE "CLASSE"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblMediaAluno01
      ROW    471
      COL    279
      WIDTH  30
      HEIGHT 17
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblMediaClasse01
      ROW    507
      COL    279
      WIDTH  30
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL
   DEFINE FRAME FrameAnual
      ROW    440
      COL    328
      WIDTH  61
      HEIGHT 89
   END FRAME 
   DEFINE FRAME FrameAnualAluno
      ROW    455
      COL    330
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE FRAME FrameAnualClasse
      ROW    491
      COL    330
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE LABEL LblAnualAlunoTitulo
      ROW    443
      COL    329
      WIDTH  60
      HEIGHT 15
      VALUE "MÉD.ANU"
      FONTNAME "Verdana"
      FONTSIZE 8.5
      FONTBOLD .T.
      FONTCOLOR {97,97,97}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblAnualAluno
      ROW    456
      COL    335
      WIDTH  60
      HEIGHT 15
      VALUE "ALUNO"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblAnualClasse
      ROW    493
      COL    335
      WIDTH  60
      HEIGHT 20
      VALUE "CLASSE"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblAnualAluno01
      ROW    471
      COL    344
      WIDTH  30
      HEIGHT 17
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblAnualClasse01
      ROW    507
      COL    344
      WIDTH  30
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      TRANSPARENT .T. 
   END LABEL

   DEFINE FRAME FrameQtdeNotas
      ROW    440
      COL    393
      WIDTH  61
      HEIGHT 89
   END FRAME 
   DEFINE FRAME FrameQtdeAzul
      ROW    455
      COL    395
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE FRAME FrameQtdeVermelha
      ROW    491
      COL    395
      WIDTH  57
      HEIGHT 35
   END FRAME 
   DEFINE LABEL LblQtdeNotas
      ROW    443
      COL    395
      WIDTH  60
      HEIGHT 15
      VALUE "QTD.NOT"
      FONTNAME "Verdana"
      FONTSIZE 8.5
      FONTBOLD .T.
      FONTCOLOR {97,97,97}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblQtdeAzul
      ROW    456
      COL    405
      WIDTH  60
      HEIGHT 15
      VALUE "AZUL"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblQtdeVermelha
      ROW    493
      COL    396
      WIDTH  60
      HEIGHT 20
      VALUE "VERMEL."
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblQtAzul01
      ROW    471
      COL    408
      WIDTH  30
      HEIGHT 17
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {0,0,255}
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblQtVerm01
      ROW    507
      COL    408
      WIDTH  30
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 9
      FONTBOLD .T.
      FONTCOLOR {255,0,0}
      TRANSPARENT .T. 
   END LABEL

   DEFINE LABEL LblCausas
      ROW    438
      COL    458
      WIDTH  100
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      VALUE "CAUSAS"
      TRANSPARENT .T. 
   END LABEL
   DEFINE LABEL LblEncaminhamentos
      ROW    438
      COL    627
      WIDTH  130
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      FONTCOLOR {64,162,21}
      VALUE "ENCAMINHAMENTOS"
      TRANSPARENT .T. 
   END LABEL
   DEFINE LISTBOX LISTCAUSAS
      ROW 450
      COL 458
      WIDTH 165
      HEIGHT 90
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   END LISTBOX      

   DEFINE LISTBOX LISTENCAMINHAMENTOS
      ROW 450
      COL 627
      WIDTH 165
      HEIGHT 90
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   END LISTBOX      

   DEFINE FRAME Frame_4
      ROW    436
      COL    196
      WIDTH  601
      HEIGHT 320
      OPAQUE .T.
   END FRAME
   DEFINE CHECKBOX Chk_Parabens
      ROW    538
      COL    200
      WIDTH  90
      HEIGHT 28
      VALUE .F.
      CAPTION "PARABÉNS !!!"
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
      ONGOTFOCUS (lAlteraCtrls:=.t.)
      TRANSPARENT .T. 
   END CHECKBOX
   DEFINE CHECKBOX Chk_Evadido
      ROW    538
      COL    315
      WIDTH  90
      HEIGHT 28
      VALUE .F.
      CAPTION "EVADIDO"
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
      ONGOTFOCUS (lAlteraCtrls:=.t.)
      TRANSPARENT .T. 
   END CHECKBOX
   DEFINE LABEL LblHipoteses
      ROW    572
      COL    200
      WIDTH  130
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
      VALUE "HIPÓTESES"
      TRANSPARENT .T. 
   END LABEL
   DEFINE COMBOBOX Combo_Hipotese
      ROW    565
      COL    270
      WIDTH  150
      HEIGHT 130
      ITEMS {' ','PRÉ-SILÁBICO','SILÁBICO Ñ.SONORO','SIL.VLR.SONORO','SILÁB.ALFABÉTICO','ALFABÉTICO'}
      VALUE 0
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .T.
      TABSTOP .T.
      ONGOTFOCUS (lAlteraCtrls:=.t.)
   END COMBOBOX
   DEFINE LABEL LblSituacao
      ROW    572
      COL    447
      WIDTH  130
      HEIGHT 16
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
      VALUE "SITUAÇÃO"
      TRANSPARENT .T.
   END LABEL
   DEFINE COMBOBOX Combo_Situacao
      ROW    565
      COL    510
      WIDTH  130
      HEIGHT 68
      ITEMS {' ','PROMOVIDO','RETIDO','PROM.PARCIAL','PROM.CONSELHO','PROM.PROGRESSÃO'}
      VALUE 0
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .T.
      TABSTOP .T.
      ONGOTFOCUS (lAlteraCtrls:=.t.)
      TRANSPARENT .T.
   END COMBOBOX
   DEFINE LABEL LblSliderIndisci
      ROW    541
      COL    665
      WIDTH  90
      HEIGHT 15
      VALUE "INDISCIPLINA"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE SLIDER SliderIndisci
      ROW    552
      COL    640
      WIDTH  145
      HEIGHT 22
      RANGEMIN 0
      RANGEMAX 4
      VALUE 0
      TOOLTIP "INDISCIPLINA: 1=PERTURBA-SE; 2=PERTURBA-SE E OS PARES; 3=PERTURBA-SE, OS PARES E O PROFESSOR; 4=INDISCIPLINA GRAVISSIMA"
      ONCHANGE (if(this.value<>val(consitem->cit_indis1),(lAlteraCtrls:=.t.),nil))
      HELPID Nil
      *BACKCOLOR {225,226,236} 
   END SLIDER
   DEFINE LABEL LblSliderMarcador0
      ROW    575
      COL    650
      WIDTH  20
      HEIGHT 15
      VALUE "0   "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      BACKCOLOR {169,252,133}
   END LABEL
   DEFINE LABEL LblSliderMarcador1
      ROW    575
      COL    670
      WIDTH  28
      HEIGHT 15
      VALUE "    1   "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      BACKCOLOR {251,248,134}
   END LABEL
   DEFINE LABEL LblSliderMarcador2
      ROW    575
      COL    700
      WIDTH  28
      HEIGHT 15
      VALUE "    2   "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      BACKCOLOR {253,192,132}
   END LABEL
   DEFINE LABEL LblSliderMarcador3
      ROW    575
      COL    727
      WIDTH  27
      HEIGHT 15
      VALUE "   3 "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      BACKCOLOR {255,130,130}
   END LABEL
   DEFINE LABEL LblSliderMarcador4
      ROW    575
      COL    750
      WIDTH  27
      HEIGHT 15
      VALUE "   4 "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      BACKCOLOR {255,0,0}
   END LABEL
   DEFINE BUTTON ButtonObservacao
      ROW    500
      COL    33
      WIDTH  50
      HEIGHT 40
      ACTION ObservacaoItemConselho()
      PICTURE "OBSERVA"
      TOOLTIP "OBSERVAÇÃO SOBRE ALUNO"
      FLAT .T. 
   END BUTTON
   DEFINE BUTTON ButtonOcorrencias
      ROW    500
      COL    103
      WIDTH  50
      HEIGHT 40
      ACTION MostraOcorrencias()
      PICTURE "OCOORENCIAS"
      TOOLTIP "OCORRÊNCIAS DO BIMESTRE"
      FLAT .T.
   END BUTTON
   DEFINE BUTTON Button_Inicio
      ROW    543
      COL    06
      WIDTH  25
      HEIGHT 22
      CAPTION "<<"
      ACTION SelecionaItemConselho("PRIMEIRO")
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.
   END BUTTON

   DEFINE BUTTON Button_Anterior
      ROW    543
      COL    29
      WIDTH  25
      HEIGHT 22
      CAPTION "<"
      ACTION SelecionaItemConselho("ANTERIOR")
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.
   END BUTTON
   DEFINE BUTTON Button_Proximo
      ROW    543
      COL    56
      WIDTH  25
      HEIGHT 22
      CAPTION ">"
      ACTION SelecionaItemConselho("PROXIMO")
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.
   END BUTTON
   DEFINE BUTTON Button_Fim
      ROW    543
      COL    83
      WIDTH  25
      HEIGHT 22
      CAPTION ">>"
      ACTION SelecionaItemConselho("FIM")
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.
   END BUTTON
   DEFINE LABEL LblBuscaChamada
      ROW    545
      COL    118
      WIDTH  15
      HEIGHT 18
      FONTNAME "Arial"
      VALUE "Nº"
      FONTSIZE 8.5
      FONTBOLD .T.
      TRANSPARENT .T. 
   END LABEL
   DEFINE TEXTBOX txtBuscaChamada
      ROW    543
      COL    132
      WIDTH  25
      HEIGHT 18
      FONTNAME "Arial"
      FONTSIZE 8.5
      FONTBOLD .T.
   END TEXTBOX
   DEFINE BUTTON Button_Busca
      ROW    543
      COL    159
      WIDTH  23
      HEIGHT 20
      CAPTION "P"
      ACTION SelecionaItemConselho("BUSCA")
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .T.
   END BUTTON

   DEFINE BUTTON Button_Salva
      ROW    568
      COL    06
      WIDTH  85
      HEIGHT 22
      CAPTION "SALVA"
      ACTION SelecionaItemConselho("SALVAR")
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.   
   END BUTTON
   DEFINE BUTTON Button_Sai
      ROW    568
      COL    95
      WIDTH  85
      HEIGHT 22
      CAPTION "SAIR"
      ACTION SairConselho()
      FONTNAME "Arial"
      FONTSIZE 9
      FONTBOLD .T.
   END BUTTON
END WINDOW
CENTER WINDOW FrmConselho
SomaClasseBimAtual()
if conselho->con_fecha
   setproperty("FrmConselho","Grd_Notas","Enabled", .f.)
   setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
   setproperty("FrmConselho","Chk_Parabens","Enabled", .f.)
   setproperty("FrmConselho","Chk_Evadido","Enabled", .f.)
   setproperty("FrmConselho","Grd_Notas","Enabled", .f.)
   setproperty("FrmConselho","Button_Salva","Enabled", .f.)
   setproperty("FrmConselho","SliderIndisci","Enabled", .f.)
   setproperty("FrmConselho","LblSliderIndisci","Enabled", .f.)
   setproperty("FrmConselho","LblSliderMarcador0","Enabled", .f.)
   setproperty("FrmConselho","LblSliderMarcador1","Enabled", .f.)
   setproperty("FrmConselho","LblSliderMarcador2","Enabled", .f.)
   setproperty("FrmConselho","LblSliderMarcador3","Enabled", .f.)
   setproperty("FrmConselho","LblSliderMarcador4","Enabled", .f.)
   setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
   setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
endif
mencoes->(dbgotop())
do while !mencoes->(eof())
   if alltrim(mencoes->men_tipo)="CAUSAS"
      FrmConselho.ListCausas.additem(mencoes->men_letra+' - '+mencoes->men_descri) 
      mencoes->(dbskip())
   else
      FrmConselho.ListEncaminhamentos.additem(mencoes->men_letra+' - '+mencoes->men_descri) 
      mencoes->(dbskip())
   endif
enddo   
if !(val(cBimestreAtual)==val(produtos->pro_qtdbim))  //não mostra este controle se não for o último bimestre
   setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
endif
SelecionaItemConselho("PRIMEIRO")
ACTIVATE WINDOW FrmConselho
Return

//----------------------------------------------------------------------------------------------------------------------------
Function Marcatodos(nColuna) //inverte valor da coluna inteira do grid
//----------------------------------------------------------------------------------------------------------------------------
Local i, aItemGrid:={}
for i = 1 to FrmConselho.Grd_Notas.itemcount
   aItemGrid:=FrmConselho.Grd_Notas.item(i)
   if aItemGrid[nColuna]
      aItemGrid[nColuna]:=.f.
   else
      aItemGrid[nColuna]:=.t.
   endif
   FrmConselho.Grd_Notas.item(i):=aItemGrid
next i
doMethod("FrmConselho","Grd_notas","REFRESH")          
lAlteraGrid:=.t.  //força o status de componentes alterados, pois o grid não aciona o método ONCHANGE quando clicado no seu Header   
return .t.    

//----------------------------------------------------------------------------------------------------------------------------
Procedure ObservacaoItemConselho()
//----------------------------------------------------------------------------------------------------------------------------
Local lAlteraEdita:=.f.
DEFINE WINDOW FrmObserva AT 0,0 WIDTH 320 HEIGHT 210 TITLE "Observação sobre o Aluno" MODAL /*backcolor {229,229,229}*/ NOSIZE
  DEFINE EDITBOX EditaObserva
     ROW    10
     COL    02
     WIDTH  305
     HEIGHT 130
     VALUE cConsitemMemoField
     FONTNAME "Verdana"
     HSCROLLBAR .F.
     FONTSIZE 9
     FONTBOLD .T.
     TRANSPARENT .T.
     ONCHANGE (lAlteraCtrls:=lAlteraEdita:=.t.) 
  END EDITBOX
 
  DEFINE BUTTON Button_Salva
     ROW    150
     COL    50
     WIDTH  85
     HEIGHT 22
     CAPTION "SALVA"
     ACTION {|| cConsitemMemoField:=FrmObserva.EditaObserva.value,lAlteraEdita:=.f.}
     FONTNAME "Arial"
     FONTSIZE 9
     FONTBOLD .T.
  END BUTTON
  DEFINE BUTTON Button_Sai
     ROW    150
     COL    145
     WIDTH  85
     HEIGHT 22
     CAPTION "SAIR"
     ACTION if(lAlteraEdita,if(msgyesno("Volta para salvar alteração na observação?","",.f.),.t.,FrmObserva.release),FrmObserva.release)
     FONTNAME "Arial"
     FONTSIZE 9
     FONTBOLD .T.
  END BUTTON
END WINDOW
center window FrmObserva
ACTIVATE WINDOW FrmObserva
return

//----------------------------------------------------------------------------------------------------------------------------
procedure mostraocorrencias()
//----------------------------------------------------------------------------------------------------------------------------
return

//----------------------------------------------------------------------------------------------------------------------------
procedure SomaClasseBimAtual()  //calcula somatória da classe toda de notas dadas e professores que deram nota (não soma professores que não atribuiram nota))
//----------------------------------------------------------------------------------------------------------------------------
nTotalBimNotaClasse:=nTotalBimProfClasse:=nQtNotaAzul:=nQtNotaVerm:=0
notas->(dbsetorder(2))  //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR
notas->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+conselho->con_setor))
do while !notas->(eof()) .and. notas->not_setor = conselho->con_setor .and. notas->not_ano = cAnoLetivoAtual .and. notas->not_bim = cBimestreAtual
   if !empty(notas->not_nota)
      nTotalBimNotaClasse+=val(alltrim(notas->not_nota))
      nTotalBimProfClasse++
      if val(notas->not_nota)>=5
         nQtNotaAzul++
      else
         nQtNotaVerm++
      endif   
   endif
   notas->(dbskip(1))
enddo   
notas->(dbsetorder(1))  //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR
return

//----------------------------------------------------------------------------------------------------------------------------
procedure SomaMediaClasseAlunoAnual(pAlunoAtual) //calcula média anual da sala e do aluno em questão 
//----------------------------------------------------------------------------------------------------------------------------
Local nHandle, nRegConselhoAnt:=conselho->(recno()), nRegConsitemAnt:=consitem->(recno())

*if (nHandle:=fCreate("arq")) == -1
*   msginfo("Erro ao criar arquivo. Veja se não está em uso, se a pasta c:\escola está criada e você tem direito de acesso a ela.")
*   return
*endif
nTotalAnualAlunoFaltas:=nTotalAnualNotaAluno:=nTotalAnualProfAluno:=nTotalAnualNotaClasse:=nTotalAnualProfClasse:=0
notas->(dbsetorder(3))
notas->(dbseek(cEmpresa+conselho->con_ano+conselho->con_setor))
do while !notas->(eof()) .and. notas->not_ano = conselho->con_ano .and. notas->not_setor = conselho->con_setor
   if !empty(notas->not_nota)
      if val(notas->not_bim)<=val(produtos->pro_qtdbim) //calcula média anual até último mês do bimestre, desprezando as notas do conceito final 
         nTotalAnualNotaClasse+=val(alltrim(notas->not_nota))
         nTotalAnualProfClasse++
*         fwrite(nHandle, alltrim(notas->not_nota)+chr(13))
         if notas->not_aluno = pAlunoAtual .and. notas->not_chamad = consitem->cit_chamad  //verifica também o nro.de chamada, pois o mesmo aluno pode ser matriculado duas vezes na mesma turma
            nTotalAnualNotaAluno+=val(alltrim(notas->not_nota))
            nTotalAnualProfAluno++
            nTotalAnualAlunoFaltas+=val(alltrim(notas->not_faltas))
         endif
      endif
   endif
   notas->(dbskip(1))
enddo   
conselho->(dbgoto(nRegConselhoAnt))
consitem->(dbgoto(nRegConsitemAnt))
notas->(dbsetorder(1))
*fClose(nHandle)
return

//----------------------------------------------------------------------------------------------------------------------------
Procedure SelecionaItemConselho(pAcao)
//----------------------------------------------------------------------------------------------------------------------------                                               
Local aGridCam1:="{cargos->car_resumo,cNota1Bim,cFaltas1Bim,cNota2Bim,cFaltas2Bim,cNota3Bim,cFaltas3Bim,cNota4Bim,cFaltas4Bim,cNota5Bim,capabime->cap_aulapr,capabime->cap_aulada,lMencaoA,lMencaoAA,lMencaoB,lMencaoC,lMencaoD,lMencaoE,lMencaoF,lMencaoG,lMencaoH,lMencaoI,lMencaoJ,lMencaoK,lMencaoL,funciona->fun_codigo,cargos->car_codigo,notas->not_empre+notas->not_setor+notas->not_funcio+notas->not_cargo+notas->not_ano+notas->not_bim+notas->not_chamad+notas->not_aluno,notas->not_empre+notas->not_setor+notas->not_funcio+notas->not_cargo+notas->not_ano+strzero(val(produtos->pro_qtdbim)+1,1,0)+notas->not_chamad+notas->not_aluno,cRegNumeroBimAtual}"
Local i, aItemGrid:={} 
Local nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=nContaProfAtribuicao:=0, nRecAntConsitem
Local lMencaoA:=lMencaoAA:=lMencaoB:=lMencaoC:=lMencaoD:=lMencaoE:=lMencaoF:=lMencaoG:=lMencaoH:=lMencaoI:=lMencaoJ:=lMencaoK:=lMencaoL:=.F.
Local nNroConsitem, dDataLimBimTemp, lContinua

cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:=" "
notas->(dbsetorder(1))

if pAcao = "PROXIMO"
   if !conselho->con_fecha
      if lAlteraGrid .or. lAlteraCtrls
         msgExclamation("SALVE ALTERAÇÕES ANTES DE PROSSEGUIR")
         return
      endif   
   endif
   consitem->(dbskip(1))
   SomaMediaClasseAlunoAnual(consitem->cit_aluno)
elseif pAcao = "FIM"
   if !conselho->con_fecha
      if lAlteraGrid .or. lAlteraCtrls
         msgExclamation("SALVE ALTERAÇÕES ANTES DE PROSSEGUIR")
         return
      endif   
   endif
   do while !consitem->(eof())
      if consitem->cit_conse <> conselho->con_codigo
         consitem->(dbskip(-1))
         exit
      else
         consitem->(dbskip(1))
      endif   
   enddo
   if consitem->(eof())
      consitem->(dbskip(-1))
   endif          
elseif pAcao = "BUSCA"
   if !conselho->con_fecha
      if lAlteraGrid .or. lAlteraCtrls
         msgExclamation("SALVE ALTERAÇÕES ANTES DE PROSSEGUIR")
         return
      endif   
   endif 
   nNroConsitem:=consitem->(recno())
   if !consitem->(dbseek(cEmpresa+conselho->con_codigo+strzero(val(getproperty("FrmConselho","TxtBuscaChamada","Value")),2,0)))
      msgbox("Número de Chamada inexistente.")
      consitem->(dbgoto(nNroConsitem))
      return
   endif   
   SomaMediaClasseAlunoAnual(consitem->cit_aluno)
elseif pAcao = "ANTERIOR"
   if !conselho->con_fecha
      if lAlteraGrid .or. lAlteraCtrls
         msgExclamation("SALVE ALTERAÇÕES ANTES DE PROSSEGUIR")
         return
      endif   
   endif 
   consitem->(dbskip(-1))
   SomaMediaClasseAlunoAnual(consitem->cit_aluno)
elseif pAcao = "PRIMEIRO"
   if !consitem->(dbseek(cEmpresa+conselho->con_codigo))
      msgExclamation("ITEM DO CONSELHO NÃO ENCONTRADO. FAVOR POPULAR ITENS DO CONSELHO.")
      return
   endif
   SomaMediaClasseAlunoAnual(consitem->cit_aluno)
elseif pAcao = "SALVAR"
   altd()
   if lAlteraGrid
      for i = 1 to FrmConselho.Grd_Notas.itemcount
         aItemGrid:=FrmConselho.Grd_Notas.item(i)
         cRegNumeroBimAtual:=aItemGrid[30]
         if !empty(cRegNumeroBimAtual) //se estiver em branco é porque professor não populou notas
            notas->(dbgoto(val(cRegNumeroBimAtual)))
            if !TentaAcesso("NOTAS");return;endif
            replace notas->not_nota   with aItemGrid[if(cBimestreAtual="1",2,if(cBimestreAtual="2",4,if(cBimestreAtual="3",6,if(cBimestreAtual="4",8,10))))]
            replace notas->not_faltas with aItemGrid[if(cBimestreAtual="1",3,if(cBimestreAtual="2",5,if(cBimestreAtual="3",7,09)))]
            *msgbox("aitemgrid[13]="+if(aitemgrid[13],".t.",".f."))
            replace notas->not_mencaa with aItemGrid[14]
            *msgbox("notas rec="+str(notas->(recno()))+" - Notas mencaa depois do replace="+if(notas->not_mencaa,".t.",".f."))
            replace notas->not_mencab with aItemGrid[15]
            replace notas->not_mencac with aItemGrid[16]
            replace notas->not_mencad with aItemGrid[17]
            replace notas->not_mencae with aItemGrid[18]
            replace notas->not_mencaf with aItemGrid[19]
            replace notas->not_mencag with aItemGrid[20]
            replace notas->not_mencah with aItemGrid[21]
            replace notas->not_mencai with aItemGrid[22]
            replace notas->not_mencaj with aItemGrid[23]
            replace notas->not_mencak with aItemGrid[24]
            replace notas->not_mencal with aItemGrid[25]
            notas->(dbunlockall())
         else
            notas->(dbappend())
            replace notas->not_empre  with cEmpresa
            replace notas->not_codigo with strzero(notas->(recno()),6,0)
            replace notas->not_aluno  with alunos->alu_codigo
            replace notas->not_setor  with setor->set_codigo
            replace notas->not_bim    with cBimestreAtual
            replace notas->not_ano    with cAnoLetivoAtual
            replace notas->not_cargo  with aitemGrid[27]
            replace notas->not_funcio with aitemGrid[26]
            replace notas->not_chamad with consitem->cit_chamad
            replace notas->not_nota   with aItemGrid[if(cBimestreAtual="1",2,if(cBimestreAtual="2",4,if(cBimestreAtual="3",6,if(cBimestreAtual="4",8,10))))]
            replace notas->not_faltas with aItemGrid[if(cBimestreAtual="1",3,if(cBimestreAtual="2",5,if(cBimestreAtual="3",7,09)))]
            replace notas->not_mencaa with aItemGrid[14]
            replace notas->not_mencab with aItemGrid[15]
            replace notas->not_mencac with aItemGrid[16]
            replace notas->not_mencad with aItemGrid[17]
            replace notas->not_mencae with aItemGrid[18]
            replace notas->not_mencaf with aItemGrid[19]
            replace notas->not_mencag with aItemGrid[20]
            replace notas->not_mencah with aItemGrid[21]
            replace notas->not_mencai with aItemGrid[22]
            replace notas->not_mencaj with aItemGrid[23]
            replace notas->not_mencak with aItemGrid[24]
            replace notas->not_mencal with aItemGrid[25]
         endif

         if val(produtos->pro_qtdbim)=val(cBimestreAtual)  //verifica se estamos no último bimestre e salva também nota do conceito final (posição 10 do grid) quando bimestre for o 2º ou 4º  
            if notas->(dbseek(aItemGrid[29]))   //busca por nota do conceito final
               if !TentaAcesso("NOTAS");return;endif
               replace notas->not_nota with aItemGrid[1+((val(produtos->pro_qtdbim)*2)+1)]  //
            else
               notas->(dbappend())
               replace notas->not_empre  with cEmpresa
               replace notas->not_codigo with strzero(notas->(recno()),6,0)
               replace notas->not_aluno  with alunos->alu_codigo
               replace notas->not_setor  with setor->set_codigo
               replace notas->not_bim    with if(val(produtos->pro_qtdbim)=2,"3","5")
               replace notas->not_ano    with cAnoLetivoAtual
               replace notas->not_cargo  with aitemGrid[27]
               replace notas->not_funcio with aitemGrid[26]
               replace notas->not_chamad with turmas->tur_chamad
               replace notas->not_nota   with aitemGrid[1+((val(produtos->pro_qtdbim)*2)+1)]
               replace notas->not_faltas with ""  //O conceito final não tem falta
            endif   
         endif 


         //Ordem de Capabime = CAPABIME->CAP_EMPR+CAPABIME->CAP_SETOR+CAPABIME->CAP_FUNCIO+CAPABIME->CAP_CARGO+CAPABIME->CAP_ANO+CAPABIME->CAP_BIM TAG TAG2 TO &(c_STR_Con+"CAPABIME.CDX")

         //salva o número de aulas previstas e dadas do grid no arquivo da Capa do Bimestre (Capabime)
         if capabime->(dbseek(cEmpresa+setor->set_codigo+aitemGrid[26]+aitemGrid[27]+cAnoLetivoAtual+cBimestreAtual))
            if !TentaAcesso("CAPABIME");return;endif
            replace capabime->cap_aulapr with aitemGrid[11]
            replace capabime->cap_aulada with aitemGrid[12]
            capabime->(dbunlockall())            
         else
            capabime->(dbappend())
            replace capabime->cap_empr   with cEmpresa
            replace capabime->cap_codigo with strzero(capabime->(recno()),6,0)
            replace capabime->cap_setor  with setor->set_codigo
            replace capabime->cap_bim    with cBimestreAtual
            replace capabime->cap_ano    with cAnoLetivoAtual
            replace capabime->cap_funcio with aitemGrid[26]
            replace capabime->cap_cargo  with aitemGrid[27]
            replace capabime->cap_aulapr with aitemGrid[11]
            replace capabime->cap_aulada with aitemGrid[12]
         endif
         nRecAntConsitem:=consitem->(recno())
         consitem->(dbgoto(nRecAntConsitem))
      next i         
      SomaClasseBimAtual()         
      SomaMediaClasseAlunoAnual(consitem->cit_aluno)

      lAlteraGrid:=.f.
   endif
   if !TentaAcesso("CONSITEM");return;endif   
   replace consitem->cit_indis1 with strzero(getproperty("FrmConselho", "SliderIndisci", "value"),1,0)
   replace consitem->cit_situac with getproperty("FrmConselho", "Combo_Situacao", "value")
   replace consitem->cit_observ with cConsitemMemoField
   replace consitem->cit_parabe with getproperty("FrmConselho", "Chk_Parabens", "value")
   if !TentaAcesso("ALUNOS");return;endif   
   replace alunos->alu_hipote   with getproperty("FrmConselho", "Combo_Hipotese", "value")
   if !TentaAcesso("TURMAS");return;endif   
   replace turmas->tur_evadid with getproperty("FrmConselho", "Chk_Evadido", "value")
   lAlteraCtrls:=.f.
   consitem->(dbunlockall())
   notas->(dbunlockall())
   alunos->(dbunlockall())
   turmas->(dbunlockall())
else
   msgExclamation("Ação não encontrada.")
   return
endif
setproperty("FrmConselho","TxtBuscaChamada","Value","")
cConsitemMemoField:=consitem->cit_observ

if !produtos->(dbseek(cEmpresa+setor->set_produt))
   msgExclamation("Não encontrei curso.")
endif
delete item all from Grd_Notas of FrmConselho
if consitem->cit_empre = cEmpresa .and. consitem->cit_conse = conselho->con_codigo
   if !atribuir->(dbseek(cEmpresa+conselho->con_setor))
      msgStop("Não encontrei Atribuição de professores. Entre em contato com o administrador do sistema.")
   endif
   do while !atribuir->(eof()) .and. atribuir->atr_setor = conselho->con_setor
      cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:=" "
      cRegNumeroBimAtual:=""

      if !cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
         msgStop("PAREI! Não encontrei cargo. Contatar administrador do sistema.")
         return
      endif 
      if !funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
         msgStop("PAREI! Não encontrei funcionário. Contatar administrador do sistema.")
         return
      endif 
      
      notas->(dbsetorder(4)) //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_ALUNO+NOTAS->NOT_CARGO+NOTAS->NOT_CHAMAD

      for i = 1 to (val(produtos->pro_qtdbim)+1) //pega as notas de todos os bimestres (inclusive o conceito final) para o aluno atual a fim de preencher grid do conselho
         if notas->(dbseek(cEmpresa+consitem->cit_ano+strzero(i,1,0)+consitem->cit_aluno+cargos->car_codigo))
            lContinua:=.t.
            do while lContinua
               if val(notas->not_bim)<>i .or. notas->not_aluno<>consitem->cit_aluno
                  lContinua:=.f.
                  loop
               endif   
               //procura em que turma o aluno está matriculado, pois ele vai ter também registro de nota na turma onde encontra-se com status de remanejado, e este registro em branco deve ser descartado
               if !turmas->(dbseek(cEmpresa+notas->not_aluno+notas->not_chamad+notas->not_setor+cAnoLetivoAtual))
                  if msgyesno("PAREI! Não achei turma. Aluno:"+notas->not_aluno+" Chamada:"+notas->not_chamad+" Setor:"+notas->not_setor+" Deleta?")
                     notas->(rlock())
                     notas->(dbdelete())
                     notas->(dbunlockall())
                  endif   
                  return
               endif   

               dDataLimBimTemp:=if(notas->not_bim = "1", anoletiv->ano_li1bim, if(notas->not_bim="2",anoletiv->ano_li2bim,if(notas->not_bim="3",anoletiv->ano_li3bim,anoletiv->ano_li4bim)))

               //embora esteja remanejado/transferido/reclassificado em algumas turmas, dependendo da data ele vai com nota nesta mesma turma
               if (alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDataLimBimTemp)) //.or. (alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDataLimBimTemp)) 
                  notas->(dbskip(1))
                  loop
               endif

               if !empty(notas->not_nota) .and. i = val(cBimestreAtual) .and. notas->not_aluno = consitem->cit_aluno .and. notas->not_setor = conselho->con_setor
                  if !(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual))
                     if !(alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual))
                        nTotalBimAlunoFaltas+=val(notas->not_faltas)  //se não achou nota é porque professor ainda não lançou notas. Na hora de salvar item do conselho, a nota será acrescentada.
                        nTotalBimAlunoNotas+=val(alltrim(notas->not_nota))
                        nTotalBimProf++
                     endif   
                  endif
               endif 
               lContinua:=.f.
            enddo       
            &('cNota'+strzero(i,1,0)+'Bim'):=notas->not_nota
            &('cFaltas'+strzero(i,1,0)+'Bim'):=strzero(val(notas->not_faltas),2,0)
            if cBimestreAtual=strzero(i,1,0) //guarda o nro da nota do bimestre atual para salvar, caso haja alteração.
               cRegNumeroBimAtual:=strzero(notas->(recno()),6,0)
            endif
            if notas->not_bim = cBimestreAtual 
               *msgbox("vou pegar mencoes. Bimestre nota="+notas->not_bim+" - Bimestre atual="+cBimestreAtual+" notas->recno="+str(notas->(recno())))
               lMencaoAA:=notas->not_mencaa
               lMencaoB:=notas->not_mencab
               lMencaoC:=notas->not_mencac                                             
               lMencaoD:=notas->not_mencad
               lMencaoE:=notas->not_mencae
               lMencaoF:=notas->not_mencaf
               lMencaoG:=notas->not_mencag 
               lMencaoH:=notas->not_mencah
               lMencaoI:=notas->not_mencai
               lMencaoJ:=notas->not_mencaj
               lMencaoK:=notas->not_mencak
               lMencaoL:=notas->not_mencal
            endif
         else
            &('cNota'+strzero(i,1,0)+'Bim'):=" "
            &('cFaltas'+strzero(i,1,0)+'Bim'):=" "
         endif
      next i
      //volta para a turma do conselho atual
      turmas->(dbseek(cEmpresa+consitem->cit_aluno+consitem->cit_chamad+conselho->con_setor+cAnoLetivoAtual))

      //Localiza a capa do bimestre onde encontram-se os totais de Aulas Previstas e Aulas Dadas
      capabime->(dbseek(cEmpresa+conselho->con_setor+atribuir->atr_funcio+cargos->car_codigo+consitem->cit_ano+cBimestreAtual)) 

      if !conselho->con_fecha .and. (!(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual)) .and. !(alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual)))  
         add item &(aGridCam1) to Grd_Notas of FrmConselho
         setproperty("FrmConselho","Grd_Notas","Enabled", .t.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .t.)
         setproperty("FrmConselho","Button_Salva","Enabled", .t.)
         setproperty("FrmConselho","SliderIndisci","Enabled", .t.)
         setproperty("FrmConselho","LblSliderIndisci","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador0","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador1","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador2","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador3","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador4","Enabled", .t.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .t.)
         setproperty("FrmConselho","Chk_Parabens","Enabled", .t.)
         setproperty("FrmConselho","Chk_Evadido","Enabled", .t.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .t.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .t.)
         if !(val(cBimestreAtual)==val(produtos->pro_qtdbim))  //não mostra este controle se não for o último bimestre
            setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         endif
      else
         //desabilita controles quando o aluno não estiver matriculado mais na turma.
         setproperty("FrmConselho","Grd_Notas","Enabled", .f.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
         setproperty("FrmConselho","Button_Salva","Enabled", .f.)
         setproperty("FrmConselho","SliderIndisci","Enabled", .f.)
         setproperty("FrmConselho","LblSliderIndisci","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador0","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador1","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador2","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador3","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador4","Enabled", .f.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         setproperty("FrmConselho","Chk_Parabens","Enabled", .f.)
         setproperty("FrmConselho","Chk_Evadido","Enabled", .f.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
      endif   

      if pAcao = "PRIMEIRO" // preenche fotos dos professores e seta do prof coordenador somente na primeira vez
         nContaProfAtribuicao++
         if setor->set_procoo = atribuir->atr_funcio  //se professor coordenador da sala é o professor atual
            setproperty("FrmConselho","SetaProfCoord","Col" ,(nContaProfAtribuicao*56)-30)  //move seta para indicar coordenador da sala
         endif
         if empty(alltrim(funciona->fun_foto)) .and. nContaProfAtribuicao<15 //não cabe 15 professores na tela
            setproperty("FrmConselho","Prof"+strzero(nContaProfAtribuicao,2,0),"Picture","teacher")
         else
            setproperty("FrmConselho","Prof"+strzero(nContaProfAtribuicao,2,0),"Picture", rtrim(c_PastaFotos)+"\"+alltrim(funciona->fun_foto))
         endif
         setproperty("FrmConselho","LblProf"+strzero(nContaProfAtribuicao,2,0),"value",if(empty(substr(funciona->fun_alcunh,1,9)),substr(funciona->fun_nome,1,9),substr(funciona->fun_alcunh,1,9)))
      endif
      atribuir->(dbskip(1))
   enddo   

   setproperty("FrmConselho","LblIDAluno"    ,"Value", alltrim(alunos->alu_nome))
   setproperty("FrmConselho","LblIDChamada"  ,"Value", "Nº: "+substr(consitem->cit_chamad,1,2))
   setproperty("FrmConselho","LblIdade"      ,"Value", "IDADE: "+substr(alltrim(str(val(dtos(date()))-val(dtos(alunos->alu_nasc)))),1,2)+" ANOS")
   setproperty("FrmConselho","lBlStatus"     ,"Value", alltrim(turmas->tur_status)+"-"+dtoc(turmas->tur_datast)+if(!empty(turmas->tur_observ)," - "+alltrim(turmas->tur_observ),""))
   setproperty("FrmConselho","LblIDSetor08"  ,"Value", alltrim(produtos->pro_descri))
   setproperty("FrmConselho","LblTotalFaltasBimestre01","Value", strzero(nTotalBimAlunoFaltas,3,0))
   setproperty("FrmConselho","LblTotalFaltasAno01"     ,"Value", strzero(nTotalAnualAlunoFaltas,3,0))
   setproperty("FrmConselho","LblMediaAluno01"  ,"Value", transform(alltrim(str(nTotalBimAlunoNotas/nTotalBimProf)),"999")) 
   setproperty("FrmConselho","LblMediaAluno01" ,"FontColor", if((nTotalBimAlunoNotas/nTotalBimProf)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblMediaClasse01" ,"Value", transform(alltrim(str(nTotalBimNotaClasse/nTotalBimProfClasse)),"999"))
   setproperty("FrmConselho","LblMediaClasse01" ,"FontColor",if((nTotalBimNotaClasse/nTotalBimProfClasse)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblAnualAluno01"  ,"Value", transform(alltrim(str(nTotalAnualNotaAluno/nTotalAnualProfAluno)),"999"))
   setproperty("FrmConselho","LblAnualAluno01" ,"FontColor",if((nTotalAnualNotaAluno/nTotalAnualProfAluno)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblAnualClasse01" ,"Value", transform(alltrim(str(nTotalAnualNotaClasse/nTotalAnualProfClasse)),"999"))
   setproperty("FrmConselho","LblAnualClasse01" ,"FontColor",if((nTotalAnualNotaClasse/nTotalAnualProfClasse)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblQtAzul01" ,"Value", strzero(nQtNotaAzul,3,0))
   setproperty("FrmConselho","LblQtVerm01" ,"Value", strzero(nQtNotaVerm,3,0))
   if empty(rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto)) .or. !file(rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
      setproperty("FrmConselho","ImgAluno","Picture", "FOTO")   
   else
      setproperty("FrmConselho","ImgAluno","Picture", rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
   endif   
   setproperty("FrmConselho","Combo_Situacao","Value", consitem->cit_situac)
   setproperty("FrmConselho","Combo_Hipotese","Value", alunos->alu_hipote)
   setproperty("FrmConselho","SliderIndisci","Value", val(consitem->cit_indis1))
   setproperty("FrmConselho","Chk_Parabens","Value", consitem->cit_parabe)
   setproperty("FrmConselho","Chk_Evadido","Value", turmas->tur_evadid)
else
   msgInfo("Fim dos itens do conselho")
   if pAcao = "PROXIMO"
      consitem->(dbskip(-1))
   elseif pAcao = "ANTERIOR"
      consitem->(dbskip(1))
   endif
endif
do case   //poe a cor do bimestre atual em vermelho
   case cBimestreAtual = "1"
      setproperty("FrmConselho","TxtNotas1Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "2"
      setproperty("FrmConselho","TxtNotas2Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "3"
      setproperty("FrmConselho","TxtNotas3Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "4"
      setproperty("FrmConselho","TxtNotas4Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "5"
      setproperty("FrmConselho","TxtNotas5Bim","FONTCOLOR", {255,0,0})
endcase
return

//----------------------------------------------------------------------------------------------------------------------------
procedure SomaProd()
//----------------------------------------------------------------------------------------------------------------------------
Local i, nPosanter, nOrdAnter, nHorasTotal, nPrecoTotal, cProdItens, cProdutoTemp
nPosAnter:=produtos->(recno())
nOrdAnter:=produtos->(IndexOrd())
nPrecoTotal:=nHorasTotal:=0
cProdItens:=produtos->pro_itens
produtos->(dbsetorder(1))
for i = 1 to 200 step 6
   cProdutoTemp:=substr(cProdItens,i,6)
   produtos->(dbseek(cEmpresa+cProdutoTemp))
   nPrecoTotal+=produtos->pro_preco
   nHorasTotal+=val(produtos->pro_horas)
next i
produtos->(dbsetorder(nOrdAnter))
produtos->(dbgoto(nPosAnter))
if !empty(nPrecoTotal)
   replace produtos->pro_preco with nPrecoTotal
endif
if !empty(nHorasTotal)
   replace produtos->pro_horas with nHorasTotal
endif
return

//----------------------------------------------------------------------
Procedure PoeTurmaAluno(pOper)
//----------------------------------------------------------------------
Local nGuardaRegistro:=setor->(recno())
if !TentaAcesso("alunos");return;endif
if pOper = "EXC"
   replace alunos->alu_setor with space(20)
else
   replace alunos->alu_setor with setor->set_codigo
endif
dbunlockall()
setor->(dbgoto(nGuardaRegistro)) 
return

//----------------------------------------------------------------------
Procedure PoeStatusTurma(pOper)
//----------------------------------------------------------------------
if !TentaAcesso("turmas");return;endif
if pOper = "EXC"
   replace turmas->tur_status with space(13)
else
   replace turmas->tur_status with ocorreal->occal_ocor
endif
dbunlockall()
return

//----------------------------------------------------------------------
Procedure CriaEventoAluno()
//----------------------------------------------------------------------
if msgyesno("Confirma Inclusão no arquivo de Ocorrências?")
   ocorreal->(dbappend())
   replace ocorreal->occal_empr with cEmpresa
   replace ocorreal->occal_codi with strzero(ocorreal->(recno()),6,0)
   replace ocorreal->occal_alun with turmas->tur_aluno
   replace ocorreal->occal_seto with turmas->tur_setor
   replace ocorreal->occal_dtin with turmas->tur_datast
   replace ocorreal->occal_dtfi with ctod('31/12/'+cAnoLetivoAtual)
   replace ocorreal->occal_ocor with turmas->tur_status
   replace ocorreal->occal_obse with turmas->tur_observ
endif
return

//----------------------------------------------------------------------
Procedure SalvaNotasGrid()
//----------------------------------------------------------------------
local i, cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0), aRet:={}
notas->(dbsetorder(1))
if msgyesno("Salva a Digitação das Notas e Faltas?")
   for i = 1 to getproperty("TabWindow", cControle, "itemcount")
      aRet := GetProperty("Tabwindow", cControle,'Item', i)
      //aRet[1]=nome aluno / aRet[2]=nº chamada / aRet[3]=nota / aRet[4]=faltas / aRet[5]=compens/ aRet[6]=status aluno na turma // aRet[7] = data status aluno na turma / aRet[8] = cod aluno
      if notas->(dbseek(cEmpresa+setor->set_codigo+cCodFuncionario+cCodCargo+cAnoLetivoAtual+cBimestreAtual+aRet[2]+aRet[8]))
         if !TentaAcesso("notas");return;endif
         replace notas->not_nota   with aRet[3]
         replace notas->not_faltas with aRet[4]
         replace notas->not_compen with aRet[5]
         dbunlockall()
      else
         msgStop("Não achei registro. Contate administrador do sistema.")
      endif   
   next i
   idAlteraCampo(.f., " ")  //retira flag de variável que indica alteração de campo, a fim de proteger dados digitados pelo operador 
endif
return

//----------------------------------------------------------------------
Procedure SalvaOrdemAtribuir()
//----------------------------------------------------------------------
local i, cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0), aRet:={}
if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

atribuir->(dbsetorder(3))
if msgyesno("Salva a Digitação da Ordem de Atribuição?")
   for i = 1 to getproperty("TabWindow", cControle, "itemcount")
      aRet := GetProperty("Tabwindow", cControle,'Item', i)
      if atribuir->(dbseek(cEmpresa+setor->set_codigo+aRet[6]+aRet[5]))
         if !TentaAcesso("atribuir");return;endif
         replace atribuir->atr_ordem   with aRet[2]
         dbunlockall()
      else
         msgStop("Não achei registro. Setor="+setor->set_codigo+" - Funciona="+aret[4]+" - Cargo:"+aret[5])
      endif   
   next i
   idAlteraCampo(.f., " ")  //retira flag de variável que indica alteração de campo, a fim de proteger dados digitados pelo operador
endif
atribuir->(dbsetorder(2))
refreshGrid(nTabPage)
return

//----------------------------------------------------------------------
Procedure SalvaQuestoesGrid()
//----------------------------------------------------------------------
local i, cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0), aRet:={}
avalques->(dbsetorder(1))
if msgyesno("Salva a Digitação das Respostas?")
   for i = 1 to getproperty("TabWindow", cControle, "itemcount")
      aRet := GetProperty("Tabwindow", cControle,'Item', i)
      if avalques->(dbseek(cEmpresa+aRet[1]))
         if !TentaAcesso("AVALQUES");return;endif
         replace avalques->avq_respo with aRet[4]
         replace avalques->avq_grupo with aRet[6]
         dbunlockall()
      else
         msgStop("Não achei registro. Contate administrador do sistema.")
      endif   
   next i
endif
avalques->(dbsetorder(2))
return

//----------------------------------------------------------------------
function TranspNotas()
//----------------------------------------------------------------------
return .t.

//----------------------------------------------------------------------
Function VerifAtribuir(pCodFuncio, pCodCargo)
//----------------------------------------------------------------------
Local nNumRecAnt:=atribuir->(recno())
if cCodfuncionario = cFuncionarioMaster   //O funcionário Master tem privilégio total sobre os setores.
   return .t.
endif
atribuir->(dbsetorder(3))
if atribuir->(dbseek(cEmpresa+setor->set_codigo+pCodFuncio+pCodCargo)) .and. !setor->set_fechad
   atribuir->(dbsetorder(2))
   atribuir->(dbgoto(nNumRecAnt))
   return .t.
else
   atribuir->(dbsetorder(2))
   atribuir->(dbgoto(nNumRecAnt))
   return .f.
endif
return .f.

//----------------------------------------------------------------------
function VerifStatusAluno()
//----------------------------------------------------------------------
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0), aRet:={}
aRet := GetProperty("Tabwindow", cControle,'Item', getproperty("TabWindow",cControle,"value"))
//aRet[1]=nome aluno / aRet[3]=nota / aRet[4]=faltas / aRet[5]=faltas compens / aRet[6]=status aluno na turma / aRet[7] = data status aluno na turma / aRet[8] = cod aluno
if alltrim(aRet[6])$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(ctod(aRet[7])) < dtos(dDtLimBimAtual) 
   msgInfo("Aluno(a)"+alltrim(aRet[6])+" em "+aRet[7]+". Alunos com esse evento antes de "+dtoc(dDtLimBimAtual)+" não serão processados nesta turma.")
   return .f.
endif
if alltrim(aRet[6])$"MATRICULADO(A)" .and. dtos(ctod(aRet[7])) > dtos(dDtLimBimAtual) 
   msgInfo("Aluno(a)"+alltrim(aRet[6])+" em "+aRet[7]+". Alunos com esse evento depois de "+dtoc(dDtLimBimAtual)+" não serão processados nesta turma.")
   return .f.
endif
return .t.

//---------------------------------------------------------------------------
Procedure CriaControlesLivre(cFuncao)
//---------------------------------------------------------------------------
return

//------------------------------------------------------------------------------
Procedure CopiaAtribuicao()
//------------------------------------------------------------------------------
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmCopiaAtribuir"
*cAliasBrowse:=cAliasTab:='Atribuir'

DEFINE WINDOW FrmCopiaAtribuir AT 50,50 WIDTH 290 HEIGHT 120 TITLE "Copia atribuição" MODAL NOSIZE 

   DEFINE LABEL LblSerie
      ROW    10
      COL    8
      WIDTH  80
      HEIGHT 20
      VALUE "Série: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtTurma
      ROW    10
      COL    90
      WIDTH  60
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE ""
   end TEXTBOX
   DEFINE BUTTON ButCon
      ROW    10
      COL    155
      WIDTH  15
      HEIGHT 14
      CAPTION "P"
      ACTION Consulta("SETOR",{"TxtTurma","setor->set_codigo"}, "setor->set_descri", .f., 1, 1, {})
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
      TABSTOP .F.
   END BUTTON
   DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
      ROW    10
      COL    175
      WIDTH  230
      HEIGHT 12
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE BUTTON ButConfirma
      ROW    45
      COL    55
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION ExecutaCopiaAtribuicao()
      FONTNAME "Verdana"
      FONTSIZE 6
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    45
      COL    150
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmCopiaAtribuir.release
      FONTNAME "Verdana"
      FONTSIZE 6
      FONTBOLD .T.
   end BUTTON
end WINDOW
FrmCopiaAtribuir.Center
ACTIVATE WINDOW FrmCopiaAtribuir
cFormAtivo:=cFormAnterior
return

//-------------------------------------------------------------------------------
Procedure ExecutaCopiaAtribuicao()
//-------------------------------------------------------------------------------
local arr_atribuir:=array(5), nNumRecAnt
atribuir->(dbsetorder(3))
if !atribuir->(dbseek(cEmpresa+alltrim(FrmCopiaAtribuir.TxtTurma.value)))
   msgExclamation("Atribuição da Série informada não encontrada.")
endif
do while !atribuir->(eof()) .and. FrmCopiaAtribuir.TxtTurma.value = atribuir->atr_setor
   arr_atribuir[1]:=atribuir->atr_setor
   arr_atribuir[2]:=atribuir->atr_ordem 
   arr_atribuir[3]:=atribuir->atr_cargo
   arr_atribuir[4]:=atribuir->atr_funcio
   arr_atribuir[5]:=atribuir->atr_horari
   nNumRecAnt:=atribuir->(recno())

   if !atribuir->(dbseek(cEmpresa+setor->set_codigo+arr_atribuir[4]+arr_atribuir[3]))
      atribuir->(dbappend())
      replace atribuir->atr_empre  with cEmpresa
      replace atribuir->atr_codigo with strzero(atribuir->(recno()),6,0)
      replace atribuir->atr_setor  with setor->set_codigo
      replace atribuir->atr_ordem  with arr_atribuir[2]
      replace atribuir->atr_cargo  with arr_atribuir[3]
      replace atribuir->atr_funcio with arr_atribuir[4]
      replace atribuir->atr_horari with arr_atribuir[5]
   endif
   atribuir->(dbgoto(nNumRecAnt))
   atribuir->(dbskip(1))
enddo 
refreshGrid(nTabPage)  
return

//---------------------------------------------------------------------------
Procedure MostraNotas(lAnoLetivoAtual)
//---------------------------------------------------------------------------
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0)
local nPos := GetProperty ("TabWindow", cControle, "Value")
local aRet := GetProperty ("TabWindow", cControle, 'Item', nPos )
Private bColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , { 219,219,219 } , { 255,255,255 } ) }
Private cAnoMostraNotas:="    ", cAlunoAtual

if empty(nPos) //se não foi selecionado um registro no grid
   msginfo("Selecione antes um registro para mostrar Notas do aluno.")
   return
endif

nPos:=len(&(aGridCampos)) //pega ultimo valor do grid onde se encontra o recno()
dbgoto(val(aRet[nPos]))

bColumnColor3:=bColumnColor5:=bColumnColor7:=bColumnColor9:=bColumnColor11:={|| if(val(this.cellvalue)>4,{0,0,255},{255,0,0})}  //muda coluna 3 (médias) para vermelho se menor que 5 e azul se maior que 4	

limparelacoes()
notas->(dbgoto(val(aRet[nPos])))
alunos->(dbseek(cEmpresa+notas->not_aluno))
cAlunoAtual:=notas->not_aluno
cChamadaAtual:=notas->not_chamad

if !lAnoLetivoAtual
   cAnoMostraNotas:=strzero(val(cAnoLetivoAtual)-1,4,0)
else
   cAnoMostraNotas:=cAnoLetivoAtual
endif

DEFINE WINDOW FrmNotas AT 20,25 WIDTH 750 HEIGHT 400 TITLE "Notas do Aluno" MODAL NOSIZE
   DEFINE LABEL LblNomeTela
      ROW    02
      COL    202
      WIDTH  620
      HEIGHT 40
      VALUE "Notas do Aluno - "+cBimestreAtual+"º Bimestre de "+cAnoMostraNotas
      FONTNAME "Arial"
      FONTSIZE 15
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDPrincipal
      ROW    33
      COL    172
      WIDTH  620
      HEIGHT 40
      VALUE "Setor:             Sala:             Período:                     Tipo:"
      FONTNAME "Arial"
      FONTSIZE 12
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSetor
      ROW    33
      COL    220
      WIDTH  620
      HEIGHT 40
      VALUE alltrim(setor->set_descri)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTCOLOR {64,162,21}
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDSala
      ROW    33
      COL    316
      WIDTH  620
      HEIGHT 40
      VALUE alltrim(setor->set_sala)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTCOLOR {64,162,21}
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDPeriodo
      ROW    33
      COL    432
      WIDTH  620
      HEIGHT 40
      VALUE alltrim(setor->set_period)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTCOLOR {64,162,21}
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblIDProduto
      ROW    33
      COL    560
      WIDTH  620
      HEIGHT 40
      VALUE alltrim(produtos->pro_descri)
      FONTNAME "Arial"
      FONTSIZE 12
      FONTCOLOR {64,162,21}
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE FRAME Frame_1
      ROW    57
      COL    5
      WIDTH  734
      HEIGHT 306
      OPAQUE .T.
   END FRAME
   DEFINE FRAME Frame_2
      ROW    62
      COL    10
      WIDTH  170
      HEIGHT 240
   END FRAME 
   DEFINE IMAGE ImgAluno
      ROW    70
      COL    12
      WIDTH  150
      HEIGHT 185
      PICTURE rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto)
   END IMAGE
   DEFINE LABEL LblIDAluno
      ROW    265
      COL    12
      WIDTH  620
      HEIGHT 20
      VALUE alltrim(substr(alunos->alu_nome,1,15))
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .F.
   END LABEL
   DEFINE LABEL LblIDChamada
      ROW    285
      COL    75
      WIDTH  120
      HEIGHT 20
      VALUE "Nº: "+alltrim(notas->not_chamad)
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .F.
   END LABEL
   DEFINE TEXTBOX txtNotas1Bim
      ROW    60
      COL    461
      WIDTH  60
      HEIGHT 18
      VALUE "  1º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas2Bim
      ROW    60
      COL    521
      WIDTH  60
      HEIGHT 18
      VALUE "  2º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas3Bim
      ROW    60
      COL    581
      WIDTH  60
      HEIGHT 18
      VALUE "  3º BIM  "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas4Bim
      ROW    60
      COL    641
      WIDTH  60
      HEIGHT 18
      VALUE "  4º BIM  "
      READONLY .T.
      FONTNAME "Arial"
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE TEXTBOX txtNotas5Bim
      ROW    60
      COL    701
      WIDTH  30
      HEIGHT 18
      VALUE "  5º "
      FONTNAME "Arial"
      READONLY .T.
      FONTSIZE 10
      FONTBOLD .T.
   END LABEL
   DEFINE GRID Grd_Notas
      ROW 76
      COL 195
      WIDTH  539
      HEIGHT 278
      VALUE 0
      ITEMS nil
      HEADERS {'Matéria','Professor','N','F','N','F','N','F','N','F','N'}
      WIDTHS {130,135,30,30,30,30,30,30,30,30,30}
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      DYNAMICFORECOLOR {bColumnColor1,bColumnColor2,bColumnColor3,bColumnColor4,bColumnColor5,bColumnColor6,bColumnColor7,bColumnColor8,bColumnColor9,bColumnColor10,bColumnColor11} //diz qual a cor de cada coluna do grid, mudada no módulo funções
      DYNAMICBACKCOLOR { bColor , bColor , bColor , bColor , bColor , bColor, bColor, bColor, bColor, bColor, bColor}
      COLUMNCONTROLS {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
   END GRID   
END WINDOW
CENTER WINDOW FrmNotas
ItensNotas()
ACTIVATE WINDOW FrmNotas
Determinacampos("NOTAS","FUNCAO")
Return

//----------------------------------------------------------------------------------------------------------------------------
Function ItensNotas() //Consulta das notas por aluno
//----------------------------------------------------------------------------------------------------------------------------
Local nTotalFaltas:=0, nRecAnt:=notas->(recno()), i, lContinua, DDATALIMBIMTEMP
Local aGridCam1:="{substr(cargos->car_descri,1,15),substr(funciona->fun_nome,1,15),cNota1Bim,cFaltas1Bim,cNota2Bim,cFaltas2Bim,cNota3Bim,cFaltas3Bim,cNota4Bim,cFaltas4Bim,cNota5Bim}"
Private cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:="-" 

turmas->(dbsetorder(3)) //ordem de aluno

if !produtos->(dbseek(cEmpresa+setor->set_produt))
   msgStop("Não encontrei curso. Contate administrador do sistema.")
endif

if !atribuir->(dbseek(cEmpresa+setor->set_codigo))
   msgStop("Não encontrei Atribuição de professores. Entre em contato com o administrador do sistema.")
endif

   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:=" "
      cRegNumeroBimAtual:=""

      if !cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
         msgStop("PAREI! Não encontrei cargo. Contatar administrador do sistema.")
         return nil
      endif 
      if !funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
         msgStop("PAREI! Não encontrei funcionário. Contatar administrador do sistema.")
         return nil
      endif 
      
      notas->(dbsetorder(4)) //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_ALUNO+NOTAS->NOT_CARGO+NOTAS->NOT_CHAMAD

      for i = 1 to (val(produtos->pro_qtdbim)+1) //pega as notas de todos os bimestres (inclusive o conceito final) para o aluno atual a fim de preencher grid do conselho
         if notas->(dbseek(cEmpresa+cAnoLetivoAtual+strzero(i,1,0)+cAlunoAtual+cargos->car_codigo))
            lContinua:=.t.
            do while lContinua
               if val(notas->not_bim)<>i .or. notas->not_aluno<>cAlunoAtual
                  lContinua:=.f.
                  loop
               endif   
               //procura em que turma o aluno está matriculado, pois ele vai ter também registro de nota na turma onde encontra-se com status de remanejado, e este registro em branco deve ser descartado
               if !turmas->(dbseek(cEmpresa+notas->not_aluno+notas->not_chamad+notas->not_setor+cAnoLetivoAtual))
                  if msgyesno("PAREI! Não achei turma. Aluno:"+notas->not_aluno+" Chamada:"+notas->not_chamad+" Setor:"+notas->not_setor+" Deleta?")
                     notas->(rlock())
                     notas->(dbdelete())
                     notas->(dbunlockall())
                  endif   
                  return nil
               endif   

               dDataLimBimTemp:=if(notas->not_bim = "1", anoletiv->ano_li1bim, if(notas->not_bim="2",anoletiv->ano_li2bim,if(notas->not_bim="3",anoletiv->ano_li3bim,anoletiv->ano_li4bim)))

               //embora esteja remanejado/transferido/reclassificado em algumas turmas, dependendo da data ele vai com nota nesta mesma turma
               if (alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDataLimBimTemp)) .or. (alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDataLimBimTemp)) 
                  notas->(dbskip(1))
                  loop
               endif
               lContinua:=.f.
            enddo       
            &('cNota'+strzero(i,1,0)+'Bim'):=notas->not_nota
            &('cFaltas'+strzero(i,1,0)+'Bim'):=strzero(val(notas->not_faltas),2,0)
            if cBimestreAtual=strzero(i,1,0) //guarda o nro da nota do bimestre atual para salvar, caso haja alteração.
               cRegNumeroBimAtual:=strzero(notas->(recno()),6,0)
            endif
            if notas->not_bim = cBimestreAtual 
               lMencaoAA:=notas->not_mencaa
               lMencaoB:=notas->not_mencab
               lMencaoC:=notas->not_mencac
               lMencaoD:=notas->not_mencad
               lMencaoE:=notas->not_mencae
               lMencaoF:=notas->not_mencaf
               lMencaoG:=notas->not_mencag 
               lMencaoH:=notas->not_mencah
               lMencaoI:=notas->not_mencai
               lMencaoJ:=notas->not_mencaj
               lMencaoK:=notas->not_mencak
               lMencaoL:=notas->not_mencal
            endif
         else
            &('cNota'+strzero(i,1,0)+'Bim'):=" "
            &('cFaltas'+strzero(i,1,0)+'Bim'):=" "
         endif
      next i
      //volta para a turma do conselho atual
      turmas->(dbseek(cEmpresa+cAlunoAtual+cChamadaAtual+setor->set_codigo+cAnoLetivoAtual))

      if (!(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual)) .and. !(alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual)))  
         add item &(aGridCam1) to Grd_Notas of FrmNotas
      endif   
      atribuir->(dbskip(1))
   enddo   

/*


do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
   cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:=" "

   if !cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      msgStop("PAREI! Não encontrei cargo. Contatar administrador do sistema.")
      return nil
   endif 
   if !funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
      msgStop("PAREI! Não encontrei funcionário. Contatar administrador do sistema.")
      return nil
   endif 

   notas->(dbsetorder(4))

   for i = 1 to 5 //pega as notas dos 5 bimestres para o aluno atual a fim de preencher grid do conselho
      if notas->(dbseek(cEmpresa+cAnoMostraNotas+strzero(i,1,0)+cAlunoAtual+cargos->car_codigo))
         do while .t.
            //procura em que turma o aluno está matriculado, pois ele vai ter também registro de nota na turma onde encontra-se com status de remanejado, e este registro em branco deve ser descartado
            if !turmas->(dbseek(cEmpresa+cAlunoatual+cChamadaAtual+notas->not_setor+cAnoMostraNotas))
               msgstop("PAREI! Não achei turma. Aluno:"+cAlunoAtual+" Chamada:"+cChamadaAtual+" Setor:"+notas->not_setor)
               return nil
            endif   

            //embora esteja remanejado/transferido/reclassificado em algumas turmas, dependendo da data ele vai com nota nesta mesma turma
            if substr(turmas->tur_status,1,5)$"REMAN¦TRANS¦RECLA" .and. dtos(turmas->tur_datast) < dtos(if(strzero(i,1,0) = "1", anoletiv->ano_Li1bim, if(strzero(i,1,0)="2",anoletiv->ano_Li2bim,if(strzero(i,1,0)="3",anoletiv->ano_Li3bim,anoletiv->ano_Li4bim)))) 
               notas->(dbskip(1))
               loop
            endif
            exit
         enddo       
         if notas->not_aluno <> cAlunoAtual .or. notas->not_chamad <> cChamadaAtual .or. notas->not_cargo <> atribuir->atr_cargo
            exit
         endif   
         &('cNota'+strzero(i,1,0)+'Bim'):=notas->not_nota
         &('cFaltas'+strzero(i,1,0)+'Bim'):=strzero(val(notas->not_faltas),2,0)
      else
         &('cNota'+strzero(i,1,0)+'Bim'):="-"
         &('cFaltas'+strzero(i,1,0)+'Bim'):="-"
      endif
   next i
   //volta para a turma original
   turmas->(dbseek(cEmpresa+cAlunoAtual+cChamadaAtual+setor->set_codigo+cAnoMostraNotas))
   if substr(turmas->tur_status,1,5)=="MATRI" // .and. notas->not_setor = setor->set_codigo  //não pega nota que foi lançada para o aluno em outra turma, quando este aluno foi remanejado.
      add item &(aGridCam1) to Grd_Notas of FrmNotas
   endif
   //volta para a nota do bimestre atual
   notas->(dbsetorder(1))
   notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+cargos->car_codigo+cAnoMostraNotas+cBimestreAtual+turmas->tur_chamad+cAlunoAtual))

   atribuir->(dbskip(1))
enddo   
*/

setproperty("FrmNotas","LblIDAluno"   ,"Value", alltrim(substr(alunos->alu_nome,1,25)))
setproperty("FrmNotas","LblIDChamada" ,"Value", "Nº "+cChamadaAtual)
setproperty("FrmNotas","LblIDSetor"   ,"Value", alltrim(setor->set_descri))
setproperty("FrmNotas","LblIDSala"    ,"Value", alltrim(setor->set_sala))
setproperty("FrmNotas","LblIDPeriodo" ,"Value", alltrim(setor->set_period))
setproperty("FrmNotas","LblIDProduto" ,"Value", alltrim(produtos->pro_descri))

if empty(rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
   setproperty("FrmNotas","ImgAluno","Picture", "FOTO")
else
   setproperty("FrmNotas","ImgAluno","Picture", rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
endif
domethod("FrmNotas","LblNomeTela","REFRESH")
domethod("FrmNotas","LblIDSetor","REFRESH")
domethod("FrmNotas","LblIDAluno","REFRESH")
domethod("FrmNotas","ImgAluno","REFRESH")
doMethod("FrmNotas","Grd_notas","REFRESH")
domethod("FrmNotas","LblIDProduto","REFRESH")
notas->(dbsetorder(1))
return .t.

//------------------------------------------------------------------------------------
procedure PopulaQuestoesAvaliacao()
//------------------------------------------------------------------------------------
Local i, nTotalCanceladas:=0
if msgyesno("Confirma Popular Questões?","",.f.)
   avalques->(dbsetorder(2))
   for i = 1 to val(avaliar->av_nroques)
      if avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
         if alltrim(avalques->avq_tpcorr) == "QUESTÃO CANCELADA"  //se for questão cancelada pelo usuário
            nTotalCanceladas++  //adiciona contador de canceladas para processar todas as questões 
         endif           
      endif
   next i

   for i = 1 to val(avaliar->av_nroques)
      if !avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
         avalques->(dbappend())
         replace avalques->avq_empre  with cEmpresa
         replace avalques->avq_codigo with strzero(avalques->(recno()),6,0)
         replace avalques->avq_avalia with avaliar->av_codigo
         replace avalques->avq_ordem  with strzero(i,3,0)
         replace avalques->avq_valor  with (val(avaliar->av_notamax)/(val(avaliar->av_nroques)-nTotalCanceladas))
         replace avalques->avq_tpcorr with avaliar->av_tipcorr
      else
         if !TentaAcesso("AVALQUES");return;endif
         if !(alltrim(avalques->avq_tpcorr) == "QUESTÃO CANCELADA")  //se não for questão cancelada pelo usuário
            replace avalques->avq_valor with (val(avaliar->av_notamax)/(val(avaliar->av_nroques)-nTotalCanceladas))
         else //senão
            replace avalques->avq_valor with 0  //atribui zero para a questão
         endif           
         if !(alltrim(avalques->avq_tpcorr) == "QUESTÃO CANCELADA")  //não muda status de questões canceladas pelo usuário
            replace avalques->avq_tpcorr with avaliar->av_tipcorr
         endif
         avalques->(dbunlock())
      endif
   next i
   if avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
      if msgyesno("Confirma Deletar Questões Excedentes? Se as excedentes forem as canceladas, responda 'Não'","",.f.)      
         do while avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0))) 
            if !TentaAcesso("AVALQUES");return;endif
            avalques->(dbdelete())
            i++
         enddo   
         avalques->(dbunlockall())
      endif
   endif   
   RefreshGrid(nTabPage)
endif
return      

//------------------------------------------------------------------------------------
procedure ProcessaGabarito()
//------------------------------------------------------------------------------------
Local x, i, j, y, cNroGabarito:=" ", arrGrupoNotas:={}, nNota:=0, cAliasAnt, lAcerto, nSomaAcerto
LimpaRelacoes()
gabarito->(dbsetorder(2))
turmas->(dbsetorder(4))
alunos->(dbsetorder(1))
avalques->(dbsetorder(2))
cAliasAnt:=upper(alias(Select()))
if gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual))
    do while !gabarito->(eof()) .and. gabarito->gab_ano = cAnoLetivoAtual .and. gabarito->gab_bime = cBimestreAtual
       if alunos->(dbseek(cEmpresa+gabarito->gab_alun))
          if turmas->(dbseek(cEmpresa+alunos->alu_codigo+gabarito->gab_ano+"MATRICULAD"))
              if !(turmas->tur_setor$avaliar->av_setor) //não processa gabarito de outros setores que não do setor atual
                 gabarito->(dbskip(1))
                 loop
              endif   
              for i = 1 to  val(avaliar->av_nroques) //começa a processar as questões do gabarito para esse aluno
                 if avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
                    if !(alltrim(avalques->avq_tpcorr) == "QUESTÃO CANCELADA") //se a questão foi cancelada, não processa
                        do case
                           case alltrim(avalques->avq_tpcorr) == "APENAS A OPÇÃO REQUERIDA"
                              if len(alltrim(gabarito->(fieldget(i+6))))>1  //i+6 porque as respostas das questões começam a partir do sexto campo
                                 lAcerto:=.f.
                              else
                                 if alltrim(gabarito->(fieldget(i+6))) == alltrim(avalques->avq_respo) 
                                    lAcerto:=.t.
                                 else
                                    lAcerto:=.f.   
                                 endif
                              endif
                           case alltrim(avalques->avq_tpcorr) == "QUALQUER OPÇÃO, EXCETO MÚLTIPLAS/BRANCO"          
                              if len(alltrim(gabarito->(fieldget(i+6))))>1 .or. empty(alltrim(gabarito->(fieldget(i+6))))
                                 lAcerto:=.f.
                              else
                                 lAcerto:=.t.
                              endif
                           case alltrim(avalques->avq_tpcorr) == "QUALQUER OPÇÃO, INCLUSIVE MÚLTIPLAS/EM BRANCO"
                              lAcerto:=.t.
                           case alltrim(avalques->avq_tpcorr) == "TODAS AS OPÇÕES REQUERIDAS"
                              nSomaAcerto:=0
                              for j = 1 to 5
                                 if substr(gabarito->(fieldget(i+6)),j,1) $ alltrim(avalques->avq_respo)
                                    nSomaAcerto++
                                 endif
                              next j
                              if len(alltrim(avalques->avq_respo))=nSomaAcerto
                                 lAcerto:=.t.
                              else
                                 lAcerto:=.f.
                              endif
                           case alltrim(avalques->avq_tpcorr) == "QUALQUER UMA DAS OPÇÕES REQUERIDAS"
                              nSomaAcerto:=0
                              for j = 1 to 5
                                 if substr(gabarito->(fieldget(i+6)),j,1) $ alltrim(avalques->avq_respo)
                                    nSomaAcerto++
                                 endif
                              next j
                              if nSomaAcerto>1
                                 lAcerto:=.t.
                              else
                                 lAcerto:=.f.
                              endif
                           otherwise
                              msgExclamation("Questão "+avalques->avq_ordem+" sem diretiva de correção. Favor verificar tipo de correção.")
                              msgInfo("avq_tpcorr="+avalques->avq_tpcorr+" nro. registro="+str(avalques->(recno())))
                              RETURN  
                        endcase         
                        if lAcerto   //verifica se resposta foi considerada correta             
                           nNota+=avalques->avq_valor
                           for x = 1 to len(arrGrupoNotas) //classifica em grupos o resultado
                              if avalques->avq_grupo == arrGrupoNotas[x,1] //se o grupo já existe
                                 arrGrupoNotas[x,2]+=avalques->avq_valor // soma a nota geral do aluno
                                 arrGrupoNotas[x,3]++ //conta quantas questões acertadas
                                 arrGrupoNotas[x,4]++ //conta o total de questoes do grupo
                                 exit //quando acha, sai
                              endif
                           next x
                           if x > len(arrGrupoNotas) // se x for maior que o tamanho do vetor, significa que não achou grupo no vetor
                              aadd(arrGrupoNotas,{avalques->avq_grupo, avalques->avq_valor,1,1}) //então cria novo grupo, somando a quantidade de acerto e a quantidade total de questoes deste grupo
                           endif   
                        else  //se o aluno errou a questao
                           for x = 1 to len(arrGrupoNotas) //verifica o grupo, a fim de somar a quantidade total de questoes no grupo
                              if avalques->avq_grupo == arrGrupoNotas[x,1]
                                 arrGrupoNotas[x,4]++
                                 exit //quando acha, sai
                              endif
                           next x
                           if x > len(arrGrupoNotas) //se ainda nao existe o grupo, entao cria já somando a qtde total de questoes deste grupo, mas deixando zerado o total de acertos
                              aadd(arrGrupoNotas,{avalques->avq_grupo, 0000.00000,0,1})
                           endif   
                        endif
                    endif
                 else
                    msgInfo("AVALQUES DESCARTADA "+cEmpresa+"-"+avaliar->av_codigo+"-"+strzero(i,3,0))
                 endif   
              next i
              if !resultav->(dbseek(cEmpresa+avaliar->av_codigo+alunos->alu_codigo))  //grava o resultado
                 resultav->(dbappend())
                 replace resultav->res_empres with cEmpresa
                 replace resultav->res_codigo with strzero(resultav->(recno()),6,0)
                 replace resultav->res_avalia with avaliar->av_codigo
                 replace resultav->res_aluno  with alunos->alu_codigo
                 replace resultav->res_geral  with nNota
                 for y = 1 to len(arrGrupoNotas)
                    replace &('resultav->res_nome'+strzero(y,2,0)) with arrGrupoNotas[y,1] 
                    replace &('resultav->res_grup'+strzero(y,2,0)) with ((val(avaliar->av_notamax)/arrGrupoNotas[y,4])*arrGrupoNotas[y,3])
                 next y                    
              else
                 altd()
                 if !TentaAcesso("RESULTAV");return;endif
                 replace resultav->res_geral  with nNota
                 for y = 1 to len(arrGrupoNotas)
                    replace &('resultav->res_nome'+strzero(y,2,0)) with arrGrupoNotas[y,1] 
                    replace &('resultav->res_grup'+strzero(y,2,0)) with ((val(avaliar->av_notamax)/arrGrupoNotas[y,4])*arrGrupoNotas[y,3])
                 next y                    
                 resultav->(dbunlockall())
              endif                                 
              if !TentaAcesso("GABARITO");return;endif
              replace gabarito->gab_aval with avaliar->av_codigo
              gabarito->(dbunlockall()) 
          endif
       else
          msgExclamation("ALUNO NAO ENCONTRADO:"+GABARITO->GAB_ALUN)
       endif
       arrGrupoNotas:={}
       nNota:=0
       gabarito->(dbskip(1))
    enddo
else
   msgbox("GAbarito para o ano e bimestre atuais nao encontrado")
endif   
select &cAliasAnt  //volta dbf anterior
gabarito->(dbsetorder(1))
msgInfo("Fim de Processamento.")
return            

//------------------------------------------------------------------------------
procedure CriaArquivoResultadoAvaliacao()
//------------------------------------------------------------------------------
Local i, u, y, nArq, nContaAlunos, c
nArq:=fcreate("arq.txt") //cria o arquivo de log
setor->(dbseek(1))
turmas->(dbsetorder(2)) //ordem de chamada
nContaAlunos:=0
for i = 1 to 360 step 6
  if !empty(substr(avaliar->av_setor,i,6))
     if turmas->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)+cAnoLetivoAtual))
        setor->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)))
        c:=1
        do while !turmas->(eof()) .and. turmas->tur_setor = substr(avaliar->av_setor,i,6)
           resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, traço.
           nContaAlunos++
           produtos->(dbseek(cEmpresa+setor->set_PRODUT))
           if c = 1
           for u = 1 to 4
              for y = 1 to 20
                 if u =1 .and. y = 1 
                    fwrite(nArq, "GERAL")
                 elseif u =2 .and. y = 1 
                    fwrite(nArq, "ANO/BIM")
                 elseif u =3 .and. y = 1 
                    fwrite(nArq, cAnoLetivoAtual+"/"+cBimestreAtual)
                 elseif u =4 .and. y = 1 
                    fwrite(nArq, substr(alltrim(setor->set_descri),1,1)+" "+substr(alltrim(setor->set_descri),4,1))
                 endif

                 do case
                    case u=1 
                       fwrite(nArq, "          "+Substr(&('resultav->res_nome'+strzero(y,2,0)),1,5))
                    case u=2 
                       fwrite(nArq, "        "+"ANO/BIM")
                    case u=3
                       fwrite(nArq, "         "+cAnoLetivoAtual+"/"+cBimestreAtual)
                    case u=4
                       fwrite(nArq, "            "+substr(alltrim(setor->set_descri),1,1)+" "+substr(alltrim(setor->set_descri),4,1))
                 endcase
              next y   
              fwrite(nArq, chr(13))
           next u
           c:=2
           endif
           for y = 1 to 20
              if y = 1 
                 fwrite(nArq, Turmas->tur_chamad)
                 if(resultav->(found()),fwrite(nArq, str(resultav->res_geral,5,2)),fwrite(nArq, "  -  "))
              endif
              fwrite(nArq, "        "+turmas->tur_chamad)
              fwrite(nArq, if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ")) 
           next y      
           fwrite(nArq, chr(13))
           turmas->(dbskip(1))
        enddo
     endif
  endif
next i
fClose(nArq)
return


function verificanotaavaliacao()
return .t.

//---------------------------------------------------------------------------
Procedure NovoLocalizaImg()  //No browse de turmas de alunos, abre janela de pastas e arquivos para operador escolher foto
//---------------------------------------------------------------------------
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0)
local nPos := GetProperty ("TabWindow", cControle, "Value")
local aRet := GetProperty ("TabWindow", cControle, 'Item', nPos ), cCaminho

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

if empty(nPos) //se não foi selecionado um registro no grid
   msginfo("Selecione antes um registro para inserir foto do aluno.")
   return
endif

nPos:=len(&(aGridCampos)) //pega ultimo valor do grid onde se encontra o recno()
dbgoto(val(aRet[nPos]))

cCaminho:=getfile({{"Arquivos jpg","*.jpg"},{"Arquivos gif","*.gif"}},"Selecione a Figura")
if msgyesno("Confirma foto do aluno?")
  if !TentaAcesso("ALUNOS");return;endif
  replace alunos->alu_foto with substr(cCaminho,rat("\", cCaminho)+1)
  alunos->(dbunlockall())
endif 
return
 
//---------------------------------------------------------------------------
Function idAlteraCampo(lPar, pCampo) //muda flags quando determinado campo é alterado pelo operador, não permitindo que saia sem gravar alterações
//---------------------------------------------------------------------------
Local lCampoAlterado:=lPar, cCampoAlterado:=pCampo
return .t.

//---------------------------------------------------------------------------
procedure ImportaNotas()
//---------------------------------------------------------------------------
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmImpNotas"
cAliasBrowse:=cAliasTab:='funciona'

DEFINE WINDOW FrmImpNotas AT 10,5 WIDTH 420 HEIGHT 140 TITLE "Importa Notas Digitadas" MODAL NOSIZE
   DEFINE LABEL LblFuncio
      ROW    10
      COL    8
      WIDTH  80
      HEIGHT 20
      VALUE "Funcionário: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtFuncio
      ROW    10
      COL    90
      WIDTH  60
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE ""
   end TEXTBOX
   DEFINE BUTTON ButCon
      ROW    10
      COL    155
      WIDTH  15
      HEIGHT 14
      CAPTION "P"
      ACTION Consulta("FUNCIONA",{"TxtFuncio","funciona->fun_codigo"}, "funciona->fun_nome", .f., 1, 1, {})
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
      TABSTOP .F.
   END BUTTON

   DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
      ROW    10
      COL    175
      WIDTH  230
      HEIGHT 12
      *BACKCOLOR {253,253,253}
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblArquivo
      ROW    35
      COL    8
      WIDTH  80
      HEIGHT 35
      VALUE "Arquivo de Notas: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtArquivoNotas
      ROW    37
      COL    90
      WIDTH  290
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      UPPERCASE .T.
      ONGOTFOCUS  setproperty("FrmImpNotas","ImgPicker","enabled",.t.) //é necessárias as duas linhas aqui em sequência pois estava dando erro de vetor quando o operado clicava no img_picker sem o foco estar no campo imgtext       
      ONLOSTFOCUS setproperty("FrmImpNotas","ImgPicker","enabled",.f.)        
      TOOLTIP 'Clique nesta caixa de texto para habilitar procura na pasta ao lado'
      TRANSPARENT .T.
   END TEXTBOX
   DEFINE IMAGE ImgPicker
      ROW    37
      COL    382
      WIDTH  18
      HEIGHT 19
      PICTURE "PASTA"
      STRETCH .T.
      ACTION LocalizaArqNotas()
      TRANSPARENT .T.
   END IMAGE

   DEFINE BUTTON ButConfirma
      ROW    70
      COL    115
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION ExecutaImportaNotas()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON

   DEFINE BUTTON ButCancela
      ROW    70
      COL    210
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmImpNotas.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmImpNotas
ACTIVATE WINDOW FrmImpNotas
cFormAtivo:=cFormAnterior
Return

//---------------------------------------------------------------------------
Procedure LocalizaArqNotas()  //abre janela de pastas e arquivos para operador escolher foto
//---------------------------------------------------------------------------
Setproperty("FrmImpNotas","TxtArquivoNotas", "value", getfolder("Pasta \Mestre\Database"))
return

//---------------------------------------------------------------------------
procedure ExecutaImportaNotas()
//---------------------------------------------------------------------------
Local i, nContaNotasImportadas:=nContaCapabime:=0
if empty(alltrim(FrmImpNotas.TxtFuncio.value))
   msgstop("Favor informar um funcionário válido antes de proesseguir.")
   return
endif
if !file(alltrim(FrmImpNotas.TxtArquivoNotas.value)+"\notas.dbf")
   msgstop("Arquivo Notas.dbf não encontrado. Importação não realizada.")
   return
endif
if !file(alltrim(FrmImpNotas.TxtArquivoNotas.value)+"\capabime.dbf")
   msgstop("Arquivo Capabimes.dbf não encontrado. Importação não realizada.")
   return
endif

msgbox("Atenção! Por motivo de segurança dos dados, as notas JÁ DIGITADAS no computador da escola não serão substituídas pelas notas do arquivo a ser importado. Se deseja que as notas do arquivo de importação prevaleçam sobre as notas digitadas no computador da escola, deixe em branco as notas no computador da escola ou exclua-as.")
notas->(dbsetorder(1))
capabime->(dbsetorder(2))
   
use (alltrim(FrmImpNotas.TxtArquivoNotas.value)+"\notas.dbf") alias notaimpo new
index on notaimpo->not_funcio to notaimpo.ntx

use (alltrim(FrmImpNotas.TxtArquivoNotas.value)+"\capabime.dbf") alias capaimpo new
index on capaimpo->cap_funcio to capaimpo.ntx 

if notaimpo->(dbseek(alltrim(frmImpNotas.txtfuncio.value)))
   do while !notaimpo->(eof()) 
      if notaimpo->not_funcio==alltrim(frmImpNotas.txtfuncio.value) .and. notaimpo->not_bim = cBimestreAtual .and. notaimpo->not_ano = cAnoLetivoAtual
         if notas->(dbseek(notaimpo->not_empre+notaimpo->not_setor+notaimpo->not_funcio+notaimpo->not_cargo+notaimpo->not_ano+notaimpo->not_bim+notaimpo->not_chamad+notaimpo->not_aluno))            
            if (!empty(notaimpo->not_nota) .or. !empty(notaimpo->not_faltas)) .and. (empty(notas->not_nota) .and. empty(notas->not_faltas))
               if !TentaAcesso("NOTAS");return;endif            
               replace notas->not_nota   with notaimpo->not_nota
               replace notas->not_faltas with notaimpo->not_faltas
               replace notas->not_compen with notaimpo->not_compen
               notas->(dbunlockall())
               nContaNotasImportadas++
            endif
         else
            notas->(dbappend())
            for i = 1 to notaimpo->(fcount())
               notas->(fieldput(i, notaimpo->(fieldget(i))))
            next i 
            replace notas->not_codigo with strzero(notas->(recno()),6,0)
            nContaNotasImportadas++
         endif
      endif
      notaimpo->(dbskip(1))
   enddo            
else
   msgStop("Arquivo de NOTAS. Não achei código do funcionário no arquivo a ser importado. Verifique.")               
endif
if capaimpo->(dbseek(alltrim(frmImpNotas.txtfuncio.value)))
   do while !capaimpo->(eof())
     if capaimpo->cap_funcio==alltrim(frmImpNotas.txtfuncio.value) .and. capaimpo->cap_bim = cBimestreAtual .and. capaimpo->cap_ano = cAnoLetivoAtual
        if capabime->(dbseek(capaimpo->cap_empr+capaimpo->cap_setor+capaimpo->cap_funcio+capaimpo->cap_cargo+capaimpo->cap_ano+capaimpo->cap_bim))            
           if (!empty(capaimpo->cap_aulapr) .or. !empty(capaimpo->cap_aulada)) .and. (empty(capabime->cap_aulapr) .and. empty(capabime->cap_aulada))
               if !TentaAcesso("CAPABIME");return;endif            
               replace capabime->cap_aulapr with capaimpo->cap_aulapr
               replace capabime->cap_aulada with capaimpo->cap_aulada
               capabime->(dbunlockall())
               nContaCapabime++
            endif
        else
           capabime->(dbappend())
           for i = 1 to capaimpo->(fcount())
              capabime->(fieldput(i, capaimpo->(fieldget(i))))
           next i
           replace capabime->cap_codigo with strzero(capabime->(recno()),6,0)
           nContaCapabime++
        endif
     endif
     capaimpo->(dbskip(1))
   enddo            
else
   msgStop("Arquivo CAPA DO BIMESTRE. Não achei código do funcionário no arquivo a ser importado. Peça para o professor digitar as Aulas Previstas e Dadas.")               
endif
msginfo("Fim da Importação. Quantidade de Notas Importadas = "+str(nContaNotasImportadas)+". Quantidade de Capas de Bimestre importadas = "+str(nContaCapabime))
close notaimpo
close capaimpo
FrmImpNotas.release
return

//---------------------------------------------------------------------------
procedure JuntaConselhoseNotas()  //junta num mesmo pendrive (ou unidade de disco) os conselhos feitos em pendrives (pu unidades de disco) diferentes. Essa opção foi necessária porque é necessário algumas vezes optmizar o conselho, fazendo-o ao mesmo tempo em salas diferentes da escola.
//---------------------------------------------------------------------------
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmJuntaConselhosENotas"
cAliasBrowse:=cAliasTab:='setor'

DEFINE WINDOW FrmJuntaConselhosENotas AT 10,5 WIDTH 480 HEIGHT 150 TITLE "Junta Conselhos de Classe e Notas" MODAL NOSIZE
   DEFINE LABEL LblSerie
      ROW    10
      COL    8
      WIDTH  80
      HEIGHT 20
      VALUE "Série: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtSerie
      ROW    10
      COL    130
      WIDTH  60
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE ""
   end TEXTBOX
   DEFINE BUTTON ButCon
      ROW    10
      COL    195
      WIDTH  15
      HEIGHT 14
      CAPTION "P"
      ACTION Consulta("SETOR",{"TxtSerie","setor->set_codigo"}, "setor->set_descri", .f., 1, 1, {})
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
      TABSTOP .F.
   END BUTTON
   DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
      ROW    10
      COL    215
      WIDTH  230
      HEIGHT 12
      *BACKCOLOR {253,253,253}
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE LABEL LblUnidadeDeDisco
      ROW    35
      COL    8
      WIDTH  130
      HEIGHT 45
      VALUE "Pasta da  Unidade de Disco (pendrive) a ser importada: "
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtUnidadeDeDisco
      ROW    37
      COL    130
      WIDTH  290
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
      UPPERCASE .T.
      ONGOTFOCUS  setproperty("FrmJuntaConselhosENotas","ImgPicker","enabled",.t.) //é necessárias as duas linhas aqui em sequência pois estava dando erro de vetor quando o operado clicava no img_picker sem o foco estar no campo imgtext       
      ONLOSTFOCUS setproperty("FrmJuntaConselhosENotas","ImgPicker","enabled",.f.)        
      TOOLTIP 'Clique nesta caixa de texto para habilitar procura na pasta ao lado'
      TRANSPARENT .T.
   END TEXTBOX
   DEFINE IMAGE ImgPicker
      ROW    37
      COL    422
      WIDTH  18
      HEIGHT 19
      PICTURE "PASTA"
      STRETCH .T.
      ACTION LocalizaPendrive()
      TRANSPARENT .T.
   END IMAGE

   DEFINE BUTTON ButConfirma
      ROW    70
      COL    115
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION ExecutaJuntaConselhosENotas()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON

   DEFINE BUTTON ButCancela
      ROW    70
      COL    210
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmJuntaConselhosENotas.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmJuntaConselhosENotas
ACTIVATE WINDOW FrmJuntaConselhosENotas
cFormAtivo:=cFormAnterior
Return

//---------------------------------------------------------------------------
Procedure LocalizaPendrive()  //Abre janela de unidades para operador escolher pendrive a ser juntado
//---------------------------------------------------------------------------
Setproperty("FrmJuntaConselhosENotas","TxtUnidadeDeDisco", "value", getfolder("Pasta \Mestre\Database"))
return

//---------------------------------------------------------------------------
procedure ExecutaJuntaConselhoseNotas()
//---------------------------------------------------------------------------
Local i

if empty(FrmJuntaConselhosENotas.txtserie.value) .or. empty(FrmJuntaConselhosENotas.TxtUnidadeDeDisco.value)
   msgbox("Campos obrigatórios não informados.")
   return
endif   

if !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\notas.dbf"))    .or. ;
   !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\capabime.dbf")) .or. ;
   !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\conselho.dbf")) .or. ;
   !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\consitem.dbf")) .or. ;
   !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\alunos.dbf"))   .or. ;
   !file((alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\turmas.dbf"))
   MsgStop("Pasta Mestre não encontrada na unidade de disco informada! Informe uma unidade válida.")
   return
endif

if !msgyesno("Confirma juntar TODOS os dados de Notas, Conselho e Aulas Dadas da série "+FrmJuntaConselhoseNotas.txtSerie.value+"?","",.f.)
   return
endif    

LimpaRelacoes()

notas->(dbsetorder(1)) //NOTAS->NOT_EMPRE+NOTAS->NOT_SETOR+NOTAS->NOT_FUNCIO+NOTAS->NOT_CARGO+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_CHAMAD+NOTAS->NOT_ALUNO
capabime->(dbsetorder(2)) //CAPABIME->CAP_EMPR+CAPABIME->CAP_SETOR+CAPABIME->CAP_FUNCIO+CAPABIME->CAP_CARGO+CAPABIME->CAP_ANO+CAPABIME->CAP_BIM
conselho->(dbsetorder(2)) //CONSELHO->CON_EMPRE+CONSELHO->CON_ANO+CONSELHO->CON_SETOR+CONSELHO->CON_BIM
consitem->(dbsetorder(1)) //CONSITEM->CIT_EMPRE+CONSITEM->CIT_CODIGO+CONSITEM->CIT_ALUNO
alunos->(dbsetorder(1)) //ALUNOS->ALU_EMPRE+ALUNOS->ALU_CODIGO 
turmas->(dbsetorder(2)) //TURMAS->TUR_EMPRE+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_CHAMAD+TURMAS->TUR_ALUNO

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\notas.dbf") alias notaimpo new
index on notaimpo->not_empre+notaimpo->not_setor+notaimpo->not_ano+notaimpo->not_bim to notaimpo.ntx

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\capabime.dbf") alias capaimpo new
index on capaimpo->cap_empr+capaimpo->cap_setor+capaimpo->cap_ano+capaimpo->cap_bim to capaimpo.ntx 

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\conselho.dbf") alias conseimp new
index on conseimp->con_empre+conseimp->con_setor+conseimp->con_ano+conseimp->con_bim to conseimp.ntx 

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\consitem.dbf") alias consiimp new
index on consiimp->cit_empre+consiimp->cit_conse to consiimp.ntx 

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\alunos.dbf") alias alunoimp new
index on alunoimp->alu_empre+alunoimp->alu_codigo to alunoimp.ntx 

use (alltrim(FrmJuntaConselhoseNotas.TxtUnidadeDeDisco.value)+"mestre\database\turmas.dbf") alias turmaimp new
index on turmaimp->tur_empre+turmaimp->tur_setor+turmaimp->tur_ano+turmaimp->tur_chamad+turmaimp->tur_aluno to turmaimp.ntx

if notaimpo->(dbseek(cEmpresa+alltrim(FrmJuntaConselhoseNotas.txtSerie.value)+cAnoLetivoAtual+cBimestreAtual))
   do while !notaimpo->(eof()) .and. notaimpo->not_setor==alltrim(FrmJuntaConselhoseNotas.txtSerie.value) 
      if notaimpo->not_ano = cAnoLetivoAtual .and. notaimpo->not_bim = cBimestreAtual
         if notas->(dbseek(notaimpo->not_empre+notaimpo->not_setor+notaimpo->not_funcio+notaimpo->not_cargo+notaimpo->not_ano+notaimpo->not_bim+notaimpo->not_chamad+notaimpo->not_aluno))            
            if !TentaAcesso("NOTAS");return;endif            
            replace notas->not_nota   with notaimpo->not_nota
            replace notas->not_faltas with notaimpo->not_faltas
            replace notas->not_compen with notaimpo->not_compen
            for i = 13 to 24 //pega mencoes do conselho (campos número 13 a 24 do arquivo de notas)
               notas->(fieldput(i, notaimpo->(fieldget(i))))
            next i
            notas->(dbunlockall())
         else
            notas->(dbappend())
            for i = 1 to notaimpo->(fcount())
               notas->(fieldput(i, notaimpo->(fieldget(i))))
            next i
            replace notas->not_codigo with strzero(notas->(recno()),6,0) 
         endif
      endif
      notaimpo->(dbskip(1))
   enddo            
else
   msgStop("Arquivo de NOTAS. Não achei a série requerida no arquivo a ser juntado. Verifique.")               
endif
if capaimpo->(dbseek(cEmpresa+alltrim(FrmJuntaConselhoseNotas.txtSerie.value)+cAnoLetivoAtual+cBimestreAtual))
   do while !capaimpo->(eof()) .and. capaimpo->cap_setor==alltrim(FrmJuntaConselhoseNotas.txtSerie.value) 
     if capaimpo->cap_ano = cAnoLetivoAtual .and. capaimpo->cap_bim = cBimestreAtual
        if capabime->(dbseek(capaimpo->cap_empr+capaimpo->cap_setor+capaimpo->cap_funcio+capaimpo->cap_cargo+capaimpo->cap_ano+capaimpo->cap_bim))            
           if !TentaAcesso("CAPABIME");return;endif            
           replace capabime->cap_aulapr with capaimpo->cap_aulapr
           replace capabime->cap_aulada with capaimpo->cap_aulada
           capabime->(dbunlockall())
        else
           capabime->(dbappend())
           for i = 1 to capaimpo->(fcount())
              capabime->(fieldput(i, capaimpo->(fieldget(i))))
           next i
           replace capabime->cap_codigo with strzero(capabime->(recno()),6,0) 
        endif
     endif
     capaimpo->(dbskip(1))
   enddo            
else
   msgStop("Arquivo CAPA DO BIMESTRE. Não achei a série requerida no arquivo a ser juntado. Verifique.")               
endif

if conseimp->(dbseek(cEmpresa+alltrim(FrmJuntaConselhoseNotas.txtSerie.value)+cAnoLetivoAtual+cBimestreAtual))
   do while !conseimp->(eof()) .and. conseimp->con_setor=alltrim(FrmJuntaConselhoseNotas.txtSerie.value)
     if conseimp->con_ano = cAnoLetivoAtual .and. conseimp->con_bim = cBimestreAtual
        if conselho->(dbseek(conseimp->con_empre+conseimp->con_ano+conseimp->con_setor+conseimp->con_bim))            
           if !TentaAcesso("CONSELHO");return;endif            
           for i = 6 to conselho->(fcount())
              conselho->(fieldput(i, conseimp->(fieldget(i))))
           next i
           conselho->(dbunlockall())
        else
           conselho->(dbappend())
           for i = 1 to conseimp->(fcount())
              conselho->(fieldput(i, conseimp->(fieldget(i))))
           next i
           replace conselho->con_codigo with strzero(conselho->(recno()),6,0) 
        endif
        if consiimp->(dbseek(cEmpresa+conseimp->con_codigo))
           do while !consiimp->(eof()) .and. consiimp->cit_conse=conseimp->con_codigo 
              if consitem->(dbseek(consiimp->cit_empre+consiimp->cit_codigo+consiimp->cit_aluno))            
                 if !TentaAcesso("CONSITEM");return;endif            
                 for i = 5 to consitem->(fcount())
                    consitem->(fieldput(i, consiimp->(fieldget(i))))
                 next i
                 consitem->(dbunlockall())
              else
                 consitem->(dbappend())
                 for i = 1 to consitem->(fcount())
                    consitem->(fieldput(i, consiimp->(fieldget(i))))
                 next i
                 replace consitem->cit_codigo with strzero(consitem->(recno()),6,0)
                 replace consitem->cit_conse  with conselho->con_codigo                  
              endif
              if alunoimp->(dbseek(consiimp->cit_empre+consiimp->cit_aluno))
                 alunos->(dbgoto(alunoimp->(recno())))
                 if !TentaAcesso("alunos");return;endif
                 replace alunos->alu_hipote with alunoimp->alu_hipote
                 alunos->(dbunlockall())
              endif                
              if turmaimp->(dbseek(consiimp->cit_empre+conseimp->con_setor+cAnoLetivoAtual+consiimp->cit_chamad+consiimp->cit_aluno))
                 turmas->(dbgoto(turmaimp->(recno())))
                 if !TentaAcesso("turmas");return;endif
                 replace turmas->tur_evadid with turmaimp->tur_evadid
                 turmas->(dbunlockall())
              endif                
              consiimp->(dbskip(1))   
           enddo
        else
           msgbox("Item do conselho a ser juntado não encontrado. Verifique.")
        endif   
     endif
     conseimp->(dbskip(1))
   enddo            
else
   msgStop("Arquivo CONSELHO. Não achei a série requerida no arquivo a ser juntado. Verifique.")               
endif
consitem->(dbsetorder(2)) //volta para o índice original do programa
close notaimpo
close capaimpo
close conseimp
close consiimp
close alunoimp
close turmaimp
msginfo("Fim do Juntamento dos Conselhos.")
FrmJuntaConselhosENotas.release
return

//---------------------------------------------------------------------------
function Minutos()
//---------------------------------------------------------------------------
Local tUso
if !conselho->con_fecha  //não conta tempo se conselho foi fechado
   tUso:= TimeToSec(alltrim(conselho->con_tempo))+(Seconds() - tInicial) 
   setproperty("FrmConselho", "lblTimer", "value", SecToTime(tUso))
else
   setproperty("FrmConselho", "lblTimer", "value", "FECHADO")
endif
return .t.

//---------------------------------------------------------------------------
procedure SairConselho()
//---------------------------------------------------------------------------
Local tUso:= (Seconds() - tInicial) 
if !TentaAcesso("CONSELHO");return;endif
if !conselho->con_fecha
   replace conselho->con_tempo with SecToTime(TimeToSec(alltrim(conselho->con_tempo))+ tUso)
endif
*if !conselho->con_fecha
*   if msgyesno("Fecha o conselho desta série?")
*      replace conselho->con_fecha with .t.
*   endif
*endif
Conselho->(dbunlock())
FrmConselho.release
return

//---------------------------------------------------------------------------
procedure LancaTotalAulas()
//---------------------------------------------------------------------------
capabime->(dbsetorder(2))
capabime->(dbseek(cEmpresa+setor->set_codigo+cCodFuncionario+cCodCargo+cAnoLetivoAtual+cBimestreAtual))
produtos->(dbseek(cEmpresa+setor->set_produt))
if val(cBimestreAtual)=val(produtos->pro_qtdbim)+1
   msgstop("Alterne para o último bimestre a fim de lançar total de aulas.")
   return 
endif      

DEFINE WINDOW FrmTotalAulas AT 60,25 WIDTH 330 HEIGHT 140 TITLE "Lançamento de Total de Aulas no Bimestre" MODAL NOSIZE
   DEFINE LABEL LblAulasPrevistas
      ROW    10
      COL    23
      WIDTH  250
      HEIGHT 20
      VALUE "Quantidade de Aulas Previstas: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtAulasPrevistas
      ROW    10
      COL    225
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE capabime->cap_aulapr
   end TEXTBOX

   DEFINE LABEL LblAulasDadas
      ROW    37
      COL    23
      WIDTH  250
      HEIGHT 20
      VALUE "Quantidade de Aulas Dadas: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtAulasDadas
      ROW    35
      COL    225
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE capabime->cap_aulada
   end TEXTBOX

   DEFINE BUTTON ButSalva
      ROW    75
      COL    80
      WIDTH  65
      HEIGHT 21
      CAPTION "Salvar"
      ACTION SalvaAulasDadas()
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON

   DEFINE BUTTON ButCancela
      ROW    75
      COL    165
      WIDTH  65
      HEIGHT 21
      CAPTION "Sair"
      ACTION FrmTotalAulas.release
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmTotalAulas
ACTIVATE WINDOW FrmTotalAulas
Return

//---------------------------------------------------------------------------
Procedure SalvaAulasDadas()
//---------------------------------------------------------------------------
if msgyesno("Confirma Salvar Aulas dadas?")
   if !capabime->(found())
      capabime->(dbappend())
   else
      if !TentaAcesso("CAPABIME");return;endif
   endif   
   replace capabime->cap_empr   with cEmpresa
   replace capabime->cap_codigo with strzero(capabime->(recno()),6,0)
   replace capabime->cap_setor  with setor->set_codigo
   replace capabime->cap_ano    with cAnoLetivoAtual
   replace capabime->cap_bim    with cBimestreAtual
   replace capabime->cap_funcio with cCodFuncionario
   replace capabime->cap_cargo  with cCodCargo
   replace capabime->cap_aulapr with alltrim(FrmTotalAulas.txtAulasPrevistas.value)
   replace capabime->cap_aulada with alltrim(FrmTotalAulas.txtAulasDadas.value)
   capabime->(dbunlockall())
   msginfo("Informações Atualizadas!")
endif
return

//---------------------------------------------------------------------------
procedure ConceitoFinal()
//---------------------------------------------------------------------------
produtos->(dbseek(cEmpresa+setor->set_produt))
if cBimestreAtual==produtos->pro_qtdbim
   cBimestreAtual:=strzero(val(cBimestreAtual)+1,1,0) //acrescenta mais um para ir para o conceito final
   if populanotas()
      BrowseWindow.BwsGenerico.enabled:=.f. //desabilita browse principal enquanto estiver ativo o conceito final
      principe.statusbar.item(2):="Bim.Atual: "+cBimestreAtual
      setproperty("TabWindow","ButtFun03_05","Caption","Últ.Bimestre")
      msginfo("Notas para Conceito Final em vigor. Clique no botão 'Últ.Bimestre' antes de fechar estas janela.")
   else
      cBimestreAtual :=produtos->pro_qtdbim
      msginfo("Mantido notas para o "+cBimestreAtual+"º bimestre.")
   endif
elseif val(cBimestreAtual)>val(produtos->pro_qtdbim)
   cBimestreAtual:=strzero(val(cBimestreAtual)-1,1,0) //subtrai um para voltar para o último bimestre
   if populanotas()
      BrowseWindow.BwsGenerico.enabled:=.t. //habilita browse principal novamente
      principe.statusbar.item(2):="Bim.Atual: "+cBimestreAtual
      setproperty("TabWindow","ButtFun03_05","Caption","Últ.Conceito")
      msginfo("Notas para "+cBimestreAtual+"º bimestre novamente em vigor.")
   else
      cBimestreAtual:=strzero(val(produtos->pro_qtdbim)+1,1,0)
      msginfo("Mantido notas para o Conceito Final. Clique no botão 'Últ.Bimestre' antes de fechar esta janela.")
   endif       
else
   msgstop("Função ativa somente no "+produtos->pro_qtdbim+"º bimestre")
endif
return     

//---------------------------------------------------------------------------
procedure LancaNotaTransferido()
//---------------------------------------------------------------------------
DEFINE WINDOW FrmLcaNotaTr AT 60,25 WIDTH 330 HEIGHT 150 TITLE "Lançamento de Notas Alunos Transferidos" MODAL NOSIZE
   DEFINE LABEL LblAulasPrevistas
      ROW    10
      COL    8
      WIDTH  150
      HEIGHT 20
      VALUE "Aluno: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtAluno
      ROW    10
      COL    160
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX

   DEFINE LABEL LblTurma
      ROW    35
      COL    8
      WIDTH  150
      HEIGHT 20
      VALUE "Turma: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtTurma
      ROW    35
      COL    160
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX

   DEFINE LABEL LblTurma
      ROW    35
      COL    8
      WIDTH  150
      HEIGHT 20
      VALUE "Turma: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtTurma
      ROW    35
      COL    160
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE BUTTON ButSalva
      ROW    70
      COL    40
      WIDTH  65
      HEIGHT 21
      CAPTION "Salvar"
      ACTION SalvaAulasDadas()
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON

   DEFINE BUTTON ButCancela
      ROW    70
      COL    125
      WIDTH  65
      HEIGHT 21
      CAPTION "Sair"
      ACTION FrmTotalAulas.release
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON

END WINDOW
CENTER WINDOW FrmTotalAulas
ACTIVATE WINDOW FrmTotalAulas
Return

//---------------------------------------------------------------------------
function VerifItemRelacionado(cBDPai, cBDFilho, cBDCampo)
//---------------------------------------------------------------------------
if &(cBDFilho)->(dbseek(cEmpresa+&(cBDPai)->&(cBDCampo))) 
   msgbox("Registro não pode ser excluído. Há registros em "+cBDFilho+" relacionados a ele.")
   return .f.
endif   
return .t.

//---------------------------------------------------------------------------
procedure ConfiguraSistema()
//---------------------------------------------------------------------------
CriaDbfs(.f.)    //cria dbfs, se não houver
reindexa()    //cria índices, se não houver
empresa->(dbgotop())

if setor->(dbseek(empresa->emp_codigo,.t.))
   if funciona->(dbseek(empresa->emp_codigo,.t.))
      if atribuir->(dbseek(empresa->emp_codigo,.t.))
         msgbox("Sistema já configurado!")
         return
      endif   
   endif
endif

DEFINE WINDOW FrmConfig AT 30,15 WIDTH 630 HEIGHT 350 TITLE "Configuração Inicial do Sistema" MODAL NOSIZE
   DEFINE LABEL LblEmpresa
      ROW    10
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Nome Completo da Escola (Ex: E.E. Antonio Adib Chammas): "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtEmpresa
      ROW    25
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX

   DEFINE LABEL LblAdmin
      ROW    50
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Nome do Administrador do sistema (Não pode ter aula atribuída): "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtFunciona
      ROW    65
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL LblCargo
      ROW    90
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Cargo/Função que ocupa (Ex: DIRETOR/COORDENADOR/SECRETÁRIA/AGENTE ESCOLAR): "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtCargo
      ROW    105
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL LblSetor
      ROW    130
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Setor (Ex: DIREÇÃO/COORDENAÇÃO/SECRETARIA):"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtSetor
      ROW    145
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL LblAnoLetivo
      ROW    170
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Ano Letivo (4 DÍGITOS):"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtAnoLetivo
      ROW    185
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      INPUTMASK "9999"
   end TEXTBOX
   DEFINE LABEL LblBimestre
      ROW    210
      COL    8
      WIDTH  600
      HEIGHT 20
      VALUE "Bimestre (1 DÍGITO):"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtBimestre
      ROW    225
      COL    08
      WIDTH  600
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      INPUTMASK "9"
   end TEXTBOX
   DEFINE BUTTON ButSalva
      ROW    250
      COL    150
      WIDTH  90
      HEIGHT 35
      CAPTION "Salvar"
      ACTION SalvaConfig()
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    250
      COL    350
      WIDTH  90
      HEIGHT 35
      CAPTION "Sair"
      ACTION FrmConfig.release
      FONTNAME "Verdana"
      FONTSIZE 7
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmConfig
ACTIVATE WINDOW FrmConfig
Return

//---------------------------------------------------------------------------
Procedure SalvaConfig()
//---------------------------------------------------------------------------
empresa->(dbgotop())  //verifica se já registros cadastrados. Não configura se já houver registros.
if empty(FrmConfig.TxtEmpresa.value) .or. empty(FrmConfig.TxtSetor.value) .or. empty(FrmConfig.TxtCargo.value) .or. empty(FrmConfig.TxtFunciona.value) .or. empty(FrmConfig.TxtAnoLetivo.value) .or. empty(FrmConfig.TxtBimestre.value)
   msgbox("Preencha todos os campos!")
   return
endif
   
empresa->(dbappend())
replace empresa->emp_codigo with strzero(empresa->(recno()),6,0)
replace empresa->emp_nome   with alltrim(FrmConfig.TxtEmpresa.value)
replace empresa->emp_ano    with alltrim(FrmConfig.TxtAnoletivo.value)
replace empresa->emp_bim    with alltrim(FrmConfig.TxtBimestre.value)

setor->(dbappend())
replace setor->set_empre  with empresa->emp_codigo
replace setor->set_codigo with strzero(setor->(recno()),6,0)
replace setor->set_descri with alltrim(FrmConfig.TxtSetor.value)
replace setor->set_ano    with alltrim(FrmConfig.TxtAnoLetivo.value)

funciona->(dbappend())
replace funciona->fun_empre  with empresa->emp_codigo
replace funciona->fun_codigo with strzero(setor->(recno()),6,0)
replace funciona->fun_nome   with alltrim(FrmConfig.TxtFunciona.value)

cargos->(dbappend())
replace cargos->car_empre  with empresa->emp_codigo
replace cargos->car_codigo with strzero(cargos->(recno()),6,0)
replace cargos->car_descri with FrmConfig.TxtCargo.value

Atribuir->(dbappend())
replace atribuir->atr_empre  with empresa->emp_codigo
replace atribuir->atr_codigo with strzero(atribuir->(recno()),6,0)
replace atribuir->atr_setor  with setor->set_codigo
replace atribuir->atr_funcio with funciona->fun_codigo
replace atribuir->atr_cargo  with cargos->car_codigo

Begin ini file ("CONFIG.INI")
  Set Section "CONFIGURATION" ENTRY "Master"  To funciona->fun_codigo
End ini

msgbox("Pronto! O sistema será finalizado. Entre novamente para carregar novos registros.")
FrmConfig.release
dbcloseall()
quit

//---------------------------------------------------------------------------
Procedure ImportaAlunosTurmas()
//---------------------------------------------------------------------------
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmImpAlunoTurma"
cAliasBrowse:=cAliasTab:='funciona'

DEFINE WINDOW FrmImpAlunoTurma AT 10,5 WIDTH 420 HEIGHT 100 TITLE "Importa Alunos x Turmas" MODAL NOSIZE
   DEFINE LABEL LblCSV
      ROW    10
      COL    8
      WIDTH  100
      HEIGHT 20
      VALUE "Arquivo CSV: "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtCSV
      ROW    10
      COL    94
      WIDTH  280
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE ""
   end TEXTBOX
   DEFINE IMAGE CSVPicker
      ROW    11
      COL    380
      WIDTH  18
      HEIGHT 19
      PICTURE "PASTA"
      STRETCH .T.
      ACTION Setproperty("FrmImpAlunoTurma","TxtCSV", "value", getfile({{"alunoXturma.csv","alunoXturma.csv"}},"Selecione arquivo de importação"))
      TRANSPARENT .T.
   END IMAGE

   DEFINE BUTTON ButConfirma
      ROW    35
      COL    115
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION ExecutaImportaAlunoTurma()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON

   DEFINE BUTTON ButCancela
      ROW    35
      COL    210
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmImpAlunoTurma.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmImpAlunoTurma
ACTIVATE WINDOW FrmImpAlunoTurma
cFormAtivo:=cFormAnterior
Return

//---------------------------------------------------------------------------
Procedure ExecutaImportaAlunoTurma()
//---------------------------------------------------------------------------
Local arq, nTamArq, nCampo, cCampo:="", nLinha:=i:=0, nContaAlunosImporta:=0
if empty(FrmImpAlunoTurma.TxtCSV.value)
   msgExclamation("Favor informar o arquivo para importar.")
   return
endif      
LimpaRelacoes()
setor->(dbsetorder(2))    //ordem de descricao+ano
turmas->(dbsetorder(3))   //ordem de aluno+setor+ano
alunos->(dbsetorder(2))   //ordem de nome
ocorreal->(dbsetorder(2)) //ordem de aluno. Essa é a ordem principal do bd no sistema
arq:=fopen(GetProperty("FrmImpAlunoTurma","TxtCSV", "value"))
if ferror()=0   //testa se nao houve erro ao abrir o arquivo
   for i = 1 to 2
   	iif(i=1,msgbox("Vou verificar arquivo a fim de ver se está tudo ok. Aguarde..."),msgbox("Tudo OK. Agora vou importar arquivo. Aguarde..."))
   	cCampo:=""
      nTamArq:=fseek(arq, 0, 2)  //verifica o seu tamanho
      nCampo:=1
   	fseek(arq,0,0) //move para inicio do arquivo
   	do while fseek(arq, 0,1) < nTamArq  //faca enquanto nao exceder o tamanho do arquivo
         if freadstr(arq,1) = chr(10) //descarta a primeira linha, pois trata-se do cabeçalho do arquivo de importação
            nLinha:=2
            exit
         endif
      enddo        
   	do while fseek(arq, 0,1) < nTamArq  //faca enquanto nao exceder o tamanho do arquivo
         cCaracter:=freadstr(arq,1)
         if cCaracter<>";" .and. cCaracter<>chr(13)
            cCampo+=cCaracter
         endif  
         if cCaracter = chr(13)
            cCaracter:=freadstr(arq,1)
            nLinha++
         endif
         if cCaracter = ";" .or. cCaracter=chr(10)
            if !empty(alltrim(cCampo))
               do case
                  case nCampo = 1 
                     if len(alltrim(cCampo))=2 .and. substr(cCampo,1,1)$"123456789" .and. upper(substr(alltrim(cCampo),-1))$"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                        if !setor->(dbseek(cEmpresa+upper(alltrim(cCampo))+space(18)+cAnoLetivoAtual))  //O campo "Descrição do Setor" tem 20 caracteres. Está implícito aqui que o operador informou descrição do setor no formado XX (5A, por exemplo)
                           if !(alltrim(cCampo) == alltrim(setor->set_descri))  //impede duplicidades de setor
                              if i = 2
                                 setor->(dbappend())
                                 replace setor->set_empre  with cEmpresa
                                 replace setor->set_codigo with strzero(setor->(recno()),6,0)
                                 replace setor->set_descri with alltrim(upper(cCampo))
                                 replace setor->set_ano    with cAnoLetivoAtual
                                 replace setor->set_ehaula with .t. 
                              endif
                           endif
                        endif
                     else
                        msgbox("Linha:"+str(nLinha)+". Setor informado no arquivo CSV com formato errado. Informe setor com dois caracteres. Exemplo: 5A")   
                        setor->(dbsetorder(1))
                        alunos->(dbsetorder(1))
                        turmas->(dbsetorder(2))
                        fclose(Arq)
                        return
                     endif
                  case nCampo = 2
                     if !alunos->(dbseek(cEmpresa+upper(alltrim(cCampo)))) //verifica se nome já consta no cadastro de alunos
                        if i = 2
                           alunos->(dbappend())
                           replace alunos->alu_nome   with upper(alltrim(cCampo))
                           replace alunos->alu_empre  with cEmpresa 
                           replace alunos->alu_codigo with strzero(alunos->(recno()),6,0)
                           replace alunos->alu_setor  with setor->set_codigo
                           nContaAlunosImporta++
                        endif 
                     endif 
                  case nCampo = 3
                     if !turmas->(dbseek(cEmpresa+alunos->alu_codigo+strzero(val(cCampo),2,0)+setor->set_codigo+cAnoLetivoAtual))
                        if i = 2
                           turmas->(dbappend())
                           replace turmas->tur_empre  with cEmpresa
                           replace turmas->tur_codigo with strzero(turmas->(recno()),6,0)
                           replace turmas->tur_setor  with setor->set_codigo
                           replace turmas->tur_aluno  with alunos->alu_codigo
                           replace turmas->tur_status with "MATRICULADO(A)"
                           replace turmas->tur_chamad with strzero(val(cCampo),2,0)
                           replace turmas->tur_ano    with cAnoLetivoAtual
                        endif
                     endif
                  case nCampo = 4
                     if !alunos->(found()) //só preenche campo na primeira vez que é incluído registro
                        if i = 2
                           replace alunos->alu_ra     with cCampo
                        endif
                     endif   
                  case nCampo = 5
                     if !alunos->(found())
                        if i = 2
                           replace alunos->alu_nasc   with ctod(cCampo)
                        endif
                     endif
                  case nCampo = 6
                     if !turmas->(found())
                        if i = 2
                           replace turmas->tur_datast with ctod(cCampo)
                        endif
                     endif
                     if !ocorreal->(dbseek(cEmpresa+alunos->alu_codigo))
                        if i = 2
                           ocorreal->(dbappend())
                           replace ocorreal->occal_empr with cEmpresa
                           replace ocorreal->occal_codi with strzero(ocorreal->(recno()),6,0)
                           replace ocorreal->occal_alun with alunos->alu_codigo
                           replace ocorreal->occal_seto with setor->set_codigo
                           replace ocorreal->occal_dtin with ctod(cCampo)
                           replace ocorreal->occal_dtfi with ctod('31/12/'+cAnoLetivoAtual)
                           replace ocorreal->occal_ocor with "MATRICULADO(A)"
                        endif
                     endif
               endcase
            else
               msgbox("Linha:"+str(nLinha)+". Campo Vazio no arquivo de importação")
               setor->(dbsetorder(1))
               alunos->(dbsetorder(1))
               turmas->(dbsetorder(2))
               fclose(Arq)
               return
            endif
            nCampo++
            cCampo:=""
            if cCaracter = chr(10)
               nCampo:=1
            endif   
         endif
      enddo   
   next i
   fclose(Arq)   //fecha arquivo
else
   Msgbox("Erro abrindo arquivo: "+GetProperty("FrmImpAlunoTurma","TxtCSV", "value"))
endif
setor->(dbsetorder(1))
alunos->(dbsetorder(1))
turmas->(dbsetorder(2))
msgbox("Fim de processamento. Total de alunos enturmados = "+str(nContaAlunosImporta))
FrmImpAlunoTurma.release
return

//--------------------------------------------------------------------------
Function VerifDuplicidadeNome(pNome)
//--------------------------------------------------------------------------
Local nPrimeiroEspaco:=nSegundoEspaco:=nTerceiroEspaco:=0, cPrimeiroNome, cSegundoNome, cTerceiroNome, lRetorno:=.f.
pNome:=pNome+" "
alunos->(dbsetorder(2)) //ordem de nome

nPrimeiroEspaco:=at(" ",pNome)
cPrimeiroNome:=alltrim(substr(pNome,1,nPrimeiroEspaco))

do while .t.
   nSegundoEspaco:=at(" ",substr(pNome,nPrimeiroEspaco+1))
   cSegundoNome:=alltrim(substr(pNome,nPrimeiroEspaco+1,nSegundoEspaco))
   if cSegundoNome$"DE,DA,DO,DAS,DOS"
      nPrimeiroEspaco:=nSegundoEspaco
   else
      exit
   endif      
enddo

nTerceiroEspaco:=at(" ",substr(pNome,(nPrimeiroEspaco+nSegundoEspaco+1)))
cTerceiroNome:=alltrim(substr(pNome,(nPrimeiroEspaco+nSegundoEspaco+1),nTerceiroEspaco))

if alunos->(dbseek(cEmpresa+cPrimeiroNome))
   do while !alunos->(eof()) .and. at(cPrimeiroNome, alunos->alu_nome)<>0 
      if at(cSegundoNome, alunos->alu_nome)<>0
         if !empty(cTerceiroNome)
            if at(cTerceiroNome, alunos->alu_nome)<>0
               msgbox("Nome já existente. Verifique duplicidade. Código = "+alunos->alu_codigo+" - "+alltrim(alunos->alu_nome))
               lRetorno:=.t.
               exit
            endif
         else
            msgbox("Nome já existente. Verifique duplicidade. Código = "+alunos->alu_codigo+" - "+alltrim(alunos->alu_nome))
            lRetorno:=.t.
         endif
      endif
      alunos->(dbskip(1))
   enddo
endif
alunos->(dbsetorder(1)) //ordem de codigo
return lRetorno 

//--------------------------------------------------------------------------
Procedure ZeraArquivos()  //zera todos os arquivos para começar novamente do início
//--------------------------------------------------------------------------
if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

if msgyesno("CUIDADO! Esse processo será irreversível. Faça cópia dos arquivos antes de continuar com esse procedimento. Confirma ZERAR base de dados?","",.f.)
   dbcloseall()
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"alunos","alunos",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"empresa","empresa",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"funciona","funciona",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"setor","setor",.F.,.F.)   
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"atribuir","atribuir",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"turmas","turmas",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"capabime","capabime",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"anoletiv","anoletiv",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"ocorreal","ocorreal",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"conselho","conselho",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"consitem","consitem",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"cargos","cargos",.F.,.F.)
   zap
   DBUSEAREA(.T., "DBFCDX", c_STR_Con+"notas","notas",.F.,.F.)
   zap
   msgbox("Processo concluído: arquivos zerados. O programa será finalizado. Por favor, entre novamente.")
   principe.release
   dbcloseall()
   quit
else
   msgstop("Processo cancelado pelo usuário.")
endif

//--------------------------------------------------------------------------
Procedure RemanejaAluno()
//--------------------------------------------------------------------------
local aIndice:={}, nComboItemCount, x
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0)
local nPos := GetProperty ("TabWindow", cControle, "Value")
local aRet := GetProperty ("TabWindow", cControle, 'Item', nPos )
Private nTurmasRecAnter
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmRemaneja"

if empty(nPos) //se não foi selecionado um registro no grid
   msginfo("Selecione antes um registro para mostrar imagem do aluno.")
   return
endif

nPos:=len(&(aGridCampos)) //pega ultimo valor do grid onde se encontra o recno()
dbgoto(val(aRet[nPos]))
nTurmasRecAnter:=recno()

DEFINE WINDOW FrmRemaneja AT 0,0 WIDTH 500 HEIGHT 200 TITLE "Remaneja/Transfere/Reclassifica Aluno(a)" MODAL NOSIZE
   DEFINE LABEL LblAluno
      ROW    10
      COL    8
      WIDTH  400
      HEIGHT 20
      VALUE "Aluno : "+alunos->alu_codigo+" - "+alunos->alu_nome
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE LABEL LblStatus
      ROW    35
      COL    8
      WIDTH  110
      HEIGHT 20
      VALUE "Status : "
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE COMBOBOX Combo_Status
      ROW    35
      COL    120
      WIDTH  150
      HEIGHT 130
      ITEMS {'MATRICULADO(A)','TRANSFERIDO(A)','ABANDONO','REMANEJADO(A)','RECLASSIFICADO'}
      VALUE 0
      FONTNAME "Arial"
      FONTSIZE 8
      FONTBOLD .T.
      ONCHANGE (iif(frmRemaneja.combo_status.value>3,frmRemaneja.butConSerie.enabled:=.t.,frmRemaneja.butConSerie.enabled:=.f.))
   END COMBOBOX

   //posiciona o combo no ítem que está no registro de Turma
   nComboItemCount:=getproperty("FrmRemaneja", "Combo_Status", "itemcount") //conta quantos itens tem no combo
   for x = 1 to nComboItemCount
      if alltrim(turmas->tur_status) == alltrim(getproperty("FrmRemaneja", "Combo_Status", "item", x))
         setproperty("FrmRemaneja","Combo_Status","Value", x)
         exit
      endif
   next x
   if x > nComboItemCount
      setproperty("FrmRemaneja","Combo_Status","Value", 0)
   endif
                                                 
   DEFINE LABEL LblSerie
      ROW    65
      COL    8
      WIDTH  80
      HEIGHT 20
      VALUE "Para Série:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtSerie
      ROW    65
      COL    120
      WIDTH  60
      HEIGHT 15
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE ""
   end TEXTBOX
   DEFINE BUTTON ButConSerie
      ROW    65
      COL    185
      WIDTH  15
      HEIGHT 14
      CAPTION "P"
      ACTION Consulta("SETOR",{"TxtSerie","setor->set_codigo"}, "setor->set_descri", .f., 1, 2, {})
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   END BUTTON
   DEFINE LABEL &("Label_99"+cFormAtivo+"02")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
      ROW    65
      COL    205
      WIDTH  230
      HEIGHT 12
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   END LABEL
   DEFINE LABEL LblData
      ROW    90
      COL    8
      WIDTH  110
      HEIGHT 20
      VALUE "Data do Evento:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE DATEPICKER TxtData
      ROW    90
      COL    120
      WIDTH  290
      HEIGHT 20
      VALUE nil
      FONTNAME "Verdana"
      VALUE ""
      FONTSIZE 8
      FONTBOLD .T.
   END DATEPICKER
   Define CHECKBOX Chk_Ocorre
    	ROW	115
    	COL	8
      CAPTION "Grava Ocorrência"
    	WIDTH	145
  	  HEIGHT 20
      VALUE .t.
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.      
   End CHECKBOX
   DEFINE BUTTON ButConfirma
      ROW    140
      COL    120
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION ExecutaRemanejaAluno()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    140
      COL    215
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmRemaneja.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmRemaneja
ACTIVATE WINDOW FrmRemaneja
cFormAtivo:=cFormAnterior
Return

//--------------------------------------------------------------------------                 
Procedure ExecutaRemanejaAluno()
//--------------------------------------------------------------------------
Local cAlunoCodigo, nContaAlunosTurma:=0
if getproperty("FrmRemaneja","Combo_Status","item",GetProperty("FrmRemaneja","Combo_Status", "value")) $ "REMANEJADO(A)¦RECLASSIFICADO" .and. (empty(FrmRemaneja.txtdata.value) .or. empty(FrmRemaneja.txtserie.value)) 
   msgbox("Campos obrigatórios não informados.")
   return
endif  
Setor->(dbgoto(nNumRecPri))
Turmas->(dbgoto(nTurmasRecAnter)) 

cAlunoCodigo:=turmas->tur_aluno
cSetorDescri:=setor->set_descri

//Se for Remanejamento ou Reclassificação, verifica se aluno informado já existe na turma informada
if getproperty("FrmRemaneja","Combo_Status","item",GetProperty("FrmRemaneja","Combo_Status", "value")) $ "REMANEJADO(A)¦RECLASSIFICADO" 
  //TURMAS->TUR_EMPRE+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_CHAMAD+TURMAS->TUR_ALUNO
  turmas->(dbseek(cEmpresa+getproperty("FrmRemaneja","TxtSerie","value")))
  do while turmas->(!eof()) .and. turmas->tur_setor = getproperty("FrmRemaneja","TxtSerie","value")
     if turmas->tur_aluno = cAlunoCodigo
        MsgStop("Aluno já existe na turma informada. Procedimento interrompido.")
        Setor->(dbgoto(nNumRecPri))
        Turmas->(dbgoto(nTurmasRecAnter)) 
        return
     endif   
     nContaAlunosTurma++
     turmas->(dbskip(1))
  enddo
endif    

Setor->(dbgoto(nNumRecPri))
Turmas->(dbgoto(nTurmasRecAnter)) 

if !TentaAcesso("Turmas");return;endif
if !TentaAcesso("Alunos");return;endif

replace turmas->tur_status with getproperty("FrmRemaneja","Combo_Status","item",GetProperty("FrmRemaneja","Combo_Status", "value"))
replace turmas->tur_datast with getproperty("FrmRemaneja","TxtData","value")
if getproperty("FrmRemaneja","Combo_Status","item",GetProperty("FrmRemaneja","Combo_Status", "value")) $"REMANEJADO(A)¦RECLASSIFICADO"
   replace turmas->tur_observ with "PARA "+getproperty("FrmRemaneja","Label_99FrmRemaneja02","value")
   replace alunos->alu_setor with getproperty("FrmRemaneja","TxtSerie","value")
endif    

if FrmRemaneja.chk_ocorre.value  //se operador deixou marcado para gravar evento no cadastro de ocorrências
   ocorreal->(dbappend())
   replace ocorreal->occal_empr with cEmpresa
   replace ocorreal->occal_codi with strzero(ocorreal->(recno()),6,0)
   replace ocorreal->occal_alun with turmas->tur_aluno
   replace ocorreal->occal_seto with turmas->tur_setor
   replace ocorreal->occal_dtin with turmas->tur_datast
   replace ocorreal->occal_dtfi with ctod('31/12/'+cAnoLetivoAtual)
   replace ocorreal->occal_ocor with turmas->tur_status
   replace ocorreal->occal_obse with turmas->tur_observ
endif

//Faz a mudança de turma
if getproperty("FrmRemaneja","Combo_Status","item",GetProperty("FrmRemaneja","Combo_Status", "value")) $ "REMANEJADO(A)¦RECLASSIFICADO" 
   turmas->(dbappend())
   replace turmas->tur_empre  with cEmpresa
   replace turmas->tur_codigo with strzero(turmas->(recno()),6,0)
   replace turmas->tur_setor  with getproperty("FrmRemaneja","TxtSerie","value")
   replace turmas->tur_aluno  with cAlunoCodigo
   replace turmas->tur_status with "MATRICULADO(A)"
   replace turmas->tur_chamad with strzero(nContaAlunosTurma+1,2,0)
   replace turmas->tur_ano    with cAnoLetivoAtual
   replace turmas->tur_datast with getproperty("FrmRemaneja","TxtData","value") 
   replace turmas->tur_observ with "VEIO "+cSetorDescri
endif    

Setor->(dbgoto(nNumRecPri))
Turmas->(dbgoto(nTurmasRecAnter)) 

RefreshGrid(nTabPage)
FrmRemaneja.release
return

//--------------------------------------------------------------------------                 
Function CriaDBFs(lSomenteVerificaExistencia)
//--------------------------------------------------------------------------                 
Local i, lNaoExiste:=.f.
Private aDbfNomes:={;
"AVALQUES.DBF",;
"CADITTLA.DBF",;
"GABARITO.DBF",;
"RESULTAV.DBF",;
"PRODUTOS.DBF",;
"ALUNOS.DBF",;
"AVALIAR.DBF",;
"NOTAS.DBF",;
"CONSITEM.DBF",;
"CADCAMPO.DBF",;
"CONTRATO.DBF",;
"EMPRESA.DBF",;
"MENCOES.DBF",;
"ANOLETIV.DBF",;
"SETOR.DBF",;
"CALMEDIA.DBF",;
"CADINDEX.DBF",;
"CONSELHO.DBF",; 
"FUNCIONA.DBF",;
"TURMAS.DBF",;
"CAPABIME.DBF",;
"CADBDADO.DBF",;
"OCORREAL.DBF",;
"ATRIBUIR.DBF",;
"HORARIOS.DBF",;
"CARGOS.DBF",;
"CADTELA.DBF",;
"CADTELIT.DBF"}

*--AVALQUES
Private aDbfStru01:={;
{"AVQ_EMPRE"   ,"C",006,000},;
{"AVQ_CODIGO"  ,"C",006,000},;
{"AVQ_AVALIA"  ,"C",006,000},;
{"AVQ_ORDEM"   ,"C",003,000},;
{"AVQ_RESPO"   ,"C",010,000},;
{"AVQ_VALOR"   ,"N",010,005},;
{"AVQ_TPCORR"  ,"C",060,000},;
{"AVQ_GRUPO"   ,"C",020,000}}
                                  
*--CADITTLA
Private aDbfStru02:={;
{"ITTL_EMPR"   ,"C",006,000},;
{"ITTL_CODI"   ,"C",006,000},;
{"ITTL_TELA"   ,"C",006,000},;
{"ITTL_CAMPO"  ,"C",006,000},;
{"ITTL_ORDEM"  ,"C",003,000},;
{"ITTL_ATIVO"  ,"L",001,000},;
{"ITTL_MASCA"  ,"C",050,000},;
{"ITTL_TPCTR"  ,"C",010,000},;
{"ITTL_PARA1"  ,"C",100,000},;
{"ITTL_PARA2"  ,"C",100,000},;
{"ITTL_PARA3"  ,"C",100,000},;
{"ITTL_PARA4"  ,"C",100,000},;
{"ITTL_PARA5"  ,"C",100,000},;
{"ITTL_PARA6"  ,"C",100,000}}

*--GABARITO
Private aDbfStru03:={;
{"GAB_EMPR"    ,"C",006,000},;
{"GAB_ANO"     ,"C",004,000},;
{"GAB_BIME"    ,"C",001,000},;
{"GAB_ALUN"    ,"C",006,000},;
{"GAB_NOME"    ,"C",045,000},;
{"GAB_AVAL"    ,"C",006,000},;
{"Q1"          ,"C",005,000},;
{"Q2"          ,"C",005,000},;
{"Q3"          ,"C",005,000},;
{"Q4"          ,"C",009,000},;
{"Q5"          ,"C",009,000},;
{"Q6"          ,"C",009,000},;
{"Q7"          ,"C",009,000},;
{"Q8"          ,"C",009,000},;
{"Q9"          ,"C",009,000},;
{"Q10"         ,"C",009,000},;
{"Q11"         ,"C",009,000},;
{"Q12"         ,"C",009,000},;
{"Q13"         ,"C",009,000},;
{"Q14"         ,"C",009,000},;
{"Q15"         ,"C",009,000},;
{"Q16"         ,"C",009,000},;
{"Q17"         ,"C",009,000},;
{"Q18"         ,"C",009,000},;
{"Q19"         ,"C",009,000},;
{"Q20"         ,"C",009,000},;
{"Q21"         ,"C",009,000},;
{"Q22"         ,"C",009,000},;
{"Q23"         ,"C",009,000},;
{"Q24"         ,"C",009,000},;
{"Q25"         ,"C",009,000},;
{"Q26"         ,"C",009,000},;
{"Q27"         ,"C",009,000},;
{"Q28"         ,"C",009,000},;
{"Q29"         ,"C",009,000},;
{"Q30"         ,"C",009,000},;
{"Q31"         ,"C",009,000},;
{"Q32"         ,"C",009,000},;
{"Q33"         ,"C",009,000},;
{"Q34"         ,"C",009,000},;
{"Q35"         ,"C",009,000},;
{"Q36"         ,"C",009,000},;
{"Q37"         ,"C",009,000},;
{"Q38"         ,"C",009,000},;
{"Q39"         ,"C",009,000},;
{"Q40"         ,"C",009,000},;
{"Q41"         ,"C",009,000},;
{"Q42"         ,"C",009,000},;
{"Q43"         ,"C",009,000},;
{"Q44"         ,"C",009,000},;
{"Q45"         ,"C",009,000},;
{"Q46"         ,"C",009,000},;
{"Q47"         ,"C",009,000},;
{"Q48"         ,"C",009,000},;
{"Q49"         ,"C",009,000},;
{"Q50"         ,"C",009,000},;
{"Q51"         ,"C",009,000},;
{"Q52"         ,"C",009,000},;
{"Q53"         ,"C",009,000},;
{"Q54"         ,"C",009,000},;
{"Q55"         ,"C",009,000},;
{"Q56"         ,"C",009,000},;
{"Q57"         ,"C",009,000},;
{"Q58"         ,"C",009,000},;
{"Q59"         ,"C",009,000},;
{"Q60"         ,"C",009,000}}

*-------- RESULTAV.DBF ---------+
Private aDbfStru04:={;
{"RES_EMPRES"  ,"C",006,000},;
{"RES_CODIGO"  ,"C",006,000},;
{"RES_AVALIA"  ,"C",006,000},;
{"RES_ALUNO"   ,"C",006,000},;
{"RES_GERAL"   ,"N",010,005},;
{"RES_GRUP01"  ,"N",010,005},;
{"RES_GRUP02"  ,"N",010,005},;
{"RES_GRUP03"  ,"N",010,005},;
{"RES_GRUP04"  ,"N",010,005},;
{"RES_GRUP05"  ,"N",010,005},;
{"RES_GRUP06"  ,"N",010,005},;
{"RES_GRUP07"  ,"N",010,005},;
{"RES_GRUP08"  ,"N",010,005},;
{"RES_GRUP09"  ,"N",010,005},;
{"RES_GRUP10"  ,"N",010,005},;
{"RES_GRUP11"  ,"N",010,005},;
{"RES_GRUP12"  ,"N",010,005},;
{"RES_GRUP13"  ,"N",010,005},;
{"RES_GRUP14"  ,"N",010,005},;
{"RES_GRUP15"  ,"N",010,005},;
{"RES_GRUP16"  ,"N",010,005},;
{"RES_GRUP17"  ,"N",010,005},;
{"RES_GRUP18"  ,"N",010,005},;
{"RES_GRUP19"  ,"N",010,005},;
{"RES_GRUP20"  ,"N",010,005},;
{"RES_NOME01"  ,"C",003,000},;
{"RES_NOME02"  ,"C",003,000},;
{"RES_NOME03"  ,"C",003,000},;
{"RES_NOME04"  ,"C",003,000},;
{"RES_NOME05"  ,"C",003,000},;
{"RES_NOME06"  ,"C",003,000},;
{"RES_NOME07"  ,"C",003,000},;
{"RES_NOME08"  ,"C",003,000},;
{"RES_NOME09"  ,"C",003,000},;
{"RES_NOME10"  ,"C",003,000},;
{"RES_NOME11"  ,"C",003,000},;
{"RES_NOME12"  ,"C",003,000},;
{"RES_NOME13"  ,"C",003,000},;
{"RES_NOME14"  ,"C",003,000},;
{"RES_NOME15"  ,"C",003,000},;
{"RES_NOME16"  ,"C",003,000},;
{"RES_NOME17"  ,"C",003,000},;
{"RES_NOME18"  ,"C",003,000},;
{"RES_NOME19"  ,"C",003,000},;
{"RES_NOME20"  ,"C",003,000}}

*-------- PRODUTOS.DBF ---------+
Private aDbfStru05:={;
{"PRO_EMPRE"   ,"C",006,000},;
{"PRO_CODIGO"  ,"C",006,000},;
{"PRO_REFER"   ,"C",015,000},;
{"PRO_DESCRI"  ,"C",050,000},;
{"PRO_TIPO"    ,"C",004,000},;
{"PRO_PRECO"   ,"N",010,002},;
{"PRO_DETAL"   ,"M",010,000},;
{"PRO_ITENS"   ,"C",200,000},;
{"PRO_HORAS"   ,"C",010,000},;
{"PRO_DURA"    ,"C",010,000},;
{"PRO_QTDBIM"  ,"C",001,000}}
                             
*--------- ALUNOS.DBF ----------+
Private aDbfStru06:={;
{"ALU_EMPRE"   ,"C",006,000},;
{"ALU_CODIGO"  ,"C",006,000},;
{"ALU_NOME"    ,"C",060,000},;
{"ALU_END"     ,"C",045,000},;
{"ALU_NRO"     ,"C",005,000},;
{"ALU_COMPLE"  ,"C",020,000},;
{"ALU_BAIRRO"  ,"C",030,000},;
{"ALU_CIDADE"  ,"C",030,000},;
{"ALU_ESTADO"  ,"C",002,000},;
{"ALU_CEP"     ,"C",009,000},;
{"ALU_NASC"    ,"D",008,000},;
{"ALU_TEL"     ,"C",014,000},;
{"ALU_CEL"     ,"C",014,000},;
{"ALU_EMAIL"   ,"C",035,000},;
{"ALU_FOTO"    ,"C",300,000},;
{"ALU_TIPO"    ,"C",001,000},;
{"ALU_SEXO"    ,"C",001,000},;
{"ALU_MAE"     ,"C",050,000},;
{"ALU_PAI"     ,"C",050,000},;
{"ALU_SITUA"   ,"C",015,000},;
{"ALU_SITDT"   ,"D",008,000},;
{"ALU_CPFALU"  ,"C",015,000},;
{"ALU_SETOR"   ,"C",006,000},;
{"ALU_RGNRAL"  ,"C",012,000},;
{"ALU_RGORAL"  ,"C",010,000},;
{"ALU_RGUFAL"  ,"C",002,000},;
{"ALU_RA"      ,"C",012,000},;
{"ALU_RADIGI"  ,"C",001,000},;
{"ALU_RAUF"    ,"C",002,000},;
{"ALU_HIPOTE"  ,"N",001,000}}

*--------- AVALIAR.DBF ---------+
Private aDbfStru07:={;
{"AV_EMPRE"    ,"C",006,000},;
{"AV_CODIGO"   ,"C",006,000},;
{"AV_DESCRI"   ,"C",090,000},;
{"AV_DTAPLIC"  ,"D",008,000},;
{"AV_SETOR"    ,"C",360,000},;
{"AV_ANO"      ,"C",004,000},;
{"AV_BIM"      ,"C",001,000},;
{"AV_NROQUES"  ,"C",003,000},;
{"AV_TIPCORR"  ,"C",060,000},;
{"AV_NOTAMAX"  ,"C",003,000}}

*---------- NOTAS.DBF ----------+
Private aDbfStru08:={;
{"NOT_EMPRE"   ,"C",006,000},;
{"NOT_CODIGO"  ,"C",006,000},;
{"NOT_SETOR"   ,"C",006,000},;
{"NOT_ALUNO"   ,"C",006,000},;
{"NOT_ANO"     ,"C",004,000},;
{"NOT_BIM"     ,"C",001,000},;
{"NOT_CARGO"   ,"C",006,000},;
{"NOT_NOTA"    ,"C",002,000},;
{"NOT_FALTAS"  ,"C",002,000},;
{"NOT_COMPEN"  ,"C",002,000},;
{"NOT_FUNCIO"  ,"C",006,000},;
{"NOT_CHAMAD"  ,"C",002,000},;
{"NOT_MENCAA"  ,"L",001,000},;
{"NOT_MENCAB"  ,"L",001,000},;
{"NOT_MENCAC"  ,"L",001,000},;
{"NOT_MENCAD"  ,"L",001,000},;
{"NOT_MENCAE"  ,"L",001,000},;
{"NOT_MENCAF"  ,"L",001,000},;
{"NOT_MENCAG"  ,"L",001,000},;
{"NOT_MENCAH"  ,"L",001,000},;
{"NOT_MENCAI"  ,"L",001,000},;
{"NOT_MENCAJ"  ,"L",001,000},;
{"NOT_MENCAK"  ,"L",001,000},;
{"NOT_MENCAL"  ,"L",001,000}}

*-------- CONSITEM.DBF ---------+
Private aDbfStru09:={;
{"CIT_EMPRE"   ,"C",006,000},;
{"CIT_CODIGO"  ,"C",006,000},;
{"CIT_CONSE"   ,"C",006,000},;
{"CIT_ALUNO"   ,"C",006,000},;
{"CIT_CHAMAD"  ,"C",002,000},;
{"CIT_ANO"     ,"C",004,000},;
{"CIT_BIM"     ,"C",001,000},;
{"CIT_ASSIDU"  ,"L",001,000},;
{"CIT_FALCOM"  ,"L",001,000},;
{"CIT_NAOREA"  ,"L",001,000},;
{"CIT_FALEST"  ,"L",001,000},;
{"CIT_DIFAPR"  ,"L",001,000},;
{"CIT_CONPAI"  ,"L",001,000},;
{"CIT_RECPAR"  ,"L",001,000},;
{"CIT_RECCON"  ,"L",001,000},;
{"CIT_HABEST"  ,"L",001,000},;
{"CIT_PARABE"  ,"L",001,000},;
{"CIT_INDISC"  ,"L",001,000},;
{"CIT_EVADID"  ,"L",001,000},;
{"CIT_NAOALF"  ,"L",001,000},;
{"CIT_INDIS1"  ,"C",001,000},;
{"CIT_SITUAC"  ,"N",001,000},;
{"CIT_OBSERV"  ,"M",010,000}}

*-------- CADCAMPO.DBF ---------+
Private aDbfStru10:={;
{"CAMP_EMPRE"  ,"C",006,000},;
{"CAMP_CODI"   ,"C",006,000},;
{"CAMP_BDADO"  ,"C",006,000},;
{"CAMP_NOME"   ,"C",025,000},;
{"CAMP_TIPO"   ,"C",010,000},;
{"CAMP_TAMAN"  ,"C",010,000},;
{"CAMP_DECIM"  ,"C",010,000},;
{"CAMP_ROTUL"  ,"C",015,000}}

*-------- CONTRATO.DBF ---------+
Private aDbfStru11:={;
{"CONTR_EMPR"  ,"C",006,000},;
{"CONTR_CODI"  ,"C",006,000},;
{"CONTR_NUME"  ,"C",006,000},;
{"CONTR_ALU"   ,"C",006,000},;
{"CONTR_DTIN"  ,"D",008,000},;
{"CONTR_DTFI"  ,"D",008,000},;
{"CONTR_PROD"  ,"C",010,000},;
{"CONTR_TES1"  ,"C",050,000},;
{"CONTR_RGT1"  ,"C",015,000},;
{"CONTR_TES2"  ,"C",050,000},;
{"CONTR_RGT2"  ,"C",015,000},;
{"CONTR_TEXT"  ,"M",010,000},;
{"CONTR_VALO"  ,"N",010,002},;
{"CONTR_HORA"  ,"C",003,000},;
{"CONTR_DESC"  ,"N",010,004},;
{"CONTR_NPAR"  ,"C",002,000},;
{"CONTR_VLPA"  ,"N",010,002},;
{"CONTR_DIVC"  ,"C",002,000},;
{"CONTR_OBSE"  ,"M",010,000}}

*--------- EMPRESA.DBF ---------+
Private aDbfStru12:={;
{"EMP_CODIGO"  ,"C",006,000},;
{"EMP_NOME"    ,"C",080,000},;
{"EMP_RUA"     ,"C",050,000},;
{"EMP_NUMERO"  ,"C",010,000},;
{"EMP_COMPLE"  ,"C",030,000},;
{"EMP_BAIRRO"  ,"C",030,000},;
{"EMP_CIDADE"  ,"C",050,000},;
{"EMP_ESTADO"  ,"C",002,000},;
{"EMP_TEL"     ,"C",015,000},;
{"EMP_FAX"     ,"C",015,000},;
{"EMP_EMAIL"   ,"C",030,000},;
{"EMP_SITE"    ,"C",060,000},;
{"EMP_ANO"     ,"C",004,000},;
{"EMP_BIM"     ,"C",001,000},;
{"EMP_LOGO"    ,"C",200,000},;
{"EMP_CNPJ"    ,"C",014,000},;
{"EMP_INSCES"  ,"C",020,000},;
{"EMP_OCIP"    ,"C",020,000},;
{"EMP_PRESID"  ,"C",006,000}}

*--------- MENCOES.DBF ---------+
Private aDbfStru13:={;
{"MEN_EMPRE"   ,"C",006,000},;
{"MEN_CODIGO"  ,"C",006,000},;
{"MEN_LETRA"   ,"C",001,000},;
{"MEN_DESCRI"  ,"C",018,000},;
{"MEN_TIPO"    ,"C",015,000}}

*-------- ANOLETIV.DBF ---------+
Private aDbfStru14:={;
{"ANO_EMPRES"  ,"C",006,000},;
{"ANO_CODIGO"  ,"C",006,000},;
{"ANO_ANO"     ,"C",004,000},;
{"ANO_QTDIAL"  ,"C",003,000},;
{"ANO_IN1BIM"  ,"D",008,000},;
{"ANO_LI1BIM"  ,"D",008,000},;
{"ANO_FI1BIM"  ,"D",008,000},;
{"ANO_IN2BIM"  ,"D",008,000},;
{"ANO_LI2BIM"  ,"D",008,000},;
{"ANO_FI2BIM"  ,"D",008,000},;
{"ANO_IN3BIM"  ,"D",008,000},;
{"ANO_LI3BIM"  ,"D",008,000},;
{"ANO_FI3BIM"  ,"D",008,000},;
{"ANO_IN4BIM"  ,"D",008,000},;
{"ANO_LI4BIM"  ,"D",008,000},;
{"ANO_FI4BIM"  ,"D",008,000}}

*---------- SETOR.DBF ----------+
Private aDbfStru15:={;
{"SET_EMPRE"   ,"C",006,000},;
{"SET_CODIGO"  ,"C",006,000},;
{"SET_DESCRI"  ,"C",020,000},;
{"SET_ANO"     ,"C",004,000},;
{"SET_RA"      ,"C",020,000},;
{"SET_SALA"    ,"C",005,000},;
{"SET_PERIOD"  ,"C",010,000},;
{"SET_PRODUT"  ,"C",006,000},;
{"SET_PROCOO"  ,"C",006,000},;
{"SET_CAPACI"  ,"N",003,000},;
{"SET_HORINI"  ,"C",005,000},;
{"SET_HORFIM"  ,"C",005,000},;
{"SET_DIASEM"  ,"C",025,000},;
{"SET_EHAULA"  ,"L",001,000},;
{"SET_FECHAD"  ,"L",001,000}}

*-------- CALMEDIA.DBF ---------+
Private aDbfStru16:={;
{"CAL_EMPRE"   ,"C",006,000},;
{"CAL_CODIGO"  ,"C",006,000},;
{"CAL_FUNCIO"  ,"C",006,000},;
{"CAL_MATERI"  ,"C",006,000},;
{"CAL_ANO"     ,"C",004,000},;
{"CAL_BIMEST"  ,"C",002,000},;
{"CAL_SETOR"   ,"C",006,000},;
{"CAL_ALUNO"   ,"C",006,000},;
{"CAL_ATIVID"  ,"C",006,000},;
{"CAL_NOTA"    ,"N",006,002},;
{"CAL_PESOAT"  ,"N",007,004},;
{"CAL_ATNOME"  ,"C",015,000},;
{"CAL_MEDIA"   ,"N",008,004},;
{"CAL_MEDARR"  ,"N",003,000}}

*-------- CADINDEX.DBF ---------+
Private aDbfStru17:={;
{"IDX_EMPRES"  ,"C",006,000},;
{"IDX_CODIGO"  ,"C",006,000},;
{"IDX_BDADO"   ,"C",006,000},;
{"IDX_NOME"    ,"C",008,000},;
{"IDX_TAG"     ,"C",010,000},;
{"IDX_EXPRES"  ,"C",200,000}}

*-------- CONSELHO.DBF ---------+
Private aDbfStru18:={;
{"CON_EMPRE"   ,"C",006,000},;
{"CON_CODIGO"  ,"C",006,000},;
{"CON_ANO"     ,"C",004,000},;
{"CON_BIM"     ,"C",001,000},;
{"CON_SETOR"   ,"C",006,000},;
{"CON_FUNCIO"  ,"C",120,000},;
{"CON_COORDE"  ,"C",006,000},;
{"CON_DATA"    ,"D",008,000},;
{"CON_OBSERV"  ,"M",010,000},;
{"CON_TEMPO"   ,"C",010,000},;
{"CON_FECHA"   ,"L",001,000}}

*-------- FUNCIONA.DBF ---------+
Private aDbfStru19:={;
{"FUN_EMPRE"   ,"C",006,000},;
{"FUN_CODIGO"  ,"C",006,000},;
{"FUN_TRATA"   ,"C",010,000},;
{"FUN_NOME"    ,"C",050,000},;
{"FUN_FOTO"    ,"C",200,000},;
{"FUN_HORA"    ,"C",010,000},;
{"FUN_SENHA"   ,"C",006,000},;
{"FUN_NRG"     ,"C",016,000},;
{"FUN_NCPF"    ,"C",014,000},;
{"FUN_DTNASC"  ,"D",008,000},;
{"FUN_ALCUNH"  ,"C",010,000}}

*--------- TURMAS.DBF ----------+
Private aDbfStru20:={;
{"TUR_EMPRE"   ,"C",006,000},;
{"TUR_CODIGO"  ,"C",006,000},;
{"TUR_SETOR"   ,"C",006,000},;
{"TUR_ALUNO"   ,"C",006,000},;
{"TUR_HORARI"  ,"C",050,000},;
{"TUR_CHAMAD"  ,"C",002,000},;
{"TUR_STATUS"  ,"C",015,000},;
{"TUR_DATAST"  ,"D",008,000},;
{"TUR_OBSERV"  ,"C",050,000},;
{"TUR_ANO"     ,"C",004,000},;
{"TUR_EVADID"  ,"L",001,000}}

*-------- CAPABIME.DBF ---------+
Private aDbfStru21:={;
{"CAP_EMPR"    ,"C",006,000},;
{"CAP_CODIGO"  ,"C",006,000},;
{"CAP_SETOR"   ,"C",006,000},;
{"CAP_ANO"     ,"C",004,000},;
{"CAP_BIM"     ,"C",001,000},;
{"CAP_FUNCIO"  ,"C",006,000},;
{"CAP_CARGO"   ,"C",006,000},;
{"CAP_AULAPR"  ,"C",003,000},;
{"CAP_AULADA"  ,"C",003,000}}

*-------- CADBDADO.DBF ---------+
Private aDbfStru22:={;
{"BD_EMPRESA"  ,"C",006,000},;
{"BD_CODIGO"   ,"C",006,000},;
{"BD_NOME"     ,"C",008,000},;
{"BD_ALIAS"    ,"C",010,000},;
{"BD_IDXPRIN"  ,"C",006,000},;
{"BD_DEFINE"   ,"M",010,000}}

*-------- OCORREAL.DBF ---------+
Private aDbfStru23:={;
{"OCCAL_EMPR"  ,"C",006,000},;
{"OCCAL_CODI"  ,"C",006,000},;
{"OCCAL_ALUN"  ,"C",006,000},;
{"OCCAL_SETO"  ,"C",006,000},;
{"OCCAL_DTIN"  ,"D",008,000},;
{"OCCAL_DTFI"  ,"D",008,000},;
{"OCCAL_OCOR"  ,"C",015,000},;
{"OCCAL_OBSE"  ,"C",250,000}}

*-------- ATRIBUIR.DBF ---------+
Private aDbfStru24:={;
{"ATR_EMPRE"   ,"C",006,000},;
{"ATR_CODIGO"  ,"C",006,000},;
{"ATR_SETOR"   ,"C",006,000},;
{"ATR_ORDEM"   ,"C",002,000},;
{"ATR_CARGO"   ,"C",006,000},;
{"ATR_FUNCIO"  ,"C",006,000},;
{"ATR_HORARI"  ,"C",050,000}}

*-------- HORARIOS.DBF ---------+
Private aDbfStru25:={;
{"HOR_EMPRE"   ,"C",006,000},;
{"HOR_CODIGO"  ,"C",006,000},;
{"HOR_PRODUT"  ,"C",006,000},;
{"HOR_DIA"     ,"C",003,000},;
{"HOR_INI"     ,"C",005,000},;
{"HOR_FIM"     ,"C",005,000}}

*--------- CARGOS.DBF ----------+
Private aDbfStru26:={;
{"CAR_EMPRE"   ,"C",006,000},;
{"CAR_CODIGO"  ,"C",006,000},;
{"CAR_DESCRI"  ,"C",050,000},;
{"CAR_RESUMO"  ,"C",003,000},;
{"CAR_COMPON"  ,"C",005,000}}

*--------- CADTELA.DBF ---------+
Private aDbfStru27:={;
{"TELA_EMPR"   ,"C",006,000},;
{"TELA_CODI"   ,"C",006,000},;
{"TELA_NOME"   ,"C",010,000}}

*-------- CADTELIT.DBF ---------+
Private aDbfStru28:={;
{"TEDT_CODI"   ,"C",010,000},;
{"TEDT_TELA"   ,"C",010,000}}

For i = 1 to 28
   if !file("database\"+aDbfNomes[i])
      lNaoExiste:=.t.
      if !lSomenteVerificaExistencia
         dbcreate("database\"+aDbfNomes[i], &("aDbfStru"+strzero(i,2)))
      endif   
   endif
next i   
return lNaoExiste   

//eof                                                 
