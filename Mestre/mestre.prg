#include "minigui.ch"
Memvar pListenSocket

/*
CONSELHO       BITMAP        RES\BMP\CONSELHO.BMP    
CADEADO        BITMAP        RES\BMP\CADEADO.BMP
FUNCIONARIO    BITMAP        RES\BMP\FUNCIONA.BMP    
ESTADO         BITMAP        RES\BMP\ESTADO.BMP
NOVO           BITMAP        RES\BMP\BNOVO.BMP
ALTERA         BITMAP        RES\BMP\BALTERA.BMP
DELETA         BITMAP        RES\BMP\BDELETA.BMP    
IMPRIME        BITMAP        RES\BMP\BIMPRIME.BMP
PESQUISA       BITMAP        RES\BMP\BPESQUISA.BMP
SALVA          BITMAP        RES\BMP\BSALVA.BMP
FECHA          BITMAP        RES\BMP\BFECHA.BMP
SETABAIXO      BITMAP        RES\BMP\SETABAIXO.BMP
BUTTON3        BITMAP        RES\BMP\BUTTON3.BMP
ALUNO          BITMAP        RES\BMP\ALUNOS.BMP
SETOR          BITMAP        RES\BMP\DEPARTAMENTOS.BMP  
MESTRE         BITMAP        RES\BMP\MESTRE2.BMP
MESTRECINZA    BITMAP        RES\BMP\MESTRECINZA.BMP
TIMER          BITMAP        RES\BMP\TIMER.BMP
ESCOLA         BITMAP        RES\BMP\ESCOLA.BMP 
INFO           BITMAP        RES\BMP\INFO.BMP
HORARIO        BITMAP        RES\BMP\HORARIOS.BMP
CURSO          BITMAP        RES\BMP\CURSOS.BMP
ICOCARGO       BITMAP        RES\BMP\ICOCARGO.BMP
CARGOS         BITMAP        RES\BMP\CARGOS.BMP
AVALIACAO      BITMAP        RES\BMP\AVALIACAO.BMP
SETADIREITA    BITMAP        RES\BMP\SETANOVA.BMP                           
SAI            BITMAP        RES\BMP\SAI.BMP
SENHA          BITMAP        RES\BMP\KEYS.BMP
FUNCICONE      BITMAP        RES\BMP\FUNCICONE.BMP
ICOESCOLA      BITMAP        RES\BMP\ICOESCOLA.BMP
PASTA          BITMAP        RES\BMP\PASTA.BMP
VAI            BITMAP        RES\BMP\B_VAI.BMP
FOTO           BITMAP        RES\BMP\FOTO3X4.BMP
OBSERVA        BITMAP        RES\BMP\OBSERVA.BMP
OCORRENCIAS    BITMAP        RES\BMP\OCORRENCIAS.BMP
B_SALVA        BITMAP        RES\BMP\B_SALVA.BMP
B_SAI          BITMAP        RES\BMP\B_SAI.BMP
TEACHER        BITMAP        RES\BMP\TEACHER.BMP
MENCOES        BITMAP        RES\BMP\MENCOES.BMP
MAIN	         ICON          Res\ICON\MAIN.ICO
*/

/*
PROJECTFOLDER=C:\Mestre 01-06-2013
DEBUG=NO
REBUILD=NO
RUNAFTER=YES
HIDEBUILD=YES
DELETETEMP=YES
XHARBOUR=NO
MULTITHREAD=YES
GENPPO=NO
EXETYPE=GUI
WARNINGS=BASIC
GENLIB=NO
PRGPARAMS=
CPARAMS=
EXEPARAMS=
ZIPSUPPORT=NO
ODBCSUPPORT=NO
ADSSUPPORT=NO
MYSQLSUPPORT=NO
C:\MiniGUI\Harbour\lib\hbnetio.lib
C:\MiniGUI\Harbour\lib\hbzlib.lib
C:\Borland\BCC55\Lib\ws2_32.lib
Mestre.prg
Funcoes.prg
Consulta.prg
Edita.prg
Imprime.prg
mestre.rc

*/
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
//eof


#include <minigui.ch>
#include <miniprint.ch>
#include <winprint.ch>

// Measure Units Are Millimeters
Memvar aColor, aliasado, nHandle, aLin, cFiltroBrowse, cMencaoA
Memvar bColumnColor1, bColumnColor2, bColumnColor3
Memvar bColumnColor4, bColumnColor5, bColumnColor6
Memvar bColumnColor7, bColumnColor8, bColumnColor9
Memvar bColumnColor10, bColumnColor11, bColumnColor12
Memvar bColumnColor13, bColumnColor14, bColor, c_pastaFotos
Memvar aLabelsEdit, aCamposEdit, aCamposTip, cFormAnterior, cAliasTab, cAliasBrowse
Memvar aBrowseCampos, aBrowseHeaders, aBrowseWidths, aBrowseIndex, aExecutaExclui
Memvar aGridCampos, aGridHeaders, aGridWidths, aGridColValid, aGridColWhen, lAlteraGrid
Memvar aGridPesquisa, bgridBotoes, cBrowseTitulo, cBrowsePesquisa, aList, aTab, aExecutaIncAlt
Memvar aBotoesFuncoes, cEmpresa, aGridColumnControl, cFormAtivo, pCampo1, cCodFuncionario, tInicial
Memvar cCodCargo, aRelatTab, aRelatBrowse, cAnoLetivoAtual, cBimestreAtual, nTabPage
Memvar CNOTAFINAL, CNOTA4BIM, CNOTA3BIM, CNOTA2BIM, CNOTA1BIM, NTOTALBIMPROFCLASSE, NTOTALBIMNOTACLASSE
Memvar NTOTALANUALPROFALUNO, NTOTALANUALNOTAALUNO, NTOTALANUALPROFCLASSE, NTOTALANUALNOTACLASSE
Memvar NTOTALANUALALUNOFALTAS, CFALTAS4BIM, CFALTAS3BIM, CFALTAS2BIM, CFALTAS1BIM, nTotalBimAlunoFaltas, dDtLimBimAtual
Memvar NCONTAPROFATRIBUICAO, NTOTALBIMPROF, NTOTALBIMALUNONOTAS, dDtIniBimAtual, nSomaQuestoesBranco, lTemGabarito, c_MargemSuperior, c_MargemEsquerda
Memvar cMencaoB, cMencaoC, cMencaoD, cMencaoE, cMencaoF, cMencaoG, cMencaoH
Memvar cMencaoI, cMencaoJ, cMencaoK, cMencaoL
Memvar nColunaMencaoInicio, nColunaMencaoFim, x, cLetras

//---------------------------------------------------------------------------
function imprimir(cArquivo)
//---------------------------------------------------------------------------
Local i, lSuccess
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE
if cArquivo = "CARTEIRINHA"
   cFormAnterior:=cFormAtivo
   cFormAtivo:="FrmImpressao"
   cAliasBrowse:=cAliasTab:='setor'
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 429 HEIGHT 100 TITLE "Impressão de Carteirinhas" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    11
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Série "
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL

      DEFINE TEXTBOX TxtSerie
         ROW    10
         COL    60
         WIDTH  60
         HEIGHT 20
         FONTNAME "Verdana"
         FONTSIZE 8
         UPPERCASE .T.
         FONTBOLD .T.
      end TEXTBOX
   
      DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
         ROW    11
         COL    127
         WIDTH  230
         HEIGHT 20
         *BACKCOLOR {153,153,153}
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
      END LABEL
      DEFINE BUTTON ButCon
         ROW    10
         COL    390
         WIDTH  15
         HEIGHT 19
         CAPTION "P"
         ACTION Consulta("SETOR",{"TxtSerie","setor->set_codigo"}, "setor->set_descri", .f., 1, 1, {})
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
         TABSTOP .F.
      END BUTTON
      DEFINE BUTTON ButConfirma
         ROW    37
         COL    125
         WIDTH  85
         HEIGHT 25
         CAPTION "OK"
         ACTION Carteirinha()
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    37
         COL    235
         WIDTH  85
         HEIGHT 25
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
   cFormAtivo:=cFormAnterior
elseif cArquivo = "NOTAS" 
   imp_tarjeta()
elseif cArquivo = "CONTRATO"
   imp_contrato()
elseif cArquivo $ "RESULTFINAL"
   ImpResultadoAnoLetivoFinal()
elseif cArquivo $ "LISTACLASSE"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE COMBOBOX Combo_Mes
        ROW    10
        COL    10
        WIDTH  260
        HEIGHT 120
        ITEMS {"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        TABSTOP .T.
        VISIBLE .T.
        SORT .F.
        DISPLAYEDIT .F.
      END COMBOBOX

      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpListadeClasse()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "PROFESSOR"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    10
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Professor: "
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL
      DEFINE TEXTBOX TxtProfessor
         ROW    10
         COL    65
         WIDTH  50
         HEIGHT 13
         FONTNAME "Verdana"
         FONTSIZE 6
         UPPERCASE .T.
         FONTBOLD .T.
         VALUE ""
      end TEXTBOX
      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpAvaliacaoResultadoAnaliseProfessor()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    90
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "AVALIACAO"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      Define CheckBox Chk_01
      	 Row		15
      	 Col		30
      	 Width	180
      	 HEIGHT  15
      	 Value	.F.
          FONTNAME "Verdana"
          FONTSIZE 7
          FONTBOLD .T.
          Caption "Imprime Somente Nota Geral" 
          *BACKCOLOR {255,255,255}
          TRANSPARENT .T. 
      End CheckBox

      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION MARCELOespecifico()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "DEVOLUTIVA"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    10
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Série "
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL
      DEFINE TEXTBOX TxtSerie
         ROW    10
         COL    65
         WIDTH  50
         HEIGHT 13
         FONTNAME "Verdana"
         FONTSIZE 6
         UPPERCASE .T.
         FONTBOLD .T.
         VALUE ""
      end TEXTBOX
      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpResultadoAvaliacaoDevolutivaAluno()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "MAPAO"
   if msgyesno("Deseja imprimir versão para digitação, com caracteres maiores? (Para imprimir, escolha orientação retrato)")
      ImpResultadosAvaliacao2()
   else
      ImpMapao()   //ImpResultadosAvaliacao1()
   endif   
elseif cArquivo $ "BOLETIM"
   ImpBoletim()
endif
return nil

*------------------------------------------------------------------------------*
Procedure Carteirinha()
*------------------------------------------------------------------------------*
Local nOrdAntAlunos, nOrdAntProdutos, lSuccess, nstartPrint:=0, nContaCarteirinha:=0
limparelacoes()
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
setor->(dbsetorder(1))  //ordem do código de referência do setor dado pelo operador (não do código do sistema)
alunos->(dbsetorder(1))  //ordem de codigo
turmas->(dbsetorder(2)) //TURMAS->TUR_EMPRE+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_CHAMAD+TURMAS->TUR_ALUNO

START PRINTDOC
START PRINTPAGE

setor->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))

do while !turmas->(eof()) .and. alltrim(turmas->tur_setor)==alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if nContaCarteirinha=4
      END PRINTPAGE
      START PRINTPAGE
      nStartPrint:=nContaCarteirinha:=0
   endif
   if alltrim(turmas->tur_status) = "MATRICULADO(A)"
      alunos->(dbseek(cEmpresa+turmas->tur_aluno))
      @ nStartPrint+05,005 PRINT RECTANGLE TO nStartPrint+065,100 PENWIDTH 0.1
      @ nStartPrint+05,102 PRINT RECTANGLE TO nStartPrint+065,197 PENWIDTH 0.1
   
      @ nStartPrint+07,18 PRINT alltrim(empresa->emp_nome) FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+12,18 PRINT rtrim(empresa->emp_rua)+", "+rtrim(empresa->emp_numero)+" - "+rtrim(empresa->emp_bairro) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+16,18 PRINT rtrim(empresa->emp_cidade)+"-"+rtrim(empresa->emp_estado)+" Tel.: "+rtrim(empresa->emp_tel)    FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+21,08 PRINT "R.G. / Org.Exp. / U.F.                       Data Nascimento" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+26,08 PRINT RECTANGLE TO nStartPrint+29,54 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+26,59 PRINT RECTANGLE TO nStartPrint+29,98 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+26,08 PRINT alltrim(alunos->alu_rgnral)+" / "+alltrim(alunos->alu_rgoral)+" / "+alltrim(alunos->alu_rgufal) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+26,59 PRINT alunos->alu_nasc FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+34,08 PRINT "Válido até" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+39,08 PRINT RECTANGLE TO nStartPrint+42,54 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+39,08 PRINT "31/12/"+alltrim(empresa->emp_ano) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+52,08 PRINT "É importante  a apresentação desta" FONT "arial" SIZE 8 BOLD COLOR aColor[3]
      @ nStartPrint+57,08 PRINT "identidade no momento da entrada"   FONT "arial" SIZE 8 BOLD COLOR aColor[3]
      @ nStartPrint+34,59 PRINT "Direção" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+38,58 PRINT RECTANGLE TO nStartPrint+63,99 PENWIDTH 0.1 COLOR aColor[7]
   
      @ nStartPrint+08.7,122.7 PRINT "CARTEIRA DE ESTUDANTE" FONT "arial" SIZE 14 BOLD COLOR {225,225,225}
      @ nStartPrint+08,122 PRINT "CARTEIRA DE ESTUDANTE" FONT "arial" SIZE 14 BOLD COLOR aColor[9]
      @ nStartPrint+15,128 PRINT "(RA ESCOLAR)" FONT "arial" SIZE 11 BOLD COLOR aColor[9]
      @ nStartPrint+28,104 PRINT iif(alunos->alu_sexo=="M","Aluno",iif(alunos->alu_sexo=="F","Aluna","Aluno(a)")) SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+33,104 PRINT RECTANGLE TO nStartPrint+36,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+33,104 PRINT substr(alunos->alu_nome,1,29) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+38,104 PRINT RECTANGLE TO nStartPrint+41,163 PENWIDTH 3 COLOR aColor[7]
   
      @ nStartPrint+38,104 PRINT alltrim(substr(alunos->alu_nome,30)) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+45,104 PRINT "Nº                             Série/Turma" FONT "arial" SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+50,104 PRINT RECTANGLE TO nStartPrint+52,129 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+50,134 PRINT RECTANGLE TO nStartPrint+52,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+49,104 PRINT turmas->tur_chamad FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+49,136 PRINT setor->set_descri  FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+55,104 PRINT "Período                     R.A. " FONT "arial" SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+60,104 PRINT RECTANGLE TO nStartPrint+63,129 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+60,134 PRINT RECTANGLE TO nStartPrint+63,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+60,104 PRINT setor->set_period FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+60,134 PRINT alunos->alu_ra    FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+57,177 PRINT empresa->emp_ano FONT "arial" SIZE 15 BOLD COLOR aColor[9]
      @ nStartPrint+06,103 PRINT IMAGE alltrim(c_PastaFotos)+"\"+alltrim(empresa->emp_logo) WIDTH 10 HEIGHT 20 
      @ nStartPrint+14,165 PRINT IMAGE alltrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto) WIDTH 20 HEIGHT 40 
      nStartPrint+=66
      nContaCarteirinha++
   endif
   turmas->(dbskip(1))
