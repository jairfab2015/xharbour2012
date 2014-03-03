********************************************************************************
/* Programa.: SAOPED.PRG
   Autor....: Antonio Geraldo Vidal  
   Data.....: 07/02/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento de Pedidos. */
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matped(modo)
/* Manuten‡„o dos Pedidos - 1- Inclus„o
                            2- Altera‡„o
                            3- Exclus„o
*/
********************************************************************************
// Declara os vetores privados que ser„o utilizados para editar os itens.
PRIVATE mcod[66],mqtd[66],mpre[66],lpre[66],vcod,vqtd,vpre,n
/* mcod[]/vcod: c¢digo dos produtos.
   mqtd[]/vqtd: quantidade solicitada.
   mpre[]/vpre: pre‡o unit rio bruto.
   lpre[]     : pre‡o unit rio l¡quido.
   n: verifica produto j  cadastrado.*/
// Declara as vari veis privadas de controle da edi‡„o na tela.
PRIVATE vli,li,lf,vt,vord,vok,mudap
/* vli:  linha inicial para edi‡„o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens do pedido
   vok:  existˆncia do pedido
   mudap:mudan‡a de produto de um item.*/
// Inicializa a linha inicial para edi‡„o dos itens.
vli:=10
// Abertura dos arquivos de dados
IF FILE("SAOPRO.DBF")
   // Produtos
   SELECT 1
   USE SAOPRO ALIAS Prod
   // Se n„o forem encontrados os arquivos de ¡ndice.
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo dos Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOFOR.DBF")
   // Fornecedores
   SELECT 2
   USE SAOFOR ALIAS Forne
   IF !FILE("SAOFOR1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOFOR1,SAOFOR2
ELSE
   Mensagem("Arquivo dos Fornecedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPED.DBF")
   // Pedidos
   SELECT 3
   USE SAOPED ALIAS Ped
   IF !FILE("SAOPED1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPED1,SAOPED2,SAOPED3
ELSE
   Mensagem("Arquivo dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPDI.DBF")
   // Itens dos Pedidos
   SELECT 4
   USE SAOPDI ALIAS Pdi
   IF !FILE("SAOPDI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPDI1.NTX
ELSE
   Mensagem("Arquivo dos Itens dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOM.DBF")
   // Pedidos
   SELECT 5
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM1
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 6
   USE SAOOPE ALIAS Ope
   IF !FILE("SAOOPE1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOOPE1,SAOOPE2
ELSE
   Mensagem("Tabela de Opera‡”es N„o Encontrada no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
// Apresenta a opera‡„o escolhida.
IF modo=1
   Sinal("PEDIDOS","INCLUSŽO")
ELSEIF modo=2
   Sinal("PEDIDOS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("PEDIDOS","EXCLUSŽO")
ENDIF
// Abre a janela de dados.
Abrejan(2)
SELECT Ped
DO WHILE .T.
   // Inicializa as vari veis auxiliares para edi‡„o dos dados.
   vnupd:=SPACE(5)
   vdata:=vvenc:=CTOD(SPACE(8))
   vcodfor:=SPACE(5)
   vforne:=SPACE(40)
   vvalor:=valiq:=vvalef:=vpicms:=vicms:=vpipi:=vipi:=0
   vopera:=SPACE(6)
   vdesc:=SPACE(50)
   vok:=.F.
   // Apresenta os dados dos pedidos na tela.
   Tela()
   DO WHILE .T.
      // Solicita o n£mero do pedido a ser editado.
      vnupd:=SPACE(5)
      @  3,20 GET vnupd  PICTURE "99999"
      Aviso(24,"Digite o N§ do Pedido ou telce [Esc] para Finalizar")
      Le()
      /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero do pedido
         estiver em branco.*/
      IF LASTKEY()=K_ESC .OR. EMPTY(vnupd)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Funcao Zeracod(): coloca zeros na frente do numero do pedido.
      vnupd:=Zeracod(vnupd)
      // Pesquisa o pedido no arquivo.
      IF modo=1
         SELECT Com
         SEEK vnupd
         IF FOUND()
            Mensagem("Desculpe, Compra j  Cadastrada!",5,1)
            LOOP
         ENDIF
      ENDIF
      SELECT Ped
      SEEK vnupd
      IF FOUND()
         // Se foi encontrado a vari vel vok torna-se verdadeira.
         vok:=.T.
      ELSE
         IF modo=2 .OR. modo=3
            // Se n„o foi encontrado retorna se for altera‡„o ou exclus„o.
            Mensagem("Desculpe, Pedido N„o Encontrado !",6,1)
            LOOP
         ENDIF 
      ENDIF
      EXIT
   ENDDO
   // Inicializa os vetores dos itens dos pedidos.
   AFILL(mcod,SPACE(6));AFILL(mqtd,0);AFILL(mpre,0);AFILL(lpre,0)
   // Inicializa as vari veis de controle da tela.
   li:=lf:=1;vt:=0;vord:=0
   /* Se o pedido tiver sido encontrado, transfere os dados dos arquivos para
      as vari veis auxiliares de edi‡„o.*/
   IF vok
      @ 24,00 CLEAR
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      // Transfere os dados dos pedidos para as vari veis auxiliares.
      Transfere()
      k:=1
      vvalor:=valiq:=0
      // Transferˆncia dos dados dos itens dos pedidos para os vetores.
      SELECT Pdi
      SEEK vnupd
      IF FOUND()
         DO WHILE vnupd=nupd .AND. !EOF()
            mcod[k]:=Pdi->codpro // c¢digo dos produtos.
            mqtd[k]:=Pdi->quant  // quantidade solicitada.
            mpre[k]:=Pdi->preun  // pre‡o unit rio bruto de compra.
            lpre[k]:=Pdi->preul  // pre‡o unit rio l¡quido de compra.
            // Calcula o valor total bruto do pedido.
            vvalor+=(mpre[k]*mqtd[k])
            // Calcula o valor total l¡quido do pedido, sem IPI.
            valiq+=(lpre[k]*mqtd[k])
            SKIP
            ++k
         ENDDO
         // Define o n£mero total de itens do pedido.
         vord:=k-1
      ENDIF
      // Define a £ltima linha de edi‡„o dos itens do pedido (lf).
      IF vord>=(22-vli)
         lf:=(22-vli)
      ELSE
         lf:=k
      ENDIF
      @ 24,00 CLEAR
      // Calcula o valor do ICMS e do IPI.
      vicms:=valiq*(vpicms/100)
      vipi :=vvalor-valiq
      // Apresenta os dados do pedido na tela.
      Tela()
      // Apresenta os dados dos itens do pedido na tela.
      Mostra(1,vord,vcn)
   ENDIF
   // Se a opera‡„o for exclus„o de pedidos.
   IF modo=3
      // Solicita confirma‡„o da exclus„o do pedido apresentado.
      IF Exclui()
         // Deleta os itens do pedido.
         SELECT Pdi
         SEEK vnupd
         DO WHILE nupd=vnupd .AND. !EOF()
            SELECT Prod
            SEEK Pdi->codpro
            SELECT Pdi
            // Atualiza o saldo de pedidos no arquivo dos Produtos.
            IF Prod->pedid<Pdi->quant
               Prod->pedid:=0
            ELSE
               Prod->pedid:=Prod->pedid-Pdi->quant
            ENDIF
            // Deleta os itens do pedido.
            DELETE
            SKIP
         ENDDO
         // Deleta o pedido.
         SELECT Ped
         DELETE
      ENDIF
      // Limpa a tela.
      @ 24,00 CLEAR
      FOR i=22 TO vli+1 STEP -1
          @ i,01 SAY SPACE(78)
      NEXT
      SELECT Ped
      // Retorna para realizar outra exclus„o.
      LOOP
   ENDIF
   // Se for inclus„o ou altera‡„o de pedidos.
   DO WHILE .T.
      // Edita os dados do pedido enquanto n„o houver confirma‡„o.
      Edita()
      IF Confirme()
         // Finaliza se a edi‡„o for confirmada.
         EXIT
      ENDIF
   ENDDO
   // Inclui um novo pedido se for inclus„o e o mesmo ainda n„o existir.
   SELECT Ped
   IF modo=1 .AND. !vok
      APPEND BLANK
      Ped->nupd:=vnupd
   ENDIF
   // Edi‡„o dos itens do pedido.
   DO WHILE .T.
      // Apresenta a linha de orienta‡„o ao usu rio.
      SETCOLOR(vcr)
      @ 23,01 SAY "    Sobe      Desce   [Ins]  Inclui/Altera   [Del]  Exclui   [Esc]  Finaliza "
      @ 23,02 SAY CHR(24)
      @ 23,12 SAY CHR(25)
      // Apresenta a setinha indicando o item selecionado.
      SETCOLOR(vcp)
      @ vli+li,1 SAY "Í"+CHR(16)
      // Mostra o item selecionado.
      Mostra(li,li,vca)
      // Aguarda o pressionamento de uma tecla de controle pelo usu rio.
      tk:=INKEY(0)
      IF tk=K_INS 
         // Pressionada a tecla <Ins>: inclus„o ou altera‡„o de um item.
         // Transfere para vari veis o conte£do dos vetores do item.
         vcod:=mcod[li+vt] // c¢digo do produto.
         vqtd:=mqtd[li+vt] // quantidade solicitada.
         vpre:=mpre[li+vt] // pre‡o unit rio bruto.
         mudap:=.F.        // mudan‡a de produto falsa.
         // Solicita o c¢digo do produto.
         @ vli+li, 04  GET vcod PICTURE "@R 9.99.999"
         Aviso(24,"Digite o C¢digo do Produto")
         Le()
         /* Pesquisa o c¢digo do produto atrav‚s da tabela fornecida pela
            fun‡„o Acha(), no programa SAOBIB.PRG.*/
         vcod:=Acha(vcod,"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
         // Retorna se o c¢digo estiver em branco.
         IF EMPTY(vcod)
            @ vli+li,03 SAY SPACE(76)
            LOOP
         ENDIF
         // Verifica se houve mudan‡a de c¢digo do produto.
         IF vcod#mcod[li+vt] .AND. mcod[li+vt]#SPACE(6)
            // Houve mudan‡a, mudap torna-se verdadeira.
            mudap=.T.
         ENDIF
         // Reapresenta o c¢digo na tela.
         @ vli+li,04 SAY vcod PICTURE "@R 9.99.999"
         /* Se houve mudan‡a de produto, verifica se o mesmo j  n„o foi
            inclu¡do no pedido, num dos outros itens j  cadastrados.*/
         // Verifica que o produto j  est  cadastrado nos itens.
         n:=ASCAN(mcod,vcod)
         IF n#0 .AND. n#(li+vt)
            Mensagem("Desculpe, Produto j  Presente Neste Pedido !",6,1)
            IF !EMPTY(mcod[li+vt])
               @ vli+li,04 SAY mcod[li+vt] PICTURE "@R 9.99.999"
            ELSE
               @ vli+li,03 SAY SPACE(76)
            ENDIF
            // Retorna se j  estiver cadastrado no pedido.
            LOOP
         ENDIF
         // Apresenta o nome do produto na tela.
         @ vli+li, 13 SAY LEFT(Prod->nome,40)
         // Solicita a quantidade.
         @ vli+li, 54 GET vqtd PICTURE "999,999.99" VALID(vqtd>0)
         Aviso(24,"Digite a Quantidade em "+TRIM(Prod->unid))
         Le()
         @ vli+li,54 SAY vqtd PICTURE "@E 999,999.99"
         // Solicita o pre‡o unit rio.
         @ vli+li,65 GET vpre PICTURE "999,999,999.99"
         Aviso(24,"Digite o Pre‡o Unit rio Bruto")
         Le()
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         // Atualiza o arquivo dos Produtos.
         SELECT Prod
         SEEK vcod
         // Al¡quota do IPI.
         vpipi:=Prod->pipi
         IF mudap     // Houve mudan‡a de produto.
            // Atualiza o saldo do produto.
            Prod->pedid:=(Prod->pedid+vqtd)
            // Atualiza o produto anterior.
            SEEK mcod[li+vt]
            IF Prod->pedid<mqtd[li+vt]
               Prod->pedid:=0
            ELSE
               Prod->pedid:=(Prod->pedid-mqtd[li+vt])
            ENDIF
         ELSE
            // Atualiza o saldo do produto.
            Prod->pedid:=(Prod->pedid+vqtd-mqtd[li+vt])
         ENDIF
         SELECT Prod
         SEEK vcod
         // Atualiza os itens do pedido.
         SELECT Pdi
         IF mudap     // Houve mudan‡a de produto.
            SEEK vnupd+mcod[li+vt]
            Pdi->codpro:=vcod
         ELSE         // N„o houve mudan‡a de produto.
            SEEK vnupd+vcod
            IF !FOUND()
               // Se o item ainda n„o existir no pedido, inclui um novo.
               ++vord  // Aumenta o n£mero de itens do pedido.
               APPEND BLANK
               Pdi->nupd:=vnupd;Pdi->codpro:=vcod;Pdi->item:=STRZERO(vord,2)
            ENDIF
            // Atualiza os dados do item.
            Pdi->quant:=vqtd;Pdi->preun:=vpre;Pdi->preco:=vpre*vqtd
            Pdi->codfor:=vcodfor;Pdi->data:=vdata;Pdi->preul:=vpre*(1-vpipi/100)
         ENDIF
         // Atualiza o valor do pedido.
         vvalor:=vvalor-mpre[li+vt]*mqtd[li+vt]+vpre*vqtd
         valiq :=valiq-lpre[li+vt]*mqtd[li+vt]+vpre*(1-vpipi/100)*vqtd
         // Calcula o valor do ICMS e do IPI.
         vicms :=valiq*(vpicms/100)
         vipi  :=vvalor-valiq
         // Reapresenta o valor total do pedido, o ICMS e o IPI.
         SETCOLOR(vcr)
         @  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
         @  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
         @  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o vetor dos itens do pedido.
         mcod[li+vt]:=vcod;mqtd[li+vt]:=vqtd;mpre[li+vt]:=vpre;lpre[li+vt]:=vpre*(1-vpipi/100)
         // Reapresenta o item.
         @ vli+li,01 SAY SPACE(2)
         Mostra(li,li,vcn)
         // Incrementa uma linha de edi‡„o.
         IF li<(22-vli)
            ++li
         ELSE
            // Realiza o rolamento da tela.
            IF vt<(66-(22-vli))
               ++vt
               SCROLL(vli+1,1,22,78,1)
               Mostra(li,li,vcn)
            ENDIF
         ENDIF
         // Atualiza a linha final.
         IF lf<li
            lf:=li
         ENDIF
      ELSEIF tk=K_UP
         // Foi pressionada a Seta para Cima: desloca para o item anterior.
         @ vli+li,01 SAY SPACE(2)
         // Mostra o item.
         Mostra(li,li,vcn)
         // Decrementa a linha dos itens.
         IF li>1
            --li
         ELSE
            // Realiza o rolamento da tela.
            IF vt>0
               --vt
               SCROLL(vli+1,1,22,78,-1)
               // Mostra o item.
               Mostra(li,li,vcn)
            ENDIF
         ENDIF
      ELSEIF tk=K_DOWN
         // Foi pressionada a Seta para Baixo: desloca para o item seguinte.
         @ vli+li,01 SAY SPACE(2)
         // Mostra o item.
         Mostra(li,li,vcn)
         // Incrementa a linha dos itens.
         IF li<lf
            ++li
         ELSE
            // Realiza o rolamento da tela.
            IF vt<(66-(22-vli)) .AND. !EMPTY(mcod[li+vt])
               ++vt
               SCROLL(vli+1,1,22,78,1)
               // Mostra o item.
               Mostra(li,li,vcn)
            ENDIF
         ENDIF
      ELSEIF tk=K_DEL
         // Foi pressionada a tecla <Del>: exclus„o de itens.
         SELECT Pdi
         // Pesquisa o item no arquivo.
         SEEK vnupd+mcod[li+vt]
         IF FOUND()
            // Atualiza o arquivo dos Produtos.
            SELECT Prod
            SEEK mcod[li+vt]
            IF pedid>=mqtd[li+vt]
               Prod->pedid:=(pedid-mqtd[li+vt])
            ELSE
               Prod->pedid:=0
            ENDIF
         ENDIF
         SELECT Pdi
         // Deleta o item do pedido.
         DELETE
         // Diminui a quantidade de itens do pedido.
         --vord
         // Atualiza o valor do pedido.
         vvalor:=vvalor-mpre[li+vt]*mqtd[li+vt]
         valiq :=valiq- lpre[li+vt]*mqtd[li+vt]
         // Calcula o valor do ICMS e do IPI.
         vicms:=valiq*(vpicms/100)
         vipi :=vvalor-valiq
         // Reapresenta o valor total do pedido, o ICMS e o IPI.
         SETCOLOR(vcr)
         @  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
         @  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
         @  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o n£mero dos itens do pedido.
         REPLACE Pdi->item WITH STR(VAL(item)-1,2) WHILE vnupd=Pdi->nupd
         // Atualiza o vetor dos itens, eliminando o elemento deletado.
         ADEL(mcod,li+vt);ADEL(mqtd,li+vt);ADEL(mpre,li+vt);ADEL(lpre,li+vt)
         // Atualiza as linhas de controle de edi‡„o na tela.
         IF vt>0
            --vt
         ELSE
            IF lf>1 .AND. lf<(22-vli)
               --lf
            ENDIF
         ENDIF
         // Reapresenta os itens do pedido, eliminando o que foi deletado.
         Mostra(1,(22-vli),vcn)
      ELSEIF tk=K_ESC
         // Foi pressionada a tecla <Esc>: finaliza a edi‡„o dos itens.
         IF Confirme()
            // Finaliza se for confirmado.
            SELECT Ped
            // Atualiza o pedido, gravando as vari veis auxiares no registro do arquivo.
            Atualiza()
            // Atualiza os itens do pedido.
            Atualitem()
            EXIT
         ENDIF
      ENDIF
   ENDDO
   // Limpa a tela.
   @ 24,00 CLEAR
   FOR i=22 TO vli+1 STEP -1
       @ i,01 SAY SPACE(78)
   NEXT
   SELECT Ped
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Tela()
// Apresenta os dados dos pedidos na tela.
********************************************************************************
SETCOLOR(vcn)
@  3, 2 SAY "N£mero do Pedido: "
@  3,27 SAY "Data do Pedido: "
@  3,53 SAY "Data de Entrega: "
@  5, 2 SAY "Fornecedor:   C¢digo: "
@  5,32 SAY "Nome: "
@  7, 2 SAY "Valor: "
@  7,23 SAY "Encargos: "
@  7,47 SAY "%ICMS: "
@  7,60 SAY "ICMS: "
@  8,60 SAY "IPI_: "
@  9, 2 SAY "Oper: "
@  9,17 SAY "Descri‡„o: "
SETCOLOR(vcr)
@ 03,20 SAY vnupd       PICTURE "99999"
@ 03,43 SAY vdata       PICTURE "99/99/99"
@ 03,70 SAY vvenc       PICTURE "99/99/99"
@ 05,24 SAY vcodfor     PICTURE "99999"
@ 05,38 SAY vforne      PICTURE "@!"
@ 07,09 SAY vvalor      PICTURE "@E 99,999,999.99"
@ 07,33 SAY vvalef      PICTURE "@E 99,999,999.99"
@ 07,54 SAY vpicms      PICTURE "99.99"
@ 07,66 SAY vicms       PICTURE "@E 9,999,999.99"
@ 08,66 SAY vipi        PICTURE "@E 9,999,999.99"
@ 09,08 SAY vopera      PICTURE "@R 9.99.999"
@ 09,28 SAY vdesc       PICTURE "@!"
SETCOLOR(vcn)
@ 10, 01  SAY "ÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit.ÍÍÍ"
/* M scara de edi‡„o dos itens do pedido.
ÍÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit.Í"
Í> 9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999,999.99
*/
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados do pedido na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,20 SAY vnupd       PICTURE "99999"
SETCOLOR(vcn)
@  3,43 GET vdata       PICTURE "99/99/99" VALID !EMPTY(vdata)
@  3,70 GET vvenc       PICTURE "99/99/99"
@  5,24 GET vcodfor     PICTURE "99999"
Le()
// Apresenta uma tabela de consulta para o fornecedor.
vcodfor:=Acha(vcodfor,"Forne",1,2,"codi","nome","99999","@!",15,05,22,76)
SETCOLOR(vcr)
@  5,24 SAY vcodfor     PICTURE "99999"
// Apresenta o nome do fornecedor.
vforne:=LEFT(Forne->nome,40)
@  5,38 SAY vforne      PICTURE "@!"
@  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
SETCOLOR(vcn)
@  7,33 GET vvalef      PICTURE "@E 99,999,999.99"
@  7,54 GET vpicms      PICTURE "99.99"
Le()
// Calcula o ICMS e o IPI.
vicms:=valiq*(vpicms/100)
vipi :=vvalor-valiq
SETCOLOR(vcr)
@  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
@  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
SETCOLOR(vcn)
@  9,08 GET vopera      PICTURE "@R 9.99.999"
Le()
// Apresenta uma tabela de consulta para a opera‡„o.
vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
SETCOLOR(vcr)
@  9,08 SAY vopera      PICTURE "@R 9.99.999"
SETCOLOR(vcn)
IF EMPTY(vdesc)
   vdesc:=Ope->nome
ENDIF
@  9,28 GET vdesc       PICTURE "@!"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(ni,nf,vcor)
// Apresenta os itens dos pedidos na tela.
/* ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr„o de cor a serem apresentados os itens.*/
********************************************************************************
LOCAL i
SELECT Prod
SET ORDER TO 1
SETCOLOR(vcor)
// Apresenta os itens solicitados na tela.
FOR i=ni TO IF(nf<23-vli,nf,22-vli)
   IF !EMPTY(mcod[i+vt])
      SEEK mcod[i+vt]
      @ vli+i, 04 SAY mcod[i+vt] PICTURE "@R 9.99.999"
      @ vli+i, 13 SAY LEFT(Prod->nome,40)
      @ vli+i, 54 SAY mqtd[i+vt]  PICTURE "@E 999,999.99"
      @ vli+i, 65 SAY mpre[i+vt]  PICTURE "@E 999,999,999.99"
   ELSE
      @ vli+i, 3 SAY SPACE(76)
   ENDIF
NEXT
SETCOLOR(vcn)
SELECT Ped
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados do arquivo para as vari veis auxiliares.
********************************************************************************
vdata  :=Ped->data
vvenc  :=Ped->venc
vcodfor:=Ped->codfor
vforne :=Ped->forne
vvalor :=Ped->valor
vvalef :=Ped->valef
vpicms :=Ped->picms
vicms  :=Ped->icms
vopera :=Ped->opera
vdesc  :=Ped->desc
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados do arquivo com as vari veis auxiliares.
********************************************************************************
LOCAL i:=0
SELECT Ped
Ped->data  :=vdata
Ped->venc  :=vvenc
Ped->codfor:=vcodfor
Ped->forne :=vforne
Ped->valor :=vvalor
Ped->valef :=vvalef
Ped->picms :=vpicms
Ped->icms  :=vicms
Ped->opera :=vopera
Ped->desc  :=vdesc
RETURN
********************************************************************************
STATIC PROCEDURE Atualitem()
// Atualiza os dados dos itens com as vari veis auxiliares.
********************************************************************************
SELECT Pdi
SEEK vnupd
IF FOUND()
   DO WHILE vnupd=nupd .AND. !EOF()
      Pdi->item:=STRZERO(++i,2) // Numero sequencial do item.
      Pdi->data:=vdata          // Data do pedido.     
      Pdi->codfor:=vcodfor      // Codigo do fornecedor.
      SKIP
   ENDDO
ENDIF
SELECT Ped
RETURN
********************************************************************************
PROCEDURE Consped()
// Consulta dos Pedidos na Tela
********************************************************************************
// Abertura dos arquivos de dados
IF FILE("SAOPRO.DBF")
   // Produtos
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1
ELSE
   Mensagem("Arquivo dos Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPED.DBF")
   // Pedidos
   SELECT 2
   USE SAOPED ALIAS Ped
   IF !FILE("SAOPED1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPED1,SAOPED2,SAOPED3
ELSE
   Mensagem("Arquivo dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPDI.DBF")
   // Itens dos Pedidos
   SELECT 3
   USE SAOPDI ALIAS Pdi
   IF !FILE("SAOPDI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPDI1
ELSE
   Mensagem("Arquivo dos Itens dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ped
// Inicializa as vari veis auxiliares.
vli:=10
vnupd  :=SPACE(5)
vnunf  :=SPACE(7)
vdata  :=vvenc:=CTOD(SPACE(8))
vcodfor:=SPACE(5)
vforne :=SPACE(40)
vvalor :=vvalef:=vpicms:=vicms:=vipi:=vpipi:=0
vopera :=SPACE(6)
vdesc  :=SPACE(50)
// Constru‡„o da Tela de Apresenta‡„o.
Sinal("PEDIDOS","CONSULTAS")
Abrejan(2)
// Declara os vetores de consulta.
PRIVATE vdado[8],vmask[8],vcabe[8]
// Dados a serem apresentados.
vdado[01]:="nupd"
vdado[02]:="data"
vdado[03]:="opera"
vdado[04]:="venc"
vdado[05]:="forne"
vdado[06]:="valor"
vdado[07]:="valef"
vdado[08]:="icms"
// Cabe‡alhos das colunas.
vcabe[01]:="Pedido"
vcabe[02]:="Data"
vcabe[03]:="Opera‡„o"
vcabe[04]:="Entrega"
vcabe[05]:="Fornecedor"
vcabe[06]:="Valor"
vcabe[07]:="Encargos"
vcabe[08]:="ICMS"
// M scaras de apresenta‡„o.
vmask[01]:="99999"
vmask[03]:="@R 9.99.999"
vmask[05]:="@!"
vmask[06]:="@E 999,999,999.99"
vmask[07]:="@E 999,999,999.99"
vmask[08]:="@E 99,999,999.99"
// Linha de orienta‡„o ao usu rio.
SETCOLOR(vcr)
@ 23,02 SAY PADC("F1 Help  F5 N£mero  F6 Fornecedor  F9 Data  [PgUp] [PgDn]  [Enter]  [Esc]",76)
SETCOLOR(vcn)
// Executa a fun‡„o DBEDIT().
DBEDIT(03,01,22,78,vdado,"Fxpd",vmask,vcabe,"Ä","³")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fxpd(modo)
// Fun‡ao para Consulta aos Pedidos atrav‚s da DBEDIT()
********************************************************************************
IF modo=4
   IF LASTKEY()=K_ENTER
      // Foi pressionada a tecla <Enter>: apresenta‡„o dos itens do pedido.
      vtela:=SAVESCREEN(01,00,24,79) // Salva a tela de consulta.
      SETCOLOR(vcn)
      Abrejan(2)  // Abre a janela de dados.
      vnupd:=nupd
      Transfere() // Transfere os dados do arquivo para as vari veis auxiliares.
      Tela()      // Apresenta a tela do pedido.
      SELECT Pdi
      SEEK vnupd  // Pesquisa os itens do pedido.
      IF !FOUND()
         // Itens n„o encontrados.
         SETCOLOR(vca)
         Aviso(13,"Este Pedido N„o possui Itens !")
         SETCOLOR(vcn)
         INKEY(5)  // Aguarda 5 segundos.
      ELSE
         // Apresenta os itens do pedido.
         DO WHILE .T.
            i:=11
            DO WHILE i<23 .AND. nupd=vnupd .AND. !EOF()
               @ i  ,  4  SAY  Pdi->codpro PICTURE "@R 9.99.999"
               SELECT Prod
               SEEK Pdi->codpro
               SELECT Pdi
               @ i  , 13  SAY  LEFT(Prod->nome,40)
               SELECT Pdi
               @ i  , 54  SAY  Pdi->quant PICTURE "@E 999,999.99"
               @ i  , 65  SAY  Pdi->preun PICTURE "@E 999,999,999.99"
               ++i
               SKIP
            ENDDO
            DO WHILE ROW()<22
               // Limpa as linhas restantes da tela.
               @ ROW()+1,1 SAY SPACE(78)
            ENDDO
            // Apresenta a linha de orienta‡„o ao usu rio.
            SETCOLOR(vcr)
            @ 23,02 SAY PADC("[PgUp] Retorna   [PgDn] Avan‡a   [Esc] Finaliza",76)
            SETCOLOR(vcn)
            DO WHILE .T.
               // Aguarda o pressionamento de uma tecla de controle pelo usu rio.
               tk:=INKEY(0)
               IF tk=K_PGUP
                  // Foi pressionada a tecla <PgUp>: retrocede os itens.
                  SKIP -(22-vli)*2
                  IF Pdi->nupd#vnupd .OR. BOF()
                     SEEK vnupd
                  ENDIF
                  EXIT
               ELSEIF tk=K_PGDN
                  // Foi pressionada a tecla <PgDn>: avan‡a os itens.
                  SKIP -1
                  EXIT
               ELSEIF tk=K_ESC
                  // Foi pressionada a tecla <Esc>: finaliza.
                  @ 24,00 CLEAR
                  SELECT Ped
                  EXIT
               ENDIF
            ENDDO
            IF tk=K_ESC
               EXIT
            ENDIF
         ENDDO
      ENDIF
      // Reapresenta a tela de consulta.
      RESTSCREEN(01,00,24,79,vtela)
      SELECT Ped
      SETCOLOR(vcn)
      RETURN(1)
   ELSEIF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      // Pressionada a tecla <F5>: pesquisa pelo n£mero do pedido.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SELECT Ped
      SET ORDER TO 1
      // Solicita o n£mero do pedido desejado.
      vcd:=SPACE(5)
      @ 24,27 SAY "Pedido Desejado: " GET vcd PICTURE "99999"
      Le()
      // Retorna se o n£mero do pedido estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      vcd:=Zeracod(vcd)
      // Pesquisa o n£mero do pedido solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vcd)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Pedido N„o Encontrado !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando o pedido solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      // Pressionada a tecla <F6>: pesquisa pelo nome do fornecedor.
      @ 24,00 CLEAR
      // Define a ordem de pesquisa.
      SELECT Ped
      SET ORDER TO 2
      // Solicita o nome do fornecedor.
      vnome:=SPACE(40)
      @ 24,10 SAY "Fornecedor Desejado: " GET vnome PICTURE "@!"
      Le()
      // Retorna se o nome estiver em branco.
      IF EMPTY(vnome)
         RETURN(1)
      ENDIF
      rec:=RECNO() // Armazena o n£mero do registro atual.
      // Pesquisa o nome solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vnome)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Fornecedor N„o Encontrado !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta mostrando o fornecedor solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F9
      // Pressionada a tecla <F9>: pesquisa pela data do pedido.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SELECT Ped
      SET ORDER TO 3
      // Solicita a data do pedido desejado.
      vcd:=CTOD(SPACE(8))
      @ 24,27 SAY "Data Desejado: " GET vcd
      Le()
      // Retorna se a data do pedido estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa a data do pedido solicitado.
      SET SOFTSEEK ON
      SEEK vcd
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrado !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando o pedido solicitado.
      RETURN(2)
   ELSE
      /* Apresenta mensagens de aux¡lio ao usu rio se uma tecla impr¢pria for
         pressionada.*/
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      Abrejan(2)
      SETCOLOR(vcr)
      Aviso(5,"  HELP - Auxilio ao Usu rio  ")
      SETCOLOR(vca)
      @ 10,12 SAY " Tecla                Fun‡„o"
      SETCOLOR(vcn)
      @ 12,12 SAY "[Setas] - p/ Cima e p/ Baixo, posicionam no item desejado"
      @ 13,12 SAY "[PgUp]  - Retorna para a janela anterior"
      @ 14,12 SAY "[PgDn]  - Avan‡a para a pr¢xima janela"
      @ 15,12 SAY "[Home]  - Retorna para o inicio do arquivo"
      @ 16,12 SAY "[End]   - Avan‡a para o fim do arquivo"
      @ 17,12 SAY "[Enter] - Mostra os Itens do Pedido"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[F5]    - Pesquisa pelo N£mero do Pedido"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Fornecedor"
      @ 21,12 SAY "[F9]    - Pesquisa pela Data do Pedido"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ENDIF
ELSEIF modo=1
   Mensagem("In¡cio do Arquivo !",5)
   RETURN(1)
ELSEIF modo=2
   Mensagem("Fim do Arquivo !",5)
   RETURN(1)
ELSEIF modo=3
   Mensagem("N„o H  Dados Cadastrados no Arquivo !",8,1)
   RETURN(0)
ENDIF
RETURN(1)
********************************************************************************
PROCEDURE Relped1()
/*
Objetivo : emite os relat¢rios dos pedidos.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("PEDIDOS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOPED.DBF")
   // Pedidos
   SELECT 1
   USE SAOPED ALIAS Ped
   IF !FILE("SAOPED3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPED3
ELSE
   Mensagem("Arquivo dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ped
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujos pedidos devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Sint‚tico dos Pedidos")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=0                 // Totalizador.
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
// DO WHILE principal
DO WHILE !EOF() .AND. Ped->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Sintetico dos Pedidos","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,03 SAY "Nro.     DATA                  FORNECEDOR                     VALOR TOTAL"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Ped->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Ped->data>=vdati .AND. Ped->data<=vdatf
         @ PROW()+1,02 SAY Ped->nupd
         @ PROW(),  09 SAY Ped->data
         @ PROW(),  19 SAY Ped->forne
         @ PROW(),  61 SAY Ped->valor+Ped->valef+Ped->icms PICTURE "@E 999,999,999.99"
         vtot+=Ped->valor+Ped->valef+Ped->icms
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  59 SAY vtot PICTURE "@E 9,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
  Nro.     Data                  Fornecedor                     Valor Total         
 99999  99/99/99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99  */
********************************************************************************
PROCEDURE Relped2()
/*
Objetivo : emite os relat¢rios dos pedidos.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("PEDIDOS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOPRO.DBF")
   // Produtos
   SELECT 1
   USE SAOPRO ALIAS Prod
   // Se n„o forem encontrados os arquivos de ¡ndice.
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1
ELSE
   Mensagem("Arquivo dos Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPED.DBF")
   // Pedidos
   SELECT 2
   USE SAOPED ALIAS Ped
   IF !FILE("SAOPED3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPED3
ELSE
   Mensagem("Arquivo dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPDI.DBF")
   // Itens dos Pedidos
   SELECT 3
   USE SAOPDI ALIAS Pdi
   IF !FILE("SAOPDI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPDI1
ELSE
   Mensagem("Arquivo dos Itens dos Pedidos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
SELECT Ped
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujos pedidos devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Anal¡tico dos Pedidos")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
vtot:=0                 // Totalizador.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
SET SOFTSEEK ON
SEEK DTOS(vdati)
SET SOFTSEEK OFF
DO WHILE !EOF() .AND. Ped->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Analitico dos Pedidos","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Ped->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF Ped->data<vdati .OR. Ped->data>vdatf
         SKIP
         LOOP
      ENDIF
      // Impress„o dos dados.
      @ PROW()+2, 2 SAY "Numero do Pedido: "+Ped->nupd
      @ PROW(),  27 SAY "Data do Pedido: "+DTOC(Ped->data)
      @ PROW(),  53 SAY "Data de Entrega: "+DTOC(Ped->venc)
      @ PROW()+1, 2 SAY "Fornecedor: "+Ped->codfor+" - "+Ped->forne
      @ PROW()+1, 2 SAY "Valor:"+TRANSFORM(Ped->valor,"@E 999,999,999.99")
      @ PROW(),  23 SAY "Encargos:"+TRANSFORM(Ped->valef,"@E 999,999,999.99")
      @ PROW(),  47 SAY "%ICMS: "+TRANSFORM(Ped->picms,"@E 99.99")
      @ PROW(),  60 SAY "ICMS:"+TRANSFORM(Ped->icms,"@E 999,999,999.99")
      @ PROW()+1, 2 SAY "Operacao: "+TRANSFORM(Ped->opera,"@E 9.99.999")
      @ PROW(),  21 SAY "Descricao: "+TRIM(Ped->desc)
      SELECT Pdi
      IF pv
         vtot+=Ped->valor+Ped->valef
         SEEK Ped->nupd
         pv=.F.
      ENDIF
      IF Ped->nupd=Pdi->nupd
         @ PROW()+1,01 SAY "-Codigo-------Nome dos Produtos---------Quantidade-Custo Unitario---Custo Total-"
         DO WHILE Ped->nupd=Pdi->nupd .AND. PROW()<=60 .AND. !EOF() 
            @ PROW()+1,01 SAY Pdi->codpro PICTURE "@R 9.99.999"
            @ PROW(),  10 SAY LEFT(Prod->nome,32)
            @ PROW(),  43 SAY TRANSFORM(Pdi->quant,"@E 9,999.99")
            @ PROW(),  52 SAY TRANSFORM(Pdi->preco,"@E 999,999,999.99")
            @ PROW(),  67 SAY TRANSFORM(Pdi->quant*Pdi->preco,"@E 999,999,999.99")
            SKIP
         ENDDO
      ENDIF
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SELECT Ped
      IF Pdi->nupd#Ped->nupd
         SKIP
         pv:=.T.
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  64 SAY vtot PICTURE "@E 99,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
-Codigo-------Nome dos Produtos---------Quantidade-Custo Unitario---Custo Total-
9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9,999.99 999,999,999.99 999,999,999.99
*/
********************************************************************************
//                        Fim do Programa SAOPED.PRG
********************************************************************************
