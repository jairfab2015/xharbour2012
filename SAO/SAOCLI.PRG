********************************************************************************
/* Programa.: SAOCLI.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Clientes.                   */
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matcli(modo)
/* Gerenciador de CLIENTES
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("CLIENTES","INCLUSŽO")
ELSEIF modo=2
   Sinal("CLIENTES","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("CLIENTES","EXCLUSŽO")
ENDIF
IF FILE("SAOCLI.DBF")
   SELECT 1
   USE SAOCLI ALIAS Cli
   IF !FILE("SAOCLI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCLI1.NTX, SAOCLI2.NTX
ELSE
   Mensagem("Arquivo de Clientes N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vcodi :=SPACE(5)
   vnome :=SPACE(20)
   vcgc  :=SPACE(19)
   vrazao:=vende:=SPACE(50)
   vmuni :=SPACE(20)
   vesta :=SPACE(2)
   vcep  :=SPACE(8)
   vddd  :=SPACE(4)
   vtelf :=SPACE(20)
   vtelx :=SPACE(7)
   vfax  :=SPACE(8)
   vcont :=SPACE(50)
   vinsc :=SPACE(15)
   vrep :=SPACE(3)
   vdata:=CTOD(SPACE(8))
   vcfin:=vcven:=SPACE(2)
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 6,12 GET vcodi PICTURE "99999"
   Aviso(24,"Digite o C¢digo, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      CLOSE DATABASE
      RETURN
   ENDIF
   IF !EMPTY(vcodi)
      vcodi:=Zeracod(vcodi)
   ENDIF
   IF modo#1
      // Apresenta uma tabela de consulta para o cliente.
      vcodi:=Acha(vcodi,"Cli",1,2,"codi","nome","99999","@!",15,15,22,76)
   ENDIF
   IF EMPTY(vcodi)
      LOOP
   ENDIF
   SELECT Cli
   SEEK vcodi
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Cliente N„o Encontrado !",8,1)
         LOOP
      ENDIF
   ELSE
      // Transfere os dados do registro para as vari veis auxiliares.
      Transfere()
   ENDIF
   // Mostra os dados do registro.
   Mostra()
   SETCOLOR(vcn)
   IF modo=1 .OR. modo=2
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados do Cliente")
         SETCOLOR(vcn)
         // Edita os Dados do Registro
         Edita()
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      IF modo=1 .AND. !FOUND()
         // Inclui um novo registro no arquivo.
         APPEND BLANK
         Cli->Codi:=vcodi
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza()
   ELSE
      IF Exclui()
         // Deleta o registro do arquivo.
         DELETE
      ENDIF
   ENDIF
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Titulos()
// Apresenta os t¡tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@ 06,04 SAY "C¢digo: "
@ 06,20 SAY "Nome: "
@ 06,48 SAY "CGC/CPF: "
@ 08,04 SAY "Raz„o Social________: "
@ 10,04 SAY "Endere‡o____________: "
@ 12,04 SAY "Munic¡pio___________: "
@ 12,50 SAY "Estado: "
@ 12,63 SAY "CEP: "
@ 14,04 SAY "DDD: "
@ 14,16 SAY "Telefone: "
@ 14,47 SAY "Telex: "
@ 14,63 SAY "Fax: "
@ 16,04 SAY "Nome para Contato___: "
@ 18,04 SAY "Inscri‡„o Estadual__: "
@ 18,51 SAY "C¢digo do Vendedor__: "
@ 20,04 SAY "Data: "
@ 20,20 SAY "Classifica‡„o Financeira: "
@ 20,50 SAY "Classifica‡„o de Venda: "
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@ 06,12 SAY vcodi   PICTURE "99999"
@ 06,26 SAY vnome   PICTURE "@!"
@ 06,57 SAY vcgc    PICTURE "@!"
@ 08,26 SAY vrazao  PICTURE "@!"
@ 10,26 SAY vende   PICTURE "@!"
@ 12,26 SAY vmuni   PICTURE "@!"
@ 12,58 SAY vesta   PICTURE "@!"
@ 12,68 SAY vcep    PICTURE "99999999"
@ 14,09 SAY vddd     PICTURE "9999"
@ 14,26 SAY vtelf   PICTURE "@!"
@ 14,54 SAY vtelx   PICTURE "9999999"
@ 14,68 SAY vfax    PICTURE "999-9999"
@ 16,26 SAY vcont   PICTURE "@!"
@ 18,26 SAY vinsc   PICTURE "@!"
@ 18,73 SAY vrep    PICTURE "999"
@ 20,10 SAY vdata   PICTURE "99/99/99"
@ 20,46 SAY vcfin   PICTURE "99"
@ 20,74 SAY vcven   PICTURE "99"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@ 06,12 SAY vcodi PICTURE "99999"
SETCOLOR(vcn)
@ 06,26 GET vnome  PICTURE "@!"
@ 06,57 GET vcgc   PICTURE "@!"
@ 08,26 GET vrazao PICTURE "@!"
@ 10,26 GET vende  PICTURE "@!"
@ 12,26 GET vmuni  PICTURE "@!"
@ 12,58 GET vesta  PICTURE "@!"
@ 12,68 GET vcep   PICTURE "99999999"
@ 14,09 GET vddd   PICTURE "9999"
@ 14,26 GET vtelf  PICTURE "@!"
@ 14,54 GET vtelx  PICTURE "9999999"
@ 14,68 GET vfax   PICTURE "999-9999"
@ 16,26 GET vcont  PICTURE "@!"
@ 18,26 GET vinsc  PICTURE "@!"
@ 18,73 GET vrep   PICTURE "999"
@ 20,10 GET vdata  PICTURE "99/99/99"
@ 20,46 GET vcfin  PICTURE "99"
@ 20,74 GET vcven  PICTURE "99"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vcodi :=Cli->codi
vnome :=Cli->nome
vcgc  :=Cli->cgc
vrazao:=Cli->razao
vende :=Cli->ende
vmuni :=Cli->muni
vesta :=Cli->esta
vcep  :=Cli->cep
vddd  :=Cli->ddd
vtelf :=Cli->telf
vtelx :=Cli->telx
vfax  :=Cli->fax
vcont :=Cli->cont
vinsc :=Cli->insc
vrep  :=Cli->rep
vdata :=Cli->data
vcfin :=Cli->cfin
vcven :=Cli->cven
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Cli->nome :=vnome
Cli->cgc  :=vcgc
Cli->razao:=vrazao
Cli->ende :=vende
Cli->muni :=vmuni
Cli->esta :=vesta
Cli->cep  :=vcep
Cli->ddd  :=vddd
Cli->telf :=vtelf
Cli->telx :=vtelx
Cli->fax  :=vfax
Cli->cont :=vcont
Cli->insc :=vinsc
Cli->rep  :=vrep
Cli->data :=vdata
Cli->cfin :=vcfin
Cli->cven :=vcven
RETURN
********************************************************************************
PROCEDURE Conscli()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("CONSULTA","CLIENTES")
IF FILE("SAOCLI.DBF")
   SELECT 1
   USE SAOCLI ALIAS Cli
   IF !FILE("SAOCLI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCLI1, SAOCLI2
ELSE
   Mensagem("Arquivo de Clientes N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[18],vmask[18],vcabe[18],vedit[18]
// vdado: vetor dos nomes dos campos
vdado[01]:="codi"
vdado[02]:="nome"
vdado[03]:="cgc"
vdado[04]:="razao"
vdado[05]:="ende"
vdado[06]:="muni"
vdado[07]:="esta"
vdado[08]:="cep"
vdado[09]:="ddd"
vdado[10]:="telf"
vdado[11]:="telx"
vdado[12]:="fax"
vdado[13]:="cont"
vdado[14]:="insc"
vdado[15]:="rep"
vdado[16]:="data"
vdado[17]:="cfin"
vdado[18]:="cven"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="99999"
vmask[02]:="@!"
vmask[03]:="@!"
vmask[04]:="@!"
vmask[05]:="@!"
vmask[06]:="@!"
vmask[07]:="@!"
vmask[08]:="99999999"
vmask[09]:="9999"
vmask[10]:="@!"
vmask[11]:="9999999"
vmask[12]:="999-9999"
vmask[13]:="@!"
vmask[14]:="@!"
vmask[15]:="999"
vmask[16]:="99/99/99"
vmask[17]:="99"
vmask[18]:="99"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="CGC/CPF"
vcabe[04]:="Raz„o Social"
vcabe[05]:="Endere‡o"
vcabe[06]:="Munic¡pio"
vcabe[07]:="Estado"
vcabe[08]:="CEP"
vcabe[09]:="DDD"
vcabe[10]:="Telefone"
vcabe[11]:="Telex"
vcabe[12]:="Fax"
vcabe[13]:="Nome para Contato"
vcabe[14]:="Inscri‡„o Estadual"
vcabe[15]:="Vendedor"
vcabe[16]:="Data"
vcabe[17]:="Class.Fin."
vcabe[18]:="Class.Venda."
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Cli",03,01,22,78,vdado,vmask,vcabe,vedit,1,;
           "codi",1,"99999",5,"C¢digo",;
           "nome",2,"@!",50,"Nome")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relcli(tipo,ordem)
/*
Objetivo  : emite os relat¢rios dos clientes.
Parƒmetros: tipo:  1 -> resumido
                   2 -> anal¡tico
            ordem: 1 -> c¢digo
                   2 -> nome
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("CLIENTES","RELATORIOS")
IF FILE("SAOCLI.DBF")
   SELECT 1
   USE SAOCLI ALIAS Cli
   IF !FILE("SAOCLI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCLI1, SAOCLI2
ELSE
   Mensagem("Arquivo de Clientes N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF ordem=1
   vcodi:=vcodf:=SPACE(5)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(5,"99999","C¢digos de Clientes")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Codigo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Clientes")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
IF !Imprime("Relat¢rio dos Clientes")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
//SET PRINTER TO SAOREL.TXT
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   IF tipo=1
      // Cabecalho do Relat¢rio resumido.
      Cabe(emp[2],vsist,"Relatorio Resumido dos Clientes",vtit,80,vcia10)
      @ PROW()+1,01 SAY "CODIGO      N O M E         T E L E F O N E S            C O N T A T O"
      @ PROW()+1,00 SAY REPLICATE("-",80)
   ELSEIF tipo=2
      // Cabecalho do Relat¢rio completo.
      Cabe(emp[2],vsist,"Relatorio Completo dos Clientes",vtit,80,vcia10)
   ENDIF
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF tipo=1
         // Imprime os dados do relat¢rio resumido.
         @ PROW()+1,01 SAY Cli->codi
         @ PROW(),  07 SAY Cli->nome
         @ PROW(),  28 SAY Cli->telf
         @ PROW(),  49 SAY LEFT(Cli->cont,32)
      ELSEIF tipo=2
         // Imprime os dados do relat¢rio completo.
         @ PROW()+1,3 SAY "Codigo: "+Cli->codi
         @ PROW(), 20 SAY "Nome: "+Cli->nome
         @ PROW(), 48 SAY "CGC/CPF: "+Cli->cgc
         @ PROW(), 11 SAY Cli->codi
         @ PROW(), 26 SAY Cli->nome
         @ PROW()+1,3 SAY "Razao Social________: "+Cli->razao
         @ PROW()+1,3 SAY "Endereco____________: "+Cli->ende
         @ PROW()+1,3 SAY "Municipio___________: "+Cli->muni
         @ PROW(), 57 SAY "Estado: "+Cli->esta
         @ PROW(), 63 SAY "CEP: "+Cli->cep
         @ PROW()+1,3 SAY "Pessoa para Contato_: "+Cli->cont
         @ PROW()+1,3 SAY "DDD: "+Cli->ddd
         @ PROW(), 14 SAY "Telefone: "+Cli->telf
         @ PROW(), 46 SAY "Telex: "+Cli->telx
         @ PROW(), 62 SAY "Fax: "+Cli->fax
         @ PROW()+1,3 SAY "Inscri‡„o Estadual_______: "+Cli->insc
         @ PROW(), 41 SAY "C¢digo do Represent.: "+Cli->rep
         @ PROW()+1,3 SAY "Data: "+DTOC(Cli->data)
         @ PROW(), 20 SAY "Classifica‡„o Financeira: "+Cli->cfin
         @ PROW(), 50 SAY "Classifica‡„o de Venda: "+Cli->cven
         @ PROW()+1,00 SAY REPLICATE("-",80)
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
*******************************************************************************
PROCEDURE Eticli(ordem)
//  Emissao de Etiquetas dos Clientes
*******************************************************************************
LOCAL vlabel[ADIR("*.LBL")]
PRIVATE vcodi,vcodf
IF FILE("SAOCLI.DBF") .AND. FILE("SAOCLI1.NTX") .AND. FILE("SAOCLI2.NTX")
   SELECT 1
   USE SAOCLI INDEX SAOCLI1,SAOCLI2 ALIAS Cli EXCLUSIVE
ELSE
   Mensagem("O Arquivo dos Clientes N„o Est  Disponivel !",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
Sinal("CLIENTES","ETIQUETAS")
IF ordem=1
   vcodi:=vcodf:=SPACE(5)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(5,"99999","C¢digos de Clientes")
   bcond:={|vcod,vnome| vcod<=vcodf}
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Clientes")
   bcond:={|vcod,vnome| vnome<=vcodf}
ENDIF
Abrejan(2)
tk=0
Aviso (8,"Escolha o Formul rio de Etiquetas Desejado")
Aviso (24,"[Enter] Seleciona    [Esc] Cancela")
ADIR("*.LBL",vlabel)
vlabel:=ASORT(vlabel)
@ 11,32 CLEAR TO 21,46
@ 11,32,21,46 BOX frame[1]
vop:=ACHOICE(12,33,20,45,vlabel)
IF vop=0
   CLOSE DATABASE
   RETURN
ENDIF
veti=ALLTRIM(vlabel[vop])
IF !Imprime("Etiquetas de Clientes, formul rio: "+veti)
   CLOSE DATABASE
   RETURN
ENDIF
FOR i:= 1 TO vcop
    SET SOFTSEEK ON
    SEEK vcodi
    SET SOFTSEEK OFF
    LABEL FORM &veti WHILE EVAL(bcond,codi,nome) .AND. Esceti() TO PRINTER
    SET CONSOLE OFF
    IF LASTKEY()=K_ESC
       EXIT
    ENDIF
NEXT
CLOSE DATABASE
RETURN
********************************************************************************
//                                    F i m
********************************************************************************
