********************************************************************************
/* Programa.: SAOPRO.PRG
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Produtos. */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Matprod(modo)
/* Gerenciador de PRODUTOS
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("PRODUTOS","INCLUSŽO")
ELSEIF modo=2
   Sinal("PRODUTOS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("PRODUTOS","EXCLUSŽO")
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1.NTX, SAOPRO2.NTX
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPRO.DBF")
   SELECT 2
   USE SAOTPRO ALIAS TPro
   IF !FILE("SAOTPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPRO1.NTX, SAOTPRO2.NTX
ELSE
   Mensagem("Arquivo de Fam¡lia de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPXF.DBF")
   SELECT 3
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1.NTX, SAOPXF2.NTX
ELSE
   Mensagem("Arquivo de Produtos x Fornecedor N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Prod
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vcodi :=SPACE(6)
   vnome :=SPACE(50)
   vunid :=SPACE(10)
   vprazo:=vclfis:=SPACE(12)
   vdesc1:=vdesc2:=vdesc3:=vdesc4:=SPACE(50)
   vpipi:=vpicms:=vestmi:=vprecr:=vsaldi:=vsaldid:=0
   vdatcr:=vdatcu:=CTOD(SPACE(8))
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   IF modo=1
      vcodi:=SPACE(3)
      @ 4,23 GET vcodi PICTURE "@R 9.99."
      Aviso(24,"Digite o Grupo do Produto, ou Tecle [Esc] para Finalizar")
      Le()
      IF LASTKEY()=K_ESC
         CLOSE DATABASE
         RETURN
      ENDIF
      SELECT Tpro
      SEEK vcodi
      IF !FOUND()
         GO TOP
         vcodi:=Acha(vcodi,"Tpro",1,2,"codi","nome","@R 9.99","@!",15,15,22,76)
         IF EMPTY(vcodi)
            LOOP
         ENDIF
      ENDIF
      SETCOLOR(vcr)
      @ 4,23 SAY vcodi PICTURE "@R 9.99."
      SETCOLOR(vcn)
      vcodpro:=SPACE(3)
      @ 4,28 GET vcodpro PICTURE "999"
      Aviso(24,"Digite o C¢digo do Produto, ou Tecle [Esc] para Finalizar")
      Le()
      SETCOLOR(vcr)
      @ 4,28 SAY vcodpro PICTURE "999"
      SETCOLOR(vcn)
      IF LASTKEY()=K_ESC .OR. EMPTY(vcodpro)
         CLOSE DATABASE
         RETURN
      ENDIF
      vcodi:=vcodi+vcodpro
   ELSE
      vcodi:=SPACE(6)
      @ 4,23 GET vcodi PICTURE "@R 9.99.999"
      Aviso(24,"Digite o C¢digo do Produto, ou Tecle [Esc] para Finalizar")
      Le()
      IF LASTKEY()=K_ESC
         CLOSE DATABASE
         RETURN
      ENDIF
      SELECT Prod
      SET SOFTSEEK ON
      SEEK vcodi
      SET SOFTSEEK OFF
      IF !FOUND()
         IF EOF()
            GO TOP
         ENDIF
         vcodi:=Acha(vcodi,"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
         IF EMPTY(vcodi)
            LOOP
         ENDIF
      ENDIF
      SETCOLOR(vcr)
      @ 4,23 SAY vcodi PICTURE "@R 9.99.999"
      SETCOLOR(vcn)
   ENDIF
   SELECT Prod
   SEEK vcodi
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Produto N„o Encontrado !",8,1)
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
         Aviso(24,"Digite os Dados do Produto")
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
         Prod->codi:=vcodi
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Atualiza()
   ELSE
      IF Exclui()
         // Deleta o registro do arquivo.
         DELETE
         SELECT Pxf
         SEEK vcodi
         DELETE WHILE codpro=vcodi
         SELECT Prod
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
@  4, 9 SAY "C¢digo______: "
@  6, 9 SAY "Nome________: "
@  8, 9 SAY "Descri‡„o___: "
@ 13, 9 SAY "Unidade_____: "
@ 13,39 SAY "Classifica‡„o Fiscal: "
@ 15, 9 SAY "Porcentagem ICMS: "
@ 15,51 SAY "Porcentagem IPI: "
@ 17, 9 SAY "Prazo M‚dio de Entrega: "
@ 17,46 SAY "Estoque M¡mimo_:"
@ 19, 9 SAY "Pre‡o de Venda: "
@ 19,46 SAY "Estoque Inicial:" 
@ 21,09 SAY "Reajuste de Pre‡o:"
@ 21,46 SAY "Reajuste de Custo:"
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  4,23 SAY vcodi       PICTURE "@R 9.99.999"
@  6,23 SAY vnome       PICTURE "@!"
@  8,23 SAY vdesc1      PICTURE "@!"
@  9,23 SAY vdesc2      PICTURE "@!"
@ 10,23 SAY vdesc3      PICTURE "@!"
@ 11,23 SAY vdesc4      PICTURE "@!"
@ 13,23 SAY vunid       PICTURE "@!"
@ 13,61 SAY vclfis      PICTURE "9999.99.9999"
@ 15,27 SAY vpicms      PICTURE "@E 99.99"
@ 15,68 SAY vpipi       PICTURE "@E 99.99"
@ 17,33 SAY vprazo      PICTURE "@!"
@ 17,63 SAY vestmi      PICTURE "@E 999,999.99"
@ 19,25 SAY vprecr      PICTURE "@E 999,999,999.99"
@ 19,63 SAY vsaldi+vsaldid  PICTURE "@E 999,999.99"
@ 21,28 SAY vdatcr
@ 21,65 SAY vdatcu
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@  4,23 SAY vcodi PICTURE "@R 9.99.999"
SETCOLOR(vcn)
@  6,23 GET vnome       PICTURE "@!"
@  8,23 GET vdesc1      PICTURE "@!"
@  9,23 GET vdesc2      PICTURE "@!"
@ 10,23 GET vdesc3      PICTURE "@!"
@ 11,23 GET vdesc4      PICTURE "@!"
@ 13,23 GET vunid       PICTURE "@!"
@ 13,61 GET vclfis      PICTURE "9999.99.9999"
@ 15,27 GET vpicms      PICTURE "@E 99.99"
@ 15,68 GET vpipi       PICTURE "@E 99.99"
@ 17,33 GET vprazo      PICTURE "@!"
@ 17,63 GET vestmi      PICTURE "@E 999,999.99"
@ 19,25 GET vprecr      PICTURE "@E 999,999,999.99"
@ 21,28 GET vdatcr
@ 21,65 GET vdatcu
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vcodi :=Prod->codi
vnome :=Prod->nome
vunid :=Prod->unid
vpipi :=Prod->pipi
vpicms:=Prod->picms
vdesc1:=Prod->desc1
vdesc2:=Prod->desc2
vdesc3:=Prod->desc3
vdesc4:=Prod->desc4
vprazo:=Prod->prazo
vestmi:=Prod->estmi
vclfis:=Prod->clfis
vdatcr:=Prod->datcr
vdatcu:=Prod->datcu
vprecr:=Prod->precr
vsaldi:=Prod->saldi
vsaldid:=Prod->saldid
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Prod->nome :=vnome
Prod->unid :=vunid
Prod->pipi :=vpipi
Prod->desc1:=vdesc1
Prod->desc2:=vdesc2
Prod->desc3:=vdesc3
Prod->desc4:=vdesc4
Prod->prazo:=vprazo
Prod->picms:=vpicms
Prod->estmi:=vestmi
Prod->clfis:=vclfis
Prod->datcr:=vdatcr
Prod->datcu:=vdatcu
Prod->precr:=vprecr
Prod->preus:=Dolar(vdatcr,vprecr)
RETURN
********************************************************************************
PROCEDURE Consprod()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("PRODUTOS","CONSULTA")
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
SET RELATION TO codfor INTO Forne
SELECT Prod
// Cria os vetores para a fun‡„o DBEDIT().
PRIVATE vdado[21],vmask[21],vcabe[21]
// vdado: vetor dos nomes dos campos
vdado[01]:="custr"
vdado[02]:="precr"
vdado[03]:="IF(custr#0 .AND. precr#0,(precr/custr-1)*100,0)"
vdado[04]:="cusus"
vdado[05]:="preus"
vdado[06]:="pedid"
vdado[07]:="estmi"
vdado[08]:="saldi+saldid"
vdado[09]:="saldo"
vdado[10]:="saldod"
vdado[11]:="saldo+saldod"
vdado[12]:="unid"
vdado[13]:="datue"
vdado[14]:="datus"
vdado[15]:="datcr"
vdado[16]:="datcu"
vdado[17]:="custm"
vdado[18]:="prazo"
vdado[19]:="picms"
vdado[20]:="pipi"
vdado[21]:="clfis"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[01]:="@E 999,999,999.99"
vmask[02]:="@E 999,999,999.99"
vmask[03]:="@E 9,999.99"
vmask[04]:="@E 999,999,999.99"
vmask[05]:="@E 999,999,999.99"
vmask[06]:="@E 999,999.99"
vmask[07]:="@E 999,999.99"
vmask[08]:="@E 999,999.99"
vmask[09]:="@E 999,999.99"
vmask[10]:="@E 999,999.99"
vmask[11]:="@E 999,999.99"
vmask[12]:="@!" 
vmask[17]:="@E 999,999,999.99"
vmask[18]:="@!"
vmask[19]:="@E 99.99"
vmask[20]:="@E 99.99"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[01]:="Custo Cr$"
vcabe[02]:="Pre‡o Cr$"
vcabe[03]:="Margem %"
vcabe[04]:="Custo US$"
vcabe[05]:="Pre‡o US$"
vcabe[06]:="Qtd.Pedida"
vcabe[07]:="Estoque M¡nimo"
vcabe[08]:="Saldo Inicial"
vcabe[09]:="Saldo Loja"
vcabe[10]:="Saldo Dep¢sito"
vcabe[11]:="Saldo Total"
vcabe[12]:="Unidade"
vcabe[13]:="Ultima Entrada"
vcabe[14]:="Ultima Sa¡da"
vcabe[15]:="Reajuste Pre‡o"
vcabe[16]:="Reajuste Custo"
vcabe[17]:="Custo M‚dio"
vcabe[18]:="Prazo Entrega"
vcabe[19]:="ICMS %"
vcabe[20]:="IPI %"
vcabe[21]:="Class.Fiscal"
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 Produto  F6 Nome  F9 Fornecedores  [Enter] Visualiza  [Esc] Fim",78)
SETCOLOR(vcn)
@ 04,01 SAY REPLICATE("Ä",78)
DBEDIT(05,01,22,78,vdado,"Fpro",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fpro(modo)
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
      @ 24,20 SAY "C¢digo Desejado: " GET vcodi PICTURE "@R 9.99.999"
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
   ELSEIF LASTKEY()=K_F9
      // Pressionada a tecla <F9>
      // Mostra os fornecedores do produto.
      vcodi:=Prod->codi
      SELECT Pxf
      SEEK vcodi
      IF !FOUND()
         Mensagem("N„o H  Fornecedores Cadastrados para Este Produto!",8,1)
         SELECT Prod
         RETURN(1)
      ELSE
         vtela:=SAVESCREEN(05,00,24,79)  // Salva a tela.
         @ 05,01 CLEAR TO 22,78
         @ 05,02 SAY "Referˆncia               F o r n e c e d o r                      P r e ‡ o"
         @ 06,01 SAY REPLICATE("Ä",78)
         DO WHILE ROW()<=22 .AND. Pxf->codpro=vcodi .AND. !EOF()
            @ ROW()+1,02 SAY Pxf->codpxf
            @ ROW()  ,13 SAY Forne->nome
            @ ROW()  ,64 SAY Pxf->preco PICTURE "@E 999,999,999.99"
            SKIP
         ENDDO
         SETCOLOR(vcr)
         @ 23,01 SAY PADC("Digite Qualquer Tecla para Continuar",78)
         SETCOLOR(vcn)
         INKEY(0)
         RESTSCREEN(05,00,24,79,vtela)
         SELECT Prod
         RETURN(1)
      ENDIF
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
      @ 13,03 SAY "Custo Unitario US$: "
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
      @ 13,23 SAY Prod->preus PICTURE "@E 9,999,999.99"
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
   ELSE
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
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
      @ 21,12 SAY "[F9]    - Mostra os Fornecedores do Produto"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
********************************************************************************
PROCEDURE Relprod1(tipo,ordem)
/*
Objetivo  : emite os relat¢rios basicos dos produtos.
Parƒmetros: tipo:  1 -> resumido
                   2 -> anal¡tico
            ordem: 1 -> c¢digo
                   2 -> nome
*/
********************************************************************************
LOCAL vtot[3],vgru[6]
// Atualiza a linha de status.
Sinal("PRODUTOS","RELATORIO")
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1, SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF ordem=1
   vcodi:=vcodf:=SPACE(6)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(6,"@R 9.99.999","C¢digos de Produtos")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Codigo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Produtos")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
