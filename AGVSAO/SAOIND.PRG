********************************************************************************
/* Programa.: SAOIND.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro dos Indices de Corre‡„o. */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Matind(tipo)
// Manuten‡„o do Cadastro dos Indices
********************************************************************************
IF tipo=1
   Sinal("DOLAR","CADASTRO")
   IF FILE("SAOUS.DBF")
      USE SAOUS INDEX SAOUS1 ALIAS Dolar
   ELSE
      Mensagem("Arquivo do D¢lar N„o Encontrado no Disco !",5,1)
      CLOSE DATABASE
      RETURN
   ENDIF
ELSEIF tipo=2
   Sinal("INDICE","CADASTRO")
   IF FILE("SAOIND.DBF")
      USE SAOIND INDEX SAOIND1 ALIAS Indice
   ELSE
      Mensagem("Arquivo do Indice N„o Encontrado no Disco !",5,1)
      CLOSE DATABASE
      RETURN
   ENDIF
ENDIF
GO TOP
Abrejan(2)
// Limpa a janela de dados.
PRIVATE vdado[2],vmask[2],vcabe[2]
vdado[01]="data"
vdado[02]="valor"
vmask[02]="@E 999,999.99"
vcabe[01]="Data"
vcabe[02]=" Cota‡„o"
SETCOLOR(vcr)
@ 23,01 SAY PADC("F1 Help  F9 Data  [Ins]  [Del]  [PgUp] [PgDn]  [Enter]  [Esc]",76)
SETCOLOR(vcn)
DBEDIT(03,01,22,78,vdado,"Fdbi",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fdbi(modo)
// Funcao para Consulta com DBEDIT
********************************************************************************
IF modo=1
   Mensagem("In¡cio do Arquivo !",8,2)
   RETURN(1)
ELSEIF modo=2
   Mensagem("Fim do Arquivo !",8,2)
   RETURN(1)
ELSEIF modo=3
   Mensagem("Arquivo Vazio !",8,2)
   RETURN(1)
ELSEIF modo=4
   IF LASTKEY()=K_ESC
      RETURN(0)
   ELSEIF LASTKEY()=K_ENTER
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
      @ vlin-1, 02 TO vlin+1,76
      SETCOLOR(vcn)
      @ vlin, 29  GET data
      @ vlin, 40  GET valor PICTURE "@ 999,999.99"
      Aviso(24,"Altere os Dados ou Tecle [PgDn]")
      Le()
      IF UPDATED()
         RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
         RETURN(2)
      ELSE
         RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
         RETURN(1)
      ENDIF
   ELSEIF LASTKEY()=K_INS
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
      vdata:=CTOD(SPACE(8))
      vcota:=0.000
      @ vlin-1, 02 TO vlin+1,76
      SETCOLOR(vcn)
      @ vlin, 29  GET vdata
      @ vlin, 40  GET vcota PICTURE "999,999.99"
      Aviso(24,"Digite os Novos Dados")
      Le()
      IF EMPTY(vdata)
         RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
         RETURN(1)
      ENDIF
      SEEK vdata
      IF FOUND()
         Mensagem("Desculpe, Data j  Cadastrada !",8,1)
         RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
         RETURN(1)
      ENDIF
      IF Confirme()
         APPEND BLANK
         REPLACE data WITH vdata,valor WITH vcota
         RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
         RETURN(2)
      ENDIF
      RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
      RETURN(1)
   ELSEIF LASTKEY()=K_DEL
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
      @ vlin-1, 02 TO vlin+1,76
      SETCOLOR(vcr)
      @ vlin, 29  SAY data
      @ vlin, 40  SAY valor PICTURE "@E 999,999.99"
      SETCOLOR(vcn)
      IF Exclui()
         DELETE
         SKIP
      ENDIF
      RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
      RETURN(2)
   ELSEIF LASTKEY()=K_F9
      // Foi pressionada a tecla [F9].
      @ 24,00 CLEAR
      SET ORDER TO 1
      vdata:=CTOD(SPACE(8))
      @ 24,20 SAY "Data Desejada: " GET vdata
      Le()
      IF EMPTY(vdata)
         RETURN(1)
      ENDIF
      rec:=RECNO()
      SET SOFTSEEK ON
      SEEK vdata
      SET SOFTSEEK OFF
      IF EOF()
         // Se nao for encontrado retorna.
         Mensagem("Data N„o Encontrada !",8,1)
         GO rec
         RETURN(2)
      ENDIF
      RETURN(2)
   ELSE
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      Abrejan(2)
      SETCOLOR(vci)
      Aviso(5,"   Auxilio ao Usu rio   ")
      SETCOLOR(vca)
      @ 09,12 SAY " Tecla                Fun‡„o"
      SETCOLOR(vcn)
      @ 11,12 SAY "[Setas] - p/ Cima e p/ Baixo, posicionam no item desejado"
      @ 12,12 SAY "[Setas] - p/ Direita e p/ Esquerda, posicionam no pr¢ximo campo"
      @ 13,12 SAY "[PgUp]  - Retorna para a janela anterior"
      @ 14,12 SAY "[PgDn]  - Avan‡a para a pr¢xima janela"
      @ 15,12 SAY "[Home]  - Retorna para o inicio do registro"
      @ 16,12 SAY "[End]   - Avan‡a para o fim do registro"
      @ 17,12 SAY "[Enter] - Mostra os Dados do Item"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[Ins]   - Inclui uma nova Cota‡„o"
      @ 20,12 SAY "[Del]   - Exclui uma Cota‡„o"
      @ 21,12 SAY "[F9]    - Pesquisa pela Data"
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
//                                 F i m
********************************************************************************
