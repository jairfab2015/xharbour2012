********************************************************************************
/* Programa.: SAOPXF.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Produtos fornecidos pelos Fornecedores. */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Matpxf(modo)
/* Gerenciador de PRODUTOS x FORNECEDORES
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("PRODxFORNE","INCLUSŽO")
ELSEIF modo=2
   Sinal("PRODxFORNE","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("PRODxFORNE","EXCLUSŽO")
ENDIF
IF FILE("SAOPXF.DBF")
   SELECT 1
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3,SAOPXF4
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 2
   USE SAOFOR ALIAS Forn
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 3
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vcodfor:=SPACE(5)
   vnfor  :=SPACE(40)
   vcodpro:=SPACE(6)
   vnpro  :=SPACE(40)
   vunid  :=SPACE(10)
   vcusto :=0
   vcodpxf:=SPACE(10)
   vnome  :=SPACE(40)
   vpreco :=0
   vprazo :=SPACE(20)
   vcpagto:=SPACE(15)
   vdata  :=CTOD(SPACE(8))
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 5,17 GET vcodfor PICTURE "99999"
   Aviso(24,"Digite o C¢digo do Fornecedor, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      CLOSE DATABASE
      RETURN
   ENDIF
   IF !EMPTY(vcodfor)
      vcodfor:=Zeracod(vcodfor)
   ENDIF
   vcodfor:=Acha(vcodfor,"Forn",1,2,"codi","nome","99999","@!",15,05,22,76)
   IF EMPTY(vcodfor)
      CLOSE DATABASE
      RETURN
   ENDIF
   vnfor:=LEFT(Forn->nome,40)
   SETCOLOR(vcr)
   @ 5,17 SAY vcodfor PICTURE "99999"
   @ 5,32 SAY vnfor PICTURE "@!"
   SETCOLOR(vcn)
   @ 7,17 GET vcodpro PICTURE "@R 9.99.999"
   Aviso(24,"Digite o C¢digo do Produto, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      CLOSE DATABASE
      RETURN
   ENDIF
   vcodpro:=Acha(vcodpro,"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
   IF EMPTY(vcodpro)
      CLOSE DATABASE
      RETURN
   ENDIF
   vnpro :=LEFT(Prod->nome,40)
   vunid :=Prod->unid
   vcusto:=Prod->custr   
   SETCOLOR(vcr)
   @ 7,32 SAY vnpro PICTURE "@!"
   @ 9,35 SAY vunid PICTURE "@!"
   @ 9,60 SAY vcusto PICTURE "@E 9,999,999.99"
   SETCOLOR(vcn)
   SELECT Pxf
   SEEK vcodpro+vcodfor
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Registro Produto x Fornecedor N„o Encontrado !",8,1)
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
         Aviso(24,"Digite os Dados do Registro")
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
         Pxf->codfor:=vcodfor
         Pxf->codpro:=vcodpro
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
@ 05,05 SAY "Fornecedor: "
@ 05,26 SAY "Nome: "
@ 07,05 SAY "Produto___: "
@ 07,26 SAY "Nome: "
@ 09,26 SAY "Unidade: "
@ 09,47 SAY "Custo Atual: "
@ 11,01 SAY REPLICATE("Ä",78)
SETCOLOR(vca)
Aviso(13,"Dados do Produto para o Fornecedor")
SETCOLOR(vcn)
@ 15,05 SAY "Refer._: "
@ 15,26 SAY "Nome: "
@ 17,05 SAY "Pre‡o_: "
@ 17,32 SAY "Prazo de Entrega__: "
@ 19,05 SAY "Condi‡”es de Pagto._: "
@ 19,43 SAY "Data da Atualiza‡„o: "
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@ 05,17 SAY vcodfor PICTURE "99999"
@ 05,32 SAY vnfor   PICTURE "@!"
@ 07,17 SAY vcodpro PICTURE "@R 9.99.999"
@ 07,32 SAY vnpro   PICTURE "@!"
@ 09,35 SAY vunid   PICTURE "@!"
@ 09,60 SAY vcusto  PICTURE "@E 9,999,999.99"
@ 15,14 SAY vcodpxf PICTURE "@!"
@ 15,32 SAY vnome   PICTURE "@!"
@ 17,13 SAY vpreco  PICTURE "@E 999,999,999.99"
@ 17,52 SAY vprazo  PICTURE "@!"
@ 19,27 SAY vcpagto PICTURE "@!"
@ 19,64 SAY vdata   PICTURE "99/99/99"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
@ 15,14 GET vcodpxf PICTURE "@!"
@ 15,32 GET vnome   PICTURE "@!"
@ 17,13 GET vpreco  PICTURE "@E 999,999,999.99"
@ 17,52 GET vprazo  PICTURE "@!"
@ 19,27 GET vcpagto PICTURE "@!"
@ 19,64 GET vdata   PICTURE "99/99/99"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vcodpxf:=Pxf->codpxf
vnome  :=Pxf->nome
vpreco :=Pxf->preco
vprazo :=Pxf->prazo
vcpagto:=Pxf->cpagto
vdata  :=Pxf->data
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Pxf->codpxf:=vcodpxf
Pxf->nome  :=vnome
Pxf->preco :=vpreco
Pxf->prazo :=vprazo
Pxf->cpagto:=vcpagto
Pxf->data  :=vdata
RETURN
********************************************************************************
PROCEDURE Conspxf()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("PRODxFORNE","CONSULTA")
IF FILE("SAOPXF.DBF")
   SELECT 1
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3,SAOPXF4
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 2
   USE SAOFOR ALIAS Forn
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 3
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Pxf
SET RELATION TO codfor INTO Forn,TO codpro INTO Prod
// Cria os vetores para a funcao DBEDIT().
PRIVATE vdado[8],vmask[8],vcabe[8]
// vdado: vetor dos nomes dos campos
vdado[1]:="codpxf"
vdado[2]:="nome"
vdado[3]:="Prod->unid"
vdado[4]:="Prod->custr"
vdado[5]:="preco"
vdado[6]:="prazo"
vdado[7]:="cpagto"
vdado[8]:="data"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[1]:="@!"
vmask[2]:="@!"
vmask[3]:="@!"
vmask[4]:="@E 999,999,999.99"
vmask[5]:="@E 999,999,999.99"
vmask[6]:="@!"
vmask[7]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[1]:="Referˆncia"
vcabe[2]:="Nome"
vcabe[3]:="Unidade"
vcabe[4]:="Custo Rep."
vcabe[5]:="Pre‡o For"
vcabe[6]:="Prazo de Entrega"
vcabe[7]:="Condi‡”es de Pagto."
vcabe[8]:="Data Atualz."
// Visualiza os registros atrav‚s da fun‡„o DBEDIT().
Abrejan(2)
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F5 Produto/Fornecedor  F6 Referˆncia  F7 Nome  [Esc] Fim",78)
SETCOLOR(vcn)
@ 05,01 SAY REPLICATE("Ä",78)
DBEDIT(06,01,22,78,vdado,"Fpxf",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
*******************************************************************************
FUNCTION Fpxf(modo)
// Funcao para Consulta com DBEDIT
*******************************************************************************
SETCOLOR(vcn)
@ 03,08 SAY "Produto___:"
@ 04,08 SAY "Fornecedor:"
SETCOLOR(vca)
@ 03,20 SAY Prod->codi PICTURE "@R 9.99.999"
@ 03,30 SAY LEFT(Prod->nome,40)
@ 04,20 SAY Forn->codi
@ 04,30 SAY LEFT(Forn->nome,40)
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
      vforne:=SPACE(5)
      @ 24,20 SAY "Produto: "    GET vcodi PICTURE "@R 9.99.999"
      @ 24,41 SAY "Fornecedor: " GET vforne PICTURE "99999"
      Le()
      IF EMPTY(vcodi)
         RETURN(1)
      ENDIF
      vforne:=Zeracod(vforne)
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vcodi+vforne
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Produto N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      @ 24,00 CLEAR
      SET ORDER TO 3
      vforne:=SPACE(10)
      @ 24,10 SAY "Referˆncia do Fornecedor: " GET vforne PICTURE "@!"
      Le()
      IF EMPTY(vforne)
         RETURN(1)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vforne
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Produto N„o Encontrado !",3,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSEIF LASTKEY()=K_F7
      @ 24,00 CLEAR
      SET ORDER TO 4
      vnom:=SPACE(40)
      @ 24,10 SAY "Nome do Fornecedor: " GET vnom PICTURE "@!"
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
      @ 18,12 SAY "[F5]    - Pesquisa pelo C¢digo do Produto e do Fornecedor"
      @ 19,12 SAY "[F6]    - Pesquisa pela Referˆncia do Fornecedor"
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
********************************************************************************
PROCEDURE Relpxf1(ordem)
/*
Objetivo  : emite os relat¢rios dos fornecedores x produtos.
Parƒmetros: ordem: 1 -> c¢digo
                   2 -> nome
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL pv
Sinal("PRODUxFORNE","RELATORIO")
IF FILE("SAOPXF.DBF")
   SELECT 1
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3,SAOPXF4
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 2
   USE SAOFOR ALIAS Forn
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 3
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Pxf
SET ORDER TO 1
SET RELATION TO codfor INTO Forn
SELECT Prod
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
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Produtos")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
IF !Imprime("Relat¢rio dos Fornecedores x Produtos")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controla a impressao do relat¢rio.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   // Cabecalho do Relat¢rio resumido.
   Cabe(emp[2],vsist,"Relatorio Fornecedor por Produto",vtit,80,vcia10)
   @ PROW()+1,01 SAY "CODIGO                NOME DO PRODUTO                   UNIDADE         CUSTO"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Imprime os dados do relat¢rio.
      @ PROW()+2,01 SAY Prod->codi PICTURE "@R 9.99.999"
      @ PROW(),  12 SAY LEFT(Prod->nome,40)
      @ PROW(),  53 SAY Prod->unid
      @ PROW(),  68 SAY Prod->custr PICTURE "@E 9,999,999.99"
      @ PROW(),  01 SAY Prod->codi PICTURE "@R 9.99.999"
      @ PROW(),  12 SAY LEFT(Prod->nome,40)
      @ PROW(),  53 SAY Prod->unid
      @ PROW(),  68 SAY Prod->custr PICTURE "@E 9,999,999.99"
      SELECT Pxf
      IF pv
         SEEK Prod->codi
         pv:=.F.
      ENDIF
      IF Prod->codi=Pxf->codpro
         @ PROW()+1,00 SAY "Codigo-----Fornecedor/Nome do Produto/Telefones-----Contato/Data-------Cotacao--"
         DO WHILE PROW()<=58 .AND. !EOF() .AND. Pxf->codpro=Prod->codi
            // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
            IF Escprint(80)
               CLOSE DATABASE
               RETURN
            ENDIF
            @ PROW()+1,01 SAY Forn->codi
            @ PROW(),  07 SAY Forn->nome
            @ PROW(),  28 SAY Forn->telf
            @ PROW(),  49 SAY LEFT(Forn->cont,32)
            @ PROW()+1,01 SAY Pxf->codpxf
            @ PROW(),  12 SAY LEFT(Pxf->nome,40)
            @ PROW(),  53 SAY Pxf->data
            IF Pxf->preco#0
               @ PROW(),  68 SAY Pxf->preco PICTURE "@E 9,999,999.99"
            ENDIF
            @ PROW()+1,00 SAY REPLICATE(".",80)
            SKIP
         ENDDO
      ELSE
         @ PROW()+1,12 SAY "Nao ha fornecedores cadastrados para este produto."
      ENDIF
      SELECT Forn
      IF Prod->codi#Pxf->codpro
         SELECT Prod
         SKIP
         pv=.T.
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*            
CODIGO      N O M E         T E L E F O N E S            C O N T A T O
99999 xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Codigo     Fornecedor/Nome do Produto/Telefones     Contato/Data         Preco
9.99.999   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx 9,999,999.99
9999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx 9,999,999.99 */
********************************************************************************
PROCEDURE Relpxf2(ordem)
/*
Objetivo  : emite os relat¢rios dos produtos x fornecedores.
Parƒmetros: ordem: 1 -> c¢digo
                   2 -> nome
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL pv
Sinal("PRODUxFORNE","RELATORIO")
IF FILE("SAOPXF.DBF")
   SELECT 1
   USE SAOPXF ALIAS Pxf
   IF !FILE("SAOPXF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPXF1,SAOPXF2,SAOPXF3,SAOPXF4
ELSE
   Mensagem("Arquivo de Produtos x Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   SELECT 2
   USE SAOFOR ALIAS Forn
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo de Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 3
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Pxf
SET ORDER TO 2
SET RELATION TO codpro INTO Prod
SELECT Forn
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
IF !Imprime("Relat¢rio dos Produtos x Fornecedores")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controla a impressao do relat¢rio.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE .NOT. EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   // Cabecalho do Relat¢rio resumido.
   Cabe(emp[2],vsist,"Relatorio Produtos por Fornecedor",vtit,80,vcia10)
   @ PROW()+1,01 SAY "CODIGO      N O M E         T E L E F O N E S            C O N T A T O"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Imprime os dados do relat¢rio.
      @ PROW()+2,00 SAY Forn->codi
      @ PROW(),  07 SAY Forn->nome
      @ PROW(),  28 SAY Forn->telf
      @ PROW(),  49 SAY LEFT(Forn->cont,32)
      @ PROW(),  00 SAY Forn->codi
      @ PROW(),  07 SAY Forn->nome
      @ PROW(),  28 SAY Forn->telf
      @ PROW(),  49 SAY LEFT(Forn->cont,32)
      SELECT Pxf
      IF pv
         SEEK Forn->codi
         pv:=.F.
      ENDIF
      IF Forn->codi=Pxf->codfor
         @ PROW()+1,00 SAY "-Codigo -------------- Nome do Produto -------------- Datas ------ Custo/Cotacao"
         DO WHILE PROW()<=58 .AND. !EOF() .AND. Pxf->codfor=Forn->codi
            // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
            IF Escprint(80)
               CLOSE DATABASE
               RETURN
            ENDIF
            @ PROW()+1,01 SAY Prod->codi PICTURE "@R 9.99.999"
            @ PROW(),  12 SAY LEFT(Prod->nome,40)
            IF Prod->custr#0
               @ PROW(),  53 SAY Prod->datcu
               @ PROW(),  68 SAY Prod->custr PICTURE "@E 9,999,999.99"
            ENDIF
            @ PROW()+1,01 SAY Pxf->codpxf
            @ PROW(),  12 SAY LEFT(Pxf->nome,40)
            IF Pxf->preco#0
               @ PROW(),  53 SAY Pxf->data
               @ PROW(),  68 SAY Pxf->preco PICTURE "@E 9,999,999.99"
            ENDIF
            @ PROW()+1,01 SAY "Porcentagem de IPI: "+TRANSFORM(Prod->pipi,"@E 99,99")
            @ PROW()  ,30 SAY "Data:   /   /   "
            @ PROW(),  50 SAY "Nova Cotacao:"
            @ PROW()+1,00 SAY PADL(" Saldo Atual: "+TRANSFORM(Prod->Saldo+Prod->Saldod,"@E 999,999.99"),80,".")
            SKIP
         ENDDO
      ELSE
         @ PROW()+1,12 SAY "Nao ha produtos cadastrados para este fornecedor."
      ENDIF
      SELECT Forn
      IF Forn->codi#Pxf->codfor
         SELECT Forn
         SKIP
         pv=.T.
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*            
CODIGO      N O M E         T E L E F O N E S            C O N T A T O
99999 xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Codigo                Nome do Produto                Unidade/Data  Cotacao/Preco
9.99.999   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx 9,999,999.99
9999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx 9,999,999.99 */
********************************************************************************
//                                    F i m
********************************************************************************
