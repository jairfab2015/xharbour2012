********************************************************************************
/* Programa.: SAOTAB.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Cadastro das Tabelas de C¢digos.         */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Tabela
// Cadastro das Tabelas
********************************************************************************
PARAMETERS tipo
PRIVATE vdado[2],vmask[2],vcabe[2]
vdado[01]:="codi"
vdado[02]:="nome"
vmask[01]:="999"
vmask[02]:="@!"
vcabe[01]:="C¢digo"
vcabe[02]:=" D e n o m i n a ‡ „ o "
IF tipo=1
   Sinal("PRODUTOS","CADASTRO")
   IF FILE("SAOTPRO.DBF") .AND. FILE("SAOTPRO1.NTX") .AND. FILE("SAOTPRO2.NTX")
      SELECT 1
      USE SAOTPRO INDEX SAOTPRO1,SAOTPRO2 ALIAS Tab EXCLUSIVE
   ELSE
      Mensagem("A Tabela de Tipo de Produtos N„o Est  Disponivel !",4,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   vmask[1]:="@R 9.99"
ELSEIF tipo=2
   Sinal("BANCOS","CADASTRO")
   IF FILE("SAOBAN.DBF") .AND. FILE("SAOBAN1.NTX") .AND. FILE("SAOBAN2.NTX")
      SELECT 1
      USE SAOBAN INDEX SAOBAN1,SAOBAN2 ALIAS Tab EXCLUSIVE
   ELSE
      Mensagem("A Tabela de Bancos N„o Est  Disponivel !",4,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   vmask[1]:="999"
ELSEIF tipo=3
   Sinal("TIPO PAGTO","CADASTRO")
   IF FILE("SAOTPG.DBF") .AND. FILE("SAOTPG1.NTX") .AND. FILE("SAOTPG2.NTX")
      SELECT 1
      USE SAOTPG INDEX SAOTPG1,SAOTPG2 ALIAS Tab EXCLUSIVE
   ELSE
      Mensagem("A Tabela de Tipos de Pagamento N„o Est  Disponivel !",4,1)
      CLOSE DATABASE
      RETURN
   ENDIF
   vmask[1]:="!!!"
ENDIF
Abrejan(2)
@ 23,01 SAY REPLICATE("Í",78)
SETCOLOR(vcr)
@ 23,01 SAY " F9 Impr.  F5 C¢digo  F6 Nome        [Ins] [Del] [PgUp] [PgDn] [Enter]  [Esc] "
@ 23,32 SAY CHR(24)
@ 23,35 SAY CHR(25)
pos1:=INT((77-MAX(LEN(codi),LEN(vcabe[01]))-MAX(LEN(nome),LEN(vcabe[02])))/2)
pos2:=pos1+MAX(LEN(codi),LEN(vcabe[01]))+3
SETCOLOR(vcn)
DBEDIT(03,01,22,78,vdado,"Ftab",vmask,vcabe,"Ä"," ³ ")
CLOSE DATABASE
RETURN
*******************************************************************************
FUNCTION Ftab(modo)
// Funcao para Consulta com DBEDIT
*******************************************************************************
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
   ELSEIF LASTKEY()=K_ENTER
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
      @ vlin-1, 01 TO vlin+1,78
      SETCOLOR(vcr)
      @ vlin, pos1 SAY codi PICTURE vmask[1]
      SETCOLOR(vcn)
      @ vlin, pos2  GET nome PICTURE vmask[2]
      Aviso(24,"Altere os Dados ou Tecle <PgDn>")
      Le()
      IF UPDATED()
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(2)
      ELSE
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(1)
      ENDIF
   ELSEIF LASTKEY()=K_INS
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
      vcodi:=SPACE(LEN(codi))
      vnome:=SPACE(LEN(nome))
      @ vlin-1, 01 TO vlin+1,78
      SETCOLOR(vcn)
      @ vlin, pos1 GET vcodi PICTURE vmask[1]
      @ vlin, pos2 GET vnome PICTURE vmask[2]
      Aviso(24,"Digite os Novos Dados")
      Le()
      IF EMPTY(vcodi)
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(1)
      ENDIF
      SET ORDER TO 1
      SEEK vcodi
      IF FOUND()
         Mensagem("Desculpe, C¢digo j  Cadastrado !",3,1)
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(1)
      ENDIF
      IF Confirme()
         APPEND BLANK
         REPLACE codi WITH vcodi,nome WITH vnome
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(2)
      ENDIF
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN(1)
   ELSEIF LASTKEY()=K_DEL
      vlin:=ROW()
      vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
      @ vlin-1, 01 TO vlin+1,78
      SETCOLOR(vcr)
      @ vlin, pos1 SAY codi PICTURE vmask[1]
      @ vlin, pos2 SAY nome PICTURE vmask[2]
      SETCOLOR(vcn)
      IF Exclui()
         DELETE
         SKIP
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(2)
      ELSE
         RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
         RETURN(1)
      ENDIF
   ELSEIF LASTKEY()=K_F9
      vreg:=RECNO()
      vtela:=SAVESCREEN(01,00,23,79)
      Reltab(tipo)
      GO vreg
      RESTSCREEN(01,00,23,79,vtela)
      RETURN(2)
   ELSEIF LASTKEY()=K_F5
      @ 24,00 CLEAR
      SET ORDER TO 1
      vcodi:=SPACE(LEN(vdado[1]))
      @ 24,20 SAY "C¢digo Desejado: " GET vcodi PICTURE vmask[1]
      Le()
      IF EMPTY(vcodi)
         RETURN(1)
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
      vnome:=SPACE(LEN(nome))
      @ 24,05 SAY "Nome Desejado: " GET vnome PICTURE vmask[2]
      Le()
      IF EMPTY(vnome)
         RETURN(1)
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
   ELSE
      // Salva a tela.
      vtela:=SAVESCREEN(01,00,23,79)
      Abrejan(2)
      SETCOLOR(vci)
      Aviso(6,"   Auxilio ao Usu rio   ")
      SETCOLOR(vca)
      @ 08,12 SAY " Tecla                Fun‡„o"
      SETCOLOR(vcn)
      @ 10,12 SAY "[Setas] - p/ Cima e p/ Baixo, posicionam no registro desejado"
      @ 11,12 SAY "[Setas] - p/ Direita e p/ Esquerda, posicionam no pr¢ximo campo"
      @ 12,12 SAY "[PgUp]  - Retorna para a Janela Anterior"
      @ 13,12 SAY "[PgDn]  - Avan‡a para a Pr¢xima Janela"
      @ 14,12 SAY "[Home]  - Retorna para o Inicio do Registro"
      @ 15,12 SAY "[End]   - Avan‡a para o Fim do Registro"
      @ 16,12 SAY "[Enter] - Edita o Registro"
      @ 17,12 SAY "[Esc]   - Finaliza"
      @ 18,12 SAY "[Ins]   - Inclui um Novo Registro"
      @ 19,12 SAY "[Del]   - Exclui o Registro"
      @ 20,12 SAY "[F5]    - Pesquisa pelo C¢digo"
      @ 21,12 SAY "[F6]    - Pesquisa pelo Nome"
      @ 22,12 SAY "[F9]    - Impress„o da Tabela"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,23,79,vtela)
      RETURN(1)
   ENDIF
ENDIF
RETURN(1)
*******************************************************************************
STATIC PROCEDURE Reltab(tipo)
// Relatorio das Tabelas
*******************************************************************************
IF tipo=1
   Sinal("PRODUTO","RELATORIO")
   vtit1:="RelatÑrio dos Tipos de Produto"
ELSEIF tipo=2
   Sinal("BANCOS","RELATORIO")
   vtit1:="RelatÑrio dos Bancos"
ELSEIF tipo=3
   Sinal("PAGAMENTOS","RELATORIO")
   vtit1:="RelatÑrio dos Tipos de Pagamento"
ENDIF
vtit2:="Ordem de Codigo"
tk:=0
IF !Imprime("Relat¢rio das Tabelas")
   RETURN
ENDIF
pg:=0
GO TOP
SET DEVICE TO PRINT
DO WHILE !EOF()
   Cabe(emp[2],vsist,vtit1,vtit2,80,vcia10)
   @ PROW()+1,13 SAY "CÑdigo"
   @ PROW(), 36 SAY "D e n o m i n a Æ Ä o"
   @ PROW()+1,0 SAY REPLICATE("-",80)
   DO WHILE PROW()<58 .AND. .NOT. EOF()
      IF Escprint(80)
         RETURN
      ENDIF
      @ PROW()+1,pos1  SAY codi PICTURE vmask[1]
      @ PROW()  ,pos2  SAY nome PICTURE vmask[2]
      SKIP
   ENDDO
ENDDO
@ PROW()+2,0 SAY REPLICATE("=",80)
EJECT
SET DEVICE TO SCREEN
RETURN
*******************************************************************************
//                                  F i m
*******************************************************************************
