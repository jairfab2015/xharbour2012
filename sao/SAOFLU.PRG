********************************************************************************
/* Programa.: SAOFLU.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: M¢dulo do Fluxo de Caixa.         */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // Codigo das teclas
********************************************************************************
PROCEDURE Relflu()
// Relat¢rio do Fluxo de Caixa
********************************************************************************
Sinal("FLUXO","EMISSŽO")
// Abertura dos Arquivos de Dados.
IF FILE("SAOCP.DBF")
   SELECT 1
   USE SAOCP ALIAS Cp
   IF !FILE("SAOCP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCP1,SAOCP2,SAOCP3
ELSE
   Mensagem("Arquivo de Contas a Pagar N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET ORDER TO 3
IF FILE("SAOCR.DBF")
   SELECT 2
   USE SAOCR ALIAS Cr
   IF !FILE("SAOCR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCR1,SAOCR2,SAOCR3
ELSE
   Mensagem("Arquivo de Contas a Receber N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET ORDER TO 3
vdati:=vdatf:=CTOD(SPACE(8))
Pesqdat()
/*
Abrejan(2)
vsaldo:=0
@ 11,20 SAY "Digite o Saldo Inicial: " GET vsaldo PICTURE "@E 999,999,999.99" VALID vsaldo#0
Le()
*/
IF !Imprime("Relat¢rio do Fluxo de Caixa")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
cr:=cp:=.T.             // Controladores da impressao.
vtotcp:=vtotcr:=0       // Totalizadores.
SET DEVICE TO PRINTER   // Direciona para a impressora.
//SET PRINTER TO SAOREL.TXT
// DO WHILE principal
vdata:=vdati
DO WHILE vdata<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"RELATORIO DO FLUXO DE CAIXA","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,01 SAY "DOCUMENTO TIPO  EMISSAO        CREDOR / DEVEDOR                       V A L O R"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   DO WHILE PROW()<=60 .AND. vdata<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF cp
         cr:=.F.
         SELECT Cp
         SEEK DTOS(vdata)
         DO WHILE PROW()<=60 .AND. Cp->venc=vdata .AND. !EOF()
            // Impress„o dos dados.
            IF Cp->valpg=0
               @ PROW()+1,01 SAY Cp->docto
               @ PROW(),  12 SAY Cp->tipg
               @ PROW(),  16 SAY Cp->emis
               @ PROW(),  25 SAY LEFT(Cp->nome,40)
               @ PROW(),  66 SAY Cp->valor PICTURE "@E 999,999,999.99"
               vtotcp+=Cp->valor
            ENDIF
            SKIP
         ENDDO
         IF Cp->venc#vdata
            IF vtotcp#0
               @ PROW()+1,25 SAY "TOTAL A PAGAR EM "+DTOC(vdata)+":"
               @ PROW(),  66 SAY vtotcp PICTURE "@E 999,999,999.99"
               @ PROW()+1,00 SAY REPLICATE("-",80)
            ENDIF
            cr:=.T.
         ENDIF
      ENDIF
      IF cr
         cp:=.F.
         SELECT Cr
         SEEK DTOS(vdata)
         DO WHILE PROW()<=60 .AND. Cr->venc=vdata .AND. !EOF()
            // Impress„o dos dados.
            IF Cr->valpg=0
               @ PROW()+1,01 SAY Cr->docto
               @ PROW(),  12 SAY Cr->tipg
               @ PROW(),  16 SAY Cr->emis
               @ PROW(),  25 SAY LEFT(Cr->nome,40)
               @ PROW(),  66 SAY Cr->valor PICTURE "@E 999,999,999.99"
               vtotcr+=Cr->valor
            ENDIF
            SKIP
         ENDDO
         IF Cr->venc#vdata
            IF vtotcr#0
               @ PROW()+1,25 SAY "TOTAL A RECEBER EM "+DTOC(vdata)+":"
               @ PROW(),  66 SAY vtotcr PICTURE "@E 999,999,999.99"
               @ PROW()+1,00 SAY REPLICATE("-",80)
            ENDIF
            cp:=.T.
         ENDIF
      ENDIF
      IF cp
         IF (vtotcr-vtotcp#0)
            @ PROW()+1,25 SAY "DIFERENCA EM "+DTOC(vdata)+":"
            @ PROW(),  66 SAY vtotcr-vtotcp PICTURE "@E 999,999,999.99"
            @ PROW()+1,00 SAY REPLICATE("=",80)
            vtotcr:=vtotcp:=0
         ENDIF
         ++vdata
      ENDIF
   ENDDO
ENDDO
SET DEVICE TO SCREEN
EJECT
CLOSE DATABASE
RETURN
/*
DOCUMENTO TIPO  EMISSAO           C R E D O R / D E V E D O R         V A L O R
9999999999 XXX 99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99*/
********************************************************************************
//                                F I M
********************************************************************************
