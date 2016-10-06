********************************************************************************
/* Procedure: SAO.PRG
   Aviso....: Copyright (c) 2001, Universe New Desenv.de Sistemas , All Rights Reserved
   Fun‡„o...: M¢dulo principal do sistema - Menu de Op‡”es. */
********************************************************************************
#include "INKEY.CH"
// Aguarda o parƒmetro senha, passado pela linha de comando do DOS.
FUNCTION MAIN( sen )
// Declara‡ao das variaveis Locais e P£blicas.
LOCAL chc:=0,se:=.T.
RESTORE FROM SAO.CFG ADDITIVE
RESTORE FROM SAO ADDITIVE
PUBLIC vcn, vci, vca, vcp, vcr, vcia, tk, hlp:=0, i05, id5, i10, i12, i16, i20
PUBLIC frame[8], emp[3],vsen[6],mp:=1,vsist,vcop:=1, vcabpg:=.T.,pg:=0, ncol:=80
PUBLIC vcodi,vcodf,vdata,saomes,vclin,vccol
// Defini‡oes globais de ambiente de trabalho.
SET EPOCH TO "1950"
SET DATE BRITISH         // Coloca vari veis data no formato dd/mm/aa.
SET DATE FORMAT TO "DD/MM/yyyy"
SETCURSOR(0)             // Desliga a apresenta‡ao do cursor.
SET CONSOLE OFF          // Desliga a apresenta‡ao de sa¡das de comandos.
SET DELETED ON           // Ignora os registros deletados no processamento.
SET KEY K_F10 TO Calc()
vcia:=vci

ConfigurarAmbiente()

// Defini‡ao das molduras a serem utilizadas no comando @...BOX.
frame[1]:=CHR(218)+CHR(196)+CHR(191)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
frame[2]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+SPACE(1)
frame[3]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+CHR(176)
frame[4]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+CHR(177)
frame[5]:=CHR(194)+CHR(196)+CHR(194)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
frame[6]:=CHR(218)+CHR(196)+CHR(191)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
// Defini‡ao do Nome da Empresa e do Sistema.
emp[1]:=vcemp1
emp[2]:=vcemp2
emp[3]:=vcemp3
vsist:="Sistema de Administracao de Operacoes"
// Defini‡ao das senhas de acesso aos m¢dulos do sistema.
vsen[1]:="CAD"  // M¢dulo do cadastro.
vsen[2]:="COM"  // M¢dulo de compras.
vsen[3]:="VEN"  // M¢dulo de vendas.
vsen[4]:="CTA"  // M¢dulo de contas.
vsen[5]:="BCO"  // M¢dulo de bancos.
vsen[6]:="UTI"  // M¢dulo de utilitarios.
CLEAR
SETCOLOR(vci)
// Montagem da Linha de status no topo da tela.
@ 01,00 SAY SPACE(12)+"º"+SPACE(12)+"º"+SPACE(28)+"º"+SPACE(11)+"º"+SPACE(13)
@ 01,68 SAY DATE()
@ 01,26 SAY "  Administra‡„o Opera‡”es  "
SETCOLOR(vcn)
Sinal("S E N H A","ACESSO")
@ 02,00,05,79 BOX frame[1]
SETCOLOR(vcr)
Aviso(03,"    "+emp[1]+"    ")
Aviso(04,"SISTEMA ADMINISTRA€ŽO DE OPERA€OES - "+emp[3]+"   ")
SETCOLOR(vcn)
FOR i=6 TO 11
    @ i,i-6,29-i,79-(i-6) BOX frame[2]
NEXT
@ 12,06,17,73 BOX frame[4]
SETCOLOR(vcf)
Aviso(16," Vers„o 1.7 - Copyright (C) jair 1992/2001 ")
SETCOLOR(vcn)

set message to 24
public espaco,nivelx,vcodi,dianov,quebra1


@ 24,00 CLEAR
IF !FILE("SAOPRO1.NTX")
   /* Executa a rotina indexa (SAOBIB.PRG) para criar os arquivos de ¡ndice,
      caso estes ainda nao existam.*/
   Indexa()
