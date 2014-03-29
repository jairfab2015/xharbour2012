********************************************************************************
/* Programa.: SAOMBA.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento do Movimento Banc rio.     */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Matmba(tipo,modo)
/* Gerenciador de Lan‡amentos banc rios.
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o
               tipo - credito ou debito:        1 - Cr‚dito
                                                2 - D‚bito */
********************************************************************************
IF tipo=1
   vtit:="CREDITOS"
ELSE
   vtit:="DEBITOS"
ENDIF
IF modo=1
   Sinal(vtit,"INCLUSŽO")
ELSEIF modo=2
   Sinal(vtit,"ALTERA€ŽO")
ELSEIF modo=3
   Sinal(vtit,"EXCLUSŽO")
ENDIF
IF FILE("SAOMBA.DBF")
   SELECT 1
   USE SAOMBA ALIAS Mba
   IF !FILE("SAOMBA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOMBA1,SAOMBA2
ELSE
   Mensagem("Arquivo de Lan‡amentos Banc rios N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 2
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1,SAOOPE2
ELSE
   Mensagem("Arquivo de Contas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCTB.DBF")
   SELECT 3
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
Abrejan(2)
// Apresenta os t¡tulos na tela
SELECT Mba
Titulos(tipo)
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vdocto :=SPACE(10)
   vdata  :=CTOD(SPACE(8))
   vbanco :=SPACE(3)
   vagenc :=SPACE(5)
   vconta :=SPACE(10)
   vcheque:=SPACE(10)
   vdesc  :=SPACE(50)
   vopera :=SPACE(6)
   vnope  :=SPACE(41)
   vnome  :=SPACE(39)
   vvalor :=valant:=vsaldo:=vsdmes:=0
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra(tipo)
   @ 5,22 GET vdocto PICTURE "9999999999"
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
      vmes:="mes"+STRZERO(MONTH(saomes),2)
   ELSE
      IF tipo=1 .AND. !Mba->debcre
         Mensagem("Lan‡amento de Cr‚dito Incorreto !",5,1)
         LOOP
      ELSEIF tipo=2 .AND. Mba->debcre
         Mensagem("Lan‡amento de D‚bito Incorreto !",5,1)
         LOOP
      ENDIF
      // Transfere os dados do registro para as vari veis auxiliares.
      Transfere()
      vmes:="mes"+STRZERO(MONTH(vdata),2)
      SELECT Ctb
      SEEK vbanco+vagenc+vconta
      vsaldo:=Ctb->saldo
      vsdmes:=Ctb->&vmes
      vnome:=LEFT(Ctb->nome,39)
   ENDIF
   SELECT Ope
   SEEK vopera
   vnope:=LEFT(Ope->nome,41)
   SELECT Mba
   // Mostra os dados do registro.
   Mostra(tipo)
   SETCOLOR(vcn)
   IF modo=1 .OR. modo=2
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados do Lan‡amento")
         SETCOLOR(vcn)
         // Edita os Dados do Registro
         Edita(tipo)
         // Calculo do Saldo da Conta.
         IF tipo=1
            vsaldo:=Ctb->saldo-valant+vvalor
            vsdmes:=Ctb->&vmes-valant+vvalor
         ELSE
            vsaldo:=Ctb->saldo+valant-vvalor
            vsdmes:=Ctb->&vmes+valant-vvalor
         ENDIF
         SETCOLOR(vcr)
         @  9,56 SAY vsaldo PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      IF modo=1 .AND. !FOUND()
         // Inclui um novo registro no arquivo.
         APPEND BLANK
         Mba->Docto:=vDocto
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza(tipo)
      // Atualiza o saldo da conta no arquivo de contas banc rias.
      vmes:="mes"+STRZERO(MONTH(vdata),2)
      IF tipo=1
         Ctb->&vmes:=Ctb->&vmes-valant+vvalor  // No mˆs.
         Ctb->saldo:=Ctb->saldo-valant+vvalor  // Atual.
      ELSE
         Ctb->&vmes:=Ctb->&vmes+valant-vvalor  // No mˆs.
         Ctb->saldo:=Ctb->saldo+valant-vvalor  // Atual.
      ENDIF
   ELSE
      // Calculo do Saldo da Conta.
      IF tipo=1
         vsaldo:=Ctb->saldo-vvalor  // Atual.
         vsdmes:=Ctb->&vmes-vvalor  // No mˆs.
       ELSE
         vsaldo:=Ctb->saldo+vvalor  // Atual.
         vsdmes:=Ctb->&vmes+vvalor  // No mˆs.
      ENDIF
      SETCOLOR(vcr)
      @  9,56 SAY vsaldo PICTURE "@E 999,999,999.99"
      SETCOLOR(vcn)
      IF Exclui()
         // Deleta o registro do arquivo.
         DELETE
         // Atualiza o Saldo no arquivo.
         IF tipo=1
            Ctb->&vmes:=Ctb->&vmes-vvalor
            Ctb->saldo:=Ctb->saldo-vvalor
         ELSE
            Ctb->&vmes:=Ctb->&vmes+vvalor
            Ctb->saldo:=Ctb->saldo+vvalor
         ENDIF
      ENDIF
   ENDIF
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Titulos(tipo)
// Apresenta os t¡tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@  5, 9 SAY "Documento__: "
@  7, 9 SAY "Data_______: "
@  9, 9 SAY "Banco______: "
@  9,36 SAY "Saldo Atual_______:"
@ 11, 9 SAY "Agˆncia____: "
@ 13, 9 SAY "C.Corrente_: "
IF tipo=1
   @ 15, 9 SAY "Opera‡„o___: "
   @ 17, 9 SAY "Descri‡„o__: "
   @ 19, 9 SAY "Cr‚dito____: "
ELSEIF tipo=2
   @ 15, 9 SAY "Cheque N§__: "
   @ 17, 9 SAY "Opera‡„o___: "
   @ 19, 9 SAY "Descri‡„o__: "
   @ 21, 9 SAY "D‚bito_____: "
ENDIF
@ 08,34 TO 10,72
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(tipo)
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  5,22 SAY vdocto  PICTURE "9999999999"
@  7,22 SAY vdata   PICTURE "99/99/99"
@  9,22 SAY vbanco  PICTURE "999"
@  9,56 SAY vsaldo  PICTURE "@E 999,999,999.99"
@ 11,22 SAY vagenc  PICTURE "@!"
@ 13,22 SAY vconta  PICTURE "@!"
@ 13,33 SAY vnome   PICTURE "@!"
IF tipo=1
   @ 15,22 SAY vopera  PICTURE "@R 9.99.999"
   @ 15,31 SAY vnope   PICTURE "@!"
   @ 17,22 SAY vdesc   PICTURE "@!"
   @ 19,22 SAY vvalor  PICTURE "@E 999,999,999.99"
ELSEIF tipo=2
   @ 15,22 SAY vcheque PICTURE "@!"
   @ 17,22 SAY vopera  PICTURE "@R 9.99.999"
   @ 17,31 SAY vnope   PICTURE "@!"
   @ 19,22 SAY vdesc   PICTURE "@!"
   @ 21,22 SAY vvalor  PICTURE "@E 999,999,999.99"
ENDIF
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita(tipo)
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
LOCAL vl
SETCOLOR(vcr)
@  5,22 SAY vdocto PICTURE "9999999999"
@  9,22 SAY vbanco PICTURE "999"
@ 11,22 SAY vagenc PICTURE "@!"
SETCOLOR(vcn)
DO WHILE .T.
   @  7,22 GET vdata  PICTURE "99/99/99" VALID !EMPTY(vdata)
   Le()
   IF YEAR(vdata)#YEAR(saomes)
      Mensagem("Data Inv lida, Por favor Redigite !",8,1)
      LOOP
   ENDIF
   EXIT
ENDDO
DO WHILE .T.
   SETCOLOR(vci)
   @ 13,22 SAY vconta PICTURE "@!"
   SETCOLOR(vcn)
   vctb:=vbanco+vagenc+vconta
   vctb:=Acha(vctb,"Ctb",1,2,"banco+agenc+conta","nome","@R 999 / !!!!! / !!!!!!!!!!","@!",;
              15,08,22,76,"Banco / Agˆncia / Conta"," Correntista")
   IF !EMPTY(vctb)
      EXIT
   ENDIF
ENDDO
vbanco:=LEFT(vctb,3)
vagenc:=SUBSTR(vctb,4,5)
vconta:=RIGHT(vctb,10)
vnome:=LEFT(Ctb->nome,39)
vmes:="mes"+STRZERO(MONTH(vdata),2)
vsaldo:=Ctb->saldo
vsdmes:=Ctb->&vmes
SETCOLOR(vcr)
@  9,22 SAY vbanco  PICTURE "999"
@  9,56 SAY vsaldo  PICTURE "@E 999,999,999.99"
@ 11,22 SAY vagenc  PICTURE "@!"
@ 13,22 SAY vconta  PICTURE "@!"
@ 13,33 SAY vnome
SETCOLOR(vcn)
IF tipo=1
   vl:=15
ELSEIF tipo=2
   @ 15,22 GET vcheque PICTURE "@!"
   Aviso(24,"Digite o N§ do Cheque")
   Le()
   vl:=17
ENDIF
DO WHILE .T.
   @ vl,22 GET vopera PICTURE "@R 9.99.999"
   Le()
   vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
   vnope:=LEFT(Ope->nome,41)
   IF EMPTY(vopera)
      LOOP
   ENDIF
   EXIT
ENDDO
SETCOLOR(vcr)
@ vl,22 SAY vopera PICTURE "@R 9.99.999"
@ vl,31 SAY vnope
SETCOLOR(vcn)
@ vl+2,22 GET vdesc  PICTURE "@!"
@ vl+4,22 GET vvalor PICTURE "@E 999,999,999.99"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vdata  :=Mba->data
vbanco :=Mba->banco
vagenc :=Mba->agenc
vconta :=Mba->conta
vcheque:=Mba->cheque
vopera :=Mba->opera
vdesc  :=Mba->desc
vvalor :=Mba->valor
valant :=Mba->valor
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza(tipo)
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
IF tipo=1
   Mba->debcre:=.T.
ELSE
   Mba->debcre:=.F.
ENDIF
Mba->data  :=vdata
Mba->banco :=vbanco
Mba->agenc :=vagenc
Mba->conta :=vconta
Mba->cheque:=vcheque
Mba->opera :=vopera
Mba->desc  :=vdesc
Mba->valor :=vvalor
RETURN
********************************************************************************
PROCEDURE Consmba(tipo)
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
IF tipo=1
   vtit:="CREDITOS"
ELSE
   vtit:="DEBITOS"
ENDIF
Sinal(vtit,"CONSULTA")
IF FILE("SAOMBA.DBF")
   SELECT 1
   USE SAOMBA ALIAS Mba
   IF !FILE("SAOMBA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOMBA1, SAOMBA2
ELSE
   Mensagem("Arquivo de Dados N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF tipo=1
   SET FILTER TO debcre=.T.
ELSEIF tipo=2
   SET FILTER TO debcre=.F.
ENDIF
GO TOP
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[9],vmask[9],vcabe[9],vedit[9]
// vdado: vetor dos nomes dos campos
vdado[01]:="docto"
vdado[02]:="data"
vdado[03]:="banco"
vdado[04]:="agenc"
vdado[05]:="conta"
vdado[06]:="valor"
vdado[07]:="cheque"
vdado[08]:="opera"
vdado[09]:="desc"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="9999999999"
vmask[02]:="99/99/99"
vmask[03]:="999"
vmask[04]:="@!"
vmask[05]:="@!"
vmask[06]:="@E 999,999,999.99"
vmask[07]:="@!"
vmask[08]:="@R 9.99.999"
vmask[09]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Documento"
vcabe[02]:="Data"
vcabe[03]:="Banco"
vcabe[04]:="Agˆncia"
vcabe[05]:="C/C"
vcabe[06]:="Valor"
vcabe[07]:="Cheque N§"
vcabe[08]:="Opera‡„o"
vcabe[09]:="Descri‡„o"
// vedit: vetor que indica os campos que podem ser editados.
AFILL(vedit,.F.)
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Mba",03,01,22,78,vdado,vmask,vcabe,vedit,1,;
          "docto",1,"9999999999",10,"Documento","data",2,"99/99/99",8,"Data")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relmba(tipo)
/*
Objetivo  : emite os relat¢rios da estrutura dos arquivos de usu rio.
Parƒmetros: tipo1:  1 -> resumido
                    2 -> anal¡tico
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("MOVIMENTO","RELATORIO")
IF FILE("SAOMBA.DBF")
   SELECT 1
   USE SAOMBA ALIAS Mba
   IF !FILE("SAOMBA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOMBA1,SAOMBA2
ELSE
   Mensagem("Arquivo de Lan‡amentos Banc rios N„o Encontrado no Disco !",8,1)
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
   Mensagem("Arquivo de Contas N„o Encontrado no Disco !",8,1)
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
   Mensagem("Arquivo de Bancos N„o Encontrado no Disco !",8,1)
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
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Mba
SET ORDER TO 2
SET RELATION TO banco INTO Tban, TO opera INTO OPE
DO WHILE .T.
   vbanco:=SPACE(3)
   vagenc:=SPACE(5)
   vconta:=SPACE(10)
   vdati:=vdatf:=CTOD(SPACE(8))
   Abrejan(2)
   @ 08,27 SAY "Conta Corrente___:"
   @ 10,27 SAY "N£mero do Banco__:"
   @ 12,27 SAY "N£mero da Agˆncia:"
   @ 14,27 SAY "Data Inicial_____:"
   @ 16,27 SAY "Data Final_______:"
   SETCOLOR(vcr)
   @ 08,46 SAY vconta PICTURE "@!"
   @ 10,46 SAY vbanco PICTURE "999"
   @ 12,46 SAY vagenc PICTURE "@!"
   @ 14,46 SAY vdati
   @ 16,46 SAY vdatf
   SETCOLOR(vcn)
   Aviso(24,"Escolha a Conta Corrente ou Tecle [Esc] para Finalizar !")
   // Pesquisa os dados para impressao do relatorio.
   vctb:=vbanco+vagenc+vconta
   vctb:=Acha(vctb,"Ctb",1,2,"banco+agenc+conta","nome","@R 999 / !!!!! / !!!!!!!!!!","@!",;
              15,08,22,76,"Banco / Agˆncia / Conta"," Correntista")
   IF EMPTY(vctb)
      EXIT
   ENDIF
   @ 24,00 CLEAR
   vbanco:=LEFT(vctb,3)
   vagenc:=SUBSTR(vctb,4,5)
   vconta:=RIGHT(vctb,10)
   SETCOLOR(vcr)
   @ 08,46 SAY vconta
   @ 10,46 SAY vbanco
   @ 12,46 SAY vagenc
   SETCOLOR(vcn)
   @ 14,46 GET vdati VALID !EMPTY(vdati)
   @ 16,46 GET vdatf VALID !EMPTY(vdatf) .AND. vdatf>=vdati
   Le()
   IF !Confirme()
      LOOP
   ENDIF
   vtit:="Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf)
   IF !Imprime("Relat¢rio do Movimento Banc rio")
      CLOSE DATABASE
      RETURN
   ENDIF
   vsaldo:=vdeb:=vcre:=0  // Inicializa o saldo inicial.
   SELECT Ctb
   SEEK vctb
   vmes:=MONTH(vdati)
   vsaldo:=Ctb->saldi
   IF vmes>1
      FOR i=1 TO vmes-1
          vsaldo+=FIELDGET(10+i) // Saldo no final do mes anterior.
      NEXT
   ENDIF
   vdata:=CTOD("01/"+STRZERO(vmes)+"/"+STR(YEAR(saomes),4))
   SELECT Mba
   SET SOFTSEEK ON
   SEEK DTOS(vdata)+vctb
   SET SOFTSEEK OFF
   DO WHILE Mba->data<=vdati .AND. Mba->banco+Mba->agenc+Mba->conta=vctb
      vsaldo+=IF(Mba->debcre,Mba->valor,-Mba->valor)
      SKIP
   ENDDO
   vdata:=vdati
   pg:=0                   // Contador de p ginas.
   SET DEVICE TO PRINTER   // Direciona para a impressora.
   // DO WHILE principal
   DO WHILE !EOF() .AND. Mba->banco=vbanco .AND. Mba->agenc=vagenc .AND. Mba->conta=vconta .AND. Mba->data<=vdatf
      // Impressao do cabe‡alho.
      IF tipo=1
         // Cabecalho do Relat¢rio resumido.
         Cabe(emp[2],vsist,"Relatorio Sintetico do Movimento Bancario",vtit,80,vcia10)
         @ PROW()+1,01 SAY "BANCO: "+vbanco
         @ PROW(),  13 SAY LEFT(Tban->nome,20)
         @ PROW(),  34 SAY "AGENCIA: "+vagenc
         @ PROW(),  55 SAY "CONTA CORRENTE: "+vconta
         @ PROW()+1,29 SAY "SALDO EM "+DTOC(vdata)+": "+TRANSFORM(vsaldo,"@E 999,999,999.99")
         @ PROW()+1,00 SAY REPLICATE("=",80)
         SET PRINT ON
         ?? vcia20
         SET PRINT OFF
         @ PROW()+1,01 SAY "  DATA      DOCUMENTO      CHEQUE                  D E S C R I C A O                         DEBITO        CREDITO        SALDO"
         @ PROW()+1,00 SAY REPLICATE("-",132)
      ELSEIF tipo=2
         // Cabecalho do Relat¢rio completo.
         Cabe(emp[2],vsist,"Relatorio Analitico do Movimento Bancario",vtit,80,vcia10)
         @ PROW()+1,01 SAY "BANCO: "+vbanco
         @ PROW(),  13 SAY LEFT(Tban->nome,20)
         @ PROW(),  34 SAY "AGENCIA: "+vagenc
         @ PROW(),  55 SAY "CONTA CORRENTE: "+vconta
         @ PROW()+1,29 SAY "SALDO EM "+DTOC(vdata)+": "+TRANSFORM(vsaldo,"@E 999,999,999.99")
         @ PROW()+1,00 SAY REPLICATE("=",132)
         @ PROW()+1,01 SAY "DATA/DOCUMENTO                   O P E R A C A O              VALOR / CHEQUE"
         @ PROW()+1,00 SAY REPLICATE("-",vl)
      ENDIF
      // Impressao dos dados.
      SELECT Mba
      // DO WHILE das p ginas.
      DO WHILE PROW()<58 .AND. !EOF() .AND. Mba->banco=vbanco .AND. Mba->agenc=vagenc .AND. Mba->conta=vconta .AND. Mba->data<=vdatf
         // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
         IF Escprint(80)
            CLOSE DATABASE
            RETURN
         ENDIF
         IF tipo#2
            // Imprime os dados do relat¢rio resumido.
            @ PROW()+1,01 SAY Mba->data
            @ PROW(),  10 SAY Mba->docto
            @ PROW(),  26 SAY Mba->cheque
            IF !EMPTY(Mba->desc)
               @ PROW(),  37 SAY LEFT(Mba->desc,50)
            ELSE
               @ PROW(),  37 SAY LEFT(Ope->nome,50)
            ENDIF
            IF !Mba->debcre
               @ PROW(),88 SAY Mba->valor PICTURE "@E 999,999,999.99"
               vdeb+=Mba->valor
               vsaldo-=Mba->valor
            ELSE
               @ PROW(),103 SAY Mba->valor PICTURE "@E 999,999,999.99"
               vcre+=Mba->valor
               vsaldo+=Mba->valor
            ENDIF
            @ PROW(),118 SAY vsaldo PICTURE "@E 999,999,999.99"
         ELSEIF tipo=2
            // Imprime os dados do relat¢rio completo.
            @ PROW()+2,01 SAY Mba->data
            @ PROW(),  10 SAY Ope->nome
            @ PROW(),  62 SAY Mba->valor PICTURE "@E 999,999,999.99"
            IF !Mba->debcre
               @ PROW(),  77 SAY "DEB"
               vsaldo-=Mba->valor
            ELSE
               @ PROW(),  77 SAY "CRE"
               vsaldo+=Mba->valor
            ENDIF
            @ PROW()+1,01 SAY Mba->docto
            @ PROW(),  17 SAY Mba->desc
            @ PROW(),  68 SAY Mba->cheque
         ENDIF
         SKIP
      ENDDO   // Fim do DO WHILE da pagina e do banco.
   ENDDO  // Fim do DO WHILE principal.
   IF tipo=1
      @ PROW()+1,00 SAY REPLICATE("-",132)
      @ PROW()+1,10 SAY "TOTAIS E SALDO EM "+DTOC(vdatf)
      @ PROW(), 88 SAY vdeb   PICTURE "@E 999,999,999.99"
      @ PROW(),103 SAY vcre   PICTURE "@E 999,999,999.99"
      @ PROW(),118 SAY vsaldo PICTURE "@E 999,999,999.99"
      @ PROW()+1,00 SAY REPLICATE("-",132)
   ELSEIF tipo=2
      @ PROW()+1,00 SAY REPLICATE("-",80)
      @ PROW()+1,29 SAY "SALDO EM "+DTOC(vdatf)+": "+TRANSFORM(vsaldo,"@E 999,999,999.99")
      @ PROW()+1,00 SAY REPLICATE("-",80)
   ENDIF
   SET PRINT ON
   ?? vcia10
   SET PRINT OFF
   @ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
   EJECT
   SET DEVICE TO SCREEN
ENDDO
CLOSE DATABASE
RETURN
/*
BANCO: 999  XXXXXXXXXXXXXXXXXXXX AGENCIA: 9999999999  CONTA CORRENTE: 9999999999
                            SALDO EM 99/99/99: 999,999,999.99
DATA/DOCUMENTO                   O P E R A C A O              VALOR / CHEQUE
99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99 CRE
999999999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999999999999
  DATA      DOCUMENTO      CHEQUE                  D E S C R I C A O                         DEBITO        CREDITO        SALDO                      
99/99/99 999999999999999 9999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99 999,999,999.99 999,999,999.99
*/
********************************************************************************
//                                    F i m
********************************************************************************
