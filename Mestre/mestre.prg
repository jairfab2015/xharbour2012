#include "minigui.ch"
#include "TSBrowse.ch"
 
DECLARE WINDOW FrmGenerico
DECLARE WINDOW FrmConsulta
DECLARE WINDOW Principe
DECLARE WINDOW Abertura

Memvar aColors, BwsGenerico, lContinuaSalvar, c_port, c_Path, c_Addr, c_STR_Con, Aliasado, lUsuarioLogado, nNroTab, pCampo1, cImage, aBrowseIndexPrincipal
Memvar nTabPage, cFormAnterior, cCampoAlterado, lCampoAlterado, cFuncionarioMaster, aBrowseHeadersPrincipal, aBrowseCamposPrincipal, aBrowseWidthsPrincipal
Memvar aTabPrincipal, cAliasBrowse, cCodFuncionario, cFuncionarioNome, cCargo, cCodCargo, cFiltroBrowse, aCamposEdit,aLabelsEdit,aCamposTip,aBrowseCampos
Memvar aBrowseHeaders,aBrowseWidths,aGridCampos,aGridHeaders, nGridColumnLock, aGridWidths,aGridcolWhen,aGridcolValid,aGridPesquisa
Memvar aGridColumnControl,aBrowseIndex,aTab,aList,aRelatTab, aRelatBrowse,aItensList, aBotoesFuncoes, cBrowseTitulo,cBrowsePesquisa
Memvar i_temp, aExecutaIncAlt,aExecutaAposExclusao,aExecutaAntesExclusao,bExecutaAntesIncAlt, lMudaFundoBotao, nControlHandle
Memvar cBimestreAtual, cAnoLetivoAtual, cEmpresa, cFormAtivo, cOperacao, cAliasTab, pListenSocket, bBrowseColor, nNumeroLinhaGrid
Memvar bColumnColor1, bColumnColor2, bColumnColor3, bColumnColor4, bColumnColor5, bColumnColor6, b, cTempBrowseBackColor, cTempGridBackColor
Memvar bColumnColor7, bColumnColor8, bColumnColor9, bColumnColor10, bColumnColor11, bColumnColor12, bGridColor
Memvar bColumnColor13, bColumnColor14, bColumnColor15, bColumnColor16, bColumnColor17, bColumnColor18
Memvar bColumnColor19, bColumnColor20, bColumnColor21, bColumnColor22, bColumnColor23, bColumnColor24
Memvar bColumnColor25, bColumnColor26, bColumnColor27, bColumnColor28, bColumnColor29, bColumnColor30
Memvar bGridBotoes, dDtIniBimAtual, dDtLimBimAtual, nNumRecPri, c_MargemSuperior, c_MargemEsquerda, c_PastaFotos, c_OrdemComboFunc

//---------------------------------------------------------------------------
Function Main()
//---------------------------------------------------------------------------
Public cEmpresa, aliasado, BwsGenerico, lUsuarioLogado, c_STR_Con, nNroTab, pCampo1, lContinuaSalvar
Public nTabPage, cCampoAlterado, lCampoAlterado, aBrowseHeadersPrincipal, aBrowseCamposPrincipal, aBrowseWidthsPrincipal, aBrowseIndexPrincipal
Public aTabPrincipal, cAliasBrowse, cCodFuncionario, cFuncionarioNome, cCargo, cCodCargo, aCamposEdit,aLabelsEdit,aCamposTip,aBrowseCampos, cFiltroBrowse
Public aBrowseHeaders,aBrowseWidths,aGridCampos,aGridHeaders, nGridColumnLock, aGridWidths,aGridcolWhen,aGridcolValid,aGridPesquisa,aExecutaAntesExclusao
Public aGridColumnControl,aBrowseIndex,aTab,aList,aRelatTab, aRelatBrowse,aItensList, aBotoesFuncoes, cBrowseTitulo,cBrowsePesquisa, aBrowsePesquisa
Public i_temp, aExecutaIncAlt,aExecutaAposExclusao,bExecutaAntesIncAlt, cBimestreAtual, cAnoLetivoAtual, cFormAtivo, cOperacao, cAliasTab
Public bColumnColor1, bColumnColor2, bColumnColor3, bColumnColor4, bColumnColor5, bColumnColor6
Public bColumnColor7, bColumnColor8, bColumnColor9, bColumnColor10, bColumnColor11, bColumnColor12
Public bColumnColor13, bColumnColor14, bColumnColor15, bColumnColor16, bColumnColor17, bColumnColor18
Public bColumnColor19, bColumnColor20, bColumnColor21, bColumnColor22, bColumnColor23, bColumnColor24
Public bColumnColor25, bColumnColor26, bColumnColor27, bColumnColor28, bColumnColor29, bColumnColor30
Public bGridBotoes, dDtIniBimAtual, dDtLimBimAtual, nNumRecPri, aColors
PUBLIC lMudaFundoBotao, nControlHandle
PUBLIC cFuncionarioMaster:=c_PastaFotos:=c_OrdemComboFunc:=" "
PUBLIC c_MargemSuperior:=c_MargemEsquerda:="10"
Public c_port:="2941"
Public c_Path:="Database"
Public c_Addr:="127.0.0.1"
Public pListenSocket:=nil
nNroTab:=0
lCampoAlterado:=.f.; lUsuarioLogado:=.f.
aCamposEdit:={""};aLabelsEdit:={""};aCamposTip:={""};aBrowseCampos:={""}
aBrowseHeaders:={""};aBrowseWidths:={""};aGridCampos:={""};aGridHeaders:={""};nGridColumnLock:=0
aGridWidths:={""};aGridcolWhen:={""};aGridcolValid:={""};aGridPesquisa:={""}
aGridColumnControl:={""};aBrowseIndex:={""};aTab:={""};aList:={""};aRelatTab:={""}
aRelatBrowse:={""};aItensList:={""}; aBotoesFuncoes:={}; cBrowseTitulo:="";cBrowsePesquisa:=""
i_temp:=0 
cAnoLetivoAtual:=""
cFormAtivo:="TabWindow"; cOperacao:=""
bColumnColor1:= {|| {0,0,0}}; bColumnColor2:= {|| {0,0,0}}; bColumnColor3:= {|| {0,0,0}}
bColumnColor4:= {|| {0,0,0}}; bColumnColor5:= {|| {0,0,0}}; bColumnColor6:= {|| {0,0,0}}
bColumnColor7:= {|| {0,0,0}}; bColumnColor8:= {|| {0,0,0}}; bColumnColor9:= {|| {0,0,0}}
bColumnColor10:={|| {0,0,0}}; bColumnColor11:={|| {0,0,0}}; bColumnColor12:={|| {0,0,0}}
bColumnColor13:={|| {0,0,0}}; bColumnColor14:={|| {0,0,0}}; bColumnColor15:={|| {0,0,0}}
bColumnColor16:={|| {0,0,0}}; bColumnColor17:={|| {0,0,0}}; bColumnColor18:={|| {0,0,0}}; bColumnColor19:={|| {0,0,0}}; bColumnColor20:={|| {0,0,0}}; bColumnColor21:={|| {0,0,0}}; bColumnColor22:= {|| {0,0,0}}; bColumnColor23:= {|| {0,0,0}}; bColumnColor24:={|| {0,0,0}}; bColumnColor25:={|| {0,0,0}}; bColumnColor26:={|| {0,0,0}}; bColumnColor27:={|| {0,0,0}}; bColumnColor28:={|| {0,0,0}}; bColumnColor29:={|| {0,0,0}}; bColumnColor30:={|| {0,0,0}}
bGridBotoes:={|| .T.}; dDtIniBimAtual:=dDtLimBimAtual:=ctod("")
nNumRecPri:=0	

REQUEST DBFCDX, DBFFPT  //o índice do banco de dados é cdx
SET NAVIGATION EXTENDED // A tecla Enter se comporta como TAB
SET CENTURY ON  //guarda o formato de quatro dígitos para o ano
SET LANGUAGE TO PORTUGUESE  //as mensagens de erro do sistema saem em português
SET CODEPAGE TO PORTUGUESE
SET DELETED ON  //os registros deletados não aparecem por default
SET DATE TO BRITISH  // o formato da data é dd/mm/aaaa
SET BROWSESYNC ON //Essencial para sincronizar o Browse com o arquivo DBF
SET MENUSTYLE EXTENDED
SET MULTIPLE OFF

if !file("config.ini")
   if !msgyesno("Não achei arquivo Config.ini. Deseja Criá-lo agora?")
      quit
   else
      Begin ini file ("Config.ini")
        Set Section "CONFIGURATION" ENTRY "TopMargin"  To "10"
        Set Section "CONFIGURATION" ENTRY "LeftMargin" To "10"
        Set Section "CONFIGURATION" ENTRY "Master"     To "000001"
        Set Section "CONFIGURATION" ENTRY "PastaFotos" To ""
        Set Section "CONFIGURATION" ENTRY "OrdCmbFunc" To "1"
        Set Section "CONFIGURATION" ENTRY "Port"       To "2941"
        Set Section "CONFIGURATION" ENTRY "Path"       To "DATABASE"
        Set Section "CONFIGURATION" ENTRY "Address"    To "127.0.0.1"
      End ini
      msgbox("Parâmetros Gravados! Você pode alterá-los posteriormente no menu Ferramentas")
   endif   
endif

Begin ini file ("Config.ini")
   Get c_Port             Section "CONFIGURATION" ENTRY "Port"
   Get c_Path             Section "CONFIGURATION" ENTRY "Path"
   Get c_Addr             Section "CONFIGURATION" ENTRY "Address"
   Get cFuncionarioMaster Section "CONFIGURATION" ENTRY "Master"
   Get c_PastaFotos       Section "CONFIGURATION" ENTRY "PastaFotos"
   Get c_MargemSuperior   Section "CONFIGURATION" ENTRY "TopMargin"
   Get c_MargemEsquerda   Section "CONFIGURATION" ENTRY "LeftMargin"
   Get c_OrdemComboFunc   Section "CONFIGURATION" ENTRY "OrdCmbFunc"
End Ini

pListenSocket:=netio_mtserver(2941, '127.0.0.1')
if empty(pListenSocket)
   MsgStop("Servidor não pode ser iniciado! Verifique IP da máquina no arquivo config.ini")
   quit
endif

c_STR_Con := "net:"+c_Addr+":"+lTrim(c_Port)+":"+c_Path+"\"

AbrirCompartilhado()