IF !Imprime("Relat¢rio dos Produtos")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
AFILL(vtot,0)           // Totalizadores gerais.
AFILL(vgru,0)           // Totalizadores do grupo.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   IF tipo=1
      // Cabecalho do Relat¢rio resumido.
      Cabe(emp[2],vsist,"RELATORIO RESUMIDO DOS PRODUTOS",vtit,132,vcia20)
      @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                     UNIDADE     LOJA    DEPOSITO SALDO TOTAL CUSTO UNITARIO PRECO DE VENDA"
      @ PROW()+1,00 SAY REPLICATE("-",132)
   ELSEIF tipo=2
      // Cabecalho do Relat¢rio completo.
      Cabe(emp[2],vsist,"RELATORIO COMPLETO DOS PRODUTOS",vtit,80,vcia10)
   ENDIF
   // Impressao dos dados.
   IF tipo#2
      DO WHILE PROW()<60 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
         // DO WHILE das p ginas.
         vgrupo:=LEFT(Prod->codi,3)
         DO WHILE LEFT(Prod->codi,3)=vgrupo .AND. PROW()<60 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
            // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
            IF Escprint(132)
               CLOSE DATABASE
               RETURN
            ENDIF
            // Imprime os dados do relat¢rio resumido.
            @ PROW()+1,01 SAY Prod->codi PICTURE "@R 9.99.999"
            @ PROW(),  10 SAY LEFT(Prod->nome,50)
            @ PROW(),  61 SAY LEFT(Prod->unid,7)
            @ PROW(),  69 SAY Prod->saldo PICTURE "@E 999,999.99"
            @ PROW(),  80 SAY Prod->saldod PICTURE "@E 999,999.99"
            @ PROW(),  91 SAY Prod->saldo+Prod->saldod PICTURE "@E 999,999.99"
            @ PROW(), 102 SAY Prod->custr PICTURE "@E 999,999,999.99"
            @ PROW(), 117 SAY Prod->precr PICTURE "@E 999,999,999.99"
            // Totaliza‡„o do Grupo.
            ++vgru[1]
            vgru[2]+=Prod->saldo
            vgru[3]+=Prod->saldod
            vgru[4]+=(Prod->saldo+Prod->saldod)
            vgru[5]+=(Prod->custr*(Prod->saldo+Prod->saldod))
            vgru[6]+=(Prod->precr*(Prod->saldo+Prod->saldod))
            // Totaliza‡„o Geral.
            ++vtot[1]
            vtot[2]+=(Prod->custr*(Prod->saldo+Prod->saldod))
            vtot[3]+=(Prod->precr*(Prod->saldo+Prod->saldod))
            SKIP
         ENDDO  // Fim do DO WHILE da p gina.
         IF vgrupo#LEFT(Prod->codi,3)
            @ PROW()+1,00 SAY REPLICATE("-",132)
            @ PROW()+1,01 SAY "T O T A I S   D O   G R U P O :"
            @ PROW(),  40 SAY "Itens: "+TRANSFORM(vgru[1],"@E 999,999")
            @ PROW(),  69 SAY vgru[2] PICTURE "@E 999,999.99"
            @ PROW(),  80 SAY vgru[3] PICTURE "@E 999,999.99"
            @ PROW(),  91 SAY vgru[4] PICTURE "@E 999,999.99"
            @ PROW(), 102 SAY vgru[5] PICTURE "@E 999,999,999.99"
            @ PROW(), 117 SAY vgru[6] PICTURE "@E 999,999,999.99"
            @ PROW()+1,00 SAY REPLICATE("-",132)
            AFILL(vgru,0)
         ENDIF
      ENDDO    // Fim do grupo.
   ELSEIF tipo=2
      // DO WHILE das p ginas.
      DO WHILE PROW()<55 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
         // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
         IF Escprint(80)
            CLOSE DATABASE
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio completo.
         @ PROW()+2, 03 SAY "Codigo: "+TRANSFORM(Prod->codi,"@R 9.99.999")
         @ PROW(),   20 SAY "Nome: "+Prod->nome
         @ PROW(),   11 SAY TRANSFORM(Prod->codi,"@R 9.99.999")
         @ PROW(),   26 SAY Prod->nome
         @ PROW()+1, 03 SAY "Unidade: "+Prod->unid
         @ PROW(),   27 SAY "Custo: "+TRANSFORM(Prod->custr,"@E 999,999,999.99")
         @ PROW(),   50 SAY "Preco de Venda: "+TRANSFORM(Prod->precr,"@E 999,999,999.99")
         @ PROW()+1, 03 SAY "Medio: "+TRANSFORM(Prod->custm,"@E 999,999,999.99")
         @ PROW(),   27 SAY "Custo U$:  "+TRANSFORM(Prod->cusus,"@E 999,999.99")
         @ PROW(),   50 SAY "Preco de Venda U$:  "+TRANSFORM(Prod->preus,"@E 999,999.99")
         @ PROW()+1, 03 SAY "Descricao____________: "+Prod->desc1
         FOR i=4 TO 6
            IF i=4
               @ PROW()+1,03 SAY "Margem: "+TRANSFORM(IF(Prod->custr#0 .AND. Prod->precr#0,(Prod->precr/Prod->custr-1)*100,0),"@E 99,999.99")
               @ PROW()  ,26 SAY FIELDGET(i)
            ELSE
               IF !EMPTY(FIELDGET(i))
                  @ PROW()+1,26 SAY FIELDGET(i)
               ENDIF
            ENDIF
         NEXT
         @ PROW()+1, 03 SAY "Porcentagem de ICMS: "+TRANSFORM(Prod->picms,"@E 99.99")
         @ PROW(),   30 SAY "Porcentagem de IPI: "+TRANSFORM(Prod->pipi,"@E 99.99")
         @ PROW(),   56 SAY "Quant.Pedida: "+TRANSFORM(Prod->pedid,"@E 999,999.99")
         @ PROW()+1, 03 SAY "Estoque Minimo_: "+TRANSFORM(Prod->estmi,"@E 999,999.99")
         @ PROW(),   31 SAY "Saldo Inicial: "+TRANSFORM(Prod->saldi+Prod->saldid,"@E 999,999.99")
         @ PROW(),   57 SAY "Saldo Atual: "+TRANSFORM(Prod->saldo+Prod->saldod,"@E 999,999.99")
         @ PROW()+1, 03 SAY "Data Ultima Entrada_____: "+DTOC(datue)
         @ PROW(),   48 SAY "Data Ultima Saida_____: "+DTOC(datus)
         @ PROW()+1, 03 SAY "Prazo Entrega: "+Prod->prazo
         @ PROW(),   33 SAY "Class.Fiscal: "+Prod->clfis
         @ PROW(),   62 SAY "Reajuste: "+DTOC(datcr)
         @ PROW()+1, 00 SAY REPLICATE("-",80)
         // Totaliza‡„o.
         ++vtot[1]
         vtot[2]+=(Prod->custr*(Prod->saldo+Prod->saldod))
         vtot[3]+=(Prod->precr*(Prod->saldo+Prod->saldod))
         SKIP
      ENDDO  // Fim do DO WHILE da p gina.
   ENDIF
ENDDO  // Fim do DO WHILE principal.
IF tipo#2
   @ PROW()+1,00 SAY REPLICATE("-",132)
   @ PROW()+1, 01 SAY "T  O  T  A  I  S     G  E  R  A  I  S :"
   @ PROW(),   50 SAY "Itens: "+TRANSFORM(vtot[1],"@E 999,999")
   @ PROW(),  102 SAY vtot[2] PICTURE "@E 999,999,999.99"
   @ PROW(),  117 SAY vtot[3] PICTURE "@E 999,999,999.99"
   @ PROW()+1,00 SAY REPLICATE("-",132)
ELSEIF tipo=2
   @ PROW()+1, 00 SAY "TOTAIS:"
   @ PROW(),   09 SAY "Itens: "+TRANSFORM(vtot[1],"@E 999,999")
   @ PROW(),   26 SAY "Custo Reposicao: "+TRANSFORM(vtot[2],"@E 999,999,999.99")
   @ PROW(),   59 SAY "Preco: "+TRANSFORM(vtot[3],"@E 999,999,999.99")
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // TOTAIS: Itens: 999,999   Custo Reposicao: 999,999,999.99  Preco: 999,999,999.99
ENDIF
@ PROW()+2,0 SAY vcia10+PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*            
 CODIGO                   P R O D U T O                         LOJA     DEPOSITO SALDO TOTAL CUSTO UNITARIO PRECO DE VENDA
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999.99  999,999.99 999,999,999.99 999,999,999.99
*/
********************************************************************************
PROCEDURE Relprod2(tipo)
/*
Objetivo  : emite as tabelas dos produtos.
Parƒmetros: tipo:  1 -> saldo
                   2 -> pre‡o
                   3 -> custo
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL pv
Sinal("PRODUTOS","TABELA")
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1, SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPRO.DBF")
   SELECT 2
   USE SAOTPRO ALIAS Tpro
   IF !FILE("SAOTPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPRO1, SAOTPRO2
ELSE
   Mensagem("Arquivo de Grupos de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Tpro
vcodi:=vcodf:=SPACE(4)
SET ORDER TO 1
// Pesquisa a faixa de codigos cujos registros devem ser impressos.
Pesqint(3,"@R 9.99","Grupos de Produtos")
IF tipo=1
   vtit:="Tabela de Saldos dos Produtos"
ELSEIF tipo=2
   vtit:="Tabela de Precos dos Produtos"
ELSEIF tipo=3
   vtit:="Tabela de Custos dos Produtos"
ENDIF
IF !Imprime("Relat¢rio das Tabelas dos Produtos")
   CLOSE DATABASE
   RETURN
ENDIF
pv:=.T.                    // Controlador de impress„o.
pg:=vtoti:=vtotg:=vtots:=0 // Contadores de p ginas e de itens.
vcod:=vnom:=SPACE(1)       // Controle dos grupos de produtos.
SET DEVICE TO PRINTER      // Direciona para a impressora.
DO WHILE !EOF() .AND. Tpro->codi<=vcodf
   // Impressao do cabe‡alho.
   // Cabecalho do Relat¢rio resumido.
   Cabe(emp[2],vsist,vtit,"EMISSAO POR GRUPO DE PRODUTOS",80,vcia10)
   IF tipo=1
      @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                       SALDO"
   ELSEIF tipo=2
      @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                     PRECO DE VENDA"
   ELSEIF tipo=3
      @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                     CUSTO DE REPOSICAO"
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. Tpro->codi<=vcodf
      vcod:=Tpro->codi
      vnog:=TRIM(Tpro->nome)
      // Impressao dos dados.
      @ PROW()+2,01 SAY vcod PICTURE "@R 9.99"
      @ PROW(),  10 SAY PADR(vnog+" ",70,"-")
      @ PROW(),  01 SAY vcod PICTURE "@R 9.99"
      @ PROW(),  10 SAY PADR(vnog+" ",70,"-")
      @ PROW()+1,00 SAY ""
      IF pv
         SELECT Prod
         SEEK vcod
         IF !FOUND()
            SELECT Tpro
            SKIP
            LOOP
         ENDIF
         pv:=.F.
      ENDIF
      SELECT Prod
      DO WHILE PROW()<58 .AND. LEFT(Prod->codi,3)=vcod
         // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
         IF Escprint(80)
            CLOSE DATABASE
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio resumido.
         @ PROW()+1,01 SAY Prod->codi PICTURE "@R 9.99.999"
         @ PROW(),  10 SAY PADR(TRIM(LEFT(Prod->nome,47)),47,".")
         IF tipo=1
            @ PROW(),  58 SAY Prod->saldo+Prod->saldod PICTURE "@E 99,999,999.99"
            @ PROW(),  72 SAY LEFT(Prod->unid,8)
            vtots+=(Prod->saldo+Prod->saldod)
         ELSEIF tipo=2
            @ PROW(),  58 SAY Prod->precr PICTURE "@E 99,999,999.99"
            @ PROW(),  72 SAY Prod->datcr
         ELSEIF tipo=3
            @ PROW(),  58 SAY Prod->custr PICTURE "@E 99,999,999.99"
            @ PROW(),  72 SAY Prod->datcu
         ENDIF
         ++vtoti // Itens por grupo.
         ++vtotg // Total de itens.
         SKIP
      ENDDO  // Fim do DO WHILE do grupo.
      IF LEFT(Prod->codi,3)#vcod
         @ PROW()+1,00 SAY REPLICATE("-",80)
         @ PROW()+1,23 SAY "Total de Itens no Grupo: "+TRANSFORM(vtoti,"@E 999,999")
         IF tipo=1
            @ PROW(),  58 SAY vtots PICTURE "@E 99,999,999.99"
            vtots:=0
         ENDIF
         @ PROW()+1,00 SAY REPLICATE("-",80)
         vtoti:=0
         pv:=.T.
         SELECT Tpro
         SKIP
         IF tipo=2
            EXIT
         ENDIF
      ENDIF
      SELECT Tpro
   ENDDO  // Fim do DO WHILE das p ginas.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,23 SAY "Total Geral de Itens___: "+TRANSFORM(vtotg,"@E 999,999")
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*            
 CODIGO                   P R O D U T O                       SALDO    
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99,999,999.99 99/99/99
*/
********************************************************************************
PROCEDURE Relprod3()
/*
Objetivo  : emite o relat¢rio dos produtos com estoque abaixo do m¡nimo.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("PRODUTOS","MINIMO")
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1, SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF !Imprime("Relat¢rio dos Produtos com Estoque Abaixo do M¡nimo")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
DO WHILE !EOF()
   // Impressao do cabe‡alho.
   // Cabecalho do Relat¢rio resumido.
   Cabe(emp[2],vsist,"Relatorio dos Produtos","Estoque Abaixo do Minimo",80,vcia10)
   @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                       SALDO     MINIMO"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF()
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Imprime os dados do relat¢rio resumido.
      IF (Prod->saldo+Prod->saldod)<=Prod->estmi
         @ PROW()+1,01 SAY Prod->codi PICTURE "@R 9.99.999"
         @ PROW(),  10 SAY PADR(TRIM(LEFT(Prod->nome,50)),50,".")
         @ PROW(),  61 SAY Prod->saldo+Prod->saldod PICTURE "@E 99,999.99"
         @ PROW(),  71 SAY Prod->estmi PICTURE "@E 99,999.99"
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
 CODIGO                   P R O D U T O                       SALDO     MINIMO  
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99,999.99 99,999.99
*/
********************************************************************************
PROCEDURE Relprod4()
/*
Objetivo  : emite o relat¢rio por grupo dos produtos.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL pv,vtot[3],vtog[6]
Sinal("PRODUTOS","RELATORIO")
IF FILE("SAOPRO.DBF")
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1, SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPRO.DBF")
   SELECT 2
   USE SAOTPRO ALIAS Tpro
   IF !FILE("SAOTPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPRO1, SAOTPRO2
ELSE
   Mensagem("Arquivo de Grupos de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Tpro
vcodi:=vcodf:=SPACE(4)
SET ORDER TO 1
// Pesquisa a faixa de codigos cujos registros devem ser impressos.
Pesqint(3,"@R 9.99","Grupos de Produtos")
IF !Imprime("Relat¢rio dos Produtos por Grupo")
   CLOSE DATABASE
   RETURN
ENDIF
pv:=.T.                 // Controlador da impress„o.
pg:=0                   // Contador de p ginas.
AFILL(vtot,0)           // Totalizadores gerais.
AFILL(vtog,0)           // Totalizadores por grupo.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF() .AND. Tpro->codi<=vcodf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"RELATORIO DOS PRODUTOS","EMISSAO POR GRUPO DE PRODUTO",132,vcia20)
   @ PROW()+1,02 SAY "CODIGO                   P R O D U T O                     UNIDADE    LOJA     DEPOSITO SALDO TOTAL CUSTO UNITARIO PRECO DE VENDA"
   @ PROW()+1,00 SAY REPLICATE("-",132)
   // DO WHILE das p ginas.
   DO WHILE PROW()<=58 .AND. Tpro->codi<=vcodf
      vcod:=Tpro->codi
      SELECT Prod
      IF pv
         SEEK vcod
         pv:=.F.
      ENDIF
      DO WHILE PROW()<60 .AND. !EOF() .AND. LEFT(Prod->codi,3)=vcod
         // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
         IF Escprint(132)
            CLOSE DATABASE
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio.
         @ PROW()+1, 01 SAY Prod->codi PICTURE "@R 9.99.999"
         @ PROW(),   10 SAY LEFT(Prod->nome,50)
         @ PROW(),   61 SAY LEFT(Prod->unid,7)
         @ PROW(),   69 SAY Prod->saldo PICTURE "@E 999,999.99"
         @ PROW(),   80 SAY Prod->saldod PICTURE "@E 999,999.99"
         @ PROW(),   91 SAY Prod->saldo+Prod->saldod PICTURE "@E 999,999.99"
         @ PROW(),  102 SAY Prod->custr PICTURE "@E 999,999,999.99"
         @ PROW(),  117 SAY Prod->precr PICTURE "@E 999,999,999.99"
         @ PROW()+1,102 SAY Prod->custr*(Prod->saldo+Prod->saldod) PICTURE "@E 999,999,999.99"
         @ PROW(),  117 SAY Prod->precr*(Prod->saldo+Prod->saldod) PICTURE "@E 999,999,999.99"
         ++vtog[1]
         vtog[2]+=Prod->saldo
         vtog[3]+=Prod->saldod
         vtog[4]+=(Prod->saldo+Prod->saldod)
         vtog[5]+=(Prod->custr*(Prod->saldo+Prod->saldod))
         vtog[6]+=(Prod->precr*(Prod->saldo+Prod->saldod))
         ++vtot[1]
         vtot[2]+=(Prod->custr*(Prod->saldo+Prod->saldod))
         vtot[3]+=(Prod->precr*(Prod->saldo+Prod->saldod))
         SKIP
      ENDDO  // Fim do DO WHILE da p gina.
      SELECT Tpro
      IF LEFT(Prod->codi,3)#vcod
         @ PROW()+1,00 SAY REPLICATE("-",132)
         @ PROW()+1, 01 SAY "TOTAIS "+LEFT(Tpro->nome,48)
         @ PROW(),   57 SAY "Itens:"
         @ PROW(),   63 SAY vtog[1] PICTURE "@E 9,999"
         @ PROW(),   69 SAY vtog[2] PICTURE "@E 999,999.99"
         @ PROW(),   80 SAY vtog[3] PICTURE "@E 999,999.99"
         @ PROW(),   91 SAY vtog[4] PICTURE "@E 999,999.99"
         @ PROW(),  102 SAY vtog[5] PICTURE "@E 999,999,999.99"
         @ PROW(),  117 SAY vtog[6] PICTURE "@E 999,999,999.99"
         @ PROW()+1,00 SAY REPLICATE("-",132)
         @ PROW()+1,00 SAY " "
         AFILL(vtog,0)
         SKIP
         pv:=.T.
      ENDIF
   ENDDO  // Fim do DO WHILE das p ginas.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("=",132)
@ PROW()+1, 01 SAY "T  O  T  A  I  S     G  E  R  A  I  S :"
@ PROW(),   74 SAY "Itens:"
@ PROW(),   80 SAY vtot[1] PICTURE "@E 99,999"
@ PROW(),  102 SAY vtot[2] PICTURE "@E 999,999,999.99"
@ PROW(),  117 SAY vtot[3] PICTURE "@E 999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("=",132)
@ PROW()+2,0 SAY vcia10+PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*            
 CODIGO                   P R O D U T O                     UNIDADE    LOJA     DEPOSITO SALDO TOTAL CUSTO UNITARIO PRECO DE VENDA
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxx 999,999.99 999,999.99 999,999.99 999,999,999.99 999,999,999.99
*/
*******************************************************************************
PROCEDURE Etiprod(tipo,modo)
//  Emissao de Etiquetas dos Produtos
*******************************************************************************
LOCAL vlabel[ADIR("*.LBL")],vprod[10],vqtd[10]
PRIVATE vcodi,vcodf,vcond:=""
IF FILE("SAOPRO.DBF") .AND. FILE("SAOPRO1.NTX") .AND. FILE("SAOPRO2.NTX")
   SELECT 1
   USE SAOPRO INDEX SAOPRO1,SAOPRO2 ALIAS Prod EXCLUSIVE
ELSE
   Mensagem("O Arquivo dos Produtos N„o Est  Disponivel !",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
Sinal("PRODUTOS","ETIQUETAS")
IF tipo=1
   // Etiqueta para codificar os produtos.
   AFILL(vprod,SPACE(6))
   AFILL(vqtd,8)
   Abrejan(2)
   SETCOLOR(vca)
   Aviso(5,"Digite os C¢digos dos Produtos Desejados")
   SETCOLOR(vcn)
   FOR i=1 TO 10
      @ i+7,07 GET vprod[i] PICTURE "@R 9.99.999"
      Aviso(24,"Digite o C¢digo do Produto, <Enter> Consulta, <Esc> Finaliza")
      Le()
      IF LASTKEY()=K_ESC
         EXIT
      ENDIF
      vprod[i]:=Acha(vprod[i],"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
      IF EMPTY(vprod[i])
         EXIT
      ENDIF
      SETCOLOR(vcr)
      @ i+7,07 SAY vprod[i] PICTURE "@R 9.99.999"
      SETCOLOR(vca)
      @ i+7,17 SAY Prod->nome
      SETCOLOR(vcn)
      @ i+7,69 GET vqtd[i] PICTURE "99"
      Aviso(24,"Digite a Quantidade de Etiquetas Desejadas, m£ltiplos de 8")
      Le()
      vqtd[i]:=ROUND(vqtd[i]/8,0)
   NEXT
   IF !Imprime("Etiquetas dos Produtos")
      CLOSE DATABASE
      RETURN
   ENDIF
   SET DEVICE TO PRINT
   w:=0
   FOR i=1 TO 10
       IF EMPTY(vprod[i])
          EXIT
       ENDIF
       FOR j=1 TO vqtd[i]
           FOR k=3 TO 130 STEP 16
              IF Escprint()
                 CLOSE DATABASE
                 RETURN
              ENDIF
              @ w,k SAY vprod[i] PICTURE "@R 9.99.999"
           NEXT
           w+=3
        NEXT
   NEXT
ELSEIF tipo=2
   // Etiquetas de precos
   IF modo=1
      vcodi:=vcodf:=SPACE(6)
      SET ORDER TO 1
      // Pesquisa a faixa de codigos cujas registros devem ser impressos.
      Pesqint(6,"@R 9.99.999","C¢digos de Produtos")
   ELSEIF modo=2
      AFILL(vprod,SPACE(6))
      Abrejan(2)
      SETCOLOR(vca)
      Aviso(5,"Digite os C¢digos dos Produtos Desejados")
      SETCOLOR(vcn)
      FOR i=1 TO 10
         @ i+7,07 GET vprod[i] PICTURE "@R 9.99.999"
         Aviso(24,"Digite o C¢digo do Produto, <Enter> Consulta, <Esc> Finaliza")
         Le()
         IF LASTKEY()=K_ESC
            EXIT
         ENDIF
         vprod[i]:=Acha(vprod[i],"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,10,22,76)
         IF EMPTY(vprod[i])
            EXIT
         ENDIF
         SETCOLOR(vcr)
         @ i+7,07 SAY vprod[i] PICTURE "@R 9.99.999"
         SETCOLOR(vca)
         @ i+7,17 SAY Prod->nome
         SETCOLOR(vcn)
         vcond:=vcond+"codi='"+vprod[i]+"' .OR."
      NEXT
      vcond:=LEFT(vcond,LEN(vcond)-5)
   ENDIF
   Abrejan(2)
   tk:=0
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
   veti:=ALLTRIM(vlabel[vop])
   IF !Imprime("Etiquetas de Produtos, formul rio: "+veti)
      CLOSE DATABASE
      RETURN
   ENDIF
   SET PRINT ON
   ?? vcia20
   SET PRINT OFF
   FOR i:=1 TO vcop
       IF modo=1
          SET SOFTSEEK ON
          SEEK vcodi
          SET SOFTSEEK OFF
          LABEL FORM &veti WHILE codi<=vcodf .AND. Esceti() TO PRINTER
          SET CONSOLE OFF
       ELSEIF modo=2
          LABEL FORM &veti FOR &vcond .AND. Esceti() TO PRINTER
       ENDIF
       IF LASTKEY()=K_ESC
          EXIT
       ENDIF
   NEXT
ENDIF
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
********************************************************************************
//                                    F i m
********************************************************************************