enddo
end printpage
end PRINTDOC
return

*------------------------------------------------------------------------------*
procedure imp_contrato()
*------------------------------------------------------------------------------*
Local nOrdAntAlunos, nOrdAntProdutos, lSuccess, nstartPrint
Private nHandle
nOrdAntAlunos:=alunos->(dbsetorder())
nOrdAntProdutos:=produtos->(dbsetorder())
alunos->(dbsetorder(1))  //ordem de código
alunos->(dbseek(cEmpresa+contrato->contr_alu))
produtos->(dbsetorder(1)) //ordem de codigo
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   alunos->(dbsetorder(nOrdAntAlunos))
   produtos->(dbsetorder(nOrdAntProdutos))
   return
endif
if (nHandle:=fCreate("texto.txt")) == -1
   msginfo("Erro ao criar arquivo. Veja se não está em uso, se a pasta c:\escola está criada e você tem direito de acesso a ela.")
   return
endif
if ((date()-alunos->alu_nasc)/365)<18
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 390 HEIGHT 200 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr0
         ROW    5
         COL    8
         WIDTH  300
         HEIGHT 25
         VALUE "O aluno é menor de 18 anos. Gerando contrato com dados do responsável cadastrado."
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
      end LABEL
      DEFINE BUTTON Confirma
         ROW    55
         COL    75
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION writeform(.t.)
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
else
   writeform(.f.)
endif
return
//----------------------------------------------------------------------------------------
procedure writeform(lMenor)
//----------------------------------------------------------------------------------------
if lMenor
   fwrite(nHandle, alltrim(alunos->alu_respon)+chr(13)+chr(10))
else
   fwrite(nHandle, alltrim(alunos->alu_nome)+chr(13)+chr(10))
endif
fwrite(nHandle, alltrim(alunos->alu_nacres)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_prores)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_civres)+chr(13)+chr(10))
if lMenor
   fwrite(nHandle, alltrim(alunos->alu_rgnrre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgorre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgufre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_cpfres)+chr(13)+chr(10))
else
   fwrite(nHandle, alltrim(alunos->alu_rgnral)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgoral)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgufal)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_cpfalu)+chr(13)+chr(10))
endif
fwrite(nHandle, alltrim(alunos->alu_end)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_nro)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_bairro)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_cep)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_cidade)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_estado)+chr(13)+chr(10))
fwrite(nHandle, dtoc(contrato->contr_dtin)+chr(13)+chr(10))
fwrite(nHandle, dtoc(contrato->contr_dtfi)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_nome)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_tes1)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_rgt1)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_tes2)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_rgt2)+chr(13)+chr(10))
fwrite(nHandle, alltrim(produtos->pro_descri)+chr(13)+chr(10))
fwrite(nHandle, alltrim(str(produtos->pro_preco))+chr(13)+chr(10))
fclose(nHandle)
return

*------------------------------------------------------------------------------*
Procedure ImpListadeClasse()
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif
START PRINTDOC
   START PRINTPAGE
      nStartPrint:=0
      @ nStartPrint+08,05 PRINT RECTANGLE TO nStartPrint+25,200 PENWIDTH 0.1
      @ nStartPrint+10,07 PRINT empresa->emp_codigo+" - "+empresa->emp_nome FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+15,07 PRINT "LISTA DE CLASSE - "+getproperty("FrmImpressao","Combo_Mes","item",GetProperty("FrmImpressao","Combo_Mes", "value"))+"/"+cAnoLetivoAtual  FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+20,07 PRINT "TURMA: "+setor->set_codigo+" - "+alltrim(setor->set_descri) FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+30,6 PRINT "Código Nº  Nome do Aluno"  FONT "arial" SIZE 7 BOLD COLOR aColor[9]
      for i = 1 to 31
         @ nStartPrint+30,65+((i*4)+1) PRINT RECTANGLE TO nStartPrint+34,65+((i*4)+5) PENWIDTH 0.1
         @ nStartPrint+32,65+((i*4)+2) PRINT STRZERO(I,2,0) FONT "arial" SIZE 5 COLOR aColor[9]
      next i   
      nStartPrint:=35
      TURMAS->(DBGOTOP())
      do while !turmas->(eof())
         if turmas->tur_setor=setor->set_codigo
            *if empty(alunos->alu_foto) .AND. ALLTRIM(TURMAS->TUR_STATUS)="MATRICULADO(A)"
               @ nStartPrint,05 PRINT RECTANGLE TO nStartPrint+4,63 PENWIDTH 0.1
               @ nStartPrint+1,07 PRINT alunos->alu_codigo+" -  "+turmas->tur_chamad+"   "+alunos->alu_nome FONT "arial" SIZE 5 BOLD COLOR aColor[9]
               for i = 1 to 31
                  @ nStartPrint,65+((i*4)+1) PRINT RECTANGLE TO nStartPrint+4,65+((i*4)+5) PENWIDTH 0.1
               next i   
               nStartPrint+=5
            *endif   
         endif
         turmas->(dbskip(1))
      enddo
   end PRINTPAGE
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure ImpResultadoAnoLetivoFinal() //Imprime 5º conceito e menção final (aprovado, retido..., etc)
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt, x:=0, cObserva:=""
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif

limparelacoes()

atribuir->(dbsetorder(2)) //ordem de setor e ordem de materia
cargos->(dbsetorder(1))
conselho->(dbsetorder(2))
consitem->(dbsetorder(2))
turmas->(dbsetorder(2))
alunos->(dbsetorder(1))
setor->(dbsetorder(1))
setor->(dbgotop())

start printdoc
   do while !setor->(eof())
      if !setor->set_ehaula
         setor->(dbskip(1))
         loop
      endif
      start printpage
         nStartPrint:=5
         @ nStartPrint+04,07 PRINT alltrim(empresa->emp_nome)+" - RESULTADOS FINAIS (5º CONCEITO) - Ano "+cAnoLetivoAtual+" - TURMA: "+alltrim(setor->set_descri) FONT "arial" SIZE 7 BOLD COLOR aColor[9]
         @ nStartPrint+09.5,7 PRINT "Nº   Nome do Aluno" FONT "arial" SIZE 6 BOLD COLOR aColor[9]
         x:=0
         atribuir->(dbseek(cEmpresa+setor->set_codigo))
         do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
            x++
            cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
            @ nStartPrint+10,36+(x*5) print alltrim(cargos->car_resumo) FONT "arial" SIZE 5.7 BOLD COLOR aColor[9]
            atribuir->(dbskip(1))
         enddo  
         nStartPrint:=18
         turmas->(dbseek(cEmpresa+setor->set_codigo))
         do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
            conselho->(dbseek(cEmpresa+cAnoLetivoAtual+turmas->tur_setor+cBimestreAtual))
            consitem->(dbseek(cEmpresa+conselho->con_codigo+turmas->tur_chamad+turmas->tur_aluno))
            alunos->(dbseek(cEmpresa+turmas->tur_aluno))

            @nstartprint+1,07 print turmas->tur_chamad+"   "+substr(alunos->alu_nome,1,20) font "arial" size 6 bold color acolor[9]

            atribuir->(dbseek(cempresa+turmas->tur_setor))
            x:=0
            do while !atribuir->(eof()) .and. atribuir->atr_setor = turmas->tur_setor
               x++
               if notas->(dbseek(cempresa+turmas->tur_setor+atribuir->atr_funcio+atribuir->atr_cargo+canoletivoatual+"5"+turmas->tur_chamad+turmas->tur_aluno))
                  @ nstartprint+1,37+(x*5) print if(empty(alltrim(notas->not_nota)),"-",notas->not_nota) font "arial" size 6 bold color if(val(notas->not_nota)>=5, acolor[11],acolor[3])
               else
                  @ nstartprint+1,37+(x*5) print "-" font "arial" size 6 bold color acolor[9]
               endif                     
               atribuir->(dbskip(1))
            enddo  
            cobserva:=consitem->cit_observ
            @ nstartprint+1,40+(x*5) print if(consitem->cit_situac=0,"",if(consitem->cit_situac=1,"",if(consitem->cit_situac=2,"promovido(a)",if(consitem->cit_situac=3,"retido(a)",if(consitem->cit_situac=4, "promovido(a) parcialmente (veja dependência em vermelho)",if(consitem->cit_situac=5,"promovido(a) pelo conselho (veja conceitos vermelhos)","promovido(a) pela progressão continuada (veja conceitos vermelhos)"))))))+if(empty(alltrim(cobserva)),""," "+alltrim(cobserva))+if(substr(turmas->tur_status,1,5)$"recla@trans@reman@"," transferido(a)",if(substr(turmas->tur_status,1,5)$"evadi"," evadido(a)","")) font "arial" size 6 bold color acolor[9]
            nstartprint+=3
            turmas->(dbskip(1))
         enddo
      end printpage
      setor->(dbskip(1))
   enddo
end printdoc
return 

