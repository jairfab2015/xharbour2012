********************************************************************************
/* Programa.: SAOUTI.PRG
   Autor....: Antonio Geraldo da Rocha Vidal  
   Data.....: 08/03/92
   Aviso....: Copyright (c) 1992, AGV Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: M¢dulo dos Utilit rios do Sistema.       */
********************************************************************************
// Arquivos-cabe‡alho.
#include "INKEY.CH"              // C¢digo das teclas
********************************************************************************
PROCEDURE Param()
// Objetivo: Define os parametros de processamento do sistema
********************************************************************************
Sinal("PARAMETROS","SISTEMA")
IF FILE("SAOPAR.DBF")
   SELECT 1
   USE SAOPAR.DBF ALIAS Param
ELSE
   Mensagem("Arquivo de Parƒmetros N„o Encontrado no Disco!",8,1)
   RETURN
ENDIF
IF FILE("SAOOPE.DBF")
   SELECT 2
   USE SAOOPE.DBF INDEX SAOOPE1 ALIAS Ope
ELSE
   Mensagem("Arquivo de Opera‡”es N„o Encontrado no Disco!",8,1)
   RETURN
ENDIF
SELECT Param
PRIVATE vpar[6,2]
Abrejan(2)
GO TOP
FOR i=1 TO 6
   vpar[i,1]:=Param->codi1
   vpar[i,2]:=Param->codi2
   SKIP
NEXT
/*
              Opera‡„o                            C¢digo Inicial C¢digo Final
 Compras sem Nota Fiscal............................ 9.99.999 .... 9.99.999
*/
@ 03,15 SAY "Opera‡„o                            C¢digo Inicial C¢digo Final"
@ 04,01 SAY REPLICATE("Ä",78)
/*
@ 06,02 SAY PADR("Compras sem Nota Fiscal",73,".")
@ 08,02 SAY PADR("Compras com Nota Fiscal Registrada",73,".")
@ 10,02 SAY PADR("Compras com Nota Fiscal N„o Registrada",73,".")
*/
@ 06,02 SAY PADR("Compras no Mercado Interno",73,".")
@ 08,02 SAY PADR("Compras no Mercado Externo",73,".")
@ 10,02 SAY PADR("Compras Especiais",73,".")
@ 12,02 SAY PADR("Vendas com Cart„o de Cr‚dito",73,".")
@ 14,02 SAY PADR("Vendas a Prazo com Cheque Pr‚-datado",73,".")
@ 16,02 SAY PADR("Vendas a Vista",73,".")
lin:=6
SETCOLOR(vcr)
FOR i=1 TO 6
   @ lin,54 SAY vpar[i,1] PICTURE "@R 9.99.999"
   @ lin,68 SAY vpar[i,2] PICTURE "@R 9.99.999"
   lin+=2
