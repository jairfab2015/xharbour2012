********************************************************************************
/* Programa.: SAOTRAN.PRG
   Autor....: Antonio Geraldo Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento de Transferˆncias Dep¢sito/Loja. */
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matran(tipo,modo)
/* Manuten‡„o das transferˆncias - Parƒmetros:tipo: 1- Transferˆncias dep¢sito/loja
                                             2- Transferˆncias loga/dep¢sito
                                       modo: 1- Inclus„o
                                             2- Altera‡„o
                                             3- Exclus„o
*/
********************************************************************************
// Declara os vetores privados que ser„o utilizados para editar os itens.
PRIVATE mcod[66],mqtd[66],mpre[66],vcod,vqtd,vpre,n
/* mcod[]/vcod: c¢digo dos produtos.
   mqtd[]/vqtd: quantidade solicitada.
   mpre[]/vpre: pre‡o total.
   n: verifica produto j  cadastrado.*/
// Declara as vari veis privadas de controle da edi‡„o na tela.
PRIVATE vli,li,lf,vt,vord,vok,mudap
/* vli:  linha inicial para edi‡„o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens da transferˆncia.
   vok:  existˆncia da transferˆncia.
   mudap:mudan‡a de produto de um item.*/
// Inicializa a linha inicial para edi‡„o dos itens.
vli:=07
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
IF FILE("SAOTRA.DBF")
   // Transferˆncias
   SELECT 2
   USE SAOTRA ALIAS Tra
   IF !FILE("SAOTRA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRA1,SAOTRA2
ELSE
   Mensagem("Arquivo das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTRI.DBF")
   // Itens das transferˆncias
   SELECT 3
   USE SAOTRI ALIAS Tri
   IF !FILE("SAOTRI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRI1
ELSE
   Mensagem("Arquivo dos Itens de Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 4
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
   Sinal("TRANSFERENCIAS","INCLUSŽO")
ELSEIF modo=2
   Sinal("TRANSFERENCIAS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("TRANSFERENCIAS","EXCLUSŽO")
ENDIF
// Abre a janela de dados.
Abrejan(2)
SELECT Tra
DO WHILE .T.
   // Inicializa as vari veis auxiliares para edi‡„o dos dados.
   vnupd  :=SPACE(5)
   vdata  :=CTOD(SPACE(8))
   vvalor :=0
   vopera :=SPACE(6)
   vdesc  :=SPACE(50)
   vok    :=.T.
   // Apresenta os dados das transferˆncias na tela.
   Tela()
   DO WHILE .T.
      // Solicita o n£mero da transferˆncia a ser editado.
      vnupd:=SPACE(5)
      @  3,20 GET vnupd  PICTURE "99999"
      Aviso(24,"Digite o N§ da Transferˆncia ou tecle [Esc] para Finalizar")
      Le()
      /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da transferˆncia
         estiver em branco.*/
      IF LASTKEY()=K_ESC .OR. EMPTY(vnupd)
         CLOSE DATABASE
         RETURN
      ENDIF
      vnupd:=Zeracod(vnupd)
      // Pesquisa a transferˆncia no arquivo de transferˆncias.
      IF modo=1
         SELECT Tra
         SEEK vnupd
         IF FOUND()
            Mensagem("Desculpe, Transferˆncia j  Cadastrada!",5,1)
            LOOP
         ELSE
            vok=.F.
         ENDIF
      ELSE
         SELECT Tra
         SEEK vnupd
         IF !FOUND()
            // Se n„o foi encontrado retorna se for altera‡„o ou exclus„o.
            Mensagem("Desculpe, Transferˆncia N„o Encontrada !",6,1)
            LOOP
         ENDIF
      ENDIF
      EXIT
   ENDDO
   // Inicializa os vetores dos itens das transferˆncias/transferˆncias.
   AFILL(mcod,SPACE(6));AFILL(mqtd,0);AFILL(mpre,0)
   // Inicializa as vari veis de controle da tela.
   li:=lf:=1;vt:=0;vord:=0
   /* Se o transferˆncia tiver sido encontrado, transfere os dados dos arquivos para
      as vari veis auxiliares de edi‡„o.*/
   IF vok
      IF Tra->ttipo#STR(tipo,1)
         Mensagem("Tipo da Transferˆncia Incompat¡vel !",8,1)
         LOOP
      ENDIF
      @ 24,00 CLEAR
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      // Transfere os dados para as vari veis auxiliares.
      Transfere()
      k:=1; vvalor:=0
      // Transferˆncia dos dados dos itens das transferˆncias para os vetores.
      SELECT Tri
      SEEK vnupd
      IF FOUND()
         DO WHILE vnupd=nupd .AND. !EOF()
            mcod[k]:=codpro // c¢digo dos produtos.
            mqtd[k]:=quant  // quantidade solicitada.
            mpre[k]:=preun  // pre‡o unit rio.
           // Calcula o valor total da transferˆncia.
            vvalor+=(mpre[k]*mqtd[k])
            SKIP
            ++k
         ENDDO
         // Define o n£mero total de itens da transferˆncia.
         vord:=k-1
      ENDIF
      // Define a £ltima linha de edi‡„o dos itens da transferˆncia (lf).
      IF vord>(22-vli)
         lf:=(22-vli)
      ELSE
         lf:=k
      ENDIF
      @ 24,00 CLEAR
      SELECT Tra
      IF modo=1
         APPEND BLANK
         Tra->nupd:=vnupd
         Tra->ttipo:=STR(tipo,1)
         Atualiza()
         vvalor:=0
         SELECT Tri
         FOR i=1 TO vord
            APPEND BLANK
            Tri->nupd:=vnupd
            Tri->codpro:=mcod[i]  // c¢digo dos produtos.
            Tri->quant :=mqtd[i]  // quantidade solicitada.
            Tri->preun :=mpre[i]  // pre‡o unit rio de transferˆncia.
            vvalor+=(mpre[i]*mqtd[i])
            SKIP
         NEXT
         SELECT Tra 
      ENDIF
      // Apresenta os dados da transferˆncia na tela.
      Tela()
      // Apresenta os dados dos itens da transferˆncia na tela.
      Mostra(1,vord,vcn)
   ELSE
      SELECT Tra
      APPEND BLANK
      Tra->nupd:=vnupd
      Tra->ttipo:=STR(tipo,1)
   ENDIF
   SELECT Tra
   // Se a opera‡„o for exclus„o de transferˆncias/transferˆncias.
   IF modo=3
      // Solicita confirma‡„o da exclus„o da transferˆncia apresentado.
      IF Exclui()
         // Deleta os itens da transferˆncia.
         SELECT Tri
         SEEK vnupd
         DO WHILE nupd=vnupd .AND. !EOF()
            SELECT Prod
            SEEK Tri->codpro
            SELECT Tri
            IF tipo=1
               // Atualiza o saldo do estoque no dep¢sito.
               IF Prod->saldod<Tri->quant
                  Prod->saldod:=0
               ELSE
                  Prod->saldod:=Prod->saldod-Tri->quant
               ENDIF
               Prod->saldo:=Prod->saldo+Tri->quant
            ELSEIF tipo=2
               // Atualiza o saldo do estoque na loja.
               IF Prod->saldo<Tri->quant
                  Prod->saldo:=0
               ELSE
                  Prod->saldo:=Prod->saldo-Tri->quant
               ENDIF
               Prod->saldod:=Prod->saldod+Tri->quant
            ENDIF
            // Deleta os itens da transferˆncia.
            DELETE
            SKIP
         ENDDO
         // Deleta a transferˆncia.
         SELECT Tra
         DELETE
      ENDIF
      // Limpa a tela.
      @ 24,00 CLEAR
      FOR i=22 TO vli+1 STEP -1
          @ i,01 SAY SPACE(78)
      NEXT
      SELECT Tra
      // Retorna para realizar outra exclus„o.
      LOOP
   ENDIF
   // Se for inclus„o ou altera‡„o de transferˆncias.
   DO WHILE .T.
      // Edita os dados da transferˆncia enquanto n„o houver confirma‡„o.
      Edita()
      IF Confirme()
         // Finaliza se a edi‡„o for confirmada.
         EXIT
      ENDIF
   ENDDO
   SELECT Tra
   // Atualiza a transferˆncia, gravando as vari veis auxiares no registro do arquivo.
   Atualiza()
   // Edi‡„o dos itens da transferˆncia.
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
         vpre:=mpre[li+vt] // pre‡o. 
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
         IF vcod#mcod[li+vt] .AND. mcod[li+vt]#SPACE(6)
            // Houve mudan‡a, mudap torna-se verdadeira.
            mudap=.T.
         ENDIF
         // Reapresenta o c¢digo na tela.
         @ vli+li,04 SAY vcod PICTURE "@R 9.99.999"
         /* Se houve mudan‡a de produto, verifica se o mesmo j  n„o foi
            inclu¡do na transferˆncia, num dos outros itens j  cadastrados.*/
         // Verifica que o produto j  est  cadastrado nos itens.
         n:=ASCAN(mcod,vcod)
         IF n#0 .AND. n#li+vt
            Mensagem("Desculpe, Produto j  Presente Nesta Transferˆncia !",6,1)
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
         @ vli+li, 65 SAY Prod->custr PICTURE "@E 999,999,999.99"
         vpre:=Prod->custr
         // Solicita a quantidade.
         @ vli+li, 54 GET vqtd PICTURE "999,999.99" VALID(vqtd>0)
         Aviso(24,"Digite a Quantidade em "+TRIM(Prod->unid))
         Le()
         @ vli+li,54 SAY vqtd PICTURE "@E 999,999.99"
         /*  
         // Solicita o pre‡o unit rio.
         @ vli+li,65 GET vpre PICTURE "999,999,999.99"
         Aviso(24,"Digite o Pre‡o Unit rio Bruto, com ICM")
         Le()
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         */
         // Atualiza o arquivo dos Produtos.
         SELECT Prod
         SEEK vcod
         // Atualiza o produto.
         IF tipo=1
            IF mudap     // Houve mudan‡a de produto.
               IF Prod->saldod<vqtd
                  Mensagem("Saldo Insuficiˆnte para esta Transferˆncia!",8,1)
                  @ vli+li,03 SAY SPACE(76)
                  LOOP
               ELSE
                  Prod->saldod:=(Prod->saldod-vqtd) // - Dep¢sito
                  Prod->saldo :=(Prod->saldo +vqtd) // + Loja
               ENDIF 
               // Atualiza o produto anterior.
               SEEK mcod[li+vt]
               Prod->saldod:=(Prod->saldod+mqtd[li+vt])  // + Dep¢sito
               Prod->saldo :=(Prod->saldo -mqtd[li+vt])  // - Loja
            ELSE
               IF Prod->saldod+mqtd[li+vt]<vqtd
                  Mensagem("Saldo Insuficiˆnte para esta Transferˆncia!",8,1)
                  @ vli+li,03 SAY SPACE(76)
                  LOOP
               ELSE
                  Prod->saldod:=(Prod->saldod+mqtd[li+vt]-vqtd) // - Dep¢sito
                  Prod->saldo :=(Prod->saldo -mqtd[li+vt]+vqtd) // + Loja
               ENDIF 
            ENDIF
         ELSEIF tipo=2
            IF mudap     // Houve mudan‡a de produto.
               IF Prod->saldo<vqtd
                  Mensagem("Saldo Insuficiˆnte para esta Transferˆncia!",8,1)
                  @ vli+li,03 SAY SPACE(76)
                  LOOP
               ELSE
                  Prod->saldo :=(Prod->saldo -vqtd)  // - Loja
                  Prod->saldod:=(Prod->saldod+vqtd)  // + Dep¢sito
               ENDIF 
               // Atualiza o produto anterior.
               SEEK mcod[li+vt]
               Prod->saldo :=(Prod->saldo +mqtd[li+vt])  // + Loja
               Prod->saldod:=(Prod->saldod-mqtd[li+vt])  // - Dep¢sito
            ELSE
               IF Prod->saldo+mqtd[li+vt]<vqtd
                  Mensagem("Saldo Insuficiˆnte para esta Transferˆncia!",8,1)
                  @ vli+li,03 SAY SPACE(76)
                  LOOP
               ELSE
                  Prod->saldo :=(Prod->saldo +mqtd[li+vt]-vqtd)  // - Loja
                  Prod->saldod:=(Prod->saldod-mqtd[li+vt]+vqtd)  // + Dep¢sito
               ENDIF 
            ENDIF
         ENDIF
         SELECT Prod
         SEEK vcod
         // Atualiza os itens da transferˆncia.
         SELECT Tri
         IF mudap     // Houve mudan‡a de produto.
            SEEK vnupd+mcod[li+vt]
            Tri->codpro:=vcod
         ELSE         // N„o houve mudan‡a de produto.
            SEEK vnupd+vcod
            IF !FOUND()
               // Se o item ainda n„o existir no transferˆncia, inclui um novo.
               ++vord  // Aumenta o n£mero de itens da transferˆncia.
               APPEND BLANK
               Tri->nupd:=vnupd;Tri->codpro:=vcod;Tri->item:=STRZERO(vord,2)
            ENDIF
         ENDIF
         // Atualiza os dados do item.
         Tri->quant:=vqtd;Tri->preco:=vpre*vqtd;Tri->preun:=vpre;Tri->data:=vdata
         // Atualiza o valor da transferˆncia.
         vvalor:=vvalor-(mpre[li+vt]*mqtd[li+vt]-vpre*vqtd)
         // Reapresenta o valor total da transferˆncia.
         SETCOLOR(vcr)
         @  3,64 SAY vvalor      PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o vetor dos itens da transferˆncia.
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
         SELECT Tri
         // Pesquisa o item no arquivo.
         SEEK vnupd+mcod[li+vt]
         IF FOUND()
            // Atualiza o arquivo dos Produtos.
            SELECT Prod
            SEEK mcod[li+vt]
            IF tipo=1
               IF saldo>=mqtd[li+vt]
                  Prod->saldo:=(saldo-mqtd[li+vt])
               ELSE
                  Prod->saldo:=0
               ENDIF
               Prod->saldod:=(saldod+mqtd[li+vt])
            ELSEIF tipo=2
               IF saldod>=mqtd[li+vt]
                  Prod->saldod:=(saldod-mqtd[li+vt])
               ELSE
                  Prod->saldod:=0
               ENDIF
               Prod->saldo:=(saldo+mqtd[li+vt])
            ENDIF
         ENDIF
         SELECT Tri
         // Deleta o item.
         DELETE
         // Diminui a quantidade de itens da transferˆncia.
         --vord
         // Atualiza o valor da transferˆncia.
         vvalor:=vvalor-(mpre[li+vt]*mqtd[li+vt])
         // Reapresenta o valor total da transferˆncia.
         SETCOLOR(vcr)
         @  3,64 SAY vvalor      PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o n£mero dos itens da transferˆncia.
         REPLACE Tri->item WITH STR(VAL(item)-1,2) WHILE vnupd=Tri->nupd
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
         // Reapresenta os itens do pedido, eliminando o que foi deletado.
         Mostra(1,(22-vli),vcn)
      ELSEIF tk=K_ESC
         // Foi pressionada a tecla <Esc>: finaliza a edi‡„o dos itens.
         IF Confirme()
            // Se confirmado, atualiza os dados da transferencia.
            SELECT Tra
            Atualiza()
            // Atualiza os dados dos itens.
            Atualitem()
            // Finaliza a edicao da transferencia.
            EXIT
         ENDIF
      ENDIF
   ENDDO
   // Limpa a tela.
   @ 24,00 CLEAR
   FOR i=22 TO vli+1 STEP -1
       @ i,01 SAY SPACE(78)
   NEXT
   SELECT Tra
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Tela()
// Apresenta os dados das transferˆncias na tela.
********************************************************************************
SETCOLOR(vcn)
@  3, 2 SAY "Transferˆncia N§: "
@  3,29 SAY "Data: "
@  3,51 SAY "Valor Total: "
@  5, 2 SAY "Oper: "
@  5,17 SAY "Descri‡„o: "
/*
 Transferencia N§: 99999    Data: 99/99/99        Valor Total: 999,999,999.99
 Oper: 9.99.999 Descricao: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*/ 
SETCOLOR(vcr)
@  3,20 SAY vnupd       PICTURE "99999"
@  3,35 SAY vdata       PICTURE "99/99/99"
@  3,64 SAY vvalor      PICTURE "@E 999,999,999.99"
@  5,08 SAY vopera      PICTURE "@R 9.99.999"
@  5,28 SAY vdesc       PICTURE "@!"
SETCOLOR(vcn)
@ 07, 01  SAY "ÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit. ÍÍ"
/* M scara de edi‡„o dos itens da transferˆncia.
ÍÍÍ C¢digo ÍÍÍÍÍ Nome do Produto ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ Quantidade Í Custo Unit.Í"
Í> 9.99.999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 999,999,999.99
*/
RETURN
********************************************************************************
STATIC PROCEDURE Edita()
// Edita os dados da transferˆncia na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,20 SAY vnupd       PICTURE "99999"
SETCOLOR(vcn)
@  3,35 GET vdata       PICTURE "99/99/99" VALID !EMPTY(vdata)
Le()
SETCOLOR(vcr)
@  3,64 SAY vvalor      PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
@  5,08 GET vopera      PICTURE "@R 9.99.999"
Le()
// Apresenta uma tabela de consulta para a opera‡„o.
vopera:=Acha(vopera,"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
SETCOLOR(vcr)
@  5,08 SAY vopera      PICTURE "@R 9.99.999"
SETCOLOR(vcn)
IF EMPTY(vdesc)
   vdesc:=Ope->nome
ENDIF
@  5,28 GET vdesc       PICTURE "@!"
Le()
RETURN
********************************************************************************
STATIC PROCEDURE Mostra(ni,nf,vcor)
// Apresenta os itens das transferˆncias na tela.
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
SELECT Tra
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados do arquivo para as vari veis auxiliares.
********************************************************************************
vdata  :=Tra->data
vvalor :=Tra->valor
vopera :=Tra->opera
vdesc  :=Tra->desc
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados do arquivo com as vari veis auxiliares.
********************************************************************************
Tra->data  :=vdata
Tra->valor :=vvalor
Tra->opera :=vopera
Tra->desc  :=vdesc
RETURN
********************************************************************************
STATIC PROCEDURE Atualitem()
// Atualiza os dados dos itens com as vari veis auxiliares.
********************************************************************************
SELECT Tri
SEEK vnupd
IF FOUND()
   DO WHILE vnupd=nupd .AND. !EOF()
      Tri->item:=STRZERO(++i,2) // Numero sequencial do item.
      Tri->data:=vdata          // Data da transferencia.
      SKIP
   ENDDO
ENDIF
SELECT Tra
RETURN
********************************************************************************
PROCEDURE Constra(tipo)
// Consulta das Transferˆncias na Tela
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
IF FILE("SAOTRA.DBF")
   // Transferˆncias
   SELECT 2
   USE SAOTRA ALIAS Tra
   IF !FILE("SAOTRA1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRA1,SAOTRA2
ELSE
   Mensagem("Arquivo das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTRI.DBF")
   // Itens das Transferˆncias
   SELECT 3
   USE SAOTRI ALIAS Tri
   IF !FILE("SAOTRI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRI1
ELSE
   Mensagem("Arquivo dos Itens das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Tra
IF tipo=1
   vtit:="Transferencias do Deposito para a Loja"
   SET FILTER TO Tra->ttipo="1"
ELSEIF tipo=2
   vtit:="Transferencias da Loja para o Deposito"
   SET FILTER TO Tra->ttipo="2"
ENDIF
GO TOP
// Inicializa as vari veis auxiliares.
vli:=10
vnupd  :=SPACE(5)
vdata  :=CTOD(SPACE(8))
vvalor :=0
vopera :=SPACE(6)
vdesc  :=SPACE(50)
// Constru‡„o da Tela de Apresenta‡„o.
Sinal("TRANSFERENCIAS","CONSULTAS")
Abrejan(2)
// Declara os vetores de consulta.
PRIVATE vdado[4],vmask[4],vcabe[4]
// Dados a serem apresentados.
vdado[01]:="nupd"
vdado[02]:="data"
vdado[03]:="opera"
vdado[04]:="valor"
// Cabe‡alhos das colunas.
vcabe[01]:="Transf."
vcabe[02]:="Data"
vcabe[03]:="Opera‡„o"
vcabe[04]:="Valor"
// M scaras de apresenta‡„o.
vmask[01]:="99999"
vmask[03]:="@R 9.99.999"
vmask[04]:="@E 999,999,999.99"
// Linha de orienta‡„o ao usu rio.
SETCOLOR(vcr)
@ 23,02 SAY PADC("F1 Help  F5 N£mero  F9 Data  [PgUp] [PgDn]  [Enter]  [Esc]",76)
SETCOLOR(vcn)
// Executa a fun‡„o DBEDIT().
DBEDIT(03,01,22,78,vdado,"Fxtr",vmask,vcabe,"Ä","³")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fxtr(modo)
// Fun‡ao para Consulta `as Transferˆncias atrav‚s da DBEDIT()
********************************************************************************
IF modo=4
   IF LASTKEY()=K_ENTER
      // Foi pressionada a tecla <Enter>: apresenta‡„o dos itens da transferˆncia.
      vtela:=SAVESCREEN(01,00,24,79) // Salva a tela de consulta.
      SETCOLOR(vcn)
      Abrejan(2)  // Abre a janela de dados.
      vnupd:=nupd
      Transfere() // Transfere os dados do arquivo para as vari veis auxiliares.
      Tela()      // Apresenta a tela da transferˆncia.
      SELECT Tri
      SEEK vnupd  // Pesquisa os itens da transferˆncia.
      IF !FOUND()
         // Itens n„o encontrados.
         SETCOLOR(vca)
         Aviso(13,"Esta Transferˆncia N„o possui Itens !")
         SETCOLOR(vcn)
         INKEY(5)  // Aguarda 5 segundos.
      ELSE
         // Apresenta os itens da transferˆncia.
         DO WHILE .T.
            i:=08
            DO WHILE i<23 .AND. nupd=vnupd .AND. !EOF()
               @ i  ,  4  SAY  Tri->codpro PICTURE "@R 9.99.999"
               SELECT Prod
               SEEK Tri->codpro
               SELECT Tri
               @ i  , 13  SAY  LEFT(Prod->nome,40)
               @ i  , 54  SAY  Tri->quant PICTURE "@E 999,999.99"
               @ i  , 65  SAY  Tri->preun PICTURE "@E 999,999,999.99"
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
                  IF Tri->nupd#vnupd .OR. BOF()
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
                  SELECT Tra
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
      SELECT Tra
      SETCOLOR(vcn)
      RETURN(1)
   ELSEIF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      // Pressionada a tecla <F5>: pesquisa pelo n£mero da transferˆncia.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 1
      // Solicita o n£mero da transferˆncia desejado.
      vcd:=SPACE(5)
      @ 24,27 SAY "Transferˆncia Desejada: " GET vcd PICTURE "99999"
      Le()
      // Retorna se o n£mero da transferˆncia estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      vcd:=Zeracod(vcd)
      // Pesquisa o n£mero da transferˆncia solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vcd)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Transferˆncia N„o Encontrada !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando o transferˆncia solicitada.
      RETURN(2)
   ELSEIF LASTKEY()=K_F9
      // Pressionada a tecla <F9>: pesquisa pela data da transferˆncia.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 2
      // Solicita a data da transferˆncia desejado.
      vcd:=CTOD(SPACE(8))
      @ 24,27 SAY "Data Desejada: " GET vcd
      Le()
      // Retorna se o n£mero da transferˆncia estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa a data da transferˆncia solicitada.
      SET SOFTSEEK ON
      SEEK vcd
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrada !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando o transferˆncia solicitada.
      RETURN(2)
   ELSE
      /* Apresenta mensagens de aux¡lio ao usu rio se uma tecla impr¢pria for
         pressionada.*/
      vtela:=SAVESCREEN(01,00,24,79)
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
      @ 17,12 SAY "[Enter] - Mostra os Itens da Transferˆncia"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[F5]    - Pesquisa pelo N£mero da Transferˆncia"
      @ 20,12 SAY "[F9]    - Pesquisa pela Data da Transferˆncia"
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
PROCEDURE Reltra1(tipo)
/*
Objetivo : emite os relat¢rios das transferˆncias.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("TRANSFERENCIAS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOTRA.DBF")
   // transferˆncias
   SELECT 1
   USE SAOTRA ALIAS Tra
   IF !FILE("SAOTRA2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRA2
ELSE
   Mensagem("Arquivo das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Tra
IF tipo=1
   vtit:="Transferencias do Deposito para a Loja"
   SET FILTER TO Tra->ttipo="1"
ELSEIF tipo=2
   vtit:="Transferencias da Loja para o Deposito"
   SET FILTER TO Tra->ttipo="2"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas transferˆncias devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio Sint‚tico das Transferˆncias")
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
DO WHILE !EOF() .AND. Tra->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio de "+vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,02 SAY "NUM.        D E S C R I C A O                             DATA        TOTAL"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Tra->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Tra->data>=vdati .AND. Tra->data<=vdatf
         @ PROW()+1,01 SAY Tra->nupd
         @ PROW(),  07 SAY Tra->desc
         @ PROW(),  58 SAY Tra->data
         @ PROW(),  67 SAY Tra->valor PICTURE "@E 99,999,999.99"
         vtot+=Tra->valor
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
 NUM.        D E S C R I C A O                             DATA        TOTAL
99999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/99 999,999,999.99
*/
********************************************************************************
PROCEDURE Reltra2(tipo)
/*
Objetivo : emite os relat¢rios das transferencias.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("TRANSFERENCIAS","RELATORIO")
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
IF FILE("SAOTRA.DBF")
   // Transferencias
   SELECT 2
   USE SAOTRA ALIAS Tra
   IF !FILE("SAOTRA2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRA2
ELSE
   Mensagem("Arquivo das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTRI.DBF")
   // Itens das transferˆncias
   SELECT 3
   USE SAOTRI ALIAS Tri
   IF !FILE("SAOTRI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOTRI1
ELSE
   Mensagem("Arquivo dos Itens das Transferˆncias N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
SELECT Tra
IF tipo=1
   vtit:="Transferencias do Deposito para a Loja"
   SET FILTER TO Tra->ttipo="1"
ELSEIF tipo=2
   vtit:="Transferencias da Loja para o Deposito"
   SET FILTER TO Tra->ttipo="2"
ELSE
   vtit:="Transferencias"
ENDIF
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujos pedidos devem ser impressos.
Pesqdat()
IF !Imprime("Relat¢rio Anal¡tico das Transferˆncias")
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
DO WHILE !EOF() .AND. Tra->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio das "+vtit,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Tra->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      IF Tra->data<vdati .OR. Tra->data>vdatf
         SKIP
         LOOP
      ENDIF
      // Impress„o dos dados.
      @ PROW()+2, 2 SAY "Pedido No: "+Tra->nupd
      @ PROW(),  42 SAY "Data: "+DTOC(Tra->data)
      @ PROW(),  54 SAY "Valor:"+TRANSFORM(Tra->valor,"@E 999,999,999.99")
      @ PROW()+1, 2 SAY "Oper: "+TRANSFORM(Tra->opera,"@R 9.99.999")
      @ PROW(),  17 SAY "Descricao: "+Tra->desc
      SELECT Tri
      IF pv
         vtot+=Tra->valor
         SEEK Tri->nupd
         pv=.F.
      ENDIF
      IF Tri->nupd=Tri->nupd
         @ PROW()+1,01 SAY "-- Codigo ------ Nome do Produto ------------------- Quantidade - Custo Unit.-"
         DO WHILE Tra->nupd=Tri->nupd .AND. PROW()<=60 .AND. !EOF() 
            @ PROW()+1,02 SAY Tri->codpro PICTURE "@R 9.99.999"
            @ PROW(),  13 SAY LEFT(Prod->nome,40)
            @ PROW(),  54 SAY TRANSFORM(Tri->quant,"@E 999,999.99")
            @ PROW(),  65 SAY TRANSFORM(Tri->preun,"@E 999,999,999.99")
            SKIP
         ENDDO
      ENDIF
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SELECT Tra
      IF Tri->nupd#Tra->nupd
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
//                        Fim do Programa SAOTRA.PRG
********************************************************************************