*------------------------------------------------------------------------------*
Procedure imp_tarjeta()
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt, ncontaAlunos, cFuncionarioNome, nNotaChamada
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif
START PRINTDOC
   START PRINTPAGE
      nStartPrint:=0
      @ nStartPrint+04,05 PRINT RECTANGLE TO nStartPrint+8,15 PENWIDTH 0.1
      @ nStartPrint+05,06 PRINT "ANO"  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+04,15 PRINT RECTANGLE TO nStartPrint+8,25 PENWIDTH 0.1
      @ nStartPrint+05,16 PRINT "BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+08,05 PRINT RECTANGLE TO nStartPrint+12,15 PENWIDTH 0.1
      @ nStartPrint+09,06 PRINT cAnoLetivoAtual FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+08,15 PRINT RECTANGLE TO nStartPrint+12,25 PENWIDTH 0.1
      @ nStartPrint+09,16 PRINT cBimestreAtual  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+12,05 PRINT RECTANGLE TO nStartPrint+16,25 PENWIDTH 0.1
      @ nStartPrint+13,06 PRINT " CLASSE " FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,05 PRINT RECTANGLE TO nStartPrint+20,10 PENWIDTH 0.1
      @ nStartPrint+17,06 PRINT "T" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,10 PRINT RECTANGLE TO nStartPrint+20,15 PENWIDTH 0.1
      @ nStartPrint+17,11 PRINT "G" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,15 PRINT RECTANGLE TO nStartPrint+20,20 PENWIDTH 0.1
      @ nStartPrint+17,16 PRINT "S" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,20 PRINT RECTANGLE TO nStartPrint+20,25 PENWIDTH 0.1
      @ nStartPrint+17,21 PRINT "t" FONT "arial" SIZE 7 COLOR aColor[9]

      produtos->(dbseek(cEmpresa+setor->set_PRODUT))
      cargos->(dbseek(cEmpresa+cCodCargo))
      @ nStartPrint+20,05 PRINT RECTANGLE TO nStartPrint+24,10 PENWIDTH 0.1
      @ nStartPrint+21,06 PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,10 PRINT RECTANGLE TO nStartPrint+24,15 PENWIDTH 0.1
      @ nStartPrint+21,11 PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,15 PRINT RECTANGLE TO nStartPrint+24,20 PENWIDTH 0.1
      @ nStartPrint+21,16 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+20,20 PRINT RECTANGLE TO nStartPrint+24,25 PENWIDTH 0.1
      @ nStartPrint+21,21 PRINT substr(alltrim(setor->set_descri),2,2) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+24,05 PRINT RECTANGLE TO nStartPrint+28,25 PENWIDTH 0.1
      @ nStartPrint+25,06 PRINT "COMP.CUR." FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+28,05 PRINT RECTANGLE TO nStartPrint+32,25 PENWIDTH 0.1
      @ nStartPrint+29,06 PRINT cargos->car_compon FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,05 PRINT RECTANGLE TO nStartPrint+36,10 PENWIDTH 0.1
      @ nStartPrint+33,06 PRINT "Nº" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,10 PRINT RECTANGLE TO nStartPrint+36,15 PENWIDTH 0.1
      @ nStartPrint+33,11 PRINT "M" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,15 PRINT RECTANGLE TO nStartPrint+36,20 PENWIDTH 0.1
      @ nStartPrint+33,16 PRINT "F" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,20 PRINT RECTANGLE TO nStartPrint+36,25 PENWIDTH 0.1
      @ nStartPrint+33,21 PRINT "AC" FONT "arial" SIZE 7 COLOR aColor[9]

      nStartPrint:=36
      NOTAS->(DBGOTOP())
      nContaAlunos:=0
      do while !notas->(eof())
         if notas->not_setor=setor->set_codigo
            @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
            @ nStartPrint+1,06 PRINT notas->not_chamad FONT "arial" SIZE 7 COLOR aColor[9]

            @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,15 PENWIDTH 0.1
            @ nStartPrint+1,11 PRINT notas->not_nota FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 

            @ nStartPrint  ,15 PRINT RECTANGLE TO nStartPrint+4,20 PENWIDTH 0.1
            @ nStartPrint+1,16 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]

            @ nStartPrint  ,20 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
            @ nStartPrint+1,21 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]
            nNotaChamada:=val(notas->not_chamad)
            nStartPrint+=4
            nContaAlunos++
         endif
         notas->(dbskip(1))
      enddo      
      for i = 0 to (55-nContaAlunos)
         @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
         @ nStartPrint+1,06 PRINT strzero(nNotaChamada++,2,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,15 PENWIDTH 0.1
         @ nStartPrint  ,15 PRINT RECTANGLE TO nStartPrint+4,20 PENWIDTH 0.1
         @ nStartPrint  ,20 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1
         nStartPrint+=4
      next i
      @ nStartPrint   ,05 PRINT RECTANGLE TO nStartPrint+30,25 PENWIDTH 0.1
      @ nStartPrint+1 ,06 PRINT "Rubr.Prof."      FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+5 ,06 PRINT substr(cFuncionarioNome,8)  FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+12,06 PRINT "Aulas Previstas:" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,06 PRINT "Aulas Dadas:"     FONT "arial" SIZE 7 COLOR aColor[9]
   end PRINTPAGE
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure ImpAvaliacaoResultadoAnaliseProfessor() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msginfo("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         if gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
             lTemGabarito:=.t.
             for i = 1 to val(avaliar->av_nroques)
                 if avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
                     if !("CANCELADA"$AVALQUES->AVQ_TPCORR)
                         if i < 10
                            if alltrim(gabarito->&('q'+strzero(i,1,0))) == alltrim(avalques->avq_respo) 
                               arrQuestao[i]++
                            endif   
                            if empty(alltrim(gabarito->&('q'+strzero(i,1,0))))
                               nSomaQuestoesBranco++
                            endif
                         else
                            if alltrim(gabarito->&('q'+strzero(i,2,0))) == alltrim(avalques->avq_respo)
                               arrQuestao[i]++
                            endif                
                            if empty(alltrim(gabarito->&('q'+strzero(i,2,0))))
                               nSomaQuestoesBranco++
                            endif
                         endif
                     else 
                         arrQuestao[i]:=" X"
                         if i < 10
                            if empty(alltrim(gabarito->&('q'+strzero(i,1,0))))
                               nSomaQuestoesBranco++
                            endif
                         else
                            if empty(alltrim(gabarito->&('q'+strzero(i,2,0))))
                               nSomaQuestoesBranco++
                            endif
                         endif
                     endif    
                 else
                     msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - i = "+STRZERO(i,3,0)+". Rotina interrompida.")
                     return 
                 endif   
             next i    
         else
            lTemGabarito:=.f.
         endif
         if !(nSomaQuestoesBranco=val(avaliar->av_nroques)) .and. lTemGabarito
            nSomaParticipantesProva++
         endif   
         nSomaQuestoesBranco:=0   
         turmas->(dbskip(1))
      enddo   
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      nStartPrint:=0

      *MSGBOX("imprimindo fucnionario="+funciona->fun_nome+" - setor="+setor->set_descri+" - nContacoluna="+str(ncontacoluna))
      @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+05,17+(nContaColuna*22) PRINT "Part:"+strzero(nSomaParticipantesProva,2,0) FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,06+(nContaColuna*22) PRINT "Que" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,06+(nContaColuna*22) PRINT "stão " FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,11+(nContaColuna*22) PRINT "Disc" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,11+(nContaColuna*22) PRINT "iplin" FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,17+(nContaColuna*22) PRINT "Acerto" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,17+(nContaColuna*22) PRINT "Sala" FONT "arial" SIZE 6 COLOR aColor[9]
   
      *avaliar->(dbgotop())
      *do while !avaliar->(eof())
      *   if setor->set_codigo$avaliar->av_setor .and. avaliar->av_ano = cAnoLetivoAtual .and. avaliar->av_bim = cBimestreAtual
      *      exit
      *   endif
      *   avaliar->(dbskip())
      *enddo
      *if avaliar->(eof())
      *   msgbox("Não encontrei setor solicitado em Avaliar")
      *   setor->(dbskip(1))
      *   loop
      *endif   
   
      nStartPrint:=15
      *turmas->(dbseek(cEmpresa+setor->set_codigo))
      *gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) 
   
      for x = 1 to val(avaliar->av_nroques)
          avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(x,3,0)))
   
          @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
          @ nStartPrint+1,06+(nContaColuna*22) PRINT strzero(x,2,0) FONT "arial" SIZE 6 COLOR aColor[9]
   
          @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
          @ nStartPrint+1,11+(nContaColuna*22) PRINT substr(avalques->avq_grupo,1,3) FONT "arial" SIZE 6 COLOR aColor[9]
   
          @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
          @ nStartPrint+1,18+(nContaColuna*22) PRINT if(valtype(arrQuestao[x])="N",strzero(arrQuestao[x],2,0),arrQuestao[x]) FONT "arial" SIZE 6 COLOR aColor[9]
          nStartPrint+=3
      next x
      ncontaColuna++
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 


*------------------------------------------------------------------------------*
Procedure testei() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lSuccess, lFiltraProfessor:=.t., nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito,lSohGeral:=getproperty("FrmImpressao","chk_01","value")

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=nStartPrint:=0
   
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 

      for y = 0 to 19  //são 20 grupos por default
         if y = 0  
             @ 05+01,05+y*15 PRINT "GERAL" FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
             @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
             @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
             @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
             @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
             @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
         endif
         if y > 0 .and. !lSohGeral

*         elseif !lSohGeral
*             @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
*             @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),4,1) FONT "arial" SIZE 8 COLOR aColor[9]
*             @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
*             @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
*             @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
*             @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 


            do while !turmas->(eof())  .and. turmas->tur_setor = setor->set_codigo
               resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))

               if lFiltraProfessor
                  if &('resultav->res_nome'+strzero(y,2,0)) == cargos->car_resumo
                     @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                     @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                     @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                     @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                  endif
               else
                  @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                  @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                  @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                  @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
               endif
 *        else
 *           @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
 *           @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
 *           @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
 *           @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
 *        endif
               nStartPrint+=3
               turmas->(dbskip(1))
            enddo
         endif   
      next y      
   
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      nStartPrint:=0
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure ImpResultadosAvaliacao() //imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y, u, lSuccess, lFiltraProfessor:=.f., nStartPrint, ncontaAlunos, lSohGeral:=getproperty("FrmImpressao","chk_01","value")
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nStartPrint:=0
nContaAlunos:=0
atribuir->(dbsetorder(4))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
   
      for i = 1 to 360 step 6
         nStartPrint:=36
         START PRINTPAGE
         if lFiltraProfessor
            @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
         endif
         if !empty(substr(avaliar->av_setor,i,6))
            if turmas->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)+cAnoLetivoAtual))
               setor->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)))
               do while !turmas->(eof()) .and. turmas->tur_setor = substr(avaliar->av_setor,i,6)
                  resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
                  nContaAlunos++
                  produtos->(dbseek(cEmpresa+setor->set_PRODUT))
                  cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
                  for y = 0 to 19  //são 20 grupos por default
                     if y = 0 .or. lSohGeral 
                         @ 05+01,05+y*15 PRINT "GERAL" FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                         @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                         @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                         @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                         @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                         @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
                     endif
                     if y > 0 .and. !lSohGeral
                        if lFiltraProfessor
                           if &('resultav->res_grup'+strzero(y,2,0)) = cargos->car_resumo
                              @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                              @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                              @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                              @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                              @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                              @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                           endif
                        else
                           @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                           @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                           @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                           @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                           @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                           @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                        endif
                     endif
                  next y      
                  turmas->(dbskip(1))
                  nStartPrint+=4
               enddo
            endif
            nStartPrint+=3
            for u = 1 to (55-nContaAlunos)
                @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
                @ nStartPrint+1,06 PRINT strzero(nContaAlunos+u,2,0) FONT "arial" SIZE 7 COLOR aColor[9]
                @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1
                nStartPrint+=4
            next u
           @ nStartPrint   ,05 PRINT RECTANGLE TO nStartPrint+30,25 PENWIDTH 0.1
           @ nStartPrint+1 ,06 PRINT "Rubr.Prof."      FONT "arial" SIZE 7 COLOR aColor[9]
           @ nStartPrint+12,06 PRINT "Aulas Previstas:" FONT "arial" SIZE 7 COLOR aColor[9]
           @ nStartPrint+20,06 PRINT "Aulas Dadas:"     FONT "arial" SIZE 7 COLOR aColor[9]   
         endif
         end PRINTPAGE
         nStartPrint:=0
      next i
      atribuir->(dbskip(1))
   enddo
   funciona->(dbskip(1))
enddo   
end PRINTDOC
//CriaArquivoResultadoAvaliacao()
return

//------------------------------------------------------------------------------
procedure ImpMapao() //menor imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nStartColumn:=35, nContaAlunos, nChamada:=0, cObserva:=""
Local nColunaMencaoInicio:=nColunaMencaoFim:=0, x, cLetrasCausas, cLetrasEncaminhamentos, cLetraMencao, cMencoes, cProfessores
limparelacoes()
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
capabime->(dbsetorder(2))
consitem->(dbsetorder(2))
conselho->(dbsetorder(2))

setor->(dbsetfilter({|| setor->set_ano = cAnoLetivoAtual},"setor->set_ano = cAnoLetivoAtual"))
setor->(dbgotop())
START PRINTDOC