ENDIF
// Abre a janela de dados: Rotina Abrejan() (contida na SAOBIB.PRG)
Abrejan(4)
// Constru‡ao da tela do menu principal.
@ 03,01 SAY SPACE(78)
@ 04,00 SAY "º"+REPLICATE(CHR(196),78)+"º"
// Op‡oes do menu principal.
//Cadastros    Entradas   Sa¡das    Contas   Movimento   Utilit rios   Fim
@ 03, 03 SAY "Cadastros"
@ 03, 16 SAY "Entradas"
@ 03, 27 SAY "Sa¡das"
@ 03, 37 SAY "Contas"
@ 03, 46 SAY "Movimento"
@ 03, 58 SAY "Utilit rios"
@ 03, 72 SAY "Fim"
vt1:=SAVESCREEN(01,00,24,79)  // Salva tela para posterior uso.
SET MESSAGE TO 24 CENTER      // Mensagens dos @ PROMPT's centralizada na linha 24.
DO WHILE .T.
   RESTSCREEN(01,00,24,79,vt1)  // Sobrep”e a tela salva anteriormente.
   IF vcia#vci
      // Remonta a tela para o caso de mudan‡a de cores.
      SETCOLOR(vci)
      // Montagem da Linha de status no topo da tela
      @ 01,00 SAY SPACE(12)+"º"+SPACE(12)+"º"+SPACE(28)+"º"+SPACE(11)+"º"+SPACE(13)
      @ 01,70 SAY DATE()
      @ 01,26 SAY "  Administra‡„o Opera‡”es  "
      SETCOLOR(vcn)
      vt1:=SAVESCREEN(01,00,24,79)  // Salva tela para posterior uso.
      vcia:=vci
   ENDIF
   // Apresenta o sinal na linha de status.
   Sinal("M E N U","PRINCIPAL")
   m1:=1
   IF mp=1
      // Primeira op‡ao do menu principal.
      SETCOLOR(vci)
      @ 03,   03 SAY "Cadastros"
      SETCOLOR(vcn)
      // Linha, coluna e n£mero de op‡oes do menu de n¡vel 1.
      lin1:=4;col1:=03;nop1:=6
      // Vetores das op‡oes e mensagens do menu de n¡vel 1.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Produtos     "
      vop[2]:="Fornecedores "
      vop[3]:="Clientes     "
      vop[4]:="Vendedores   "
      vop[5]:="Contas Bancos"
      vop[6]:="Opera‡”es    "
      vme[1]:="Manuten‡„o do Cadastro de Produtos"
      vme[2]:="Manuten‡„o do Cadastro de Fornecedores"
      vme[3]:="Manuten‡„o do Cadastro de Clientes"
      vme[4]:="Manuten‡„o do Cadastro de Vendedores ou Representantes"
      vme[5]:="Manuten‡„o do Cadastro de Contas Correntes em Bancos"
      vme[6]:="Manuten‡„o do Cadastro de Opera‡”es"
      // Moldura do menu de n¡vel 1.
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      // Apresenta a primeira mensagem.
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Executa o primeiro menu de n¡vel 1.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida pelo usu rio.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Menu de n¡vel 2: Cadastro dos Produtos.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=7
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Inclus„o     "
            vops[2,1]:="Altera‡„o    "
            vops[3,1]:="Exclus„o     "
            vops[4,1]:="Consultas    "
            vops[5,1]:="Relat¢rios   "
            vops[6,1]:="Fornecedores "
            vops[7,1]:="Atualiza‡„o  "
            vops[1,2]:="Inclus„o de Novos Produtos"
            vops[2,2]:="Altera‡„o no Cadastro de Produtos"
            vops[3,2]:="Exclus„o de Produtos do Cadastro"
            vops[4,2]:="Consultas na Tela ao Cadastro dos Produtos"
            vops[5,2]:="Emiss„o de Relat¢rios e Etiquetas dos Produtos"
            vops[6,2]:="Cadastro de Fornecedores por Produto (Prod.x Forn.)"
            vops[7,2]:="Atualiza‡„o dos Custos e Pre‡os dos Produtos"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2>0 .AND. m2<4
               Matprod(m2)
            ELSEIF m2=4
               Consprod()
            ELSEIF m2=5
               // Menu de nivel 3: relatorios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=5
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[3,1]:="Etiquetas    "
                  vops[4,1]:="Tabelas      "
                  vops[5,1]:="Grupos       "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos Produtos"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos Produtos"
                  vops[3,2]:="Emiss„o de Etiquetas de Produtos e Pre‡os"
                  vops[4,2]:="Emiss„o de Tabelas de Produtos"
                  vops[5,2]:="Emiss„o do Relat¢rio de Grupos de Produtos"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3=0
                     EXIT
                  ELSEIF m3>=1 .AND. m3<=2
                     // Menu de nivel 4: Ordem de emiss„o dos relat¢rios.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     DO WHILE .T.
                        // Matriz de op‡oes e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="C¢digo       "
                        vops[2,1]:="Alfab‚tico   "
                        vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo dos Produtos"
                        vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome dos Produtos"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4#0
                           IF m3=1 .OR. m3=2
                              Relprod1(m3,m4)
                           ELSE
                              EXIT
                           ENDIF
                           RESTSCREEN(01,00,24,79,vt4)
                        ELSE
                           EXIT
                        ENDIF
                     ENDDO
                  ELSEIF m3=3
                     // Menu de nivel 5: Tipo de Etiqueta.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+1+m3;col4:=col3+4;nop4=2
                     DO WHILE .T.
                        // Matriz de op‡oes e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="Produtos     "
                        vops[2,1]:="Pre‡os       "
                        vops[1,2]:="Emiss„o de Etiquetas para Codificar Produtos"
                        vops[2,2]:="Emiss„o de Etiquetas de Pre‡os para Produtos"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4=1
                           Etiprod(m4,0)
                        ELSEIF m4=2
                           // Menu de nivel 6: Selecao de Etiqueta.
                           vt5:=SAVESCREEN(01,00,24,79)
                           lin5:=lin4+1+m4;col5:=col4+4;nop5=2
                           DO WHILE .T.
                              // Matriz de op‡oes e mensagens.
                              PRIVATE vops[nop5,2]
                              vops[1,1]:="Faixa        "
                              vops[2,1]:="C¢digos      "
                              vops[1,2]:="Emiss„o de Etiquetas por Faixa de Produtos"
                              vops[2,2]:="Emiss„o de Etiquetas por C¢digo de Produtos"
                              // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                              m5:=Fmenu(lin5,col5,nop5,vops)
                              IF m5#0
                                 Etiprod(m4,m5)
                              ELSE
                                 EXIT
                              ENDIF
                              RESTSCREEN(01,00,24,79,vt5) 
                           ENDDO
                        ELSE
                           EXIT
                        ENDIF
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSEIF m3=4
                     // Menu de nivel 4: Emiss„o de Tabelas de Produtos.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=4
                     DO WHILE .T.
                        // Matriz de op‡oes e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="Saldos       "
                        vops[2,1]:="Pre‡os       "
                        vops[3,1]:="Custos       "
                        vops[4,1]:="M¡mimo       "
                        vops[1,2]:="Emiss„o da Tabela de Saldos dos Produtos"
                        vops[2,2]:="Emiss„o da Tabela de Pre‡os dos Produtos"
                        vops[3,2]:="Emiss„o da Tabela de Custos dos Produtos"
                        vops[4,2]:="Emiss„o da Tabela de Estoque M¡mimo dos Produtos"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4>=1 .AND. m4<=3
                           Relprod2(m4)
                        ELSEIF m4=4
                           Relprod3()
                        ELSE
                           EXIT
                        ENDIF
                        // Reapresenta a tela.
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSEIF m3=5
                     Relprod4()
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=6
               // Menu de nivel 3: Cadastro dos Produtos por Fornecedor.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2
               DO WHILE .T.
                  m3:=Matmenu(lin3,col3)
                  IF m3>0 .AND. m3<4
                     Matpxf(m3)
                  ELSEIF m3=4
                     Conspxf()
                  ELSEIF m3=5
                     // Menu de nivel 4: relatorios.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+m3;col4:=col3+8;nop4:=2
                     DO WHILE .T.
                        // Matriz de op‡”es e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="Produto      "
                        vops[2,1]:="Fornecedor   "
                        vops[1,2]:="Emiss„o do Relat¢rio dos Produtos fornecidos por Fornecedores"
                        vops[2,2]:="Emiss„o do Relat¢rio dos Fornecedores por Produto"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4#0
                           // Menu de nivel 5: Ordem de emiss„o dos relat¢rios.
                           lin5:=lin4+m4;col5:=col4+4;nop5:=2
                           // Matriz de op‡oes e mensagens.
                           PRIVATE vops[nop4,2]
                           vops[1,1]:="C¢digo       "
                           vops[2,1]:="Alfab‚tico   "
                           vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo"
                           vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome"
                           // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                           m5:=Fmenu(lin5,col5,nop5,vops)
                           IF m5#0
                              IF m4=1
                                 Relpxf1(m5)
                              ELSEIF m4=2
                                 Relpxf2(m5)
                              ELSE
                                 EXIT
                              ENDIF
                           ENDIF
                        ELSE
                           EXIT
                        ENDIF
                        // Reapresenta a tela.
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSE
                     EXIT
                  ENDIF
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=7
               // Menu de nivel 3: Custos dos Produtos
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=4
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Manual       "
                  vops[2,1]:="Fornecedor   "
                  vops[3,1]:="Indice       "
                  vops[4,1]:="Custo M‚dio  "
                  vops[1,2]:="Atualiza‡„o Manual do Custo e do Pre‡o dos Produtos"
                  vops[2,2]:="Atualiza‡„o Autom tica do Custo e do Pre‡o dos Produtos por Fornecedor"
                  vops[3,2]:="Atualiza‡„o Autom tica do Custo e do Pre‡o dos Produtos atrav‚s de Indices"
                  vops[4,2]:="Recalculo do Custo M‚dio dos Produtos"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3=1
                     // Menu de nivel 4: Tipo de atualiza‡„o manual.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     PRIVATE vops[nop4,2]
                     vops[1,1]:="Produto      "
                     vops[2,1]:="Fornecedor   "
                     vops[1,2]:="Atualiza‡„o dos Custos por Produto"
                     vops[2,2]:="Atualiza‡„o dos Custos por Fornecedor"
                     // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                     m4:=Fmenu(lin4,col4,nop4,vops)
                     IF m4=1
                        Atupro()
                     ELSEIF m4=2
                        Atufor()
                     ENDIF
                  ELSEIF m3=2
                     Fornecust()
                  ELSEIF m3=3
                     // Menu de nivel 4: Tipo de ¡ndice para corre‡„o.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     vt4:=SAVESCREEN(01,00,24,79)
                     DO WHILE .T.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="D¢lar        "
                        vops[2,1]:="Indice       "
                        vops[1,2]:="Corre‡„o dos Custos Atrav‚s da Cota‡„o do D¢lar"
                        vops[2,2]:="Corre‡„o dos Custos Atrav‚s da Cota‡„o do Indice"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4#0
                           // Menu de nivel 5: Tipo de Ordem de Corre‡„o
                           lin5:=lin4+1+m4;col5:=col4+4;nop5:=2
                           // Matriz de op‡oes e mensagens.
                           PRIVATE vops[nop5,2]
                           vops[1,1]:="Produto      "
                           vops[2,1]:="Fornecedor   "
                           vops[1,2]:="Corre‡„o dos Custos por Produto"
                           vops[2,2]:="Corre‡„o dos Custos por Fornecedor"
                           // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                           m5:=Fmenu(lin5,col5,nop5,vops)
                           IF m5#0
                              Indcust(m4,m5)
                           ENDIF
                        ELSE
                           EXIT
                        ENDIF
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSEIF m3=4
                     Medcust()
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Menu de nivel 2: Cadastro dos Fornecedores.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matfor(m2)
            ELSEIF m2=4
               Consfor()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[3,1]:="Etiquetas    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos Fornecedores"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos Fornecedores"
                  vops[3,2]:="Emiss„o de Etiquetas de Fornecedores"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     // Menu de nivel 4: Ordem de emiss„o dos relat¢rios.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     PRIVATE vops[nop4,2]
                     vops[1,1]:="C¢digo       "
                     vops[2,1]:="Alfab‚tico   "
                     vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo dos Fornecedores"
                     vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome dos Fornecedores"
                     // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                     m4:=Fmenu(lin4,col4,nop4,vops)
                     IF m4#0
                        IF m3=1 .OR. m3=2
                           Relforne(m3,m4)
                        ELSEIF m3=3
                           Etiforne(m4)
                        ELSE
                           EXIT
                        ENDIF
                     ENDIF
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Menu de nivel 2: Cadastro dos Clientes.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matcli(m2)
            ELSEIF m2=4
               Conscli()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[3,1]:="Etiquetas    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos Clientes"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos Clientes"
                  vops[3,2]:="Emiss„o de Etiquetas de Clientes"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     // Menu de nivel 4: Ordem de emiss„o dos relat¢rios.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     PRIVATE vops[nop4,2]
                     vops[1,1]:="C¢digo       "
                     vops[2,1]:="Alfab‚tico   "
                     vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo dos Clientes"
                     vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome dos Clientes"
                     // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                     m4:=Fmenu(lin4,col4,nop4,vops)
                     IF m4#0
                        IF m3=1 .OR. m3=2
                           Relcli(m3,m4)
                        ELSEIF m3=3
                           Eticli(m4)
                        ELSE
                           EXIT
                        ENDIF
                     ENDIF
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=4
         // Menu de nivel 2: Cadastro dos Vendedores.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matrep(m2)
            ELSEIF m2=4
               Consrep()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="C¢digo       "
                  vops[2,1]:="Alfab‚tico   "
                  vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo dos Vendedores"
                  vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome dos Vendedores"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relrep(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=5
         // Menu de nivel 2: Cadastro das Contas Banc rias.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matctb(m2)
            ELSEIF m2=4
               Consctb()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Conta        "
                  vops[2,1]:="Alfab‚tico   "
                  vops[1,2]:="Emiss„o do Relat¢rio por Ordem de N§ de Conta"
                  vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome do Correntista"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relctb(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=6
         // Menu de nivel 2: Cadastro das Opera‡oes.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matope(m2)
            ELSEIF m2=4
               Consope()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="C¢digo       "
                  vops[2,1]:="Alfab‚tico   "
                  vops[3,1]:="Grupos       "
                  vops[1,2]:="Emiss„o do Relat¢rio por Ordem de C¢digo da Opera‡„o"
                  vops[2,2]:="Emiss„o do Relat¢rio por Ordem de Nome da Opera‡„o"
                  vops[3,2]:="Emiss„o do Relat¢rio por Grupo de Opera‡”es"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3>0 .AND. m3<3
                     Relope(m3)
                  ELSEIF m3=3
                     // Relope2()
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ENDIF
   ELSEIF mp=2
      // Segunda op‡ao do menu principal.
      // M¢dulo de Entradas no Estoque.
      SETCOLOR(vci)
      @ 03, 16 SAY "Entradas"
      SETCOLOR(vcn)
      lin1:=4;col1:=16;nop1:=4
      // Vetores de op‡oes do menu de n¡vel 1.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Pedidos      "
      vop[2]:="Compras      "
      vop[3]:="Transferˆncia"
      vop[4]:="Relat¢rios   "
      vme[1]:="Cadastro de Pedidos aos Fornecedores"
      vme[2]:="Registro das Compras Efetuadas"
      vme[3]:="Registro de Transferˆncias entre o Dep¢sito e a Loja"
      vme[4]:="Emiss„o de Relat¢rios"
      // Moldura do menu.
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Manuten‡„o do Cadastro de Pedidos de Compras.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matped(m2)
            ELSEIF m2=4
               Consped()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos Pedidos de Compras"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos Pedidos de Compras"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3=1
                     Relped1()
                  ELSEIF m3=2
                     Relped2()
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Manuten‡„o do Registro de Compras de Mercadorias.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=2
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Dep¢sito     "
            vops[2,1]:="Loja         "
            vops[1,2]:="Registro de Compras para o Dep¢sito"
            vops[2,2]:="Registro de Compras para a Loja"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2
               DO WHILE .T.
                  m3:=Matmenu(lin3,col3)
                  IF m3>0 .AND. m3<4
                     Matcom(m2,m3)
                  ELSEIF m3=4
                     Conscom(m2)
                  ELSEIF m3=5
                     // Menu de nivel 3: relat¢rios de compras.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+m3+1;col4:=col3+8;nop4:=2
                     DO WHILE .T.
                        // Matriz de op‡oes e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="Sint‚tico    "
                        vops[2,1]:="Anal¡tico    "
                        vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico das Compras"
                        vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico das Compras"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4=1
                           Relcom1(m2)
                        ELSEIF m4=2
                           Relcom2(m2)
                        ELSE
                           EXIT
                        ENDIF
                        // Reapresenta a tela.
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSE
                     EXIT
                  ENDIF
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Manuten‡„o do Registro de Transferˆncias de Mercadorias.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=2
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Dep¢sito     "
            vops[2,1]:="Loja         "
            vops[1,2]:="Registro de Transferˆncias do Dep¢sito para a Loja"
            vops[2,2]:="Registro de Transferˆncias da Loja para o Dep¢sito"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2
               DO WHILE .T.
                  m3:=Matmenu(lin3,col3)
                  IF m3>0 .AND. m3<4
                     Matran(m2,m3)
                  ELSEIF m3=4
                     Constra(m2)
                  ELSEIF m3=5
                     // Menu de nivel 3: relat¢rios de compras.
                     vt4:=SAVESCREEN(01,00,24,79)
                     lin4:=lin3+m3+1;col4:=col3+8;nop4:=2
                     DO WHILE .T.
                        // Matriz de op‡oes e mensagens.
                        PRIVATE vops[nop4,2]
                        vops[1,1]:="Sint‚tico    "
                        vops[2,1]:="Anal¡tico    "
                        vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico das Transferˆncias"
                        vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico das Transferˆncias"
                        // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                        m4:=Fmenu(lin4,col4,nop4,vops)
                        IF m4=1
                           Reltra1(m2)
                        ELSEIF m4=2
                           Reltra2(m2)
                        ELSE
                           EXIT
                        ENDIF
                        // Reapresenta a tela.
                        RESTSCREEN(01,00,24,79,vt4) 
                     ENDDO
                  ELSE
                     EXIT
                  ENDIF
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=4
         // Emiss„o de Relat¢rios de Compras.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=5
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Fornecedor   "
            vops[2,1]:="Produto      "
            vops[3,1]:="Transferˆncia"
            vops[4,1]:="ICMS         "
            vops[5,1]:="Resumo       "
            vops[1,2]:="Emiss„o do Relat¢rio de Compras por Fornecedor"
            vops[2,2]:="Emiss„o do Relat¢rio de Compras por Produto"
            vops[3,2]:="Emiss„o do Relat¢rio de Transferˆncias de Produtos"
            vops[4,2]:="Emiss„o do Relat¢rio de ICMS sobre Compras"
            vops[5,2]:="Emiss„o do Resumo de Compras"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2=1
               Relcomfor()
            ELSEIF m2=2
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Anal¡tico    "
                  vops[2,1]:="Sint‚tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Anal¡tico de Compras por Produto"
                  vops[2,2]:="Emiss„o do Relat¢rio Sint‚tico de Compras por Produto"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relcompro(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=3
               Reltra2(0)
            ELSEIF m2=4
               Relcicms()
            ELSEIF m2=5
               Relcomres()
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ENDIF
   ELSEIF mp=3
      // Terceira op‡ao do menu principal.
      // M¢dulo de Sa¡das do Estoque.
      SETCOLOR(vci)
      @ 03, 27 SAY "Sa¡das"
      SETCOLOR(vcn)
      lin1:=4;col1:=27;nop1:=3
      // Vetores de op‡oes do menu de n¡vel 1.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Vendas       "
      vop[2]:="Notas Fiscais"
      vop[3]:="Relat¢rios   "
      vme[1]:="Cadastro de Vendas"
      vme[2]:="Cadastro e Emiss„o de Notas Fiscais"
      vme[3]:="Emiss„o de Relat¢rios de Vendas"
      // Moldura do menu.
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Manuten‡„o do Cadastro de Pedidos de Clientes.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matven(m2)
            ELSEIF m2=4
               Consven()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico das Vendas"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico das Vendas"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3=1
                     Relven1()
                  ELSEIF m3=2
                     Relven2()
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Manuten‡„o do Cadastro de Notas Fiscais.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matnf(m2)
            ELSEIF m2=4
               Consnf()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Acumulado    "
                  vops[2,1]:="Sint‚tico    "
                  vops[3,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Acumulado das Notas Fiscais"
                  vops[2,2]:="Emiss„o do Relat¢rio Sint‚tico das Notas Fiscais"
                  vops[3,2]:="Emiss„o do Relat¢rio Anal¡tico das Notas Fiscais"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3=1 .OR. m3=2
                     Relnf1(m3)
                  ELSEIF m3=2
                     Relnf2()
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Emiss„o de Relat¢rios de Saidas
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=5
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Cliente      "
            vops[2,1]:="Produto      "
            vops[3,1]:="Vendedor     "
            vops[4,1]:="ICMS         "
            vops[5,1]:="Resumo       "
            vops[1,2]:="Emiss„o do Relat¢rio de Vendas por Cliente"
            vops[2,2]:="Emiss„o do Relat¢rio de Vendas por Produto"
            vops[3,2]:="Emiss„o do Relat¢rio de Vendas por Vendedor"
            vops[4,2]:="Emiss„o do Relat¢rio de ICMS sobre Notas Fiscais"
            vops[5,2]:="Emiss„o do Relat¢rio Resumo de Vendas por Tipo de Pagamento"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2=1
               Relvencli()
            ELSEIF m2=2
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Anal¡tico    "
                  vops[2,1]:="Sint‚tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Anal¡tico das Vendas por Produto"
                  vops[2,2]:="Emiss„o do Relat¢rio Sint‚tico das Vendas por Produto"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relvenpro(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=3
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico das Vendas por Vendedor"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico das Vendas por Vendedor"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relvenven(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=4
               // Menu de nivel 3: Tipo de Relat¢rio
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Vendas       "
                  vops[2,1]:="Notas Fiscais"
                  vops[1,2]:="Emiss„o do Relat¢rio de ICMS sobre Vendas Totais"
                  vops[2,2]:="Emiss„o do Relat¢rio de ICMS sobre Notas Fiscais"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relvicms(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=5
               Relvenres()
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ENDIF
   ELSEIF mp=4
      // Quarta op‡ao do menu principal: Contas a Pagar e a Receber.
      SETCOLOR(vci)
      @ 03,   37 SAY "Contas"
      SETCOLOR(vcn)
      // Define a linha, coluna e n£mero de op‡oes do menu.
      lin1:=4;col1:=37;nop1:=3
      // Vetores de op‡oes e mensagens.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Receber      "
      vop[2]:="Pagar        "
      vop[3]:="Fluxo Caixa  "
      vme[1]:="Cadastro de Contas a Receber"
      vme[2]:="Cadastro de Contas a Pagar"
      vme[3]:="Emiss„o do Relat¢rio de Fluxo de Caixa"
      // Moldura.
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Constr¢i e apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Menu de n¡vel 2: Manuten‡„o das Contas a Receber.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=5
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Registro     "
            vops[2,1]:="Exclus„o     "
            vops[3,1]:="Baixas       "
            vops[4,1]:="Consultas    "
            vops[5,1]:="Relat¢rios   "
            vops[1,2]:="Cadastro e Altera‡„o de Contas a Receber"
            vops[2,2]:="Exclus„o de Contas a Receber"
            vops[2,2]:="Baixa de Contas a Receber: valores recebidos"
            vops[3,2]:="Consultas a Contas a Receber"
            vops[4,2]:="Emiss„o de Relat¢rios de Contas a Receber"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2>0 .AND. m2<3
               // Menu de nivel 3: Manuten‡„o de Contas a Receber.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Vendas       "
                  vops[2,1]:="Outras       "
                  vops[1,2]:="Cadastro e Manuten‡„o de Contas a Receber de Vendas"
                  vops[2,2]:="Cadastro e Manuten‡„o de Contas a Receber de Outras Origens"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Matcr(m2,m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=3
               // Menu de nivel 3: Baixa de Contas a Receber.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Vendas       "
                  vops[2,1]:="Outras       "
                  vops[1,2]:="Baixa de Contas a Receber de Vendas"
                  vops[2,2]:="Baixa de Contas a Receber de Outras Origens"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Matcr(m2,m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=4
               Conscr()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios de contas a receber.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="A Receber    "
                  vops[2,1]:="Recebidas    "
                  vops[3,1]:="Atrasadas    "
                  vops[1,2]:="Emiss„o do Relat¢rio das Contas a Receber"
                  vops[2,2]:="Emiss„o do Relat¢rio das Contas Recebidas"
                  vops[3,2]:="Emiss„o do Relat¢rio das Contas a Receber em Atraso"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     // Menu de nivel 4: tipo de relat¢rio.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     PRIVATE vops[nop4,2]
                     vops[1,1]:="Sint‚tico    "
                     vops[2,1]:="Anal¡tico    "
                     vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico"
                     vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico"
                     // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                     m4:=Fmenu(lin4,col4,nop4,vops)
                     IF m4=1
                        Relcr1(m3)
                     ELSEIF m4=2
                        Relcr2(m3)
                     ENDIF
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Menu de n¡vel 2: Manuten‡„o das Contas a Pagar.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=5
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Registro     "
            vops[2,1]:="Exclus„o     "
            vops[3,1]:="Baixas       "
            vops[4,1]:="Consultas    "
            vops[5,1]:="Relat¢rios   "
            vops[1,2]:="Cadastro e Altera‡„o de Contas a Pagar"
            vops[2,2]:="Exclus„o de Contas a Pagar"
            vops[3,2]:="Baixa de Contas a Pagar: valores pagos"
            vops[4,2]:="Consultas a Contas a Pagar"
            vops[5,2]:="Emiss„o de Relat¢rios de Contas a Pagar"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2=1 .OR. m2=2
               // Menu de nivel 3: Manuten‡„o de Contas a Pagar.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Compras      "
                  vops[2,1]:="Outras       "
                  vops[1,2]:="Cadastro e Manuten‡„o de Contas a Pagar de Compras"
                  vops[2,2]:="Cadastro e Manuten‡„o de Contas a Pagar de Outras Origens"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Matcp(m2,m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=3
               // Menu de nivel 3: Baixa de Contas a Pagar.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+1+m2;col3:=col2+4;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Compras      "
                  vops[2,1]:="Outras       "
                  vops[1,2]:="Baixa de Contas a Pagar de Compras"
                  vops[2,2]:="Baixa de Contas a Pagar de Outras Origens"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Matcp(m2,m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSEIF m2=4
               Conscp()
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios de contas a pagar.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+4;nop3:=3
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="A Pagar      "
                  vops[2,1]:="Contas Pagas "
                  vops[3,1]:="Atrasadas    "
                  vops[1,2]:="Emiss„o do Relat¢rio das Contas a Pagar"
                  vops[2,2]:="Emiss„o do Relat¢rio das Contas Pagas"
                  vops[3,2]:="Emiss„o do Relat¢rio das Contas a Pagar em Atraso"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     // Menu de nivel 4: tipo de relat¢rio.
                     lin4:=lin3+1+m3;col4:=col3+4;nop4:=2
                     // Matriz de op‡oes e mensagens.
                     PRIVATE vops[nop4,2]
                     vops[1,1]:="Sint‚tico    "
                     vops[2,1]:="Anal¡tico    "
                     vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico"
                     vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico"
                     // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                     m4:=Fmenu(lin4,col4,nop4,vops)
                     IF m4=1
                         Relcp1(m3)
                     ELSEIF m4=2
                         Relcp2(m3)
                     ENDIF
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Emiss„o do Fluxo de Caixa
         Relflu()
      ENDIF
   ELSEIF mp=5
      // Quinta op‡ao do menu principal: Contas Banc rias.
      SETCOLOR(vci)
      @ 03,   46 SAY "Movimento"
      SETCOLOR(vcn)
      // Define a linha, coluna e n£mero de op‡oes do menu.
      lin1:=4;col1:=46;nop1:=5
      // Vetores de op‡oes e mensagens.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Cr‚ditos     "
      vop[2]:="D‚bitos      "
      vop[3]:="Consulta C/C "
      vop[4]:="Consulta Ger."
      vop[5]:="Fechamento   "
      vme[1]:="Registro de Cr‚ditos"
      vme[2]:="Registro de D‚bitos"
      vme[3]:="Consulta ao Saldo das Contas Correntes"
      vme[4]:="Consulta a Informa‡”es Gerenciais na Tela"
      vme[5]:="Fechamento do Movimento Mensal e do Movimento Anual"
      // Moldura.
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Constr¢i e apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Manuten‡„o dos Cr‚ditos Banc rios.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matmba(m1,m2)
            ELSEIF m2=4
               Consmba(m1)
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos Cr‚ditos Banc rios"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos Cr‚ditos Banc rios"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relmba(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Manuten‡„o dos D‚bitos Banc rios.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1
         DO WHILE .T.
            m2:=Matmenu(lin2,col2)
            IF m2>0 .AND. m2<4
               Matmba(m1,m2)
            ELSEIF m2=4
               Consmba(m1)
            ELSEIF m2=5
               // Menu de nivel 3: relat¢rios.
               vt3:=SAVESCREEN(01,00,24,79)
               lin3:=lin2+m2+1;col3:=col2+8;nop3:=2
               DO WHILE .T.
                  // Matriz de op‡oes e mensagens.
                  PRIVATE vops[nop3,2]
                  vops[1,1]:="Sint‚tico    "
                  vops[2,1]:="Anal¡tico    "
                  vops[1,2]:="Emiss„o do Relat¢rio Sint‚tico dos D‚bitos Banc rios"
                  vops[2,2]:="Emiss„o do Relat¢rio Anal¡tico dos D‚bitos Banc rios"
                  // Constru‡ao do menu atrav‚s da fun‡ao Fmenu().
                  m3:=Fmenu(lin3,col3,nop3,vops)
                  IF m3#0
                     Relmba(m3)
                  ELSE
                     EXIT
                  ENDIF
                  // Reapresenta a tela.
                  RESTSCREEN(01,00,24,79,vt3) 
               ENDDO
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Menu de n¡vel 2: Consulta ao Saldo das Contas Correntes.
         Conscc()
      ELSEIF m1=4
         // Menu de n¡vel 2: Consulta gerencial na tela.
         Consger()
      ELSEIF m1=5
         // Menu de n¡vel 2: Fechamento.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=3
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Mensal       "
            vops[2,1]:="Anual        "
            vops[3,1]:="Relat¢rios   "
            vops[1,2]:="Fechamento do Mˆs em Processamento"
            vops[2,2]:="Fechamento do Ano e Grava‡„o de Arquivos Hist¢ricos"
            vops[3,2]:="Emiss„o de Relat¢rios Consolidados"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2=1
               Fechames()
            ELSEIF m2=2
               Fechaano()
            ELSEIF m2=3
               Relfch()
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ENDIF
   ELSEIF mp=6
      // Quinta op‡ao do menu principal - Utilit rios do sistema.
      SETCOLOR(vci)
      @ 03,   58 SAY "Utilit rios"
      SETCOLOR(vcn)
      // Linha, coluna e n£mero de op‡oes do menu.
      lin1:=4;col1:=58;nop1:=10
      // Vetores de op‡oes e mensagens.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Indices      "
      vop[2]:="Tabelas      "
      vop[3]:="Parƒmetros   "
      vop[4]:="Reorganiza‡„o"
      vop[5]:="Back-Up      "
      vop[6]:="Recupera‡„o  "
      vop[7]:="Impressora   "
      vop[8]:="Cores        "
      vop[9]:="Usuarios     "
      vop[10]:="Empresa     "
      vme[1]:="Manuten‡„o da Tabela de Indices de Corre‡„o e do D¢lar"
      vme[2]:="Manuten‡„o das Tabelas do Sistema"
      vme[3]:="Manuten‡„o dos Parƒmetros de Processamento do Sistema"
      vme[4]:="Indexa‡„o dos Arquivos do Sistema"
      vme[5]:="Grava‡„o de C¢pias de Seguran‡a em Disquetes"
      vme[6]:="Recupera‡„o das C¢pias de Seguran‡a dos Disquetes"
      vme[7]:="Configura‡„o da Impressora Utilizada"
      vme[8]:="Configura‡„o das Cores da Tela"
      vme[9]:="Cadastro de usuarios p/. o sistema"
      vme[10]:="Configura‡„o dos Dados da Empresa"
      Caixa(lin1,col1,lin1+nop1+1,col1+14,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Constr¢i e apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+13,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a op‡ao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Manutencao das Tabelas de Indice do Sistema.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=2
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="D¢lar        "
            vops[2,1]:="Indice       "
            vops[1,2]:="Manuten‡„o da Tabela do D¢lar"
            vops[2,2]:="Manuten‡„o da Tabela do Indice de Corre‡„o"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               // Manuten‡ao de Tabelas.
               Matind(m2)
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=2
         // Manutencao das Tabelas do sistema.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=3
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Produtos     "
            vops[2,1]:="Bancos       "
            vops[3,1]:="Pagamentos   "
            vops[1,2]:="Manuten‡„o da Tabela de Grupos de Produtos"
            vops[2,2]:="Manuten‡„o da Tabela de Bancos"
            vops[3,2]:="Manuten‡„o da Tabela de Tipo de Pagamento"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               // Manuten‡ao de Tabelas.
               Tabela(m2)
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=3
         // Defini‡„o dos Parƒmetros de Processamento do Sistema.
         Param()
      ELSEIF m1=4
         // Indexa‡ao dos arquivos de dados (SAOBIB.PRG)
         Indexa()
      ELSEIF m1=5
         // Grava‡ao de c¢pias de seguran‡a em disquetes.
         Backup()
      ELSEIF m1=6
         // Recupera‡ao das c¢pias para o disco r¡gido.
         Recup()
      ELSEIF m1=7
         // Configura‡ao de impressoras.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=6
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Emilia PC    "
            vops[2,1]:="Rima Padr„o  "
            vops[3,1]:="Rima Itautec "
            vops[4,1]:="Elgin        "
            vops[5,1]:="Epson MX, FX "
            vops[6,1]:="Epson LX-810 "
            vops[1,2]:="Impressoras Elebra: Monica, Emilia PC/PS, Diana, etc."
            vops[2,2]:="Impressoras Rima Padr„o: XT180, XT250, XT300, XT500, etc."
            vops[3,2]:="Impressoras Rima Itautec"
            vops[4,2]:="Impressoras Elgin: Amelia PC, etc."
            vops[5,2]:="Impressoras Epson: MX, FX, EX, etc."
            vops[6,2]:="Impressoras Epson: LX-810 ou T-2000"
            // Apresenta e executa o menu atrav‚s da fun‡ao Fmenu().
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               // Configura‡ao da impressora (SAOUTI.PRG).
               Confimp(m2)
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=8
         // Configura‡ao de cores da tela.
         vt2:=SAVESCREEN(01,00,24,79)
         lin2:=lin1+1+m1;col2:=col1+4;nop2:=6
         DO WHILE .T.
            // Matriz de op‡oes.
            PRIVATE vops[nop2,2]
            vops[1,1]:="Monocrom tico"
            vops[2,1]:="Azul         "
            vops[3,1]:="Verde        "
            vops[4,1]:="P£rpura      "
            vops[5,1]:="Vermelho     "
            vops[6,1]:="LCD          "
            vops[1,2]:="Padr„o de Cores para monitores monocrom ticos"
            vops[2,2]:="Padr„o de Cores com Azul"
            vops[3,2]:="Padr„o de Cores com Verde"
            vops[4,2]:="Padr„o de Cores com P£rpura"
            vops[5,2]:="Padr„o de Cores com Vermelho"
            vops[6,2]:="Padr„o de Cores para monitores de Cristal L¡quido"
            // Apresenta e executa o menu.
            m2:=Fmenu(lin2,col2,nop2,vops)
            IF m2#0
               // Configura‡ao das cores (SAOUTI.PRG).
               Confcor(m2)
            ELSE
               EXIT
            ENDIF
            RESTSCREEN(01,00,24,79,vt2) 
         ENDDO
      ELSEIF m1=9
         //Confemp()
      ELSEIF m1=10
         Confemp()
      ENDIF
   ELSEIF mp=7
      // Ultima op‡ao do menu principal.
      SETCOLOR(vci)
      @ 03,   72 SAY "Fim"
      SETCOLOR(vcn)
      lin1:=4;col1:=72;nop1:=2
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="N„o"
      vop[2]:="Sim"
      vme[1]:="N„o Finaliza, Retorna ao Menu"
      vme[2]:="Finaliza, Retorna ao Sistema Operacional"
      Caixa(lin1,col1,lin1+nop1+1,col1+4,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[m1])
      op:=m1
      SETCOLOR(vcm)
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+3,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=2
         EXIT
      ELSEIF m1=1
         mp:=1
      ENDIF
   ENDIF
   // Retorna ao in¡cio do DO WHILE do menu principal para reapresent -lo.
ENDDO
// Fim das opera‡oes.
Abrejan(4)
SETCOLOR(vcp)
Aviso(11,"  Aten‡„o !  ")
SETCOLOR(vca)
Aviso(13," N„o Esque‡a de Atualizar suas C¢pias de Seguran‡a ! ")
SETCOLOR(vcn)
// Salva as variaveis de configuracao do ambiente de trabalho.
SAVE ALL LIKE vc* TO SAO.CFG
INKEY(2)
@ 02,00 CLEAR
Caixa(08,00,15,79,frame[4])
SETCOLOR(vcr)
@ 15, 02 SAY " AGV "
@ 15, 71 SAY " Jair "
SETCOLOR(vcp)
Beep(2)
Aviso(11," Fim das Opera‡”es ! ")
SETCOLOR(vcn)
INKEY(3)
CLOSE DATABASE
SETCOLOR(vca)
Aviso(13," Obrigado ! ")
SETCOLOR(vcn)
CLEAR
SETCURSOR(1)
RETURN
********************************************************************************
FUNCTION Fch(modo,lin)
/*
Objetivo__: faz parte da fun‡ao ACHOICE() que constr¢i o primeiro n¡vel de menus.
Parƒmetros: modo: estado da fun‡ao ACHOICE()
            lin:  linha sobre a qual est  a barra seletora.
*/
********************************************************************************
IF modo=3
   IF LASTKEY()=13
      // Pressionada a tecla <Enter> - finaliza com uma escolha.
      RETURN(1)
   ELSEIF LASTKEY()=27
      // Pressionada a tecla <Esc> - finaliza sem escolher.
      RETURN(0)
   ELSEIF LASTKEY()=4
      // Pressionada a tecla para a direta - desloca o menu.
      IF mp<7
         mp++
      ELSE
         mp:=1
      ENDIF
      m:=1;op:=1
      // Finaliza.
      RETURN(0)
   ELSEIF LASTKEY()=19
      // Pressionada a tecla para a esquerda - desloca o menu.
      IF mp=1
         mp:=7
      ELSE
         mp--
      ENDIF
      m:=1;op:=1
      // Finaliza.
      RETURN(0)
   ELSE
      // Pressionada qualquer outra tecla - continua o menu.
      RETURN(3)
   ENDIF
ELSE
   /* Em qualquer outro caso apresenta a mensagem de orienta‡ao na
      linha 24.*/
   @ 24,00 CLEAR
   Aviso(24,vme[lin])
   RETURN(2)
ENDIF
********************************************************************************
FUNCTION Fmenu(lin,col,nop,vp)
/*
Objetivo__: apresenta um menu de n¡vel inferior ao prim rio.
Parƒmetros:   lin => linha inicial do menu
              col => coluna inicial do menu
              nop => numero de op‡oes
              vp  => matriz de op‡oes
*/
********************************************************************************
LOCAL mx
@ 24,00 CLEAR
// Constr¢i a moldura do menu (Caixa() SAOBIB.PRG)
Caixa(lin,col,lin+nop+1,col+14,frame[6])
SETCOLOR(vcm)
// Monta as op‡oes do menu.
FOR i=1 TO nop
    @ lin+i,col+1 PROMPT vp[i,1] MESSAGE vp[i,2]
NEXT
// Aguarda a escolha da op‡ao.
MENU TO mx
SETCOLOR(vcn)
@ 24,00 CLEAR
// Retorna a op‡ao escolhida.
RETURN(mx)
********************************************************************************
STATIC FUNCTION Matmenu(lin,col)
LOCAL mx
/* Apresenta um Menu
   lin => linha inicial do menu
   col => coluna inicial do menu
*/
@ 24,00 CLEAR
Caixa(lin,col+4,lin+6,col+18,frame[6])
SETCOLOR(vcm)
@ lin+1,col+5 PROMPT "Inclus„o     " MESSAGE "Inclus„o de Novos Registros no Arquivo"
@ lin+2,col+5 PROMPT "Altera‡„o    " MESSAGE "Altera‡„o de Dados nos Registros Cadastrados"
@ lin+3,col+5 PROMPT "Exclus„o     " MESSAGE "Exclus„o de Registros Cadastrados"
@ lin+4,col+5 PROMPT "Consultas    " MESSAGE "Consultas aos Registros Cadastrados"
@ lin+5,col+5 PROMPT "Relat¢rios   " MESSAGE "Emiss„o de Relat¢rios na Impressora"
MENU TO mx
SETCOLOR(vcn)
@ 24,00 CLEAR
RETURN(mx)
*******************************************************************************
//                                   F  i  m
*******************************************************************************
