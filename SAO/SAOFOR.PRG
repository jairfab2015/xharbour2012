********************************************************************************
/* Programa.: SAOFOR.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Fornecedores.             */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Matfor(modo)
/* Gerenciador de Forne
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("FORNECEDOR","INCLUSŽO")
ELSEIF modo=2
   Sinal("FORNECEDOR","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("FORNECEDOR","EXCLUSŽO")
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 1
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1, SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPXF.DBF")
   SELECT 2
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3
   SET ORDER TO 2
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
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
   vrazao:=SPACE(50)
   vende :=SPACE(50)
   vmuni :=SPACE(20)
   vesta :=SPACE(2)
   vcep  :=SPACE(8)
   vcont :=SPACE(50)
   vddd  :=SPACE(4)
   vtelf :=SPACE(20)
   vtelx :=SPACE(7)
   vfax  :=SPACE(8)
   vrep  :=SPACE(50)
   vdddr :=SPACE(4)
   vtelfr:=SPACE(20)
   vtelxr:=SPACE(7)
   vfaxr :=SPACE(8)
   vdata :=CTOD(SPACE(8))
   vinsc :=SPACE(15)
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 5,11 GET vcodi PICTURE "99999"
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
      // Apresenta uma tabela de consulta para o fornecedor.
      vcodi:=Acha(vcodi,"Forne",1,2,"codi","nome","99999","@!",15,15,22,76)
   ENDIF
   IF EMPTY(vcodi)
      LOOP
   ENDIF
   SELECT Forne
   SEEK vcodi
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Fornecedor N„o Encontrado !",8,1)
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
         Aviso(24,"Digite os Dados do Fornecedor")
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
         Forne->codi:=vcodi
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza()
   ELSE
      IF Exclui()
         SELECT Pxf
         SEEK vcodi
         IF FOUND()
            Mensagem("Este fornecedor n„o pode ser exclu¡do pois possui produtos!",8,1)
            SELECT Forne
         ELSE
            SELECT Forne
            // Deleta o registro do arquivo.
            DELETE
         ENDIF
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
@  5, 3 SAY "C¢digo: "
@  5,19 SAY "Nome: "
@  5,47 SAY "CGC/CPF: "
@  7, 3 SAY "Raz„o Social________: "
@ 09, 3 SAY "Endere‡o____________: "
@ 11, 3 SAY "Munic¡pio___________: "
@ 11,49 SAY "Estado: "
@ 11,62 SAY "CEP: "
@ 13, 3 SAY "Pessoa para Contato_: "
@ 15, 3 SAY "DDD: "
@ 15,15 SAY "Telefone: "
@ 15,46 SAY "Telex: "
@ 15,62 SAY "Fax: "
@ 17, 3 SAY "Representante_______: "
@ 19, 3 SAY "DDD: "
@ 19,15 SAY "Telefone: "
@ 19,46 SAY "Telex: "
@ 19,62 SAY "Fax: "
@ 21, 3 SAY "Data de atualiza‡„o: "
@ 21,41 SAY "Inscri‡„o Estadual:"
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  5,11 SAY vcodi       PICTURE "99999"
@  5,25 SAY vnome       PICTURE "@!"
@  5,56 SAY vcgc        PICTURE "@!"
@  7,25 SAY vrazao      PICTURE "@!"
@ 09,25 SAY vende       PICTURE "@!"
@ 11,25 SAY vmuni       PICTURE "@!"
@ 11,57 SAY vesta       PICTURE "@!"
@ 11,67 SAY vcep        PICTURE "99999999"
@ 13,25 SAY vcont       PICTURE "@!"
@ 15, 8 SAY vddd        PICTURE "9999"
@ 15,25 SAY vtelf       PICTURE "@!"
@ 15,53 SAY vtelx       PICTURE "9999999"
@ 15,67 SAY vfax        PICTURE "999-9999"
@ 17,25 SAY vrep        PICTURE "@!"
@ 19, 8 SAY vdddr       PICTURE "9999"
@ 19,25 SAY vtelfr      PICTURE "@!"
@ 19,53 SAY vtelxr      PICTURE "9999999"
@ 19,67 SAY vfaxr       PICTURE "999-9999"
@ 21,25 SAY vdata
@ 21,60 SAY vinsc       PICTURE "@!"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@  5,11 SAY vcodi       PICTURE "99999"
SETCOLOR(vcn)
@  5,25 GET vnome       PICTURE "@!"
@  5,56 GET vcgc        PICTURE "999.999.999/0009-99"
@  7,25 GET vrazao      PICTURE "@!"
@ 09,25 GET vende       PICTURE "@!"
@ 11,25 GET vmuni       PICTURE "@!"
@ 11,57 GET vesta       PICTURE "@!"
@ 11,67 GET vcep        PICTURE "99999999"
@ 13,25 GET vcont       PICTURE "@!"
@ 15, 8 GET vddd        PICTURE "9999"
@ 15,25 GET vtelf       PICTURE "@!"
@ 15,53 GET vtelx       PICTURE "9999999"
@ 15,67 GET vfax        PICTURE "999-9999"
@ 17,25 GET vrep        PICTURE "@!"
@ 19, 8 GET vdddr       PICTURE "9999"
@ 19,25 GET vtelfr      PICTURE "@!"
@ 19,53 GET vtelxr      PICTURE "9999999"
@ 19,67 GET vfaxr       PICTURE "999-9999"
@ 21,25 GET vdata
@ 21,60 GET vinsc       PICTURE "@!"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vnome :=Forne->nome
vcgc  :=Forne->cgc
vrazao:=Forne->razao
vende :=Forne->ende
vmuni :=Forne->muni
vesta :=Forne->esta
vcep  :=Forne->cep
vcont :=Forne->cont
vddd  :=Forne->ddd
vtelf :=Forne->telf
vtelx :=Forne->telx
vfax  :=Forne->fax
vrep  :=Forne->rep 
vdddr :=Forne->dddr
vtelfr:=Forne->telfr
vtelxr:=Forne->telxr
vfaxr :=Forne->faxr
vdata :=Forne->data
vinsc :=Forne->insc
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Forne->nome :=vnome
Forne->cgc  :=vcgc
Forne->razao:=vrazao
Forne->ende :=vende
Forne->muni :=vmuni
Forne->esta :=vesta
Forne->cep  :=vcep
Forne->cont :=vcont
Forne->ddd  :=vddd
Forne->telf :=vtelf
Forne->telx :=vtelx
Forne->fax  :=vfax
Forne->rep  :=vrep
Forne->dddr :=vdddr
Forne->telfr:=vtelfr
Forne->telxr:=vtelxr
Forne->faxr :=vfaxr
Forne->data :=vdata
Forne->insc :=vinsc
RETURN
********************************************************************************
PROCEDURE Consfor()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("FORNECEDOR","CONSULTA")
IF FILE("SAOFOR.DBF")
   SELECT 1
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1, SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[20],vmask[20],vcabe[20],vedit[20]
// vdado: vetor dos nomes dos campos
vdado[01]:="codi"
vdado[02]:="nome"
vdado[03]:="razao"
vdado[04]:="cgc"
vdado[05]:="ende"
vdado[06]:="muni"
vdado[07]:="esta"
vdado[08]:="cep"
vdado[09]:="cont"
vdado[10]:="ddd"
vdado[11]:="telf"
vdado[12]:="telx"
vdado[13]:="fax"
vdado[14]:="rep"
vdado[15]:="dddr"
vdado[16]:="telfr"
vdado[17]:="telxr"
vdado[18]:="faxr"
vdado[19]:="data"
vdado[20]:="insc"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="99999"
vmask[02]:="@!"
vmask[03]:="!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
vmask[04]:="@!"
vmask[05]:="@!"
vmask[06]:="@!"
vmask[07]:="@!"
vmask[08]:="99999999"
vmask[09]:="@!"
vmask[10]:="9999"
vmask[11]:="@!"
vmask[12]:="9999999"
vmask[13]:="999-9999"
vmask[14]:="@!"
vmask[15]:="9999"
vmask[16]:="@!"
vmask[17]:="9999999"
vmask[18]:="999-9999"
vmask[19]:=""
vmask[20]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Raz„o Social"
vcabe[04]:="CGC/CPF"
vcabe[05]:="Endere‡o"
vcabe[06]:="Munic¡pio"
vcabe[07]:="Estado"
vcabe[08]:="CEP"
vcabe[09]:="Pessoa para Contato"
vcabe[10]:="DDD"
vcabe[11]:="Telefone"
vcabe[12]:="Telex"
vcabe[13]:="Fax"
vcabe[14]:="Representante"
vcabe[15]:="DDD"
vcabe[16]:="Telefone"
vcabe[17]:="Telex"
vcabe[18]:="Fax"
vcabe[19]:="Data"
vcabe[20]:="Inscri‡„o Estadual:"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Forne",03,01,22,78,vdado,vmask,vcabe,vedit,1,;
           "codi",1,"99999",5,"C¢digo",;
           "nome",2,"@!",40,"Fornecedor")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relforne(tipo,ordem)
/*
Objetivo  : emite os relat¢rios dos fornecedores.
Parƒmetros: tipo:  1 -> resumido
                   2 -> anal¡tico
            ordem: 1 -> c¢digo
                   2 -> nome
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("FORNECEDORES","RELATORIO")
IF FILE("SAOFOR.DBF")
   SELECT 1
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1, SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF ordem=1
   vcodi:=vcodf:=SPACE(5)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(5,"99999","C¢digos de Fornecedores")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Codigo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Fornecedores")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
IF !Imprime("Relat¢rio dos Fornecedores")
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
      Cabe(emp[2],vsist,"Relatorio Resumido dos Fornecedores",vtit,80,vcia10)
      @ PROW()+1,01 SAY "CODIGO      N O M E         T E L E F O N E S            C O N T A T O"
      @ PROW()+1,00 SAY REPLICATE("-",80)
   ELSEIF tipo=2
      // Cabecalho do Relat¢rio completo.
      Cabe(emp[2],vsist,"Relatorio Completo dos Produtos",vtit,80,vcia10)
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
         @ PROW()+1,01 SAY Forne->codi
         @ PROW(),  07 SAY Forne->nome
         @ PROW(),  28 SAY Forne->telf
         @ PROW(),  49 SAY LEFT(Forne->cont,32)
      ELSEIF tipo=2
         // Imprime os dados do relat¢rio completo.
         @ PROW()+1,3 SAY "Codigo: "+Forne->codi
         @ PROW(), 19 SAY "Nome: "+Forne->nome
         @ PROW(), 48 SAY "CGC/CPF: "+Forne->cgc
         @ PROW(), 11 SAY Forne->codi
         @ PROW(), 25 SAY Forne->nome
         @ PROW()+1,3 SAY "Razao Social________: "+Forne->razao
         @ PROW()+1,3 SAY "Endereco____________: "+Forne->ende
         @ PROW()+1,3 SAY "Municipio___________: "+Forne->muni
         @ PROW(), 49 SAY "Estado: "+Forne->esta
         @ PROW(), 62 SAY "CEP: "+Forne->cep
         @ PROW()+1,3 SAY "Pessoa para Contato_: "+Forne->cont
         @ PROW()+1,3 SAY "DDD: "+Forne->ddd
         @ PROW(), 14 SAY "Telefone: "+Forne->telf
         @ PROW(), 46 SAY "Telex: "+Forne->telx
         @ PROW(), 62 SAY "Fax: "+Forne->fax
         @ PROW()+1,3 SAY "Representante_______: "+Forne->rep 
         @ PROW()+1,3 SAY "DDD: "+Forne->dddr
         @ PROW(), 14 SAY "Telefone: "+Forne->telfr
         @ PROW(), 46 SAY "Telex: "+Forne->telxr
         @ PROW(), 62 SAY "Fax: "+Forne->faxr
         @ PROW()+1,3 SAY "Data de atualizacao: "+DTOC(Forne->data)
         @ PROW(), 41 SAY "Inscricao Estadual:"+Forne->insc
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
/*            
CODIGO      N O M E         T E L E F O N E S            C O N T A T O
99999 xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
*******************************************************************************
PROCEDURE Etiforne(ordem)
//  Emissao de Etiquetas dos Fornecedores
*******************************************************************************
LOCAL vlabel[ADIR("*.LBL")]
PRIVATE vcodi,vcodf
IF FILE("SAOFOR.DBF") .AND. FILE("SAOFOR1.NTX") .AND. FILE("SAOFOR2.NTX")
   SELECT 1
   USE SAOFOR INDEX SAOFOR1,SAOFOR2 ALIAS Forne EXCLUSIVE
ELSE
   Mensagem("O Arquivo dos Fornecedores N„o Est  Disponivel !",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
Sinal("FORNECEDORES","ETIQUETAS")
IF ordem=1
   vcodi:=vcodf:=SPACE(5)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(5,"99999","C¢digos de Fornecedores")
   bcond:={|vcod,vnome| vcod<=vcodf}
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Fornecedores")
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
IF !Imprime("Etiquetas de Fornecedores, formul rio: "+veti)
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