do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PRINTPAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   produtos->(dbseek(cEmpresa+setor->set_PRODUT))

   nStartColumn:=val(c_MargemEsquerda)
   nStartLine:=val(c_MargemSuperior)

   @nStartLine+00,nStartColumn+01 PRINT RECTANGLE TO nStartLine+18,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+02,nStartColumn+02 print "REGISTRO E"  font "arial" bold size 7 color aColor[9]
   @nStartLine+06,nStartColumn+02 print "CONTROLE DO" font "arial" bold size 7 color aColor[9] 
   @nStartLine+10,nStartColumn+02 print "RENDIMENTO " font "arial" bold size 7 color aColor[9]
   @nStartLine+14,nStartColumn+02 print "ESCOLAR"     font "arial" bold size 7 color aColor[9]

   @nStartLine+00 ,nStartColumn+29 PRINT RECTANGLE TO nStartLine+04,nStartColumn+33 PENWIDTH 0.1
   @nStartLine+1.2,nStartColumn+30 PRINT "50" FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+22,nStartColumn+01 PRINT RECTANGLE TO nStartLine+26,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+02 print "10" font "arial" size 6 color aColor[9] 

   @nStartLine+22,nStartColumn+05 PRINT RECTANGLE TO nStartLine+26,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+06 print "Bimestre: "+cBimestreAtual font "arial" size 6 color aColor[9] 

   @nStartLine+26,nStartColumn+05 PRINT RECTANGLE TO nStartLine+30,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+27,nStartColumn+06 print "Média Final" font "arial" size 6 color aColor[9] 

   @nStartLine+30,nStartColumn+05 PRINT RECTANGLE TO nStartLine+34,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+31,nStartColumn+06 print "Recuperação" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+01 PRINT RECTANGLE TO nStartLine+46,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+02 print "20" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+05 PRINT RECTANGLE TO nStartLine+46,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+06 print "Curso/Habilitação" font "arial" size 6 color aColor[9] 

   @nStartLine+46,nStartColumn+05 PRINT RECTANGLE TO nStartLine+50,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+47,nStartColumn+08 print produtos->pro_tipo font "arial" size 6 color aColor[9] 

   @nStartLine+50,nStartColumn+05 PRINT RECTANGLE TO nStartLine+54,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+51,nStartColumn+06 print "      Código" font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+05 PRINT RECTANGLE TO nStartLine+58,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+62,nStartColumn+01 PRINT RECTANGLE TO nStartLine+66,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+02 print "30" font "arial" size 6 color aColor[9] 

   @nStartLine+62,nStartColumn+05 PRINT RECTANGLE TO nStartLine+66,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+06 print "Ano: "+cAnoLetivoAtual font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+01 PRINT RECTANGLE TO nStartLine+76,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+02 print "40" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+05 PRINT RECTANGLE TO nStartLine+76,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+06 print "Classe" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+05 PRINT RECTANGLE TO nStartLine+80,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+07 print "T" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+10 PRINT RECTANGLE TO nStartLine+80,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+12 print " " font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+15 PRINT RECTANGLE TO nStartLine+80,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+17 print "S" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+20 PRINT RECTANGLE TO nStartLine+80,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+22 print "t" font "arial" size 6 color aColor[9] 

   @nStartLine+80,nStartColumn+05 PRINT RECTANGLE TO nStartLine+84,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+08 PRINT if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+80,nStartColumn+10 PRINT RECTANGLE TO nStartLine+84,nStartColumn+15 PENWIDTH 0.1

   @nStartLine+80,nStartColumn+15 PRINT RECTANGLE TO nStartLine+84,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+18 print substr(alltrim(setor->set_descri),1,1) font "arial" size 6 color aColor[9]

   @nStartLine+80,nStartColumn+20 PRINT RECTANGLE TO nStartLine+84,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+22 print substr(alltrim(setor->set_descri),2,2) font "arial" size 6 color aColor[9]

   @nStartLine+86,nStartColumn+06 print "Carimbo da UE:" font "arial" size 6 color aColor[9]

   @nStartLine+126,nStartColumn+01 print line TO nStartLine+126,nStartColumn+25 penwidth 0.1
   @nStartLine+128,nStartColumn+01 print "Secretário(a) de Escola" font "arial" size 6 color aColor[9]

   @nStartLine+136,nStartColumn+05 PRINT RECTANGLE TO nStartLine+143,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+137,nStartColumn+06 print "NO VERSO ATA" font "arial" size 6 color aColor[9] 
   @nStartLine+140,nStartColumn+06 print "DO CONSELHO"  font "arial" size 6 color aColor[9] 

   @nStartLine+146,nStartColumn+05 PRINT RECTANGLE TO nStartLine+157,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+147,nStartColumn+06 print "   VIDE FICHA " font "arial" size 6 color aColor[9] 
   @nStartLine+150,nStartColumn+06 print "   INDIVIDUAL " font "arial" size 6 color aColor[9] 
   @nStartLine+153,nStartColumn+06 print "   DO ALUNO" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+01 PRINT RECTANGLE TO nStartLine+178,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+02 print "60" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+05 PRINT RECTANGLE TO nStartLine+192,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+06 print " AULAS DADAS" font "arial" size 6 color aColor[9] 
   @nStartLine+179,nStartColumn+06 print " Sub-total  " font "arial" size 6 color aColor[9] 
   @nStartLine+182,nStartColumn+06 print " Acumulado  " font "arial" size 6 color aColor[9] 
   @nStartLine+187,nStartColumn+06 print " Total      " font "arial" size 6 color aColor[9] 
   @nStartLine+189,nStartColumn+06 print "(Observar Reposição)" font "arial" size 5 color aColor[9] 
   @nStartLine+189,nStartColumn+26 print image "SETADIREITA" width 5 height 5

   nStartColumn:=(nStartColumn+28)

   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      nContaAlunos:=0
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))

      @nStartLine+00 ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+03,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+0.2,(nStartColumn+06)+(y*18) PRINT alltrim(substr(cargos->car_descri,1,12)) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @nStartLine+04 ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+06.6,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+07)+(y*18) PRINT "ANO"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+04 ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+06.6,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+17)+(y*18) PRINT "BIM"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+09.2,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+07)+(y*18) PRINT cAnoLetivoAtual FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+09.2,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+17)+(y*18) PRINT cBimestreAtual  FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+9.2,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+11.8,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+9.4,(nStartColumn+08)+(y*18) PRINT " CLASSE "      FONT "arial" SIZE 6.5 COLOR aColor[9]
      
      @nStartLine+11.8,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+06)+(y*18) PRINT "T" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+10)+(y*18) PRINT "G" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+15)+(y*18) PRINT "S" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+19)+(y*18) PRINT "t" FONT "arial" SIZE 6.5 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+14.4,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+06)+(y*18) PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+10)+(y*18) PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+15)+(y*18) PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+19)+(y*18) PRINT substr(alltrim(setor->set_descri),2,2) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+16.7,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+19.3,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+16.9,(nStartColumn+07)+(y*18) PRINT "COMP.CUR." FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+19.3,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+21.9,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+19.5,(nStartColumn+09)+(y*18) PRINT cargos->car_compon FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+21.9,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+06)+(y*18) PRINT "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+10)+(y*18) PRINT "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+15)+(y*18) PRINT "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+19)+(y*18) PRINT "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) PRINT turmas->tur_chamad FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+10)+(y*18) PRINT "TR" FONT "arial" SIZE 6.5 COLOR aColor[9] 
         else 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+11)+(y*18) PRINT notas->not_nota FONT "arial" SIZE 7.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+15)+(y*18) PRINT notas->not_faltas FONT "arial" SIZE 7.5 COLOR aColor[9]
 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+19)+(y*18) PRINT notas->not_compen FONT "arial" SIZE 7.5 COLOR aColor[9]
         nContaAlunos++
         nChamada:=val(turmas->tur_chamad)         
         turmas->(dbskip(1))
      enddo
      for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 65
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
      next i
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5     ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.5 ,(nStartColumn+06)+(y*18) PRINT "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+3   ,(nStartColumn+06)+(y*18) PRINT substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 4.9 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+8.2 ,(nStartColumn+06)+(y*18) PRINT "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+11  ,(nStartColumn+06)+(y*18) PRINT "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+17,(nStartColumn+22)+(y*18) PENWIDTH 0.1 //retangulo para colocar reposição de aulas
      atribuir->(dbskip(1))
   enddo
   end PRINTPAGE
   setor->(dbskip(1))
enddo   

notas->(dbsetorder(5)) //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR+NOTAS->NOT_ALUNO+NOTAS->NOT_CHAMAD
conselho->(dbsetorder(2))  //CONSELHO->CON_EMPRE+CONSELHO->CON_ANO+CONSELHO->CON_SETOR+CONSELHO->CON_BIM
setor->(dbgotop())

do while !setor->(eof())
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif

   if cBimestreAtual=="5"
      if !conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+"4"))
         *msgbox("Não achei conselho bimestre:"+cBimestreAtual+"-cEmpresa:"+cEmpresa+"-Ano:"+cAnoLetivoAtual+"-setor:"+setor->set_codigo+"-Ordem:"+conselho->(indexkey()))
         setor->(dbskip(1))
         loop
      endif
   else
      if !conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+cBimestreAtual))
         *msgbox("Não achei conselho bimestre:"+cBimestreAtual+"-cEmpresa:"+cEmpresa+"-Ano:"+cAnoLetivoAtual+"-setor:"+setor->set_codigo+"-Ordem:"+conselho->(indexkey()))
         setor->(dbskip(1))
         loop
      endif
   endif

   START PRINTPAGE

   nStartColumn:=10
   nStartLine=10

   @nStartLine+00,nStartColumn+01 PRINT RECTANGLE TO nStartLine+04,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+02 print "10" font "arial" size 6 color aColor[9] 

   @nStartLine+00,nStartColumn+05 PRINT RECTANGLE TO nStartLine+14,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+06 print "ATA DO CONSELHO" font "arial" size 6 color aColor[9] 

   @nStartLine+05,nStartColumn+07 PRINT RECTANGLE TO nStartLine+07,nStartColumn+09 PENWIDTH 0.1
   @nStartLine+05.2,nStartColumn+7.4 print "X" font "arial" size 6 color aColor[9] 
   @nStartLine+05,nStartColumn+11 print "DE CLASSE" font "arial" size 6 color aColor[9] 
   @nStartLine+10,nStartColumn+07 PRINT RECTANGLE TO nStartLine+12,nStartColumn+09 PENWIDTH 0.1
   @nStartLine+10,nStartColumn+11 print "DE SÉRIE" font "arial" size 6 color aColor[9] 

   @nStartLine+32,nStartColumn+01 PRINT RECTANGLE TO nStartLine+36,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+33,nStartColumn+02 print "20" font "arial" size 6 color aColor[9] 
   @nStartLine+32,nStartColumn+05 PRINT RECTANGLE TO nStartLine+36,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+33,nStartColumn+11 PRINT "DATA" font "arial" size 6 color aColor[9] 
   @nStartLine+36,nStartColumn+05 PRINT RECTANGLE TO nStartLine+43,nStartColumn+12 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+07 print substr(dtoc(conselho->con_data),1,2) font "arial" size 7 color aColor[9] 
   @nStartLine+36,nStartColumn+12 PRINT RECTANGLE TO nStartLine+43,nStartColumn+19 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+14 print substr(dtoc(conselho->con_data),4,2) font "arial" size 7 color aColor[9] 
   @nStartLine+36,nStartColumn+19 PRINT RECTANGLE TO nStartLine+43,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+21 print substr(dtoc(conselho->con_data),7,4) font "arial" size 7 color aColor[9] 

   @nStartLine+50,nStartColumn+02 print "  FICA A CRITÉRIO  " font "arial" size 6 color aColor[9] 
   @nStartLine+52,nStartColumn+02 print "    DA DIREÇÃO A   " font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+02 print "FORMA DE UTILIZAÇÃO" font "arial" size 6 color aColor[9] 
   @nStartLine+56,nStartColumn+02 print "    DOS CAMPOS E   " font "arial" size 6 color aColor[9] 
   @nStartLine+58,nStartColumn+02 print "ESPAÇOS DISPONÍVEIS" font "arial" size 6 color aColor[9] 

   @nStartLine+170,nStartColumn+01 print line TO nStartLine+170,nStartColumn+25 penwidth 0.1
   @nStartLine+172,nStartColumn+07 print "DIRETOR" font "arial" size 6 color aColor[9]

   nStartColumn:=(nStartColumn+28)

   @nStartLine+00,nStartColumn+07 print RECTANGLE TO nStartLine+04,nStartColumn+11 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+08 print "30" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+11 PRINT RECTANGLE TO nStartLine+04,nStartColumn+70 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+12 print "CAUSAS PROVÁVEIS" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+72 PRINT RECTANGLE TO nStartLine+04,nStartColumn+76 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+73 print "40" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+76 PRINT RECTANGLE TO nStartLine+04,nStartColumn+131 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+77 print "PROPOSTAS DE SOLUÇÃO" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+133 PRINT RECTANGLE TO nStartLine+04,nStartColumn+137 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+134 print "50" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+137 PRINT RECTANGLE TO nStartLine+04,nStartColumn+305 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+138 print "ESPAÇO DESTINADO ÀS OBSERVAÇÕES SOBRE OS ALUNOS" font "arial" size 6 color aColor[9]
   @nStartLine+04,nStartColumn+133 PRINT RECTANGLE TO nStartLine+08,nStartColumn+290 PENWIDTH 0.1

   for x = 0 to 11  //imprime 12 caixas de Causas para colocar mencoes do conselho
      @nStartLine+04,nStartColumn+11+(4*x)    PRINT RECTANGLE TO nStartLine+08,nStartColumn+15+(4*x) PENWIDTH 0.1
   next x
   //acaba de preencher coluna de Causas
   @nStartLine+04,nStartColumn+59         PRINT RECTANGLE TO nStartLine+08,nStartColumn+70 PENWIDTH 0.1

   for x = 0 to 11  //imprime 12 caixas de Encaminhamentos colocar mencoes do conselho
      @nStartLine+04,nStartColumn+76+(4*x)    PRINT RECTANGLE TO nStartLine+08,nStartColumn+80+(4*x) PENWIDTH 0.1
   next x
   //acaba de preencher coluna de Encaminhamentos
   @nStartLine+04,nStartColumn+115 PRINT RECTANGLE TO nStartLine+08,nStartColumn+131 PENWIDTH 0.1

   mencoes->(dbsetorder(2))
   mencoes->(dbgotop())
   x:=0
   cLetrasCausas:=""
   do while !mencoes->(eof())
      if alltrim(mencoes->men_tipo) = "CAUSAS"
         @nStartLine+(04+1),nStartColumn+(11+1.5)+(4*x) PRINT mencoes->men_letra FONT "arial" SIZE 6.5 COLOR aColor[9]
         cLetrasCausas+=mencoes->men_letra 
         x++
      endif
      mencoes->(dbskip(1))
   enddo   
   mencoes->(dbgotop())
   x:=0
   cLetrasEncaminhamentos:=""
   do while !mencoes->(eof())
      if alltrim(mencoes->men_tipo) = "ENCAMINHAMENTOS"
         @nStartLine+(04+1),nStartColumn+(76+1.5)+(4*x) PRINT mencoes->men_letra FONT "arial" SIZE 6.5 COLOR aColor[9] 
         cLetrasEncaminhamentos+=mencoes->men_letra
         x++
      endif
      mencoes->(dbskip(1))
   enddo   
   if !consitem->(dbseek(cEmpresa+conselho->con_codigo))
      msgbox("Não achei consitem")
   endif   

   nContaAlunos:=nChamada:=0

   do while !consitem->(eof()) .and. consitem->cit_conse = conselho->con_codigo
      notas->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+conselho->con_setor+consitem->cit_aluno+consitem->cit_chamad))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
      cMencaoA:=cMencaoB:=cMencaoC:=cMencaoD:=cMencaoE:=cMencaoF:=cMencaoG:=cMencaoH:=cMencaoI:=cMencaoJ:=cMencaoK:=cMencaoL:=.f.
      do while !notas->(eof()) .and. notas->not_setor = setor->set_codigo
         if notas->not_aluno=consitem->cit_aluno
            if notas->not_mencaa
               cMencaoA:=notas->not_mencaa
            endif   
            if notas->not_mencab
               cMencaoB:=notas->not_mencab
            endif   
            if notas->not_mencac
               cMencaoC:=notas->not_mencac
            endif   
            if notas->not_mencad
               cMencaoD:=notas->not_mencad
            endif   
            if notas->not_mencae
               cMencaoE:=notas->not_mencae
            endif   
            if notas->not_mencaf
               cMencaoF:=notas->not_mencaf
            endif   
            if notas->not_mencag
               cMencaoG:=notas->not_mencag
            endif   
            if notas->not_mencah
               cMencaoH:=notas->not_mencah
            endif   
            if notas->not_mencai
               cMencaoI:=notas->not_mencai
            endif   
            if notas->not_mencaj
               cMencaoJ:=notas->not_mencaj
            endif   
            if notas->not_mencak
               cMencaoK:=notas->not_mencak
            endif   
            if notas->not_mencal
               cMencaoL:=notas->not_mencal
            endif   
         endif
         notas->(dbskip(1))
      enddo
      @ nStartLine+(nContaAlunos*2.5)+08,(nStartColumn+7)   PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+11) PENWIDTH 0.1
      @ nStartLine+(nContaAlunos*2.5)+8.5,(nStartColumn+8) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 

      cMencoes:=""

      //Imprime as mencoes de Causas
      nColunaMencaoInicio:=11  //coluna inicial para mencoes "Causas"
      nColunaMencaoFim:=15  //coluna final para mencoes "Causas"
      for x = 1 to len(cLetrasCausas) //imprime menções do conselho de classe
         cLetraMencao:=substr(cLetrasCausas,x,1)
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         if mencoes->(dbseek(cEmpresa+"CAUSAS         "+cLetraMencao))
            @ nStartLine+(nContaAlunos*2.5)+08+0.3,(nStartColumn+(nColunaMencaoInicio+1)) PRINT if(&("cMencao"+cLetraMencao),"X","") FONT "arial" SIZE 6.5 COLOR aColor[9] 
            cMencoes+=mencoes->men_letra+"-"+rtrim(upper(substr(mencoes->men_descri,1,1)))+rtrim(lower(substr(mencoes->men_descri,2)))+"; "
         endif   
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x
      for x = len(cLetrasCausas) to 12 //imprime demais colunas das menções do conselho de classe
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //Imprime as mencoes de Encaminhamentos
      nColunaMencaoInicio:=76  //coluna inicial para mencoes "Encaminhamentos"
      nColunaMencaoFim:=80  //coluna final para mencoes "Encaminhamentos"
      for x = 1 to len(cLetrasEncaminhamentos) //imprime menções do conselho de classe
         cLetraMencao:=substr(cLetrasEncaminhamentos,x,1)
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         if mencoes->(dbseek(cEmpresa+"ENCAMINHAMENTOS"+cLetraMencao))
            @ nStartLine+(nContaAlunos*2.5)+08+0.3,(nStartColumn+(nColunaMencaoInicio+1)) PRINT if(&("cMencao"+cLetraMencao),"X","") FONT "arial" SIZE 6.5 COLOR aColor[9] 
            cMencoes+=mencoes->men_letra+"-"+rtrim(upper(substr(mencoes->men_descri,1,1)))+rtrim(lower(substr(mencoes->men_descri,2)))+"; "
         endif   
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      for x = len(cLetrasEncaminhamentos) to 12 //imprime demais menções do conselho de classe
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //completa os quadros de causas e encaminhamentos
      @ nStartLine+(nContaAlunos*2.5)+08,nStartColumn+59 PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,nStartColumn+70 PENWIDTH 0.1
      @ nStartLine+(nContaAlunos*2.5)+08,nStartColumn+124 PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,nStartColumn+131 PENWIDTH 0.1
