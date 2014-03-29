********************************************************************************
/* Programa.: SAOREP.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Vendedores.                 */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Matrep(modo)
/* Gerenciador de REPRESENTANTES/VENDEDORES
   Parametros: modo - opera‡„o a ser realizada: 1 - Inclus„o
                                                2 - Altera‡ao
                                                3 - Exclus„o */
********************************************************************************
IF modo=1
   Sinal("VENDEDORES","INCLUSŽO")
ELSEIF modo=2
   Sinal("VENDEDORES","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("VENDEDORES","EXCLUSŽO")
ENDIF
IF FILE("SAOREP.DBF")
   SELECT 1
   USE SAOREP ALIAS Rep
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1, SAOREP2
ELSE
   Mensagem("Arquivo de Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
Abrejan(2)
// Apresenta os t¡tulos na tela
Titulos()
DO WHILE .T.
   // Inicializa‡„o das vari veis auxiliares.
   vcodi:=SPACE(3)
   vnome:=SPACE(40)
   vpctc:=0
   vcomi:=0
   // Mostra na tela os campos do Arquivo de Dados.
   Mostra()
   @ 8,19 GET vcodi PICTURE "999"
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
      vcodi:=Acha(vcodi,"Rep",1,2,"codi","nome","999","@!",15,15,22,76)
   ENDIF
   IF EMPTY(vcodi)
      LOOP
   ENDIF
   SELECT Rep
   SEEK vcodi
   IF !FOUND()
      IF modo#1
         Mensagem("Desculpe, Vendedor N„o Encontrado !",8,1)
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
         Aviso(24,"Digite os Dados do Vendedor")
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
         Rep->codi:=vcodi
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
@ 08,11 SAY "C¢digo: "
@ 12,11 SAY "Nome___________: "
@ 16,11 SAY "Comiss„o:     Porcentagem: "
@ 16,49 SAY "Valor: "
RETURN
********************************************************************************
STATIC PROCEDURE Mostra()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcr)
@ 08,19 SAY vcodi PICTURE "999"
@ 12,28 SAY vnome PICTURE "@!"
@ 16,38 SAY vpctc PICTURE "@E 99.99"
@ 16,56 SAY vcomi PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do arquivo atrav‚s das vari veis auxiliares.
********************************************************************************
SETCOLOR(vcr)
@ 08,19 SAY vcodi PICTURE "999"
@ 16,56 SAY vcomi PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
@ 12,28 GET vnome PICTURE "@!"
@ 16,38 GET vpctc PICTURE "99.99"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados dos campos do arquivo para respectivas as vari veis
// auxiliares.
********************************************************************************
vnome:=Rep->nome
vpctc:=Rep->pctc
vcomi:=Rep->comi
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Rep->nome:=vnome
Rep->pctc:=vpctc
Rep->comi:=vcomi
RETURN
********************************************************************************
PROCEDURE Consrep()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
Sinal("VENDEDORES","CONSULTA")
IF FILE("SAOREP.DBF")
   SELECT 1
   USE SAOREP ALIAS Rep
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1, SAOREP2
ELSE
   Mensagem("Arquivo de Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Cria os vetores para a funcao Visualiza().
PRIVATE vdado[4],vmask[4],vcabe[4],vedit[4]
// vdado: vetor dos nomes dos campos
vdado[1]:="codi"
vdado[2]:="nome"
vdado[3]:="pctc"
vdado[4]:="comi"
// vmask: vetor das m scaras de apresenta‡„o dos dados.
vmask[1]:="999"
vmask[2]:="@!"
vmask[3]:="@E 99.99"
vmask[4]:="@E 999,999,999.99"
// vcabe: vetor dos t¡tulos para o cabe‡alho das colunas.
vcabe[1]:="C¢digo"
vcabe[2]:="Nome"
vcabe[3]:="Comiss„o"
vcabe[4]:="Valor no Mˆs"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
vedit[4]:=.F.
/* Visualiza os registros atrav‚s do procedimento Visualiza() (AGVBIB.PRG),
   que utiliza um objeto TBrowse.*/
Abrejan(2)
Visualiza("Rep",03,01,22,78,vdado,vmask,vcabe,vedit,1,;
          "codi",1,"999",3,"C¢digo",;
          "nome",2,"@!",40,"Nome")
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Relrep(ordem)
/*
Objetivo : emite os relat¢rios das contas bancarias.
Parƒmetro: ordem: 1 -> por c¢digo
                  2 -> por nome.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("VENDEDORES","RELATORIO")
IF FILE("SAOREP.DBF")
   SELECT 1
   USE SAOREP ALIAS Rep
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1, SAOREP2
ELSE
   Mensagem("Arquivo de Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF ordem=1
   vcodi:=vcodf:=SPACE(3)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(3,"999","C¢digo de Vendedores")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Codigo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Vendedores")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Alfabetica"
ENDIF
IF !Imprime("Relat¢rio dos Vendedores")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
//SET PRINTER TO SAOREL.TXT
// DO WHILE principal
DO WHILE .NOT. EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio dos Vendedores",vtit,80,vcia10)
   @ PROW()+1,01 SAY "CODIGO                  N O M E                             %   COMISSAO "+Dpc(saomes)
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
      @ PROW()+2,01 SAY Rep->codi
      @ PROW(),  06 SAY Rep->nome
      @ PROW(),  59 SAY Rep->pctc PICTURE "@E 99.99"
      @ PROW(),  66 SAY Rep->comi PICTURE "@E 999,999,999.99"
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
CODIGO                  N O M E                             %   COMISSAO XXX/99
999  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99.99  999,999,999.99 */
********************************************************************************
//                                    F i m
********************************************************************************