NEXT
SETCOLOR(vcn)
DO WHILE .T.
   i:=1;lin:=6
   DO WHILE i<=6
      @ lin,54 GET vpar[i,1] PICTURE "@R 9.99.999"
      Le()
      // Apresenta uma tabela de consulta para a opera‡„o.
      vpar[i,1]:=Acha(vpar[i,1],"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
      SETCOLOR(vcr)
      @ lin,54 SAY vpar[i,1] PICTURE "@R 9.99.999"
      SETCOLOR(vcn)
      @ lin,68 GET vpar[i,2] PICTURE "@R 9.99.999"
      Le()
      // Apresenta uma tabela de consulta para a opera‡„o.
      vpar[i,2]:=Acha(vpar[i,2],"Ope",1,2,"codi","nome","@R 9.99.999","@!",15,05,22,76)
      SETCOLOR(vcr)
      @ lin,68 SAY vpar[i,2] PICTURE "@R 9.99.999"
      SETCOLOR(vcn)
      ++i
      lin+=2
   ENDDO
   IF Confirme()
      EXIT
   ENDIF
ENDDO
SELECT Param
GO TOP
FOR i=1 TO 6
   Param->codi1:=vpar[i,1]
   Param->codi2:=vpar[i,2]
   SKIP
NEXT
CLOSE DATABASE
RETURN
********************************************************************************
PROCEDURE Indexa()
/* 
Objetivo: Recria os indices dos arquivos de dados e, caso o usu rio
          solicite, exclui os registros deletados atraves do comando PACK.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("ARQUIVOS","INDEXA€ŽO")
Abrejan(2)
SETCOLOR(vca)
Aviso(07,"Reorganiza‡„o dos Arquivos do Sistema")
SETCOLOR(vcp)
Aviso(10,"A g u a r d e")
SETCOLOR(vcn)
SELECT 1
   USE SAOPRO ALIAS Prod
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Produtos")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOPRO1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOPRO2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOFOR ALIAS Forne
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Fornecedores")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOFOR1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOFOR2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOPXF ALIAS Pxf
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Produtos x Fornecedores")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codpro+codfor TO SAOPXF1
   INDEX ON codfor+codpro TO SAOPXF2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Referˆncia do Fornecedor")
   INDEX ON codpxf TO SAOPXF3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome do Fornecedor")
   INDEX ON nome TO SAOPXF4
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOCLI ALIAS Cli
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Clientes")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOCLI1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOCLI2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOREP ALIAS Repr
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Vendedores/Representantes")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOREP1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOREP2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOCTB ALIAS Ctb
   SETCOLOR(vca)
   Aviso(12,"Cadastro da Contas Banc rias")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON banco+agenc+conta TO SAOCTB1
   Aviso(14,"Reorganizando o Arquivo por Nome do Correntista")
   INDEX ON nome TO SAOCTB2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOOPE ALIAS Ope
   SETCOLOR(vca)
   Aviso(12,"Cadastro de Opera‡”es")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOOPE1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOOPE2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOUS ALIAS Dolar
   SETCOLOR(vca)
   Aviso(12,"Tabela do D¢lar")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo")
   INDEX ON data TO SAOUS1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOIND ALIAS Indice
   SETCOLOR(vca)
   Aviso(12,"Tabela do Indice de Corre‡„o")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo")
   INDEX ON data TO SAOIND1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOPED ALIAS Pedidos
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Pedidos de Compras")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON nupd TO SAOPED1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Fornecedor")
   INDEX ON forne TO SAOPED2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+nupd TO SAOPED3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo dos Itens de Pedidos de Compras")
   SELECT 1
   USE SAOPDI
   INDEX ON nupd+codpro TO SAOPDI1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOCOM ALIAS Compras
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Compras")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON nupd TO SAOCOM1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Fornecedor")
   INDEX ON forne TO SAOCOM2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+nupd TO SAOCOM3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo dos Itens de Compras")
   SELECT 1
   USE SAOCOI
   INDEX ON nupd+codpro TO SAOCOI1
   INDEX ON codpro+nupd TO SAOCOI2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOTRA ALIAS Tra
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Transferˆncias")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON nupd TO SAOTRA1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+nupd TO SAOTRA2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo dos Itens de Transferˆncias")
   SELECT 1
   USE SAOTRI
   INDEX ON nupd+codpro TO SAOTRI1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOVEN ALIAS Vendas
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Vendas")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON nupd TO SAOVEN1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Cliente")
   INDEX ON cli TO SAOVEN2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+nupd TO SAOVEN3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo dos Itens de Vendas")
   SELECT 1
   USE SAOVEI ALIAS Vdi
   INDEX ON nupd+codpro TO SAOVEI1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAONF ALIAS Notas
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Notas Fiscais")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por N£mero")
   INDEX ON nunf TO SAONF1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Cliente")
   INDEX ON cli TO SAONF2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+nunf TO SAONF3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo dos Itens de Notas Fiscais")
   SELECT 1
   USE SAONFI ALIAS Nfi
   INDEX ON nunf+codpro TO SAONFI1
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOCR ALIAS Cr
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Contas a Receber")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por Documento")
   INDEX ON docto TO SAOCR1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Pedido")
   INDEX ON nupd TO SAOCR2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(venc)+docto TO SAOCR3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Devedor")
   INDEX ON nome TO SAOCR4
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOCP ALIAS Cp
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Contas a Pagar")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por Documento")
   INDEX ON docto TO SAOCP1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Pedido")
   INDEX ON nupd TO SAOCP2
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(venc)+docto TO SAOCP3
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Credor")
   INDEX ON nome TO SAOCP4
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOMBA ALIAS Mba
   SETCOLOR(vca)
   Aviso(12,"Arquivo de Movimento Banc rio")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por Documento")
   INDEX ON docto TO SAOMBA1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Data")
   INDEX ON DTOS(data)+banco+agenc+conta TO SAOMBA2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOBAN ALIAS Tban
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Bancos")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOBAN1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOBAN2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOTPG ALIAS Tpg
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Tipos de Pagamento")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOTPG1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOTPG2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SELECT 1
   USE SAOTPRO ALIAS Tpro
   SETCOLOR(vca)
   Aviso(12,"Cadastro dos Tipos de Produtos")
   SETCOLOR(vcn)
   PACK
   Aviso(14,"Reorganizando o Arquivo por C¢digo")
   INDEX ON codi TO SAOTPRO1
   @ 14,01 SAY SPACE(78)
   Aviso(14,"Reorganizando o Arquivo por Nome")
   INDEX ON nome TO SAOTPRO2
   @ 14,01 SAY SPACE(78)
   @ 12,01 SAY SPACE(78)
SETCOLOR(vcp)
Aviso(13,"  Arquivos  Reorganizados !  ")
SETCOLOR(vcn)
RETURN
*******************************************************************************
PROCEDURE Backup()
/*
Objetivo: copia os arquivos de dados do sistema para disquetes atrav‚s do
          programa BACKUP do MS-DOS.
*/
********************************************************************************
Sinal("BACK-UP","ARQUIVOS")
// Salva a tela.
vtela:=SAVESCREEN(01,00,MaxRow()-1,MaxCol()-1)
// Salva a tela do sistema
Abrejan(2)
Aviso(08,"Escolha o Acionador de Disquetes no qual ser  Feita a C¢pia")
SET MESSAGE TO MaxRow()-1 CENTER
@ MaxRow()-1,00 CLEAR
SETCOLOR(vcm)
@ 11,37 PROMPT "[   A   ]" MESSAGE "C¢pia no Acionador de Disquetes A:"
@ 13,37 PROMPT "[   B   ]" MESSAGE "C¢pia no Acionador de Disquetes B:"
MENU TO md
IF md=1
   vdrv:="A:"
ELSEIF md=2
   vdrv:="B:"
ELSE
   RETURN
ENDIF
SETCOLOR(vcn)
Abrejan(2)
// Solicita o primeiro disquete de back-up
Aviso(11,"Coloque Primeiro Disquete de Back-Up dos Arquivos no Drive "+vdrv)
Aviso(13,"Tecle <Enter> quando Pronto !")
INKEY(0)
// Verifica a existencia do programa BACKUP do DOS no diretorio atual
IF !FILE("BACKUP.COM")
    // Se o programa nao for encontrado a operacao ‚ cancelada.
    Mensagem("Programa BACKUP do DOS N„o Encontrado !",8,1)
    RETURN
ENDIF
Abrejan(2)
// Apresenta mensagens de orientacao ao usuario
SETCOLOR(vca)
Aviso(08,"Back-Up dos Arquivos do Sistema")
SETCOLOR(vcn)
@ 11,15 SAY "Ser  iniciado o processo de c¢pia para os disquetes."
@ 12,15 SAY "Ap¢s o primeiro disquete ser completado ser  solici-"
@ 13,15 SAY "tado o segundo e assim por diante, at‚ que todos  os"
@ 14,15 SAY "arquivos do sistema tenham sido copiados."
@ 16,15 SAY "N„o interrompa de forma alguma este Processo !"
@ 17,17 SAY "Certifique-se de colocar os disquetes corretos !"
@ 19,25 SAY "Deseja iniciar o Processo ?"
IF Confirme()
   /* Se for confirmado inicia o processo de Back-Up atraves do comando RUN
    e do programa BACKUP do DOS.*/
   CLEAR
   SETCOLOR(vci)
   Aviso(02," Back Up dos Arquivos - SIGA AS INSTRU€OES ! ")
   SETCOLOR(vcn)
   @ 04,01 SAY ""
   IF vdrv="A:"
      RUN BACKUP *.DBF A:
   ELSE
      RUN BACKUP *.DBF B:
   ENDIF
   Mensagem("Fim do Processo !",8)
   RESTSCREEN(01,00,MaxRow()-1,MaxCol()-1,vtela)
   // Recupera a tela do sistema
ENDIF
RETURN
********************************************************************************
PROCEDURE Recup()
/*
Objetivo: copia os arquivos de seguran‡a gravados nos disquete de volta para o
          disco r¡gido.
*/
********************************************************************************
Sinal("RECUPERA€ŽO","ARQUIVOS")
// Salva a tela.
vtela:=SAVESCREEN(01,00,MaxRow()-1,MaxCol()-1)
Abrejan(2)
Aviso(08,"Escolha o Acionador de Disquetes do qual ser  Recuperada a C¢pia")
@ MaxRow()-1,00 CLEAR
SET MESSAGE TO MaxRow()-1 CENTER
SETCOLOR(vcm)
@ 11,37 PROMPT "[   A   ]" MESSAGE "C¢pia no Acionador de Disquetes A:"
@ 13,37 PROMPT "[   B   ]" MESSAGE "C¢pia no Acionador de Disquetes B:"
MENU TO md
IF md=1
   vdrv:="A:"
ELSEIF md=2
   vdrv:="B:"
ELSE
   RETURN
ENDIF
SETCOLOR(vcn)
Abrejan(2)
// Solicita o primeiro disquete a ser recuperado.
Aviso(11,"Coloque Primeiro Disquete de Back-Up no Drive "+vdrv)
Aviso(13,"Tecle <Enter> quando Pronto !")
INKEY(0)
// Verifica a existencia do programa RESTORE do MS-DOS no diretorio atual.
// Se nao for encontrado a operacao ser  cancelada.
IF !FILE("RESTORE.COM")
    Mensagem("Programa RESTORE do DOS N„o Encontrado !",8,1)
    RETURN
ENDIF
Abrejan(2)
// Apresenta mensagens de orientacao ao usuario.
SETCOLOR(vca)
Aviso(08,"Recupera‡„o dos Arquivos do Sistema")
SETCOLOR(vcn)
@ 11,15 SAY "Ser  iniciado o processo de c¢pia para o winchester."
@ 12,15 SAY "Ap¢s o primeiro disquete ser copiado ser  solicitado"
@ 13,15 SAY "o  segundo  e  assim  por  diante, at‚ que todos os "
@ 14,15 SAY "arquivos do sistema tenham sido recuperados."
@ 16,17 SAY "N„o interrompa de forma alguma este Processo !"
@ 17,17 SAY "Certifique-se de colocar os disquetes corretos !"
@ 19,25 SAY  "Deseja iniciar o Processo ?"
IF Confirme()
   /* Inicia a operacao de recuperacao dos arquivos atraves do comando RUN e
    do programa RESTORE do DOS.*/
   CLEAR
   SETCOLOR(vci)
   Aviso(02," Recupera‡„o dos Arquivos - SIGA AS INSTRU€OES ! ")
   SETCOLOR(vcn)
   @ 04,01 SAY ""
   IF vdrv="A:"
      RUN RESTORE A: C:
   ELSE
      RUN RESTORE B: C:
   ENDIF
   Mensagem("Fim do Processo !",8)
   RESTSCREEN(01,00,MaxRow()-1,MaxCol()-1,vtela)
   // Recupera a tela do sistema
   // Reindexa os arquivos recuperados dos disquetes.
   Indexa()
ENDIF
RETURN
********************************************************************************
PROCEDURE Confimp(vimp)
/*
Objetivo: configuracao da impressora.
*/
********************************************************************************
LOCAL vtit
Abrejan(2)
Sinal("IMPRESSORA","CONFIGURA€ŽO")
IF vimp=1 .OR. vimp=2  // Elebra e Rima Padrao
   vtit:="Elebra e Rima Padr„o"
   vcia05:=CHR(14)          // ativa a expansao em uma linha
   vcid05:=CHR(20)          // desativa a expansao
   vcia10:=CHR(30)+"0"      // impressao a 10 cpp
   vcid20:=CHR(18)          // desativa a condencacao de caracteres
   vcia12:=CHR(30)+"2"      // impressao a 12 cpp
   vcia20:=CHR(30)+CHR(52)  // ativa condensacao de caracteres
   vcia15:=CHR(30)+"3"      // ativa condensacao a 15 cpp
   vcia17:=CHR(30)+"3"      // ativa a impressao para 163 caractere
   vciaip:=CHR(27)+"@"      // ativa a impressao 
ELSEIF vimp=3          // Configuracao para Rima Itautec
   vtit:="Rima Itautec"
   vcia05:=CHR(14)          // ativa a expansao em uma linha
   vcid05:=CHR(20)          // desativa a expansao
   vcia10:=CHR(30)+"0"      // impressao a 10 cpp
   vcid10:=CHR(18)          // desativa a condencacao de caracteres
   vcia12:=CHR(30)+"2"      // impressao a 12 cpp
   vcia20:=CHR(30)+CHR(52)  // ativa condensacao de caracteres
   vcia15:=CHR(27)+"[6W"    // ativa condensacao a 15 cpp
   vcia17:=CHR(27)+"[2W"    // ativa a impressao para 163 caractere
   vciaip:=CHR(27)+"[5W"    // ativa a impressao 
ELSEIF vimp=4          // Configuracao para Elgin
   vtit:="Elgin"
   vcia05:=CHR(27)+"[9w"    // ativa a expansao em uma linha 
   vcid05:=CHR(27)+"[8w"    // desativa a expansao
   vcia10:=CHR(27)+"[4w"    // impressao a 10 cpp
   vcid10:=CHR(27)+"[4w"    // desativa a condencacao de caracteres
   vcia12:=CHR(27)+"[5w"    // impressao a 12 cpp
   vcia20:=CHR(27)+"[6w"    // ativa condensacao de caracteres
   vcia15:=CHR(30)+"[6w"    // ativa condensacao a 15 cpp
   vcia17:=CHR(27)+"[5w"    // ativa a impressao para 163 caractere
   vciaip:=CHR(27)+"[3w"    // ativa a impressao 
ELSEIF vimp=5          // Configuracao para Epson Padrao
   vtit:="Epson Padr„o FX"
   vcia05:=CHR(14)          // ativa a expansao em uma linha
   vcid05:=CHR(20)          // desativa a expansao
   vcia10:=CHR(30)+"0"      // impressao a 10 cpp
   vcid10:=CHR(18)          // desativa a condencacao de caracteres
   vcia12:=CHR(30)+"2"      // impressao a 12 cpp
   vcia20:=CHR(15)          // ativa condensacao de caracteres
   vcia15:=CHR(30)+"3"      // ativa condensacao a 15 cpp
   vcia17:=CHR(30)+"3"      // ativa a impressao para 163 caractere
   vciaip:=CHR(27)+"@"      // ativa a impressao 
ELSEIF vimp=6          // Configuracao para Epson LX-810
   vtit:="Epson LX-810"
   vcia05:=CHR(14)          // ativa a expansao em uma linha
   vcid05:=CHR(20)          // desativa a expansao
   vcia10:=CHR(27)+"P"      // impressao a 10 cpp
   vcid10:=CHR(18)          // desativa a condencacao de caracteres
   vcia12:=CHR(27)+"M"      // impressao a 12 cpp
   vcia20:=CHR(15)          // ativa condensacao de caracteres
   vcia15:=CHR(15)          // ativa condensacao a 15 cpp
   vcia17:=CHR(15)          // ativa a impressao para 163 caractere
   vciaip:=CHR(27)+"P"      // ativa a impressao 
ENDIF
SETCOLOR(vcp)
Aviso(12,"Configurando o Sistema para as Impressoras "+vtit)
SETCOLOR(vcn)
INKEY(4)
RETURN
********************************************************************************
PROCEDURE Confcor(vcor)
/*
Objetivo: configuracao das cores da tela.
*/
********************************************************************************
IF vcor=1
   // Padrao Monocrom tico
   vcn:="W/N,N/W,,,W+/BG"
   vci:="N/W,W/N,,,BG/W+"
   vca:="W+/N,N/W,,,BG/W+"
   vcp:="W+*/N,N/W,,,BG/W+"
   vcr:="W+/BG,N/W,,,BG/W+"
   vcm:="W/N,N/W,,,W+/BG"
   vcf:="W+/RB,N/W,,,W+/BG"
ELSEIF vcor=2
   // Padrao Azul
   vcn:="W/N,N/W,,,W+/B"
   vci:="W+/B,W/N,,,B/W+"
   vca:="W+/N,N/W,,,B/W+"
   vcp:="W+*/N,N/W,,,B/W+"
   vcr:="W+/B,N/W,,,B/W+"
   vcm:="W/N,W+/B,,,W+/B"
   vcf:="W+/BG,GR+/B,,,W+/B"
ELSEIF vcor=3
   // Padrao Verde
   vcn:="W/N,N/W,,,W+/G"
   vci:="W+/G,W/N,,,G/W+"
   vca:="W+/N,N/W,,,G/W+"
   vcp:="W+*/N,N/W,,,G/W+"
   vcr:="W+/G,N/W,,,G/W+"
   vcm:="W/N,W+/G,,,W+/G"
   vcf:="W+/BG,W+/R,,,W+/G"
ELSEIF vcor=4
   // Padrao P£rpura
   vcn:="W/N,N/W,,,W+/RB"
   vci:="W+/RB,W/N,,,RB/W+"
   vca:="W+/N,N/W,,,RB/W+"
   vcp:="W+*/N,N/W,,,RB/W+"
   vcr:="W+/RB,N/W,,,RB/W+"
   vcm:="W/N,W+/RB,,,W+/RB"
   vcf:="W+/BG,GR+/RB,,,W+/RB"
ELSEIF vcor=5
   // Padrao Vermelho
   vcn:="W/N,N/W,,,W+/R"
   vci:="W+/R,W/N,,,R/W+"
   vca:="W+/N,N/W,,,R/W+"
   vcp:="W+*/N,N/W,,,R/W+"
   vcr:="W+/R,N/W,,,R/W+"
   vcm:="W/N,W+/R,,,W+/R"
   vcf:="W+/BG,GR+/R,,,W+/R"
ELSEIF vcor=6
   // Padrao Cristal L¡quido.
   vcn:="W/N,N/W,,,B+/N"
   vci:="N/W,N/W,,,B+/N"
   vca:="W+/N,N/W,,,B+/N"
   vcp:="W+*/N,N/W,,,B+/N"
   vcr:="N/W,N/W,,,B+/N"
   vcm:="W/N,N/W,,,B+/N"
   vcf:="W+/BG,N/W,,,B+/N"
ENDIF
// Reapresenta a linha de status com as novas cores definidas.
SETCOLOR(vci)
@ 01,00 SAY SPACE(12)+"º"+SPACE(12)+"º"+SPACE(28)+"º"+SPACE(11)+"º"+SPACE(13)
@ 01,70 SAY DATE()
@ 01,26 SAY "  Administra‡„o Opera‡”es  "
Sinal("MENU","PRINCIPAL")
SETCOLOR(vcn)
// Salva a tela.
vt2:=SAVESCREEN(01,00,MaxRow()-1,MaxCol()-1)
RETURN
********************************************************************************
PROCEDURE Confemp()
/*
Objetivo: configuracao dos dados da empresa.
*/
********************************************************************************
Sinal("EMPRESA","DADOS")
Abrejan(2)
SETCOLOR(vca)
Aviso(06,"  D a d o s    d a    E m p r e s a  ")
SETCOLOR(vcn)
vcemp1:=PADR(ALLTRIM(vcemp1),54)
vcemp2:=PADR(ALLTRIM(vcemp2),54)
vcemp3:=PADR(ALLTRIM(vcemp3),8)
DO WHILE .T.
   @ 10,02 SAY "Nome para Tela______:" GET vcemp1
   @ 12,02 SAY "Nome para Relat¢rios:" GET vcemp2 
   @ 14,02 SAY "Sigla da Empresa____:" GET vcemp3
   Le()
   IF !EMPTY(vcemp1) .AND. !EMPTY(vcemp2) .AND. !EMPTY(vcemp3)
      IF Confirme()
         EXIT
      ENDIF
   ENDIF
ENDDO
vcemp1:=PADC(ALLTRIM(vcemp1),60)
vcemp2:=ALLTRIM(vcemp2)
vcemp3:=ALLTRIM(vcemp3)
RETURN
********************************************************************************
//                                   Fim
********************************************************************************




#include "inkey.ch"
#include "hbgtinfo.ch"

/********** * * * * *
ConfigurarAmbiente()
*/
PROCEDURE ConfigurarAmbiente()
lOCAL	c := SaveScreen( 0, 0, MaxRow(), MaxCol() )
LOCAL aFonte := {}
LOCAL nAlt, nLar
wvw_SetCodePage( 0, 255 )
wvw_SetTitle( 0, "Sistemas Contabilidade" )
*wvw_Size_Ready( .t. )
wvw_EnableMaximize( 0, .t. )
wvw_SetFont( 0 , "Consolas", 24, 11, 100, 4 )
SETMODE( 25, 84 ) // 20,70 
*--- Ativa o mouse --*
SET EVENTMASK TO 159
Set(40 ,159)


FOR i:=1 TO 20
	wvw_SetFont(0,"Consolas",i*2,i,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont(0,"Consolas",nAlt,nLar,100,4)
FOR i:=1 TO 10
	wvw_SetFont(0,"Consolas",nAlt+1,nLar,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont(0,"Consolas",nAlt,nLar,100,4)

FOR i:=1 TO 10
	wvw_SetFont(0,"Consolas",nAlt,nLar+i,100,4)
        IF SETMODE( 25, 84 )
		aFonte := WVW_GETFONTINFO()
		nAlt := aFonte[2]
		nLar := aFonte[3]
	ENDIF
NEXT
wvw_SetFont( 0, "Consolas", nAlt, nLar, 100,4 )
	
wvw_settitle(0, "Sistemas Contabilidade" )
wvw_sbdestroy(0)

IF wvw_sbcreate(0) > 0

   IF WVW_SBAddPart(,"Resolução: " + ALLTRIM(STR(wvw_maxmaxrow())) +'x'+ ALLTRIM(STR(wvw_maxmaxcol())) ) > 0
      WVW_SBSetText(, 1, "Resolução: " + ALLTRIM(STR(wvw_maxmaxrow())) +'x'+ ALLTRIM(STR(wvw_maxmaxcol())) )
   ENDIF

   IF WVW_SBAddPart(,"Usuario: " + GetEnv("USERNAME") ) > 0
      WVW_SBSetText(, 2, "Usuario: " + GetEnv("USERNAME") )
   ENDIF

   IF WVW_SBAddPart(, "99/99/9999" ) > 0
      SET CENTURY ON
      WVW_SBSetText(, 3, DTOC(DATE()) )
      SET CENTURY OFF
   ENDIF

   WVW_SBSetText(, 0, "Sistemas Contabilidade")

ENDIF


wvw_noclose(.T.)
WVW_Maximize()

RETURN