*-------------------------------------
      //imprime a linha com observações gerais de cada aluno
      @ nStartLine+(nContaAlunos*2.5)+08,(nStartColumn+133) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+305) PENWIDTH 0.1
      cObserva:=""
      if cBimestreAtual ="5"
         cObserva+=if(consitem->cit_situac=0,"",if(consitem->cit_situac=1,"",if(consitem->cit_situac=2,"promovido(a)",if(consitem->cit_situac=3,"retido(a)",if(consitem->cit_situac=4, "promovido(a) parcialmente (veja dependência em vermelho)",if(consitem->cit_situac=5,"promovido(a) pelo conselho (veja conceitos vermelhos)","promovido(a) pela progressão continuada (veja conceitos vermelhos)"))))))
      endif 
      cObserva+=if(!(consitem->cit_indis1$"0@ "),"Indisciplina "+consitem->cit_indis1+". ","")
      cObserva+=if(consitem->cit_parabe,"Parabéns! ","")
      cObserva+=if(consitem->cit_evadid,"Evadido. ","")
      cObserva+=if(consitem->cit_naoalf,"Não Alfabetizado. ","")
      cObserva+=consitem->cit_observ

      @ nStartLine+(nContaAlunos*2.5)+08+0.2,(nStartColumn+134) PRINT ALLTRIM(cObserva) FONT "arial" SIZE 6 COLOR aColor[9] 

      nContaAlunos++
      consitem->(dbskip(1))
   enddo

   for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 60
      @ nStartLine+((nContaAlunos+i)*2.5)+08      ,(nStartColumn+07) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+11) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+08.5+0.2,(nStartColumn+08) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9]

      //Imprime as mencoes de Causas
      nColunaMencaoInicio:=11  //coluna inicial para mencoes "Causas"
      nColunaMencaoFim:=15  //coluna final para mencoes "Causas"
      for x = 1 to 12 //imprime menções do conselho de classe
         @ nStartLine+((nContaAlunos+i)*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //Imprime as mencoes de Encaminhamentos
      nColunaMencaoInicio:=76  //coluna inicial para mencoes "Encaminhamentos"
      nColunaMencaoFim:=80  //coluna final para mencoes "Encaminhamentos"
      for x = 1 to 12 //imprime menções do conselho de classe
         @ nStartLine+((nContaAlunos+i)*2.5)+08    ,(nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //completa os quadros de causas e encaminhamentos
      @ nStartLine+((nContaAlunos+i)*2.5)+08,nStartColumn+59 PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,nStartColumn+70 PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+08,nStartColumn+124 PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,nStartColumn+131 PENWIDTH 0.1
*-------------------------------------
      //imprime a linha com observações gerais de cada aluno
      @ nStartLine+((nContaAlunos+i)*2.5)+08,(nStartColumn+133) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+305) PENWIDTH 0.1
   next i

   cProfessores:=""
   for y = 1 to 120 step 6
      funciona->(dbseek(cEmpresa+substr(conselho->con_funcio,y,6)))
      cProfessores+=upper(substr(funciona->fun_alcunh,1,1))+rtrim(lower(substr(funciona->fun_alcunh,2)))+"; "
   next i

   @ nStartLine+((nContaAlunos+i)*2.5)+08+2 ,(nStartColumn+07) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+6,(nStartColumn+11) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+3 ,(nStartColumn+08) PRINT "60" FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+2 ,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+6,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+3 ,(nStartColumn+12) PRINT "OBSERVAÇÕES GERAIS:         Legenda Indisciplina-> 1 = Prejudica-se / 2 = Prejudica-se e os pares / 3 = Prejudica-se, os pares e o professor / 4 = Indisciplina Gravíssima   -  Série: "+setor->set_descri FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+6 ,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+10,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+7 ,(nStartColumn+12) PRINT "Participantes: "+cProfessores FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+10,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+14,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+11,(nStartColumn+12) PRINT "Legenda de Menções-> "+cMencoes FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+14,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+18,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+15,(nStartColumn+12) PRINT "Perfil da Sala-> "+upper(substr(conselho->con_observ,1,1))+rtrim(lower(substr(conselho->con_observ,2))) FONT "arial" SIZE 6.5 COLOR aColor[9]

   end PRINTPAGE
   setor->(dbskip(1))
enddo   
end PRINTDOC
capabime->(dbsetorder(2))
setor->(dbsetfilter())
return

//------------------------------------------------------------------------------
procedure ImpResultadosAvaliacao2() //maior imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nContaAlunos, nNotaChamada:=0
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nStartLine:=0
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
setor->(dbgotop())
START PRINTDOC

do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PRINTPAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      if y > 8
         y:=0
         END PRINTPAGE
         START PRINTPAGE
      endif   
      nStartLine:=2
      produtos->(dbseek(cEmpresa+setor->set_produt))
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
      @nStartLine+04,05+y*22 PRINT RECTANGLE TO nStartLine+8,(y*22)+15 PENWIDTH 0.1
      @nStartLine+05,06+y*22 PRINT "ANO"  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+04,15+y*22 PRINT RECTANGLE TO nStartLine+8,(y*22)+25 PENWIDTH 0.1
      @nStartLine+05,16+y*22 PRINT "BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+08,05+y*22 PRINT RECTANGLE TO nStartLine+12,(y*22)+15 PENWIDTH 0.1
      @nStartLine+09,06+y*22 PRINT cAnoLetivoAtual FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+08,15+y*22 PRINT RECTANGLE TO nStartLine+12,(y*22)+25 PENWIDTH 0.1
      @nStartLine+09,16+y*22 PRINT cBimestreAtual  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+12,05+y*22 PRINT RECTANGLE TO nStartLine+16,(y*22)+25 PENWIDTH 0.1
      @nStartLine+13,06+y*22 PRINT " CLASSE " FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,05+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+10 PENWIDTH 0.1
      @nStartLine+17,06+y*22 PRINT "T" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,10+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+15 PENWIDTH 0.1
      @nStartLine+17,11+y*22 PRINT "G" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,15+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+20 PENWIDTH 0.1
      @nStartLine+17,16+y*22 PRINT "S" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,20+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+25 PENWIDTH 0.1
      @nStartLine+17,21+y*22 PRINT "t" FONT "arial" SIZE 7 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+20,05+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+10 PENWIDTH 0.1
      @ nStartLine+21,06+y*22 PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+20,10+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+15 PENWIDTH 0.1
      @ nStartLine+21,11+y*22 PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+20,15+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+20 PENWIDTH 0.1
      @ nStartLine+21,16+y*22 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartLine+20,20+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+21,21+y*22 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartLine+24,05+y*22 PRINT RECTANGLE TO nStartLine+28,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+25,06+y*22 PRINT "COMP.CUR." FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+28,05+y*22 PRINT RECTANGLE TO nStartLine+32,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+29,06+y*22 PRINT cargos->car_compon FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+32,05+y*22 PRINT RECTANGLE TO nStartLine+36,(y*22)+10 PENWIDTH 0.1
      @ nStartLine+32.5,06+y*22 PRINT "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,10+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+15 PENWIDTH 0.1
      @ nStartLine+32.5,11+y*22 PRINT "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,15+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+20 PENWIDTH 0.1
      @ nStartLine+32.5,16+y*22 PRINT "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,20+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+32.5,21+y*22 PRINT "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      nStartLine:=38

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         nContaAlunos++
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine  ,05+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+10 PENWIDTH 0.1
         @ nStartLine+1,06+y*22 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9] 

         @ nStartLine  ,10+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+15 PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+0.5,11+y*22 PRINT "TR" FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         else 
            @ nStartLine+1,11+y*22 PRINT notas->not_nota FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif
 
         @ nStartLine  ,15+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+20 PENWIDTH 0.1
         @ nStartLine+1,16+y*22 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]
 
         @ nStartLine  ,20+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+25 PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+1,21+y*22 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]

         nStartLine+=4
         turmas->(dbskip(1))
      enddo
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine   ,05+y*22 PRINT RECTANGLE TO nStartLine+30,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+1 ,06+y*22 PRINT "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+5 ,06+y*22 PRINT substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+9,06+y*22 PRINT "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+13,06+y*22 PRINT "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      atribuir->(dbskip(1))
   enddo
   end PRINTPAGE
   setor->(dbskip(1))
enddo   
end PRINTDOC
return

*------------------------------------------------------------------------------*
Procedure ImpResultadoAvaliacaoDevolutivaAluno() //Imprime resultado da avaliacao para entregar para alunos (devolutiva)
*------------------------------------------------------------------------------*
Local lSuccess, nStartLine, nQtdeAcertoSala:=0, y, x, nContaColuna:=0, i, arrQuestao:=array(60)
afill(arrQuestao,0)
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
START PRINTDOC
START PRINTPAGE

if !turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
   msgstop("PAREI! Não achei turma.")
   close gabarito
   return
endif 

avaliar->(dbgotop())
do while !avaliar->(eof())
   if turmas->tur_setor$avaliar->av_setor
      exit
   endif
   avaliar->(dbskip())
enddo
if avaliar->(eof())
   msgstop("PAREI! Não encontrei setor solicitado em Avaliar.")
   return
endif   

