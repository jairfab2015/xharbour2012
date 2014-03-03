********************************************************************************
/* Programa.: SAOFCH.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: M¢dulo de Fechamento Mensal e Anual do Movimento. */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Atuopera(vopera)
/* Objetivo: Atualiza o arquivo de opera‡”es.*/
********************************************************************************
varq:=SELECT()
SELECT Ope
SEEK vopera
FOR i=1 TO 12
    FIELDPUT(i+3,vmes[i])
NEXT
SELECT (varq)
RETURN
********************************************************************************
PROCEDURE Fecha(vdat)
/* Objetivo__:  fechamento do mˆs/ano em processamento.
   Parametro:   mˆs que est  sendo fechado. */
********************************************************************************
LOCAL vcod1,vcod2,vtot1[12],vtot2[12]
PRIVATE vmes[12]
IF FILE("SAOOPE.DBF")
   SELECT 1
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1,SAOOPE2
ELSE
   Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Processamento das compras.
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Processamento das Compras")
SETCOLOR(vcn)
IF FILE("SAOCOM.DBF")
   SELECT 2
   USE SAOCOM ALIAS Com
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
INDEX ON opera TO TEMP
DO WHILE !EOF()
   vope:=Com->opera
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Com->opera=vope .AND. !EOF()
      IF Com->data<vdat
         @ 14,43 SAY Com->nupd
         IF !EMPTY(Com->data)
            vmes[MONTH(Com->data)]+=Com->valor
         ENDIF
      ENDIF
      SKIP
   ENDDO
   // Atualiza o arquivo de opera‡”es.
   Atuopera(vope)
ENDDO
// Processamento das vendas
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Processamento das Vendas")
SETCOLOR(vcn)
IF FILE("SAOVEN.DBF")
   SELECT 2
   USE SAOVEN ALIAS Ven