DEFINE WINDOW PRINCIPE AT 135 , 142 WIDTH 862 HEIGHT 350 TITLE "MESTRE ADMINISTRAÇÃO ESCOLAR" MAIN ICON "RES\ICON\MAIN.ICO" ON RELEASE limparelacoes() //BACKCOLOR {229,229,229} 
    DEFINE MAIN MENU
        DEFINE POPUP "CADASTROS"
            MENUITEM "  &ALUNOS"      ACTION CadGenerico('ALUNOS') IMAGE "\RES\distlstl.bmp"
            MENUITEM "  &DEPARTAMENTOS, ATRIBUIÇÃO E TURMAS" ACTION CadGenerico('SETOR') IMAGE "bmp\imagem.bmp"
            SEPARATOR
            MENUITEM "  &ESCOLA"      ACTION CadGenerico('EMPRESA')
            MENUITEM "  &FUNCIONÁRIO" ACTION CadGenerico('FUNCIONA')
            MENUITEM "  &CARGOS"      ACTION CadGenerico('CARGOS') IMAGE "bmp\CARGOS.bmp"
            MENUITEM "  C&URSOS"      ACTION CadGenerico('PRODUTOS') IMAGE "bmp\img_produto.bmp"
            MENUITEM "  &HORÁRIOS"    ACTION CadGenerico('HORARIOS')
            MENUITEM "  &MENÇÕES"     ACTION CadGenerico('MENCOES')
            SEPARATOR
            MENUITEM "  &SAIR"        ACTION Fim() IMAGE "SALVAR"
        END POPUP
        DEFINE POPUP "FERRAMENTAS"
            MENUITEM "CONSELHO"      ACTION CadGenerico('CONSELHO')
            MENUITEM "AVALIAÇÃO"     ACTION CadGenerico('AVALIAR')            
            MENUITEM "IMPORTA NOTAS" ACTION ImportaNotas()            
            MENUITEM "IMPORTA ALUNOS X TURMAS" ACTION ImportaAlunosTurmas()            
            MENUITEM "JUNTA CONSELHOS E NOTAS" ACTION JuntaConselhoseNotas()
        END POPUP
        DEFINE POPUP "RELATÓRIOS"
            MENUITEM "MAPÃO"    ACTION Imprimir('MAPAO')
            MENUITEM "BOLETIM"  ACTION Imprimir('BOLETIM')
            MENUITEM "RESULTADO FINAL"  ACTION Imprimir('RESULTFINAL')
            MENUITEM "CARTEIRINHA" ACTION Imprimir('CARTEIRINHA')
        END POPUP
        DEFINE POPUP "CONFIGURA"
            MENUITEM "PARÂMETROS"          ACTION ConfigParametros()
            MENUITEM "ZERA ARQUIVOS"       ACTION ZeraArquivos() //Zera base de dados para iniciar novamente
            MENUITEM "REINDEXA"            ACTION Reindexa() //reindexa arquivos; para isso, nenhum outro operador pode estar usando programa
        END POPUP
        DEFINE POPUP "SOBRE"
            MENUITEM "AJUDA"               ACTION Ajuda() 
            MENUITEM "CRÉDITOS"            ACTION MostraCreditos()
        END POPUP
    END MENU
 	  DEFINE TOOLBARex ToolBar_Principal BUTTONSIZE 77,77 FONT "ARIAL" SIZE 8 FLAT BORDER
      BUTTON Button_1 ;
       	PICTURE 'ALUNO'  CAPTION "ALUNOS" ACTION CadGenerico('ALUNOS') tooltip "Alunos e Histórico" //SEPARATOR
  		BUTTON Button_2 ;
  			PICTURE 'ESCOLA' CAPTION "ESCOLAS" ACTION CadGenerico('EMPRESA') tooltip "Escolas e Anos Letivos" //SEPARATOR
  		BUTTON Button_3 ;
  			PICTURE 'SETOR'  CAPTION "SETORES" ACTION CadGenerico('SETOR') tooltip "Setores, Atribuições, Turmas e Notas" //SEPARATOR
  		BUTTON Button_4 ;
  			PICTURE 'FUNCIONARIO' CAPTION "FUNCIONÁRIOS" ACTION CadGenerico('FUNCIONA') tooltip "Funcionários" //SEPARATOR
  		BUTTON Button_5 ;
  			PICTURE 'CURSO'  CAPTION "CURSOS" ACTION CadGenerico('PRODUTOS') tooltip "Cursos e Produtos" // SEPARATOR
  		BUTTON Button_6 ;    
      	PICTURE 'CARGOS' CAPTION "CARGOS" ACTION CadGenerico('CARGOS') tooltip "Cargos" // SEPARATOR
  		BUTTON Button_7 ;    
      	PICTURE 'AVALIACAO' CAPTION "AVALIAÇÕES" ACTION CadGenerico('AVALIAR') tooltip "Avaliações" // SEPARATOR
  		BUTTON Button_8 ;
  			PICTURE 'CONSELHO' CAPTION "CONSELHOS" ACTION CadGenerico('CONSELHO') tooltip "Conselhos" // SEPARATOR
  		BUTTON Button_9 ;
  			PICTURE 'MENCOES'  CAPTION "MENÇÕES" ACTION CadGenerico('MENCOES') tooltip "Menções Conselho" // SEPARATOR
  		BUTTON Button_10 ;
  			PICTURE 'SAI'      CAPTION "ENCERRAR" ACTION Principe.release tooltip "Encerra o Programa" // SEPARATOR
    END TOOLBAR  
    DEFINE STATUSBAR FONT "Arial" SIZE 8
      STATUSITEM "FUNCIONÁRIO:" width 100
      STATUSITEM "BIM.ATUAL:"   width 100 action TrocaBimestre() tooltip "Clique para trocar o bimestre"
      STATUSITEM "ANO LETIVO:"  width 100 action CadastraAnoLetivo() tooltip "Clique para inserir datas do bimestre"
      STATUSITEM "CARGO:"       width 200 action TrocaCargo() tooltip "Clique para fazer login com outro cargo"
      PROGRESSITEM              WIDTH 100 RANGE 0 , 100 value 0
      clock
      Date
    END STATUSBAR
END WINDOW
DEFINE WINDOW Abertura AT 135 , 142 WIDTH 562 HEIGHT 350 NOMINIMIZE NOSIZE NOSYSMENU NOCAPTION ON INIT SplashDelay() BACKCOLOR {225,226,236}
    DEFINE IMAGE Image_1
        ROW    145
        COL    300
        WIDTH  250
        HEIGHT 148
        PICTURE "ESTADO"
    END IMAGE
 
    DEFINE IMAGE Image_2
        ROW    100
        COL    15
        WIDTH  250
        HEIGHT 211
        PICTURE "MESTRE"
        TRANSPARENT .T.
        STRETCH .T.
    END IMAGE
    
    DEFINE LABEL Label_3
        ROW    70
        COL    250
        WIDTH  120
        HEIGHT 20
        VALUE "Versão 1.2.0 - Build 02/06/2013"
        FONTNAME "Arial"
        FONTSIZE 10
        FONTBOLD .T.
        FONTCOLOR {0,0,0}
        TRANSPARENT .T.
    END LABEL 
    DEFINE LABEL Label_1
        ROW    25
        COL    100
        WIDTH  460
        HEIGHT 50
        VALUE "ADMINISTRAÇÃO ESCOLAR"
        FONTNAME "Arial"
        FONTBOLD .T.
        FONTSIZE 22
        FONTCOLOR {0,0,0}
        TRANSPARENT .T.
    END LABEL
    DEFINE LABEL Label_2
        ROW    30
        COL    105
        WIDTH  460
        HEIGHT 50
        VALUE "ADMINISTRAÇÃO ESCOLAR"
        FONTNAME "Arial"
        FONTBOLD .T.
        FONTSIZE 22
        FONTCOLOR {157,157,157}
        TRANSPARENT .T.
    END LABEL
END WINDOW
domethod("principe","refresh")
Center Window principe
Center Window Abertura
Seleciona()  //define tela de login
principe.setfocus
principe.maximize()
Activate Window Principe, Seleciona, Abertura
Return Nil

//----------------------------------------------------------------------------
procedure Seleciona()
//----------------------------------------------------------------------------
DEFINE WINDOW SELECIONA AT 275 , 316 WIDTH 400 HEIGHT 365 MODAL NOCAPTION //BACKCOLOR {229,229,229}
    ON KEY F11 Action ConfiguraSistema() //Configura o programa pela primeira vez
    DEFINE BUTTONEX MYBUTTON2
         ROW    00
         COL    20
         WIDTH  50 
         HEIGHT 70
         PICTURE "CADEADO"
    END BUTTONEX   
    DEFINE LABEL Label_Login
        ROW    30
        COL    115
        WIDTH  220
        HEIGHT 40
        VALUE "Login do Sistema"
        FONTNAME "Arial"
        FONTSIZE 18
        FONTBOLD .T.
        TRANSPARENT .T.
    END LABEL
    DEFINE LABEL Label_Empresa
        ROW    130
        COL    13
        WIDTH  48
        HEIGHT 48
        VALUE "ESCOLA"
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TRANSPARENT .T.
    END LABEL
    DEFINE IMAGE Image_empresa
         ROW    120
         COL    68
         WIDTH  30
         HEIGHT 30
         PICTURE "ICOESCOLA"
         STRETCH .T.
    END IMAGE
    DEFINE COMBOBOX Combo_Empresa
        ROW    130
        COL    120
        WIDTH  250
        HEIGHT 120
        ITEMS {""}
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 8
        ONCHANGE FiltraFuncionario()
        FONTBOLD .T.
        TABSTOP .T.
        TRANSPARENT .T.
    END COMBOBOX
    DEFINE LABEL Label_Funcionario
        ROW    170
        COL    13
        WIDTH  120
        HEIGHT 30
        VALUE "FUNCIONÁRIO"
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TRANSPARENT .T.    
    END LABEL
    DEFINE IMAGE Image_funciona
         ROW    170
         COL    85
         WIDTH  30
         HEIGHT 30
         PICTURE "FUNCICONE"
         STRETCH .T.
         TRANSPARENT .T.
    END IMAGE
    DEFINE COMBOBOX Combo_Funcionario
        ROW    170
        COL    120
        WIDTH  250
        HEIGHT 120
        ITEMS {""}
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 8
        ONCHANGE FiltraCargo()
        FONTBOLD .T.
        TABSTOP .T.
        TRANSPARENT .T.
    END COMBOBOX
    DEFINE LABEL Label_Cargo
        ROW    210
        COL    13
        WIDTH  80
        HEIGHT 20
        VALUE "CARGO"
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TRANSPARENT .T.
    END LABEL
    DEFINE IMAGE Image_cargo
         ROW    210
         COL    85
         WIDTH  32
         HEIGHT 32
         PICTURE "ICOCARGO"
         STRETCH .T.
         TRANSPARENT .T.
    END IMAGE
    DEFINE COMBOBOX Combo_Cargo
        ROW    210
        COL    120
        WIDTH  250
        HEIGHT 80
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 8
        ITEMS {""}
        FONTBOLD .T.
        TABSTOP .T.
        TRANSPARENT .T.
    END COMBOBOX
    DEFINE LABEL Label_Senha
        ROW    250
        COL    13
        WIDTH  80
        HEIGHT 28
        VALUE "SENHA"
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TRANSPARENT .T.
    END LABEL
    DEFINE IMAGE Image_senha
         ROW    248
         COL    85
         WIDTH  30
         HEIGHT 30
         PICTURE "SENHA"
         STRETCH .T.
         TRANSPARENT .T.
    END IMAGE
    DEFINE TEXTBOX Text_Senha   //INFORMA SENHA
        ROW    250
        COL    120
        WIDTH  250
        HEIGHT 20
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TABSTOP .T.
        UPPERCASE .T.
        PASSWORD .T.
        TRANSPARENT .T.
    END TEXTBOX
    DEFINE FRAME Frame_1
        ROW    110
        COL    08
        WIDTH  370
        HEIGHT 180
        FONTNAME "Arial"
        FONTSIZE 9
        OPAQUE .T.
    END FRAME
    DEFINE BUTTON ButtonEmp
        ROW    300
        COL    80
        WIDTH  100
        HEIGHT 28
        CAPTION "OK"
        ACTION SelecionaEmpresa()
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TABSTOP .T.
        TRANSPARENT .T.
    END BUTTON
    DEFINE BUTTON ButtonSair
        ROW    300
        COL    210
        WIDTH  100
        HEIGHT 28
        CAPTION "SAIR"
        ACTION if(lUsuarioLogado,Seleciona.release,Principe.release)
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .T.
        TABSTOP .T.
    END BUTTON
    DEFINE LABEL Label_Configura
        ROW    335
        COL    135
        WIDTH  220
        HEIGHT 40
        VALUE "F11"
        FONTNAME "Arial"
        FONTSIZE 09
        FONTBOLD .T.
    END LABEL
    DEFINE LABEL Label_Config1
        ROW    335
        COL    160
        WIDTH  220
        HEIGHT 40
        VALUE "Instalar/Reindexa Sistema"
        FONTNAME "Arial"
        FONTSIZE 08
    END LABEL

END WINDOW
empresa->(dbsetorder(1)) //ordem de codigo
empresa->(dbgotop())
Seleciona.Combo_Empresa.deleteallitems
do while !empresa->(eof())
   domethod("Seleciona","Combo_Empresa","additem", empresa->emp_codigo+"-"+empresa->emp_nome)
   empresa->(dbskip(1))
enddo
Center Window Seleciona
return

//----------------------------------------------------------------------------
procedure CadGenerico(pArquivo)   //cadastro genérico do sistema, contendo o browser do arquivo principal e seus campos para edição no componente Tab
//---------------------------------------------------------------------------
Local i, k, nLinha, b
Private bBrowseColor:={|| if(recno()/2==int(recno()/2), {222,222,222}, {192,192,192})}, cTempBrowseBackColor:=cTempGridBackColor:="{}", nNumeroLinhaGrid   
Private bGridColor:={|| if(This.CellRowIndex/2 == int(This.CellRowIndex/2), {222,222,222}, {192,192,192})}
set autoscroll on  //esse comando é importante para a janela rolar automaticamente quando clicado algum controle.
cAliasBrowse:=pArquivo  //guarda o alias do BD principal, pois nos tabs o alias corrente muda
DeterminaCampos(cAliasBrowse,"BROWSE")  //inicia todas as variaveis necessárias para manipular o banco de dados em pauta
aTabPrincipal:=aTab   //quando o operador clicar no Tab (outro arquivo), mantém as informações do Tab original (o primeiro)
aBrowseHeadersPrincipal:=aBrowseHeaders
aBrowseCamposPrincipal:=aBrowseCampos
aBrowseWidthsPrincipal:=aBrowseWidths
aBrowseIndexPrincipal:=aBrowseIndex

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   if !(pArquivo = "SETOR")
      msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
      return 
   endif   
endif