do while !turmas->(eof()) .and. turmas->tur_setor = alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if !gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
      msgstop("PAREI! Não achei gabarito - nº chamada: "+turmas->tur_chamad)
   endif

   for i = 1 to val(avaliar->av_nroques)
       if !avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
          msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - i = "+STRZERO(i,3,0))
          return
       endif   
       if i < 10
          if alltrim(gabarito->&('q'+strzero(i,1,0))) == alltrim(avalques->avq_respo) 
             arrQuestao[i]++
          endif   
       else
          if alltrim(gabarito->&('q'+strzero(i,2,0))) == alltrim(avalques->avq_respo)
             arrQuestao[i]++
          endif                
       endif
   next i    
   turmas->(dbskip(1))
enddo   

if !turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
   msgstop("PAREI! Não achei turma:"+GetProperty("FrmImpressao","TxtSerie","value"))
   return
endif 
if !setor->(dbseek(cEmpresa+turmas->tur_setor))
   msgstop("PAREI! Não achei setor: "+turmas->tur_setor)
endif   

do while !turmas->(eof()) .and. turmas->tur_setor = alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if nContaColuna>10
      end printpage
      start printpage 
      nContaColuna:=0
   endif         

   nStartLine:=0

   @ nStartLine+04,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+7,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+05,06+(nContaColuna*25) PRINT "Série: "+alltrim(setor->set_descri) FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+04,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+7,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+05,16+(nContaColuna*25) PRINT "Nº: "+turmas->tur_chamad  FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+07,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+10,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+08,06+(nContaColuna*25) PRINT "Ano: "+cAnoLetivoAtual FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+07,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+10,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+08,16+(nContaColuna*25) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,10+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,06+(nContaColuna*25) PRINT "Ques" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,06+(nContaColuna*25) PRINT "tão " FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,11+(nContaColuna*25) PRINT "Sua" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,11+(nContaColuna*25) PRINT "Resp" FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,20+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,16+(nContaColuna*25) PRINT "Resp" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,16+(nContaColuna*25) PRINT "Corr" FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,21+(nContaColuna*25) PRINT "Acer" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,21+(nContaColuna*25) PRINT "Sala" FONT "arial" SIZE 5 COLOR aColor[9]

   avaliar->(dbgotop())
   do while !avaliar->(eof())
      if turmas->tur_setor$avaliar->av_setor
         exit
      endif
      avaliar->(dbskip())
   enddo
   if avaliar->(eof())
      msgstop("PAREI. Não encontrei setor:"+turmas->tur_setor+" solicitado em Avaliar")
      return
   endif   

   nStartLine:=15

   if !gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
      msgstop("PAREI! Não achei gabarito. Aluno:"+turmas->tur_aluno)
      return
   endif
   for x = 1 to val(avaliar->av_nroques)
       if !avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(x,3,0)))
          msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - x = "+STRZERO(x,3,0))
          return
       endif   
       @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
       @ nStartLine+1,06+(nContaColuna*25) PRINT strzero(x,2,0) FONT "arial" SIZE 5 COLOR aColor[9]

       @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
       if x < 10
          @ nStartLine+1,11+(nContaColuna*25) PRINT gabarito->&('q'+strzero(x,1,0)) FONT "arial" SIZE 5 COLOR aColor[9] 
       else
          @ nStartLine+1,11+(nContaColuna*25) PRINT gabarito->&('q'+strzero(x,2,0)) FONT "arial" SIZE 5 COLOR aColor[9]             
       endif
       @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
       @ nStartLine+1,16+(nContaColuna*25) PRINT avalques->avq_respo FONT "arial" SIZE 5 COLOR aColor[9]

       @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
       @ nStartLine+1,21+(nContaColuna*25) PRINT strzero(arrQuestao[x],2,0) FONT "arial" SIZE 5 COLOR aColor[9]
       nStartLine+=3
   next x
   if resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))
      @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,06+(nContaColuna*25) PRINT "GER" FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,11+(nContaColuna*25) PRINT str(resultav->res_geral,5,2) FONT "arial" SIZE 5 COLOR aColor[9]

      @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,16+(nContaColuna*25) PRINT resultav->res_nome01 FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,21+(nContaColuna*25) PRINT str(resultav->res_grup01,5,2) FONT "arial" SIZE 5 COLOR aColor[9]
      for y = 2 to 15 step 2
         nStartLine+=3
         @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,06+(nContaColuna*25) PRINT alltrim(resultav->&('res_nome'+strzero(y,2,0))) FONT "arial" SIZE 5 COLOR aColor[9]
         @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,11+(nContaColuna*25) PRINT str(resultav->&('res_grup'+strzero(y,2,0)),5,2) FONT "arial" SIZE 5 COLOR aColor[9]

         @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,16+(nContaColuna*25) PRINT alltrim(resultav->&('res_nome'+strzero(y+1,2,0))) FONT "arial" SIZE 5 COLOR aColor[9]
         @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,21+(nContaColuna*25) PRINT str(resultav->&('res_grup'+strzero(y+1,2,0)),5,2) FONT "arial" SIZE 5 COLOR aColor[9]
      next y
   else
      msgstop("PAREI! Não achei RESULTAV - Aluno: "+turmas->tur_aluno)
      return
   endif 
   turmas->(dbskip(1))
   ncontaColuna++
enddo
end printpage
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure ImpBoletim() //Imprime boletim
//------------------------------------------------------------------------------
Local y:=0, x:=-1, lSuccess, nStartLine, nStartColumn, ncontaAlunos, nNotaChamada:=0, cProblemas, cEncaminha, cMencoes, nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0, nNotaRecAtual
Private aColor [11], nTotalAnualAlunoFaltas:=nTotalBimProfClasse:=nTotalBimNotaClasse:=0
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
LimpaRelacoes()
turmas->(dbsetorder(2))
nStartLine:=0
setor->(dbsetorder(1))
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
alunos->(dbsetorder(1))
cargos->(dbsetorder(1))
conselho->(dbsetorder(2))
consitem->(dbsetorder(2))
setor->(dbgotop())
START PRINTDOC
START PRINTPAGE

nStartColumn:=val(c_MargemEsquerda)

do while !setor->(eof()) 
   if !setor->set_EhAula; setor->(dbskip(1)); loop; endif  //nao processa setores que nao sao sala de aula
   if !turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual));setor->(dbskip(1));endif  //verifica se tem turma cadastrada neste setor
   do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo .and. turmas->tur_ano = cAnoLetivoAtual
      if turmas->tur_status = "MATRICULADO(A)"
         x++  //conta 4 boletins por página
         if x = 4
            END PRINTPAGE
            START PRINTPAGE
            x:=0
         endif
         nStartLine:=val(c_MargemSuperior)+(x*70)
         cProblemas:=cEncaminha:=cMencoes:=" "
         alunos->(dbseek(cEmpresa+turmas->tur_aluno))

         conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+cBimestreAtual))
         consitem->(dbseek(cEmpresa+conselho->con_codigo+turmas->tur_chamad+turmas->tur_aluno))  

         @nStartLine+04,nStartColumn+06 PRINT "BOLETIM - "+alltrim(setor->set_descri)+" - Bim.: "+cBimestreAtual+" - Ano: "+cAnoLetivoAtual+" - Aluno: "+turmas->tur_chamad+" - "+alltrim(substr(alunos->alu_nome,1,40))+" - Data matrícula: "+dtoc(turmas->tur_datast) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+07,nStartColumn+06 PRINT "MATÉRIA                PROFESSOR                                     NOTA        FALTAS    AC" FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+8.5,nStartColumn+06 PRINT replicate("-",132) FONT "arial" SIZE 7 COLOR aColor[9]
         y:=nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0
         atribuir->(dbseek(cEmpresa+setor->set_codigo))      
         do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
            y++  //soma quantidade de linhas de atribuições
            nStartLine:=(val(c_MargemSuperior)+8)+(x*70)
            cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
            funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
            @nStartLine+(3.5*y),nStartColumn+06 PRINT substr(cargos->car_descri,1,12) FONT "arial" SIZE 7 COLOR aColor[9]
            @nStartLine+(3.5*y),nStartColumn+28 PRINT substr(funciona->fun_nome,1,25) FONT "arial" SIZE 7 COLOR aColor[9]

            if notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))
               @nStartLine+(3.5*y),nStartColumn+72 PRINT notas->not_nota   FONT "arial" SIZE 7 COLOR aColor[9]
               @nStartLine+(3.5*y),nStartColumn+85 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]
               @nStartLine+(3.5*y),nStartColumn+95 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]

               nTotalBimAlunoFaltas+=val(notas->not_faltas)
               nTotalBimAlunoFaltas-=val(notas->not_compen)
               nTotalBimAlunoNotas+=val(notas->not_nota)
               nTotalBimProf++
            endif   
            atribuir->(dbskip(1))
         enddo

         nNotaRecAtual:=notas->(recno())
         notas->(dbsetorder(1))
         notas->(dbgoto(nNotaRecAtual))
         SomaClasseBimAtual()
         SomaMediaClasseAlunoAnual(turmas->tur_aluno)
         @nStartLine+00,nStartColumn+126 PRINT "Total Faltas Ano      : "+strzero(nTotalAnualAlunoFaltas,3,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+04,nStartColumn+126 PRINT "Total Faltas Bimestre : "+strzero(nTotalBimAlunoFaltas,3,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+08,nStartColumn+126 PRINT "Média do Aluno no Bimestre : "+alltrim(str(nTotalBimAlunoNotas/nTotalBimProf)) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+12,nStartColumn+126 PRINT "Média da Classe no Bimestre: "+alltrim(str(nTotalBimNotaClasse/nTotalBimProfClasse)) FONT "arial" SIZE 7 COLOR aColor[9]

         nStartLine:=(val(c_MargemSuperior)+8)+(y*3.5)+(x*70)
         cProblemas+=if(consitem->cit_assidu,"  * Faltas Excessivas","")
         cProblemas+=if(consitem->cit_falcom,"  * Descompromisso","")
         cProblemas+=if(consitem->cit_naorea,"  * Não Faz Atividades","")
         cProblemas+=if(consitem->cit_falest,"  * Não Estuda","")
         cProblemas+=if(consitem->cit_difapr,"  * Dificuldade Aprendizagem","")
         @nStartLine+05,nStartColumn+06 PRINT "Problemas Detectados : "+cProblemas  FONT "arial" SIZE 7 COLOR aColor[9]
  
         cEncaminha+=if(consitem->cit_conpai,"  * Conversar c/Responsável","")
         cEncaminha+=if(consitem->cit_recpar,"  * Recuperação Paralela","")
         cEncaminha+=if(consitem->cit_reccon,"  * Recuperação Contínua","")
         cEncaminha+=if(consitem->cit_habest,"  * Criar hábito de estudo","")
         @nStartLine+09,nStartColumn+06 PRINT "Encaminhamentos : "+cEncaminha  FONT "arial" SIZE 7 COLOR aColor[9]
  
         cMencoes+=if(consitem->cit_parabe,"  * PARABÉNS!!!","")
         cMencoes+=if(consitem->cit_naoalf,"  * Não Alfabetizado","")
         cMencoes+=if(consitem->cit_evadid,"  * Evadido(a)","")
         cMencoes+=if(consitem->cit_indis1="1","  * Indisciplina 1 de 4 : Prejudica a si próprio","")
         cMencoes+=if(consitem->cit_indis1="2","  * Indisciplina 2 de 4 : Prejudica a si e aos colegas","")
         cMencoes+=if(consitem->cit_indis1="3","  * Indisciplina 3 de 4 : Prejudica a si, aos colegas e ao professor","")
         cMencoes+=if(consitem->cit_indis1="4","  * Indisciplina 4 de 4 : Indisciplina Grave","")
         @nStartLine+13,nStartColumn+06 PRINT "Outras Menções : "+cMencoes FONT "arial" SIZE 7 COLOR aColor[9]
      endif
      turmas->(dbskip(1))
   enddo
   setor->(dbskip(1))
enddo   
end PRINTPAGE
end PRINTDOC
capabime->(dbsetorder(2))
LimpaRelacoes()
return

/*
//------------------------------------------------------------------------------
procedure ImpBoletim1() //Imprime boletim
//------------------------------------------------------------------------------
Local y:=0, x:=-1, lSuccess, nStartLine, nStartColumn, ncontaAlunos, nNotaChamada:=0, cProblemas, cEncaminha, cMencoes, nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0, nNotaRecAtual
Private aColor [11], nTotalAnualAlunoFaltas:=nTotalBimProfClasse:=nTotalBimNotaClasse:=0
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif

START PRINTDOC
START PRINTPAGE

nStartColumn:=val(c_MargemEsquerda)

cConsitemMemoField:=consitem->cit_observ

if !produtos->(dbseek(cEmpresa+setor->set_produt))
   msgExclamation("Não encontrei curso.")
endif

aItens:={}

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
               if (alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDataLimBimTemp)) .or. (alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDataLimBimTemp)) 
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
            if notas->not_bim = strzero(i,1,0)
               cRegNumeroBimAtual:=strzero(notas->(recno()),6,0)
            endif
            if cBimestreAtual = notas->not_bim
               lMencaoA:=notas->not_mencaa
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
         setproperty("FrmConselho","LblProf"+strzero(nContaProfAtribuicao,2,0),"value",substr(funciona->fun_alcunh,1,9))
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



end PRINTPAGE
end PRINTDOC
capabime->(dbsetorder(2))
LimpaRelacoes()
return

  */

*------------------------------------------------------------------------------*
Procedure marceloGeral() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lPrimeiroAluno, lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 
      lPrimeiroAluno:=.t.
      nStartPrint:=0
      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr

         if lPrimeiroAluno
            @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,06+(nContaColuna*22) PRINT "Nº" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,06+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,11+(nContaColuna*22) PRINT "Nota" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,11+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,17+(nContaColuna*22) PRINT "GERAL" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
            lPrimeiroAluno:=.f.
            nStartPrint:=15
         endif

         @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,06+(nContaColuna*22) PRINT turmas->tur_chamad FONT "arial" SIZE 6 COLOR aColor[9]
   
         @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,11+(nContaColuna*22) PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 6 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 

         @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         nStartPrint+=3
         turmas->(dbskip(1))
      enddo   
      ncontaColuna++
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure marceloEspecifico() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local u, lPrimeiroAluno, lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 
      lPrimeiroAluno:=.t.
      nStartPrint:=0
      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         
         if resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
            for u = 1 to 20
               if &('resultav->res_nome'+strzero(u,2,0)) = cargos->car_resumo
                  msgbox("achei nome resumido na posição "+str(u)+" - cargo="+cargos->car_resumo+" - resumo="+&('resultav->res_nome'+strzero(u,2,0)))
                  exit
               endif
            next u      
         endif
         if u > 20
            u:=20
         endif   
         if lPrimeiroAluno
            @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,06+(nContaColuna*22) PRINT "Nº" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,06+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,11+(nContaColuna*22) PRINT "Nota" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,11+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,17+(nContaColuna*22) PRINT cargos->car_resumo FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
            lPrimeiroAluno:=.f.
            nStartPrint:=15
         endif

         @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,06+(nContaColuna*22) PRINT turmas->tur_chamad FONT "arial" SIZE 6 COLOR aColor[9]
   
         @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,11+(nContaColuna*22) PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(u,2,0)),5,2),"  -  ") FONT "arial" SIZE 6 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 

         @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         nStartPrint+=3
         turmas->(dbskip(1))
      enddo   
      ncontaColuna++
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure Impwinprint() //menor imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nStartColumn:=35, nContaAlunos, nChamada:=0
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

