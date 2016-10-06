********************************************************************************
/* Programa.: SAOVEN.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: Processamento das Vendas.                */
********************************************************************************
// Definicoes Globais
// Arquivos-cabe‡alho
#include "INKEY.CH"
********************************************************************************
PROCEDURE Matven(modo)
/* Manuten‡„o das vendas  - 1- Inclus„o
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
   vord: n£mero de itens da venda
   vok:  existˆncia da venda
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
   SET INDEX TO SAOVEN1,SAOVEN2,SAOVEN3
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
IF FILE("SAOTPG.DBF")
   SELECT 6
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
   Sinal("VENDAS","INCLUSŽO")
ELSEIF modo=2
   Sinal("VENDAS","ALTERA€ŽO")
ELSEIF modo=3
   Sinal("VENDAS","EXCLUSŽO")
ENDIF
// Abre a janela de dados.
Abrejan(2)
SELECT Ven
DO WHILE .T.
   // Inicializa as vari veis auxiliares para edi‡„o dos dados.
   vnupd:=SPACE(5)
   vdata  :=CTOD(SPACE(8))
   vcodcli:=SPACE(5)
   vcli   :=SPACE(40)
   vpdcli :=SPACE(15)
   vopera :=SPACE(6)
   vtipg  :=SPACE(3)
   vcodrep:=SPACE(3)
   vrep:=SPACE(35)
   vvalor:=vvcomi:=vvencf:=vvdesc:=vicms:=0
   // Valor Padrao da Al¡quota do ICMS.
   vpicms:=18.00
   vok:=.F.
   // Apresenta os dados das vendas na tela.
   Tela()
   DO WHILE .T.
      // Solicita o n£mero da venda a ser editado.
      vnupd:=SPACE(5)
      @  3,22 GET vnupd  PICTURE "99999"
      Aviso(24,"Digite o N§ da Venda ou tecle [Esc] para Finalizar")
      Le()
      /* Finaliza se for pressionada a tecla <Esc> ou se o n£mero da venda
         estiver em branco.*/
      IF LASTKEY()=K_ESC .OR. EMPTY(vnupd)
         CLOSE DATABASE
         RETURN
      ENDIF
      vnupd:=PADL(ALLTRIM(vnupd),LEN(vnupd),"0")
      // Pesquisa a venda no arquivo.
      SELECT Ven
      SEEK vnupd
      IF FOUND()
         // Se foi encontrado a vari vel vok torna-se verdadeira.
         vok:=.T.
      ELSE
         IF modo=2 .OR. modo=3
            // Se n„o foi encontrado retorna se for altera‡„o ou exclus„o.
            Mensagem("Desculpe, Venda N„o Encontrada !",6,1)
            LOOP
         ENDIF 
      ENDIF
      EXIT
   ENDDO
   // Inicializa os vetores dos itens das vendas.
   AFILL(mcod,SPACE(6));AFILL(mqtd,0);AFILL(mpre,0)
   // Inicializa as vari veis de controle da tela.
   li:=lf:=1;vt:=0;vord:=0
   /* Se a venda tiver sido encontrado, transfere os dados dos arquivos para
      as vari veis auxiliares de edi‡„o.*/
   IF vok
      @ 24,00 CLEAR
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      // Transfere os dados das vendas para as vari veis auxiliares.
      Transfere()
      SELECT Cli
      SEEK vcodcli
      vcli:=Cli->nome
      SELECT Rep
      SEEK vcodrep
      vrep:=LEFT(Rep->nome,35)
      Rep->comi:=IF(Rep->comi-vvcomi>0,Rep->comi-vvcomi,0)
      k:=1
      vvalor:=0
      // Transferˆncia dos dados dos itens das vendas para os vetores.
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
         // Define o n£mero total de itens da venda.
         vord:=k-1
      ENDIF
      // Define a £ltima linha de edi‡„o dos itens da venda (lf).
      IF vord>=(22-vli)
         lf:=(22-vli)
      ELSE
         lf:=k
      ENDIF
      @ 24,00 CLEAR
      // Calcula o valor do ICMS e da Comiss„o do Vendedor.
      vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
      vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
      // Apresenta os dados da venda na tela.
      Tela()
      // Apresenta os dados dos itens da venda na tela.
      Mostra(1,vord,vcn)
   ENDIF
   // Se a opera‡„o for exclus„o de vendas.
   IF modo=3
      // Solicita confirma‡„o da exclus„o da venda apresentado.
      IF Exclui()
         // Deleta os itens da venda.
         SELECT Vei
         SEEK vnupd
         DO WHILE nupd=vnupd .AND. !EOF()
            SELECT Prod
            SEEK Vei->codpro
            SELECT Vei
            // Atualiza o saldo de vendas no arquivo dos Produtos.
            Prod->saldo:=Prod->saldo+Vei->quant
            // Deleta os itens da venda.
            DELETE
            SKIP
         ENDDO
         // Deleta a venda.
         SELECT Ven
         DELETE
      ENDIF
      // Limpa a tela.
      @ 24,00 CLEAR
      FOR i=22 TO vli+1 STEP -1
          @ i,01 SAY SPACE(78)
      NEXT
      SELECT Ven
      // Retorna para realizar outra exclus„o.
      LOOP
   ENDIF
   // Se for inclus„o ou altera‡„o de vendas.
   DO WHILE .T.
      // Edita os dados da venda enquanto n„o houver confirma‡„o.
      Edita()
      IF Confirme()
         // Finaliza se a edi‡„o for confirmada.
         EXIT
      ENDIF
   ENDDO
   // Inclui uma nova venda se for inclus„o e o mesmo ainda n„o existir.
   SELECT Ven
   IF modo=1 .AND. !vok
      APPEND BLANK
      Ven->nupd:=vnupd
   ENDIF
   // Atualiza a venda, gravando as vari veis auxiares no registro do arquivo.
   Atualiza()
   // Edi‡„o dos itens da venda.
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
         IF vcod#mcod[li+vt] .AND. !EMPTY(mcod[li+vt])
            // Houve mudan‡a, mudap torna-se verdadeira.
            mudap=.T.
         ENDIF
         // Reapresenta o c¢digo na tela.
         @ vli+li,04 SAY vcod PICTURE "@R 9.99.999"
         /* Se houve mudan‡a de produto, verifica se o mesmo j  n„o foi
            inclu¡do na venda, num dos outros itens j  cadastrados.*/
         // Verifica que o produto j  est  cadastrado nos itens.
         n:=ASCAN(mcod,vcod)
         IF n#0 .AND. n#(li+vt)
            Mensagem("Desculpe, Produto j  Presente Nesta Venda !",6,1)
            IF !EMPTY(mcod[li+vt])
               @ vli+li,04 SAY mcod[li+vt] PICTURE "@R 9.99.999"
            ELSE
               @ vli+li,03 SAY SPACE(76)
            ENDIF
            // Retorna se j  estiver cadastrado na venda.
            LOOP
         ENDIF
         // Apresenta o nome e o pre‡o do produto na tela.
         @ vli+li, 13 SAY LEFT(Prod->nome,40)
         vpre:=IF(vpre#0,vpre,Prod->precr)
         @ vli+li,65 SAY vpre PICTURE "999,999,999.99"
         // Solicita a quantidade.
         @ vli+li, 54 GET vqtd PICTURE "999,999.99" VALID(vqtd>0)
         Aviso(24,"Digite a Quantidade em "+TRIM(Prod->unid))
         Le()
         @ vli+li,54 SAY vqtd PICTURE "@E 999,999.99"
         // Solicita o pre‡o unit rio.
         vpre:=IF(vpre#0,vpre,Prod->precr)
         @ vli+li,65 GET vpre PICTURE "999,999,999.99"
         Aviso(24,"Digite o Pre‡o Unit rio, com ICMS")
         Le()
         @ vli+li,65 SAY vpre PICTURE "@E 999,999,999.99"
         // Atualiza o arquivo dos Produtos.
         SELECT Prod
         SEEK vcod
         IF mudap     // Houve mudan‡a de produto.
            IF Prod->saldo<vqtd
               Mensagem("Saldo Insuficiente para esta Venda!",8,1)
               Mostra(li,li,vca)
               LOOP
            ELSE
               Prod->saldo:=Prod->saldo-vqtd;Prod->datus:=vdata
            ENDIF
            // Atualiza o produto anterior.
            SEEK mcod[li+vt]
            Prod->saldo:=Prod->saldo+mqtd[li+vt]
            // Atualiza os itens da venda.
            SELECT Vei
            SEEK vnupd+mcod[li+vt]
            Vei->codpro:=vcod
         ELSE         // N„o houve mudan‡a de produto.
            IF Prod->saldo+mqtd[li+vt]<vqtd
               Mensagem("Saldo Insuficiente para esta Venda!",8,1)
               Mostra(li,li,vca)
               LOOP
            ELSE
               Prod->saldo:=Prod->saldo+mqtd[li+vt]-vqtd;Prod->datus:=vdata
            ENDIF
            // Atualiza os itens da venda.
            SELECT Vei
            SEEK vnupd+vcod
            IF !FOUND()
               // Se o item ainda n„o existir na venda, inclui um novo.
               ++vord  // Aumenta o n£mero de itens da venda.
               APPEND BLANK
               Vei->nupd:=vnupd;Vei->codpro:=vcod;Vei->item:=STRZERO(vord,2)
            ENDIF
         ENDIF
         // Atualiza os dados do item.
         SELECT Vei
         SEEK vnupd+vcod
         Vei->quant:=vqtd;Vei->preco:=vpre*vqtd;Vei->preun:=vpre;Vei->custo:=Prod->custr
         Vei->codcli:=vcodcli;Vei->data:=vdata;Vei->preul:=preun //*(1-vpicms/100)
         // Atualiza o valor da venda, o ICMS e a comiss„o.
         vvalor:=vvalor-mpre[li+vt]*mqtd[li+vt]+vpre*vqtd
         vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
         vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
         // Reapresenta o valor total da venda e o icms.
         SETCOLOR(vcr)
         @  3,63 SAY vvalor+vvencf-vvdesc PICTURE "@E 999,999,999.99"
         @  9,67 SAY vvcomi               PICTURE "@E 999,999.99"
         @ 11,63 SAY vicms                PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o vetor dos itens da venda.
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
         SELECT Vei
         // Pesquisa o item no arquivo.
         SEEK vnupd+mcod[li+vt]
         IF FOUND()
            // Atualiza o arquivo dos Produtos.
            SELECT Prod
            SEEK mcod[li+vt]
            Prod->saldo:=Prod->saldo+mqtd[li+vt]
         ENDIF
         SELECT Vei
         // Deleta o item da venda.
         DELETE
         // Diminui a quantidade de itens da venda.
         --vord
         // Atualiza o valor da venda, o ICMS e a comiss„o do vendedor.
         vvalor:=vvalor-mpre[li+vt]*mqtd[li+vt]
         vicms :=(vvalor-vvdesc+vvencf)*(vpicms/100)
         vvcomi:=(vvalor-vvdesc)*Rep->pctc/100
         // Reapresenta o valor total da venda, do ICMS e da Comiss„o.
         SETCOLOR(vcr)
         @  3,63 SAY vvalor+vvencf-vvdesc PICTURE "@E 999,999,999.99"
         @  9,67 SAY vvcomi               PICTURE "@E 999,999.99"
         @ 11,63 SAY vicms                PICTURE "@E 999,999,999.99"
         SETCOLOR(vcn)
         // Atualiza o n£mero dos itens da venda.
         REPLACE Vei->item WITH STR(VAL(item)-1,2) WHILE vnupd=Vei->nupd
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
         // Reapresenta os itens da venda, eliminando o que foi deletado.
         Mostra(1,(22-vli),vcn)
      ELSEIF tk=K_ESC
         // Foi pressionada a tecla <Esc>: finaliza a edi‡„o dos itens.
         IF Confirme()
            // Se confirmado, atualiza os dados da venda.
            SELECT Ven
            Atualiza()
            // Atualiza os itens da venda.
            Atualitem()
            // Atualiza a comissao do vendedor.
            Rep->comi:=Rep->comi+vvcomi
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
   SELECT Ven
ENDDO
CLOSE DATABASE
RETURN
********************************************************************************
STATIC PROCEDURE Tela()
// Apresenta os dados das vendas na tela.
********************************************************************************
SETCOLOR(vcn)
@  3, 4 SAY "N£mero do Pedido: "
@  3,29 SAY "Data: "
@  3,47 SAY "Valor da Venda: "
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
@  3,22 SAY vnupd       PICTURE "99999"
@  3,35 SAY vdata
@  3,63 SAY vvalor+vvencf-vvdesc PICTURE "@E 999,999,999.99"
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
// Edita os dados da venda na tela.
********************************************************************************
SETCOLOR(vcr)
@  3,22 SAY vnupd       PICTURE "99999"
SETCOLOR(vcn)
@  3,35 GET vdata VALID !EMPTY(vdata)
SETCOLOR(vcr)
@  3,63 SAY vvalor+vvencf-vvdesc PICTURE "@E 999,999,999.99"
SETCOLOR(vcn)
@  5,20 GET vcodcli     PICTURE "99999"
Le()
vcodcli:=Acha(vcodcli,"Cli",1,2,"codi","nome","99999","@!",15,05,22,76)
vCli:=Cli->nome
SETCOLOR(vcr)
@  5,20 SAY vcodcli     PICTURE "99999"
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
@  7,74 SAY vtipg       PICTURE "!!!"
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
// Apresenta os itens das vendas na tela.
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
SELECT Ven
RETURN
********************************************************************************
STATIC PROCEDURE Transfere()
// Transfere os dados do arquivo para as vari veis auxiliares.
********************************************************************************
vdata  :=Ven->data
vvalor :=Ven->valor
vvcomi :=Ven->vcomi
vcodcli:=Ven->codcli
vcli   :=Ven->cli
vpdcli :=Ven->pdcli
vopera :=Ven->opera
vtipg  :=Ven->tipg
vcodrep:=Ven->codrep
vvencf :=Ven->vencf
vvdesc :=Ven->vdesc
vicms  :=Ven->icms
RETURN
********************************************************************************
STATIC PROCEDURE Atualiza()
// Atualiza os dados do arquivo com as vari veis auxiliares.
********************************************************************************
Ven->data  :=vdata
Ven->valor :=vvalor
Ven->vcomi :=vvcomi
Ven->codcli:=vcodcli
Ven->cli   :=vcli
Ven->pdcli :=vpdcli
Ven->opera :=vopera
Ven->tipg  :=vtipg
Ven->codrep:=vcodrep
Ven->vencf :=vvencf
Ven->vdesc :=vvdesc
Ven->icms  :=vicms
RETURN
********************************************************************************
STATIC PROCEDURE Atualitem()
// Atualiza os dados dos itens com as vari veis auxiliares.
********************************************************************************
SELECT Vei
SEEK vnupd
IF FOUND()
   DO WHILE vnupd=nupd .AND. !EOF()
      Vei->item:=STRZERO(++i,2) // Numero sequencial do item.
      Vei->data:=vdata          // Data da venda.
      Vei->codcli:=vcodcli      // Codigo do cliente.
      SKIP
   ENDDO
ENDIF
SELECT Ven
RETURN
********************************************************************************
PROCEDURE Consven()
// Consulta das vendas na Tela
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
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 2
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN1,SAOVEN2,SAOVEN3
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEI.DBF")
   // Itens das vendas
   SELECT 3
   USE SAOVEI ALIAS Vei
   IF !FILE("SAOVEI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEI1
ELSE
   Mensagem("Arquivo dos Itens das Vendas N„o Encontrado no Disco !",8,1)
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
SELECT Ven
// Inicializa as vari veis auxiliares.
vli:=12
vnupd  :=SPACE(5)
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
Sinal("VENDAS","CONSULTAS")
Abrejan(2)
// Declara os vetores de consulta.
PRIVATE vdado[12],vmask[12],vcabe[12]
// Dados a serem apresentados.
vdado[01]:="nupd"
vdado[02]:="data"
vdado[03]:="opera"
vdado[04]:="valor+vencf-vdesc"
vdado[05]:="LEFT(cli,38)"
vdado[06]:="pdcli"
vdado[07]:="tipg"
vdado[08]:="vencf"
vdado[09]:="vdesc"
vdado[10]:="icms"
vdado[11]:="codrep"
vdado[12]:="vcomi"
// Cabe‡alhos das colunas.
vcabe[01]:="Venda"
vcabe[02]:="Data"
vcabe[03]:="Opera‡„o"
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
vmask[01]:="99999"
vmask[03]:="@R 9.99.999"
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
DBEDIT(03,01,22,78,vdado,"Fxve",vmask,vcabe,"Ä","³")
CLOSE DATABASE
RETURN
********************************************************************************
FUNCTION Fxve(modo)
// Fun‡ao para Consulta aos vendas atrav‚s da DBEDIT()
********************************************************************************
IF modo=4
   IF LASTKEY()=K_ENTER
      // Foi pressionada a tecla <Enter>: apresenta‡„o dos itens da venda.
      vtela:=SAVESCREEN(01,00,24,79) // Salva a tela de consulta.
      SETCOLOR(vcn)
      Abrejan(2)  // Abre a janela de dados.
      vnupd:=nupd
      Transfere() // Transfere os dados do arquivo para as vari veis auxiliares.
      SELECT Rep
      SEEK vcodrep
      IF FOUND()
         vrep:=LEFT(Rep->nome,35)
      ELSE
         vrep:=SPACE(35)
      ENDIF
      Tela()      // Apresenta a tela da venda.
      SELECT Vei
      SEEK vnupd  // Pesquisa os itens da venda.
      IF !FOUND()
         // Itens n„o encontrados.
         SETCOLOR(vca)
         Aviso(16,"Esta Venda N„o possui Itens !")
         SETCOLOR(vcn)
         INKEY(5)  // Aguarda 5 segundos.
      ELSE
         // Apresenta os itens da venda.
         DO WHILE .T.
            i:=13
            DO WHILE i<23 .AND. nupd=vnupd .AND. !EOF()
               @ i  ,  4  SAY  Vei->codpro PICTURE "@R 9.99.999"
               SELECT Prod
               SEEK Vei->codpro
               SELECT Vei
               @ i  , 13  SAY  LEFT(Prod->nome,40)
               @ i  , 54  SAY  Vei->quant PICTURE "@E 999,999.99"
               @ i  , 65  SAY  Vei->preun PICTURE "@E 999,999,999.99"
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
                  IF Vei->nupd#vnupd .OR. BOF()
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
                  SELECT Ven
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
      SELECT Ven
      SETCOLOR(vcn)
      RETURN(1)
   ELSEIF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSEIF LASTKEY()=K_F5
      // Pressionada a tecla <F5>: pesquisa pelo n£mero da venda.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 1
      // Solicita o n£mero da venda desejado.
      vcd:=SPACE(5)
      @ 24,27 SAY "Venda Desejada: " GET vcd PICTURE "99999"
      Le()
      vcd:=Zeracod(vcd)
      // Retorna se o n£mero da venda estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa o n£mero da venda solicitado.
      SET SOFTSEEK ON
      SEEK TRIM(vcd)
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Venda N„o Encontrado !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando a venda solicitado.
      RETURN(2)
   ELSEIF LASTKEY()=K_F6
      // Pressionada a tecla <F6>: pesquisa pelo nome do fornecedor.
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
      // Pressionada a tecla <F9>: pesquisa pela data da venda.
      rec:=RECNO()  // armazena o n£mero do registro atual.
      @ 24,00 CLEAR
      SET ORDER TO 3
      // Solicita a data da venda desejada.
      vcd:=CTOD(SPACE(8))
      @ 24,27 SAY "Data Desejada: " GET vcd
      Le()
      // Retorna se a data da venda estiver em branco.
      IF EMPTY(vcd)
         RETURN(1)
      ENDIF
      // Pesquisa a data da venda solicitada.
      SET SOFTSEEK ON
      SEEK vcd
      SET SOFTSEEK OFF
      // Retorna se n„o for encontrado.
      IF EOF()
         Mensagem("Desculpe, Data N„o Encontrada !",6,1)
         GO rec
         RETURN(1)
      ENDIF
      // Reapresenta a tela de consulta, mostrando a venda solicitado.
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
      @ 17,12 SAY "[Enter] - Mostra os Itens da Venda"
      @ 18,12 SAY "[Esc]   - Finaliza a Consulta"
      @ 19,12 SAY "[F5]    - Pesquisa pelo N£mero da Venda"
      @ 20,12 SAY "[F6]    - Pesquisa pelo Nome do Cliente"
      @ 21,12 SAY "[F9]    - Pesquisa pela Data da Venda"
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
PROCEDURE Relven1()
/*
Objetivo : emite os relat¢rios das vendas.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("VENDAS","RELATORIO")
// Abertura dos arquivos de dados
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 1
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN3
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ven
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
// Pesquisa a faixa de Pedidos a serem impressos.
Pesqint(5,"99999","Pedidos")
IF !Imprime("Relat¢rio Sint‚tico das Vendas")
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
DO WHILE !EOF() .AND. Ven->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Sintetico das Vendas","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,03 SAY "Nro.     DATA                  CLIENTE                        VALOR TOTAL"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Ven->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Ven->data>=vdati .AND. Ven->data<=vdatf .AND. Ven->nupd>=vcodi .AND. Ven->nupd<=vcodf
         @ PROW()+1,02 SAY Ven->nupd
         @ PROW(),  09 SAY Ven->data
         @ PROW(),  19 SAY Ven->cli
         @ PROW(),  61 SAY Ven->valor+Ven->vencf-Ven->vdesc PICTURE "@E 999,999,999.99"
         vtot+=(Ven->valor+Ven->vencf-Ven->vdesc)
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
  Nro.     Data                  Cliente                        Valor Total         
 99999  99/99/99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99  
*/
********************************************************************************
PROCEDURE Relven2()
/*
Objetivo : emite os relat¢rios das vendas.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("VENDAS","RELATORIO")
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
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 2
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN3.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN3
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEI.DBF")
   // Itens das Vendas
   SELECT 3
   USE SAOVEI ALIAS Vei
   IF !FILE("SAOVEI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEI1
ELSE
   Mensagem("Arquivo dos Itens das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SET RELATION TO codpro INTO Prod
SELECT Ven
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
// Pesquisa a faixa de Pedidos a serem impressos.
Pesqint(5,"99999","Pedidos")
IF !Imprime("Relat¢rio Anal¡tico das Vendas")
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
DO WHILE !EOF() .AND. Ven->data<=vdatf
   // Impressao do cabe‡alho.
   Cabe(emp[2],vsist,"Relatorio Analitico das Vendas","Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. Ven->data<=vdatf
      // A fun‡ao Escprint() (SAOBIB.PRG) permite cancelar a impressao.
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress„o dos dados.
      IF Ven->data<vdati .OR. Ven->data>vdatf .OR. Ven->nupd<vcodi .OR. Ven->nupd>vcodf
         SKIP
         LOOP
      ENDIF
      @ PROW()+2, 4 SAY "Numero do Pedido: "+Ven->nupd
      @ PROW(),  29 SAY "Data: "+DTOC(Ven->data)
      @ PROW(),  46 SAY "Valor da Venda:"+TRANSFORM(Ven->valor,"@E 999,999,999.99")
      @ PROW()+1, 4 SAY "Cliente: "+Ven->codcli+" - "+Ven->cli
      @ PROW()+1, 4 SAY "Pedido Cliente: "+Ven->pdcli
      @ PROW(),  37 SAY "Nat.Oper.: "+Ven->opera
      @ PROW(),  55 SAY "Tipo de Pagamento: "+Ven->tipg
      @ PROW()+1, 4 SAY "Vendedor: "+Ven->codrep
      @ PROW(),  56 SAY "Comissao: "+TRANSFORM(Ven->vcomi,"@E 999,999.99")
      @ PROW()+1, 4 SAY "Encargos:"+TRANSFORM(Ven->vencf,"@E 999,999,999.99")
      @ PROW(),  29 SAY "Desconto:"+TRANSFORM(Ven->vdesc,"@E 999,999,999.99")
      @ PROW(),  56 SAY "ICMS:"+TRANSFORM(Ven->icms,"@E 999,999,999.99")
      SELECT Vei
      IF pv
         SEEK Ven->nupd
         pv=.F.
      ENDIF
      IF Ven->nupd=Vei->nupd
         @ PROW()+1,01 SAY "-- Codigo ------ Nome do Produto ------------------- Quantidade - Preco Unit.-"
         DO WHILE Ven->nupd=Vei->nupd .AND. PROW()<=60 .AND. !EOF() 
            @ PROW()+1,02 SAY Vei->codpro PICTURE "@R 9.99.999"
            @ PROW(),  13 SAY LEFT(Prod->nome,40)
            @ PROW(),  54 SAY TRANSFORM(Vei->quant,"@E 999,999.99")
            @ PROW(),  65 SAY TRANSFORM(Vei->preun,"@E 999,999,999.99")
            SKIP
         ENDDO
      ENDIF
      @ PROW()+1,00 SAY REPLICATE("-",80)
      SELECT Ven
      IF Vei->nupd#Ven->nupd
         vtot+=(Ven->valor+Ven->vencf+Ven->icms-Ven->vdesc)
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
PROCEDURE Relvenpro(tipo)
/* Relatorio de Vendas por Produto
   Parametros: tipo 1- Analitico
                    2- Sintetico*/
********************************************************************************
// Atualiza a linha de status no topo da tela.
Sinal("VENDAS","RELATORIO")
PRIVATE vtot[6]
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
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 2
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN1
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEI.DBF")
   // Itens das Vendas
   SELECT 3
   USE SAOVEI ALIAS Vei
ELSE
   Mensagem("Arquivo dos Itens das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Vei
Abrejan(2)
SETCOLOR(vcp)
Aviso(12,"Aguarde... Reorganizando o Arquivo de Vendas por Produto !")
SETCOLOR(vcn)
INDEX ON codpro TO Temp
@ 12,01 SAY SPACE(78)
vcodi:=vcodf:=SPACE(6)
Pesqint(6,"@R 9.99.999","C¢digos dos Produtos")
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio de Vendas por Produto")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0            // Vari vel pg: armazena o numero das paginas.
AFILL(vtot,0.00) // Totalizadores.
SET DEVICE TO PRINT
pv:=.T.
SELECT Vei
SET RELATION TO nupd INTO Ven
SET SOFTSEEK ON
SEEK vcodi
SET SOFTSEEK OFF
DO WHILE Vei->codpro<=vcodf .AND. !EOF()
   SELECT Vei
   IF tipo=1
      Cabe(emp[2],vsist,"Relatorio Analitico de Vendas por Produto","Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
      @ PROW()+1,01 SAY "Pedido   Data         Cliente        Ven. Ped.Cli. Pagto        Preco      Qtd."
   ELSE
      Cabe(emp[2],vsist,"Relatorio Sintetico de Vendas por Produto","Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
      @ PROW()+1,01 SAY "Codigo                  P r o d u t o                           Preco      Qtd."
   ENDIF
   @ PROW()+1,00 SAY REPLICATE("-",80)
   vgrupo:=LEFT(Vei->codpro,3)
   DO WHILE Vei->codpro<=vcodf .AND. vgrupo=LEFT(Vei->codpro,3) .AND. !EOF() .AND. PROW()<=60
      vcodpro:=Vei->codpro
      SELECT Prod
      SEEK vcodpro
      IF tipo=1
         @ PROW()+1,05 SAY vcia20+vcia05+TRANSFORM(vcodpro,"@R 9.99.999")+" - "+TRIM(nome)+vcid05+vcia10
         @ PROW()+1,00 SAY REPLICATE("-",80)
      ENDIF
      SELECT Vei
      DO WHILE PROW()<=60 .AND. codpro=vcodpro .AND. !EOF()
         IF Escprint(80)
            CLOSE DATABASE
            RETURN
         ENDIF
         IF Vei->data>=vdati .AND. Vei->data<=vdatf
            IF tipo=1
               @  PROW()+1,1  SAY Vei->nupd
               @  PROW(), 08  SAY Vei->data
               @  PROW(), 17  SAY LEFT(Ven->cli ,20)
               @  PROW(), 38  SAY Ven->codrep
               @  PROW(), 42  SAY LEFT(Ven->pdcli,10)
               @  PROW(), 53  SAY Ven->tipg
               @  PROW(), 58  SAY Vei->preun PICTURE "@E 99,999,999.99"
               @  PROW(), 72  SAY Vei->quant PICTURE "@E 9,999.99"
            ENDIF
            // Total por produto.
            vtot[1]+=Vei->quant
            vtot[2]+=(Vei->quant*Vei->preun)
            // Total por grupo.
            vtot[3]+=Vei->quant
            vtot[4]+=(Vei->quant*Vei->preun)
            // Total geral.
            vtot[5]+=Vei->quant
            vtot[6]+=(Vei->quant*Vei->preun)
         ENDIF
         SKIP
      ENDDO
      IF vcodpro#Vei->codpro
         IF tipo=1
            @  PROW()+1,35 SAY "Total do Produto ->"
            @  PROW(), 58  SAY vtot[2] PICTURE "@E 99,999,999.99"
            @  PROW(), 72  SAY vtot[1] PICTURE "@E 9,999.99"
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ELSE
            @ PROW()+1,01 SAY TRANSFORM(vcodpro,"@R 9.99.999")+" - "+LEFT(Prod->nome,40)
            @  PROW(), 58  SAY vtot[2] PICTURE "@E 99,999,999.99"
            @  PROW(), 72  SAY vtot[1] PICTURE "@E 9,999.99"
         ENDIF
         vcodpro:=Vei->codpro
         vtot[1]:=vtot[2]:=0
      ENDIF
   ENDDO
   IF vgrupo#LEFT(Vei->codpro,3)
      IF tipo=2
         @ PROW()+1,0 SAY REPLICATE("-",80)
      ENDIF
      @  PROW()+1,35 SAY "Total do Grupo "+TRANSFORM(vgrupo,"@R 9.99")+" ->"
      @  PROW(), 58  SAY vtot[4] PICTURE "@E 99,999,999.99"
      @  PROW(), 72  SAY vtot[3] PICTURE "@E 9,999.99"
      @ PROW()+1,0 SAY REPLICATE("-",80)
      vgrupo:=LEFT(Vei->codpro,3)
      vtot[3]:=vtot[4]:=0
   ENDIF
ENDDO
@ PROW()+1,00 SAY REPLICATE("=",80)
@ PROW()+1,30 SAY "T O T A L   G E R A L  ->"
@ PROW(),  57 SAY vtot[6] PICTURE "@E 999,999,999.99"
@ PROW()+1, 0 SAY REPLICATE("=",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
CLOSE DATABASE
ERASE TEMP.NTX
SET DEVICE TO SCREEN
RETURN
/*
Pedido   Data         Cliente        Ven. Ped.Cli. Pagto        Preco      Qtd.
99999  99/99/99 xxxxxxxxxxxxxxxxxxxx xxx xxxxxxxxxx xxx   99,999,999.99 9,999.99
*/
********************************************************************************
PROCEDURE Relvenven(tipo)
// Relatorio de Vendas por Vendedor.
********************************************************************************
// Atualiza a linha de status no topo da tela
Sinal("VENDAS","RELATORIO")
IF FILE("SAOREP.DBF")
   // Vendedores
   SELECT 1
   USE SAOREP ALIAS Rep
   // Se n„o forem encontrados os arquivos de ¡ndice.
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1,SAOREP2
ELSE
   Mensagem("Arquivo dos Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 2
   USE SAOVEN ALIAS Ven
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ven
Abrejan(2)
SETCOLOR(vcp)
Aviso(12,"Aguarde... Reorganizando o Arquivo !")
SETCOLOR(vcn)
INDEX ON codrep TO TEMP
@ 12,01 SAY SPACE(78)
SELECT Rep
Pesqint(3,"999","Vendedores")
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
muda:=.T.
vpula:=.F.
IF tipo=1
   vtit:="Relatorio Resumido de Vendas por Vendedor"
ELSE
   vtit:="Relatorio Completo de Vendas por Vendedor"
   Aviso(18,"Ejetar p gina ap¢s cada Vendedor ?")
   IF Confirme()
      vpula:=.T.
   ENDIF
ENDIF
IF !Imprime(vtit)
   CLOSE DATABASE
   RETURN
ENDIF
SET DEVICE TO PRINT
vcodrep:=Rep->codi
PRIVATE vtotp[4],vtotg[4]
AFILL(vtotp,0);AFILL(vtotg,0)
pg:=0
DO WHILE Rep->codi<=vcodf .AND. !EOF()
   IF tipo=1
      Cabe(emp[2],vsist,vtit,"Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
      @ PROW()+1,01 SAY "Num.          V e n d e d o r                    Valor Total       Comissao"
      @ PROW()+1,00 SAY REPLICATE("-",80)
   ELSE
      Cabe(emp[2],vsist,vtit,"Periodo de "+DTOC(vdati)+" a "+DTOC(vdatf),132,vcia20)
      @ PROW()+1,01 SAY "Pedido   Data                 Cliente                     Ped.Cli. Pagto.    V a l o r      Encargos      Descontos     Comissao"
      @ PROW()+1,00 SAY REPLICATE("-",132)
   ENDIF
   DO WHILE PROW()<=60 .AND. !EOF() .AND. Rep->codi<=vcodf
      IF tipo=2
         @ PROW()+2,01 SAY vcia05+vcodrep+" - "+TRIM(Rep->nome)+vcid05
         @ PROW()+1,00 SAY ""
      ENDIF
      SELECT Ven
      IF muda
         SEEK vcodrep
         muda:=.F.
      ENDIF
      DO WHILE PROW()<=60 .AND. Ven->codrep=vcodrep .AND. !EOF()
         IF Escprint()
            CLOSE DATABASE
            RETURN
         ENDIF
         IF Ven->data>=vdati .AND. Ven->data<=vdatf
            IF tipo=2
               @  PROW()+1,1  SAY Ven->nupd
               @  PROW(), 08  SAY Ven->data
               @  PROW(), 18  SAY Ven->cli
               @  PROW(), 59  SAY LEFT(Ven->pdcli,10)
               @  PROW(), 69  SAY Ven->tipg
               @  PROW(), 75  SAY Ven->valor PICTURE "@E 999,999,999.99"
               @  PROW(), 90  SAY Ven->vencf PICTURE "@E 999,999,999.99"
               @  PROW(),105  SAY Ven->vdesc PICTURE "@E 999,999,999.99"
               @  PROW(),120  SAY Ven->valor*Rep->pctc/100 PICTURE "@E 9,999,999.99"
            ENDIF
            vtotp[1]+=Ven->valor
            vtotp[2]+=Ven->vencf
            vtotp[3]+=Ven->vdesc
            vtotp[4]+=(Ven->valor*Rep->pctc/100)
            vtotg[1]+=Ven->valor
            vtotg[2]+=Ven->vencf
            vtotg[3]+=Ven->vdesc
            vtotg[4]+=(Ven->valor*Rep->pctc/100)
         ENDIF
         SKIP
      ENDDO
      IF Ven->codrep#vcodrep
         IF vtotp[1]#0.00
            IF tipo=1
               @ PROW()+1,01 SAY Rep->codi
               @ PROW(),  05 SAY LEFT(Rep->nome,41)
               @ PROW(),  47 SAY vtotp[1]+vtotp[2]-vtotp[3] PICTURE "@E 99,999,999,999.99"
               @ PROW(),  65 SAY vtotp[4] PICTURE "@E 999,999,999.99"
            ELSE
               @  PROW()+1,55 SAY "T o t a i s   ->"
               @  PROW(),  75 SAY vtotp[1] PICTURE "@E 999,999,999.99"
               @  PROW(),  90 SAY vtotp[2] PICTURE "@E 999,999,999.99"
               @  PROW(), 105 SAY vtotp[3] PICTURE "@E 999,999,999.99"
               @  PROW(), 120 SAY vtotp[4] PICTURE "@E 9,999,999.99"
            ENDIF
         ENDIF
         IF tipo=2
            @ PROW()+1,0 SAY REPLICATE("-",132)
         ENDIF
         AFILL(vtotp,0)
         muda:=.T.
         SELECT Rep
         SKIP
         vcodrep:=Rep->codi
         IF vpula
            EXIT
         ENDIF
      ENDIF
      SELECT Rep
   ENDDO
ENDDO
IF tipo=1
   @ PROW()+1,00  SAY REPLICATE("=",80)
   @ PROW()+1,05 SAY "T O T A L   G E R A L"
   @ PROW(),  47 SAY vtotg[1]+vtotg[2]-vtotg[3] PICTURE "@E 99,999,999,999.99"
   @ PROW(),  65 SAY vtotg[4] PICTURE "@E 999,999,999.99"
   @ PROW()+1,00  SAY REPLICATE("=",80)
ELSE
   @ PROW()+1,00  SAY REPLICATE("=",132)
   @ PROW()+1,45  SAY "T o t a l    G e r a l   ->"
   @ PROW(),  75  SAY vtotg[1] PICTURE "@E 999,999,999.99"
   @ PROW(),  90  SAY vtotg[2] PICTURE "@E 999,999,999.99"
   @ PROW(), 105  SAY vtotg[3] PICTURE "@E 999,999,999.99"
   @ PROW(), 120  SAY vtotg[4] PICTURE "@E 9,999,999.99"
   @ PROW()+1,00  SAY REPLICATE("=",132)
ENDIF
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
CLOSE DATABASE
ERASE TEMP.NTX
SET DEVICE TO SCREEN
RETURN
/*
Pedido   Data                 Cliente                     Vencito. Pagto.    V a l o r      Encargos      Descontos     Comissao
99999  99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/99  xxx   999,999,999.99 999,999,999.99 999,999,999.99 9,999,999.99

Num.          V e n d e d o r                    Valor Total       Comissao
999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99,999,999,999.99 999,999,999.99
*/
********************************************************************************
PROCEDURE Relvencli()
// Relatorio de Vendas por Cliente.
********************************************************************************
// Atualiza a linha de status no topo da tela
Sinal("VENDAS","RELATORIO")
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 1
   USE SAOVEN ALIAS Ven
   IF !FILE("SAOVEN2.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEN2
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOREP.DBF")
   // Vendedores
   SELECT 2
   USE SAOREP ALIAS Rep
   // Se n„o forem encontrados os arquivos de ¡ndice.
   IF !FILE("SAOREP1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOREP1
ELSE
   Mensagem("Arquivo dos Vendedores N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ven
SET ORDER TO 2
Pesqint(20,"@!","Clientes")
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
Aviso(18,"Ejetar p gina ap¢s cada Cliente ?")
IF Confirme()
   vpula:=.T.
ELSE
   vpula:=.F.
ENDIF
IF !Imprime("Relat¢rio Completo de Vendas por Cliente")
   CLOSE DATABASE
   RETURN
ENDIF
SET DEVICE TO PRINT
muda:=.T.
vcli:=Ven->cli
pg:=vtottv:=vtottc:=vtotv:=vtotc:=0
DO WHILE Ven->cli<=vcodf .AND. !EOF()
   Cabe(emp[2],vsist,"Relatorio Completo de Vendas de "+DTOC(vdati)+" a "+DTOC(vdatf),"Relatorio por Cliente",80,vcia10)
   @ PROW()+1,01 SAY "Pedido   Data    Ped.Cliente     Vend. Pagto.     V a l o r          Comissao"
   @ PROW()+1,00 SAY REPLICATE("-",80)
   DO WHILE PROW()<=60 .AND. !EOF() .AND. Ven->cli<=vcodf
      @ PROW()+2,01 SAY vcia05+Ven->codcli+" - "+TRIM(Ven->cli)+vcid05
      @ PROW()+1,00 SAY ""
      vcli:=Ven->cli
      DO WHILE PROW()<=60 .AND. Ven->cli=vcli .AND. !EOF()
         IF Escprint()
            CLOSE DATABASE
            RETURN
         ENDIF
         IF Ven->data>=vdati .AND. Ven->data<=vdatf
            @  PROW()+1,1  SAY Ven->nupd
            @  PROW(), 08  SAY Ven->data
            @  PROW(), 17  SAY Ven->pdcli
            @  PROW(), 35  SAY Ven->codrep
            @  PROW(), 41  SAY Ven->tipg
            @  PROW(), 49  SAY Ven->valor PICTURE "@E 999,999,999.99"
            @  PROW(), 67  SAY Ven->valor*Rep->pctc/100 PICTURE "@E 99,999,999.99"
            // Totais por cliente.
            vtotv+=Ven->valor
            vtotc+=(Ven->valor*Rep->pctc/100)
            // Totais gerais.
            vtottv+=Ven->valor
            vtottc+=(Ven->valor*Rep->pctc/100)
         ENDIF
         SKIP
      ENDDO
      IF Ven->cli#vcli
         IF vtotv#0.00
            @ PROW()+1,10 SAY "T o t a i s   ->"
            @ PROW(),  49 SAY vtotv PICTURE "@E 999,999,999.99"
            @ PROW(),  67 SAY vtotc PICTURE "@E 99,999,999.99"
         ENDIF
         @ PROW()+1,0 SAY REPLICATE("-",80)
         vtotv:=vtotc:=0.00
         SELECT Ven
         SKIP
         vcli:=Ven->cli
         IF vpula
            EXIT
         ENDIF
      ENDIF
      SELECT Ven
   ENDDO
ENDDO
@ PROW()+1,00 SAY REPLICATE("=",80)
@ PROW()+1,20 SAY "T o t a l    G e r a l   ->"
@ PROW(),  49 SAY vtottv PICTURE "@E 999,999,999.99"
@ PROW(),  67 SAY vtottc PICTURE "@E 99,999,999.99"
@ PROW()+1,0 SAY REPLICATE("=",80)
@ PROW()+2,0 SAY PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
CLOSE DATABASE
SET DEVICE TO SCREEN
RETURN
/*
Pedido   Data    Ped.Cliente     Vend. Pagto.     V a l o r          Comissao
99999  99/99/99 xxxxxxxxxxxxxxx   xxx   xxx     999,999,999.99    99,999,999.99
*/
********************************************************************************
PROCEDURE Relvenres()
// Relatorio Resumo de Vendas.
********************************************************************************
// Atualiza a linha de status no topo da tela
LOCAL vres[10],vtot[10],nven:=0,nite:=0,tven:=0,tite:=0
Sinal("VENDAS","RELATORIO")
IF FILE("SAOVEN.DBF")
   // Vendas
   SELECT 1
   USE SAOVEN ALIAS Ven
ELSE
   Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOVEI.DBF")
   // Itens das Vendas
   SELECT 2
   USE SAOVEI ALIAS Vei
   IF !FILE("SAOVEI1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOVEI1
ELSE
   Mensagem("Arquivo dos Itens das Vendas N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOTPG.DBF") .AND. FILE("SAOTPG1.NTX") .AND. FILE("SAOTPG2.NTX")
   // Tipos de Pagamento.
   SELECT 3
   USE SAOTPG INDEX SAOTPG1,SAOTPG2 ALIAS Tpag EXCLUSIVE
ELSE
   Mensagem("A Tabela de Tipos de Pagamento N„o Est  Disponivel !",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF FILE("SAOPRO.DBF")
   SELECT 4
   USE SAOPRO ALIAS Prod
   IF !FILE("SAOPRO1.NTX")
      Indexa()
   ENDIF
   SET INDEX TO SAOPRO1
ELSE
   Mensagem("Arquivo de Produtos N„o Encontrado no Disco !",8,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Ven
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressos.
Pesqdat()
Abrejan(2)
SETCOLOR(vcp)
Aviso(12,"Aguarde..., Reorganizando o Arquivo")
SETCOLOR(vcn)
INDEX ON Ven->tipg TO Temp
IF !Imprime("Relat¢rio Resumo de Vendas")
   CLOSE DATABASE
   RETURN
ENDIF
AFILL(vtot,0)           // Totalizador Geral
AFILL(vres,0)           // Totalizador por tipo de pagto.
pg:=0                   // Contador de p ginas.
pv:=.T.                 // Controlador da impressao.
SET DEVICE TO PRINTER   // Direciona para a impressora.
// DO WHILE principal
DO WHILE !EOF()
   Cabe(emp[2],vsist,"Relatorio Resumo de Vendas de "+DTOC(vdati)+" a "+DTOC(vdatf),"Relatorio por Tipo de Pagamento",124,vcia20)
   @ PROW()+1,01 SAY "No. de Vendas    Valor Total     Acrescimos       Descontos       Comissoes          ICMS           C.M.V.      Itens/Venda"
   @ PROW()+1,00 SAY REPLICATE("-",124)
   DO WHILE PROW()<=60 .AND. !EOF()
      vtipg:=Ven->tipg
      SELECT Tpag
      SEEK vtipg
      SELECT Ven
      DO WHILE Ven->tipg=vtipg .AND. !EOF()
         IF Ven->data>=vdati .AND. Ven->data<=vdatf
            ++nven                // N£mero de vendas
            vres[01]+=Ven->valor  // Valor total
            vres[02]+=Ven->vencf  // Acr‚scimos
            vres[03]+=Ven->vdesc  // Descontos
            vres[04]+=Ven->vcomi  // Comissoes
            vres[05]+=Ven->icms   // ICMS
            SELECT Vei
            SEEK Ven->nupd
            DO WHILE Vei->nupd=Ven->nupd .AND. !EOF()
               SELECT Prod
               SEEK Vei->codpro
               SELECT Vei
               vres[06]+=(Vei->quant*Prod->custr) // Custo dos Produtos vendidos
               ++nite                            // N£mero de Itens por venda
               SKIP
            ENDDO
            SELECT Ven
         ENDIF
         SKIP
      ENDDO
      @ PROW()+2,02 SAY Tpag->nome
      @ PROW()  ,02 SAY Tpag->nome
      @ PROW()+1,05 SAY nven     PICTURE "@E 999"
      @ PROW(),  16 SAY vres[01] PICTURE "@E 999,999,999.99"
      @ PROW(),  33 SAY vres[02] PICTURE "@E 99,999,999.99"
      @ PROW(),  49 SAY vres[03] PICTURE "@E 99,999,999.99"
      @ PROW(),  65 SAY vres[04] PICTURE "@E 99,999,999.99"
      @ PROW(),  81 SAY vres[05] PICTURE "@E 99,999,999.99"
      @ PROW(),  97 SAY vres[06] PICTURE "@E 999,999,999.99"
      @ PROW(), 117 SAY ROUND(nite/nven,0) PICTURE "@E 999"
      tven+=nven
      tite+=nite
      FOR i=1 TO 6
         vtot[i]+=vres[i]
      NEXT
      nven:=nite:=0
      AFILL(vres,0)
   ENDDO
ENDDO
@ PROW()+1,00 SAY REPLICATE("-",124)
@ PROW()+1,05 SAY tven     PICTURE "@E 999"
@ PROW(),  16 SAY vtot[01] PICTURE "@E 999,999,999.99"
@ PROW(),  33 SAY vtot[02] PICTURE "@E 99,999,999.99"
@ PROW(),  49 SAY vtot[03] PICTURE "@E 99,999,999.99"
@ PROW(),  65 SAY vtot[04] PICTURE "@E 99,999,999.99"
@ PROW(),  81 SAY vtot[05] PICTURE "@E 99,999,999.99"
@ PROW(),  97 SAY vtot[06] PICTURE "@E 999,999,999.99"
@ PROW(), 117 SAY ROUND(tite/tven,0) PICTURE "@E 999"
@ PROW()+1,00 SAY REPLICATE("-",124)
@ PROW()+2,0 SAY vcia10+PADC(" F i m   d o   R e l a t o r i o ",80,"=")
EJECT
SET DEVICE TO SCREEN
CLOSE DATABASE
ERASE TEMP.NTX
RETURN
/*
No. de Vendas    Valor Total     Acrescimos       Descontos       Comissoes          ICMS           C.M.V.      Itens/Venda
    999        999,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   999,999,999.99      999
*/
********************************************************************************
PROCEDURE Relvicms(tipo)
/*
Objetivo : emite os relat¢rios do ICMS sobre vendas.
*/
********************************************************************************
// Atualiza a linha de status.
LOCAL vtot
Sinal("ICMS","RELATORIO")
// Abertura dos arquivos de dados
IF tipo=1
   vcab:="Vendas Totais"
   IF FILE("SAOVEN.DBF")
      // Vendas
      SELECT 1
      USE SAOVEN ALIAS Nf
      IF !FILE("SAOVEN3.NTX")
         Indexa()
      ENDIF
      SET INDEX TO SAOVEN3
   ELSE
      Mensagem("Arquivo das Vendas N„o Encontrado no Disco !",8,1)
      CLOSE DATABASE
      RETURN
   ENDIF
ELSE
   vcab:="Notas Fiscais"
   IF FILE("SAONF.DBF")
      // Notas Fiscais
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
ENDIF
SELECT Nf
vdati:=vdatf:=CTOD(SPACE(8))
// Pesquisa a faixa datas cujas vendas devem ser impressas.
Pesqdat()
IF !Imprime("Relat¢rio do ICMS")
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
   Cabe(emp[2],vsist,"Relatorio do ICMS Sobre "+vcab,"Periodo: "+DTOC(vdati)+" a "+DTOC(vdatf),80,vcia10)
   @ PROW()+1,03 SAY "Nro.     DATA                  CLIENTE                        VALOR ICMS"
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
         IF tipo=1
            @ PROW()+1,02 SAY Nf->nupd
         ELSE
            @ PROW()+1,02 SAY Nf->nunf
         ENDIF
         @ PROW(),  09 SAY Nf->data
         @ PROW(),  19 SAY Nf->cli
         @ PROW(),  61 SAY Nf->icms PICTURE "@E 999,999,999.99"
         vtot+=Nf->icms
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
  Nro.     Data                  Cliente                        Valor Total         
 99999  99/99/99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99  
*/
********************************************************************************
//                        Fim do Programa SAOVEN.PRG
********************************************************************************
