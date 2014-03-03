********************************************************************************
/* Programa.: SAOCP.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento de Contas a Pagar.         */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Matcp(modo,tipo)
/* Gerenciador de CTA A PAGAR
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o
               tipo - tipo de opera‡„o          1 - Compras
                                                2 - Outras */
********************************************************************************
IF modo=1
   Sinal("CTA A PAGAR","INCLUSŽO")
ELSEIF modo=2
   Sinal("CTA A PAGAR","EXCLU€ŽO")
ELSEIF modo=3
   Sinal("CTA A PAGAR","BAIXA")
ENDIF
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
   IF !FILE("SAOCP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCP1,SAOCP2,SAOCP3,SAOCP4
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOM.DBF")
   SELECT 2
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM1,SAOCOM2
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 3
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1,SAOOPE2
ELSE
   Mensagem("Tabela de Opera‡”es N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOBAN.DBF")
   SELECT 4
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
IF FILE("SAOMBA.DBF")
   SELECT 5
   USE SAOMBA ALIAS Mba
   IF !FILE("SAOMBA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOMBA1,SAOMBA2
ELSE
   Mensagem("Arquivo do Movimento Banc rio N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCTB.DBF")
   SELECT 6
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1,SAOCTB2
ELSE
   Mensagem("Arquivo das Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPG.DBF")
   SELECT 7
   USE SAOTPG ALIAS Tpg
   IF !FILE("SAOTPG1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPG1,SAOTPG2
ELSE
   Mensagem("Arquivo dos Tipos de Pagamento N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Cp
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos(modo,tipo)
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vdocto:=SPACE(10)
   vtipg :=SPACE(3)
   vbanc1:=SPACE(3)
   vnupd :=SPACE(5)
   vemis :=CTOD(SPACE(8))
   vopera:=SPACE(6)
   vnope :=SPACE(40)
   vnome :=SPACE(40)
   vvenc :=CTOD(SPACE(8))
   vvalor:=vTaxa:=0
   vdatpg:=CTOD(SPACE(8))
   vvalpg:=0
   vbanc2:=SPACE(3)
   vagenc:=SPACE(5)
   vconta:=vcheque:=SPACE(10)
   vobs  :=SPACE(40)
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra(modo,tipo)
   @ 4,21 GET vdocto PICTURE "9999999999"
   Aviso(24,"Digite o N§ do Documento, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC .OR. EMPTY(vDocto)
      CLOSE DATABASE
      RETURN
   ENDIF
   vdocto:=Zeracod(vdocto)
   SELECT Cp
   SEEK vdocto
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Documento N„o Encontrado !",8,1)
         LOOP
      ENDIF
   ELSE
      IF tipo=2 .AND. !EMPTY(Cp->nupd)
         tipo=1
      ELSEIF tipo=1 .AND. EMPTY(Cp->nupd)
         tipo=2
      ENDIF
      // Apresenta os t¡tulos na tela
      Titulos(modo,tipo)
      // Transfere os dados do registro para as vari veis auxiliares.
      Transfere(modo,tipo)
   ENDIF
   SELECT Cp
   // Mostra os dados do registro.
   Mostra(modo,tipo)
   SETCOLOR(vcn)
   IF modo=1
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados do Documento")
         SETCOLOR(vcn)
         // Edita os Dados do Registro
         Edita(modo,tipo)
         IF EMPTY(vnupd) .AND. tipo=1
            EXIT
         ENDIF
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      IF !FOUND()
         // Inclui um novo registro no arquivo.
         APPEND BLANK
         Cp->Docto:=vDocto
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza(modo,tipo)
   ELSEIF modo=2
      IF Exclui()
         // Deleta o registro do arquivo.
         DELETE
         SELECT Mba
         SEEK vdocto
         IF FOUND()
            // Exclui o registro no arquivo de Movimento Banc rio.
            vvalor:=Mba->valor
            vbanco:=Mba->banco
            vagenc:=Mba->agenc
            vconta:=Mba->conta
            vdata :=Mba->data
            vmes  :="mes"+STRZERO(MONTH(vdata),2)
            DELETE
            SELECT Ctb
            SEEK vbanco+vagenc+vconta
            Ctb->&vmes:=Ctb->&vmes+vvalor  // No mˆs.
            Ctb->saldo:=Ctb->saldo+vvalor  // Atual.
         ENDIF
         SELECT Cp
      ENDIF
   ELSEIF modo=3
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados do Pagamento")
         SETCOLOR(vcn)
         // Edita os Dados do Registro
         Edita(modo,tipo)
         IF EMPTY(vnupd) .AND. tipo=1
            EXIT
         ENDIF
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      SELECT Cp
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza(modo,tipo)
      SELECT Mba
      SEEK vdocto
      IF !FOUND()
         // Inclui um novo registro no arquivo de movimento banc rio.
         APPEND BLANK
         Mba->Docto:=vDocto
      ENDIF
      // Atualiza o registro do Movimento Banc rio.
      Mba->debcre:=.F.
      Mba->data  :=vdatpg
      Mba->banco :=vbanc2
      Mba->agenc :=vagenc
      Mba->conta :=vconta
      Mba->opera :=vopera
      Mba->desc  :=vobs
      Mba->valor :=vvalpg
      // Atualiza o Saldo da Conta Banc ria.
      vmes:="mes"+STRZERO(MONTH(vdatpg),2)
      SELECT Ctb
      SEEK vbanc2+vagenc+vconta
      Ctb->&vmes:=Ctb->&vmes-vvalpg  // No mˆs.
      Ctb->saldo:=Ctb->saldo-vvalpg  // Atual.
   ENDIF
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Titulos(modo,tipo)
// Apresenta os t¡tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@  4,10 SAY "Documento: "
@  4,34 SAY "Tipo do Pagto: "
@  4,54 SAY "N§ do Banco: "
IF tipo=1
   @  6,01 SAY SPACE(78)
   @  6,10 SAY "N§ do Pedido de Compra___:"
   @  6,45 SAY "Data da Emiss„o: "
   @ 10,10 SAY "Nome do Fornecedor: "
ELSE
   @  6,01 SAY REPLICATE("Ä",78)
   @ 10,10 SAY "Nome do Credor____: "
ENDIF
@  8,10 SAY "Opera‡„o_: "
@ 12,10 SAY "Data Vencimento: "
@ 12,36 SAY "Valor: "
@ 12,59 SAY "Taxa: "
IF modo=3
   @ 14,01 SAY REPLICATE("Ä",78)
   SETCOLOR(vci)
   @ 14,30 SAY " Dados do Pagamento "
   SETCOLOR(vcn)
   @ 16,10 SAY "Data do Pagamento: "
   @ 16,39 SAY "Valor Pago_____: "
   @ 18,10 SAY "Banco: "
   @ 18,21 SAY "Agˆncia: "
   @ 18,36 SAY "C/C: "
   @ 18,52 SAY "Cheque:"
   @ 20,10 SAY "Observa‡”es_______: "
ELSE
   @ 14,10 SAY "Observa‡”es_______: "
ENDIF
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(modo,tipo)
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  4,21 SAY vdocto  PICTURE "9999999999"
@  4,49 SAY vtipg   PICTURE "!!!"
@  4,67 SAY vbanc1  PICTURE "999"
IF tipo=1
   @  6,37 SAY vnupd   PICTURE "99999"
   @  6,62 SAY vemis   PICTURE "99/99/99"
ENDIF
@  8,21 SAY vopera  PICTURE "@R 9.99.999"
@  8,30 SAY vnope   PICTURE "@!"
@ 10,30 SAY vnome   PICTURE "@!"
@ 12,27 SAY vvenc   PICTURE "99/99/99"
@ 12,43 SAY vvalor  PICTURE "@E 999,999,999.99"
@ 12,65 SAY vtaxa   PICTURE "@E 99.99"
IF modo=3
   @ 16,29 SAY vdatpg  PICTURE "99/99/99"
   @ 16,56 SAY vvalpg  PICTURE "@E 999,999,999.99"
   @ 18,17 SAY vbanc2  PICTURE "999"
   @ 18,30 SAY vagenc  PICTURE "@!"
   @ 18,41 SAY vconta  PICTURE "@!"
   @ 18,60 SAY vcheque PICTURE "@!"
   @ 20,30 SAY vobs    PICTURE "@!"
ELSE
   @ 14,30 SAY vobs    PICTURE "@!"
ENDIF
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita(modo,tipo)
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@ 4,21 SAY vdocto PICTURE "9999999999"
SETCOLOR(vcn)
IF modo=1
   @  4,49 GET vtipg  PICTURE "!!!"
   Le()
   vtipg:=Acha(vtipg,"Tpg",1,2,"codi","nome","!!!","@!",15,15,22,76)
   SETCOLOR(vcr)
   @  4,49 SAY vtipg PICTURE "!!!"
   SETCOLOR(vcn)
   @  4,67 GET vbanc1 PICTURE "999"
   Le()
   vbanc1:=Acha(vbanc1,"Tban",1,2,"codi","nome","999","@!",15,15,22,76)
   SETCOLOR(vcr)
   @  4,67 SAY vbanc1 PICTURE "999"
   SETCOLOR(vcn)
   IF tipo=1
      @  6,37 GET vnupd PICTURE "99999"
      Le()
      IF EMPTY(vnupd)
         RETURN
      ENDIF
      vnupd:=Zeracod(vnupd)
      vnupd:=Acha(vnupd,"Com",1,2,"nupd","forne","99999","@!",15,10,22,76)
      IF EMPTY(vnupd)
         RETURN
      ENDIF
      SETCOLOR(vcr)
      @  6,37 SAY vnupd PICTURE "99999"
      SETCOLOR(vcn)
      vemis :=Com->data
      vvenc :=Com->venc
      vnome :=Com->forne
      vvalor:=Com->valor
      vopera:=Com->opera
      SELECT Ope
      SEEK vopera
      vnope:=IF(FOUND(),LEFT(Ope->nome,40),PADR("N„o Determinada",40))
      SELECT Cp
      SETCOLOR(vcr)
      @  6,62 SAY vemis  PICTURE "99/99/99"
      @  8,21 SAY vopera PICTURE "@R 9.99.999"
      @  8,30 SAY vnope  PICTURE "@!"
      @ 10,30 SAY vnome  PICTURE "@!"
      @ 12,27 SAY vvenc  PICTURE "99/99/99"
      @ 12,43 SAY vvalor PICTURE "@E 999,999,999.99"
      SETCOLOR(vcn)
   ENDIF
   DO WHILE .T.
      @  8,21 GET vopera PICTURE "@R 9.99.999"
      Le()
      vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
      IF EMPTY(vopera)
         LOOP
      ENDIF
      vnope:=LEFT(Ope->nome,40)
      EXIT
   ENDDO
   SETCOLOR(vcr)
   @  8,21 SAY vopera PICTURE "@R 9.99.999"
   @  8,30 SAY vnope  PICTURE "@!"
   SETCOLOR(vcn)
   IF tipo=2
      @ 10,30 GET vnome  PICTURE "@!"
      Le()
   ENDIF
   @ 12,27 GET vvenc  PICTURE "99/99/99"
   @ 12,43 GET vvalor PICTURE "@E 999,999,999.99"
   @ 12,65 GET vtaxa  PICTURE "@E 99.99"
   @ 14,30 GET vobs   PICTURE "@!"
   Le()
ELSEIF modo=3
   @ 16,29 GET vdatpg  PICTURE "99/99/99" VALID !EMPTY(vdatpg)
   @ 16,56 GET vvalpg  PICTURE "@E 999,999,999.99"
   @ 18,41 GET vconta  PICTURE "@!"
   Le()
   vctb:=vbanc2+vagenc+vconta
   vctb:=Acha(vctb,"Ctb",1,2,"banco+agenc+conta","nome","@R 999 / !!!!! / !!!!!!!!!!","@!",;
              15,08,22,76,"Banco / Agˆncia / Conta"," Correntista")
   vbanc2:=LEFT(vctb,3)
   vagenc:=SUBSTR(vctb,4,5)
   vconta:=RIGHT(vctb,10)
   SETCOLOR(vcr)
   @ 18,17 SAY vbanc2  PICTURE "999"
   @ 18,30 SAY vagenc  PICTURE "@!"
   @ 18,41 SAY vconta  PICTURE "@!"
   SETCOLOR(vcn)
   @ 18,60 GET vcheque PICTURE "@!"
   @ 20,30 GET vobs    PICTURE "@!"
   Le()
ENDIF
RETURN
********************************************************************************
STATIC PROCEDURE Transfere(modo,tipo)
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vtipg  :=Cp->tipg 
vbanc1 :=Cp->banc1
IF tipo=1
   vnupd  :=Cp->nupd
   vemis  :=Cp->emis
ENDIF
vopera :=Cp->opera
SELECT Ope
SEEK vopera
vnope  :=LEFT(Ope->nome,40)
SELECT Cp
vnome  :=Cp->nome
vvenc  :=Cp->venc
vvalor :=Cp->valor
vtaxa  :=Cp->taxa
IF modo=3
   vdatpg :=Cp->datpg
   vvalpg :=Cp->valpg
   vbanc2 :=Cp->banc2 
   vagenc :=Cp->agenc
   vconta :=Cp->conta
   vcheque:=Cp->cheque
ENDIF
vobs   :=Cp->obs
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza(modo,tipo)
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Cp->tipg  :=vtipg 
Cp->banc1 :=vbanc1
IF tipo=1
   Cp->nupd  :=vnupd
   Cp->emis  :=vemis
ENDIF
Cp->opera :=vopera
Cp->nome  :=vnome
Cp->venc  :=vvenc
Cp->valor :=vvalor
Cp->taxa  :=vtaxa
IF modo=3
   Cp->datpg :=vdatpg
   Cp->valpg :=vvalpg
   Cp->banc2 :=vbanc2 
   Cp->agenc :=vagenc
   Cp->conta :=vconta
   Cp->cheque:=vcheque
ENDIF
Cp->obs:=vobs
RETURN
********************************************************************************
PROCEDURE Conscp()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("CTA A PAGAR","CONSULTA")
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
   IF !FILE("SAOCP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCP1,SAOCP2,SAOCP3,SAOCP4
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao DBEDIT().
PRIVATE vdado[15],vmask[15],vcabe[15]
// vdado: vetor dos nomes dos campos
vdado[01]:="venc"
vdado[02]:="valor"
vdado[03]:="taxa"
vdado[04]:="tipg"
vdado[05]:="banc1"
vdado[06]:="nupd"
vdado[07]:="emis"
vdado[08]:="opera"
vdado[09]:="datpg"
vdado[10]:="valpg"
vdado[11]:="banc2"
vdado[12]:="agenc"
vdado[13]:="conta"
vdado[14]:="cheque"
vdado[15]:="obs"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="99/99/99"
vmask[02]:="@E 999,999,999.99"
vmask[03]:="@E 99.99"
vmask[04]:="!!!"
vmask[05]:="999"
vmask[06]:="99999"
vmask[07]:="99/99/99"
vmask[08]:="@R 9.99.999"
vmask[09]:="99/99/99"
vmask[10]:="@E 999,999,999.99"
vmask[11]:="999"
vmask[12]:="@!"
vmask[13]:="@!"
vmask[14]:="@!"
vmask[15]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Vencimento"
vcabe[02]:="Valor"
vcabe[03]:="Taxa"
vcabe[04]:="Tipo"
vcabe[05]:="Banco"
vcabe[06]:="Pedido"
vcabe[07]:="Emiss„o"
vcabe[08]:="Opera‡„o"
vcabe[09]:="Pagamento"
vcabe[10]:="Valor Pago"
vcabe[11]:="Banco"
vcabe[12]:="Agˆncia"
vcabe[13]:="Conta"
vcabe[14]:="Cheque N§"
vcabe[15]:="Observa‡”es"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 Documento  F6 Vencimento  F7 Credor  [Esc] Fim",78)
SETCOLOR(vcn)
@ 04,01 SAY REPLICATE("Ä",78)
DBEDIT(05,01,22,78,vdado,"Fcp",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
*******************************************************************************
FUNCTION Fcp(modo)
// Funcao para Consulta com DBEDIT
*******************************************************************************
SETCOLOR(vcn)
@ 03,04 SAY "Documento:"
@ 03,28 SAY "Credor:"
SETCOLOR(vca)
@ 03,15 SAY Cp->docto
@ 03,36 SAY Cp->nome
SETCOLOR(vcn)
IF modo=1
   Mensagem("In¡cio do Arquivo !",2,1)
   RETURN(1)
ELSEIF modo=2
   Mensagem("Fim do Arquivo !",2,1)
   RETURN(1)
ELSEIF modo=3
   Mensagem("Arquivo Vazio !",3,1)
   RETURN(1)
ELSEIF modo=4
   IF LASTKEY()=K_ESC
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      @ 24,00 CLEAR
      SET ORDER TO 1
      vdocto:=SPACE(10)
      @ 24,30 SAY "Documento N£mero: " GET vdocto PICTURE "9999999999"
      Le()
      IF EMPTY(vdocto)
         RETURN(1)
      ENDIF
      vdocto:=Zeracod(vdocto)
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vdocto
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Documento N„o Encontrado !",4,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      @ 24,00 CLEAR
      SET ORDER TO 3
      vdata:=CTOD(SPACE(8))
      @ 24,25 SAY "Data do Vencimento: " GET vdata
      Le()
      IF EMPTY(vdata)
         RETURN(1)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK DTOS(vdata)
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrada !",4,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F7
      @ 24,00 CLEAR
      SET ORDER TO 4
      vnom:=SPACE(40)
      @ 24,10 SAY "Nome do Credor: " GET vnom PICTURE "@!"
      Le()
      IF EMPTY(vnom)
         RETURN(1)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vnom
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Nome N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSE
      // Salva a tela.
      vtela:=SAVESCREEN(01,00,23,79)
      Abrejan(2)
      SETCOLOR(vci)
      Aviso(6,"   Auxilio ao Usu rio   ")
      SETCOLOR(vca)
      @ 08,12 SAY " Tecla                Fun‡„o"
      SETCOLOR(vcn)
      @ 11,12 SAY "[Setas] - p/ Cima e p/ Baixo, posicionam no registro desejado"
      @ 12,12 SAY "[Setas] - p/ Direita e p/ Esquerda, posicionam no pr¢ximo campo"
      @ 13,12 SAY "[PgUp]  - Retorna para a Janela Anterior"
      @ 14,12 SAY "[PgDn]  - Avan‡a para a Pr¢xima Janela"
      @ 15,12 SAY "[Home]  - Retorna para o Inicio do Registro"
      @ 16,12 SAY "[End]   - Avan‡a para o Fim do Registro"
      @ 17,12 SAY "[Esc]   - Finaliza"
      @ 18,12 SAY "[F5]    - Pesquisa pelo N£mero do Documento"
      @ 19,12 SAY "[F6]    - Pesquisa pela Data de Vencimento"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Credor"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,23,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
RETURN
********************************************************************************
PROCEDURE Relcp1(tipo)
/*
Objetivo : emite os relat¢rios das contas a pagar.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("CTA A PAGAR","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
   IF !FILE("SAOCP3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCP3
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF tipo=1
   vtit:="Relatorio Sintetico de Contas a Pagar"
ELSEIF tipo=2
   vtit:="Relatorio Sintetico de Contas Pagas"
ELSEIF tipo=3
   vtit:="Relatorio Sintetico de Contas a Pagar em Atraso"
ENDIF
SELECT Cp
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio Sint‚tico das Contas a Pagar")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=0                 // Totalizador.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
DO WHILE !EOF() .AND. Cp->venc<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   IF tipo=1
      @ PROW()+1,01 SAY "DOCUMENTO TIPO  EMISSAO           C R E D O R             VENCTO.     V A L O R"
   ELSEIF tipo=2
      @ PROW()+1,01 SAY "DOCUMENTO TIPO  VENCTO.           C R E D O R           DATA PGTO.   VALOR PAGO"
   ELSEIF tipo=3
      @ PROW()+1,01 SAY "DOCUMENTO TIPO  VENCTO.           C R E D O R        DIAS ATRASADOS   V A L O R"
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Cp->venc<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF tipo=1
         IF EMPTY(Cp->datpg) .OR. EMPTY(Cp->valpg)
            @ PROW()+1,01 SAY Cp->docto
            @ PROW(),  12 SAY Cp->tipg
            @ PROW(),  16 SAY Cp->emis
            @ PROW(),  25 SAY LEFT(Cp->nome,32)
            @ PROW(),  58 SAY Cp->venc
            @ PROW(),  66 SAY Cp->valor PICTURE "@E 999,999,999.99"
            vtot+=Cp->valor
         ENDIF
      ELSEIF tipo=2
         IF !EMPTY(Cp->datpg) .OR. !EMPTY(Cp->valpg)
            @ PROW()+1,01 SAY Cp->docto
            @ PROW(),  12 SAY Cp->tipg
            @ PROW(),  16 SAY Cp->venc
            @ PROW(),  25 SAY LEFT(Cp->nome,32)
            @ PROW(),  58 SAY Cp->datpg
            @ PROW(),  66 SAY Cp->valpg PICTURE "@E 999,999,999.99"
            vtot+=Cp->valpg
         ENDIF
      ELSEIF tipo=3
         IF Cp->venc<DATE() .AND. (EMPTY(Cp->valpg) .OR. EMPTY(Cp->datpg))
            @ PROW()+1,01 SAY Cp->docto
            @ PROW(),  12 SAY Cp->tipg
            @ PROW(),  16 SAY Cp->venc
            @ PROW(),  25 SAY LEFT(Cp->nome,32)
            @ PROW(),  60 SAY DATE()-Cp->venc PICTURE "999"
            @ PROW(),  66 SAY Cp->valor PICTURE "@E 999,999,999.99"
            vtot+=Cp->valor
         ENDIF
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  59 SAY vtot PICTURE "@E 9,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*   
DOCUMENTO TIPO  EMISSAO           C R E D O R             VENCTO.     V A L O R
9999999999 XXX 99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/99 999,999,999.99*/
********************************************************************************
PROCEDURE Relcp2(tipo)
/*
Objetivo : emite os relat¢rios das contas a pagar.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("CTA A PAGAR","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
   IF !FILE("SAOCP3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCP3
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 2
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1
ELSE
   Mensagem("Tabela de Opera‡”es N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOBAN.DBF")
   SELECT 3
   USE SAOBAN ALIAS Tban
   IF !FILE("SAOBAN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOBAN1
ELSE
   Mensagem("Tabela de Bancos N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCTB.DBF")
   SELECT 4
   USE SAOCTB ALIAS Ctb
   IF !FILE("SAOCTB1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCTB1
ELSE
   Mensagem("Arquivo das Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPG.DBF")
   SELECT 5
   USE SAOTPG ALIAS Tpg
   IF !FILE("SAOTPG1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPG1
ELSE
   Mensagem("Arquivo dos Tipos de Pagamento N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Cp
SET RELATION TO tipg INTO Tpg, TO opera INTO Ope
vdati:=vdatf:=CTOD(SPACE(8))
IF tipo=1
   vtit:="Relatorio Analitico de Contas a Pagar"
ELSEIF tipo=2
   vtit:="Relatorio Analitico de Contas Pagas"
ELSEIF tipo=3
   vtit:="Relatorio Analitico de Contas a Pagar em Atraso"
ENDIF
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Anal¡tico de Contas a Pagar")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=0                 // Totalizador.
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
// DO WHILE principal
DO WHILE !EOF() .AND. Cp->venc<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Analitico das Contas a Pagar","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Cp->venc<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF tipo=1
         IF EMPTY(Cp->datpg) .OR. EMPTY(Cp->valpg)
            @ PROW()+1,10 SAY "Documento: "+Cp->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cp->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cp->banc1
            @ PROW()+1,10 SAY "Nome do Credor____: "+Cp->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cp->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cp->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cp->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cp->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Observacoes_______: "+Cp->obs
            vtot+=Cp->valor
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ELSEIF tipo=2
         IF !EMPTY(Cp->datpg) .OR. !EMPTY(Cp->valpg)
            @ PROW()+1,10 SAY "Documento: "+Cp->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cp->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cp->banc1
            @ PROW()+1,10 SAY "Nome do Credor____: "+Cp->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cp->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cp->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cp->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cp->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Data do Pagamento: "+DTOC(Cp->datpg)
            @ PROW(),  39 SAY "Valor Pago_____: "+TRANSFORM(Cp->valpg,"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Banco: "+Cp->banc2
            @ PROW(),  25 SAY "Agencia: "+Cp->agenc
            @ PROW(),  44 SAY "Conta Corrente: "+Cp->conta
            @ PROW()+1,10 SAY "Observacoes_______: "+Cp->obs
            vtot+=Cp->valpg
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ELSEIF tipo=3
         IF Cp->venc<DATE() .AND. (EMPTY(Cp->datpg) .OR. EMPTY(Cp->valpg))
            @ PROW()+1,10 SAY "Documento: "+Cp->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cp->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cp->banc1
            @ PROW()+1,10 SAY "Nome do Credor____: "+Cp->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cp->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cp->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cp->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cp->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Dias em atraso____: "+TRANSFORM(DATE()-Cp->venc,"999")
            @ PROW()+1,10 SAY "Observacoes_______: "+Cp->obs
            vtot+=Cp->valor
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  62 SAY vtot PICTURE "@E 99,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
********************************************************************************
//                                    F i m
********************************************************************************