INIT PRINTSYS

SELECT DEFAULT PREVIEW

DEFINE FONT "F0" NAME "arial" SIZE 6

turmas->(dbsetorder(2)) //ordem de chamada
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
capabime->(dbsetorder(2))

START DOC


do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   nStartColumn:=10
   nStartLine=10

   @nStartLine+00,nStartColumn+01,nStartLine+18,nStartColumn+25 RECTANGLE
   @nStartLine+02,nStartColumn+02 say "REGISTRO E"  font "f0" to print
   @nStartLine+06,nStartColumn+02 say "CONTROLE DO" font "f0" to print 
   @nStartLine+10,nStartColumn+02 say "RENDIMENTO " font "f0" to print
   @nStartLine+14,nStartColumn+02 say "ESCOLAR"     font "f0" to print
  
/*
   @nStartLine+00 ,nStartColumn+29 say RECTANGLE TO nStartLine+04,nStartColumn+33 PENWIDTH 0.1
   @nStartLine+1.2,nStartColumn+30 say "50" FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+22,nStartColumn+01 say RECTANGLE TO nStartLine+26,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+02 say "10" font "arial" size 6 color aColor[9] 

   @nStartLine+22,nStartColumn+05 say RECTANGLE TO nStartLine+26,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+06 say "Bimestre" font "arial" size 6 color aColor[9] 

   @nStartLine+26,nStartColumn+05 say RECTANGLE TO nStartLine+30,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+27,nStartColumn+06 say "Média Final" font "arial" size 6 color aColor[9] 

   @nStartLine+30,nStartColumn+05 say RECTANGLE TO nStartLine+34,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+31,nStartColumn+06 say "Recuperação" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+01 say RECTANGLE TO nStartLine+46,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+02 say "20" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+05 say RECTANGLE TO nStartLine+46,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+06 say "Curso/Habilitação" font "arial" size 6 color aColor[9] 

   @nStartLine+46,nStartColumn+05 say RECTANGLE TO nStartLine+50,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+50,nStartColumn+05 say RECTANGLE TO nStartLine+54,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+51,nStartColumn+06 say "    Código" font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+05 say RECTANGLE TO nStartLine+58,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+62,nStartColumn+01 say RECTANGLE TO nStartLine+66,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+02 say "30" font "arial" size 6 color aColor[9] 

   @nStartLine+62,nStartColumn+05 say RECTANGLE TO nStartLine+66,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+06 say "Ano" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+01 say RECTANGLE TO nStartLine+76,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+02 say "40" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+05 say RECTANGLE TO nStartLine+76,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+06 say "Classe" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+05 say RECTANGLE TO nStartLine+80,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+06 say "T" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+10 say RECTANGLE TO nStartLine+80,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+11 say "E" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+15 say RECTANGLE TO nStartLine+80,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+16 say "S" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+20 say RECTANGLE TO nStartLine+80,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+22 say "+" font "arial" size 6 color aColor[9] 

   @nStartLine+80,nStartColumn+05 say RECTANGLE TO nStartLine+84,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+10 say RECTANGLE TO nStartLine+84,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+15 say RECTANGLE TO nStartLine+84,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+20 say RECTANGLE TO nStartLine+84,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+86,nStartColumn+06 say "Carimbo da UE:" font "arial" size 6 color aColor[9]

   @nStartLine+126,nStartColumn+01 say line TO nStartLine+126,nStartColumn+25 penwidth 0.1
   @nStartLine+128,nStartColumn+01 say "Secretário(a) de Escola" font "arial" size 6 color aColor[9]

   @nStartLine+136,nStartColumn+05 say RECTANGLE TO nStartLine+143,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+137,nStartColumn+06 say "NO VERSO ATA" font "arial" size 6 color aColor[9] 
   @nStartLine+140,nStartColumn+06 say "DO CONSELHO"  font "arial" size 6 color aColor[9] 

   @nStartLine+146,nStartColumn+05 say RECTANGLE TO nStartLine+157,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+147,nStartColumn+06 say "   VIDE FICHA " font "arial" size 6 color aColor[9] 
   @nStartLine+150,nStartColumn+06 say "   INDIVIDUAL " font "arial" size 6 color aColor[9] 
   @nStartLine+153,nStartColumn+06 say "   DO ALUNO" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+01 say RECTANGLE TO nStartLine+178,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+02 say "60" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+05 say RECTANGLE TO nStartLine+192,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+06 say " AULAS DADAS" font "arial" size 6 color aColor[9] 
   @nStartLine+179,nStartColumn+06 say " Sub-total  " font "arial" size 6 color aColor[9] 
   @nStartLine+182,nStartColumn+06 say " Acumulado  " font "arial" size 6 color aColor[9] 
   @nStartLine+187,nStartColumn+06 say " Total      " font "arial" size 6 color aColor[9] 
   @nStartLine+189,nStartColumn+06 say "(Observar Reposição)" font "arial" size 5 color aColor[9] 
   @nStartLine+189,nStartColumn+26 say image "SETADIREITA" width 5 height 5

   nStartColumn:=(nStartColumn+28)

   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      nContaAlunos:=0
      produtos->(dbseek(cEmpresa+setor->set_PRODUT))
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))

      @nStartLine+00 ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+03,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+0.2,(nStartColumn+06)+(y*18) say alltrim(substr(cargos->car_descri,1,12)) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @nStartLine+04 ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+06.6,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+07)+(y*18) say "ANO"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+04 ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+06.6,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+17)+(y*18) say "BIM"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+09.2,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+07)+(y*18) say cAnoLetivoAtual FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+09.2,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+17)+(y*18) say cBimestreAtual  FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+9.2,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+11.8,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+9.4,(nStartColumn+08)+(y*18) say " CLASSE "      FONT "arial" SIZE 6.5 COLOR aColor[9]
      
      @nStartLine+11.8,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+06)+(y*18) say "T" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+10)+(y*18) say "G" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+15)+(y*18) say "S" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+19)+(y*18) say "t" FONT "arial" SIZE 6.5 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+14.4,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+06)+(y*18) say  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+10)+(y*18) say alltrim(produtos->pro_tipo) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+15)+(y*18) say substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+19)+(y*18) say substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+16.7,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+19.3,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+16.9,(nStartColumn+07)+(y*18) say "COMP.CUR." FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+19.3,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+21.9,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+19.5,(nStartColumn+09)+(y*18) say cargos->car_compon FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+21.9,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+06)+(y*18) say "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+10)+(y*18) say "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+15)+(y*18) say "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+19)+(y*18) say "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      *nStartLine:=25.5

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) say turmas->tur_chamad FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+10)+(y*18) say "TR" FONT "arial" SIZE 6.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         else 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+11)+(y*18) say notas->not_nota FONT "arial" SIZE 6.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+15)+(y*18) say notas->not_faltas FONT "arial" SIZE 6.5 COLOR aColor[9]
 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+19)+(y*18) say notas->not_compen FONT "arial" SIZE 6.5 COLOR aColor[9]

         nContaAlunos++
         nChamada:=val(turmas->tur_chamad)         
         turmas->(dbskip(1))
      enddo
      for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 65
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) say strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
      next i
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5     ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.5 ,(nStartColumn+06)+(y*18) say "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+3   ,(nStartColumn+06)+(y*18) say substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 4.9 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+8.2 ,(nStartColumn+06)+(y*18) say "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+11  ,(nStartColumn+06)+(y*18) say "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+17,(nStartColumn+22)+(y*18) PENWIDTH 0.1 //retangulo para colocar reposição de aulas
      atribuir->(dbskip(1))
   enddo
*/
   end PAGE
   setor->(dbskip(1))
enddo   
end DOC
capabime->(dbsetorder(2))
RELEASE PRINTSYS
return



#include "minigui.ch"
Memvar cFormAtivo, cFormAnterior, cOperacao, cBrowseTitulo, cAliasTab, aLabelsEdit, aCamposTip, i_Temp, cCodFuncionario, cFuncionarioMaster
Memvar aList, aCamposEdit, aTabPrincipal, cEmpresa, nTabPage, aExecutaAposExclusao, cAliasBrowse, nNumRecPri 
//-----------------------------------------------------------------------------------------------------------------------
procedure Editar(cReg, nNro)
//-----------------------------------------------------------------------------------------------------------------------
Local nLinha, i
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmEdita"
if cReg == "0"  //se cReg é igual a zero é porque trata-se de uma inclusao de registro
   cOperacao="INC"
   dbgobottom()
   dbskip(1)
else   
   dbgoto(val(cReg))
