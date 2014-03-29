********************************************************************************
/* Programa.: SAOCTO.PRG 
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento dos Custos dos Produtos.   */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Atupro()
// Atualiza‡„o de Pre‡os e Custos por Produto.
********************************************************************************
Sinal("PRODUTOS","CUSTOS")
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
// Cria os vetores para a fun‡„o DBEDIT().
PRIVATE vdado[13],vmask[13],vcabe[13]
// vdado: vetor dos nomes dos campos
vdado[01]:="custr"
vdado[02]:="datcu"
vdado[03]:="precr"
vdado[04]:="datcr"
vdado[05]:="IF(custr#0 .AND. precr#0,(precr/custr-1)*100,0)"
vdado[06]:="custm"
vdado[07]:="cusus"
vdado[08]:="preus"
vdado[09]:="saldo"
vdado[10]:="saldod"
vdado[11]:="saldo+saldod"
vdado[12]:="datue"
vdado[13]:="datus"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="@E 999,999,999.99"
vmask[03]:="@E 999,999,999.99"
vmask[05]:="@E 9,999.99"
vmask[06]:="@E 999,999,999.99"
vmask[07]:="@E 999,999.99"
vmask[08]:="@E 999,999.99"
vmask[09]:="@E 999,999.99"
vmask[10]:="@E 999,999.99"
vmask[11]:="@E 999,999.99"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Custo Cr$"
vcabe[02]:="Reajuste"
vcabe[03]:="Pre‡o Cr$"
vcabe[04]:="Reajuste"
vcabe[05]:="Margem %"
vcabe[06]:="Custo M‚dio"
vcabe[07]:="Custo US$"
vcabe[08]:="Pre‡o US$"
vcabe[09]:="Saldo Loja"
vcabe[10]:="Saldo Dep¢sito"
vcabe[11]:="Saldo Total"
vcabe[12]:="Ultima Entrada"
vcabe[13]:="Ultima Sa¡da"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 Produto  F6 Nome  [Ins] Reajuste  [Enter] Visualiza  [Esc] Fim",78)
SETCOLOR(vcn)
@ 04,01 SAY REPLICATE("Ä",78)
DBEDIT(05,01,22,78,vdado,"Fctopro",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fctopro(modo)
// Fun‡„o para Consulta com DBEDIT()
********************************************************************************
SETCOLOR(vcn)
@ 03,03 SAY "Produto:"
SETCOLOR(vca)
@ 03,12 SAY Prod->codi PICTURE "@R 9.99.999"
@ 03,21 SAY Prod->nome
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
      vcodi:=SPACE(6)
      @ 24,20 SAY "C¢digo do Produto Desejado: " GET vcodi PICTURE "@R 9.99.999"
      Le()
      IF EMPTY(vcodi)
         RETURN(2)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vcodi
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, C¢digo N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      @ 24,00 CLEAR
      SET ORDER TO 2
      vnome:=SPACE(50)
      @ 24,02 SAY "Nome Desejado: " GET vnome PICTURE "@!"
      Le()
      IF EMPTY(vnome)
         RETURN(2)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vnome
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Nome N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_ENTER
      // Pressionada a tecla <Enter>
      // Visualiza o produto.
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      Abrejan(2)
      SETCOLOR(vcn)
      @ 04,03 SAY "C¢digo: "
      @ 04,20 SAY "Nome: "
      @ 06,03 SAY "Unidade: "
      @ 06,24 SAY "Custo: "
      @ 06,48 SAY "Pre‡o de Venda: "
      @ 08,03 SAY "Descri‡„o____________: "
      @ 11,03 SAY "Margem % :"
      @ 13,03 SAY "Custo Unit rio US$: "
      @ 13,50 SAY "Porcentagem de IPI "
      @ 15,03 SAY "Quant.Pedida: "
      @ 15,28 SAY "Prazo: "
      @ 15,50 SAY "Porcentagem de ICMS:"
      @ 17,03 SAY "Estoque M¡mino_: "
      @ 17,30 SAY "Saldo Inicial: "
      @ 17,55 SAY "Saldo Atual: "
      @ 19,03 SAY "Data da Ultima Entrada__: "
      @ 19,44 SAY "Data da Ultima Sa¡da__: "
      @ 21,03 SAY "Custo M‚dio: "
      @ 21,30 SAY "Class. Fiscal: "
      @ 21,58 SAY "Reajuste: "
      SETCOLOR(vcr)
      @ 04,11 SAY Prod->codi  PICTURE "@R 9.99.999"
      @ 04,26 SAY Prod->nome  PICTURE "@!"
      @ 06,12 SAY Prod->unid  PICTURE "@!"
      @ 06,31 SAY Prod->custr PICTURE "@E 9,999,999.99"
      @ 06,64 SAY Prod->precr PICTURE "@E 9,999,999.99"
      @ 08,26 SAY Prod->desc1 PICTURE "@!"
      @ 09,26 SAY Prod->desc2 PICTURE "@!"
      @ 10,26 SAY Prod->desc3 PICTURE "@!"
      @ 11,14 SAY IF(Prod->custr#0 .AND. Prod->precr#0,(Prod->precr/Prod->custr-1)*100,0) PICTURE "@E 9,999.99"
      @ 11,26 SAY Prod->desc4 PICTURE "@!"
      @ 13,23 SAY Prod->cusus PICTURE "@E 9,999,999.99"
      @ 13,71 SAY Prod->pipi  PICTURE "@E 99.99"
      @ 15,17 SAY Prod->pedid PICTURE "@E 9,999.99"
      @ 15,35 SAY Prod->prazo PICTURE "@!"
      @ 15,71 SAY Prod->picms PICTURE "99.99"
      @ 17,20 SAY Prod->estmi PICTURE "@E 9,999.99"
      @ 17,45 SAY Prod->saldi+Prod->saldid PICTURE "@E 9,999.99"
      @ 17,68 SAY Prod->saldo+Prod->saldod PICTURE "@E 9,999.99"
      @ 19,29 SAY Prod->datue PICTURE "99/99/99"
      @ 19,68 SAY Prod->datus PICTURE "99/99/99"
      @ 21,16 SAY Prod->custm PICTURE "@E 9,999,999.99"
      @ 21,45 SAY Prod->clfis PICTURE "9999.99.9999"
      @ 21,68 SAY Prod->datcr PICTURE "99/99/99"
      SETCOLOR(vcr)
      @ 23,01 SAY PADC("Pressione uma Tecla para Continuar...",78)
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ELSEIF LASTKEY()=K_INS
      // Pressionada a tecla <Ins>
      // Atualiza o Custo e o Pre‡o
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      SETCOLOR(vcf)
      @ 07,04,21,74 BOX frame[1]
      SELECT Prod
      @  9, 6 SAY "C¢digo: "
      @ 11, 6 SAY "Loja: "
      @ 11,29 SAY "Dep¢sito: "
      @ 11,54 SAY "Unidade: "
      @ 13, 6 SAY "Custo Reposi‡„o: "
      @ 13,48 SAY "Ultimo Reajuste: "
      @ 15, 6 SAY "Pre‡o de Venda_: "
      @ 15,48 SAY "Ultimo Reajuste: "
      // Margem(%): 999.99   Custo US$: 999,999.99    Pre‡o US$: 999,999.99
      @ 17,06 SAY "Margem (%):"
      @ 17,27 SAY "Custo US$:"
      @ 17,52 SAY "Pre‡o US$:"
      @ 19, 6 SAY "Entrada_: "
      @ 19,26 SAY "Sa¡da___: "
      @ 19,46 SAY "Custo M‚dio: "
      SETCOLOR(vcr)
      @  9,14 SAY codi   PICTURE "@R 9.99.999"
      @  9,23 SAY nome   PICTURE "@!"
      @ 11,12 SAY saldo  PICTURE "@E 999,999.99"
      @ 11,39 SAY saldod PICTURE "@E 999,999.99"
      @ 11,63 SAY unid   PICTURE "@!"
      @ 13,23 SAY custr  PICTURE "@E 999,999,999.99"
      @ 13,65 SAY datcu
      @ 15,23 SAY precr  PICTURE "@E 999,999,999.99"
      @ 15,65 SAY datcr
      @ 17,18 SAY (precr/custr-1)*100 PICTURE "@E 9999.99"
      @ 17,38 SAY cusus  PICTURE "@E 999,999.99"
      @ 17,63 SAY preus  PICTURE "@E 999,999.99"
      @ 19,16 SAY datue
      @ 19,36 SAY datus
      @ 19,59 SAY custm  PICTURE "@E 999,999,999.99"
      DO WHILE .T.
         SETCOLOR(vcf)
         vmarg:=(precr/custr-1)*100
         @ 13,23 GET custr PICTURE "@E 999,999,999.99"
         @ 13,65 GET datcu
         @ 15,65 GET datcr
         @ 17,18 GET vmarg PICTURE "@E 9999.99"
         SETCOLOR(vcn)
         Aviso(24,"Atualize o Custo e a Margem")
         Le()
         Prod->precr:=Prod->custr*(1+vmarg/100)
         SETCOLOR(vcr)
         @ 17,38 SAY cusus PICTURE "@E 999,999.99"
         @ 17,63 SAY preus PICTURE "@E 999,999.99"
         SETCOLOR(vcf)
         @ 15,23 GET precr PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         Aviso(24,"Fa‡a o Arredondamento Desejado no Pre‡o de Venda")
         Le()
         vmarg:=(Prod->precr/Prod->custr-1)*100
         Prod->cusus:=Dolar(Prod->datcu,Prod->custr)
         Prod->preus:=Dolar(Prod->datcr,Prod->precr)
         SETCOLOR(vcr)
         @ 15,23 SAY precr PICTURE "@E 999,999,999.99"
         @ 17,18 SAY vmarg PICTURE "@E 9999.99"
         @ 17,38 SAY cusus PICTURE "@E 999,999.99"
         @ 17,63 SAY preus PICTURE "@E 999,999.99"
         SETCOLOR(vcn)
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ELSE
      // Salva a tela.
      vtela:=SAVESCREEN(01,00,24,79)
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
      @ 15,12 SAY "[Home]  - Retorna para o In¡cio do Registro"
      @ 16,12 SAY "[End]   - Avan‡a para o Fim do Registro"
      @ 17,12 SAY "[Enter] - Visualiza o Produto na Tela"
      @ 18,12 SAY "[Esc]   - Finaliza"
      @ 19,12 SAY "[F5]    - Pesquisa pelo C¢digo do Produto"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Produto"
      @ 21,12 SAY "[Ins]   - Reajustar Custo e Pre‡o do Produto"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Atufor()
// Atualiza‡„o de Pre‡os e Custos por Fornecedor.
********************************************************************************
Sinal("PRODUTOS","CUSTOS")
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
IF FILE("SAOFOR.DBF")
   SELECT 2
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1.NTX, SAOFOR2.NTX
ELSE
   Mensagem("Arquivo de Dados N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPXF.DBF")
   SELECT 3
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF2.NTX
ELSE
   Mensagem("Arquivo de Dados N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
// Cria os vetores para a fun‡„o DBEDIT().
PRIVATE vdado[13],vmask[13],vcabe[13]
// vdado: vetor dos nomes dos campos
vdado[01]:="Prod->custr"
vdado[02]:="Prod->datcu"
vdado[03]:="Prod->precr"
vdado[04]:="Prod->datcr"
vdado[05]:="IF(Prod->custr#0 .AND. Prod->precr#0,(Prod->precr/Prod->custr-1)*100,0)"
vdado[06]:="Prod->custm"
vdado[07]:="Prod->cusus"
vdado[08]:="Prod->preus"
vdado[09]:="Prod->saldo"
vdado[10]:="Prod->saldod"
vdado[11]:="Prod->saldo+Prod->saldod"
vdado[12]:="Prod->datue"
vdado[13]:="Prod->datus"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="@E 999,999,999.99"
vmask[03]:="@E 999,999,999.99"
vmask[05]:="@E 9,999.99"
vmask[06]:="@E 999,999,999.99"
vmask[07]:="@E 999,999.99"
vmask[08]:="@E 999,999.99"
vmask[09]:="@E 999,999.99"
vmask[10]:="@E 999,999.99"
vmask[11]:="@E 999,999.99"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Custo Cr$"
vcabe[02]:="Reajuste"
vcabe[03]:="Pre‡o Cr$"
vcabe[04]:="Reajuste"
vcabe[05]:="Margem %"
vcabe[06]:="Custo M‚dio"
vcabe[07]:="Custo US$"
vcabe[08]:="Pre‡o US$"
vcabe[09]:="Saldo Loja"
vcabe[10]:="Saldo Dep¢sito"
vcabe[11]:="Saldo Total"
vcabe[12]:="Ultima Entrada"
vcabe[13]:="Ultima Sa¡da"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 C¢digo  F6 Nome  [Ins] Reajuste  [Enter] Visualiza  [Esc] Fim",78)
SETCOLOR(vcn)
@ 05,01 SAY REPLICATE("Ä",78)
DBEDIT(06,01,22,78,vdado,"Fctofor",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fctofor(modo)
// Fun‡„o para Consulta com DBEDIT()
********************************************************************************
SETCOLOR(vcn)
@ 03,03 SAY "Produto___:"
@ 04,03 SAY "Fornecedor:"
SETCOLOR(vca)
@ 03,15 SAY Prod->codi PICTURE "@R 9.99.999"
@ 03,24 SAY Prod->nome
SELECT Forne
SEEK Pxf->codfor
@ 04,15 SAY Forne->codi
@ 04,24 SAY Forne->nome
SELECT Pxf
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
      vcodi:=SPACE(5)
      @ 24,20 SAY "C¢digo do Fornecedor Desejado: " GET vcodi PICTURE "99999"
      Le()
      IF EMPTY(vcodi)
         RETURN(2)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vcodi
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, C¢digo N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      @ 24,00 CLEAR
      SET ORDER TO 1
      vnome:=SPACE(40)
      @ 24,10 SAY "Fornecedor Desejado: " GET vnome PICTURE "@!"
      Le()
      IF EMPTY(vnome)
         RETURN(2)
      ENDIF
      vreg:=RECNO()
      SELECT Forne
      SET ORDER TO 2
      SET SOFTSEEK ON
      SEEK TRIM(vnome)
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Fornecedor N„o Encontrado !",3,1)
         SET ORDER TO 1
         SELECT Pxf
         RETURN(2)
      ELSE
         vcodi:=Forne->codi
         SET ORDER TO 1
         SELECT Pxf
         SEEK vcodi
         IF !FOUND()
             Mensagem("Desculpe, Fornecedor N„o Encontrado !",3,1)
             GO vreg
             RETURN(2)
         ENDIF
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_ENTER
      // Pressionada a tecla <Enter>
      // Visualiza o produto.
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      Abrejan(2)
      SETCOLOR(vcn)
      @ 04,03 SAY "C¢digo: "
      @ 04,20 SAY "Nome: "
      @ 06,03 SAY "Unidade: "
      @ 06,24 SAY "Custo: "
      @ 06,48 SAY "Pre‡o de Venda: "
      @ 08,03 SAY "Descri‡„o____________: "
      @ 11,03 SAY "Margem % :"
      @ 13,03 SAY "Custo Unit rio US$: "
      @ 13,50 SAY "Porcentagem de IPI "
      @ 15,03 SAY "Quant.Pedida: "
      @ 15,28 SAY "Prazo: "
      @ 15,50 SAY "Porcentagem de ICMS:"
      @ 17,03 SAY "Estoque M¡mino_: "
      @ 17,30 SAY "Saldo Inicial: "
      @ 17,55 SAY "Saldo Atual: "
      @ 19,03 SAY "Data da Ultima Entrada__: "
      @ 19,44 SAY "Data da Ultima Sa¡da__: "
      @ 21,03 SAY "Custo M‚dio: "
      @ 21,30 SAY "Class. Fiscal: "
      @ 21,58 SAY "Reajuste: "
      SETCOLOR(vcr)
      @ 04,11 SAY Prod->codi  PICTURE "@R 9.99.999"
      @ 04,26 SAY Prod->nome  PICTURE "@!"
      @ 06,12 SAY Prod->unid  PICTURE "@!"
      @ 06,31 SAY Prod->custr PICTURE "@E 9,999,999.99"
      @ 06,64 SAY Prod->precr PICTURE "@E 9,999,999.99"
      @ 08,26 SAY Prod->desc1 PICTURE "@!"
      @ 09,26 SAY Prod->desc2 PICTURE "@!"
      @ 10,26 SAY Prod->desc3 PICTURE "@!"
      @ 11,14 SAY IF(Prod->custr#0 .AND. Prod->precr#0,(Prod->precr/Prod->custr-1)*100,0) PICTURE "@E 9,999.99"
      @ 11,26 SAY Prod->desc4 PICTURE "@!"
      @ 13,23 SAY Prod->cusus PICTURE "@E 9,999,999.99"
      @ 13,71 SAY Prod->pipi  PICTURE "@E 99.99"
      @ 15,17 SAY Prod->pedid PICTURE "@E 9,999.99"
      @ 15,35 SAY Prod->prazo PICTURE "@!"
      @ 15,71 SAY Prod->picms PICTURE "99.99"
      @ 17,20 SAY Prod->estmi PICTURE "@E 9,999.99"
      @ 17,45 SAY Prod->saldi+Prod->saldid PICTURE "@E 9,999.99"
      @ 17,68 SAY Prod->saldo+Prod->saldod PICTURE "@E 9,999.99"
      @ 19,29 SAY Prod->datue PICTURE "99/99/99"
      @ 19,68 SAY Prod->datus PICTURE "99/99/99"
      @ 21,16 SAY Prod->custm PICTURE "@E 9,999,999.99"
      @ 21,45 SAY Prod->clfis PICTURE "9999.99.9999"
      @ 21,68 SAY Prod->datcr PICTURE "99/99/99"
      SETCOLOR(vcr)
      @ 23,01 SAY PADC("Pressione uma Tecla para Continuar...",78)
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ELSEIF LASTKEY()=K_INS
      // Pressionada a tecla <Ins>
      // Atualiza o Custo e o Pre‡o
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      SETCOLOR(vcn)
      @ 07, 04 CLEAR TO 21,74
      @ 07, 04 TO 21, 74 DOUBLE  // Apresenta a moldura
      @  9, 6 SAY "C¢digo: "
      @ 11, 6 SAY "Loja: "
      @ 11,29 SAY "Dep¢sito: "
      @ 11,54 SAY "Unidade: "
      @ 13, 6 SAY "Custo Reposi‡„o: "
      @ 13,48 SAY "Ultimo Reajuste: "
      @ 15, 6 SAY "Pre‡o de Venda_: "
      @ 15,48 SAY "Ultimo Reajuste: "
      @ 17,06 SAY "Margem (%):"
      @ 17,27 SAY "Custo US$:"
      @ 17,52 SAY "Pre‡o US$:"
      @ 19, 6 SAY "Entrada_: "
      @ 19,26 SAY "Sa¡da___: "
      @ 19,46 SAY "Custo M‚dio: "
      SETCOLOR(vcr)
      @  9,14 SAY Prod->codi       PICTURE "@R 9.99.999"
      @  9,23 SAY Prod->nome       PICTURE "@!"
      @ 11,12 SAY Prod->saldo      PICTURE "@E 999,999.99"
      @ 11,39 SAY Prod->saldod     PICTURE "@E 999,999.99"
      @ 11,63 SAY Prod->unid       PICTURE "@!"
      @ 13,23 SAY Prod->custr      PICTURE "@E 999,999,999.99"
      @ 13,65 SAY Prod->datcu
      @ 15,23 SAY Prod->precr       PICTURE "@E 999,999,999.99"
      @ 15,65 SAY Prod->datcr
      @ 17,18 SAY (Prod->precr/Prod->custr-1)*100 PICTURE "@E 9999.99"
      @ 17,38 SAY Prod->cusus      PICTURE "@E 999,999.99"
      @ 17,63 SAY Prod->preus      PICTURE "@E 999,999.99"
      @ 19,16 SAY Prod->datue
      @ 19,36 SAY Prod->datus
      @ 19,59 SAY Prod->custm      PICTURE "@E 999,999,999.99"
      SETCOLOR(vcn)
      DO WHILE .T.
         vmarg:=(Prod->precr/Prod->custr-1)*100
         @ 13,23 GET Prod->custr PICTURE "@E 999,999,999.99"
         @ 13,65 GET Prod->datcu
         @ 15,65 GET Prod->datcr
         @ 17,18 GET vmarg PICTURE "@E 9999.99"
         Aviso(24,"Atualize o Custo e a Margem")
         Le()
         Prod->precr:=Prod->custr*(1+vmarg/100)
         Prod->cusus:=Dolar(Prod->datcu,Prod->custr)
         Prod->preus:=Dolar(Prod->datcr,Prod->precr)
         SETCOLOR(vcr)
         @ 15,23 SAY Prod->precr      PICTURE "@E 999,999,999.99"
         @ 17,38 SAY Prod->cusus      PICTURE "@E 999,999.99"
         @ 17,63 SAY Prod->preus      PICTURE "@E 999,999.99"
         SETCOLOR(vcn)
         IF Confirme()
            EXIT
         ENDIF
      ENDDO
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ELSE
      // Salva a tela.
      vtela:=SAVESCREEN(01,00,24,79)
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
      @ 15,12 SAY "[Home]  - Retorna para o In¡cio do Registro"
      @ 16,12 SAY "[End]   - Avan‡a para o Fim do Registro"
      @ 17,12 SAY "[Enter] - Visualiza o Produto na Tela"
      @ 18,12 SAY "[Esc]   - Finaliza"
      @ 19,12 SAY "[F5]    - Pesquisa pelo C¢digo do Fornecedor"
      @ 20,12 SAY "[Ins]   - Reajustar Custo e Pre‡o do Produto"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Fornecust()
// Atualizas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("FORNECEDOR","ATUALIZA€ŽO")
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
IF FILE("SAOPXF.DBF")
   SELECT 2
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 3
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Pxf
SET ORDER TO 2
SET RELATION TO codpro INTO Prod
SELECT Forne
// Cria os vetores para a fun‡„o DBEDIT().
PRIVATE vdado[4],vmask[4],vcabe[4]
// vdado: vetor dos nomes dos campos
vdado[01]:="codi"
vdado[02]:="nome"
vdado[03]:="razao"
vdado[04]:="cont"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="99999"
vmask[02]:="@!"
vmask[03]:="!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
vmask[04]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Raz„o Social"
vcabe[04]:="Contato"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 C¢digo  F6 Nome  [Enter] Produtos  [Esc] Fim",78)
SETCOLOR(vcn)
DBEDIT(03,01,22,78,vdado,"Faforne",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Faforne(modo)
// Fun‡„o para Consulta com DBEDIT()
********************************************************************************
LOCAL i
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
      vcodi:=SPACE(5)
      @ 24,20 SAY "C¢digo Desejado: " GET vcodi PICTURE "99999"
      Le()
      IF EMPTY(vcodi)
         RETURN(2)
      ENDIF
      vcodi:=Zeracod(vcodi)
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vcodi
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, C¢digo N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      @ 24,00 CLEAR
      SET ORDER TO 2
      vnome:=SPACE(20)
      @ 24,12 SAY "Nome Desejado: " GET vnome PICTURE "@!"
      Le()
      IF EMPTY(vnome)
         RETURN(2)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vnome
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Nome N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_ENTER
      // Pressionada a tecla <Enter>
      // Mostra os produtos do fornecedor.
      vcodi:=Forne->codi
      SELECT Pxf
      SEEK vcodi
      IF !FOUND()
         Mensagem("N„o H  Produtos Cadastrados para Este Fornecedor!",8,1)
         SELECT Forne
         RETURN(1)
      ELSE
         // Salva a tela.
         vtela:=SAVESCREEN(01,00,24,79)
         @ 03,01 CLEAR TO 22,78
         @ 03,02 SAY "Fornecedor: "
         SETCOLOR(vca)
         @ 03,15 SAY Pxf->codfor
         @ 03,22 SAY Forne->nome
         @ 03,44 SAY Forne->telf
         SETCOLOR(vcn)
         @ 04,01 SAY REPLICATE("Ä",78)
         DO WHILE Pxf->codfor=vcodi .AND. !EOF()
            @ 05,01 SAY "C¢digo               Nome do Produto               Custo Repos.    Pre‡o Venda"
            @ 06,01 SAY REPLICATE("Ä",78)
            i:=7
            DO WHILE ROW()<=22 .AND. Pxf->codfor=vcodi .AND. !EOF()
               @ i,01 SAY Pxf->codpro PICTURE "@R 9.99.999"
               @ i,10 SAY LEFT(Prod->nome,40)
               @ i,51 SAY Prod->custr PICTURE "@E 99,999,999.99"
               @ i,66 SAY Prod->precr PICTURE "@E 99,999,999.99"
               ++i
               SKIP
            ENDDO
            FOR i=i TO 22
                @ i,01 SAY SPACE(78)
            NEXT
            SETCOLOR(vcr)
            @ 23,01 SAY PADC(" [PgUp] Retorna  [PgDn] Avan‡a  [Enter] Atualiza  [Esc] Finaliza ",78)
            SETCOLOR(vcn)
            DO WHILE .T.
               // Aguarda o pressionamento de uma tecla de controle pelo usuario.
               tk:=INKEY(0)
               IF tk=K_PGUP
                  SKIP -30
                  IF Pxf->codfor<>vcodi .OR. BOF()
                     // Reposiciona-se no primeiro produto do fornecedor.
                     SEEK vcodi
                  ENDIF
                  EXIT
               ELSEIF tk=K_PGDN
                  // Foi pressionada a tecla <Pg Dn>.
                  // Avan‡a uma tela, sendo que cada tela apresenta 15 produtos.
                  IF Pxf->codfor=vcodi
                     SKIP -2
                     EXIT
                  ELSE
                     LOOP
                  ENDIF
               ELSEIF tk=K_ESC
                  // Foi pressionada a tecla <Esc>.
                  // Finaliza a apresenta‡ao dos produtos do fornecedor.
                  @ 24,00 CLEAR
                  SELECT Forne
                  // Reapresenta a tela dos fornecedores.
                  RESTSCREEN(01,00,24,79,vtela)
                  RETURN(1)
               ELSEIF tk=K_ENTER
                  // Corre‡„o dos Custos e Pre‡os dos Produtos do Fornecedor.
                  @ 24,00 CLEAR
                  vind:=0.00
                  vdata=DATE()
                  @ 24,03 SAY "Digite o Indice % de Corre‡„o:" GET vind PICTURE "99.99"
                  @ 24,41 SAY "Digite a Data da Corre‡„o:" GET vdata VALID !EMPTY(vdata)
                  Le()
                  SELECT Pxf
                  SEEK vcodi
                  vrec:=RECNO()
                  IF vind<=0
                     GO vrec
                     EXIT
                  ENDIF
                  @ 24,00 CLEAR
                  SETCOLOR(vcp)
                  Aviso(24,"Aguarde, Corrigindo Custos e Pre‡os do Fornecedor...")
                  SETCOLOR(vcn)
                  // Atualiza‡„o do Arquivo dos Produtos x Fornecedor.
                  DO WHILE Pxf->codfor=vcodi .AND. !EOF()
                     Prod->custr:=Prod->custr*(1+(vind/100))
                     Prod->precr:=ROUND(Prod->precr*(1+(vind/100)),-2)
                     Prod->datcr:=Prod->datcu:=vdata
                     Prod->cusus:=Dolar(vdata,Prod->custr)
                     Prod->preus:=Dolar(vdata,Prod->precr)
                     SKIP
                  ENDDO
                  @ 24,00 CLEAR
                  GO vrec
                  EXIT
               ENDIF
            ENDDO
         ENDDO
         RESTSCREEN(01,00,24,79,vtela)
         SELECT Forne
         RETURN(1)
      ENDIF
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
      @ 15,12 SAY "[Home]  - Retorna para o In¡cio do Registro"
      @ 16,12 SAY "[End]   - Avan‡a para o Fim do Registro"
      @ 17,12 SAY "[Enter] - Apresenta os Produtos Fornecidos pelo Fornecedor."
      @ 18,12 SAY "[Esc]   - Finaliza"
      @ 19,12 SAY "[F5]    - Pesquisa pelo C¢digo do Fornecedor"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Fornecedor"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,23,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
/*
C¢digo               Nome do Produto               Custo Repos.    Pre‡o Venda
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99,999,999.99  99,999,999.99
*/
********************************************************************************
PROCEDURE Indcust(tipo,modo)
/* Objetivo  : corre‡„o do Custo dos Produtos.
   Parametros: tipo 1 -> corre‡„o pelo d¢lar
                    2 -> corre‡„o pelo ¡ndice
               modo 1 -> por produto
               modo 2 -> por fornecedor
*/
********************************************************************************
Sinal("CUSTOS","CORRE€ŽO")
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
IF FILE("SAOPXF.DBF")
   SELECT 2
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF2.NTX
ELSE
   Mensagem("Arquivo de Dados N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF tipo=1
   IF FILE("SAOUS.DBF")
      SELECT 3
      USE SAOUS ALIAS Indice
      IF !FILE("SAOUS1.NTX")
         Indexa()
      ENDIF
      SET INDEX TO SAOUS1.NTX
   ELSE
      Mensagem("Arquivo do D¢lar N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
ELSEIF tipo=2
   IF FILE("SAOIND.DBF")
      SELECT 3
      USE SAOIND ALIAS Indice
      IF !FILE("SAOIND1.NTX")
         Indexa()
      ENDIF
      SET INDEX TO SAOIND1.NTX
   ELSE
      Mensagem("Arquivo do Indice N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
ENDIF
IF modo=1
   SELECT Prod
   vcodi:=vcodf:=SPACE(6)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujos produtos devem ser processados.
   Pesqint(6,"@R 9.99.999","C¢digos de Produtos")
ELSE
   SELECT Pxf
   SET RELATION TO codpro INTO Prod
   vcodi:=vcodf:=SPACE(5)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujos produtos devem ser processados.
   Pesqint(5,"99999","C¢digos de Fornecedores")
ENDIF
Abrejan(2)
SELECT Indice
GO BOTTOM
vcot:=Indice->valor
vdti:=Indice->data
SETCOLOR(vcp)
Aviso(11,"A g u a r d e ...")
SETCOLOR(vcn)
IF modo=1
   SELECT Prod
   SET SOFTSEEK ON
   SEEK vcodi
   SET SOFTSEEK OFF
   DO WHILE Prod->codi<=vcodf .AND. !EOF()
      IF !EMPTY(Prod->datcr)
         vdat:=Prod->datcr
      ELSEIF !EMPTY(Prod->datue)
         vdat:=Prod->datue
      ELSEIF !EMPTY(Prod->datus)
         vdat:=Prod->datus
      ELSE
         vdat:=DATE()
      ENDIF
      vcod:=Prod->codi
      Aviso(13,"Produto C¢digo: "+TRANSFORM(vcod,"@R 9.99.999"))
      SELECT Indice
      SET SOFTSEEK ON
      SEEK vdat
      SET SOFTSEEK OFF
      IF !EOF()
         vind:=vcot/Indice->valor
      ELSE
         vind:=1.000
      ENDIF
      // Atualizacao dos custos e precos.
      SELECT Prod
      Prod->custr:=Prod->custr*vind
      Prod->precr:=ROUND(Prod->precr*vind,-2)
      Prod->datcr:=Prod->datcu:=vdti
      IF tipo=1
         Prod->cusus:=Prod->custr/vcot
         Prod->preus:=Prod->precr/vcot
      ELSE
         Prod->cusus:=Dolar(vdti,Prod->custr)
         Prod->preus:=Dolar(vdti,Prod->precr)
      ENDIF
      SKIP
   ENDDO
ELSE
   SELECT Pxf
   SET SOFTSEEK ON
   SEEK vcodi
   SET SOFTSEEK OFF
   DO WHILE Pxf->codfor<=vcodf .AND. !EOF()
      IF !EMPTY(Prod->datcr)
         vdat:=Prod->datcr
      ELSEIF !EMPTY(Prod->datue)
         vdat:=Prod->datue
      ELSEIF !EMPTY(Prod->datus)
         vdat:=Prod->datus
      ELSE
         vdat:=DATE()
      ENDIF
      vcod:=Prod->codi
      Aviso(13,"Produto C¢digo: "+TRANSFORM(vcod,"@R 9.99.999"))
      SELECT Indice
      SET SOFTSEEK ON
      SEEK vdat
      SET SOFTSEEK OFF
      IF !EOF()
         vind:=vcot/Indice->valor
      ELSE
         vind:=1.000
      ENDIF
      // Atualizacao dos custos e precos.
      SELECT Pxf
      Prod->custr:=Prod->custr*vind
      Prod->precr:=ROUND(Prod->precr*vind,-2)
      Prod->datcr:=Prod->datcu:=vdti
      IF tipo=1
         Prod->cusus:=Prod->custr/vcot
         Prod->preus:=Prod->precr/vcot
      ELSE
         Prod->cusus:=Dolar(vdti,Prod->custr)
         Prod->preus:=Dolar(vdti,Prod->precr)
      ENDIF
      SKIP
   ENDDO
ENDIF
CLOSE DATABASE
Mensagem("Fim da Corre‡„o dos Custos dos Produtos !",6)
RETURN
********************************************************************************
PROCEDURE Medcust()
// C lculo do custo m‚dio dos produtos.
********************************************************************************
Sinal("CUSTO","MEDIO")
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
vcodi:=vcodf:=SPACE(6)
SET ORDER TO 1
// Pesquisa a faixa de codigos cujos produtos devem ser processados.
Pesqint(6,"@R 9.99.999","C¢digos de Produtos")
Abrejan(2)
SETCOLOR(vcp)
Aviso(8,"A g u a r d e ...")
SETCOLOR(vca)
Aviso(10,"C lculo do Custo M‚dio dos Produtos !")
SETCOLOR(vcn)
SELECT Prod
SET SOFTSEEK ON
SEEK vcodi
SET SOFTSEEK OFF
@ 13,27 SAY "Produto: "
@ 15,27 SAY "Data___: "
@ 17,27 SAY "Compra_: "
DO WHILE Prod->codi<=vcodf .AND. !EOF()
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
Mensagem("Fim dos C lculos do Custo M‚dio !",10)
RETURN
********************************************************************************
//                                    F I M
********************************************************************************