DEFINE WINDOW FrmGenerico AT 0,0 WIDTH 801 HEIGHT 545 TITLE cBrowseTitulo MODAL NOSIZE ON RELEASE ResetaOperacao() //BACKCOLOR {229,229,229} 
   ON KEY F3 ACTION MOSTRA()   //mostra informações referentes banco de dados atual

   DEFINE SPLITBOX

   DEFINE TOOLBAREX ToolBar_Generico BUTTONSIZE 70,75 FONT "Verdana" SIZE 6 FLAT  
      BUTTON ButNovo PICTURE 'NOVO'  CAPTION "NOVO" ACTION NovoRegistro()
      BUTTON ButAlte PICTURE 'ALTERA'   CAPTION "ALTERA"   ACTION AlteraRegistro()
      BUTTON ButDele PICTURE 'DELETA'   CAPTION "DELETA"   ACTION DeletaRegistro()
      BUTTON ButSalv PICTURE 'SALVA'    CAPTION "SALVA"    ACTION AtualizaRegistro(cAliasBrowse, "PRINCIPAL")
      BUTTON ButSair PICTURE 'FECHA'    CAPTION "FECHA"    ACTION FinalizaFormPrincipal()
   END TOOLBAR
   DEFINE WINDOW BrowseWindow WIDTH 325 HEIGHT 430 SPLITCHILD NOCAPTION  
      ON KEY F3 ACTION MOSTRA()   //mostra informações referentes banco de dados atual
      cTempBrowseBackColor:="{"     //rotina para contar quantas colunas tem no Browser a fim de deixa-lo listrado
      for b = 1 to len(aBrowseHeadersPrincipal)
         if b = 1
            cTempBrowseBackColor+="bBrowseColor"
         else
            cTempBrowseBackColor+=",bBrowseColor"
         endif
      next b
      cTempBrowseBackColor+="}"         
        
      DEFINE BROWSE BwsGenerico 
         ROW    15
         COL    5
         WIDTH  300
         HEIGHT 365
         VALUE 0
         HEADERS aBrowseHeadersPrincipal
         FIELDS aBrowseCamposPrincipal
         WIDTHS aBrowseWidthsPrincipal
         WORKAREA &(cAliasBrowse)
         FONTNAME "Verdana"
         FONTSIZE 6
         ONHEADCLICK &(aBrowseIndexPrincipal)
         ONCHANGE AtualizaBrowseGrid()
         ONGOTFOCUS AtualizaBrowseGrid()  
         FONTBOLD .T.
         TRANSPARENT .T.         
         DYNAMICBACKCOLOR &(cTempBrowseBackColor) 
      END BROWSE

      DEFINE FRAME Frame_2
         ROW    382
         COL    5
         WIDTH  304
         HEIGHT 45
         TRANSPARENT .T.
      END FRAME
      DEFINE LABEL LblPesquisa
         ROW    387
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "PESQUISA"
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
         TRANSPARENT .T.
      END LABEL
      DEFINE TEXTBOX TxtPesquisa
         ROW    387
         COL    58
         WIDTH  229
         HEIGHT 13
         FONTNAME "Verdana"
         FONTSIZE 6
         UPPERCASE .T.
         FONTBOLD .T.
         TRANSPARENT .T.
         ON ENTER LocalizaBws(cAliasBrowse)  //localiza registro no browser 
      END TEXTBOX
      DEFINE IMAGE Image_1
         ROW    387
         COL    288
         WIDTH  16
         HEIGHT 15
         PICTURE "VAI"
         ACTION LocalizaBws(cAliasBrowse)  //localiza registro no browser
      END IMAGE
      DEFINE LABEL LblIndice
         ROW    402  
         COL    8
         WIDTH  300
         HEIGHT 60
         VALUE "EXPRESSÃO DE BUSCA: "+indexkey()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
         TRANSPARENT .T.
      END LABEL
   END WINDOW
 
   DEFINE WINDOW TabWindow WIDTH 20 HEIGHT 430 VIRTUAL HEIGHT 800 SPLITCHILD NOCAPTION    
      ON KEY F3 ACTION MOSTRA()   //mostra informações referentes banco de dados atual
      for i = 1 to len(aTabPrincipal)   //cria agora os componentes das páginas do TAB, pois senão não serão reconhecidos como sendo desse form quando enunciados posteriormente
         Determinacampos(aTabPrincipal[i,1],"TAB")   //determina campos do tab atual para gerar os grids corretamente com os headers e widths corretos
         DEFINE GRID &('Grd_'+strzero(i,2,0))
            ROW 15
            COL 1
            WIDTH  405
            HEIGHT 290
            VALUE 1
            ALLOWEDIT .T.
            LOCKCOLUMNS nGridColumnLock
            HEADERS aGridHeaders
            WIDTHS aGridWidths 
            COLUMNWHEN aGridColWhen //diz qual colunas serão editáveis
            COLUMNVALID aGridColValid //valida os dados inputados pelo operador
            DYNAMICFORECOLOR {bColumnColor1,bColumnColor2,bColumnColor3,bColumnColor4,bColumnColor5,bColumnColor6,bColumnColor7,bColumnColor8,bColumnColor9} //diz qual a cor de cada coluna do grid; mudada no módulo funções
            DYNAMICBACKCOLOR {bGridColor,bGridColor,bGridColor,bGridColor,bGridColor,bGridColor,bGridColor,bGridColor,bGridColor} //diz qual a cor de cada coluna do grid; mudada no módulo funções
            COLUMNCONTROLS aGridColumnControl
            FONTNAME "Verdana"
            FONTSIZE 6
            FONTBOLD .T.
         END GRID   
         DEFINE LABEL &('Lbl_'+strzero(i,2,0))
            COL 1
            ROW 1
            WIDTH  60
            HEIGHT 20
            VALUE "PESQUISA"
            FONTNAME "Verdana"
            TRANSPARENT .T.
            FONTSIZE 6
            FONTBOLD .T.
         END LABEL
         DEFINE TEXTBOX &('Txt_'+strzero(i,2,0))
            COL 1
            ROW 1
            WIDTH  200
            HEIGHT 13
            FONTNAME "Verdana"
            FONTSIZE 6
            UPPERCASE .T.
            FONTBOLD .T.
         END TEXTBOX
         DEFINE IMAGE &('Img_'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  16
            HEIGHT 15
            PICTURE "VAI"
            STRETCH .T.
            ACTION LocalizaGrd((aTabPrincipal[i_temp,1]),i_temp)
            ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
         END IMAGE

         DEFINE COMBOBOX &('ComboPesq_'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  120
            HEIGHT 60
            ITEMS &(aGridPesquisa)
            VALUE 1
            FONTNAME "Verdana"
            FONTSIZE 6
            FONTBOLD .T.
          END COMBOBOX
          DEFINE BUTTON &('ButNovo'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  70
            HEIGHT 18
            CAPTION "NOVO"
            ACTION pegavalordacoluna("INC", i_temp)  //pega último campo do registro no grid no qual está o valor de recno(), a fim de proceder com a edição do registro
            ONGOTFOCUS (i_temp:=val(substr(this.name,-2))) //O componente do form tem que ter um número com 2 casas no fim de seu nome 
            FONTNAME "Verdana"
            FONTSIZE 6
            FONTBOLD .T.
            TABSTOP .T.
          END BUTTON
          DEFINE BUTTON &('ButEdit'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  70
            HEIGHT 18
            CAPTION "ALTERAR"
            ACTION pegavalordacoluna("ALT", i_temp)    //pega último campo do registro no grid no qual está o valor de recno(), a fim de proceder com a edição do registro
            ONGOTFOCUS (i_temp:=val(substr(this.name,-2))) //O componente do form tem que ter um número com 2 casas no fim de seu nome
            FONTNAME "Verdana"
            FONTSIZE 6
            FONTBOLD .T.
            TABSTOP .T.
          END BUTTON
          DEFINE BUTTON &('ButDele'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  70                                            
            HEIGHT 18                                  
            CAPTION "DELETAR"
            ACTION pegavalordacoluna("DEL", i_temp)    //pega último campo do registro no grid no qual está o valor de recno(), a fim de proceder com a edição do registro
            ONGOTFOCUS (i_temp:=val(substr(this.name,-2))) //O componente do form tem que ter um número com 2 casas no fim de seu nome
            FONTNAME "Verdana"
            FONTSIZE 6
            FONTBOLD .T.
            TABSTOP .T.
          END BUTTON
          //cria 5 botoes para atalhos de funcoes complementares definidas em funcoes.prg  
          DEFINE FRAME &('Frame_'+strzero(i,2,0))
            ROW    1
            COL    1
            WIDTH  400
            HEIGHT 33
            FONTNAME "Arial"
            FONTSIZE 5
            FONTBOLD .T.
            CAPTION "FUNÇÕES"
            BACKCOLOR {253,253,253}
          END FRAME
          for k = 1 to 5 
             DEFINE BUTTON &('ButtFun'+strzero(i,2,0)+'_'+strzero(k,2,0))
                ROW    1
                COL    1
                WIDTH  70                                            
                HEIGHT 18                                  
                CAPTION aBotoesFuncoes[k,1]
                ACTION pegavalordacoluna("ATA", i_temp)    //pega último campo do registro no grid no qual está o valor de recno(), a fim de proceder com a edição do registro
                ONGOTFOCUS (i_temp:=val(substr(this.name,-2))) //O componente do form tem que ter um número com 2 casas no fim de seu nome
                FONTNAME "Verdana"
                FONTSIZE 6
                FONTBOLD .T.
                TABSTOP .T.
             END BUTTON
          next k
      next i
      DeterminaCampos(cAliasBrowse, "BROWSE")

      DEFINE TAB Tab_1 AT 15,5 WIDTH 426 HEIGHT 790 VALUE 1 FONT "Verdana" SIZE 6 Bold /*BACKCOLOR {229,229,229}*/ ON CHANGE AtualizaBrowseGrid()  
         //Cria agora somente a página do TAB para a edição dos campos no Browse (nome=Dados), as próximas páginas deste tab tem que ser adicionadas depois dessa rotina 
         DEFINE PAGE 'DADOS' IMAGE "INFO"  //a propriedade IMAGE é essencial para o funcionamento do componente TAB
            nLinha:=10
            for i = 1 to len(aLabelsEdit)
               if i > 1  //só vale para o segundo elemento - verifica se é necessário linhas extras de espaço entre elementos como campos memo e de imagem
                  if aCamposTip[i-1,1]="MEMO".or.aCamposTip[i-1,1]="TEXTIMAGE".or.aCamposTip[i-1,1]="LSTBOXDUO"  //verifica se é necessário dar mais espaço por causa do componente anterior
                     nLinha+=113
                  else
                     nLinha+=18
                  endif
               else
                  nLinha+=18
               endif

               DEFINE LABEL &("Label_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    10
                  WIDTH  90
                  HEIGHT 12
                  VALUE &("'"+aLabelsEdit[i]+"'")
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .t.
                  TRANSPARENT .T.
               END LABEL
            next i
            nLinha:=10
            for i = 1 to len(aCamposEdit)
               if i > 1  //só vale para o segundo elemento
                  if aCamposTip[i-1,1]="MEMO".or.aCamposTip[i-1,1]="TEXTIMAGE".or.aCamposTip[i-1,1]="LSTBOXDUO"  //verifica se é necessário dar mais espaço por causa do componente anterior
                     nLinha+=113
                  else
                     nLinha+=18
                  endif
               else        
                  nLinha+=18
               endif
               if aCamposTip[i,1] == "TEXT"
                  if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
                     DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                        ROW    nLinha
                        COL    115
                        WIDTH  55
                        HEIGHT 13
                        FONTNAME "Verdana"
                        FONTSIZE 6
                        FONTBOLD .T.
                        UPPERCASE .T.
                        ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                        if valtype(&(aCamposEdit[i])) = "D"
                           DATE .T.
                        elseif valtype(&(aCamposEdit[i])) = "N"
                           NUMERIC .T.
                        endif
                        if !empty(aCamposTip[i,4])
                           INPUTMASK aCamposTip[i,4] 
                        endif
                        TRANSPARENT .T.
                     END TEXTBOX
                     DEFINE LABEL &("Label_99"+cFormAtivo+strzero(i,2,0))  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
                        ROW    nLinha
                        COL    175
                        WIDTH  230
                        HEIGHT 12
                        *BACKCOLOR {253,253,253}
                        FONTNAME "Verdana"
                        FONTSIZE 6
                        FONTBOLD .T.
                        TRANSPARENT .T.
                     END LABEL
                     DEFINE BUTTON &("ButCon_"+cFormAtivo+strzero(i,2,0))
                        ROW    nLinha
                        COL    405
                        WIDTH  15
                        HEIGHT 14
                        CAPTION "P"
                        ACTION Consulta(aCamposTip[i_temp,2][1],{"Text_"+cFormAtivo+strzero(i_temp,2,0), aCamposTip[i_temp,2][2]}, aCamposTip[i_temp,2][3],.f.,1,i_temp,aCamposTip[i_temp,2][4])
                        FONTNAME "Verdana"
                        FONTSIZE 6
                        ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                        FONTBOLD .T.
                        TRANSPARENT .T.
                        TABSTOP .F.
                     END BUTTON
                  else
                     DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                        ROW    nLinha
                        COL    115
                        WIDTH  290
                        HEIGHT 13
                        FONTNAME "Verdana"
                        FONTSIZE 6
                        FONTBOLD .T.
                        UPPERCASE .T.
                        if valtype(&(aCamposEdit[i])) = "D"
                           DATE .T.
                           NUMERIC .F.
                        elseif valtype(&(aCamposEdit[i])) = "N"
                           NUMERIC .T.
                           DATE .F.
                        endif
                        if !empty(aCamposTip[i,4])
                           INPUTMASK aCamposTip[i,4]
                        endif
                        ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                        ONLOSTFOCUS AcaoPosCampo("Text_"+strzero(i_temp,2,0), aCamposTip[i_temp,3])  //verifica se tem alguma ação programada para esse campo após sua edição. Essa ação é armazenada no bloco de código em DeterminaCampos
                        TRANSPARENT .T.
                     END TEXTBOX
                  endif 
               elseif aCamposTip[i,1] = "COMBO" 
                  DEFINE COMBOBOX &("Combo_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  290
                     HEIGHT 100
                     if aCamposTip[i,2] //se for .t. essa posição significa que os dados do combo devem vir de um arquivo dbf
                        ITEMS {""}  //inicialmente declara os itens em branco para depois de terminado a formação do combo inserir os valores de acordo com o dbf escolhido pelo programador (veja logo abaixo)
                     else
                        ITEMS &(aCamposTip[i,3]) //se for .f. significa que o operador já informou os itens que deverão ser inseridos no combo
                     endif
                     VALUE 0
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                     TRANSPARENT .T.
                  END COMBOBOX
                  if aCamposTip[i,2] //se for .t. essa posição significa que os dados do combo devem vir de um arquivo dbf
                     &(aCamposTip[i,3])->(dbgotop())
                     do while !&(aCamposTip[i,3])->(eof())
                        domethod("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"additem", &(aCamposTip[i,3])->(&(aCamposTip[i,4])))
                        &(aCamposTip[i,3])->(dbskip(1))
                     enddo
                  endif
               elseif aCamposTip[i,1] = "DATA" 
                  DEFINE DATEPICKER &("Date_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  290
                     HEIGHT 14
                     VALUE nil
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                     TRANSPARENT .T.
                  END DATEPICKER
               elseif aCamposTip[i,1] = "MEMO" 
                  DEFINE EDITBOX &("Edit_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  290
                     HEIGHT 100
                     FONTNAME "Verdana"
                     HSCROLLBAR .F.
                     FONTSIZE 6
                     FONTBOLD .T.
                     TRANSPARENT .T.
                  END EDITBOX
               elseif aCamposTip[i,1] = "TEXTIMAGE"
                  DEFINE TEXTBOX &("TxtImg_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  290
                     HEIGHT 13
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                     UPPERCASE .T.
                     ONGOTFOCUS  setproperty("TabWindow","ImgPicker_"+cFormAtivo+strzero((i_temp:=val(substr(this.name,-2))),2,0),"enabled",.t.) //é necessárias as duas linhas aqui em sequência pois estava dando erro de vetor quando o operado clicava no img_picker sem o foco estar no campo imgtext       
                     ONLOSTFOCUS setproperty("TabWindow","ImgPicker_"+cFormAtivo+strzero((i_temp:=val(substr(this.name,-2))),2,0),"enabled",.f.)        
                     TOOLTIP 'Clique nesta caixa de texto para habilitar procura na pasta ao lado'
                     TRANSPARENT .T.
                  END TEXTBOX
                  DEFINE IMAGE &("ImgPicker_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    403
                     WIDTH  18
                     HEIGHT 19
                     PICTURE "PASTA"
                     STRETCH .T.
                     ACTION LocalizaImg()
                     TRANSPARENT .T.
                  END IMAGE
                  nLinha+=18
                  DEFINE IMAGE &("Img_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  100
                     HEIGHT 125
                     PICTURE rtrim(c_PastaFotos)+"\"+alltrim(aCamposEdit[i])
                     TRANSPARENT .T.
                  END IMAGE
               elseif aCamposTip[i,1] = "CHKBOX"
                  Define CheckBox &("Chk_"+cFormAtivo+strzero(i,2,0))
                  	Row	nLinha
                  	Col	115
                  	Width	20
                  	HEIGHT 15
                     TRANSPARENT .F. 
                  End CheckBox
               elseif aCamposTip[i,1] = "LISTBOX"
                  Define ListBox &("Lst_"+cFormAtivo+strzero(i,2,0))
                     Row	 nLinha
                  	Col	 115
                  	Width	 20
                  	HEIGHT 15
                     TRANSPARENT .F. 
                     MULTISELECT .T.
                  End ListBox
               elseif aCamposTip[i,1] = "LSTBOXDUO"
                  DEFINE LISTBOX &("LstDuo_1_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    115
                     WIDTH  150
                     HEIGHT 100
                     ITEMS {''}
                     VALUE 0
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                     FONTBOLD .T.
                     ONDBLCLICK TransfereListBoxDuo(i_temp, "TabWindow")  //realiza a transferencia dos dados do listbox1 para o listbox2
                     TABSTOP .T.
                     TRANSPARENT .T.
                  END LISTBOX
                  DEFINE LISTBOX &("LstDuo_2_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    265
                     WIDTH  150
                     HEIGHT 100
                     ITEMS {''}
                     VALUE 0
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                     FONTBOLD .T.
                     ONDBLCLICK DeletaItemListBoxDuo(i_temp,"TabWindow")  //realiza a exclusão do registro em listbox2, incluída anteriormente pelo operador
                     TABSTOP .T.
                     TRANSPARENT .T.
                  END LISTBOX
               endif
            next i
         END PAGE
      END TAB
   END WINDOW
   END SPLITBOX
END WINDOW
for i = 1 to len(aTabPrincipal)   //cria agora as demais páginas do TAB segundo o vetor aTabPrincipal)
   TabWindow.Tab_1.AddPage( i+1, (aTabPrincipal[i,3]), 'INFO')  //adiciona + 1 ao contador para não coincidir com a página de edição do browse já criada (primeira)
   TabWindow.Tab_1.AddControl( 'Grd_'+strzero(i,2,0)    , i+1, 025 , 010) 
   TabWindow.Tab_1.AddControl( 'Lbl_'+strzero(i,2,0)    , i+1, 320 , 010) 
   TabWindow.Tab_1.AddControl( 'Txt_'+strzero(i,2,0)    , i+1, 318 , 065)
   TabWindow.Tab_1.AddControl( 'ComboPesq_'+strzero(i,2,0)  , i+1, 318 , 270)
   TabWindow.Tab_1.AddControl( 'Img_'+strzero(i,2,0)    , i+1, 318 , 395)
   TabWindow.Tab_1.AddControl( 'ButNovo'+strzero(i,2,0) , i+1, 339 , 090) 
   TabWindow.Tab_1.AddControl( 'ButEdit'+strzero(i,2,0) , i+1, 339 , 170) 
   TabWindow.Tab_1.AddControl( 'ButDele'+strzero(i,2,0) , i+1, 339 , 250) 
   TabWindow.Tab_1.AddControl( 'Frame_' +strzero(i,2,0) , i+1, 358 , 06) 
   TabWindow.Tab_1.AddControl( 'ButtFun'+strzero(i,2,0)+'_01', i+1, 367 , 010) 
   TabWindow.Tab_1.AddControl( 'ButtFun'+strzero(i,2,0)+'_02', i+1, 367 , 090) 
   TabWindow.Tab_1.AddControl( 'ButtFun'+strzero(i,2,0)+'_03', i+1, 367 , 170) 
   TabWindow.Tab_1.AddControl( 'ButtFun'+strzero(i,2,0)+'_04', i+1, 367 , 250) 
   TabWindow.Tab_1.AddControl( 'ButtFun'+strzero(i,2,0)+'_05', i+1, 367 , 330) 

         cTempGridBackColor:="{"
         for b = 1 to len(aGridHeaders)
             if b = 1
                cTempGridBackColor+="{bGridColor}"
             else   
                cTempGridBackColor+=",{bGridColor}"
             endif        
         next b
         cTempGridBackColor+="}"




next i                                                                 
FrmGenerico.Center

if !empty(cFiltroBrowse) //pode haver algum filtro para o arquivo, descrito em funcoes.prg
   (cAliasBrowse)->(dbsetfilter({|| &(cFiltroBrowse)},cFiltroBrowse))
   (cAliasBrowse)->(dbgotop())
endif

setproperty("BrowseWindow","BwsGenerico","value",recno())
BrowseWindow.BwsGenerico.SetFocus
BrowseWindow.BwsGenerico.Refresh
ACTIVATE WINDOW FrmGenerico
Return 

//---------------------------------------------------------------------------
procedure AtualizaBrowseGrid()  //configura banco de dados, variáveis e informações para a manipulação dos dados, tanto no browse principal, como nos tabs (campos para edição do browser ou Grid nos demais Tabs)
//---------------------------------------------------------------------------
if !lCampoAlterado   //se algum campo do grid foi alterado (campos que permitem edição)
    nTabPage:=(TabWindow.Tab_1.value)-1 //verifica qual foi a página do Tab selecionada pelo operador. Subtrai 1 para equiparar com o vetor de informações de Tabs.
    nNroTab:=(TabWindow.Tab_1.value)-1  //guarda número do tab para manter no mesmo tab quando operador altera dados do grid e tenta sair sem salvar
    if nTabPage >= 1 //se a página do tab selecionada não for a primeira (TAB)
       set autoscroll off  //esse comando é importante para a janela rolar automaticamente quando clicado algum controle.
       cAliasTab:=aTabPrincipal[nTabPage,1]   //pega o novo Alias
       DeterminaCampos(cAliasTab, "TAB")
       setproperty("FrmGenerico","ButNovo","enabled",.f.)
       setproperty("FrmGenerico","ButAlte","enabled",.f.)
       setproperty("FrmGenerico","ButDele","enabled",.f.)
       setproperty("FrmGenerico","ButSalv","enabled",.f.)
       setproperty("FrmGenerico","ButSair","enabled",.t.)
       RefreshGrid(nTabPage)  //mostra os dados relacionados no Grid e verifica se os botões (Novo, Alterar e Deletar) devem ficar habilitados ou não
    else //o tab é 0, significa que o arquivo é o mesmo do browse principal
       cAliasTab:=cAliasBrowse   //pega o novo Alias
       set autoscroll on  //esse comando é importante para a janela rolar automaticamente quando clicado algum controle.
       DeterminaCampos(cAliasBrowse, "BROWSE")
       cFormAtivo:="TabWindow"
       cOperacao:="" 
       if empty(BrowseWindow.BwsGenerico.value)  //se o Browse estiver vazio ou o operador não selecionou nenhum registro
          BrowseWindow.BwsGenerico.enabled:=.f.
          TabWindow.Tab_1.enabled := .f.   //desabilita os campos do cadastro e todos os botoes de edicao do browse principal
          setproperty("FrmGenerico","ButAlte","enabled",.f.)
          setproperty("FrmGenerico","ButDele","enabled",.f.)
          setproperty("FrmGenerico","ButSalv","enabled",.f.)
          setproperty("FrmGenerico","ButSair","enabled",.t.)
       else
          BrowseWindow.BwsGenerico.enabled:=.t.
          dbgoto(getproperty("BrowseWindow","BwsGenerico","Value")) //movimenta ponteiro do dbf em questão para ficar de acordo com Browse
       endif 
    endif
    
    if !eval(bGridBotoes) //verifica se foi colocado alguma condição para não deixar operador editar tabs, como por exemplo não deixar ele ver nada sobre uma turma se não há atribuição deste operador para esta turma
       TabWindow.Tab_1.Value := 1  //operador nao pode acessar edicao. Força a volta para o primeiro tab
       TabWindow.Tab_1.Refresh
       TabWindow.Tab_1.enabled := .f.
       setproperty("FrmGenerico","ButSalv","enabled",.f.)  //desabilita botoes e tab
       setproperty("FrmGenerico","ButNovo","enabled",.f.)
       setproperty("FrmGenerico","ButAlte","enabled",.f.)
       setproperty("FrmGenerico","ButDele","enabled",.f.)
       setproperty("FrmGenerico","ButNovo","enabled",.f.)
    else
       if !empty(BrowseWindow.BwsGenerico.value)  //se o Browse estiver vazio ou o operador não selecionou nenhum registro
          TabWindow.Tab_1.enabled := .t.   //operador tem direito de alterar cadastro. Habilita controles.
       endif
       if !(nTabPage >= 1) .and. !empty(BrowseWindow.BwsGenerico.value) //se a página do tab selecionada for a primeira (TAB) e o browse não estiver vazio
          AtuaCamposRegistro() //executa esse procedimento somente se for o primeiro tab
          setproperty("FrmGenerico","ButNovo","enabled",.t.)  //habilita demais controles
          setproperty("FrmGenerico","ButAlte","enabled",.t.)
          setproperty("FrmGenerico","ButDele","enabled",.t.)
          setproperty("FrmGenerico","ButSalv","enabled",.f.)
          setproperty("FrmGenerico","ButSair","enabled",.t.)
       endif
    endif  
else
    Tabwindow.tab_1.value := nNroTab+1  //impede que operador mude foco para outro tab desta janela
    if !empty(cCampoAlterado) //se não tiver sido marcado flag para indicar qual o campo alterado pelo operador
       if msgyesno("DESEJA DESCARTAR ALTERAÇÕES EM "+cCampoAlterado+"?")
          idAlteraCampo(.f., " ") //desmarca flags agora
       else   
          cCampoAlterado:=" " // o programa executa duas vezes a mesma operação, dando duas vezes essa mesma mensagem; naõ sei ainda por que ele faz isso. Consegui fazer com que ele mostre mensagem apenas uma vez desmarcando essa variavel 
          msgInfo("OBS.: SE VOCÊ MUDOU O REGISTRO NA LISTA PRINCIPAL (À ESQUERDA), VOLTE AO REGISTRO ORIGINAL ANTES DE SALVAR")
       endif
    endif
endif
nNumRecPri:=(cAliasBrowse)->(recno())  //guarda o número do registro no browse caso o operador faça a edição pelo browse ou pelo grid, ativando a consulta de outros DB, o que pode movimentar o ponteiro no browse principal. Essa variável private é usada dentro dos módulos consulta.prg e edita.prg. 
return

//---------------------------------------------------------------------------
Static Procedure AtuaCamposRegistro()   //atualiza campos do tab principal (browse) conforme registro corrente
//---------------------------------------------------------------------------
Local i, x, nComboItemCount, cReg:=recno() //guarda a posição do ponteiro na área principal para poder retornar a ela posteriormente

for i = 1 to len(aCamposEdit)
   if aCamposTip[i,1]=="TEXT"
      setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)  //desabilita os campos de edição
      if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
         &(aCamposTip[i,2][1])->(dbseek(cEmpresa+getproperty("TabWindow", "Text_"+cFormAtivo+strzero(i,2,0), "value")))  //procura registro para atualizar Label_99?
         if !empty(getproperty("BrowseWindow", "BwsGenerico", "value")) .and. &(aCamposTip[i,2][1])->(found()) //verifica se o Browser está vazio ou se existe algum registro selecionado
            setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposTip[i,2][1])->&(aCamposTip[i,2][3]))
         else 
            setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"Value", " ")
         endif
         domethod("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"REFRESH")
         setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"enabled",.f.)  //desabilita o label de consulta Label_99?
         setproperty("TabWindow","ButCon_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)  //desabilita o botão de consulta junto ao Label_99?
         dbgoto(cReg) //volta ao registro original na área principal, pois provavelmente o ponteiro foi alterado depois do dbseek, tendo em vista que existe um relacionamento entre as áreas
      endif
   elseif aCamposTip[i,1]="DATA"
      if empty(&(aCamposEdit[i]))  //testa a data se está vazia, pois quando está vazia mostra de forma errada sempre a data mostrada no registro anterior
         setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"Value", ctod("01/01/01"))
      else
         setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      endif
      setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
   elseif aCamposTip[i,1]="MEMO"
      setproperty("TabWindow","Edit_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      setproperty("TabWindow","Edit_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
   elseif aCamposTip[i,1]="COMBO"
      nComboItemCount:=getproperty("TabWindow", "Combo_"+cFormAtivo+strzero(i,2,0), "itemcount") //conta quantos itens tem no combo
      for x = 1 to nComboItemCount
         if alltrim(&(aCamposEdit[i])) == alltrim(getproperty("TabWindow", "Combo_"+cFormAtivo+strzero(i,2,0), "item", x))
            setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"Value", x)
            exit
         endif
      next x
      if x > nComboItemCount
         setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"Value", 0)
      endif
      setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
   elseif aCamposTip[i,1] = "TEXTIMAGE"
      setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
      setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)  
      setproperty("TabWindow","ImgPicker_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)  
      *msgbox("*"+rtrim(c_PastaFotos)+"\"+alltrim(&(aCamposEdit[i]))+"*")
      if empty(alltrim(&(aCamposEdit[i]))) .or. !file(rtrim(c_PastaFotos)+"\"+alltrim(&(aCamposEdit[i])))
         setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"picture","FOTO")  //zera a imagem
      else 
         *msgbox("*"+rtrim(c_PastaFotos)+"\"+alltrim(&(aCamposEdit[i]))+"*")
         setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"picture", rtrim(c_PastaFotos)+"\"+alltrim(&(aCamposEdit[i])))
      endif
      domethod("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"REFRESH")
   elseif aCamposTip[i,1] = "CHKBOX"
      setproperty("TabWindow","Chk_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      setproperty("TabWindow","Chk_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
   elseif aCamposTip[i,1] = "LISTBOX"
      setproperty("TabWindow","Lst_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      setproperty("TabWindow","Lst_"+cFormAtivo+strzero(i,2,0),"enabled",.f.)
   elseif aCamposTip[i,1] = "LSTBOXDUO"
      PreencheListBoxDuo(i,"ATUACAMPOSREGISTRO") //atualiza boxes, mas controle fica desabilitado
   endif
next i
return

//---------------------------------------------------------------------------
Function AtualizaRegistro(pAlias, pModulo)  //tem que ser function, pois retorna valor para o botão "salvar" do FrmEdita
//---------------------------------------------------------------------------
Local i, j, xx_Total, n_For, xx
lContinuaSalvar:=.t. //default como .t. para que possa ser verificado condicao mais abaixo
if !(cOperacao = "INC")  //se não for inclusão
   if empty(getproperty("BrowseWindow","BwsGenerico","value"))  //se não tiver um registro selecionado no Browser principal
      msginfo("Selecione um registro antes!")
      return nil
   endif
endif

if msgyesno("CONFIRMA SALVAR "+iif(cOperacao="INC","INCLUSÃO?","ALTERAÇÃO?"),"",.f.)
   if cOperacao = "INC"  //roda as verificacoes abaixo somente se for inclusao. 
      if eval((bExecutaAntesIncAlt)) //verifica se existe rotina para rodar antes da inclusão/alteração. Somente executa salvamento se tudo estiver ok.
         if msgyesno("Deseja continuar com SALVAR?")
            lContinuaSalvar:=.t.
         else
            lContinuaSalvar:=.f.
         endif
      endif         
   endif
   if lContinuaSalvar
      if cOperacao = "INC"
         &(pAlias)->(dbappend())
         if !(pAlias == "EMPRESA")    //todos os bancos de dados, menos os de empresas, é preenchido com o código da empresa em vigência
            &(pAlias)->(fieldput(1, cEmpresa))
         endif
      endif

      if !TentaAcesso(pAlias);return nil;endif

      for i = 1 to len(aCamposEdit)
         if aCamposTip[i,1]=="TEXT"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "Text_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="DATA"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "Date_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="MEMO"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "Edit_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="COMBO"
            if !empty(GetProperty(cFormAtivo,"Combo_"+cFormAtivo+strzero(i,2,0), "value")) //se nao for zero (nao tiver nada selecionado)
               Replace &(aCamposEdit[i]) with getproperty(cFormAtivo,"Combo_"+cFormAtivo+strzero(i,2,0),"item",GetProperty(cFormAtivo,"Combo_"+cFormAtivo+strzero(i,2,0), "value"))
            endif
         elseif aCamposTip[i,1]="TEXTIMAGE"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "TxtImg_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="CHKBOX"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "Chk_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="LISTBOX"
            replace &(aCamposEdit[i]) with getproperty(cFormAtivo, "Lst_"+cFormAtivo+strzero(i,2,0), "value")
         elseif aCamposTip[i,1]="LSTBOXDUO"
            xx_total:=""
            for n_for = 1 to getproperty(cFormAtivo, "LstDuo_2_"+cFormAtivo+strzero(i,2,0), "itemcount")
               xx = getproperty(cFormAtivo,"LstDuo_2_"+cFormAtivo+strzero(i,2,0),"item", n_for)
               xx_Total+=substr(xx,1,6)
            next
            replace &(aCamposEdit[i]) with xx_total
         endif
      next i
      for j = 1 to len(aExecutaIncAlt) // executa rotinas pós-operações (definidas no módulo funcões) 
         eval((aExecutaIncAlt[j]))
      next j   
      
      &(pAlias)->(dbunlock())
   else
      msgbox("Registro não não foi salvo.")
   endif
   cOperacao:=""
   if upper(pModulo) = "PRINCIPAL" //somente reposiciona browse principal se for edição do browse principal. No caso de edição de outros tabs, não atualiza, pois ficará no mesmo registro.
      BrowseWindow.BwsGenerico.value := &(pAlias)->(recno())  //reposiciona o browse no registro atual, indo para o final do arquivo quando é inclusão e, principalmente, desabilitando os campos de edição à direita
   endif
   AtualizaBrowseGrid()  //força esmaecer campos de edição do browse e recuperar botões de edição
   if cFormAtivo = "TabWindow"
      Domethod("BrowseWindow", "BwsGenerico", "Refresh")
   endif
endif
return .t.   //retorna .t. para o botão "Salvar" do formulário FrmEdita poder fechar a janela logo após atualizar registro

//---------------------------------------------------------------------------
Procedure DeletaRegistro()
//---------------------------------------------------------------------------
Local j
if empty(getproperty("BrowseWindow","BwsGenerico","value"))  //se não tiver um registro selecionado no Browser principal
   msgstop("Selecione um registro antes!")
   return
endif
for j = 1 to len(aExecutaAntesExclusao) // executa rotinas antes das operações (definidas no módulo funcões) 
   if !eval((aExecutaAntesExclusao[j])) //verifica condicao para exclusao. Pode haver várias verificações dentro do vetor.
      return
   endif   
next j
if msgyesno("CONFIRMA DELEÇÃO?")
   if !TentaAcesso(cAliasBrowse);return;endif
   &(cAliasBrowse)->(DBDelete())   
   &(cAliasBrowse)->(dbunlock())
   for j = 1 to len(aExecutaAposExclusao) // executa rotinas pós-operações (definidas no módulo funcões) 
      eval((aExecutaAposExclusao[j])) //roda possivel rotinas apos exclusao (variavel definida em funcoes.prg)
   next j
   if getproperty("BrowseWindow","BwsGenerico","value")=1
      setproperty("BrowseWindow","BwsGenerico","Value", 1)
   endif
   &(cAliasBrowse)->(DBskip(-1))   //reposiciona o ponteiro do banco de dados no registro anterior ao deletado, essa linha e a de baixo são fundamentais para o browse ficar em branco quando o ultimo registro for deletado
   BrowseWindow.BwsGenerico.value := &(cAliasBrowse)->(recno())  //reposiciona o browse no registro atual e já desabilitando os campos da direita
   Domethod("BrowseWindow", "BwsGenerico", "Refresh")
endif
return

//---------------------------------------------------------------------------
procedure NovoRegistro()  //zera controles e pega código do novo registro
//---------------------------------------------------------------------------
Local i, nNovoRegistro
TabWindow.Tab_1.enabled := .t.
TabWindow.Tab_1.Value := 1
TabWindow.Tab_1.Refresh

cOperacao:="INC"
for i = 1 to len(aCamposEdit)
   if aCamposTip[i,1] == "COMBO"
      setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"Value", 0)
      setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita os campos de edição
   elseif aCamposTip[i,1] == "MEMO"
      setproperty("TabWindow","Edit_"+cFormAtivo+strzero(i,2,0),"Value", "")
      setproperty("TabWindow","Edit_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita os campos de edição
   elseif aCamposTip[i,1] == "TEXT"
      if valtype(&(aCamposEdit[i])) = "D"
         setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"Value", ctod(""))
      elseif valtype(&(aCamposEdit[i])) $ "C;M"   //caracter ou memo
         setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"Value", "")
      elseif valtype(&(aCamposEdit[i])) = "N"
         setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"Value", 0)
      endif
      if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
         setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"Value", " ")
         setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"enabled",.t.) 
         setproperty("TabWindow","ButCon_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  
      endif
      setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita os campos de edição
   elseif aCamposTip[i,1] == "DATA"
      setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"Value", date())
      setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita os campos de edição
   elseif aCamposTip[i,1]== "TEXTIMAGE"
      setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i,2,0),"Value", "")
      setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"picture","")  //zera a imagem
      setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita o controle imagem
      setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita os campos de edição
   elseif aCamposTip[i,1]== "CHKBOX"
      setproperty("TabWindow","Chk_"+cFormAtivo+strzero(i,2,0),"Value", .f.)
      setproperty("TabWindow","Chk_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita checkbox
   elseif aCamposTip[i,1]== "LISTBOX"
      setproperty("TabWindow","Lst_"+cFormAtivo+strzero(i,2,0),"Value", "")
      setproperty("TabWindow","Lst_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  //habilita checkbox
   elseif aCamposTip[i,1]="LSTBOXDUO"
      domethod("TabWindow","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"deleteallitems")
      domethod("TabWindow","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"deleteallitems")
      setproperty("TabWindow","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"enabled", .t.)
      setproperty("TabWindow","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"enabled", .t.)
      PreencheListBoxDuo(i, "INCLUSAO") //informa que é inclusão, pois senao controles listboxduo ficam desabilitados
   endif
next i
for i = 1 to len(aLabelsEdit) //habilita labels
   setproperty("TabWindow","Label_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
next i

dbgobottom()
dbskip(1)
nNovoRegistro:=recno()
do while .t.  //procura próximo número de registro livre
   if Alias()="EMPRESA"   //os registros de Empresa não tem o código da empresa como os outros bancos de dado
      if !dbseek(strzero(nNovoRegistro,6,0))
          exit
      endif
   else
      if !dbseek(cEmpresa+strzero(nNovoRegistro,6,0))
          exit
      endif
   endif
   nNovoRegistro++
enddo
TabWindow.Text_TabWindow01.value:=strzero(nNovoRegistro,6,0)

setproperty("TabWindow","Text_TabWindow01","enabled",.f.) //não habilita campo do código do sistema (operador não pode alterar esse campo)

setproperty("FrmGenerico","ButSalv","enabled",.t.)
setproperty("FrmGenerico","ButNovo","enabled",.f.)
setproperty("FrmGenerico","ButAlte","enabled",.f.)
setproperty("FrmGenerico","ButDele","enabled",.f.)
setproperty("FrmGenerico","ButNovo","enabled",.f.)
Return

//---------------------------------------------------------------------------
Procedure PoeOrdem(cDBF, ordem, cLabel)   //reorganiza browse quando operador clicar no header da coluna
//---------------------------------------------------------------------------
if !cOperacao="CON" 
   setproperty("TabWindow","Tab_1","value",1)  //força a volta para o Tab do Browse se o operador estiver nos outros Tabs, pois senão poderá haver problemas com os set relations dos demais tabs
   &(cDBF)->(dbsetorder(ordem))
   &(cDBF)->(dbGOTOP())
   BrowseWindow.BwsGenerico.refresh
   SetProperty("BrowseWindow", cLabel, "value", "Expressão de Busca: "+&(cDBF)->(indexkey()))
else
   &(cDBF)->(dbsetorder(ordem))
   &(cDBF)->(dbGOTOP())
   FrmConsulta.BwsConsulta.refresh
   SetProperty("FrmConsulta", cLabel, "value", "Expressão de Busca: "+&(cDBF)->(indexkey()))
endif
return

//---------------------------------------------------------------------------
Procedure LocalizaBws(cDBF)  //localiza registro no browser conforme string informado pelo operador
//---------------------------------------------------------------------------
if empty(GetProperty("BrowseWindow", "TxtPesquisa", "value"))
   msginfo("Texto de pesquisa em branco!")
   return
endif
if !&(cAliasBrowse)->(dbseek(cEmpresa+rtrim(GetProperty("BrowseWindow", "TxtPesquisa", "value"))))
   msginfo("Registro não encontrado!")
else
   msginfo("OK. Registro encontrado!")
   BrowseWindow.BwsGenerico.value := &(cAliasBrowse)->(recno())
   BrowseWindow.BwsGenerico.refresh
endif
return

//---------------------------------------------------------------------------
Procedure LocalizaImg(cControle)  //abre janela de pastas e arquivos para operador escolher foto
//---------------------------------------------------------------------------
Local cImage
i_temp:=val(substr(this.name,-2))
cImage:=getfile({{"Arquivos jpg","*.jpg"},{"Arquivos gif","*.gif"}},"Selecione a Figura")

Setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i_temp,2,0), "value", substr(cImage,rat("\", cImage)+1)) 
setproperty("TabWindow","Img_"+cFormAtivo+strzero(i_temp,2,0) ,"picture", getproperty("TabWindow", "TxtImg_"+cFormAtivo+strzero(i_temp,2,0), "value"))
return

//--------------------------------------------------------
procedure RefreshGrid(pTabPage)   //atualiza grid com dados do arquivo no Tab corrente
//--------------------------------------------------------
Local cControle:="Grd_"+strzero(pTabPage,2,0)
domethod("TabWindow",cControle,"DisableUpdate")
delete item all from &(cControle) of TabWindow
if dbseek(cEmpresa+&(aTabPrincipal[pTabPage,4][1][1]))
   do while !eof() .and. &(aTabPrincipal[pTabPage,4][1][2]) == &(aTabPrincipal[pTabPage,4][1][1])
      if &(aTabPrincipal[pTabPage,2])  //realiza o filtro descrito em aTabPrincipal
         add item &(aGridCampos) to &(cControle) of TabWindow
      endif
      dbskip(1)
   enddo
   if !eval(bGridBotoes)
      setproperty("TabWindow","ButNovo"+strzero(pTabPage,2,0),"enabled",.f.)  //desabilita o botão de inclusão do grid, pois não atendeu a especificação do bloco em bGridBotoesEdicao
      setproperty("TabWindow","ButEdit"+strzero(pTabPage,2,0),"enabled",.f.)  //desabilita o botão de inclusão do grid, pois não atendeu a especificação do bloco em bGridBotoesEdicao
      setproperty("TabWindow","ButDele"+strzero(pTabPage,2,0),"enabled",.f.)  //desabilita o botão de inclusão do grid, pois não atendeu a especificação do bloco em bGridBotoesEdicao
   else
      setproperty("TabWindow","ButNovo"+strzero(pTabPage,2,0),"enabled",.t.)  //habilita o botão de inclusão do grid, pois atendeu a especificação do bloco em bGridBotoesEdicao
      setproperty("TabWindow","ButEdit"+strzero(pTabPage,2,0),"enabled",.t.)  //habilita o botão de inclusão do grid, pois atendeu a especificação do bloco em bGridBotoesEdicao
      setproperty("TabWindow","ButDele"+strzero(pTabPage,2,0),"enabled",.t.)  //habilita o botão de inclusão do grid, pois atendeu a especificação do bloco em bGridBotoesEdicao
   endif
endif
domethod("TabWindow",cControle,"EnableUpdate")
return   

//---------------------------------------------------------------------------
procedure AlteraRegistro()   //prepara campos do browser para alteração pelo operador  
//---------------------------------------------------------------------------
Local i
if TentaAcesso(cAliasBrowse)
   for i = 1 to len(aCamposEdit)
      if aCamposTip[i,1]=="TEXT"
         setproperty("TabWindow","Text_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
         if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
            setproperty("TabWindow","Label_99"+cFormAtivo+strzero(i,2,0),"enabled",.t.) 
            setproperty("TabWindow","ButCon_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)  
         endif
      elseif aCamposTip[i,1]="DATA"
         setproperty("TabWindow","Date_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1]="MEMO"
         setproperty("TabWindow","Edit_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1]="COMBO"
         setproperty("TabWindow","Combo_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1] = "TEXTIMAGE"
         setproperty("TabWindow","TxtImg_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
         setproperty("TabWindow","Img_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1]="CHKBOX"
         setproperty("TabWindow","Chk_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1]="LISTBOX"
         setproperty("TabWindow","Lst_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      elseif aCamposTip[i,1]="LSTBOXDUO"
         setproperty("TabWindow","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
         setproperty("TabWindow","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"enabled",.t.)
      endif
   next i
   setproperty("TabWindow","Text_TabWindow01","enabled",.f.) //não habilita campo do código do sistema (operador não pode alterar esse campo)
   setproperty("FrmGenerico","ButNovo","enabled",.f.)
   setproperty("FrmGenerico","ButAlte","enabled",.f.)
   setproperty("FrmGenerico","ButDele","enabled",.f.)
   setproperty("FrmGenerico","ButSalv","enabled",.t.)
   cOperacao:="ALT"
endif
return

//---------------------------------------------------------------------------
function TentaAcesso(pAlias)   //bloqueia registro para edição/gravação 
//---------------------------------------------------------------------------
do while .t.
   if !(pAlias)->(rlock())
      if !msgyesno("REGISTRO EM USO POR OUTRO USUÁRIO! DESEJA TENTAR OBTER ACESSO NOVAMENTE?","",.F.)
         return .f.
      endif
   else
      return .t. 
   endif
enddo               
return .f.
//------------------------------------------------------------------------------
Procedure TransfereListBoxDuo(i_temp,pForm)   //realiza a transferencia dos dados do listbox1 para o listbox2
//------------------------------------------------------------------------------
Local n_For, nn, xx, x_for
nn = getproperty(pForm,"LstDuo_1_"+cFormAtivo+strzero(i_temp,2,0),"value")
xx = getproperty(pForm,"LstDuo_1_"+cFormAtivo+strzero(i_temp,2,0),"item", nn)
for n_for=1 to getproperty(pForm, "LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0), "itemcount") 
   x_for := getproperty(pForm,"LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0),"item", n_for) 
   if xx $ x_for
      msginfo('Item "'+alltrim(x_for)+'" já existe; Posição: '+alltrim(str(n_for)),'AVISO')
      return
   endif
next
domethod(pForm,"LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0),"additem", xx)
return

//------------------------------------------------------------------------------
Procedure DeletaItemListBoxDuo(i_temp, pForm)  //realiza a exclusão do registro em listbox2, incluída anteriormente pelo operador
//------------------------------------------------------------------------------
Local nn
nn = getproperty(pForm,"LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0),"value")
domethod(pForm,"LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0),"deleteitem", nn)
setproperty(pForm,"LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0),"value", getproperty(pForm, "LstDuo_2_"+cFormAtivo+strzero(i_temp,2,0), "itemcount") )
return

//------------------------------------------------------------------------------
Procedure MOSTRA()  //mostra informações referentes banco de dados atual
//------------------------------------------------------------------------------
Local g
for g = 1 to 30
   msginfo("Área: "+strzero(g,2,0)+" - Arquivo: "+alias(g)+" - Relação 1: "+&(alias(g))->(dbrelation(1))+" - Relação 2: "+&(alias(g))->(dbrelation(2)))
next
Return

//------------------------------------------------------------------------------
FUNCTION ACAOPOSCAMPO(pCampo, pCamposTip)    //verifica se tem alguma ação programada para esse campo após sua edição. Essa ação é armazenada no bloco de código em DeterminaCampos
//------------------------------------------------------------------------------
pCampo1:=pCampo
if !empty(pCamposTip)
   return(eval((pCamposTip)))
endif
return .T.

//------------------------------------------------------------------------------------------
Procedure PegaValorDaColuna(pOper, pNro)   //pega último campo do registro no grid no qual está o valor de recno(), a fim de proceder com a edição do registro
//------------------------------------------------------------------------------------------
local cControle:="Grd_"+strzero(getproperty("TabWindow","Tab_1","value")-1,2,0)
local nPos := GetProperty ("TabWindow", cControle, "Value")
local aRet := GetProperty ("TabWindow", cControle, 'Item', nPos )

if empty(nPos) .and. pOper $ "ALT|DEL" //se O botão pressionado foi o "Alterar" e não foi selecionado um registro no grid
   msginfo("Selecione antes um registro para "+if(pOper="ALT","alterar!","deletar!"))
   return
endif

nPos:=len(&(aGridCampos)) //pega ultimo valor do grid onde se encontra o recno()
if pOper = "ALT"
   Editar(aRet[nPos], pNro)
elseif pOper = "INC"
   Editar("0", pNro)  //envia zero para informar que é um novo registro
elseif pOper = "DEL"
   DeletaGrid(aRet[nPos])
elseif pOper = "ATA"  //ATA = atalho para funcoes
   eval(aBotoesFuncoes[pNro, 2])
endif
cFormAtivo:="TabWindow"
return

//------------------------------------------------------------------------------------------------------------
Procedure SplashDelay()  //faz com que a tela de apresentação do sistema dure alguns segundos antes de fechar
//------------------------------------------------------------------------------------------------------------
Local iTime
iTime := Seconds()
Do While Seconds() - iTime < 1.5
EndDo
Abertura.release
Return

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
Function SelecionaEmpresa()  //após pressionar o botão OK na tela de seleção da empresa e do Funcionário, essa função é executada para setar os parâmetros escolhidos
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
Local cSenha
empresa->(dbseek(cEmpresa))
anoletiv->(dbsetorder(2))
if !anoletiv->(dbseek(empresa->emp_codigo+empresa->emp_ano))
   MsgExclamation("Dados do Ano Letivo não cadastrados. Favor clicar no ano letivo no rodapé para cadastrar/alterar dados.")
endif   
anoletiv->(dbsetorder(1))
principe.title:="Administração Escolar - "+empresa->emp_nome
cCargo          :=getproperty("Seleciona","Combo_Cargo","item",getproperty("Seleciona","Combo_Cargo", "value"))
cCodCargo       :=substr(getproperty("Seleciona","Combo_Cargo","item",getproperty("Seleciona","Combo_Cargo", "value")),1,6) //separa o codigo do cargo escolhido para ser usado posteriormente
cBimestreAtual  :=empresa->emp_bim
cAnoLetivoAtual :=empresa->emp_ano
dDtIniBimAtual  :=if(cbimestreatual = "1", anoletiv->ano_in1bim, if(cbimestreatual="2",anoletiv->ano_in2bim,if(cbimestreatual="3",anoletiv->ano_in3bim,anoletiv->ano_in4bim)))
dDtLimBimAtual  :=if(cbimestreatual = "1", anoletiv->ano_li1bim, if(cbimestreatual="2",anoletiv->ano_li2bim,if(cbimestreatual="3",anoletiv->ano_li3bim,anoletiv->ano_li4bim)))

cSenha:=getproperty("Seleciona","Text_Senha","value")
if empty(cEmpresa)
   msgstop("ESCOLA NÃO SELECIONADA!")
   return .F.
endif

if empty(cFuncionarioNome) 
   msgstop("FUNCIONÁRIO NÃO SELECIONADO!")
   return .F.
endif

if empty(cCodcargo) 
   msgstop("CARGO NÃO SELECIONADO!")
   return .F.
endif

funciona->(dbsetorder(1)) //PÕE FUNCIONÁRIOS EM ORDEM DE NOME
funciona->(dbseek(cempresa+substr(cfuncionarionome,1,6)))
if !(alltrim(funciona->fun_senha) == alltrim(cSenha))  //verifica se a senha informada está correta
   msginfo("SENHA NÃO CONFERE!")
   return .f.
endif

principe.statusbar.item(1):="funcionário: "+substr(alltrim(cfuncionarionome),1,40)
principe.statusbar.item(2):="bim.atual: "+cbimestreatual
principe.statusbar.item(3):="ano letivo: "+canoletivoatual
principe.statusbar.item(4):="cargo: "+lower(cargos->car_descri)
lusuariologado:=.t.
Seleciona.release
return .t.

//---------------------------------------------------------------------------
Procedure FiltraCargo() 
//---------------------------------------------------------------------------
Local n_End, n_for, x_cargo
cFuncionarioNome:=getproperty("Seleciona","Combo_Funcionario","item",Getproperty("Seleciona","Combo_Funcionario", "value"))

if val(c_OrdemComboFunc) = 1  //Parâmetro informado no menu Feramentas / Parâmetros
   cCodFuncionario :=substr(getproperty("Seleciona","Combo_Funcionario","item",GetProperty("Seleciona","Combo_Funcionario", "value")),1,6)
else
   cCodFuncionario :=substr(getproperty("Seleciona","Combo_Funcionario","item",GetProperty("Seleciona","Combo_Funcionario", "value")),-6)
endif
atribuir->(dbsetorder(3))  //ordem do código do funcionário
atribuir->(dbgotop())
cargos->(dbsetorder(1))    //ordem de código do cargo
seleciona.Combo_Cargo.deleteallitems //apaga todos os itens anteriores do combo_Cargo
do while !atribuir->(eof())
   if atribuir->atr_funcio == cCodFuncionario .and. atribuir->atr_empre == cEmpresa  //somente acrescenta os itens no combo se o funcionário da atribuição for igual ao funcionario selecionado e se ainda não foi acrescentado no combo atual
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      n_end:=getproperty("Seleciona", "Combo_Cargo", "itemcount")
      for n_for=1 to n_end
         x_cargo := substr(getproperty("Seleciona","Combo_Cargo","item",n_for),1,6)
         if cargos->car_codigo == x_cargo
            exit
         endif
      next n_for
      if n_for>n_end  //se for maior significa que foi até o fim do vetor e tentou ir mais um, finalizando o for/next.
         domethod("Seleciona","Combo_Cargo","additem", cargos->car_codigo+"-"+cargos->car_descri)   //agora entra o cargo atribuido em atribuir.dbf
      endif
   endif
   atribuir->(dbskip(1))
enddo
return

//---------------------------------------------------------------------------
Procedure FiltraFuncionario() //executa logo após selecionar empresa no combo de empresas
//---------------------------------------------------------------------------
cEmpresa:=substr(getproperty("Seleciona","Combo_Empresa","item",GetProperty("Seleciona","Combo_Empresa", "value")),1,6)
if val(c_OrdemComboFunc) = 1  //Parâmetro informado no menu Feramentas / Parâmetros 
   funciona->(dbsetorder(1)) //ordem de codigo
   funciona->(dbseek(cEmpresa))  //procura pelo nome do funcionário retirado do combo_Cargo
   seleciona.combo_funcionario.deleteallitems //apaga todos os itens anteriores do combo_Funcionario
   do while !funciona->(eof()) 
      if funciona->fun_empre == cEmpresa
         domethod("Seleciona","Combo_Funcionario","additem", funciona->fun_codigo+"-"+funciona->fun_nome)   //aqui agora entra o cargo atribuido em atribuir.dbf
      endif
      funciona->(dbskip(1))
   enddo
else
   funciona->(dbsetorder(2)) //ordem de nome
   funciona->(dbseek(cEmpresa))  //procura pelo nome do funcionário retirado do combo_Cargo
   seleciona.combo_funcionario.deleteallitems //apaga todos os itens anteriores do combo_Funcionario
   do while !funciona->(eof()) 
      if funciona->fun_empre == cEmpresa
         domethod("Seleciona","Combo_Funcionario","additem", funciona->fun_nome+space(100)+funciona->fun_codigo)   //aqui agora entra o cargo atribuido em atribuir.dbf
      endif
      funciona->(dbskip(1))
   enddo
endif   
return

//---------------------------------------------------------------------------
Function VerificaSenha(pSenhaDigitada) 
//---------------------------------------------------------------------------
return .t.
//----------------------------------------------------------------------------------------------------------------------------
Procedure FinalizaFormPrincipal() //Fecha o form de edição principal. Caso o operador tenha iniciado o processo de inclusão de novo registro, resseta variável cOperacao, pois está com o valor "INC"
//----------------------------------------------------------------------------------------------------------------------------
ResetaOperacao()
BrowseWindow.release
TabWindow.release
FrmGenerico.release
return

//----------------------------------------------------------------------------------------------------------------------------
Procedure ResetaOperacao()
//----------------------------------------------------------------------------------------------------------------------------
&(cAliasBrowse)->(Dbsetfilter())
&(cAliasBrowse)->(Dbgotop())
cOperacao:=""
return

//----------------------------------------------------------------------------------------------------------------------------
procedure PreencheListBoxDuo(pNumComponente, pProcedencia)
//Obs. Esta funcao foi desmembrada da funcao AtuaCamposRegistro para completar a transferencia extra de dados
//no caso os campos ListBoxDuo. Quando o operador seleciona a consulta de BDs, alguns campos são transferidos automaticamente.
//----------------------------------------------------------------------------------------------------------------------------
Local y, n_for, nNroRecord
domethod("TabWindow","LstDuo_1_"+cFormAtivo+strzero(pNumComponente,2,0),"deleteallitems")
domethod("TabWindow","LstDuo_2_"+cFormAtivo+strzero(pNumComponente,2,0),"deleteallitems")
nNroRecord:=&(aList[1])->(recno()) //guarda o número do registro, pois pode estar pegando os codigos no mesmo banco de dado sendo manipulado, alterando a posição do ponteiro
//preenche ListboxDuo1
if empty(aCamposTip[pNumComponente,2])  //verifica se o ListBoxDuo1 terá valores pré-definidos em  aCamposTip[i,2]
   &(aList[1])->(dbgotop())
   do while !&(aList[1])->(eof())
      if eval(aList[3])  //verifica se existe filtro para preencher o listboxDuo
         domethod("TabWindow","LstDuo_1_"+cFormAtivo+strzero(pNumComponente,2,0),"additem",eval(aList[4]))
      endif 
      &(aList[1])->(dbskip(1))
   enddo
else
   for y = 1 to len(aCamposTip[pNumComponente,2])
      domethod("TabWindow","LstDuo_1_"+cFormAtivo+strzero(pNumComponente,2,0),"additem",aCamposTip[pNumComponente,2][y])  //preenche com os valores pre-definidos em listboxDuo         
   next y
endif            
if pProcedencia = "ATUACAMPOSREGISTRO"        
   setproperty("TabWindow","LstDuo_1_"+cFormAtivo+strzero(pNumComponente,2,0),"enabled",.f.)
   setproperty("TabWindow","LstDuo_2_"+cFormAtivo+strzero(pNumComponente,2,0),"enabled",.f.)
else
   setproperty("TabWindow","LstDuo_1_"+cFormAtivo+strzero(pNumComponente,2,0),"enabled",.t.)
   setproperty("TabWindow","LstDuo_2_"+cFormAtivo+strzero(pNumComponente,2,0),"enabled",.t.)
endif
 
&(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro  para operacoes com o mesmo banco de dado para os dois listboxDuo
if !(cOperacao == "INC")  //se for inclusão, não executa rotina de pegar dados para o listboxDuo2
   //preenche listboxDuo2 (se houver registros selecionados para ele)
   for n_for = 1 to len(&(aCamposEdit[pNumComponente])) step 6  //step 6 é o tamanho de cada registro
      if empty(substr(&(aCamposEdit[pNumComponente]),n_for,6))  //pega os codigos do campo até não ter mais (branco)
         exit
      endif  
      &(aList[2])->(dbseek(cEmpresa+substr(&(aCamposEdit[pNumComponente]),n_for,6)))
      domethod("TabWindow","LstDuo_2_"+cFormAtivo+strzero(pNumComponente,2,0),"additem",eval(aList[4]))
      &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro para operacoes com o mesmo banco de dado para os dois listboxDuo
   next n_for
endif
return

//----------------------------------------------------------------------------------------------------------------------------
function ProximoReg(pNomeGrid) //move automaticamente para o proximo registro no grid. Para funcionar, essa funcao deve ser chamada da valid clause do grid
//----------------------------------------------------------------------------------------------------------------------------
Local nValorGridAtual:=getproperty("TabWindow",&("'"+pNomeGrid+"'"),"value")
setproperty("TabWindow",&("'"+pNomeGrid+"'"), "value", nValorGridAtual+1)
return .t.

//---------------------------------------------------------------------------
Procedure TrocaCargo()
//---------------------------------------------------------------------------
Seleciona()
empresa->(dbsetorder(1)) //ordem de codigo
empresa->(dbgotop())
seleciona.combo_Empresa.deleteallitems
do while !empresa->(eof())
   domethod("Seleciona","Combo_Empresa","additem", empresa->emp_codigo+"-"+empresa->emp_nome)
   empresa->(dbskip(1))
enddo
Center Window Seleciona
Activate Window Seleciona
Return

//---------------------------------------------------------------------------
Procedure TrocaBimestre()
//---------------------------------------------------------------------------
DEFINE WINDOW FrmTrocaBimestre AT 0,0 WIDTH 250 HEIGHT 120 TITLE "Troca Bimestre" MODAL NOSIZE
   DEFINE LABEL BimestreAtual
      ROW    15
      COL    8
      WIDTH  120
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE "Bimestre Atual : "
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtBimestre
      ROW    15
      COL    120
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE empresa->emp_bim
      INPUTMASK "9"
   end TEXTBOX
   DEFINE BUTTON ButConfirma
      ROW    50
      COL    30
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION GravaBimestre()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    50
      COL    125
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmTrocaBimestre.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmTrocaBimestre
ACTIVATE WINDOW FrmTrocaBimestre
Return

//----------------------------------------------------------------------------------------------------------------------------
Procedure GravaBimestre() 
//----------------------------------------------------------------------------------------------------------------------------
if !TentaAcesso("Empresa");return;endif
replace empresa->emp_bim with FrmTrocaBimestre.txtBimestre.value
AlteraAnoBim()
MsgInfo("Bimestre Alterado com Sucesso!")
FrmTrocaBimestre.release
return

//---------------------------------------------------------------------------
Function AlteraAnoBim()
//---------------------------------------------------------------------------
cBimestreAtual :=empresa->emp_bim
cAnoLetivoAtual:=empresa->emp_ano
dDtIniBimAtual:=if(cBimestreAtual = "1", anoletiv->ano_in1bim, if(cBimestreAtual="2",anoletiv->ano_in2bim,if(cBimestreAtual="3",anoletiv->ano_in3bim,anoletiv->ano_in4bim)))
dDtLimBimAtual:=if(cbimestreatual = "1", anoletiv->ano_li1bim, if(cbimestreatual="2",anoletiv->ano_li2bim,if(cbimestreatual="3",anoletiv->ano_li3bim,anoletiv->ano_li4bim)))
principe.statusbar.item(2):="Bim.Atual: "+cBimestreAtual
principe.statusbar.item(3):="Ano Letivo: "+cAnoLetivoAtual
return .t.

//----------------------------------------------------------------------------------------------------------------------------
Procedure Fim() //essa funcao se tornou necessária, pois quando fechava o programa ele ainda mantinha alguns relacionamentos de arquivos aberto, o que gerava um erro. Foi necessario tambem colocar a fucao Limparelacoes() no evento ON RELEASE da janela principal.
//----------------------------------------------------------------------------------------------------------------------------
LimpaRelacoes()  //zera todas os set relations estabelecidos anteriormente
principe.release
quit

//----------------------------------------------------------------------------------------------------------------------------
Procedure maximiza() //maximiza tela ao entrar. Houve a necessidade de desmembrar esses comandos por conta de problema de atualização da tela no windows 7 
//----------------------------------------------------------------------------------------------------------------------------
principe.setfocus
Principe.maximize() 
domethod("principe","refresh")
return

//----------------------------------------------------------------------------------------------------------------------------
Procedure ConfigParametros()  //configura parametros do sistema, como margens de impressão, usuario master e pasta das fotos dos alunos e funcionarios. As impressoras comportam-se de maneira diferente, por isso os relatorios estão preparados para receberem os valores iniciais de margem informados aqui
//----------------------------------------------------------------------------------------------------------------------------
DEFINE WINDOW FrmConfigParametros AT 60,25 WIDTH 430 HEIGHT 320 TITLE "Configura Parâmetros do Sistema" MODAL NOSIZE
   DEFINE LABEL LblTopMargin
      ROW    10
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Margem Superior (em Pixels) - Ex: 15"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtTopMargin
      ROW    10
      COL    265
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE c_MargemSuperior
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX

   DEFINE LABEL LblLeftMargin
      ROW    37
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Margem Esquerda (em Pixels) - Ex: 15"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtLeftMargin
      ROW    35
      COL    265
      WIDTH  30
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE c_MargemEsquerda
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL LblUsuarioMaster
      ROW    64
      COL    10
      WIDTH  150
      HEIGHT 20
      VALUE "Usuário Master"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtUsuarioMaster
      ROW    62
      COL    125
      WIDTH  60
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE cFuncionarioMaster
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
      ROW    64
      COL    215
      WIDTH  230
      HEIGHT 12
      FONTNAME "Verdana"
      FONTSIZE 6
      FONTBOLD .T.
      TRANSPARENT .T.
   END LABEL
   DEFINE BUTTON ButCon
      ROW    64
      COL    189
      WIDTH  15
      HEIGHT 14
      CAPTION "P"
      ACTION Consulta("FUNCIONA",{"TxtUsuarioMaster","funciona->fun_codigo"}, "funciona->fun_nome", .f., 1, 1, {})
      FONTNAME "Verdana"
      FONTSIZE 6
      FONTBOLD .T.
      TRANSPARENT .T.
      TABSTOP .F.
   END BUTTON
   DEFINE LABEL LblPastaFotos
      ROW    93
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Pasta das fotos:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtPastaFotos
      ROW    93
      COL    125
      WIDTH  260
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE c_PastaFotos
   end TEXTBOX
   DEFINE IMAGE ImgPicker
      ROW    93
      COL    385
      WIDTH  18
      HEIGHT 19
      PICTURE "PASTA"
      STRETCH .T.
      ACTION LocalizaPastaFotos()
      TRANSPARENT .T.
   END IMAGE
   DEFINE LABEL LblOrdCmbFunc
      ROW    124
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Ordenação no Login:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE RADIOGROUP OrdCmbFunc
      ROW	120
      COL	155
      OPTIONS { 'Código' , 'Nome' } 
      VALUE val(c_OrdemComboFunc) 
      WIDTH 80
      SPACING 25  
      HORIZONTAL  .t.
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   END RADIOGROUP
   DEFINE LABEL LblIPBD
      ROW    150
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "IP do Banco de Dados:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtIPBD
      ROW    150
      COL    190
      WIDTH  230
      HEIGHT 20
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
      VALUE c_Addr
   end TEXTBOX
   DEFINE LABEL LblPorta
      ROW    180
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Porta do Banco de Dados:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtPorta
      ROW    180
      COL    190
      WIDTH  230
      HEIGHT 20
      VALUE c_Port
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE LABEL LblPastaBD
      ROW    210
      COL    10
      WIDTH  250
      HEIGHT 20
      VALUE "Pasta do Banco de Dados:"
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE TEXTBOX TxtPasta
      ROW    210
      COL    190
      WIDTH  230
      HEIGHT 20
      VALUE c_Path
      FONTNAME "Verdana"
      FONTSIZE 8
      UPPERCASE .T.
      FONTBOLD .T.
   end TEXTBOX
   DEFINE BUTTON ButConfirma
      ROW    250
      COL    105
      WIDTH  75
      HEIGHT 24
      CAPTION "Salva"
      ACTION SalvaConfigParametros()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    250
      COL    200
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmConfigParametros.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmConfigParametros
ACTIVATE WINDOW FrmConfigParametros
return
 
//----------------------------------------------------------------------------------------------------------------------------
Procedure SalvaConfigParametros()
//----------------------------------------------------------------------------------------------------------------------------
Begin ini file ("CONFIG.INI")
  Set Section "CONFIGURATION" ENTRY "TopMargin"  To alltrim(FrmConfigParametros.TxtTopMargin.value)
  Set Section "CONFIGURATION" ENTRY "LeftMargin" To alltrim(FrmConfigParametros.TxtLeftMargin.value)
  Set Section "CONFIGURATION" ENTRY "Master"     To alltrim(FrmConfigParametros.TxtUsuarioMaster.value)
  Set Section "CONFIGURATION" ENTRY "PastaFotos" To alltrim(FrmConfigParametros.TxtPastaFotos.value)
  Set Section "CONFIGURATION" ENTRY "OrdCmbFunc" To alltrim(str(FrmConfigParametros.OrdCmbFunc.value))
  Set Section "CONFIGURATION" ENTRY "Port"       To alltrim(FrmConfigParametros.TxtPorta.value)
  Set Section "CONFIGURATION" ENTRY "Path"       To alltrim(FrmConfigParametros.TxtPasta.value)
  Set Section "CONFIGURATION" ENTRY "Address"    To alltrim(FrmConfigParametros.TxtIPBD.value)
End ini
cfuncionarioMaster:=alltrim(FrmConfigParametros.TxtUsuarioMaster.value)
c_MargemEsquerda:=alltrim(FrmConfigParametros.TxtLeftMargin.value)
c_MargemSuperior:=alltrim(FrmConfigParametros.TxtTopMargin.value)
c_OrdemComboFunc:=alltrim(str(FrmConfigParametros.OrdCmbFunc.value))
c_PastaFotos:=alltrim(FrmConfigParametros.TxtPastaFotos.value)
c_Port:=alltrim(FrmConfigParametros.TxtPorta.value)
c_Path:=alltrim(FrmConfigParametros.TxtPasta.value)
c_Addr:=alltrim(FrmConfigParametros.TxtIPBD.value)
msgbox("Parâmetros Gravados!")
FrmConfigParametros.release
return 

//---------------------------------------------------------------------------
Procedure LocalizaPastaFotos()  //abre janela de pastas e arquivos para operador escolher pasta das fotos
//---------------------------------------------------------------------------
Setproperty("FrmConfigParametros","TxtPastaFotos", "value", getfolder("Escolha pasta das fotos"))
return

//---------------------------------------------------------------------------
Procedure CadastraAnoLetivo()
//---------------------------------------------------------------------------
anoletiv->(dbsetorder(2))  //ordem de ano
anoletiv->(dbseek(cEmpresa+cAnoLetivoAtual))

DEFINE WINDOW FrmAnoLetivo AT 0,0 WIDTH 350 HEIGHT 190 TITLE "Cadastra Ano Letivo Bimestre" MODAL NOSIZE 
   DEFINE LABEL InicioBimestre
      ROW    15
      COL    8
      WIDTH  200
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE "Data de Início do Bimestre : "
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE LABEL FimBimestre
      ROW    50
      COL    8
      WIDTH  200
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE "Data Final do Bimestre     : "
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE LABEL LimiteBimestre
      ROW    80
      COL    8
      WIDTH  200
      HEIGHT 20
      FONTNAME "Verdana"
      VALUE "Data Limite do Bimestre    : "
      FONTSIZE 8
      FONTBOLD .T.
   end LABEL
   DEFINE DATEPICKER DataIniBimestre
      ROW    15
      COL    200
      WIDTH  100
      HEIGHT 20
      VALUE nil
      FONTNAME "Verdana"
      VALUE &("anoletiv->ano_in"+cBimestreAtual+"bim")
      FONTSIZE 8
      FONTBOLD .T.
   END DATEPICKER
   DEFINE DATEPICKER DataFimBimestre
      ROW    50
      COL    200
      WIDTH  100
      HEIGHT 20
      VALUE nil
      FONTNAME "Verdana"
      VALUE &("anoletiv->ano_fi"+cBimestreAtual+"bim")
      FONTSIZE 8
      FONTBOLD .T.
   END DATEPICKER
   DEFINE DATEPICKER DataLimBimestre
      ROW    80
      COL    200
      WIDTH  100
      HEIGHT 20
      VALUE nil
      FONTNAME "Verdana"
      VALUE &("anoletiv->ano_li"+cBimestreAtual+"bim")
      FONTSIZE 8
      FONTBOLD .T.
   END DATEPICKER
   DEFINE BUTTON ButConfirma
      ROW    120
      COL    95
      WIDTH  75
      HEIGHT 24
      CAPTION "OK"
      ACTION GravaAnoLetivo()
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
   DEFINE BUTTON ButCancela
      ROW    120
      COL    190
      WIDTH  75
      HEIGHT 24
      CAPTION "Cancela"
      ACTION FrmAnoLetivo.release
      FONTNAME "Verdana"
      FONTSIZE 8
      FONTBOLD .T.
   end BUTTON
END WINDOW
CENTER WINDOW FrmAnoLetivo
ACTIVATE WINDOW FrmAnoLetivo
Return

//----------------------------------------------------------------------------------------------------------------------------
Procedure GravaAnoLetivo() 
//----------------------------------------------------------------------------------------------------------------------------
anoletiv->(dbsetorder(2))  //ordem de ano
if !anoletiv->(dbseek(cEmpresa+cAnoLetivoAtual))
   anoletiv->(dbappend())
   replace anoletiv->ano_empres with cEmpresa
   replace anoletiv->ano_codigo with strzero(anoletiv->(recno()),6,0)
   replace anoletiv->ano_ano    with cAnoLetivoAtual
else
   if !TentaAcesso("ANOLETIV");return;endif
endif
replace &("anoletiv->ano_in"+cBimestreAtual+"bim") with FrmAnoLetivo.DataIniBimestre.value 
replace &("anoletiv->ano_fi"+cBimestreAtual+"bim") with FrmAnoLetivo.DataFimBimestre.value 
replace &("anoletiv->ano_li"+cBimestreAtual+"bim") with FrmAnoLetivo.DataLimBimestre.value 
FrmAnoLetivo.DataIniBimestre.value:=&("anoletiv->ano_in"+cBimestreAtual+"bim")
FrmAnoLetivo.DataFimBimestre.value:=&("anoletiv->ano_fi"+cBimestreAtual+"bim")  
FrmAnoLetivo.DataLimBimestre.value:=&("anoletiv->ano_li"+cBimestreAtual+"bim")  
*domethod("FrmAnoLetivo", "DataIniBimestre","refresh")
*domethod("FrmAnoLetivo", "DataFimBimestre","refresh")
*domethod("FrmAnoLetivo", "DataLimBimestre","refresh")
anoletiv->(dbunlock())
anoletiv->(dbsetorder(1)) //ordem de código
AlteraAnoBim()
MsgInfo("Ano Letivo Alterado com Sucesso!")
FrmAnoLetivo.release
return


Procedure Ajuda()

Procedure MostraCreditos()





#include "minigui.ch"
Memvar pListenSocket

//--------------------------------------------------------------------------------
Function Server()
//--------------------------------------------------------------------------------
Set Multiple Off
pListenSocket := NIL

if !File("Config.ini")
   return .f.
endif

pListenSocket:=netio_mtserver(Val(AllTrim(c_Port)), c_Addr)

if empty(pListenSocket)
   MsgStop("Servidor não pode ser iniciado! Verifique IP da máquina no arquivo config.ini", c_TITLE)
endif
return .t.
//eof
//eof