ELSE
   Mensagem("Arquivo de Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
INDEX ON opera TO TEMP
DO WHILE !EOF()
   vope:=Ven->opera
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Ven->opera=vope .AND. !EOF()
      IF Ven->data<vdat .AND. !EMPTY(Ven->data)
         @ 14,43 SAY Ven->nupd
         vmes[MONTH(Ven->data)]+=Ven->valor
      ENDIF
      SKIP
   ENDDO
   // Atualiza o arquivo de opera‡”es.
   Atuopera(vope)
ENDDO
// Processamento das comissoes dos vendedores/representantes.
IF FILE("SAOREP.DBF")
   SELECT 2
   USE SAOREP ALIAS Rep
ELSE
   Mensagem("Arquivo de Representantes/Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
REPLACE ALL comi WITH 0
// Processamento das Contas a Pagar.
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Processamento das Contas a Pagar do Mˆs")
SETCOLOR(vcn)
IF FILE("SAOCP.DBF")
   SELECT 2
   USE SAOCP ALIAS Cp
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
INDEX ON opera TO TEMP
DO WHILE !EOF()
   vope:=Cp->opera
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Cp->opera=vope .AND. !EOF()
      IF !EMPTY(Cp->datpg) .AND. Cp->datpg<vdat
         @ 14,43 SAY Cp->docto
         vmes[MONTH(Cp->datpg)]+=Cp->valor
      ENDIF
      SKIP
   ENDDO
   // Atualiza o arquivo de opera‡”es.
   Atuopera(vope)
ENDDO
// Processamento das Contas a Receber.
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Processamento das Contas a Receber do Mˆs")
SETCOLOR(vcn)
IF FILE("SAOCR.DBF")
   SELECT 2
   USE SAOCR ALIAS Cr
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
INDEX ON opera TO TEMP
DO WHILE !EOF()
   vope:=Cr->opera
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Cr->opera=vope .AND. !EOF()
      IF !EMPTY(Cr->datpg) .AND. Cr->datpg<vdat
         @ 14,43 SAY Cr->docto
         vmes[MONTH(Cr->datpg)]+=Cr->valor
      ENDIF
      SKIP
   ENDDO
   // Atualiza o arquivo de opera‡”es.
   Atuopera(vope)
ENDDO
// Processamento do Movimento Banc rio.
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Processamento do Movimento Banc rio do Mˆs")
SETCOLOR(vcn)
IF FILE("SAOMBA.DBF")
   SELECT 2
   USE SAOMBA ALIAS Mba
ELSE
   Mensagem("Arquivo de Movimenta‡„o Banc ria N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
INDEX ON opera TO TEMP
DO WHILE !EOF()
   vope:=Mba->opera
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Mba->opera=vope .AND. !EOF()
      IF Mba->data<vdat .AND. !EMPTY(Mba->data)
         @ 14,43 SAY Mba->docto
         vmes[MONTH(Mba->data)]+=Mba->valor
      ENDIF
      SKIP
   ENDDO
   // Atualiza o arquivo de opera‡”es.
   Atuopera(vope)
ENDDO
IF FILE("SAOCTB.DBF")
   SELECT 3
   USE SAOCTB INDEX SAOCTB1 ALIAS Ctb
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Mba
SET INDEX TO SAOMBA2
GO TOP
DO WHILE !EOF()
   vcta:=Mba->banco+Mba->agenc+Mba->conta
   AFILL(vmes,0)
   @ 14,32 SAY "Documento: "
   DO WHILE Mba->banco+Mba->agenc+Mba->conta=vcta .AND. !EOF()
      IF Mba->data<vdat
         @ 14,43 SAY Mba->docto
         IF Mba->debcre .AND. !EMPTY(Mba->data)
            vmes[MONTH(Mba->data)]+=Mba->valor
         ELSE
            IF !EMPTY(Mba->data)
               vmes[MONTH(Mba->data)]-=Mba->valor
            ENDIF
         ENDIF
      ENDIF
      SKIP
   ENDDO
   SELECT Ctb
   SEEK vcta
   FOR i=1 TO 12
       FIELDPUT(i+9,vmes[i])
   NEXT
   SELECT Mba
ENDDO
// Totalizacao das Operacoes.
@ 12,01 SAY SPACE(78)
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(12,"Totalizando as Opera‡”es")
SETCOLOR(vcn)
SELECT Ope
GO TOP
DO WHILE !EOF()
   AFILL(vtot1,0)
   vcod1:=LEFT(Ope->codi,1)
   DO WHILE vcod1=LEFT(Ope->codi,1) .AND. !EOF()
      AFILL(vtot2,0)
      vcod2:=LEFT(Ope->codi,3)
      DO WHILE vcod2=LEFT(Ope->codi,3) .AND. !EOF()
         IF SUBSTR(Ope->codi,2,2)#"00" .AND. RIGHT(Ope->codi,3)#"000"
            Aviso(14,"Opera‡„o: "+TRANSFORM(Ope->codi,"@R 9.99.999"))
            FOR i=1 TO 12
                vtot1[i]+=FIELDGET(i+3)
            NEXT
         ENDIF
         SKIP
      ENDDO
      vrec:=RECNO()
      SEEK vcod2+"000"
      IF !FOUND()
         APPEND BLANK
         Ope->codi:=vcod2+"000"
      ENDIF
      FOR i=1 TO 12
          FIELDPUT(i+3,vtot2[i])
          vtot1[i]+=vtot2[i]
      NEXT
      GO vrec
   ENDDO
   vrec:=RECNO()
   SEEK vcod1+"00000"
   IF !FOUND()
      APPEND BLANK
      Ope->codi:=vcod1+"00000"
   ENDIF
   FOR i=1 TO 12
       FIELDPUT(i+3,vtot2[i])
   NEXT
   GO vrec
ENDDO
CLOSE DATABASE
// Calculo do custo medio dos produtos.
@ 03,01 CLEAR TO 22,78
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1.NTX, SAOPRO2.NTX
ELSE
   Mensagem("Arquivo de Dados N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOI.DBF")
   SELECT 2
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI1.NTX, SAOCOI2.NTX
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Prod
SET ORDER TO 1
SETCOLOR(vcp)
Aviso(8,"A g u a r d e ...")
SETCOLOR(vca)
Aviso(10,"C lculo do Custo M‚dio dos Produtos !")
SETCOLOR(vcn)
SELECT Prod
GO TOP
@ 13,27 SAY "Produto: "
@ 15,27 SAY "Data___: "
@ 17,27 SAY "Compra_: "
DO WHILE !EOF()
   vcod:=Prod->codi
   SETCOLOR(vca)
   @ 13,36 SAY Coi->codpro PICTURE "@R 9.99.999"
   @ 15,36 SAY SPACE(8)
   @ 17,36 SAY SPACE(5)
   SETCOLOR(vcn)
   SELECT Coi
   SET ORDER TO 2
   SEEK vcod
   vsdi:=vsda:=vctoa:=vctoi:=vctom:=0
   vsdi:=Prod->saldi
   IF Prod->custm#0
      vctoi:=Prod->custm*Prod->saldi
   ELSE
      vctoi:=Prod->custr*Prod->saldi
   ENDIF
   DO WHILE Coi->codpro=vcod .AND. !EOF()
      SETCOLOR(vca)
      @ 15,36 SAY Coi->data 
      @ 17,36 SAY Coi->nupd
      SETCOLOR(vcn)
      vsda+=Coi->quant
      vctoa+=(Coi->preun*Coi->quant)
      SKIP
   ENDDO
   IF (vsdi+vsda)#0
      vctom:=(vctoi+vctoa)/(vsdi+vsda)
   ENDIF
   IF vctom=0
      vctom:=Prod->custr
   ENDIF
   SELECT Prod
   Prod->custm:=vctom
   SKIP
ENDDO
CLOSE DATABASE
Mensagem("Fim dos C lculos do Fechamento !",10)
RETURN
********************************************************************************
PROCEDURE Fechames()
/* Objetivo:  fechamento do mes em processamento.*/
********************************************************************************
PRIVATE vmes[12]
Sinal("FECHAMENTO","MES")
Abrejan(2)
novomes:=RIGHT(DTOC(saomes+35),7)
SETCOLOR(vca)
Aviso(08,"Fechamento do Mˆs de "+Dpc(saomes))
SETCOLOR(vcn)
DO WHILE .T.
   @ 10,26 SAY "Digite o Novo Mˆs: " GET novomes PICTURE "99/9999";
                VALID LEFT(novomes,2)>"00" .AND. LEFT(novomes,2)<="12";
                .AND. RIGHT(novomes,2)=RIGHT(DTOC(saomes),2)
   Aviso(24,"Tecle <Esc> para Cancelar !")
   Le()
   IF LASTKEY()=K_ESC
      RETURN
   ENDIF
   IF Confirme()
      EXIT
   ENDIF
ENDDO
saomes:=CTOD("01/"+novomes)
SAVE TO SAO ALL LIKE sao*
Fecha(saomes)
RETURN
********************************************************************************
PROCEDURE Fechaano()
// Fechamento do Ano em Processamento.
********************************************************************************
Sinal("ANO","FECHAMENTO")
Abrejan(2)
SETCOLOR(vci)
Aviso(5," Rotina de Abertura de Novo Ano para Processamento ")
SETCOLOR(vcn)
resp:=SPACE(1)
i:=1
@ 10,6 SAY "O  sistema  mantem a movimenta‡„o dos dados por um ano.   Para ini- "
@ 11,6 SAY "ciar um novo ano ‚ necess ario FECHAR o ano atualmente em  processa-"
@ 12,6 SAY "mento. Essa opera‡„o consiste em LIMPAR toda a movimenta‡„o do  ano "
@ 13,6 SAY "atual para  dar lugar ao novo ano. Uma vez  efetuada, n„o ser  mais "
@ 14,6 SAY "poss¡vel recuperar os dados do movimento do ano anterior, a n„o ser "
@ 15,6 SAY "atrav‚s dos arquivos hist¢ridos.  Portanto, para  ABRIR um novo ano "
@ 16,6 SAY "vocˆ deve confirmar se:"
@ 18,15 SAY "1 - J  emitiu todos os relat¢rios desejados;"
@ 19,15 SAY "2 - Todos os movimentos deste ano est„o corretos;"
@ 20,15 SAY "3 - J  conferiu as posi‡”es de custos e opera‡”es;"
@ 21,15 SAY "4 - H  autoriza‡„o do respons vel para fechar o ano."
SETCOLOR(vca)
FOR i=1 TO 4
    resp:=SPACE(1)
    @ 17+i,70 SAY "S/N ?" GET resp PICTURE "!" VALID resp$"SN"
    READ
    IF resp="N"
      @ 17+i,70 SAY "N Ž O !"
      Mensagem("Opera‡„o Cancelada !",6,1)
      SETCOLOR(vcn)
      CLOSE DATABASE
      RETURN
   ELSE
      @ 17+i,70 SAY "S I M !"
   ENDIF
NEXT
SETCOLOR(vca)
Aviso(22,"Abertura do ano de "+STR(YEAR(saomes)+1,4,0)+", Inicio do Processamento !")
SETCOLOR(vcn)
IF !Confirme()
   CLOSE DATABASE
   RETURN
ENDIF
Abrejan(2)
SETCOLOR(vcp)
Aviso(6,"A g u a r d e ...")
SETCOLOR(vcn)
Aviso(8,"Fechando o Ano de "+STR(YEAR(saomes),4,0)+" !")
Fecha(CTOD("01/01/"+STR(YEAR(saomes)+1,4,0)))
Abrejan(2)
Aviso(12,"Transferindo o Movimento do Ano para os Arquivos Hist¢ricos")
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Opera‡”es")
SETCOLOR(vcn)
IF FILE("SAOOPE.DBF")
   SELECT 1
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1,SAOOPE2
ELSE
   Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
vano:=RIGHT(DTOC(saomes),2)
varq:="SAOOPE"+vano
COPY TO &varq
REPLACE ALL mes01 WITH 0,mes02 WITH 0,mes03 WITH 0,mes04 WITH 0,;
            mes05 WITH 0,mes06 WITH 0,mes07 WITH 0,mes08 WITH 0,;
            mes09 WITH 0,mes10 WITH 0,mes11 WITH 0,mes12 WITH 0
CLOSE
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Compras")
SETCOLOR(vcn)
IF FILE("SAOCOM.DBF")
   SELECT 1
   USE SAOCOM ALIAS Com
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOCOM"+vano
COPY TO &varq
// Limpa o arquivo das compras.
ZAP
CLOSE
IF FILE("SAOCOI.DBF")
   SELECT 1
   USE SAOCOI ALIAS Coi
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOCOI"+vano
COPY TO &varq
// Limpa o arquivo dos itens das compras.
ZAP
CLOSE
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Transferencias")
SETCOLOR(vcn)
IF FILE("SAOTRA.DBF")
   SELECT 1
   USE SAOTRA ALIAS Tra
ELSE
   Mensagem("Arquivo de Transferencias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOTRA"+vano
COPY TO &varq
// Limpa o arquivo das transferencias.
ZAP
CLOSE
IF FILE("SAOTRI.DBF")
   SELECT 1
   USE SAOTRI ALIAS Tri
ELSE
   Mensagem("Arquivo de Transferencias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOTRI"+vano
COPY TO &varq
// Limpa o arquivo dos itens das transferencias.
ZAP
CLOSE
// Processamento das vendas
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Vendas")
SETCOLOR(vcn)
IF FILE("SAOVEN.DBF")
   SELECT 1
   USE SAOVEN ALIAS Ven
ELSE
   Mensagem("Arquivo de Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOVEN"+vano
COPY TO &varq
// Limpa o arquivo de vendas.
ZAP
CLOSE
IF FILE("SAOVEI.DBF")
   SELECT 1
   USE SAOVEI ALIAS Vei
ELSE
   Mensagem("Arquivo de Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOVEI"+vano
COPY TO &varq
// Limpa o arquivo de itens de vendas.
ZAP
CLOSE
// Processamento das Contas a Pagar
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Contas a Pagar")
SETCOLOR(vcn)
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOCP"+vano
COPY TO &varq
// Apaga as contas com vencimento no ano fechado.
DELETE FOR YEAR(venc)=YEAR(saomes) .AND. valpg#0
CLOSE
// Processamento das Contas a Receber
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento das Contas a Receber")
SETCOLOR(vcn)
IF FILE("SAOCR.DBF")
   SELECT 1
   USE SAOCR ALIAS Cr
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOCR"+vano
COPY TO &varq
// Apaga as contas com vencimento no ano fechado.
DELETE FOR YEAR(venc)=YEAR(saomes) .AND. valpg#0
CLOSE
// Processamento do movimento banc rio.
@ 14,01 SAY SPACE(78)
SETCOLOR(vca)
Aviso(14,"Processamento do Movimento Banc rio")
SETCOLOR(vcn)
IF FILE("SAOMBA.DBF")
   SELECT 1
   USE SAOMBA ALIAS Mba
ELSE
   Mensagem("Arquivo de Movimenta‡„o Banc ria N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Copia para o arquivo historico.
varq:="SAOMBA"+vano
COPY TO &varq
// Limpa o arquivo do movimento bancario.
ZAP
CLOSE
IF FILE("SAOCTB.DBF")
   SELECT 3
   USE SAOCTB INDEX SAOCTB1 ALIAS Ctb
ELSE
   Mensagem("Arquivo de Contas Banc rias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
DO WHILE !EOF()
   // Transfere o saldo inicial do ano.
   Ctb->saldi:=Ctb->saldo
   // Zera o saldo dos outros meses.
   FOR i=1 TO 12
       FIELDPUT(i+10,0)
   NEXT
   SKIP
ENDDO
saomes:=CTOD("01/01/"+STR(VAL(vano)+1,2))
Abrejan(2)
SETCOLOR(vca)
Aviso(08,"Novo Ano em Processamento: "+STR(YEAR(saomes),4,0)+" !")
SETCOLOR(vcn)
IF !Confirme()
   @ 08,01 SAY SPACE(78)
   DO WHILE .T.
      dano:=SPACE(5)
      @ 08,16 SAY "Digite o Novo Ano em Processamento: " GET dano PICTURE "9999"
      Le()
      IF !Confirme()
         LOOP
      ENDIF
      EXIT
   ENDDO
   saomes:=CTOD("01/01/"+dano)
   SETCOLOR(vca)
   @ 08,01 SAY SPACE(78)
   Aviso(08,"Novo Ano em Processamento: "+STR(YEAR(saomes),4,0)+" !")
   INKEY(3)
   SETCOLOR(vcn)
ENDIF
// Salva o novo ano no arquivo de variaveis de memoria SAO.MEM.
SAVE ALL LIKE sao* TO SAO
@ 08,01 SAY SPACE(78)
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relfch()
/*
Objetivo : emite os relat¢rios das opera‡oes.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("FECHAMENTO","RELATORIO")
IF FILE("SAOOPE.DBF")
   SELECT 1
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1, SAOOPE2
ELSE
   Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
vcodi:=vcodf:=SPACE(6)
// Pesquisa a faixa de codigos cujas registros devem ser impressos.
Pesqint(6,"@R 9.99.999","C¢digos das Opera‡”es")
IF !Imprime("Relat¢rio do Fechamento das Opera‡”es")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF() .AND. Ope->codi<=vcodf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio do Fechamento das Operacoes","Ano de "+STR(YEAR(saomes),4),235,vcia20)
   @ PROW()+1,01 SAY "CODIGO  TIPO            O P E R A C A O                               JANEIRO      FEVEREIRO       MARCO         ABRIL         MAIO          JUNHO         JULHO        AGOSTO       SETEMBRO      OUTUBRO       NOVEMBRO      DEZEMBRO"
   @ PROW()+1,00 SAY REPLICATE("-",235)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Ope->codi<=vcodf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF RIGHT(Ope->codi,5)="00000"
         vcol:=4
      ELSEIF RIGHT(Ope->codi,3)="000"
         vcol:=2
      ELSE
         vcol:=0
      ENDIF
      @ PROW()+1,5-vcol SAY Ope->codi PICTURE "@R 9.99.999"
      @ PROW(),      14 SAY Ope->tipo
      @ PROW(),      16 SAY Ope->nome
      FOR i=1 TO 12
          @ PROW(),PCOL()+1 SAY FIELDGET(i+3) PICTURE "@E 99,999,999.99"
      NEXT
      SKIP
      IF RIGHT(Ope->codi,5)="00000"
         @ PROW()+1,00 SAY REPLICATE("-",235)
      ELSEIF RIGHT(Ope->codi,3)="000"
         @ PROW()+1,00 SAY " "
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",235,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
CODIGO  TIPO            O P E R A C A O                          JANEIRO      FEVEREIRO       MARCO         ABRIL         MAIO          JUNHO         JULHO        AGOSTO       SETEMBRO      OUTUBRO       NOVEMBRO      DEZEMBRO
9.99.999 x xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99
*/
********************************************************************************
PROCEDURE Consger()
/*
Objetivo: Consulta gerencial na tela das operacoes de um determinado periodo:
          pedidos, compras, transferencias, vendas, notas fiscais, contas a
          receber e contas a pagar.
*/
********************************************************************************
PRIVATE vtot[14],vcons[14],i:=0,j:=0
DO WHILE .T.
   Sinal("CONSULTA","GERENCIAL")
   vdati:=vdatf:=CTOD(SPACE(8))
   // Pesquisa a faixa datas dados serao apresentados.
   Pesqdat()
   IF EMPTY(vdati) .OR. EMPTY(vdatf)
      CLOSE DATABASE
      RETURN
   ENDIF
   Abrejan(2)
   SETCOLOR(vcp)
   Aviso(10,"A g u a r d e ...")
   SETCOLOR(vca)
   Aviso(12,"Processando os Dados a Serem Apresentados !")
   AFILL(vtot,0.00)
   SETCOLOR(vcn)
   // Processamento o Estoque dos Produtos.
   IF FILE("SAOPRO.DBF")
      SELECT 1
      USE SAOPRO INDEX SAOPRO1 ALIAS Prod
   ELSE
      Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Produto C¢digo: "+TRANSFORM(codi,"@R 9.99.999"))
      vtot[1]+=(Prod->saldo*Prod->custr)
      vtot[2]+=(Prod->saldod*Prod->custr)
      vtot[3]+=(Prod->saldo*Prod->precr)
      vtot[4]+=(Prod->saldod*Prod->precr)
      SKIP
   ENDDO
   @ 14,01 SAY SPACE(78)
   // Processamento dos Pedidos de Compra.
   IF FILE("SAOPED.DBF")
      SELECT 1
      USE SAOPED INDEX SAOPED1 ALIAS Ped
   ELSE
      Mensagem("Arquivo de Pedidos N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Pedido N£mero: "+nupd)
      IF data>=vdati .AND. data<=vdatf
         vtot[5]+=Ped->valor
      ENDIF
      SKIP
   ENDDO
   @ 14,01 SAY SPACE(78)
   // Processamento das Compras.
   IF FILE("SAOCOM.DBF")
      SELECT 1
      USE SAOCOM INDEX SAOCOM1 ALIAS Com
   ELSE
      Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   IF FILE("SAOOPE.DBF")
      SELECT 2
      USE SAOOPE INDEX SAOOPE1 ALIAS Ope
   ELSE
      Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   SELECT Com
   SET RELATION TO opera INTO Ope
   DO WHILE !EOF()
      Aviso(14,"Compra N£mero: "+nupd)
      IF Com->data>=vdati .AND. Com->data<=vdatf .AND. Ope->tipo="C"
         vtot[6]+=(Com->valor+Com->valef)
      ENDIF
      SKIP
   ENDDO
   CLOSE DATABASE
   @ 14,01 SAY SPACE(78)
   // Processamento das Transferencias.
   IF FILE("SAOTRA.DBF")
      SELECT 1
      USE SAOTRA INDEX SAOTRA1 ALIAS Tra
   ELSE
      Mensagem("Arquivo de Transferˆncias N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Transferˆncia N£mero: "+nupd)
      IF data>=vdati .AND. data<=vdatf
         IF Tra->ttipo="L"
            vtot[7]+=Tra->valor
         ELSE
            vtot[8]+=Tra->valor
         ENDIF
      ENDIF
      SKIP
   ENDDO
   @ 14,01 SAY SPACE(78)
   // Processamento das Vendas.
   IF FILE("SAOVEN.DBF")
      SELECT 1
      USE SAOVEN INDEX SAOVEN1 ALIAS Ven
   ELSE
      Mensagem("Arquivo de Vendas N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   IF FILE("SAOOPE.DBF")
      SELECT 2
      USE SAOOPE INDEX SAOOPE1 ALIAS Ope
   ELSE
      Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   SELECT Ven
   SET RELATION TO opera INTO Ope
   DO WHILE !EOF()
      Aviso(14,"Venda N£mero: "+nupd)
      IF data>=vdati .AND. data<=vdatf .AND. Ope->tipo="V"
         vtot[9]+=(Ven->valor+Ven->vencf-Ven->vdesc)
      ENDIF
      SKIP
   ENDDO
   CLOSE DATABASE
   @ 14,01 SAY SPACE(78)
   // Processamento das Notas Fiscais.
   IF FILE("SAONF.DBF")
      SELECT 1
      USE SAONF INDEX SAONF1 ALIAS Nf
   ELSE
      Mensagem("Arquivo de Notas Fiscais N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Nota Fiscal N£mero: "+nunf)
      IF data>=vdati .AND. data<=vdatf
         vtot[10]+=(Nf->valor+Nf->vencf-Nf->vdesc)
      ENDIF
      SKIP
   ENDDO
   @ 14,01 SAY SPACE(78)
   // Processamento das Contas a Receber.
   IF FILE("SAOCR.DBF")
      SELECT 1
      USE SAOCR INDEX SAOCR1 ALIAS Cr
   ELSE
      Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Documento N£mero: "+docto)
      IF venc>=vdati .AND. venc<=vdatf
         IF Cr->valpg=0
            vtot[11]+=Cr->valor
         ELSE
            vtot[12]+=Cr->valpg
         ENDIF
      ENDIF
      SKIP
   ENDDO
   @ 14,01 SAY SPACE(78)
   // Processamento das Contas a Pagar.
   IF FILE("SAOCP.DBF")
      SELECT 1
      USE SAOCP INDEX SAOCP1 ALIAS Cp
   ELSE
      Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   DO WHILE !EOF()
      Aviso(14,"Documento N£mero: "+docto)
      IF venc>=vdati .AND. venc<=vdatf
         IF Cp->valpg=0
            vtot[13]+=Cp->valor
         ELSE
            vtot[14]+=Cp->valpg
         ENDIF
      ENDIF
      SKIP
   ENDDO
   Abrejan(2)
   SETCOLOR(vci)
   Aviso(04,"  Consulta Gerencial para o Per¡odo de "+DTOC(vdati)+" a "+DTOC(vdatf)+"  ")
   SETCOLOR(vcn)
   @ 07,02 SAY "Estoque na Loja___:                 Estoque no Dep¢sito___:"
   @ 09,02 SAY "Valor Venda Loja__:                 Valor Venda Dep¢sito__:"
   @ 11,02 SAY "Pedidos de Compras:                 Compras + Encargos____:"
   @ 13,02 SAY "Transferˆncia Loja:                 Transferˆncia Dep¢sito:"
   @ 15,02 SAY "Vendas+Enc.-Desc._:                 Notas Fiscais_________:"
   @ 17,02 SAY "Contas a Receber__:                 Contas Recebidas______:"
   @ 19,02 SAY "Contas a Pagar____:                 Contas Pagas__________:"
   SETCOLOR(vca)
   i:=j:=0
   DO WHILE i<14
       ++i
       @ 07+j,21 SAY vtot[i] PICTURE "@E 9,999,999,999.99"
       ++i
       @ 07+j,63 SAY vtot[i] PICTURE "@E 9,999,999,999.99"
       j+=2
   ENDDO
   vtela:=SAVESCREEN(01,00,24,79)
   SETCOLOR(vcn)
   DO WHILE .T.
      Beep(2)
      mg:=1
      SET MESSAGE TO 24 CENTER
      @ 21,25      PROMPT "Finaliza" MESSAGE "Finaliza as Consultas"
      @ 21,COL()+4 PROMPT "Outra"    MESSAGE "Realiza Outra Consulta"
      @ 21,COL()+4 PROMPT "Imprime"  MESSAGE "Imprime a Colsulta Realizada"
      MENU TO mg
      IF mg=1
         CLOSE DATABASE
         RETURN
      ELSEIF mg=2
         EXIT
      ELSEIF mg=3
         Impconsger()
      ENDIF
      RESTSCREEN(01,00,24,79,vtela)
   ENDDO
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Impconsger()
// Imprime uma consulta na Impressora.
********************************************************************************
Sinal("CONSULTA","IMPRESSŽO")
IF !Imprime("Relat¢rio da Consulta Gerencial")
   CLOSE DATABASE
   RETURN
ENDIF
SET DEVICE TO PRINTER   // Direciona para a impressora.
// Impressao do cabe‡alho.
Cabe(emp[2],vsist,"RELATORIO DA CONSULTA GERENCIAL","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
vcons[1]:="Estoque na Loja___:"
vcons[2]:="Estoque no Deposito___:"
vcons[3]:="Valor Venda Loja__:"
vcons[4]:="Valor Venda Deposito__:"
vcons[5]:="Pedidos de Compras:"
vcons[6]:="Compras + Encargos ___:"
vcons[7]:="Transferencia Loja:"
vcons[8]:="Transferencia Deposito:"
vcons[9]:="Vendas+Enc.-Desc._:"
vcons[10]:="Notas Fiscais_________:"
vcons[11]:="Contas a Receber__:"
vcons[12]:="Contas Recebidas______:"
vcons[13]:="Contas a Pagar____:"
vcons[14]:="Contas Pagas__________:"
i:=j:=0
DO WHILE i<14
   ++i
   @ 10+j,02 SAY vcons[i]+TRANSFORM(vtot[i],"@E 9,999,999,999.99")
   ++i
   @ 10+j,38 SAY vcons[i]+TRANSFORM(vtot[i],"@E 9,999,999,999.99")
   j+=3
ENDDO
@ PROW()+3,00 SAY REPLICATE("=",80)
SET DEVICE TO SCREEN
RETURN
********************************************************************************
//                                     F I M 
********************************************************************************