endif
DEFINE WINDOW FrmMestreEdita AT 0,0 WIDTH 490 HEIGHT 600 VIRTUAL WIDTH NIL VIRTUAL HEIGHT NIL TITLE cBrowseTitulo MODAL NOSYSMENU 
   DEFINE SPLITBOX
      DEFINE TOOLBAR ToolBar_Edita BUTTONSIZE 35,35 FONT "Verdana" SIZE 6
         BUTTON ButEdit1 CAPTION "Salva"    PICTURE "B_SALVA"    ACTION if(AtualizaRegistro(cAliasTab,"EDITA"),FinalizaEdit(),.t.)  //atualiza e fecha a janela
         BUTTON ButEdit2 CAPTION "Sai"      PICTURE "B_SAI"      ACTION FinalizaEdit()
      END TOOLBAR
      DEFINE WINDOW FrmEdita WIDTH 490 HEIGHT 530 VIRTUAL WIDTH 491 VIRTUAL HEIGHT 950 SPLITCHILD NOCAPTION
         nLinha:=0
         for i = 1 to len(aLabelsEdit)
            nLinha+=18
            DEFINE LABEL &("Label_"+cFormAtivo+strzero(i,2,0))
               ROW    nLinha
               COL    10
               WIDTH  108
               HEIGHT 12
               VALUE &("'"+aLabelsEdit[i]+"'")
               FONTNAME "Verdana"
               FONTSIZE 6
               FONTBOLD .t.
               TRANSPARENT .T.
            END LABEL
         next i
         nLinha:=0
         for i = 1 to len(aCamposEdit)
            nLinha+=18
            if aCamposTip[i,1] = "TEXT"
               if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
                  DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    125
                     WIDTH  90
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
                     *ONLOSTFOCUS Consulta(aCamposTip[i_temp,2][1],{"Text_"+cFormAtivo+strzero(i_temp,2,0), aCamposTip[i_temp,2][2]}, aCamposTip[i_temp,2][3],.T.,2,i_temp)
                  END TEXTBOX
                  DEFINE LABEL &("Label_99"+cFormAtivo+strzero(i,2,0))  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99
                     ROW    nLinha
                     COL    218
                     WIDTH  192
                     HEIGHT 12
                     *BACKCOLOR {253,253,253}
                     VALUE ""
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                  END LABEL
                  DEFINE BUTTON &("ButCon_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    412
                     WIDTH  15
                     HEIGHT 14
                     CAPTION "P"
                     ACTION Consulta(aCamposTip[i_temp,2][1],{"Text_"+cFormAtivo+strzero(i_temp,2,0), aCamposTip[i_temp,2][2]}, aCamposTip[i_temp,2][3],.f.,2,i_temp)
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                     FONTBOLD .T.
                  END BUTTON
               else 
                  DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    125
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
                  END TEXTBOX
                  if i = 1 .and. !(cReg == "0") // não deixa alterar o código, porque ele é automático (somente se não for um novo registro)
                     setproperty("FrmEdita", "Text_"+cFormAtivo+strzero(i,2,0), "enabled", .f.)
                  endif
               endif 
            elseif aCamposTip[i,1] = "COMBO" 
               DEFINE COMBOBOX &("Combo_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
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
               END COMBOBOX
               if aCamposTip[i,2] //se for .t. essa posição significa que os dados do combo devem vir de um arquivo dbf
                  &(aCamposTip[i,3])->(dbgotop())
                  do while !&(aCamposTip[i,3])->(eof())
                     domethod("frmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"additem", &(aCamposTip[i,3])->&(aCamposTip[i,4]))
                     &(aCamposTip[i,3])->(dbskip(1))
                  enddo
               endif
            elseif aCamposTip[i,1] = "DATA" 
               DEFINE DATEPICKER &("Date_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  290
                  HEIGHT 14
                  VALUE nil
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .T.
               END DATEPICKER
            elseif aCamposTip[i,1] = "MEMO" 
               DEFINE EDITBOX &("Edit_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  290
                  HEIGHT 100
                  VALUE ""
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .T.
               END EDITBOX
               nLinha+=60  //como o controle Combo deve ser o último na lista de edição, colocamos o nLinha maior para o redimensionamento da janela de edição dar certo e abranger o tamanho da caixa Memo
            elseif aCamposTip[i,1] = "CHKBOX"
               DEFINE CHECKBOX &("Chk_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  200
                  HEIGHT 18
                  VALUE .F.
                  CAPTION " "
                  FONTNAME "Arial"
                  FONTSIZE 9
                  TOOLTIP ""
                  TABSTOP .T.
               END CHECKBOX
            elseif aCamposTip[i,1] = "LISTBOX"
               Define ListBox &("Lst_"+cFormAtivo+strzero(i,2,0))
                  Row	 nLinha
               	Col	 125
                 	Width	 20
                 	HEIGHT 15
                  TRANSPARENT .F. 
                  MULTISELECT .T.
               End ListBox
            elseif aCamposTip[i,1] = "LSTBOXDUO"
               DEFINE LISTBOX &("LstDuo_1_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    75
                  WIDTH  150
                  HEIGHT 100
                  ITEMS {''}
                  VALUE 0
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  TOOLTIP ""
                  ONCHANGE Nil
                  ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                  ONLOSTFOCUS Nil
                  FONTBOLD .F.
                  FONTITALIC .F.
                  FONTUNDERLINE .F.
                  FONTSTRIKEOUT .F.
                  *BACKCOLOR NIL
                  FONTCOLOR NIL
                  ONDBLCLICK TransfereListBoxDuo(i_temp,"FrmEdita")
                  TABSTOP .T.
                  SORT .F.
                  MULTISELECT .F.
               END LISTBOX
               DEFINE LISTBOX &("LstDuo_2_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    230
                  WIDTH  150
                  HEIGHT 100
                  ITEMS {''}
                  VALUE 0
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  TOOLTIP ""
                  ONCHANGE Nil
                  ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                  ONLOSTFOCUS Nil
                  FONTBOLD .F.
                  FONTITALIC .F.
                  FONTUNDERLINE .F.
                  FONTSTRIKEOUT .F.
                  *BACKCOLOR NIL
                  FONTCOLOR NIL
                  ONDBLCLICK DeletaItemListBoxDuo(i_temp,"FrmEdita")
                  TABSTOP .T.
                  SORT .F.
                  MULTISELECT .F.
               END LISTBOX
            ENDIF
         next i
      END WINDOW
   END SPLITBOX
END WINDOW
dbunlock()
*FrmEdita.height := (nLinha+228) //recalcula tamanho da janela depois de criar todos os campos de edição
AtuaCampoRegGrid(cReg, nNro)
CENTER WINDOW FrmMestreEdita
ACTIVATE WINDOW FrmMestreEdita
Return

//---------------------------------------------------------------------------
Static Procedure AtuaCampoRegGrid(cReg, nNro) //preenche os campos a serem editados após o operador selecionar Editar, Alterar no grid
//---------------------------------------------------------------------------
Local i, x, n_for, nComboItemCount, nNroRecord
for i = 1 to len(aCamposEdit)
   if cReg == "0"  // somente preenche automaticamente os campos de edição se for Inclusão. Na alteração, os campos de edição terão o mesmo valor dos campos do DBF.
      for x = 1 to len(aTabPrincipal[nNro,4]) //verifica se alguns campos chaves devem ser preenchidos automaticamente
         if upper(aTabPrincipal[nNro,4,x,2])=upper(aCamposEdit[i])
            if valtype(&(aCamposEdit[i])) == "C"
               setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", &(aTabPrincipal[nNro,4,x,1]))
               DoMethod("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"SETFOCUS") //faz com que os campos textos com label de pesquisa (label_99?) tenham seu label atualizado (como se o operador tivesse digitado tab) na funcao TransfereRegistro() do programa Consulta.prg
            elseif valtype(&(aCamposEdit[i])) == "D"
               setproperty("FrmEdita","Date_"+cFormAtivo+strzero(i,2,0),"Value", &(aTabPrincipal[nNro,4,x,1]))
            endif               
         endif
      next x
   endif

   if aCamposTip[i,1]="TEXT"
      if cReg!="0"
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      endif
      if cReg == "0" .and. i = 1  //se a operação é de inclusão de registro novo (reg=="0") e for o primeiro campo (i=1), significa que devemos por o número do registro nesse campo. Isso é padrão para todos os dbfs
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", strzero(recno(),6,0))
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.)
      endif
      if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
         setproperty("FrmEdita","Label_99"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposTip[i,2][1])->&(aCamposTip[i,2][3]))
      endif
   elseif aCamposTip[i,1]="DATA"
      if cReg!="0"
      setproperty("FrmEdita","Date_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))      
      endif
   elseif aCamposTip[i,1]="MEMO"
      setproperty("FrmEdita","Edit_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1] = "CHKBOX"
      setproperty("FrmEdita","Chk_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1] = "LISTBOX"
      setproperty("FrmEdita","Lst_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1]="COMBO"
      nComboItemCount:=getproperty("FrmEdita", "Combo_"+cFormAtivo+strzero(i,2,0), "itemcount") //conta quantos itens tem no combo
      for x = 1 to nComboItemCount
         if alltrim(&(aCamposEdit[i])) == alltrim(getproperty("FrmEdita", "Combo_"+cFormAtivo+strzero(i,2,0), "item", x))
            setproperty("FrmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"Value", x)
            exit
         endif
      next x
      if x > nComboItemCount
         setproperty("FrmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"Value", 1)
      endif 
   elseif aCamposTip[i,1] = "LSTBOXDUO"
      domethod("FrmEdita","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"deleteallitems")
      domethod("FrmEdita","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"deleteallitems")

      //preenche ListboxDuo1
      nNroRecord:=&(aList[1])->(recno()) //guarda o número do registro, pois pode estar pegando os codigos no mesmo banco de dado sendo manipulado, alterando a posição do ponteiro

      &(aList[1])->(dbgotop())
      do while !&(aList[1])->(eof())
         if eval(aList[3])
            domethod("FrmEdita","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"additem",eval(aList[4]))
         endif 
         &(aList[1])->(dbskip(1))
      enddo

      &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro  para operacoes com o mesmo banco de dado para os dois listboxDuo

      //preenche listboxDuo2 (se houver registros selecionados para ele)
      for n_for = 1 to len(&(aCamposEdit[i])) step 6  //step 6 é o tamanho de cada registro
         if empty(substr(&(aCamposEdit[i]),n_for,6))  //pega os codigos do campo até não ter mais (branco)
            exit
         endif
         &(aList[2])->(dbseek(cEmpresa+substr(&(aCamposEdit[i]),n_for,6)))
         domethod("FrmEdita","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"additem",eval(aList[4]))
         &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro para operacoes com o mesmo banco de dado para os dois listboxDuo
      next n_for
      &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro para operacoes com o mesmo banco de dado para os dois listboxDuo
   endif
      for x = 1 to len(aTabPrincipal[nNro,4]) //verifica se alguns campos chaves devem ser preenchidos automaticamente
         if upper(aTabPrincipal[nNro,4,x,2])=upper(aCamposEdit[i])
               setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
               if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
                  setproperty("FrmEdita","ButCon_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
                  setproperty("FrmEdita","Label_99"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
               endif
         endif
      next x

next i

//DoMethod("FrmEdita","Text_01","SETFOCUS") //posiciona a digitação no campo apropriado para o digitador (talvez dê erro se o text_01 não existir)
return

//---------------------------------------------------------------------------
Procedure DeletaGrid(nRecord)
//---------------------------------------------------------------------------
Local j
if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

dbgoto(val(nRecord))

nTabPage:=Getproperty("TabWindow","Tab_1","value")
if msgyesno("Confirma Deleção do item selecionado?")
   if !tentaAcesso(cAliasTab);return;endif
   DBDelete()   //o banco atual é o correto, não precisa colocar o alias
   dbunlock()
   for j = 1 to len(aExecutaAposExclusao) // executa as funções pós-operações descritas em funcoes
      Eval(aExecutaAposExclusao[j])
   next j    
   RefreshGrid(nTabPage-1)
endif
return

//---------------------------------------------------------------------------
Procedure LocalizaGrd(pAlias, nNroGrd)
//---------------------------------------------------------------------------
Local i, x, nQtdeItens, aitem, nValue
nQtdeItens:=Getproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "itemcount")
if empty(nQtdeItens)
   msginfo("Não há registros para processar.")
   return
endif
For x = 1 To nQtdeItens
   if empty(GetProperty("TabWindow","Txt_"+strzero(nNroGrd,2,0),"value"))
      msginfo("Texto de pesquisa em branco!")
      return
   endif
   aItem := Getproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "item", x)  
   nValue:=Getproperty("TabWindow","ComboPesq_"+strzero(nNroGrd,2,0),"value")
   If rtrim(aItem[nValue]) = rtrim(GetProperty("TabWindow","Txt_"+strzero(nNroGrd,2,0),"value"))
      Setproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "value", x)
      DoMethod("TabWindow","Grd_"+strzero(nNroGrd,2,0),"REFRESH")
      DoMethod("TabWindow","Grd_"+strzero(nNroGrd,2,0),"SETFOCUS")
      Exit
   EndIf
Next x
if x > nQtdeItens
   msginfo("Registro não encontrado.")
endif
return

//---------------------------------------------------------------------------
Function FinalizaEdit()
//---------------------------------------------------------------------------
cOperacao:=""
cFormAtivo:=cFormAnterior
(cAliasBrowse)->(dbgoto(nNumRecPri)) //volta ao registro original no browse caso tenha sido alterado pelos set relations neste módulo ou no módulo consulta.prg.
FrmMestreEdita.release
Return(.t.)

//eof




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
cAliasBrowse:=pAliasConsulta  //muda temporariamente cAliasBrowse, pois haverá um browse de consulta com banco de dados diferente do browse principal
if !lSomentePesquisa
   DeterminaCampos(pAliasConsulta,"CONSULTA")  //inicia todas as variaveis necessárias para manipular o banco de dados em pauta
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
         VALUE "EXPRESSÃO DE BUSCA: "+alltrim(indexkey())
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

nNumRecConsulta:=recno() //guarda o registro selecionado na consulta, pois, embora já tenha transferido para os campos de edicao, vai perder o foco do registro correto quando der o Determinacampos() logo abaixo. Isso foi necessário para transferir dados dos componentes ListBoxDuo, uma vez que eles pegam valores de acordo com o BD vigente.

cOperacao:=cOperacaoAnterior

*DeterminaCampos(cAliasTab,if(cOperacao="INC","BROWSE","TAB"))  //volta ao ambiente do DB anterior (seja no Grid ou no Browse, pois a função consulta é chamada tanto pela edição do browse quanto do grid).
DeterminaCampos(cAliasTab,"TAB")  //volta ao ambiente do DB anterior (seja no Grid ou no Browse, pois a função consulta é chamada tanto pela edição do browse quanto do grid).

(pAliasConsulta)->(dbgoto(nNumRecConsulta)) //volta para o registro selecionado pelo operador na consulta

if !empty(aTransfExtra) //vamos transferir os dados automaticamente para alguns campos, se houver indicação para isso.
   for i = 1 to len(aTransfExtra) //esta rotina estava junto com a procedure TransfereRegistro(), e estava funcionando bem com os campos texto. Mas para o ListBoxduo, somente após voltar o DeterminaCampos do BD original é que a transferencia funciona.
      if aTransfExtra[i,1]="LISTBOXDUO"
         PreencheListBoxDuo(aTransfExtra[i,2], "CONSULTA")  //indica que é "CONSULTA", pois senão os ListboxDuos ficam desabilitados
      else
         setproperty(cFormAtivo, aTransfExtra[i,1],"Value", &(aTransfExtra[i,2])) //aqui são transferidos os campos Textos
      endif   
   next i
endif
cAliasBrowse:=cAliasBrowseAnterior

(cAliasBrowse)->(dbgoto(nNumRecPri)) //volta ao registro inicial no Browse. Esta cláusula é válida quando a consulta é chamada pela edição do grid, pois normalmente o browse perde o foco inicial. nNumRecPri é definida no módulo Mestre.Prg como sendo public.
dbgoto(nNumRecAnt)  //certifica-se que o recno do DB anterior no grid é o mesmo do início, no caso de alteração ou deleção do registro no grid. Esta cláusula deve vir sempre depois de voltar ao registro no browse principal 

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
