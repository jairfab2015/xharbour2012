********************************************************************************
/* Programa.: SAONF.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento das Notas Fiscais.         */
********************************************************************************
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matnf(modo)
/* Manuten‡„o das Notas   - 1- Inclus„o
                            2- Altera‡„o
                            3- Exclus„o
*/
********************************************************************************
// Declara os vetores privados que ser„o utilizados para editar os itens.
PRIVATE mcod[66],mqtd[66],mpre[66],vcod,vqtd,vpre,n
/* mcod[]/vcod: c¢digo dos produtos.
   mqtd[]/vqtd: quantidade vendida.
   mpre[]/vpre: pre‡o unit rio.
   n: verifica produto j  cadastrado.*/
// Declara as vari veis privadas de controle da edi‡„o na tela.
PRIVATE vli,li,lf,vt,vord,vok,mudap
/* vli:  linha inicial para edi‡„o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens da nota
   vok:  existˆncia da nota
   mudap:mudan‡a de produto de um item.*/
// Inicializa a linha inicial para edi‡„o dos itens.
vli:=12
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
IF FILE("SAOCLI.DBF")
   // Clientes
   SELECT 2
   USE SAOCLI ALIAS Cli
   IF !FILE("SAOCLI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOCLI1,SAOCLI2
ELSE
   Mensagem("Arquivo dos Clientes N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 3
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN1,SAOVEN2
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEI.DBF")
   // Itens das vendas
   SELECT 4
   USE SAOVEI ALIAS Vei
   IF !FILE("SAOVEI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEI1
ELSE
   Mensagem("Arquivo dos Itens de Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOREP.DBF")
   SELECT 5
   USE SAOREP ALIAS Rep
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1,SAOREP2
ELSE
   Mensagem("Arquivo dos Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAONF.DBF")
   // Notas Fiscais
   SELECT 6
   USE SAONF ALIAS Nf
   IF !FILE("SAONF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONF1,SAONF2,SAONF3
ELSE
   Mensagem("Arquivo de Notas Fiscais N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAONFI.DBF")
   // Itens das Notas Fiscais
   SELECT 7
   USE SAONFI ALIAS Nfi
   IF !FILE("SAONFI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONFI1
ELSE
   Mensagem("Arquivo dos Itens das Notas Fiscais N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPG.DBF")
   SELECT 8
   USE SAOTPG ALIAS Tpg
   IF !FILE("SAOTPG1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTPG1,SAOTPG2
ELSE
   Mensagem("Arquivo dos Tipos de Pagamento N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 9
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
   Sinal("NOTAS","INCLUSŽO")
ELSEIF modo=2
   Sinal("NOTAS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("NOTAS","EXCLUSŽO")
ENDIF
// Abre a janela de dados.
Abrejan(2)
SELECT Ven
DO WHILE .T.
   // Inicializa as vari veis auxiliares para edi‡„o dos dados.
   vnupd  :=SPACE(5)
   vnunf  :=SPACE(7)
   vdata  :=CTOD(SPACE(8))
   vcodcli:=SPACE(5)
   vcli   :=SPACE(40)
   vpdcli :=SPACE(15)
   vopera :=SPACE(6)
   vtipg  :=SPACE(3)
   vcodrep:=SPACE(3)
   vrep   :=SPACE(35)
   vvalor :=vvcomi:=vvencf:=vvdesc:=vicms:=0
   vpicms :=18.00
   vok    :=.F.
   // Apresenta os dados das vendas na tela.
   Tela()
   DO WHILE .T.
      vnupd  :=SPACE(5)
      vnunf  :=SPACE(7)
      IF modo=1
         // Solicita o n£mero da venda a ser editado.
         SETCOLOR(vcr)
         @  3,13 SAY vnunf  PICTURE "9999999"
         SETCOLOR(vcn)
         @  3,33 GET vnupd  PICTURE "99999"
         Aviso(24,"Digite o N§ da Venda, Tecle [Enter] para Nota Fiscal ou [Esc] para Finalizar")
         Le()
         /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da venda
            estiver em branco.*/
         IF LASTKEY()=K_ESC
            CLOSE DATABASE
            RETURN
         ENDIF
         vnupd:=Zeracod(vnupd)
         // Pesquisa a venda no arquivo.
         SELECT Ven
         SEEK vnupd
         IF !FOUND()
            SETCOLOR(vca)
            @ 24,04 SAY "Venda N„o Encontrada; Deseja Cadastrar a Nota Fiscal ?"
            SETCOLOR(vcn)
            IF !Confirme()
               LOOP
            ELSE
               // Solicita o n£mero da Nota a ser editado.
               @  3,13 GET vnunf  PICTURE "9999999"
               Aviso(24,"Digite o N§ da Nota Fiscal ou tecle [Esc] para Finalizar")
               Le()
               /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da Nota
                  estiver em branco.*/
               IF LASTKEY()=K_ESC .OR. EMPTY(vnunf)
                  CLOSE DATABASE
                  RETURN
               ENDIF
               vnunf:=Zeracod(vnunf)
               // Pesquisa a Nota no arquivo.
               SELECT Nf
               SEEK vnunf
               IF FOUND()
                  Mensagem("Desculpe, Nota Fiscal j  Cadastrada !",5,1)
                  LOOP
               ENDIF
               SELECT Nf
               APPEND BLANK
               Nf->nunf:=vnunf
            ENDIF
         ELSE
            vok:=.T.
         ENDIF
      ELSE
         // Solicita o n£mero da Nota a ser editado.
         @  3,13 GET vnunf  PICTURE "9999999"
         Aviso(24,"Digite o N§ da Nota Fiscal ou tecle [Esc] para Finalizar")
         Le()
         /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da Nota
            estiver em branco.*/
         IF LASTKEY()=K_ESC .OR. EMPTY(vnunf)
            CLOSE DATABASE
            RETURN
         ENDIF
         vnunf:=Zeracod(vnunf)
         // Pesquisa a Nota no arquivo.
         SELECT Nf
         SEEK vnunf
         IF !FOUND()
            Mensagem("Desculpe, Nota Fiscal N„o Encontrada!",5,1)
            LOOP
         ELSE
            vok:=.T.
         ENDIF
      ENDIF
      EXIT
   ENDDO
   // Inicializa os vetores dos itens das notas.
   AFILL(mcod,SPACE(6));AFILL(mqtd,0);AFILL(mpre,0)
   // Inicializa as vari veis de controle da tela.
   li:=lf:=1;vt:=0;vord:=1;k:=1
   IF vok
      /* Se a nota tiver sido encontrado, transfere os dados dos arquivos para
         as vari veis auxiliares de edi‡„o.*/
      @ 24,00 CLEAR
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      // Transfere os dados das notas para as vari veis auxiliares.
      Transfere()
      SELECT Cli
      SEEK vcodcli
      vcli:=Cli->nome
      SELECT Rep
      SEEK vcodrep
      vrep:=LEFT(Rep->nome,35)
      // Transferˆncia dos dados dos itens das notas para os vetores.
      IF modo=1
         SELECT Vei
         SEEK vnupd
         IF FOUND()
            vvalor:=0
            DO WHILE vnupd=nupd .AND. !EOF()
               mcod[k]:=Vei->codpro // c¢digo dos produtos.
               mqtd[k]:=Vei->quant  // quantidade solicitada.
               mpre[k]:=Vei->preun  // pre‡o unitario de venda.
               // Calcula o valor total da venda.
               vvalor+=(mpre[k]*mqtd[k])
               SKIP
               ++k
            ENDDO
            // Define o n£mero total de itens da nota.
            vord:=k-1
         ENDIF
      ELSE
         SELECT Nfi
         SEEK vnunf
         IF FOUND()
            vvalor:=0
            DO WHILE vnunf=nunf .AND. !EOF()
               mcod[k]:=Nfi->codpro // c¢digo dos produtos.
               mqtd[k]:=Nfi->quant  // quantidade solicitada.
               mpre[k]:=Nfi->preun  // pre‡o unitario de nota.
               // Calcula o valor total da nota.
               vvalor+=(mpre[k]*mqtd[k])
               SKIP
               ++k
            ENDDO
            // Define o n£mero total de itens da nota.
            vord:=k-1
         ENDIF
      ENDIF
      // Define a £ltima linha de edi‡„o dos itens da nota (lf).
      IF vord>=(22-vli)
         lf:=(22-vli)
      ELSE
         lf:=k
      ENDIF
      @ 24,00 CLEAR
      // Calcula o valor do ICMS e da Comiss„o.
      vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
      vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
   ENDIF
   // Apresenta os dados da nota na tela.
   Tela()
   // Apresenta os dados dos itens da nota na tela.
   Mostra(1,vord,vcn)
   // Inclui uma nova nota se for inclus„o e o mesmo ainda n„o existir.
   SELECT Nf
   IF modo=1 .AND. vok
      // Solicita o n£mero da Nota a ser editado.
      DO WHILE .T.
         vnunf:=SPACE(7)
         @  3,13 GET vnunf  PICTURE "9999999"
         Aviso(24,"Digite o N§ da Nota Fiscal ou tecle [Esc] para Finalizar")
         Le()
         /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da Nota
            estiver em branco.*/
         IF LASTKEY()=K_ESC .OR. EMPTY(vnunf)
            CLOSE DATABASE
            RETURN
         ENDIF
         vnunf:=Zeracod(vnunf)
         // Pesquisa a Nota no arquivo.
         SELECT Nf
         SEEK vnunf
         IF FOUND()
            Mensagem("Desculpe, Nota Fiscal J  Cadastrada!",5,1)
            LOOP
         ENDIF
         APPEND BLANK
         Nf->nunf:=vnunf;Nf->nupd:=vnupd
         Atualiza()
         vvalor:=0
         SELECT Nfi
         FOR i=1 TO vord
            APPEND BLANK
            Nfi->nunf:=vnunf
            Nfi->codpro:=mcod[i] // c¢digo dos produtos.
            Nfi->quant:=mqtd[i]  // quantidade solicitada.
            Nfi->preun:=mpre[i]  // pre‡o unitario de nota.
            vvalor+=(mpre[i]*mqtd[i])
            SKIP
         NEXT
         SELECT Nf 
         EXIT
      ENDDO
   ENDIF
   // Se a opera‡„o for exclus„o de Notas.
   IF modo=3
      // Solicita confirma‡„o da exclus„o da nota apresentado.
      IF Exclui()
         // Deleta os itens da Nota.
         SELECT Nfi
         SEEK vnunf
         DELETE WHILE nunf=vnunf
         // Deleta a Nota.
         SELECT Nf
         DELETE
      ENDIF
      // Limpa a tela.
      @ 24,00 CLEAR
      FOR i=22 TO vli+1 STEP -1
          @ i,01 SAY SPACE(78)
      NEXT
      SELECT Nf
      // Retorna para realizar outra exclus„o.
      LOOP
   ENDIF
   // Se for inclus„o ou altera‡„o de Notas.
   DO WHILE .T.
      // Edita os dados da nota enquanto n„o houver confirma‡„o.
      Edita()
      IF Confirme()
         // Finaliza se a edi‡„o for confirmada.
         EXIT
      ENDIF
   ENDDO
   // Atualiza a nota, gravando as vari veis auxiares no registro do arquivo.
   Atualiza()
   // Edi‡„o dos itens da Nota.
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
         vpre:=mpre[li+vt] // pre‡o unit rio.
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
            inclu¡do na nota, num dos outros itens j  cadastrados.*/
         // Verifica que o produto j  est  cadastrado nos itens.
         n:=ASCAN(mcod,vcod)
         IF n#0 .AND. n#(li+vt)
            Mensagem("Desculpe, Produto j  Presente Nesta Nota !",6,1)
            IF !EMPTY(mcod[li+vt])
               @ vli+li,04 SAY mcod[li+vt] PICTURE "@R 9.99.999"
            ELSE
               @ vli+li,03 SAY SPACE(76)
            ENDIF
            // Retorna se j  estiver cadastrado na nota.
            LOOP
         ENDIF
         // Apresenta o nome e o pre‡o do produto na tela.
         @ vli+li, 13 SAY LEFT(Prod->nome,40)
         vpre:=IF(vpre#0,vpre,Prod->precr)
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         // Solicita a quantidade.
         @ vli+li, 54 GET vqtd PICTURE "999,999.99" VALID(vqtd>0)
         Aviso(24,"Digite a Quantidade em "+TRIM(Prod->unid))
         Le()
         @ vli+li,54 SAY vqtd PICTURE "@E 999,999.99"
         // Solicita o pre‡o unit rio.
         vpre:=IF(vpre#0,vpre,Prod->precr)
         @ vli+li,65 GET vpre PICTURE "@E 999,999,999.99"
         Aviso(24,"Digite o Pre‡o Unit rio, com ICMS")
         Le()
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         // Atualiza os itens da nota.
         SELECT Nfi
         IF mudap     // Houve mudan‡a de produto.
            SEEK vnunf+mcod[li+vt]
            Nfi->codpro:=vcod
         ELSE         // N„o houve mudan‡a de produto.
            SEEK vnunf+vcod
            IF !FOUND()
               // Se o item ainda n„o existir na nota, inclui um novo.
               ++vord  // Aumenta o n£mero de itens da nota.
               APPEND BLANK
               Nfi->nunf:=vnunf;Nfi->codpro:=vcod;Nfi->item:=STRZERO(vord,2)
            ENDIF
         ENDIF
         SELECT Nfi
         SEEK vnunf+vcod
         // Atualiza os dados do item.
         Nfi->quant:=vqtd;Nfi->preco:=vpre*vqtd;Nfi->preun:=vpre
         Nfi->codcli:=vcodcli;Nfi->data:=vdata;Nfi->preul:=preun //*(1-vpicms/100)
         // Atualiza os valores da nota.
         vvalor:=vvalor-mpre[li+vt]*mqtd[li+vt]+vpre*vqtd
         vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
         vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
         // Reapresenta o valor total da nota e o icms.
         SETCOLOR(vcr)
         @  3,63 SAY vvalor      PICTURE "@E 999,999,999.99"
         @  9,67 SAY vvcomi      PICTURE "@E 999,999.99"
         @ 11,63 SAY vicms       PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o vetor dos itens da nota.
         mcod[li+vt]:=vcod;mqtd[li+vt]:=vqtd;mpre[li+vt]:=vpre
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
         SELECT Nfi
         // Pesquisa o item no arquivo.
         SEEK vnunf+mcod[li+vt]
         // Deleta o item da nota.
         DELETE
         // Diminui a quantidade de itens da nota.
         --vord
         // Atualiza os valores da nota.
         vvalor:=vvalor-(mpre[li+vt]*mqtd[li+vt])
         vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
         vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
         // Reapresenta o valor total da nota e o icms.
         SETCOLOR(vcr)
         @  3,63 SAY vvalor      PICTURE "@E 999,999,999.99"
         @  9,67 SAY vvcomi      PICTURE "@E 999,999.99"
         @ 11,63 SAY vicms       PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o n£mero dos itens da nota.
         REPLACE Nfi->item WITH STR(VAL(item)-1,2) WHILE vnunf=Nfi->nunf
         // Atualiza o vetor dos itens, eliminando o elemento deletado.
         ADEL(mcod,li+vt);ADEL(mqtd,li+vt);ADEL(mpre,li+vt)
         // Atualiza as linhas de controle de edi‡„o na tela.
         IF vt>0
            --vt
         ELSE
            IF lf>1 .AND. lf<(22-vli)
               --lf
            ENDIF
         ENDIF
         // Reapresenta os itens da nota, eliminando o que foi deletado.
         Mostra(1,(22-vli),vcn)
      ELSEIF tk=K_ESC
         // Foi pressionada a tecla <Esc>: finaliza a edi‡„o dos itens.
         IF Confirme()
            // Se for confirmado, atualiza os dados da Nota Fiscal.
            SELECT Nf
            Atualiza()
            // Atualiza os itens da Nota Fiscal.
            Atualitem()
            // Finaliza.
            EXIT
         ENDIF
      ENDIF
   ENDDO
   // Limpa a tela.
   @ 24,00 CLEAR
   FOR i=22 TO vli+1 STEP -1
       @ i,01 SAY SPACE(78)
   NEXT
   SELECT Nf
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Tela()
// Apresenta os dados das notas na tela.
********************************************************************************
SETCOLOR(vcn)
@  3, 4 SAY "N§ Nota: "
@  3,22 SAY "N§ Pedido: "
@  3,39 SAY "Data: "
@  3,56 SAY "Valor: "
@  5, 4 SAY "C¢digo Cliente: "
@  5,31 SAY "Nome: "
@  7, 4 SAY "Pedido Cliente: "
@  7,36 SAY "Opera‡„o: "
@  7,55 SAY "Tipo de Pagamento: "
@  9, 4 SAY "Vendedor: "
@  9,57 SAY "Comiss„o: " 
@ 11, 4 SAY "Encargos: "
@ 11,29 SAY "Desconto: "
@ 11,57 SAY "ICMS: "
SETCOLOR(vcr)
@  3,13 SAY vnunf       PICTURE "9999999"
@  3,33 SAY vnupd       PICTURE "99999"
@  3,45 SAY vdata
@  3,63 SAY vvalor      PICTURE "@E 999,999,999.99"
@  5,20 SAY vcodcli     PICTURE "99999"
@  5,37 SAY vcli        PICTURE "@!"
@  7,20 SAY vpdcli      PICTURE "@!"
@  7,46 SAY vopera      PICTURE "@R 9.99.999"
@  7,74 SAY vtipg       PICTURE "!!!"
@  9,14 SAY vcodrep     PICTURE "999"
@  9,19 SAY vrep        PICTURE "@!"
@  9,67 SAY vvcomi      PICTURE "@E 999,999.99"
@ 11,14 SAY vvencf      PICTURE "@E 999,999,999.99"
@ 11,39 SAY vvdesc      PICTURE "@E 999,999,999.99"
@ 11,63 SAY vicms       PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
@ 12, 01  SAY "ÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Pre‡o Unit. ÍÍ"
/* M scara de edi‡„o dos itens da venda.
ÍÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Pre‡o Unit.Í"
Í> 9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999,999.99
*/
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados da nota na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,13 SAY vnunf       PICTURE "9999999"
@  3,33 SAY vnupd       PICTURE "99999"
SETCOLOR(vcn)
@  3,45 GET vdata VALID !EMPTY(vdata)
SETCOLOR(vcr)
@  3,63 SAY vvalor      PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
@  5,20 GET vcodcli     PICTURE "99999"
Le()
vcodcli:=Acha(vcodcli,"Cli",1,2,"codi","nome","99999","@!",15,05,22,76)
vCli:=Cli->nome
SETCOLOR(vcr)
@  5,37 SAY vcli        PICTURE "@!"
SETCOLOR(vcn)
@  7,20 GET vpdcli      PICTURE "@!"
@  7,46 GET vopera      PICTURE "@R 9.99.999"
Le()
// Apresenta uma tabela de consulta para a opera‡„o.
vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
SETCOLOR(vcr)
@  7,46 SAY vopera      PICTURE "@R 9.99.999"
SETCOLOR(vcn)
@  7,74 GET vtipg       PICTURE "!!!"
Le()
vtipg:=Acha(vtipg,"Tpg",1,2,"codi","nome","!!!","@!",15,10,22,76)
SETCOLOR(vcr)
@  7,73 SAY vtipg       PICTURE "!!!"
SETCOLOR(vcn)
@  9,14 GET vcodrep     PICTURE "999"
Le()
vcodrep:=IF(!EMPTY(vcodrep),Zeracod(vcodrep),vcodrep)
vcodrep:=Acha(vcodrep,"Rep",1,2,"codi","nome","999","@!",15,05,22,76)
vrep:=LEFT(Rep->nome,35)
vvcomi:=vvalor*Rep->pctc/100
SETCOLOR(vcr)
@  9,14 SAY vcodrep     PICTURE "999"
@  9,19 SAY vrep        PICTURE "@!"
@  9,67 SAY vvcomi      PICTURE "@E 999,999.99"
SETCOLOR(vcn)
@ 11,14 GET vvencf      PICTURE "@E 999,999,999.99"
@ 11,39 GET vvdesc      PICTURE "@E 999,999,999.99"
SETCOLOR(vcr)
@ 11,63 SAY vicms        PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(ni,nf,vcor)
// Apresenta os itens das notas na tela.
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
SELECT Nf
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados do arquivo para as vari veis auxiliares.
********************************************************************************
vnupd  :=nupd
vdata  :=data
vvalor :=valor
vvcomi :=vcomi
vcodcli:=codcli
vcli   :=Cli
vpdcli :=Pdcli
vopera :=opera
vtipg  :=tipg  
vcodrep:=codrep
vvencf :=vencf
vvdesc :=vdesc
vicms  :=icms
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados do arquivo com as vari veis auxiliares.
********************************************************************************
Nf->nupd  :=vnupd
Nf->data  :=vdata
Nf->valor :=vvalor
Nf->vcomi :=vvcomi
Nf->codcli:=vcodcli
Nf->cli   :=vCli
Nf->pdcli :=vPdcli
Nf->opera :=vopera
Nf->tipg  :=vtipg  
Nf->codrep:=vcodrep
Nf->vencf :=vvencf
Nf->vdesc :=vvdesc
Nf->icms  :=vicms
RETURN
********************************************************************************
STATIC PROCEDURE Atualitem()
// Atualiza os dados dos itens com as vari veis auxiliares.
********************************************************************************
SELECT Nf
SEEK vnunf
IF FOUND()
   DO WHILE vnunf=nunf .AND. !EOF()
      Nfi->item:=STRZERO(++i,2) // Numero sequencial do item.
      Nfi->data:=vdata          // Data da Nota Fiscal.
      Nfi->codcli:=vcodcli      // Codigo do cliente.
      SKIP
   ENDDO
ENDIF
SELECT Nf 
RETURN
********************************************************************************
PROCEDURE Consnf()
// Consulta das notas na Tela
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
IF FILE("SAONF.DBF")
   // Notas
   SELECT 2
   USE SAONF ALIAS Nf
   IF !FILE("SAONF1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONF1,SAONF2,SAONF3
ELSE
   Mensagem("Arquivo das Notas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAONFI.DBF")
   // Itens das notas
   SELECT 3
   USE SAONFI ALIAS Nfi
   IF !FILE("SAONFI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONFI1
ELSE
   Mensagem("Arquivo dos Itens das Notas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOREP.DBF")
   SELECT 4
   USE SAOREP ALIAS Rep
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1,SAOREP2
ELSE
   Mensagem("Arquivo dos Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Nf
// Inicializa as vari veis auxiliares.
vli:=12
vnupd  :=SPACE(5)
vnunf  :=SPACE(7)
vdata  :=CTOD(SPACE(8))
vcodcli:=SPACE(5)
vcli   :=SPACE(40)
vpdcli :=SPACE(15)
vopera :=SPACE(6)
vtipg  :=SPACE(3)
vcodrep:=SPACE(3)
vrep   :=SPACE(35)
vvalor :=vvcomi:= vvencf :=vvdesc:=vicms:=0
// Constru‡„o da Tela de Apresenta‡„o.
Sinal("NOTAS","CONSULTAS")
Abrejan(2)
// Declara os vetores de consulta.
PRIVATE vdado[12],vmask[12],vcabe[12]
// Dados a serem apresentados.
vdado[01]:="nunf"
vdado[02]:="nupd"
vdado[03]:="data"
vdado[04]:="valor"
vdado[05]:="LEFT(cli,38)"
vdado[06]:="pdcli"
vdado[07]:="tipg"
vdado[08]:="vencf"
vdado[09]:="vdesc"
vdado[10]:="icms"
vdado[11]:="codrep"
vdado[12]:="vcomi"
// Cabe‡alhos das colunas.
vcabe[01]:="Nota"
vcabe[02]:="Pedido"
vcabe[03]:="Data"
vcabe[04]:="Valor Total"
vcabe[05]:="Cliente"
vcabe[06]:="Pedido Cliente"
vcabe[07]:="Pagto"
vcabe[08]:="Encargos"
vcabe[09]:="Desconto"
vcabe[10]:="ICMS"
vcabe[11]:="Vendedor"
vcabe[12]:="Comiss„o"
// M scaras de apresenta‡„o.
vmask[01]:="9999999"
vmask[02]:="99999"
vmask[04]:="@E 999,999,999.99"
vmask[08]:="@E 999,999,999.99"
vmask[09]:="@E 999,999,999.99"
vmask[10]:="@E 999,999,999.99"
vmask[12]:="@E 999,999.99"
// Linha de orienta‡„o ao usu rio.
SETCOLOR(vcr)
@ 23,02 SAY PADC("F1 Help  F5 N£mero  F6 Cliente  F9 Data  [PgUp] [PgDn]  [Enter]  [Esc]",76)
SETCOLOR(vcn)
// Executa a fun‡„o DBEDIT().
DBEDIT(03,01,22,78,vdado,"Fxnf",vmask,vcabe,"Ä","³")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fxnf(modo)
// Fun‡ao para Consulta aos notas atrav‚s da DBEDIT()
********************************************************************************
IF modo=4
   IF LASTKEY()=K_ENTER
      // Foi pressionada a tecla <Enter>: apresenta‡„o dos itens da nota.
      vtela:=SAVESCREEN(01,00,24,79) // Salva a tela de consulta.
      SETCOLOR(vcn)
      Abrejan(2)  // Abre a janela de dados.
      vnunf:=nunf
      vnupd:=nupd
      Transfere() // Transfere os dados do arquivo para as vari veis auxiliares.
      SELECT Rep
      SEEK vcodrep
      IF FOUND()
         vrep:=LEFT(Rep->nome,35)
      ENDIF
      SELECT Nf
      Tela()      // Apresenta a tela da nota.
      SELECT Nfi
      SEEK vnunf  // Pesquisa os itens da nota.
      IF !FOUND()
         // Itens n„o encontrados.
         SETCOLOR(vca)
         Aviso(16,"Esta Nota N„o possui Itens !")
         SETCOLOR(vcn)
         INKEY(5)  // Aguarda 5 segundos.
      ELSE
         // Apresenta os itens da nota.
         DO WHILE .T.
            i:=13
            DO WHILE i<23 .AND. nunf=vnunf .AND. !EOF()
               @ i  ,  4  SAY  Nfi->codpro PICTURE "@R 9.99.999"
               SELECT Prod
               SEEK Nfi->codpro
               SELECT Nfi
               @ i  , 13  SAY  LEFT(Prod->nome,40)
               @ i  , 54  SAY  Nfi->quant PICTURE "@E 999,999.99"
               @ i  , 65  SAY  Nfi->preun PICTURE "@E 999,999,999.99"
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
                  IF Nfi->nunf#vnunf .OR. BOF()
                     SEEK vnunf
                  ENDIF
                  EXIT
               ELSEIF tk=K_PGDN
                  // Foi pressionada a tecla <PgDn>: avan‡a os itens.
                  SKIP -1
                  EXIT
               ELSEIF tk=K_ESC
                  // Foi pressionada a tecla <Esc>: finaliza.
                  @ 24,00 CLEAR
                  SELECT Nf
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
      SELECT Nf
      SETCOLOR(vcn)
      RETURN(1)
   ELSEIF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      // Pressionada a tecla <F5>: pesquisa pelo n£mero da nota.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 1
      // Solicita o n£mero da nota desejado.
      vcd:=SPACE(7)
      @ 24,27 SAY "Nota Desejada: " GET vcd PICTURE "9999999"
      Le()
      // Retorna se o n£mero da nota estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa o n£mero da nota solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vcd)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Nota N„o Encontrada!",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando a nota solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      // Pressionada a tecla <F6>: pesquisa pelo nome do cliente.
      @ 24,00 CLEAR
      // Define a ordem de pesquisa.
      SET ORDER TO 2
      // Solicita o nome do cliente.
      vnome:=SPACE(40)
      @ 24,10 SAY "Cliente Desejado: " GET vnome PICTURE "@!"
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
         Mensagem("Desculpe, Cliente N„o Encontrado !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta mostrando o fornecedor solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F9
      // Pressionada a tecla <F9>: pesquisa pela data da nota.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 3
      // Solicita a data da nota desejada.
      vcd:=CTOD(SPACE(8))
      @ 24,27 SAY "Data Desejada: " GET vcd
      Le()
      // Retorna se a data da nota estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa a data da nota solicitada.
      SET SOFTSEEK ON
      SEEK vcd
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrada!",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando a nota solicitado.
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
      @ 17,12 SAY "[Enter] - Mostra os Itens da Nota"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[F5]    - Pesquisa pelo N£mero da Nota"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Cliente"
      @ 21,12 SAY "[F9]    - Pesquisa pela Data da Nota"
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
PROCEDURE Relnf1(tipo)
/*
Objetivo : emite os relat¢rios das notas fiscais.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("NOTAS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAONF.DBF")
   // Vendas
   SELECT 1
   USE SAONF ALIAS Nf
   IF !FILE("SAONF3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONF3
ELSE
   Mensagem("Arquivo das Notas Fiscais N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Nf
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas notas devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio Sint‚tico das Notas Fiscais")
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
DO WHILE !EOF() .AND. Nf->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Sintetico das Notas Fiscais","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   IF tipo=1
      @ PROW()+1,01 SAY "PEDIDO  NOTA     DATA         VALOR DA NOTA               VALOR TOTAL ACUMULADO"
   ELSE
      @ PROW()+1,01 SAY "PEDIDO  NOTA     DATA                  CLIENTE                    VALOR TOTAL"
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Nf->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Nf->data>=vdati .AND. Nf->data<=vdatf
         @ PROW()+1,01 SAY Nf->nupd
         @ PROW(),  08 SAY Nf->nunf
         @ PROW(),  16 SAY Nf->data
         vtot+=(Nf->valor+Nf->vencf-Nf->vdesc)
         IF tipo=1
            @ PROW(),  30 SAY Nf->valor+Nf->vencf-Nf->vdesc PICTURE "@E 999,999,999.99"
            @ PROW(),  66 SAY vtot PICTURE "@E 999,999,999.99"
         ELSE
            @ PROW(),  25 SAY Nf->cli
            @ PROW(),  66 SAY Nf->valor+Nf->vencf-Nf->vdesc PICTURE "@E 999,999,999.99"
         ENDIF
      ENDIF
      SKIP
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+1,10 SAY "T O T A L    G E R A L"
@ PROW(),  64 SAY vtot PICTURE "@E 9,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
/*
Pedido  Nota     Data                  Cliente                    Valor Total
99999  9999999 99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999,999.99
                              Valor da Nota     Valor Total Acumulado
99999  9999999 99/99/99      999,999,999.99         999,999,999.99 */
********************************************************************************
PROCEDURE Relnf2()
/*
Objetivo : emite os relat¢rios das vendas.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("NOTAS","RELATORIO")
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
IF FILE("SAONF.DBF")
   // Vendas
   SELECT 2
   USE SAONF ALIAS Nf
   IF !FILE("SAONF3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONF3
ELSE
   Mensagem("Arquivo das Notas Fiscais N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAONFI.DBF")
   // Itens das Notas Fiscais
   SELECT 3
   USE SAONFI ALIAS Nfi
   IF !FILE("SAONFI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAONFI1
ELSE
   Mensagem("Arquivo dos Itens das Notas Fiscais N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
SELECT Nf
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Anal¡tico das Notas Fiscais")
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
DO WHILE !EOF() .AND. Nf->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Analitico das Notas Fiscais","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Nf->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF Nf->data<vdati .OR. Nf->data>vdatf
         SKIP
         LOOP
      ENDIF
      // Impress„o dos dados.
      @ PROW()+2, 4 SAY "No.Nota: "+Nf->nunf
      @ PROW(),  22 SAY "No.Pedido: "+Nf->nupd
      @ PROW(),  45 SAY "Data: "+DTOC(Nf->data)
      @ PROW(),  60 SAY "Valor:"+TRANSFORM(Nf->valor,"@E 99,999,999.99")
      @ PROW()+1, 4 SAY "Cliente: "+Nf->codcli+" - "+Nf->cli
      @ PROW()+1, 4 SAY "Pedido Cliente: "+Nf->pdcli
      @ PROW(),  37 SAY "Oper.: "+TRANSFORM(Nf->opera,"@E 9.99.999")
      @ PROW(),  55 SAY "Tipo de Pagamento: "+Nf->tipg
      @ PROW()+1, 4 SAY "Vendedor: "+Nf->codrep
      @ PROW(),  56 SAY "Comissao: "+TRANSFORM(Nf->vcomi,"@E 999,999.99")
      @ PROW()+1, 4 SAY "Encargos:"+TRANSFORM(Nf->vencf,"@E 999,999,999.99")
      @ PROW(),  29 SAY "Desconto:"+TRANSFORM(Nf->vdesc,"@E 999,999,999.99")
      @ PROW(),  56 SAY "ICMS:"+TRANSFORM(Nf->icms,"@E 999,999,999.99")
      SELECT Nfi
      IF pv
         vtot+=(Nf->valor+Nf->vencf+Nf->icms-Nf->vdesc)
         SEEK Nfi->nunf
         pv=.F.
      ENDIF
      IF Nf->nunf=Nfi->nunf
         @ PROW()+1,01 SAY "-- Codigo ------ Nome do Produto ------------------- Quantidade - Preco Unit.-"
         DO WHILE Nf->nunf=Nfi->nunf .AND. PROW()<=60 .AND. !EOF() 
            @ PROW()+1,02 SAY Nfi->codpro PICTURE "@R 9.99.999"
            @ PROW(),  13 SAY LEFT(Prod->nome,40)
            @ PROW(),  54 SAY TRANSFORM(Nfi->quant,"@E 999,999.99")
            @ PROW(),  65 SAY TRANSFORM(Nfi->preun,"@E 999,999,999.99")
            SKIP
         ENDDO
      ENDIF
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SELECT Nf
      IF Nfi->nunf#Nf->nunf
         SKIP
         pv:=.T.
      ENDIF
   ENDDO  // Fim do DO WHILE da p gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,10 SAY "T O T A L"
@ PROW(),  62 SAY vtot PICTURE "@E 99,999,999,999.99"
@ PROW()+1,00 SAY REPLICATE("-",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
RETURN
********************************************************************************
//                        Fim do Programa SAONF.PRG
********************************************************************************
