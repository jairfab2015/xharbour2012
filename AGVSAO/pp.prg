#include "INKEY.CH"
PUBLIC vcn, vci, vca, vcp, vcr, vcia, tk, hlp:=0, i05, id5, i10, i12, i16, i20

DO SAOBIB
IF FILE("APOIO.DBF")
   SELECT 1
   USE APOIO ALIAS Cli
   SET INDEX TO SAOCLI1.NTX, SAOCLI2.NTX
ELSE
   Mensagem("Arquivo de Apoio N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
@ 06,04 SAY "C¢digo: "
@ 06,20 SAY "Nome: "
DO WHILE .T.
   vcodi :=SPACE(5)
   vnome :=SPACE(20)
   vdata:=CTOD(SPACE(8))
   @ 6,12 GET vcodi PICTURE "99999"
   Aviso(24,"Digite o Staff, ou Tecle [Esc] para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      CLOSE DATABASE
      RETURN
   ENDIF
   IF !EMPTY(vcodi)
      vcodi:=Zeracod(vcodi)
   ENDIF
   IF EMPTY(vcodi)
      vcodi:=Acha(vcodi,"Cli",1,2,"codi","nome","99999","@!",15,15,22,76)
   ENDIF
   SELECT Cli
   SEEK vcodi
   IF !FOUND()
         Mensagem("Desculpe, Cliente N„o Encontrado !",8,1)
         LOOP
   ENDIF
   vcodi :=Cli->codi
   vnome :=Cli->nome
   @ 06,12 SAY vcodi   PICTURE "99999"
   @ 06,26 SAY vnome   PICTURE "@!"
   SETCOLOR(vcn)
ENDDO 
