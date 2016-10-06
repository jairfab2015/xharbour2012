********************************************************************************
/* Programa.: SAOCR.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento de Contas a Receber.       */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Matcr(modo,tipo)
/* Gerenciador de CTA RECEBER
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o
               tipo - tipo de conta a receber   1- Vendas
                                                2- Normais */
********************************************************************************
IF modo=1
   Sinal("CTA RECEBER","INCLUSŽO")
ELSEIF modo=2
   Sinal("CTA RECEBER","EXCLUSŽO")
ELSEIF modo=3
   Sinal("CTA RECEBER","BAIXA")
ENDIF
IF FILE("SAOCR.DBF")
   SELECT 1
   USE SAOCR ALIAS Cr
   IF !FILE("SAOCR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCR1,SAOCR2,SAOCR3,SAOCR4
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEN.DBF")
   SELECT 2
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN1,SAOVEN2
ELSE
   Mensagem("Arquivo de Vendas N„o Encontrado no Disco !",8,1)
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
   Mensagem("Tabela de Contas N„o Encontrada no Disco !",8,1)
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
   Mensagem("Arquivo de Movimento Banc rio N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPG.DBF")
   SELECT 6
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
IF FILE("SAOCTB.DBF")
   SELECT 7
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
SELECT Cr
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
   vvalor:=vtaxa:=valiq:=valef:=0
   vdatpg:=CTOD(SPACE(8))
   vvalpg:=valiqpg:=valefpg:=0
   vbanc2:=SPACE(3)
   vagenc:=SPACE(5)
   vconta:=SPACE(10)
   vobs  :=SPACE(40)
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra(modo,tipo)
   @ 3,21 GET vdocto PICTURE "9999999999"
   Aviso(24,"Digite o N§ do Documento, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC .OR. EMPTY(vdocto)
      CLOSE DATABASE
      RETURN
   ENDIF
   vdocto:=Zeracod(vdocto)
   SEEK vdocto
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Documento N„o Encontrado !",8,1)
         LOOP
      ENDIF
   ELSE
      IF tipo=2 .AND. !EMPTY(Cr->nupd)
         tipo=1
      ELSEIF tipo=1 .AND. EMPTY(Cr->nupd)
         tipo=2
      ENDIF
      // Apresenta os t¡tulos na tela
      Titulos(modo,tipo)
      // Transfere os dados do registro para as vari veis auxiliares.
      Transfere(modo,tipo)
   ENDIF
   SELECT Cr
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
         Cr->docto:=vdocto
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
            Ctb->&vmes:=Ctb->&vmes-vvalor  // No mˆs.
            Ctb->saldo:=Ctb->saldo-vvalor  // Atual.
         ENDIF
         SELECT Cr
      ENDIF
   ELSEIF modo=3
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados da Baixa")
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
      SELECT Cr
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza(modo,tipo)
      SELECT Mba
      SEEK vdocto
      IF !FOUND()
         // Inclui um novo registro no arquivo de Movimento Banc rio.
         APPEND BLANK
         Mba->docto:=vdocto
      ENDIF
      // Atualiza o registro do Movimento Banc rio.
      Mba->debcre:=.T.
      Mba->data :=vdatpg
      Mba->banco:=vbanc2
      Mba->agenc:=vagenc
      Mba->conta:=vconta
      Mba->opera:=vopera
      Mba->desc :=vobs
      Mba->valor:=vvalpg*(1-vtaxa/100)
      // Atualiza o Saldo da Conta Banc ria.
      vvalpg:=vvalpg*(1-vtaxa/100)
      vmes  :="mes"+STRZERO(MONTH(vdatpg),2)
      SELECT Ctb
      SEEK vbanc2+vagenc+vconta
      Ctb->&vmes:=Ctb->&vmes+vvalpg  // No mˆs.
      Ctb->saldo:=Ctb->saldo+vvalpg  // Atual.
   ENDIF
   SELECT Cr
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Titulos(modo,tipo)
// Apresenta os t¡tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@  3,10 SAY "Documento: "
@  3,34 SAY "Tipo do Pagto: "
@  3,54 SAY "N§ do Banco: "
IF tipo=1
   @  5,01 SAY SPACE(78)
   @  5,10 SAY "N£mero do Pedido de Venda: "
   @  5,45 SAY "Data da Emiss„o: "
   @  9,10 SAY "Nome do Cliente___: "
ELSE
   @ 05,01 SAY REPLICATE("Ä",78)
   @ 09,10 SAY "Nome do Devedor___: "
ENDIF
@  7,10 SAY "Opera‡„o_: "
@ 11,10 SAY "Data Vencimento: "
@ 11,36 SAY "Valor: "
@ 11,59 SAY "Taxa: "
@ 13,10 SAY "Valor L¡quido:"
@ 13,42 SAY "Encargo_____:"
IF modo=3
   @ 15,01 SAY REPLICATE("Ä",78)
   @ 16,10 SAY "Data do Pagamento: "
   @ 16,39 SAY "Valor Pago_____: "
   @ 18,10 SAY "Valor L¡quido:"
   @ 18,42 SAY "Encargo_____:"
   @ 20,10 SAY "Banco: "
   @ 20,25 SAY "Agˆncia: "
   @ 20,44 SAY "Conta Corrente: "
   @ 22,10 SAY "Observa‡”es_______:"
ELSE
   @ 15,10 SAY "Observa‡”es_______: "
ENDIF
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(modo,tipo)
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,21 SAY vdocto  PICTURE "9999999999"
@  3,49 SAY vtipg   PICTURE "!!!"
@  3,67 SAY vbanc1  PICTURE "999"
IF tipo=1
   @  5,37 SAY vnupd   PICTURE "99999"
   @  5,62 SAY vemis   PICTURE "99/99/99"
ENDIF
@  7,21 SAY vopera  PICTURE "@R 9.99.999"
@  7,30 SAY vnope   PICTURE "@!"
@  9,30 SAY vnome   PICTURE "@!"
@ 11,27 SAY vvenc   PICTURE "99/99/99"
@ 11,43 SAY vvalor  PICTURE "@E 999,999,999.99"
@ 11,65 SAY vtaxa   PICTURE "@E 99.99"
@ 13,25 SAY valiq  PICTURE "@E 999,999,999.99"
@ 13,56 SAY valef  PICTURE "@E 999,999,999.99"
IF modo=3
   @ 16,29 SAY vdatpg  PICTURE "99/99/99"
   @ 16,56 SAY vvalpg  PICTURE "@E 999,999,999.99"
   @ 18,25 SAY valiqpg PICTURE "@E 999,999,999.99"
   @ 18,56 SAY valefpg PICTURE "@E 999,999,999.99"
   @ 20,17 SAY vbanc2  PICTURE "@!"
   @ 20,34 SAY vagenc  PICTURE "@!"
   @ 20,60 SAY vconta  PICTURE "@!"
   @ 22,30 SAY vobs    PICTURE "@!"
ELSE
   @ 15,30 SAY vobs    PICTURE "@!"
ENDIF
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita(modo,tipo)
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@ 3,21 SAY vdocto PICTURE "9999999999"
SETCOLOR(vcn)
IF modo=1
   @  3,49 GET vtipg  PICTURE "!!!"
   Le()
   vtipg:=Acha(vtipg,"Tpg",1,2,"codi","nome","!!!","@!",15,15,22,76)
   SETCOLOR(vcr)
   @  3,49 SAY vtipg PICTURE "!!!"
   SETCOLOR(vcn)
   @  3,67 GET vbanc1 PICTURE "999"
   Le()
   vbanc1:=Acha(vbanc1,"Tban",1,2,"codi","nome","999","@!",15,15,22,76)
   SETCOLOR(vcr)
   @  3,67 SAY vbanc1 PICTURE "999"
   SETCOLOR(vcn)
   IF tipo=1
      @  5,37 GET vnupd PICTURE "99999"
      Le()
      IF EMPTY(vnupd)
         RETURN
      ENDIF
      vnupd:=Zeracod(vnupd)
      vnupd:=Acha(vnupd,"Ven",1,2,"nupd","cli","99999","@!",15,10,22,76)
      IF EMPTY(vnupd)
         RETURN
      ENDIF
      SETCOLOR(vcr)
      @  5,37 SAY vnupd PICTURE "99999"
      SETCOLOR(vcn)
      vemis:=Ven->data
      vnome:=Ven->cli
      vvalor:=Ven->valor+Ven->vencf
      SETCOLOR(vcr)
      @  5,62 SAY vemis  PICTURE "99/99/99"
      @  9,30 SAY vnome  PICTURE "@!"
      @ 11,43 SAY vvalor PICTURE "@E 999,999,999.99"
      SETCOLOR(vcn)
   ENDIF
   DO WHILE .T.
      @  7,21 GET vopera PICTURE "@R 9.99.999"
      Le()
      vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
      IF EMPTY(vopera)
         LOOP
      ENDIF
      vnope:=LEFT(Ope->nome,40)
      EXIT
   ENDDO
   SETCOLOR(vcr)
   @  7,21 SAY vopera PICTURE "@R 9.99.999"
   @  7,30 SAY vnope  PICTURE "@!"
   SETCOLOR(vcn)
   IF tipo=2
      @  9,30 GET vnome  PICTURE "@!"
   ENDIF
   @ 11,27 GET vvenc  PICTURE "99/99/99"
   @ 11,43 GET vvalor PICTURE "@E 999,999,999.99"
   @ 11,65 GET vtaxa  PICTURE "@E 99.99"
   Le()
   valef:=vvalor*(vtaxa/100)
   valiq:=(vvalor-valef)
   SETCOLOR(vcr)
   @ 13,25 SAY valiq  PICTURE "@E 999,999,999.99"
   @ 13,56 SAY valef  PICTURE "@E 999,999,999.99"
   SETCOLOR(vcn)
   @ 15,30 GET vobs   PICTURE "@!"
   Le()
ELSEIF modo=3
   @ 16,29 GET vdatpg  PICTURE "99/99/99" VALID !EMPTY(vdatpg)
   @ 16,56 GET vvalpg  PICTURE "@E 999,999,999.99"
   Le()
   valefpg:=vvalpg*(vtaxa/100)
   valiqpg:=(vvalpg-valefpg)
   SETCOLOR(vcr)
   @ 18,25 SAY valiqpg  PICTURE "@E 999,999,999.99"
   @ 18,56 SAY valefpg  PICTURE "@E 999,999,999.99"
   SETCOLOR(vcn)
   @ 20,60 GET vconta  PICTURE "@!"
   Le()
   vctb:=vbanc2+vagenc+vconta
   vctb:=Acha(vctb,"Ctb",1,2,"banco+agenc+conta","nome","@R 999 / !!!!! / !!!!!!!!!!","@!",;
              15,08,22,76,"Banco / Agˆncia / Conta"," Correntista")
   vbanc2:=LEFT(vctb,3)
   vagenc:=SUBSTR(vctb,4,5)
   vconta:=RIGHT(vctb,10)
   SETCOLOR(vcr)
   @ 20,17 SAY vbanc2  PICTURE "@!"
   @ 20,34 SAY vagenc  PICTURE "@!"
   @ 20,60 SAY vconta  PICTURE "@!"
   SETCOLOR(vcn)
   @ 22,30 GET vobs    PICTURE "@!"
   Le()
ENDIF
RETURN
********************************************************************************
STATIC PROCEDURE Transfere(modo,tipo)
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vtipg  :=Cr->tipg 
vbanc1 :=Cr->banc1
IF tipo=1
   vnupd  :=Cr->nupd
   vemis  :=Cr->emis
ENDIF
vopera :=Cr->opera
SELECT Ope
SEEK vopera
vnope  :=LEFT(Ope->nome,40)
SELECT Cr
vnome  :=Cr->nome
vvenc  :=Cr->venc
vvalor :=Cr->valor
vtaxa  :=Cr->taxa
valef:=vvalor*(vtaxa/100)
valiq:=(vvalor-valef)
IF modo=3
   vdatpg :=Cr->datpg
   vvalpg :=Cr->valpg
   valefpg:=vvalpg*(vtaxa/100)
   valiqpg:=(vvalpg-valefpg)
   vbanc2 :=Cr->banc2
   vagenc :=Cr->agenc
   vconta :=Cr->conta
ENDIF
vobs:=Cr->obs
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza(modo,tipo)
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Cr->tipg  :=vtipg 
Cr->banc1 :=vbanc1
IF tipo=1
   Cr->nupd  :=vnupd
   Cr->emis  :=vemis
ENDIF
Cr->opera :=vopera
Cr->nome  :=vnome
Cr->venc  :=vvenc
Cr->valor :=vvalor
Cr->taxa  :=vtaxa
IF modo=3
   Cr->datpg :=vdatpg
   Cr->valpg :=vvalpg
   Cr->banc2 :=vbanc2
   Cr->agenc :=vagenc
   Cr->conta :=vconta
ENDIF
Cr->obs:=vobs
RETURN
********************************************************************************
PROCEDURE Conscr()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("CTA RECEBER","CONSULTA")
IF FILE("SAOCR.DBF")
   SELECT 1
   USE SAOCR ALIAS Cr
   IF !FILE("SAOCR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCR1,SAOCR2,SAOCR3,SAOCR4
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao DBEDIT().
PRIVATE vdado[16],vmask[16],vcabe[16]
// vdado: vetor dos nomes dos campos
vdado[01]:="venc"
vdado[02]:="valor"
vdado[03]:="taxa"
vdado[04]:="valor*(1-taxa/100)"
vdado[05]:="tipg"
vdado[06]:="banc1"
vdado[07]:="nupd"
vdado[08]:="emis"
vdado[09]:="opera"
vdado[10]:="datpg"
vdado[11]:="valpg"
vdado[12]:="valpg*(1-taxa/100)"
vdado[13]:="banc2"
vdado[14]:="agenc"
vdado[15]:="conta"
vdado[16]:="obs"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="99/99/99"
vmask[02]:="@E 999,999,999.99"
vmask[03]:="@E 99.99"
vmask[04]:="@E 999,999,999.99"
vmask[05]:="!!!"
vmask[06]:="999"
vmask[07]:="99999"
vmask[08]:="99/99/99"
vmask[09]:="@R 9.99.999"
vmask[10]:="99/99/99"
vmask[11]:="@E 999,999,999.99"
vmask[12]:="@E 999,999,999.99"
vmask[13]:="999"
vmask[14]:="@!"
vmask[15]:="@!"
vmask[16]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Vencimento"
vcabe[02]:="Valor Bruto"
vcabe[03]:="Taxa"
vcabe[04]:="Valor L¡quido"
vcabe[05]:="Tipo"
vcabe[06]:="Banco"
vcabe[07]:="Pedido"
vcabe[08]:="Emiss„o"
vcabe[09]:="Opera‡„o"
vcabe[10]:="Pagamento"
vcabe[11]:="Valor Pago Bruto"
vcabe[12]:="Valor Pago L¡quido"
vcabe[13]:="Banco"
vcabe[14]:="Agˆncia"
vcabe[15]:="Conta"
vcabe[16]:="Observa‡”es"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 Documento  F6 Vencimento  F7 Devedor  [Esc] Fim",78)
SETCOLOR(vcn)
@ 04,01 SAY REPLICATE("Ä",78)
DBEDIT(05,01,22,78,vdado,"Fcr",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
*******************************************************************************
FUNCTION Fcr(modo)
// Funcao para Consulta com DBEDIT
*******************************************************************************
SETCOLOR(vcn)
@ 03,04 SAY "Documento:"
@ 03,28 SAY "Devedor:"
SETCOLOR(vca)
@ 03,15 SAY Cr->docto
@ 03,37 SAY Cr->nome
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
      @ 24,10 SAY "Nome do Devedor: " GET vnom PICTURE "@!"
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
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Devedor"
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
PROCEDURE Relcr1(tipo)
/*
Objetivo : emite os relat¢rios das contas a receber.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot,vtotl
Sinal("CTA A RECEBER","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCR.DBF")
   SELECT 1
   USE SAOCR ALIAS Cr
   IF !FILE("SAOCR3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCR3
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Cr
IF tipo=1
   vtit:="Relatorio Sintetico de Contas a Receber"
ELSEIF tipo=2
   vtit:="Relatorio Sintetico de Contas Recebidas"
ELSEIF tipo=3
   vtit:="Relatorio Sintetico de Contas a Receber em Atraso"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio Sint‚tico das Contas a Receber")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=vtotl:=0          // Totalizadores.
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
// DO WHILE principal
DO WHILE !EOF() .AND. Cr->venc<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),123,vcia15)
   IF tipo=1
      @ PROW()+1,00 SAY "DOCUMENTO   TIPO   EMISSAO                D E V E D O R                  VENCTO.       V A L O R     TAXA   VALOR LIQUIDO"
   ELSEIF tipo=2
      @ PROW()+1,00 SAY "DOCUMENTO   TIPO   EMISSAO                D E V E D O R                   PAGTO.       V A L O R     TAXA   VALOR LIQUIDO"
   ELSEIF tipo=3
      @ PROW()+1,00 SAY "DOCUMENTO   TIPO   EMISSAO                D E V E D O R               DIAS ATRASO      V A L O R     TAXA   VALOR LIQUIDO"
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",123)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Cr->venc<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF tipo=1
         IF EMPTY(Cr->datpg) .OR. EMPTY(Cr->valpg)
            @ PROW()+1,00 SAY Cr->docto
            @ PROW(),  12 SAY Cr->tipg
            @ PROW(),  18 SAY Cr->emis
            @ PROW(),  29 SAY LEFT(Cr->nome,40)
            @ PROW(),  72 SAY Cr->venc
            @ PROW(),  83 SAY Cr->valor PICTURE "@E 999,999,999.99"
            @ PROW(), 100 SAY Cr->taxa  PICTURE "@E 99.99"
            @ PROW(), 108 SAY Cr->valor*(1-Cr->taxa/100) PICTURE "@E 999,999,999.99"
            vtot+=Cr->valor
            vtotl+=(Cr->valor*(1-Cr->taxa/100))
         ENDIF
      ELSEIF tipo=2
         IF !EMPTY(Cr->datpg) .OR. !EMPTY(Cr->valpg)
            @ PROW()+1,00 SAY Cr->docto
            @ PROW(),  12 SAY Cr->tipg
            @ PROW(),  18 SAY Cr->venc
            @ PROW(),  29 SAY LEFT(Cr->nome,40)
            @ PROW(),  72 SAY Cr->datpg
            @ PROW(),  83 SAY Cr->valpg PICTURE "@E 999,999,999.99"
            @ PROW(), 100 SAY Cr->taxa  PICTURE "@E 99.99"
            @ PROW(), 108 SAY Cr->valpg*(1-Cr->taxa/100) PICTURE "@E 999,999,999.99"
            vtot+=Cr->valpg
            vtotl+=(Cr->valpg*(1-Cr->taxa/100))
         ENDIF
      ELSEIF tipo=3
         IF Cr->venc<DATE() .AND. (EMPTY(Cr->datpg) .OR. EMPTY(Cr->valpg))
            @ PROW()+1,00 SAY Cr->docto
            @ PROW(),  12 SAY Cr->tipg
            @ PROW(),  18 SAY Cr->venc
            @ PROW(),  29 SAY LEFT(Cr->nome,40)
            @ PROW(),  75 SAY DATE()-Cr->venc PICTURE "999"
            @ PROW(),  83 SAY Cr->valor PICTURE "@E 999,999,999.99"
            @ PROW(), 100 SAY Cr->taxa  PICTURE "@E 99.99"
            @ PROW(), 108 SAY Cr->valor*(1-Cr->taxa/100) PICTURE "@E 999,999,999.99"
            vtot+=Cr->valor
            vtotl+=(Cr->valor*(1-Cr->taxa/100))
         ENDIF
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("-",123)
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  81 SAY vtot PICTURE "@E 9,999,999,999.99"
@ PROW(), 106 SAY vtotl PICTURE "@E 9,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",123)
SET PRINTER ON
?? vcia10
SET PRINTER OFF
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*   
DOCUMENTO   TIPO   EMISSAO                D E V E D O R                  VENCTO.       V A L O R     TAXA   VALOR LIQUIDO
9999999999  XXX   99/99/99   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99/99/99   999,999,999.99   99.99   999,999,999.99
*/
********************************************************************************
PROCEDURE Relcr2(tipo)
/*
Objetivo : emite os relat¢rios das contas a receber.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot,vtotl
Sinal("CTA A RECEBER","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCR.DBF")
   SELECT 1
   USE SAOCR ALIAS Cr
   IF !FILE("SAOCR3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCR3
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
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
SELECT Cr
SET RELATION TO tipg INTO Tpg, TO opera INTO Ope
IF tipo=1
   vtit:="Relatorio Analitico de Contas a Receber"
ELSEIF tipo=2
   vtit:="Relatorio Analitico de Contas Recebidas"
ELSEIF tipo=3
   vtit:="Relatorio Analitico de Contas a Receber em Atraso"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Anal¡tico das Contas a Receber")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=vtotl:=0          // Totalizadores.
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
// DO WHILE principal
DO WHILE !EOF() .AND. Cr->venc<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Cr->venc<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF tipo=1
         IF EMPTY(Cr->datpg) .OR. EMPTY(Cr->valpg)
            @ PROW()+1,10 SAY "Documento: "+Cr->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cr->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cr->banc1
            @ PROW()+1,10 SAY "Nome do Devedor___: "+Cr->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cr->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cr->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cr->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cr->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Valor Liquido: "+TRANSFORM(Cr->valor*(1-Cr->taxa/100),"@E 999,999,999.99")
            @ PROW(),  41 SAY "Encargo_____: "+TRANSFORM(Cr->valor*(Cr->taxa/100),"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Observacoes_______: "+Cr->obs
            vtot+=Cr->valor
            vtotl+=(Cr->valor*(1-Cr->taxa/100))
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ELSEIF tipo=2
         IF !EMPTY(Cr->datpg) .OR. !EMPTY(Cr->valpg)
            @ PROW()+1,10 SAY "Documento: "+Cr->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cr->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cr->banc1
            @ PROW()+1,10 SAY "Nome do Devedor___: "+Cr->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cr->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cr->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cr->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cr->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Valor Liquido: "+TRANSFORM(Cr->valor*(1-Cr->taxa/100),"@E 999,999,999.99")
            @ PROW(),  41 SAY "Encargo_____: "+TRANSFORM(Cr->valor*(Cr->taxa/100),"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Data do Pagamento: "+DTOC(Cr->datpg)
            @ PROW(),  39 SAY "Valor Pago_____: "+TRANSFORM(Cr->valpg,"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Pagto.Liquido: "+TRANSFORM(Cr->valpg*(1-Cr->taxa/100),"@E 999,999,999.99")
            @ PROW(),  41 SAY "Encargo_____: "+TRANSFORM(Cr->valpg*(Cr->taxa/100),"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Banco: "+Cr->banc2
            @ PROW(),  25 SAY "Agencia: "+Cr->agenc
            @ PROW(),  44 SAY "Conta Corrente: "+Cr->conta
            @ PROW()+1,10 SAY "Observacoes_______: "+Cr->obs
            vtot+=Cr->valpg
            vtotl+=(Cr->valpg*(1-Cr->taxa/100))
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ELSEIF tipo=3
         IF DATE()>Cr->venc .AND. (EMPTY(Cr->datpg) .OR. EMPTY(Cr->valpg))
            @ PROW()+1,10 SAY "Documento: "+Cr->docto
            @ PROW(),  34 SAY "Tipo do Pagto: "+Cr->tipg
            @ PROW(),  54 SAY "No.do Banco: "+Cr->banc1
            @ PROW()+1,10 SAY "Nome do Devedor___: "+Cr->nome
            @ PROW()+1,10 SAY "Operacao_: "+TRANSFORM(Cr->opera,"@R 9.99.999")+" - "+Ope->nome
            @ PROW()+1,10 SAY "Data Vencimento: "+DTOC(Cr->venc)
            @ PROW(),  36 SAY "Valor: "+TRANSFORM(Cr->valor,"@E 999,999,999.99")
            @ PROW(),  59 SAY "Taxa: "+TRANSFORM(Cr->taxa,"@E 99.99")
            @ PROW()+1,10 SAY "Valor Liquido: "+TRANSFORM(Cr->valor*(1-Cr->taxa/100),"@E 999,999,999.99")
            @ PROW(),  41 SAY "Encargo_____: "+TRANSFORM(Cr->valor*(Cr->taxa/100),"@E 999,999,999.99")
            @ PROW()+1,10 SAY "Dias em atraso____: "+TRANSFORM(DATE()-Cr->venc,"999")
            @ PROW()+1,10 SAY "Observacoes_______: "+Cr->obs
            vtot+=Cr->valor
            vtotl+=(Cr->valor*(1-Cr->taxa/100))
            @ PROW()+1,00 SAY REPLICATE("-",80)
         ENDIF
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,03 SAY "T O T A I S"
//T O T A I S:          BRUTO: 99,999,999,999.99    LIQUIDO: 99,999,999,999.99
@ PROW(),  25 SAY "BRUTO: "+TRANSFORM(vtot,"@E 99,999,999,999.99")
@ PROW(),  53 SAY "LIQUIDO: "+TRANSFORM(vtotl,"@E 99,999,999,999.99")
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
********************************************************************************
//                                    F i m
********************************************************************************
