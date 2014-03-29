********************************************************************************
/* Programa.: SAOOPE.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro das Opera‡”es.                  */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Matope(modo)
/* Gerenciador de Opera‡”es
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡„o
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("OPERA€OES","INCLUSŽO")
ELSEIF modo=2
   Sinal("OPERA€OES","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("OPERA€OES","EXCLUSŽO")
ENDIF
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
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vcodi:=SPACE(6)
   vnome:=SPACE(50)
   vtipo:=SPACE(1)
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 7,26 GET vcodi PICTURE "@R 9.99.999"
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
      vcodi:=Acha(vcodi,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,08,22,76)
   ENDIF
   IF EMPTY(vcodi)
      LOOP
   ENDIF
   SELECT Ope
   SEEK vcodi
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Opera‡„o N„o Encontrada !",8,1)
         LOOP
      ENDIF
   ELSE
      // Transfere os dados do registro para as vari veis auxiliares.
      vnome:=Ope->nome
      vtipo:=Ope->tipo
   ENDIF
   // Mostra os dados do registro.
   Mostra()
   SETCOLOR(vcn)
   IF modo=1 .OR. modo=2
      DO WHILE .T.
         SETCOLOR(vca)
         Aviso(24,"Digite os Dados da Opera‡„o")
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
         Ope->codi:=vcodi
      ENDIF
      // Atualiza o conte£do dos campos do registro com as vari veis auxiliares.
      Ope->nome:=vnome;Ope->tipo:=vtipo
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
@  7,5 SAY "C¢digo da Opera‡„o_:"
@ 11,5 SAY "Nome da Opera‡„o___:"
@ 16,5 SAY "Tipo da Opera‡„o___:"
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@  7,26 SAY vcodi  PICTURE "@R 9.99.999"
@ 11,26 SAY vnome  PICTURE "@!"
@ 16,26 SAY vtipo  PICTURE "!"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@  7,26 SAY vcodi PICTURE "@R 9.99.999"
SETCOLOR(vcn)
@ 11,26 GET vnome PICTURE "@!"
Le()
@ 16,26 GET vtipo PICTURE "!" VALID vtipo$"RDCVTO"
Aviso(24,"Digite: R=receita, D=despesa, C=compra, V=venda, T=transferˆncia e O=outras")
Le()
RETURN
********************************************************************************
PROCEDURE Consope()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("OPERA€OES","CONSULTA")
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
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[15],vmask[15],vcabe[15],vedit[15]
// vdado: vetor dos nomes dos campos
vdado[1]:="codi"
vdado[2]:="tipo"
vdado[3]:="nome"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[1]:="@R 9.99.999"
vmask[2]:="!"
vmask[3]:="@!"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[1]:="C¢digo"
vcabe[2]:="Tipo"
vcabe[3]:="Nome da Opera‡„o"
FOR i=4 TO 15
    vdado[i]:="mes"+STRZERO(i-3,2)
    vmask[i]:="@E 999,999,999.99"
    vcabe[i]:=Dpc(CTOD("01/"+STRZERO(i-3)+"/"+STR(YEAR(saomes),4)))
NEXT
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
vedit[2]:=.T.
vedit[3]:=.T.
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Ope",03,01,22,78,vdado,vmask,vcabe,vedit,1,;
          "codi",1,"@R 9.99.999",6,"C¢digo",;
          "nome",2,"@!",40,"Nome")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relope(ordem)
/*
Objetivo : emite os relat¢rios das opera‡oes.
Parƒmetro: ordem: 1 -> por conta
                  2 -> por conrrentista.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("OPERA€OES","RELATORIO")
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
IF ordem=1
   vcodi:=vcodf:=SPACE(6)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(6,"@R 9.99.999","C¢digos das Opera‡”es")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de C¢digo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Opera‡”es")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
IF !Imprime("Relat¢rio das Opera‡”es")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
//SET PRINTER TO SAOREL.TXT
// DO WHILE principal
DO WHILE .NOT. EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio das Operacoes",vtit,80,vcia10)
   @ PROW()+1,01 SAY "CODIGO      TIPO            O P E R A C A O                   SALDO EM "+Dpc(saomes)
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. .NOT. EOF() .AND. EVAL(bcond,codi,nome)
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
      @ PROW(),      66 SAY FIELDGET(MONTH(saomes)+3) PICTURE "@E 99,999,999.99"
      SKIP
      IF RIGHT(Ope->codi,5)="00000"
         @ PROW()+1,00 SAY REPLICATE("-",80)
      ELSEIF RIGHT(Ope->codi,3)="000"
         @ PROW()+1,00 SAY " "
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
CODIGO      TIPO            O P E R A C A O                   SALDO DO MES ATUAL
9.99.999     x xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99 */
********************************************************************************
//                                    F i m
********************************************************************************
