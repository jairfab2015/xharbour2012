********************************************************************************
/* Programa.: SAOCOM.PRG
   Autor....: Antonio Geraldo Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento de Compras e Transferˆncias Dep¢sito/Loja. */
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matcom(tipo,modo)
/* Manuten‡„o das Compras - Parƒmetros:tipo: 1- Compras para o dep¢sito
                                             2- Compras para a loja
                                       modo: 1- Inclus„o
                                             2- Altera‡„o
                                             3- Exclus„o
*/
********************************************************************************
// Declara os vetores privados que ser„o utilizados para editar os itens.
PRIVATE mcod[66],mqtd[66],mpre[66],lpre[66],vcod,vqtd,vpre,n
/* mcod[]/vcod: c¢digo dos produtos.
   mqtd[]/vqtd: quantidade solicitada.
   mpre[]/vpre: pre‡o unit rio bruto dos produtos.
   lpre[]     : pre‡o unit rio l¡quido dos produtos (sem IPI).
   n: verifica produto j  cadastrado.*/
// Declara as vari veis privadas de controle da edi‡„o na tela.
PRIVATE vli,li,lf,vt,vord,vok,mudap
/* vli:  linha inicial para edi‡„o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens da compra
   vok:  existˆncia da compra
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
   Mensagem("Arquivo das compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPDI.DBF")
   // Itens das compras
   SELECT 4
   USE SAOPDI ALIAS Pdi
   IF !FILE("SAOPDI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPDI1
ELSE
   Mensagem("Arquivo dos Itens das compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 5
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM1,SAOCOM2,SAOCOM3
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOI.DBF")
   // Itens das compras
   SELECT 6
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI1,SAOCOI2
ELSE
   Mensagem("Arquivo dos Itens de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 7
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
   Sinal("COMPRAS","INCLUSŽO")
ELSEIF modo=2
   Sinal("COMPRAS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("COMPRAS","EXCLUSŽO")
ENDIF
// Abre a janela de dados.
Abrejan(2)
SELECT Com
DO WHILE .T.
   // Inicializa as vari veis auxiliares para edi‡„o dos dados.
   vnupd  :=SPACE(5)
   vnunf  :=SPACE(7)
   vdata  :=vvenc:=CTOD(SPACE(8))
   vcodfor:=SPACE(5)
   vforne :=SPACE(40)
   vvalor :=valiq:=vvalef:=vpicms:=vicms:=vpipi:=vipi:=0
   vopera :=SPACE(6)
   vdesc  :=SPACE(50)
   vok    :=.T.
   // Apresenta os dados das compras na tela.
   Tela()
   DO WHILE .T.
      // Solicita o n£mero da compra a ser editado.
      vnupd:=SPACE(5)
      @  3,13 GET vnupd  PICTURE "99999"
      Aviso(24,"Digite o N§ do Pedido ou tecle [Esc] para Finalizar")
      Le()
      /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da compra
         estiver em branco.*/
      IF LASTKEY()=K_ESC .OR. EMPTY(vnupd)
         CLOSE DATABASE
         RETURN
      ENDIF
      vnupd:=Zeracod(vnupd)
      // Pesquisa a compra/transferˆncia no arquivo de compras.
      IF modo=1
         SELECT Com
         SEEK vnupd
         IF FOUND()
            Mensagem("Desculpe, Compra j  Cadastrada!",5,1)
            LOOP
         ELSE
            SELECT Ped
            SEEK vnupd
            IF !FOUND()
               vok:=.F.
            ENDIF
         ENDIF
      ELSE
         SELECT Com
         SEEK vnupd
         IF !FOUND()
            // Se n„o foi encontrado retorna se for altera‡„o ou exclus„o.
            Mensagem("Desculpe, Compra N„o Encontrada !",6,1)
            LOOP
         ENDIF
      ENDIF
      EXIT
   ENDDO
   // Inicializa os vetores dos itens das compras/transferˆncias.
   AFILL(mcod,SPACE(6));AFILL(mqtd,0);AFILL(mpre,0);AFILL(lpre,0)
   // Inicializa as vari veis de controle da tela.
   li:=lf:=1;vt:=0;vord:=0
   /* Se o compra tiver sido encontrado, transfere os dados dos arquivos para
      as vari veis auxiliares de edi‡„o.*/
   IF vok
      @ 24,00 CLEAR
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      // Transfere os dados para as vari veis auxiliares.
      Transfere()
      k:=1;vvalor:=valiq:=0
      // Transferˆncia dos dados dos itens das compras para os vetores.
      IF modo=1 .AND. tipo<3
         SELECT Pdi
      ELSE
         SELECT Coi
      ENDIF
      SEEK vnupd
      IF FOUND()
         DO WHILE vnupd=nupd .AND. !EOF()
            mcod[k]:=codpro // c¢digo dos produtos.
            mqtd[k]:=quant  // quantidade solicitada.
            mpre[k]:=preun  // pre‡o unit rio de compra.
            lpre[k]:=preul  // pre‡o unit rio l¡quido de compra.
           // Calcula o valor total da compra.
            vvalor+=(mpre[k]*mqtd[k])
            valiq+=(lpre[k]*mqtd[k])
            SKIP
            ++k
         ENDDO
         // Define o n£mero total de itens da compra.
         vord:=k-1
      ENDIF
      // Define a £ltima linha de edi‡„o dos itens da compra (lf).
      IF vord>(22-vli)
         lf:=(22-vli)
      ELSE
         lf:=k
      ENDIF
      @ 24,00 CLEAR
      // Calcula o valor do ICMS e do IPI.
      vicms:=valiq*(vpicms/100)
      vipi :=vvalor-valiq
      SELECT Com
      IF modo=1
         APPEND BLANK
         Com->nupd :=vnupd
         Com->ctipo:=STR(tipo,1)
         Atualiza()
         vvalor:=valiq:=0
         FOR i=1 TO vord
            SELECT Coi
            APPEND BLANK
            Coi->nupd:=vnupd
            Coi->codpro:=mcod[i]  // c¢digo dos produtos.
            Coi->quant :=mqtd[i]  // quantidade solicitada.
            Coi->preun :=mpre[i]  // pre‡o unit rio de compra.
            Coi->preul :=lpre[i]  // pre‡o unit rio l¡quido de compra.
            vvalor+=(mpre[i]*mqtd[i])
            valiq+=(lpre[i]*mqtd[i])
            SELECT Prod
            SEEK Coi->codpro
            IF tipo=1
               // Atualiza o saldo do estoque no dep¢sito.
               Prod->saldod:=Prod->saldod+Coi->quant
            ELSEIF tipo=2
               // Atualiza o saldo do estoque na loja.
               Prod->saldo:=Prod->saldo+Coi->quant
            ENDIF
            // Atualiza os custos.
            Prod->datue:=vdata;Prod->custr:=mpre[i];Prod->datcu:=vdata
            Prod->cusus:=Dolar(vdata,mpre[i]) // Atualiza o custo em d¢lar.
         NEXT
         // D  baixa no Pedido de Compra e atualiza o saldo de pedidos.
         SELECT Ped
         SEEK vnupd
         DELETE
         SELECT Pdi
         SEEK vnupd
         DO WHILE nupd=vnupd .AND. !EOF()
            SELECT Prod
            SEEK Pdi->codpro
            Prod->pedid:=IF(Prod->pedid-Pdi->quant>0,Prod->pedid-Pdi->quant,0)
            SELECT Pdi
            DELETE
            SKIP
         ENDDO
         SELECT Com 
      ENDIF
      // Apresenta os dados da compra na tela.
      Tela()
      // Apresenta os dados dos itens da compra na tela.
      Mostra(1,vord,vcn)
   ELSE
      SELECT Com
      APPEND BLANK
      Com->nupd:=vnupd
      Com->ctipo:=STR(tipo,1)
   ENDIF
   SELECT Com
   // Se a opera‡„o for exclus„o de compras/transferˆncias.
   IF modo=3
      // Solicita confirma‡„o da exclus„o da compra apresentada.
      IF Exclui()
         // Deleta os itens da compra.
         SELECT Coi
         SEEK vnupd
         DO WHILE nupd=vnupd .AND. !EOF()
            SELECT Prod
            SEEK Coi->codpro
            SELECT Coi
            IF tipo=1
               // Atualiza o saldo do estoque no dep¢sito.
               IF Prod->saldod<Coi->quant
                  Prod->saldod:=0
               ELSE
                  Prod->saldod:=Prod->saldod-Coi->quant
               ENDIF
            ELSEIF tipo=2
               // Atualiza o saldo do estoque na loja.
               IF Prod->saldo<Coi->quant
                  Prod->saldo:=0
               ELSE
                  Prod->saldo:=Prod->saldo-Coi->quant
               ENDIF
            ENDIF
            // Deleta os itens da compra.
            DELETE
            SKIP
         ENDDO
         // Deleta a compra.
         SELECT Com
         DELETE
      ENDIF
      // Limpa a tela.
      @ 24,00 CLEAR
      FOR i=22 TO vli+1 STEP -1
          @ i,01 SAY SPACE(78)
      NEXT
      SELECT Com
      // Retorna para realizar outra exclus„o.
      LOOP
   ENDIF
   // Se for inclus„o ou altera‡„o de compras.
   DO WHILE .T.
      // Edita os dados da compra enquanto n„o houver confirma‡„o.
      Edita()
      IF Confirme()
         // Finaliza se a edi‡„o for confirmada.
         EXIT
      ENDIF
   ENDDO
   SELECT Com
   // Atualiza a compra, gravando as vari veis auxiares no registro do arquivo.
   Atualiza()
   // Edi‡„o dos itens da compra.
   DO WHILE .T.
      // Apresenta a linha de orienta‡„o ao usu rio.
      SETCOLOR(vcr)
      @ 23,01 SAY "    Sobe      Desce   [Ins]  Inclui/Altera   [Del]  Exclui   [Esc]  Finaliza "
      @ 23,02 SAY CHR(24)
      @ 23,12 SAY CHR(25)
      // Apresenta a setinha indicando o item selecionado.
      SETCOLOR(vcp)
      @ vli+li,1 SAY CHR(205)+CHR(16)
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
            fun‡„o Acha().*/
         vcod:=Acha(vcod,"Prod",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
         // Retorna se o c¢digo estiver em branco.
         IF EMPTY(vcod)
            @ vli+li,03 SAY SPACE(76)
            LOOP
         ENDIF
         // Verifica se houve mudan‡a de c¢digo do produto.
         IF vcod#mcod[li+vt] .AND. !EMPTY(mcod[li+vt])
            // Houve mudan‡a, mudap torna-se verdadeira.
            mudap=.T.
         ENDIF
         // Reapresenta o c¢digo na tela.
         @ vli+li,04 SAY vcod PICTURE "@R 9.99.999"
         /* Se houve mudan‡a de produto, verifica se o mesmo j  n„o foi
            inclu¡do na compra, num dos outros itens j  cadastrados.*/
         // Verifica que o produto j  est  cadastrado nos itens.
         n:=ASCAN(mcod,vcod)
         IF n#0 .AND. n#li+vt
            Mensagem("Desculpe, Produto j  Presente Nesta Opera‡„o !",6,1)
            IF !EMPTY(mcod[li+vt])
               @ vli+li,04 SAY mcod[li+vt] PICTURE "@R 9.99.999"
            ELSE
               @ vli+li,03 SAY SPACE(76)
            ENDIF
            // Retorna se j  estiver.
            LOOP
         ENDIF
         // Apresenta o nome do produto na tela.
         @ vli+li, 13 SAY LEFT(Prod->nome,40)
         // Solicita a quantidade.
         @ vli+li, 54 GET vqtd PICTURE "999,999.99" VALID(vqtd>0)
         Aviso(24,"Digite a Quantidade em "+TRIM(Prod->unid))
         Le()
         @ vli+li,54 SAY vqtd PICTURE "@E 999,999.99"
         // Solicita o pre‡o unit rio bruto.
         @ vli+li,65 GET vpre PICTURE "999,999,999.99"
         Aviso(24,"Digite o Pre‡o Unit rio Bruto")
         Le()
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         // Atualiza o arquivo dos Produtos.
         SELECT Prod
         SEEK vcod
         // Al¡quota do IPI por produto.
         vpipi:=Prod->pipi
         // Atualiza o produto.
         IF tipo=1
            IF mudap     // Houve mudan‡a de produto.
               // Atualiza o saldo do dep¢sito.
               Prod->saldod:=(Prod->saldod+vqtd)
               // Atualiza o produto anterior.
               SEEK mcod[li+vt]
               IF Prod->saldod<mqtd[li+vt]
                  Prod->saldod:=0
               ELSE
                  Prod->saldod:=(Prod->saldod-mqtd[li+vt])
               ENDIF
            ELSE
               // Atualiza o saldo do dep¢sito.
               Prod->saldod:=(Prod->saldod+vqtd-mqtd[li+vt])
            ENDIF
            SELECT Prod
            SEEK vcod
            Prod->datue:=vdata;Prod->custr:=vpre;Prod->datcu:=vdata
            Prod->cusus:=Dolar(vdata,vpre)  // Atualiza o custo em d¢lar.
         ELSEIF tipo=2
            IF mudap     // Houve mudan‡a de produto.
               // Atualiza o saldo da loja.
               Prod->saldo:=(Prod->saldo+vqtd)
               // Atualiza o produto anterior.
               SEEK mcod[li+vt]
               IF Prod->saldo<mqtd[li+vt]
                  Prod->saldo:=0
               ELSE
                  Prod->saldo:=(Prod->saldo-mqtd[li+vt])
               ENDIF
            ELSE
               // Atualiza o saldo da loja.
               Prod->saldo:=(Prod->saldo+vqtd-mqtd[li+vt])
            ENDIF
            SELECT Prod
            SEEK vcod
            Prod->datue:=vdata;Prod->custr:=vpre;Prod->datcu:=vdata
            Prod->cusus:=Dolar(vdata,vpre) // Atualiza o custo em d¢lar.
         ENDIF
         // Atualiza os itens da compra.
         SELECT Coi
         IF mudap     // Houve mudan‡a de produto.
            SEEK vnupd+mcod[li+vt]
            Coi->codpro:=vcod
         ELSE         // N„o houve mudan‡a de produto.
            SEEK vnupd+vcod
            IF !FOUND()
               // Se o item ainda n„o existir no compra, inclui um novo.
               ++vord  // Aumenta o n£mero de itens da compra.
               APPEND BLANK
               Coi->nupd:=vnupd;Coi->codpro:=vcod;Coi->item:=STRZERO(vord,2)
            ENDIF
         ENDIF
         // Atualiza os dados do item.
         Coi->quant:=vqtd;Coi->preco:=vpre*vqtd;Coi->preun:=vpre
         Coi->codfor:=vcodfor;Coi->data:=vdata;Coi->preul:=vpre*(1-vpipi/100)
         // Atualiza o valor da compra.
         vvalor:=vvalor-(mpre[li+vt]*mqtd[li+vt]-vpre*vqtd)
         valiq :=valiq-(lpre[li+vt]*mqtd[li+vt]-vpre*(1-vpipi/100)*vqtd)
         // Calculo o valor do ICMS e do IPI.
         vipi  :=vvalor-valiq
         vicms :=valiq*(vpicms/100)
         vipi  :=vvalor-valiq
         // Reapresenta o valor total da compra, o ICMS e o IPI.
         SETCOLOR(vcr)
         @  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
         @  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
         @  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o vetor dos itens da compra.
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
         SELECT Coi
         // Pesquisa o item no arquivo.
         SEEK vnupd+mcod[li+vt]
         IF FOUND()
            // Atualiza o arquivo dos Produtos.
            SELECT Prod
            SEEK mcod[li+vt]
            IF tipo=1
               // Atualiza do saldo do dep¢sito.
               IF saldod>=mqtd[li+vt]
                  Prod->saldod:=(Prod->saldod-mqtd[li+vt])
               ELSE
                  Prod->saldod:=0
               ENDIF
            ELSEIF tipo=2
               // Atualiza o saldo da loja.
               IF saldo>=mqtd[li+vt]
                  Prod->saldo:=(Prod->saldo-mqtd[li+vt])
               ELSE
                  Prod->saldo:=0
               ENDIF
            ENDIF
         ENDIF
         SELECT Coi
         // Deleta o item.
         DELETE
         // Diminui a quantidade de itens da compra.
         --vord
         // Atualiza o valor da compra.
         vvalor:=vvalor-(mpre[li+vt]*mqtd[li+vt])
         valiq:=valiq-(lpre[li+vt]*mqtd[li+vt])
         // Calcula o valor do ICMS e do IPI.
         vicms:=valiq*(vpicms/100)
         vipi :=vvalor-valiq
         // Reapresenta o valor total da compra, o ICMS e o IPI.
         SETCOLOR(vcr)
         @  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
         @  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
         @  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o n£mero dos itens da compra.
         REPLACE Coi->item WITH STR(VAL(item)-1,2) WHILE vnupd=Coi->nupd
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
            SELECT Com
            // Atualiza os dados da compra.
            Atualiza()
            // Atualiza os dados dos itens da compra.
            // Atualitem()
            EXIT
         ENDIF
      ENDIF
   ENDDO
   // Limpa a tela.
   @ 24,00 CLEAR
   FOR i=22 TO vli+1 STEP -1
       @ i,01 SAY SPACE(78)
   NEXT
   SELECT Com
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Tela()
// Apresenta os dados das compras na tela.
********************************************************************************
SETCOLOR(vcn)
@  3, 2 SAY "Pedido N§: "
@  3,20 SAY "Nota Fiscal: "
@  3,42 SAY "Data: "
@  3,58 SAY "Vencimento: "
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
@  3,13 SAY vnupd       PICTURE "99999"
@  3,33 SAY vnunf       PICTURE "9999999"
@  3,48 SAY vdata       PICTURE "99/99/99"
@  3,70 SAY vvenc       PICTURE "99/99/99"
@  5,24 SAY vcodfor     PICTURE "99999"
@  5,38 SAY vforne      PICTURE "@!"
@  7, 9 SAY vvalor      PICTURE "@E 99,999,999.99"
@  7,33 SAY vvalef      PICTURE "@E 99,999,999.99"
@  7,54 SAY vpicms      PICTURE "99.99"
@  7,66 SAY vicms       PICTURE "@E 9,999,999.99"
@  8,66 SAY vipi        PICTURE "@E 9,999,999.99"
@  9,08 SAY vopera      PICTURE "@R 9.99.999"
@  9,28 SAY vdesc       PICTURE "@!"
SETCOLOR(vcn)
@ 10, 01  SAY "ÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit. ÍÍ"
/* M scara de edi‡„o dos itens da compra.
ÍÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit.Í"
Í> 9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999,999.99
*/
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados da compra na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,13 SAY vnupd       PICTURE "99999"
SETCOLOR(vcn)
@  3,33 GET vnunf       PICTURE "9999999"
Le()
vnunf:=Zeracod(vnunf)
@  3,33 SAY vnunf       PICTURE "9999999"
@  3,48 GET vdata       PICTURE "99/99/99" VALID !EMPTY(vdata)
@  3,70 GET vvenc       PICTURE "99/99/99"
@  5,24 GET vcodfor     PICTURE "99999"
Le()
// Apresenta uma tabela de consulta para o fornecedor.
vcodfor:=Acha(vcodfor,"Forne",1,2,"codi","nome","99999","@!",15,05,22,76)
SETCOLOR(vcr)
@  3,33 SAY vnunf       PICTURE "9999999"
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
// Apresenta os itens das compras na tela.
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
SELECT Com
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados do arquivo para as vari veis auxiliares.
********************************************************************************
vnunf  :=FIELD->nunf
vdata  :=FIELD->data
vvenc  :=FIELD->venc
vcodfor:=FIELD->codfor
vforne :=FIELD->forne
vvalor :=FIELD->valor
vvalef :=FIELD->valef
vpicms :=FIELD->picms
vicms  :=FIELD->icms
vopera :=FIELD->opera
vdesc  :=FIELD->desc
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados do arquivo com as vari veis auxiliares.
********************************************************************************
Com->nunf  :=vnunf
Com->data  :=vdata
Com->venc  :=vvenc
Com->codfor:=vcodfor
Com->forne :=vforne
Com->valor :=vvalor
Com->valef :=vvalef
Com->picms :=vpicms
Com->icms  :=vicms
Com->opera :=vopera
Com->desc  :=vdesc
RETURN
********************************************************************************
STATIC PROCEDURE Atualitem()
// Atualiza os dados dos itens com as vari veis auxiliares.
********************************************************************************
SELECT Coi
SEEK vnupd
IF FOUND()
   DO WHILE vnupd=nupd .AND. !EOF()
      Coi->item:=STRZERO(++i,2) // Numero sequencial do item.
      Coi->data:=vdata          // Data da compra.
      Coi->codfor:=vcodfor      // Codigo do fornecedor.
      SKIP
   ENDDO
ENDIF
SELECT Com
RETURN
********************************************************************************
PROCEDURE Conscom(tipo)
// Consulta das compras na Tela
********************************************************************************
// Abertura dos arquivos de dados
IF FILE("SAOPRO.DBF")
   // Produtos
   SELECT 1
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1,SAOPRO2
ELSE
   Mensagem("Arquivo dos Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 2
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM1,SAOCOM2,SAOCOM3
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOI.DBF")
   // Itens das compras
   SELECT 3
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI1,SAOCOI2
ELSE
   Mensagem("Arquivo dos Itens das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Com
IF tipo=1
   SET FILTER TO Com->ctipo="1"
ELSEIF tipo=2
   SET FILTER TO Com->ctipo="2"
ENDIF
GO TOP
// Inicializa as vari veis auxiliares.
vli:=10
vnupd  :=SPACE(5)
vnunf  :=SPACE(7)
vdata  :=vvenc:=CTOD(SPACE(8))
vcodfor:=SPACE(5)
vforne :=SPACE(40)
vvalor :=vvalef:=vpicms:=vicms:=vipi:=0
vopera :=SPACE(6)
vdesc  :=SPACE(50)
// Constru‡„o da Tela de Apresenta‡„o.
Sinal("COMPRAS","CONSULTAS")
Abrejan(2)
// Declara os vetores de consulta.
PRIVATE vdado[9],vmask[9],vcabe[9]
// Dados a serem apresentados.
vdado[01]:="nupd"
vdado[02]:="nunf"
vdado[03]:="opera"
vdado[04]:="data"
vdado[05]:="venc"
vdado[06]:="forne"
vdado[07]:="valor"
vdado[08]:="valef"
vdado[09]:="icms"
// Cabe‡alhos das colunas.
vcabe[01]:="Pedido"
vcabe[02]:="Nota"
vcabe[03]:="Opera‡„o"
vcabe[04]:="Data"
vcabe[05]:="Vencto."
vcabe[06]:="Fornecedor"
vcabe[07]:="Valor"
vcabe[08]:="Encargos"
vcabe[09]:="ICMS"
// M scaras de apresenta‡„o.
vmask[01]:="99999"
vmask[02]:="9999999"
vmask[03]:="@R 9.99.999"
vmask[06]:="@!"
vmask[07]:="@E 999,999,999.99"
vmask[08]:="@E 999,999,999.99"
vmask[09]:="@E 99,999,999.99"
// Linha de orienta‡„o ao usu rio.
SETCOLOR(vcr)
@ 23,02 SAY PADC("F1 Help  F5 N£mero  F6 Fornecedor  F9 Data  [PgUp] [PgDn]  [Enter]  [Esc]",76)
SETCOLOR(vcn)
// Executa a fun‡„o DBEDIT().
DBEDIT(03,01,22,78,vdado,"Fxco",vmask,vcabe,"Ä","³")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fxco(modo)
// Fun‡ao para Consulta aos compras atrav‚s da DBEDIT()
********************************************************************************
IF modo=4
   IF LASTKEY()=K_ENTER
      // Foi pressionada a tecla <Enter>: apresenta‡„o dos itens da compra.
      vtela:=SAVESCREEN(01,00,24,79) // Salva a tela de consulta.
      SETCOLOR(vcn)
      Abrejan(2)  // Abre a janela de dados.
      vnupd:=nupd
      Transfere() // Transfere os dados do arquivo para as vari veis auxiliares.
      Tela()      // Apresenta a tela da compra.
      SELECT Coi
      SEEK vnupd  // Pesquisa os itens da compra.
      IF !FOUND()
         // Itens n„o encontrados.
         SETCOLOR(vca)
         Aviso(13,"Esta Compra N„o possui Itens !")
         SETCOLOR(vcn)
         INKEY(5)  // Aguarda 5 segundos.
      ELSE
         // Apresenta os itens da compra.
         DO WHILE .T.
            i:=11
            DO WHILE i<23 .AND. nupd=vnupd .AND. !EOF()
               @ i  ,  4  SAY  Coi->codpro PICTURE "@R 9.99.999"
               SELECT Prod
               SEEK Coi->codpro
               SELECT Coi
               @ i  , 13  SAY  LEFT(Prod->nome,40)
               @ i  , 54  SAY  Coi->quant PICTURE "@E 999,999.99"
               @ i  , 65  SAY  Coi->preun PICTURE "@E 999,999,999.99"
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
                  IF Coi->nupd#vnupd .OR. BOF()
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
                  SELECT Com
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
      SELECT Com
      SETCOLOR(vcn)
      RETURN(1)
   ELSEIF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      // Pressionada a tecla <F5>: pesquisa pelo n£mero da compra.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 1
      // Solicita o n£mero da compra desejado.
      vcd:=SPACE(5)
      @ 24,27 SAY "Compra Desejada: " GET vcd PICTURE "99999"
      Le()
      // Retorna se o n£mero da compra estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      vcd:=Zeracod(vcd)
      // Pesquisa o n£mero da compra solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vcd)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Compra N„o Encontrada !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando o compra solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      // Pressionada a tecla <F6>: pesquisa pelo nome do fornecedor.
      @ 24,00 CLEAR
      // Define a ordem de pesquisa.
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
      // Pressionada a tecla <F9>: pesquisa pela data da compra.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 3
      // Solicita a data da compra desejada.
      vcd:=CTOD(SPACE(8))
      @ 24,27 SAY "Data Desejada: " GET vcd
      Le()
      // Retorna se a data da compra estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa a data da compra solicitada.
      SET SOFTSEEK ON
      SEEK vcd
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrada.
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrada !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando a compra solicitada.
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
      @ 17,12 SAY "[Enter] - Mostra os Itens da Compra"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[F5]    - Pesquisa pelo N£mero da Compra"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Fornecedor"
      @ 21,12 SAY "[F9]    - Pesquisa pela Data da Compra"
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
PROCEDURE Relcom1(tipo)
/*
Objetivo : emite os relat¢rios das compras.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("COMPRAS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 1
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM3
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Com
IF tipo=1
   vtit:="Compras para o Deposito"
   SET FILTER TO Com->ctipo="1"
ELSEIF tipo=2
   vtit:="Compras para a Loja"
   SET FILTER TO Com->ctipo="2"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas compras devem ser impressas.
Pesqdat()
// Pesquisa a faixa de notas fiscais a serem impressas.
Pesqint(5,"99999","Pedidos")
IF !Imprime("Relat¢rio Sint‚tico das Compras")
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
DO WHILE !EOF() .AND. Com->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Sintetico das "+vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,03 SAY "Nro.     DATA                  FORNECEDOR                     VALOR TOTAL"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Com->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Com->data>=vdati .AND. Com->data<=vdatf .AND. Com->nupd>=vcodi .AND. Com->nupd<=vcodf
         @ PROW()+1,02 SAY Com->nupd
         @ PROW(),  09 SAY Com->data
         @ PROW(),  19 SAY Com->forne
         @ PROW(),  61 SAY Com->valor+Com->valef PICTURE "@E 999,999,999.99"
         vtot+=(Com->valor+Com->valef)
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
 99999  99/99/99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99 
*/
********************************************************************************
PROCEDURE Relcom2(tipo)
/*
Objetivo : emite o relat¢rio anal¡tico das compras.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("COMPRAS","RELATORIO")
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
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 2
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM3
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOI.DBF")
   // Itens das Compras
   SELECT 3
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI1
ELSE
   Mensagem("Arquivo dos Itens das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
SELECT Com
IF tipo=1
   vtit:="Compras para o Deposito"
   SET FILTER TO Com->ctipo="1"
ELSEIF tipo=2
   vtit:="Compras para a Loja"
   SET FILTER TO Com->ctipo="2"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujos pedidos devem ser impressos.
Pesqdat()
// Pesquisa o intervalo de Pedidos a serem impressas.
Pesqint(5,"99999","Pedidos")
IF !Imprime("Relat¢rio Anal¡tico das Compras")
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
DO WHILE !EOF() .AND. Com->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Analitico das "+vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Com->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF Com->data<vdati .OR. Com->data>vdatf .OR. Com->nupd<vcodi .OR. Com->nupd>vcodf
         SKIP
         LOOP
      ENDIF
      // Impress„o dos dados.
      @ PROW()+2, 2 SAY "Pedido No: "+Com->nupd
      @ PROW(),  20 SAY "Nota Fiscal: "+Com->nunf
      @ PROW(),  42 SAY "Data: "+DTOC(Com->data)
      @ PROW(),  58 SAY "Vencimento: "+DTOC(Com->venc)
      @ PROW()+1, 2 SAY "Fornecedor: "+Com->codfor+" - "+Com->forne
      @ PROW()+1, 2 SAY "Valor:"+TRANSFORM(Com->valor,"@E 999,999,999.99")
      @ PROW(),  23 SAY "Encargos:"+TRANSFORM(Com->valef,"@E 999,999,999.99")
      @ PROW(),  47 SAY "%ICMS: "+TRANSFORM(Com->picms,"@E 99.99")
      @ PROW(),  60 SAY "ICMS:"+TRANSFORM(Com->icms,"@E 999,999,999.99")
      @ PROW()+1, 2 SAY "Oper: "+TRANSFORM(Com->opera,"@R 9.99.999")
      @ PROW(),  17 SAY "Descricao: "+Com->desc
      SELECT Coi
      IF pv
         SEEK Com->nupd
         pv=.F.
      ENDIF
      IF Coi->nupd=Coi->nupd
         @ PROW()+1,01 SAY "-Codigo-------Nome dos Produtos---------Quantidade-Custo Unitario---Custo Total-"
         DO WHILE Com->nupd=Coi->nupd .AND. PROW()<=60 .AND. !EOF() 
            @ PROW()+1,01 SAY Coi->codpro PICTURE "@R 9.99.999"
            @ PROW(),  10 SAY LEFT(Prod->nome,32)
            @ PROW(),  43 SAY TRANSFORM(Coi->quant,"@E 9,999.99")
            @ PROW(),  52 SAY TRANSFORM(Coi->preun,"@E 999,999,999.99")
            @ PROW(),  67 SAY TRANSFORM(Coi->preun*Coi->quant,"@E 999,999,999.99")
            SKIP
         ENDDO
      ENDIF
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SELECT Com
      IF Coi->nupd#Com->nupd
         vtot+=(Com->valor+Com->valef+Com->icms)
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
PROCEDURE Relcompro(tipo)
/* Relatorio de Compras por Produto
   Parametros: tipo 1 - Analitico
                    2 - Resumido*/
********************************************************************************
LOCAL vtot[6]
// Atualiza a linha de status no topo da tela.
Sinal("COMPRAS","RELATORIO")
// Abertura dos arquivos de dados.
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
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 2
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
IF FILE("SAOCOI.DBF")
   // Itens das Compras
   SELECT 3
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI2
ELSE
   Mensagem("Arquivo dos Itens das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Coi
SET ORDER TO 2
Pesqint(6,"@R 9.99.999","C¢digos dos Produtos")
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas compras devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio de Compras por Produto")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0   // Vari vel pg: armazena o numero das paginas.
SET DEVICE TO PRINT
pv:=.T.
AFILL(vtot,0.00) // Totalizadores.
SET RELATION TO nupd INTO Com
DO WHILE Coi->codpro<=vcodf .AND. !EOF()
   SELECT Coi
   vcodpro:=Coi->codpro
   IF tipo=1
      Cabe(emp[2],vsist,"Relatorio Analitico de Compras por Produto","Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
      @ PROW()+1,01 SAY "Pedido  Data      Fornecedor          Nota   Compra  Quantidade   Preco Unit."
   ELSE
      Cabe(emp[2],vsist,"Relatorio Sintetico de Compras por Produto","Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
      @ PROW()+1,01 SAY "Codigo                  P r o d u t o                Quantidade   Preco Total"
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",80)
   vgrupo:=LEFT(Coi->codpro,3)
   DO WHILE vgrupo=LEFT(Coi->codpro,3) .AND. Coi->codpro<=vcodf .AND. !EOF() .AND. PROW()<=60
      vcodpro:=Coi->codpro
      SELECT Prod
      SEEK vcodpro
      IF tipo=1
         @ PROW()+1,05 SAY vcia20+vcia05+TRANSFORM(vcodpro,"@R 9.99.999")+" - "+TRIM(nome)+vcid05+vcia10
         @ PROW()+1,00 SAY REPLICATE("-",80)
      ENDIF
      SELECT Coi
      DO WHILE PROW()<=60 .AND. codpro=vcodpro .AND. !EOF()
         IF Escprint(80)
            CLOSE DATABASE
            RETURN
         ENDIF
         IF Coi->data>=vdati .AND. Coi->data<=vdatf
            IF tipo=1
               @  PROW()+1,1  SAY Coi->nupd
               @  PROW(), 07  SAY Com->data
               @  PROW(), 16  SAY LEFT(Com->forne,20)
               @  PROW(), 37  SAY LEFT(Com->nunf,7)
               IF Com->ctipo="1"
                  @  PROW(), 45  SAY "Deposito"
               ELSE
                  @  PROW(), 45  SAY "Loja"
               ENDIF
               @  PROW(), 54  SAY Coi->quant PICTURE "@E 999,999.99"
               @  PROW(), 65  SAY Coi->preun PICTURE "@E 999,999,999.99"
            ENDIF
            // Totalizadores por produto.
            vtot[1]+=Coi->quant
            vtot[2]+=Coi->quant*Coi->preun
            // Totalizadores por grupo.
            vtot[3]+=Coi->quant
            vtot[4]+=Coi->quant*Coi->preun
            // Totalizadores gerais.
            vtot[5]+=Coi->quant
            vtot[6]+=(Coi->quant*Coi->preun)
         ENDIF
         SKIP
      ENDDO
      IF vcodpro#Coi->codpro
         IF tipo=1
            @ PROW()+1,02 SAY "T o t a i s   d o   P r o d u t o ->"
            @ PROW(), 54  SAY vtot[1] PICTURE "@E 999,999.99"
            @ PROW(), 65  SAY vtot[2] PICTURE "@E 999,999,999.99"
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ELSE
            @ PROW()+1,01 SAY TRANSFORM(vcodpro,"@R 9.99.999")+" - "+LEFT(Prod->nome,40)
            @ PROW(),  54  SAY vtot[1] PICTURE "@E 999,999.99"
            @ PROW(),  65  SAY vtot[2] PICTURE "@E 999,999,999.99"
         ENDIF
         vcodpro:=Coi->codpro
         vtot[1]:=vtot[2]:=0
      ENDIF
   ENDDO
   IF vgrupo#LEFT(Coi->codpro,3)
      IF tipo=2
         @ PROW()+1,0 SAY REPLICATE("-",80)
      ENDIF
      @ PROW()+1,02 SAY "T o t a i s   d o   G r u p o  "+TRANSFORM(vgrupo,"@R 9.99")+"  ->"
      @ PROW(), 54  SAY vtot[3] PICTURE "@E 999,999.99"
      @ PROW(), 65  SAY vtot[4] PICTURE "@E 999,999,999.99"
      @ PROW()+1,0 SAY REPLICATE("-",80)
      vgrupo:=LEFT(Coi->codpro,3)
      vtot[3]:=vtot[4]:=0
   ENDIF
ENDDO
@ PROW()+1,00 SAY REPLICATE("=",80)
@ PROW()+1,02 SAY "T O T A L    G E R A L   ->"
@ PROW(), 65  SAY vtot[6] PICTURE "@E 999,999,999.99"
@ PROW()+1,0 SAY REPLICATE("=",80)
EJECT
CLOSE DATABASE
SET DEVICE TO SCREEN
RETURN
/*
Pedido  Data      Fornecedor          Nota   Compra  Quantidade   Preco Unit.
99999 99/99/99 xxxxxxxxxxxxxxxxxxxx 9999999 Deposito 999,999.99 999,999,999.99
Codigo                  P r o d u t o                Quantidade   Preco Total
9.99.999 - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999,999.99
*/
********************************************************************************
PROCEDURE Relcomfor()
// Relatorio de Compras por Fornecedor.
********************************************************************************
// Declaracao das variaveis locais.
LOCAL vtot[6],vpula:=.F.,muda:=.T.,vforne
// Atualiza a linha de status no topo da tela
Sinal("COMPRAS","RELATORIO")
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 1
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM2
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Com
SET ORDER TO 2
vcodi:=vcodf:=SPACE(20)
Pesqint(20,"@!","Fornecedores")
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas compras devem ser impressas.
Pesqdat()
Aviso(18,"Ejetar p gina ap¢s cada Fornecedor ?")
IF Confirme()
   vpula:=.T.
ENDIF
IF !Imprime("Relat¢rio Completo de Compras por Fornecedor")
   CLOSE DATABASE
   RETURN
ENDIF
SET DEVICE TO PRINT
SET SOFTSEEK ON
SEEK vcodi
SET SOFTSEEK OFF
pg:=0
AFILL(vtot,0.00)
DO WHILE Com->forne<=vcodf .AND. !EOF()
   Cabe(emp[2],vsist,"Relatorio Completo de Compras de "+DTOC(vdati)+" a "+DTOC(vdatf),"Relatorio por Fornecedor",80,vcia10)
   @ PROW()+1,01 SAY "Pedido  Data    Nota    Compra         Valor           ICMS         Encargos"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   DO WHILE PROW()<=60 .AND. !EOF() .AND. Com->forne<=vcodf
      @ PROW()+2,01 SAY vcia20+vcia05+Com->codfor+" - "+TRIM(Com->forne)+vcid05+vcia10
      @ PROW()+1,00 SAY ""
      vforne:=Com->forne
      DO WHILE PROW()<=60 .AND. Com->forne=vforne .AND. !EOF()
         IF Escprint()
            CLOSE DATABASE
            RETURN
         ENDIF
         IF Com->data>=vdati .AND. Com->data<=vdatf
            @  PROW()+1,1  SAY Com->nupd
            @  PROW(), 08  SAY Com->data
            @  PROW(), 17  SAY Com->nunf
            IF Com->ctipo="1"
               @  PROW(), 25  SAY "Deposito"
            ELSE
               @  PROW(), 25  SAY "Loja"
            ENDIF
            @  PROW(), 35  SAY Com->valor PICTURE "@E 999,999,999.99"
            @  PROW(), 51  SAY Com->icms  PICTURE "@E 999,999,999.99"
            @  PROW(), 67  SAY Com->valef PICTURE "@E 99,999,999.99"
            // Totais por fornecedor.
            vtot[1]+=Com->valor
            vtot[2]+=Com->icms
            vtot[3]+=Com->valef
            // Totais gerais.
            vtot[4]+=Com->valor
            vtot[5]+=Com->icms
            vtot[6]+=Com->valef
         ENDIF
         SKIP
      ENDDO
      IF Com->forne#vforne
         IF vtot[1]#0.00
            @ PROW()+1,10 SAY "T o t a i s   ->"
            @  PROW(), 35  SAY vtot[1] PICTURE "@E 999,999,999.99"
            @  PROW(), 51  SAY vtot[2] PICTURE "@E 999,999,999.99"
            @  PROW(), 67  SAY vtot[3] PICTURE "@E 99,999,999.99"
         ENDIF
         @ PROW()+1,0 SAY REPLICATE("-",80)
         vtot[1]:=vtot[2]:=vtot[3]:=0.00
         SELECT Com
         SKIP
         vforne:=Com->forne
         IF vpula
            EXIT
         ENDIF
      ENDIF
      SELECT Com
   ENDDO
ENDDO
@ PROW()+1,00 SAY REPLICATE("=",80)
@ PROW()+1,02 SAY "T o t a l    G e r a l   ->"
@ PROW(), 35  SAY vtot[4] PICTURE "@E 999,999,999.99"
@ PROW(), 51  SAY vtot[5] PICTURE "@E 999,999,999.99"
@ PROW(), 67  SAY vtot[6] PICTURE "@E 99,999,999.99"
@ PROW()+1,0 SAY REPLICATE("=",80)
EJECT
CLOSE DATABASE
SET DEVICE TO SCREEN
RETURN
/*
Pedido   Data    Nota    Compra         Valor           ICMS         Encargos
99999  99/99/99 9999999 Deposito  999,999,999.99  999,999,999.99  999,999,999.99
*/
********************************************************************************
PROCEDURE Relcomres()
// Relatorio Resumo de Compras.
********************************************************************************
// Atualiza a linha de status no topo da tela
LOCAL vres[3],vtot[3],ncom:=0,nite:=0,tcom:=0,tite:=0
Sinal("COMPRAS","RELATORIO")
IF FILE("SAOCOM.DBF")
   // Compras
   SELECT 1
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM2
ELSE
   Mensagem("Arquivo de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOCOI.DBF")
   // Itens de Compras.
   SELECT 2
   USE SAOCOI ALIAS Coi
   IF !FILE("SAOCOI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOI1
ELSE
   Mensagem("Arquivo dos Itens de Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Com
SET ORDER TO 2
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Resumo de Compras")
   CLOSE DATABASE
   RETURN
ENDIF
AFILL(vtot,0)           // Totalizador Geral
AFILL(vres,0)           // Totalizador por tipo de pagto.
pg:=0                   // Contador de p ginas.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF()
   Cabe(emp[2],vsist,"Relatorio Resumo de Compras de "+DTOC(vdati)+" a "+DTOC(vdatf),"Relatorio por Tipo de Pagamento",80,vcia10)
   @ PROW()+1,01 SAY "No. de Compras     Valor Total       Acrescimos        ICMS       Itens/Compra"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   DO WHILE PROW()<=60 .AND. !EOF()
      vforne:=Com->forne
      DO WHILE Com->forne=vforne .AND. !EOF()
         IF Com->data>=vdati .AND. Com->data<=vdatf
            ++ncom                // N£mero de compras
            vres[01]+=Com->valor  // Valor total
            vres[02]+=Com->valef  // Acr‚scimos
            vres[03]+=Com->icms   // ICMS
            SELECT Coi
            SEEK Com->nupd
            DO WHILE Coi->nupd=Com->nupd .AND. !EOF()
               ++nite  // N£mero de Itens por compra.
               SKIP
            ENDDO
            SELECT Com
         ENDIF
         SKIP
      ENDDO
      @ PROW()+2,02 SAY vforne
      @ PROW()  ,02 SAY vforne
      @ PROW()+1,05 SAY ncom     PICTURE "@E 999"
      @ PROW(),  18 SAY vres[01] PICTURE "@E 999,999,999.99"
      @ PROW(),  36 SAY vres[02] PICTURE "@E 99,999,999.99"
      @ PROW(),  52 SAY vres[03] PICTURE "@E 99,999,999.99"
      @ PROW(),  71 SAY ROUND(nite/ncom,0) PICTURE "@E 999"
      tcom+=ncom
      tite+=nite
      FOR i=1 TO 3
         vtot[i]+=vres[i]
      NEXT
      ncom:=nite:=0
      AFILL(vres,0)
   ENDDO
ENDDO
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+1,05 SAY tcom     PICTURE "@E 999"
@ PROW(),  18 SAY vtot[01] PICTURE "@E 999,999,999.99"
@ PROW(),  36 SAY vtot[02] PICTURE "@E 99,999,999.99"
@ PROW(),  52 SAY vtot[03] PICTURE "@E 99,999,999.99"
@ PROW(),  71 SAY ROUND(tite/tcom,0) PICTURE "@E 999"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY vcia10+PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
CLOSE DATABASE
SET DEVICE TO SCREEN
ERASE TEMP.NTX
RETURN
/*
No. de Compras     Valor Total       Acrescimos        ICMS       Itens/Compra
    999          999,999,999.99    99,999,999.99   99,999,999.99      999
*/
********************************************************************************
PROCEDURE Relcicms()
/*
Objetivo : emite os relat¢rios do ICMS sobre compras.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("ICMS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOCOM.DBF")
   // Compras.
   SELECT 1
   USE SAOCOM ALIAS Com
   IF !FILE("SAOCOM3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCOM3
ELSE
   Mensagem("Arquivo das Compras N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Com
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas compras devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio do ICMS sobre Compras")
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
DO WHILE !EOF() .AND. Com->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio do ICMS sobre Compras","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,03 SAY "Nro.     DATA                  FORNECEDOR                     VALOR ICMS"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Com->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Com->data>=vdati .AND. Com->data<=vdatf
         @ PROW()+1,02 SAY Com->nupd
         @ PROW(),  09 SAY Com->data
         @ PROW(),  19 SAY Com->forne
         @ PROW(),  61 SAY Com->icms PICTURE "@E 999,999,999.99"
         vtot+=Com->icms
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  61 SAY vtot PICTURE "@E 999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
  Nro.     Data                  Fornecedor                     Valor Total         
 99999  99/99/99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99  
*/
********************************************************************************
//                        Fim do Programa SAOCOM.PRG
********************************************************************************
