********************************************************************************
/* Programa.: SAOCTB.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro de Contas Banc rias.            */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Matctb(modo)
/* Gerenciador de CTA.CORRENTE
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("CTA.CORRENTE","INCLUSŽO")
ELSEIF modo=2
   Sinal("CTA.CORRENTE","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("CTA.CORRENTE","EXCLUSŽO")
ENDIF
IF FILE("SAOCTB.DBF")
   SELECT 1
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1,SAOCTB2
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOBAN.DBF")
   SELECT 2
   USE SAOBAN ALIAS Tban
   IF !FILE("SAOBAN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOBAN1,SAOBAN2
ELSE
   Mensagem("Tabela de Bancos N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ctb
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vbanco :=SPACE(3)
   vagenc :=SPACE(5)
   vconta :=SPACE(10)
   vnomeag:=vnome:=vcont:=SPACE(40)
   vtelf  :=SPACE(20)
   vdata  :=CTOD(SPACE(8))
   vsaldo :=0
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 8,14 GET vbanco PICTURE "999"
   Aviso(24,"Digite o N§ do Banco, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   vbanco:=Acha(vbanco,"Tban",1,2,"codi","nome","999","@!",15,15,22,75)
   SETCOLOR(vcr)
   @ 8,14 SAY vbanco PICTURE "999"
   SETCOLOR(vcn)
   @ 8,34 GET vagenc PICTURE "99999"
   @ 8,62 GET vconta PICTURE "@!"
   Aviso(24,"Digite o N§ da Agˆncia e o N§ da Conta, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC .OR. EMPTY(vbanco) .OR. EMPTY(vagenc) .OR. EMPTY(vconta)
      EXIT
   ENDIF
   SEEK vbanco+vagenc+vconta
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Conta N„o Encontrada !",8,1)
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
         Aviso(24,"Digite os Dados da Conta")
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
         Ctb->banco:=vbanco
         Ctb->agenc:=vagenc
         Ctb->conta:=vconta
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
@ 08,07 SAY "Banco: "
@ 08,22 SAY "Agˆncia N§: "
@ 08,43 SAY "Conta Corrente N§: "
@ 10,07 SAY "Nome da Agˆncia________: "
@ 12,07 SAY "Nome do Correntista____: " 
@ 14,07 SAY "Contato / Gerente______: "
@ 16,07 SAY "Telefone: "
@ 16,38 SAY "Data: "
@ 16,53 SAY "Saldo: "
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@ 08,14 SAY vbanco  PICTURE "999"
@ 08,34 SAY vagenc  PICTURE "99999"
@ 08,62 SAY vconta  PICTURE "@!"
@ 10,32 SAY vnomeag PICTURE "@!"
@ 12,32 SAY vnome   PICTURE "@!"
@ 14,32 SAY vcont   PICTURE "@!"
@ 16,17 SAY vtelf   PICTURE "@!"
@ 16,44 SAY vdata
@ 16,60 SAY vsaldo  PICTURE "@E 9,999,999.99"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@ 08,14 SAY vbanco PICTURE "999"
@ 08,34 SAY vagenc PICTURE "99999"
@ 08,62 SAY vconta PICTURE "@!"
@ 16,60 SAY vsaldo PICTURE "@E 9,999,999.99"
SETCOLOR(vcn)
@ 10,32 GET vnomeag PICTURE "@!"
@ 12,32 GET vnome   PICTURE "@!"
@ 14,32 GET vcont   PICTURE "@!"
@ 16,17 GET vtelf   PICTURE "@!"
@ 16,44 GET vdata
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vbanco :=Ctb->banco
vagenc :=Ctb->agenc
vconta :=Ctb->conta
vnome  :=Ctb->nome
vnomeag:=Ctb->nomeag
vcont  :=Ctb->cont
vtelf  :=Ctb->telf
vdata  :=Ctb->data
vsaldo :=FIELDGET(MONTH(saomes)+9)
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Ctb->agenc :=vagenc
Ctb->conta :=vconta
Ctb->nome  :=vnome
Ctb->nomeag:=vnomeag
Ctb->cont  :=vcont
Ctb->telf  :=vtelf
Ctb->data  :=vdata
RETURN
********************************************************************************
PROCEDURE Consctb()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("CTA.CORRENTE","CONSULTA")
IF FILE("SAOCTB.DBF")
   SELECT 1
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1,SAOCTB2
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[20],vmask[20],vcabe[20],vedit[20]
// vdado: vetor dos nomes dos campos
vdado[1]:="banco"
vdado[2]:="agenc"
vdado[3]:="conta"
vdado[4]:="nome"
vdado[5]:="cont"
vdado[6]:="telf"
vdado[7]:="data"
vdado[8]:="saldo"
FOR i=1 TO 12
    vdado[i+8]:="mes"+STRZERO(i,2)
NEXT
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[1]:="999"
vmask[2]:="99999"
vmask[3]:="@!"
vmask[4]:="@!"
vmask[5]:="@!"
vmask[6]:="@!"
vmask[8]:="@E 999,999,999.99"
FOR i=1 TO 12
    vmask[i+8]:="@E 999,999,999.99"
NEXT
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[1]:="Banco"
vcabe[2]:="Agˆncia"
vcabe[3]:="N§ C/C"
vcabe[4]:="Correntista"
vcabe[5]:="Contato / Gerente"
vcabe[6]:="Telefone"
vcabe[7]:="Data"
vcabe[8]:="Saldo Atual"
FOR i=1 TO 12
    vcabe[i+8]:="  "+Dpc(CTOD("01/"+STRZERO(i,2)+"/"+STR(YEAR(saomes),4)))
NEXT
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
vedit[4]:=.T.
vedit[5]:=.T.
vedit[6]:=.T.
vedit[7]:=.T.
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Ctb",03,01,22,78,vdado,vmask,vcabe,vedit,3,;
          "banco",1,"999",3,"Banco",;
          "nome",2,"@!",40,"Correntista")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Conscc()
// Consultas ao Saldo Atual das Contas Correntes.
********************************************************************************
Sinal("CTA.CORRENTE","CONSULTA")
IF FILE("SAOCTB.DBF")
   SELECT 1
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1,SAOCTB2
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[5],vmask[5],vcabe[5],vedit[5]
// vdado: vetor dos nomes dos campos
vdado[1]:="banco"
vdado[2]:="agenc"
vdado[3]:="conta"
vdado[4]:="saldo"
vdado[5]:="LEFT(nome,30)"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[1]:="999"
vmask[2]:="99999"
vmask[3]:="@!"
vmask[4]:="@E 999,999,999.99"
vmask[5]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[1]:="Banco"
vcabe[2]:="Agˆncia"
vcabe[3]:="N£mero C/C"
vcabe[4]:="Saldo Atual"
vcabe[5]:="Correntista"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Ctb",03,01,22,78,vdado,vmask,vcabe,vedit,3,;
          "banco",1,"999",3,"Banco",;
          "nome",2,"@!",40,"Correntista")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relctb(ordem)
/*
Objetivo : emite os relat¢rios das contas bancarias.
Parƒmetro: ordem: 1 -> por conta.
                  2 -> por correntista.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("CTA.BANCARIA","RELATORIO")
IF FILE("SAOCTB.DBF")
   SELECT 1
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1, SAOCTB2
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOBAN.DBF")
   SELECT 2
   USE SAOBAN ALIAS Tban
   IF !FILE("SAOBAN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOBAN1,SAOBAN2
ELSE
   Mensagem("Tabela de Bancos N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ctb
SET RELATION TO banco INTO Tban
IF ordem=1
   vcodi:=vcodf:=SPACE(3)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(3,"999","N§ de Bancos")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Banco"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Correntistas")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Correntista"
ENDIF
IF !Imprime("Relat¢rio das Contas Banc rias")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
//SET PRINTER TO SAOREL.TXT
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,banco,nome)
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio das Contas Bancarias",vtit,80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,banco,nome)
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      @ PROW()+1,11 SAY "Banco__: "+Ctb->banco
      @ PROW(),  29 SAY Tban->nome
      @ PROW()+1,11 SAY "Agencia: "+Ctb->agenc
      @ PROW(),  29 SAY Ctb->nomeag
      @ PROW()+1,11 SAY "Contato/Gerente_: "+Ctb->cont
      @ PROW()+1,11 SAY "Conta: "+Ctb->conta
      @ PROW(),  29 SAY Ctb->nome
      @ PROW()+1,11 SAY "Telefones: "+Ctb->telf
      @ PROW(),  55 SAY "Data: "+DTOC(Ctb->data)
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
********************************************************************************
//                                    F i m
********************************************************************************
