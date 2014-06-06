#include <minigui.ch>
#include <miniprint.ch>
#include <winprint.ch>

// Measure Units Are Millimeters
Memvar aColor, aliasado, nHandle, aLin, cFiltroBrowse, cMencaoA
Memvar bColumnColor1, bColumnColor2, bColumnColor3
Memvar bColumnColor4, bColumnColor5, bColumnColor6
Memvar bColumnColor7, bColumnColor8, bColumnColor9
Memvar bColumnColor10, bColumnColor11, bColumnColor12
Memvar bColumnColor13, bColumnColor14, bColor, c_pastaFotos
Memvar aLabelsEdit, aCamposEdit, aCamposTip, cFormAnterior, cAliasTab, cAliasBrowse
Memvar aBrowseCampos, aBrowseHeaders, aBrowseWidths, aBrowseIndex, aExecutaExclui
Memvar aGridCampos, aGridHeaders, aGridWidths, aGridColValid, aGridColWhen, lAlteraGrid
Memvar aGridPesquisa, bgridBotoes, cBrowseTitulo, cBrowsePesquisa, aList, aTab, aExecutaIncAlt
Memvar aBotoesFuncoes, cEmpresa, aGridColumnControl, cFormAtivo, pCampo1, cCodFuncionario, tInicial
Memvar cCodCargo, aRelatTab, aRelatBrowse, cAnoLetivoAtual, cBimestreAtual, nTabPage
Memvar CNOTAFINAL, CNOTA4BIM, CNOTA3BIM, CNOTA2BIM, CNOTA1BIM, NTOTALBIMPROFCLASSE, NTOTALBIMNOTACLASSE
Memvar NTOTALANUALPROFALUNO, NTOTALANUALNOTAALUNO, NTOTALANUALPROFCLASSE, NTOTALANUALNOTACLASSE
Memvar NTOTALANUALALUNOFALTAS, CFALTAS4BIM, CFALTAS3BIM, CFALTAS2BIM, CFALTAS1BIM, nTotalBimAlunoFaltas, dDtLimBimAtual
Memvar NCONTAPROFATRIBUICAO, NTOTALBIMPROF, NTOTALBIMALUNONOTAS, dDtIniBimAtual, nSomaQuestoesBranco, lTemGabarito, c_MargemSuperior, c_MargemEsquerda
Memvar cMencaoB, cMencaoC, cMencaoD, cMencaoE, cMencaoF, cMencaoG, cMencaoH
Memvar cMencaoI, cMencaoJ, cMencaoK, cMencaoL
Memvar nColunaMencaoInicio, nColunaMencaoFim, x, cLetras

//---------------------------------------------------------------------------
function imprimir(cArquivo)
//---------------------------------------------------------------------------
Local i, lSuccess
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE
if cArquivo = "CARTEIRINHA"
   cFormAnterior:=cFormAtivo
   cFormAtivo:="FrmImpressao"
   cAliasBrowse:=cAliasTab:='setor'
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 429 HEIGHT 100 TITLE "Impressão de Carteirinhas" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    11
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Série "
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL

      DEFINE TEXTBOX TxtSerie
         ROW    10
         COL    60
         WIDTH  60
         HEIGHT 20
         FONTNAME "Verdana"
         FONTSIZE 8
         UPPERCASE .T.
         FONTBOLD .T.
      end TEXTBOX
   
      DEFINE LABEL &("Label_99"+cFormAtivo+"01")  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99?
         ROW    11
         COL    127
         WIDTH  230
         HEIGHT 20
         *BACKCOLOR {153,153,153}
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
      END LABEL
      DEFINE BUTTON ButCon
         ROW    10
         COL    390
         WIDTH  15
         HEIGHT 19
         CAPTION "P"
         ACTION Consulta("SETOR",{"TxtSerie","setor->set_codigo"}, "setor->set_descri", .f., 1, 1, {})
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
         TRANSPARENT .T.
         TABSTOP .F.
      END BUTTON
      DEFINE BUTTON ButConfirma
         ROW    37
         COL    125
         WIDTH  85
         HEIGHT 25
         CAPTION "OK"
         ACTION Carteirinha()
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    37
         COL    235
         WIDTH  85
         HEIGHT 25
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 8
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
   cFormAtivo:=cFormAnterior
elseif cArquivo = "NOTAS" 
   imp_tarjeta()
elseif cArquivo = "CONTRATO"
   imp_contrato()
elseif cArquivo $ "RESULTFINAL"
   ImpResultadoAnoLetivoFinal()
elseif cArquivo $ "LISTACLASSE"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE COMBOBOX Combo_Mes
        ROW    10
        COL    10
        WIDTH  260
        HEIGHT 120
        ITEMS {"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 8
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        TABSTOP .T.
        VISIBLE .T.
        SORT .F.
        DISPLAYEDIT .F.
      END COMBOBOX

      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpListadeClasse()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "PROFESSOR"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    10
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Professor: "
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL
      DEFINE TEXTBOX TxtProfessor
         ROW    10
         COL    65
         WIDTH  50
         HEIGHT 13
         FONTNAME "Verdana"
         FONTSIZE 6
         UPPERCASE .T.
         FONTBOLD .T.
         VALUE ""
      end TEXTBOX
      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpAvaliacaoResultadoAnaliseProfessor()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    90
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "AVALIACAO"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      Define CheckBox Chk_01
      	 Row		15
      	 Col		30
      	 Width	180
      	 HEIGHT  15
      	 Value	.F.
          FONTNAME "Verdana"
          FONTSIZE 7
          FONTBOLD .T.
          Caption "Imprime Somente Nota Geral" 
          *BACKCOLOR {255,255,255}
          TRANSPARENT .T. 
      End CheckBox

      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION MARCELOespecifico()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "DEVOLUTIVA"
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 290 HEIGHT 100 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr1
         ROW    10
         COL    8
         WIDTH  60
         HEIGHT 20
         VALUE "Série "
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
         TRANSPARENT .T.
      end LABEL
      DEFINE TEXTBOX TxtSerie
         ROW    10
         COL    65
         WIDTH  50
         HEIGHT 13
         FONTNAME "Verdana"
         FONTSIZE 6
         UPPERCASE .T.
         FONTBOLD .T.
         VALUE ""
      end TEXTBOX
      DEFINE BUTTON ButConfirma
         ROW    45
         COL    30
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION ImpResultadoAvaliacaoDevolutivaAluno()
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
      DEFINE BUTTON ButCancela
         ROW    45
         COL    85
         WIDTH  55
         HEIGHT 14
         CAPTION "Cancela"
         ACTION FrmImpressao.release
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
elseif cArquivo $ "MAPAO"
   if msgyesno("Deseja imprimir versão para digitação, com caracteres maiores? (Para imprimir, escolha orientação retrato)")
      ImpResultadosAvaliacao2()
   else
      ImpMapao()   //ImpResultadosAvaliacao1()
   endif   
elseif cArquivo $ "BOLETIM"
   ImpBoletim()
endif
return nil

*------------------------------------------------------------------------------*
Procedure Carteirinha()
*------------------------------------------------------------------------------*
Local nOrdAntAlunos, nOrdAntProdutos, lSuccess, nstartPrint:=0, nContaCarteirinha:=0
limparelacoes()
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
setor->(dbsetorder(1))  //ordem do código de referência do setor dado pelo operador (não do código do sistema)
alunos->(dbsetorder(1))  //ordem de codigo
turmas->(dbsetorder(2)) //TURMAS->TUR_EMPRE+TURMAS->TUR_SETOR+TURMAS->TUR_ANO+TURMAS->TUR_CHAMAD+TURMAS->TUR_ALUNO

START PRINTDOC
START PRINTPAGE

setor->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))

do while !turmas->(eof()) .and. alltrim(turmas->tur_setor)==alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if nContaCarteirinha=4
      END PRINTPAGE
      START PRINTPAGE
      nStartPrint:=nContaCarteirinha:=0
   endif
   if alltrim(turmas->tur_status) = "MATRICULADO(A)"
      alunos->(dbseek(cEmpresa+turmas->tur_aluno))
      @ nStartPrint+05,005 PRINT RECTANGLE TO nStartPrint+065,100 PENWIDTH 0.1
      @ nStartPrint+05,102 PRINT RECTANGLE TO nStartPrint+065,197 PENWIDTH 0.1
   
      @ nStartPrint+07,18 PRINT alltrim(empresa->emp_nome) FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+12,18 PRINT rtrim(empresa->emp_rua)+", "+rtrim(empresa->emp_numero)+" - "+rtrim(empresa->emp_bairro) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+16,18 PRINT rtrim(empresa->emp_cidade)+"-"+rtrim(empresa->emp_estado)+" Tel.: "+rtrim(empresa->emp_tel)    FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+21,08 PRINT "R.G. / Org.Exp. / U.F.                       Data Nascimento" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+26,08 PRINT RECTANGLE TO nStartPrint+29,54 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+26,59 PRINT RECTANGLE TO nStartPrint+29,98 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+26,08 PRINT alltrim(alunos->alu_rgnral)+" / "+alltrim(alunos->alu_rgoral)+" / "+alltrim(alunos->alu_rgufal) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+26,59 PRINT alunos->alu_nasc FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+34,08 PRINT "Válido até" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+39,08 PRINT RECTANGLE TO nStartPrint+42,54 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+39,08 PRINT "31/12/"+alltrim(empresa->emp_ano) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+52,08 PRINT "É importante  a apresentação desta" FONT "arial" SIZE 8 BOLD COLOR aColor[3]
      @ nStartPrint+57,08 PRINT "identidade no momento da entrada"   FONT "arial" SIZE 8 BOLD COLOR aColor[3]
      @ nStartPrint+34,59 PRINT "Direção" FONT "arial" BOLD SIZE 9 COLOR aColor[9]
      @ nStartPrint+38,58 PRINT RECTANGLE TO nStartPrint+63,99 PENWIDTH 0.1 COLOR aColor[7]
   
      @ nStartPrint+08.7,122.7 PRINT "CARTEIRA DE ESTUDANTE" FONT "arial" SIZE 14 BOLD COLOR {225,225,225}
      @ nStartPrint+08,122 PRINT "CARTEIRA DE ESTUDANTE" FONT "arial" SIZE 14 BOLD COLOR aColor[9]
      @ nStartPrint+15,128 PRINT "(RA ESCOLAR)" FONT "arial" SIZE 11 BOLD COLOR aColor[9]
      @ nStartPrint+28,104 PRINT iif(alunos->alu_sexo=="M","Aluno",iif(alunos->alu_sexo=="F","Aluna","Aluno(a)")) SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+33,104 PRINT RECTANGLE TO nStartPrint+36,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+33,104 PRINT substr(alunos->alu_nome,1,29) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+38,104 PRINT RECTANGLE TO nStartPrint+41,163 PENWIDTH 3 COLOR aColor[7]
   
      @ nStartPrint+38,104 PRINT alltrim(substr(alunos->alu_nome,30)) FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+45,104 PRINT "Nº                             Série/Turma" FONT "arial" SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+50,104 PRINT RECTANGLE TO nStartPrint+52,129 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+50,134 PRINT RECTANGLE TO nStartPrint+52,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+49,104 PRINT turmas->tur_chamad FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+49,136 PRINT setor->set_descri  FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+55,104 PRINT "Período                     R.A. " FONT "arial" SIZE 9 BOLD COLOR aColor[9]
      @ nStartPrint+60,104 PRINT RECTANGLE TO nStartPrint+63,129 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+60,134 PRINT RECTANGLE TO nStartPrint+63,163 PENWIDTH 3 COLOR aColor[7]
      @ nStartPrint+60,104 PRINT setor->set_period FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+60,134 PRINT alunos->alu_ra    FONT "arial" SIZE 9 BOLD COLOR aColor[10]
      @ nStartPrint+57,177 PRINT empresa->emp_ano FONT "arial" SIZE 15 BOLD COLOR aColor[9]
      @ nStartPrint+06,103 PRINT IMAGE alltrim(c_PastaFotos)+"\"+alltrim(empresa->emp_logo) WIDTH 10 HEIGHT 20 
      @ nStartPrint+14,165 PRINT IMAGE alltrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto) WIDTH 20 HEIGHT 40 
      nStartPrint+=66
      nContaCarteirinha++
   endif
   turmas->(dbskip(1))
enddo
end printpage
end PRINTDOC
return

*------------------------------------------------------------------------------*
procedure imp_contrato()
*------------------------------------------------------------------------------*
Local nOrdAntAlunos, nOrdAntProdutos, lSuccess, nstartPrint
Private nHandle
nOrdAntAlunos:=alunos->(dbsetorder())
nOrdAntProdutos:=produtos->(dbsetorder())
alunos->(dbsetorder(1))  //ordem de código
alunos->(dbseek(cEmpresa+contrato->contr_alu))
produtos->(dbsetorder(1)) //ordem de codigo
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   alunos->(dbsetorder(nOrdAntAlunos))
   produtos->(dbsetorder(nOrdAntProdutos))
   return
endif
if (nHandle:=fCreate("texto.txt")) == -1
   msginfo("Erro ao criar arquivo. Veja se não está em uso, se a pasta c:\escola está criada e você tem direito de acesso a ela.")
   return
endif
if ((date()-alunos->alu_nasc)/365)<18
   DEFINE WINDOW FrmImpressao AT 50,50 WIDTH 390 HEIGHT 200 TITLE "Impressão" MODAL NOSIZE 
      DEFINE LABEL LblImpr0
         ROW    5
         COL    8
         WIDTH  300
         HEIGHT 25
         VALUE "O aluno é menor de 18 anos. Gerando contrato com dados do responsável cadastrado."
         FONTNAME "Verdana"
         FONTSIZE 7
         FONTBOLD .T.
      end LABEL
      DEFINE BUTTON Confirma
         ROW    55
         COL    75
         WIDTH  55
         HEIGHT 14
         CAPTION "OK"
         ACTION writeform(.t.)
         FONTNAME "Verdana"
         FONTSIZE 6
         FONTBOLD .T.
      end BUTTON
   end WINDOW
   FrmImpressao.Center
   ACTIVATE WINDOW FrmImpressao
else
   writeform(.f.)
endif
return
//----------------------------------------------------------------------------------------
procedure writeform(lMenor)
//----------------------------------------------------------------------------------------
if lMenor
   fwrite(nHandle, alltrim(alunos->alu_respon)+chr(13)+chr(10))
else
   fwrite(nHandle, alltrim(alunos->alu_nome)+chr(13)+chr(10))
endif
fwrite(nHandle, alltrim(alunos->alu_nacres)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_prores)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_civres)+chr(13)+chr(10))
if lMenor
   fwrite(nHandle, alltrim(alunos->alu_rgnrre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgorre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgufre)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_cpfres)+chr(13)+chr(10))
else
   fwrite(nHandle, alltrim(alunos->alu_rgnral)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgoral)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_rgufal)+chr(13)+chr(10))
   fwrite(nHandle, alltrim(alunos->alu_cpfalu)+chr(13)+chr(10))
endif
fwrite(nHandle, alltrim(alunos->alu_end)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_nro)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_bairro)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_cep)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_cidade)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_estado)+chr(13)+chr(10))
fwrite(nHandle, dtoc(contrato->contr_dtin)+chr(13)+chr(10))
fwrite(nHandle, dtoc(contrato->contr_dtfi)+chr(13)+chr(10))
fwrite(nHandle, alltrim(alunos->alu_nome)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_tes1)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_rgt1)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_tes2)+chr(13)+chr(10))
fwrite(nHandle, alltrim(contrato->contr_rgt2)+chr(13)+chr(10))
fwrite(nHandle, alltrim(produtos->pro_descri)+chr(13)+chr(10))
fwrite(nHandle, alltrim(str(produtos->pro_preco))+chr(13)+chr(10))
fclose(nHandle)
return

*------------------------------------------------------------------------------*
Procedure ImpListadeClasse()
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif
START PRINTDOC
   START PRINTPAGE
      nStartPrint:=0
      @ nStartPrint+08,05 PRINT RECTANGLE TO nStartPrint+25,200 PENWIDTH 0.1
      @ nStartPrint+10,07 PRINT empresa->emp_codigo+" - "+empresa->emp_nome FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+15,07 PRINT "LISTA DE CLASSE - "+getproperty("FrmImpressao","Combo_Mes","item",GetProperty("FrmImpressao","Combo_Mes", "value"))+"/"+cAnoLetivoAtual  FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+20,07 PRINT "TURMA: "+setor->set_codigo+" - "+alltrim(setor->set_descri) FONT "arial" SIZE 10 BOLD COLOR aColor[9]
      @ nStartPrint+30,6 PRINT "Código Nº  Nome do Aluno"  FONT "arial" SIZE 7 BOLD COLOR aColor[9]
      for i = 1 to 31
         @ nStartPrint+30,65+((i*4)+1) PRINT RECTANGLE TO nStartPrint+34,65+((i*4)+5) PENWIDTH 0.1
         @ nStartPrint+32,65+((i*4)+2) PRINT STRZERO(I,2,0) FONT "arial" SIZE 5 COLOR aColor[9]
      next i   
      nStartPrint:=35
      TURMAS->(DBGOTOP())
      do while !turmas->(eof())
         if turmas->tur_setor=setor->set_codigo
            *if empty(alunos->alu_foto) .AND. ALLTRIM(TURMAS->TUR_STATUS)="MATRICULADO(A)"
               @ nStartPrint,05 PRINT RECTANGLE TO nStartPrint+4,63 PENWIDTH 0.1
               @ nStartPrint+1,07 PRINT alunos->alu_codigo+" -  "+turmas->tur_chamad+"   "+alunos->alu_nome FONT "arial" SIZE 5 BOLD COLOR aColor[9]
               for i = 1 to 31
                  @ nStartPrint,65+((i*4)+1) PRINT RECTANGLE TO nStartPrint+4,65+((i*4)+5) PENWIDTH 0.1
               next i   
               nStartPrint+=5
            *endif   
         endif
         turmas->(dbskip(1))
      enddo
   end PRINTPAGE
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure ImpResultadoAnoLetivoFinal() //Imprime 5º conceito e menção final (aprovado, retido..., etc)
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt, x:=0, cObserva:=""
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif

limparelacoes()

atribuir->(dbsetorder(2)) //ordem de setor e ordem de materia
cargos->(dbsetorder(1))
conselho->(dbsetorder(2))
consitem->(dbsetorder(2))
turmas->(dbsetorder(2))
alunos->(dbsetorder(1))
setor->(dbsetorder(1))
setor->(dbgotop())

start printdoc
   do while !setor->(eof())
      if !setor->set_ehaula
         setor->(dbskip(1))
         loop
      endif
      start printpage
         nStartPrint:=5
         @ nStartPrint+04,07 PRINT alltrim(empresa->emp_nome)+" - RESULTADOS FINAIS (5º CONCEITO) - Ano "+cAnoLetivoAtual+" - TURMA: "+alltrim(setor->set_descri) FONT "arial" SIZE 7 BOLD COLOR aColor[9]
         @ nStartPrint+09.5,7 PRINT "Nº   Nome do Aluno" FONT "arial" SIZE 6 BOLD COLOR aColor[9]
         x:=0
         atribuir->(dbseek(cEmpresa+setor->set_codigo))
         do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
            x++
            cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
            @ nStartPrint+10,36+(x*5) print alltrim(cargos->car_resumo) FONT "arial" SIZE 5.7 BOLD COLOR aColor[9]
            atribuir->(dbskip(1))
         enddo  
         nStartPrint:=18
         turmas->(dbseek(cEmpresa+setor->set_codigo))
         do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
            conselho->(dbseek(cEmpresa+cAnoLetivoAtual+turmas->tur_setor+cBimestreAtual))
            consitem->(dbseek(cEmpresa+conselho->con_codigo+turmas->tur_chamad+turmas->tur_aluno))
            alunos->(dbseek(cEmpresa+turmas->tur_aluno))

            @nstartprint+1,07 print turmas->tur_chamad+"   "+substr(alunos->alu_nome,1,20) font "arial" size 6 bold color acolor[9]

            atribuir->(dbseek(cempresa+turmas->tur_setor))
            x:=0
            do while !atribuir->(eof()) .and. atribuir->atr_setor = turmas->tur_setor
               x++
               if notas->(dbseek(cempresa+turmas->tur_setor+atribuir->atr_funcio+atribuir->atr_cargo+canoletivoatual+"5"+turmas->tur_chamad+turmas->tur_aluno))
                  @ nstartprint+1,37+(x*5) print if(empty(alltrim(notas->not_nota)),"-",notas->not_nota) font "arial" size 6 bold color if(val(notas->not_nota)>=5, acolor[11],acolor[3])
               else
                  @ nstartprint+1,37+(x*5) print "-" font "arial" size 6 bold color acolor[9]
               endif                     
               atribuir->(dbskip(1))
            enddo  
            cobserva:=consitem->cit_observ
            @ nstartprint+1,40+(x*5) print if(consitem->cit_situac=0,"",if(consitem->cit_situac=1,"",if(consitem->cit_situac=2,"promovido(a)",if(consitem->cit_situac=3,"retido(a)",if(consitem->cit_situac=4, "promovido(a) parcialmente (veja dependência em vermelho)",if(consitem->cit_situac=5,"promovido(a) pelo conselho (veja conceitos vermelhos)","promovido(a) pela progressão continuada (veja conceitos vermelhos)"))))))+if(empty(alltrim(cobserva)),""," "+alltrim(cobserva))+if(substr(turmas->tur_status,1,5)$"recla@trans@reman@"," transferido(a)",if(substr(turmas->tur_status,1,5)$"evadi"," evadido(a)","")) font "arial" size 6 bold color acolor[9]
            nstartprint+=3
            turmas->(dbskip(1))
         enddo
      end printpage
      setor->(dbskip(1))
   enddo
end printdoc
return 

*------------------------------------------------------------------------------*
Procedure imp_tarjeta()
*------------------------------------------------------------------------------*
Local i, lSuccess, nStartPrint, nOrdAnt, ncontaAlunos, cFuncionarioNome, nNotaChamada
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   alunos->(dbsetorder(nOrdAnt))
   return
endif
START PRINTDOC
   START PRINTPAGE
      nStartPrint:=0
      @ nStartPrint+04,05 PRINT RECTANGLE TO nStartPrint+8,15 PENWIDTH 0.1
      @ nStartPrint+05,06 PRINT "ANO"  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+04,15 PRINT RECTANGLE TO nStartPrint+8,25 PENWIDTH 0.1
      @ nStartPrint+05,16 PRINT "BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+08,05 PRINT RECTANGLE TO nStartPrint+12,15 PENWIDTH 0.1
      @ nStartPrint+09,06 PRINT cAnoLetivoAtual FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+08,15 PRINT RECTANGLE TO nStartPrint+12,25 PENWIDTH 0.1
      @ nStartPrint+09,16 PRINT cBimestreAtual  FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+12,05 PRINT RECTANGLE TO nStartPrint+16,25 PENWIDTH 0.1
      @ nStartPrint+13,06 PRINT " CLASSE " FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,05 PRINT RECTANGLE TO nStartPrint+20,10 PENWIDTH 0.1
      @ nStartPrint+17,06 PRINT "T" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,10 PRINT RECTANGLE TO nStartPrint+20,15 PENWIDTH 0.1
      @ nStartPrint+17,11 PRINT "G" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,15 PRINT RECTANGLE TO nStartPrint+20,20 PENWIDTH 0.1
      @ nStartPrint+17,16 PRINT "S" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+16,20 PRINT RECTANGLE TO nStartPrint+20,25 PENWIDTH 0.1
      @ nStartPrint+17,21 PRINT "t" FONT "arial" SIZE 7 COLOR aColor[9]

      produtos->(dbseek(cEmpresa+setor->set_PRODUT))
      cargos->(dbseek(cEmpresa+cCodCargo))
      @ nStartPrint+20,05 PRINT RECTANGLE TO nStartPrint+24,10 PENWIDTH 0.1
      @ nStartPrint+21,06 PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,10 PRINT RECTANGLE TO nStartPrint+24,15 PENWIDTH 0.1
      @ nStartPrint+21,11 PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,15 PRINT RECTANGLE TO nStartPrint+24,20 PENWIDTH 0.1
      @ nStartPrint+21,16 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+20,20 PRINT RECTANGLE TO nStartPrint+24,25 PENWIDTH 0.1
      @ nStartPrint+21,21 PRINT substr(alltrim(setor->set_descri),2,2) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartPrint+24,05 PRINT RECTANGLE TO nStartPrint+28,25 PENWIDTH 0.1
      @ nStartPrint+25,06 PRINT "COMP.CUR." FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+28,05 PRINT RECTANGLE TO nStartPrint+32,25 PENWIDTH 0.1
      @ nStartPrint+29,06 PRINT cargos->car_compon FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,05 PRINT RECTANGLE TO nStartPrint+36,10 PENWIDTH 0.1
      @ nStartPrint+33,06 PRINT "Nº" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,10 PRINT RECTANGLE TO nStartPrint+36,15 PENWIDTH 0.1
      @ nStartPrint+33,11 PRINT "M" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,15 PRINT RECTANGLE TO nStartPrint+36,20 PENWIDTH 0.1
      @ nStartPrint+33,16 PRINT "F" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+32,20 PRINT RECTANGLE TO nStartPrint+36,25 PENWIDTH 0.1
      @ nStartPrint+33,21 PRINT "AC" FONT "arial" SIZE 7 COLOR aColor[9]

      nStartPrint:=36
      NOTAS->(DBGOTOP())
      nContaAlunos:=0
      do while !notas->(eof())
         if notas->not_setor=setor->set_codigo
            @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
            @ nStartPrint+1,06 PRINT notas->not_chamad FONT "arial" SIZE 7 COLOR aColor[9]

            @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,15 PENWIDTH 0.1
            @ nStartPrint+1,11 PRINT notas->not_nota FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 

            @ nStartPrint  ,15 PRINT RECTANGLE TO nStartPrint+4,20 PENWIDTH 0.1
            @ nStartPrint+1,16 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]

            @ nStartPrint  ,20 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
            @ nStartPrint+1,21 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]
            nNotaChamada:=val(notas->not_chamad)
            nStartPrint+=4
            nContaAlunos++
         endif
         notas->(dbskip(1))
      enddo      
      for i = 0 to (55-nContaAlunos)
         @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
         @ nStartPrint+1,06 PRINT strzero(nNotaChamada++,2,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,15 PENWIDTH 0.1
         @ nStartPrint  ,15 PRINT RECTANGLE TO nStartPrint+4,20 PENWIDTH 0.1
         @ nStartPrint  ,20 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1
         nStartPrint+=4
      next i
      @ nStartPrint   ,05 PRINT RECTANGLE TO nStartPrint+30,25 PENWIDTH 0.1
      @ nStartPrint+1 ,06 PRINT "Rubr.Prof."      FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+5 ,06 PRINT substr(cFuncionarioNome,8)  FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+12,06 PRINT "Aulas Previstas:" FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartPrint+20,06 PRINT "Aulas Dadas:"     FONT "arial" SIZE 7 COLOR aColor[9]
   end PRINTPAGE
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure ImpAvaliacaoResultadoAnaliseProfessor() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msginfo("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         if gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
             lTemGabarito:=.t.
             for i = 1 to val(avaliar->av_nroques)
                 if avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
                     if !("CANCELADA"$AVALQUES->AVQ_TPCORR)
                         if i < 10
                            if alltrim(gabarito->&('q'+strzero(i,1,0))) == alltrim(avalques->avq_respo) 
                               arrQuestao[i]++
                            endif   
                            if empty(alltrim(gabarito->&('q'+strzero(i,1,0))))
                               nSomaQuestoesBranco++
                            endif
                         else
                            if alltrim(gabarito->&('q'+strzero(i,2,0))) == alltrim(avalques->avq_respo)
                               arrQuestao[i]++
                            endif                
                            if empty(alltrim(gabarito->&('q'+strzero(i,2,0))))
                               nSomaQuestoesBranco++
                            endif
                         endif
                     else 
                         arrQuestao[i]:=" X"
                         if i < 10
                            if empty(alltrim(gabarito->&('q'+strzero(i,1,0))))
                               nSomaQuestoesBranco++
                            endif
                         else
                            if empty(alltrim(gabarito->&('q'+strzero(i,2,0))))
                               nSomaQuestoesBranco++
                            endif
                         endif
                     endif    
                 else
                     msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - i = "+STRZERO(i,3,0)+". Rotina interrompida.")
                     return 
                 endif   
             next i    
         else
            lTemGabarito:=.f.
         endif
         if !(nSomaQuestoesBranco=val(avaliar->av_nroques)) .and. lTemGabarito
            nSomaParticipantesProva++
         endif   
         nSomaQuestoesBranco:=0   
         turmas->(dbskip(1))
      enddo   
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      nStartPrint:=0

      *MSGBOX("imprimindo fucnionario="+funciona->fun_nome+" - setor="+setor->set_descri+" - nContacoluna="+str(ncontacoluna))
      @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+05,17+(nContaColuna*22) PRINT "Part:"+strzero(nSomaParticipantesProva,2,0) FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,06+(nContaColuna*22) PRINT "Que" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,06+(nContaColuna*22) PRINT "stão " FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,11+(nContaColuna*22) PRINT "Disc" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,11+(nContaColuna*22) PRINT "iplin" FONT "arial" SIZE 6 COLOR aColor[9]
   
      @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
      @ nStartPrint+11,17+(nContaColuna*22) PRINT "Acerto" FONT "arial" SIZE 6 COLOR aColor[9]
      @ nStartPrint+13,17+(nContaColuna*22) PRINT "Sala" FONT "arial" SIZE 6 COLOR aColor[9]
   
      *avaliar->(dbgotop())
      *do while !avaliar->(eof())
      *   if setor->set_codigo$avaliar->av_setor .and. avaliar->av_ano = cAnoLetivoAtual .and. avaliar->av_bim = cBimestreAtual
      *      exit
      *   endif
      *   avaliar->(dbskip())
      *enddo
      *if avaliar->(eof())
      *   msgbox("Não encontrei setor solicitado em Avaliar")
      *   setor->(dbskip(1))
      *   loop
      *endif   
   
      nStartPrint:=15
      *turmas->(dbseek(cEmpresa+setor->set_codigo))
      *gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) 
   
      for x = 1 to val(avaliar->av_nroques)
          avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(x,3,0)))
   
          @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
          @ nStartPrint+1,06+(nContaColuna*22) PRINT strzero(x,2,0) FONT "arial" SIZE 6 COLOR aColor[9]
   
          @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
          @ nStartPrint+1,11+(nContaColuna*22) PRINT substr(avalques->avq_grupo,1,3) FONT "arial" SIZE 6 COLOR aColor[9]
   
          @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
          @ nStartPrint+1,18+(nContaColuna*22) PRINT if(valtype(arrQuestao[x])="N",strzero(arrQuestao[x],2,0),arrQuestao[x]) FONT "arial" SIZE 6 COLOR aColor[9]
          nStartPrint+=3
      next x
      ncontaColuna++
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 


*------------------------------------------------------------------------------*
Procedure testei() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lSuccess, lFiltraProfessor:=.t., nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito,lSohGeral:=getproperty("FrmImpressao","chk_01","value")

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=nStartPrint:=0
   
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 

      for y = 0 to 19  //são 20 grupos por default
         if y = 0  
             @ 05+01,05+y*15 PRINT "GERAL" FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
             @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
             @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
             @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
             @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
             @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
             @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
         endif
         if y > 0 .and. !lSohGeral

*         elseif !lSohGeral
*             @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
*             @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
*             @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),4,1) FONT "arial" SIZE 8 COLOR aColor[9]
*             @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
*             @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
*             @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
*             @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 


            do while !turmas->(eof())  .and. turmas->tur_setor = setor->set_codigo
               resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))

               if lFiltraProfessor
                  if &('resultav->res_nome'+strzero(y,2,0)) == cargos->car_resumo
                     @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                     @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                     @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                     @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                  endif
               else
                  @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                  @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                  @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                  @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
               endif
 *        else
 *           @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
 *           @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
 *           @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
 *           @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
 *        endif
               nStartPrint+=3
               turmas->(dbskip(1))
            enddo
         endif   
      next y      
   
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      nStartPrint:=0
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure ImpResultadosAvaliacao() //imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y, u, lSuccess, lFiltraProfessor:=.f., nStartPrint, ncontaAlunos, lSohGeral:=getproperty("FrmImpressao","chk_01","value")
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nStartPrint:=0
nContaAlunos:=0
atribuir->(dbsetorder(4))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
   
      for i = 1 to 360 step 6
         nStartPrint:=36
         START PRINTPAGE
         if lFiltraProfessor
            @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
         endif
         if !empty(substr(avaliar->av_setor,i,6))
            if turmas->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)+cAnoLetivoAtual))
               setor->(dbseek(cEmpresa+substr(avaliar->av_setor,i,6)))
               do while !turmas->(eof()) .and. turmas->tur_setor = substr(avaliar->av_setor,i,6)
                  resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
                  nContaAlunos++
                  produtos->(dbseek(cEmpresa+setor->set_PRODUT))
                  cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
                  for y = 0 to 19  //são 20 grupos por default
                     if y = 0 .or. lSohGeral 
                         @ 05+01,05+y*15 PRINT "GERAL" FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                         @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                         @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                         @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                         @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                         @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                         @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 
                     endif
                     if y > 0 .and. !lSohGeral
                        if lFiltraProfessor
                           if &('resultav->res_grup'+strzero(y,2,0)) = cargos->car_resumo
                              @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                              @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                              @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                              @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                              @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                              @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                              @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                           endif
                        else
                           @ 05+01,05+y*15 PRINT substr(&('resultav->res_nome'+strzero(y,2,0)),1,11) FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+05,06+y*15 PRINT "ANO/BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+09,06+y*15 PRINT cAnoLetivoAtual+"/"+cBimestreAtual FONT "arial" SIZE 7 COLOR aColor[9]
                           @ 05+21,06+y*15 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
                           @ 05+21,10+y*15 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
                           @ nStartPrint  ,05+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+10 PENWIDTH 0.1
                           @ nStartPrint+1,06+y*15 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9]
                           @ nStartPrint  ,10+y*15 PRINT RECTANGLE TO nStartPrint+4,(y*15)+17 PENWIDTH 0.1
                           @ nStartPrint+1,11+y*15 PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(y,2,0)),5,2),"  -  ") FONT "arial" SIZE 7 COLOR if(&('resultav->res_grup'+strzero(y,2,0))>=5, aColor[11],aColor[3]) 
                        endif
                     endif
                  next y      
                  turmas->(dbskip(1))
                  nStartPrint+=4
               enddo
            endif
            nStartPrint+=3
            for u = 1 to (55-nContaAlunos)
                @ nStartPrint  ,05 PRINT RECTANGLE TO nStartPrint+4,10 PENWIDTH 0.1
                @ nStartPrint+1,06 PRINT strzero(nContaAlunos+u,2,0) FONT "arial" SIZE 7 COLOR aColor[9]
                @ nStartPrint  ,10 PRINT RECTANGLE TO nStartPrint+4,25 PENWIDTH 0.1
                nStartPrint+=4
            next u
           @ nStartPrint   ,05 PRINT RECTANGLE TO nStartPrint+30,25 PENWIDTH 0.1
           @ nStartPrint+1 ,06 PRINT "Rubr.Prof."      FONT "arial" SIZE 7 COLOR aColor[9]
           @ nStartPrint+12,06 PRINT "Aulas Previstas:" FONT "arial" SIZE 7 COLOR aColor[9]
           @ nStartPrint+20,06 PRINT "Aulas Dadas:"     FONT "arial" SIZE 7 COLOR aColor[9]   
         endif
         end PRINTPAGE
         nStartPrint:=0
      next i
      atribuir->(dbskip(1))
   enddo
   funciona->(dbskip(1))
enddo   
end PRINTDOC
//CriaArquivoResultadoAvaliacao()
return

//------------------------------------------------------------------------------
procedure ImpMapao() //menor imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nStartColumn:=35, nContaAlunos, nChamada:=0, cObserva:=""
Local nColunaMencaoInicio:=nColunaMencaoFim:=0, x, cLetrasCausas, cLetrasEncaminhamentos, cLetraMencao, cMencoes, cProfessores
limparelacoes()
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
capabime->(dbsetorder(2))
consitem->(dbsetorder(2))
conselho->(dbsetorder(2))

setor->(dbsetfilter({|| setor->set_ano = cAnoLetivoAtual},"setor->set_ano = cAnoLetivoAtual"))
setor->(dbgotop())
START PRINTDOC

do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PRINTPAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   produtos->(dbseek(cEmpresa+setor->set_PRODUT))

   nStartColumn:=val(c_MargemEsquerda)
   nStartLine:=val(c_MargemSuperior)

   @nStartLine+00,nStartColumn+01 PRINT RECTANGLE TO nStartLine+18,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+02,nStartColumn+02 print "REGISTRO E"  font "arial" bold size 7 color aColor[9]
   @nStartLine+06,nStartColumn+02 print "CONTROLE DO" font "arial" bold size 7 color aColor[9] 
   @nStartLine+10,nStartColumn+02 print "RENDIMENTO " font "arial" bold size 7 color aColor[9]
   @nStartLine+14,nStartColumn+02 print "ESCOLAR"     font "arial" bold size 7 color aColor[9]

   @nStartLine+00 ,nStartColumn+29 PRINT RECTANGLE TO nStartLine+04,nStartColumn+33 PENWIDTH 0.1
   @nStartLine+1.2,nStartColumn+30 PRINT "50" FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+22,nStartColumn+01 PRINT RECTANGLE TO nStartLine+26,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+02 print "10" font "arial" size 6 color aColor[9] 

   @nStartLine+22,nStartColumn+05 PRINT RECTANGLE TO nStartLine+26,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+06 print "Bimestre: "+cBimestreAtual font "arial" size 6 color aColor[9] 

   @nStartLine+26,nStartColumn+05 PRINT RECTANGLE TO nStartLine+30,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+27,nStartColumn+06 print "Média Final" font "arial" size 6 color aColor[9] 

   @nStartLine+30,nStartColumn+05 PRINT RECTANGLE TO nStartLine+34,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+31,nStartColumn+06 print "Recuperação" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+01 PRINT RECTANGLE TO nStartLine+46,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+02 print "20" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+05 PRINT RECTANGLE TO nStartLine+46,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+06 print "Curso/Habilitação" font "arial" size 6 color aColor[9] 

   @nStartLine+46,nStartColumn+05 PRINT RECTANGLE TO nStartLine+50,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+47,nStartColumn+08 print produtos->pro_tipo font "arial" size 6 color aColor[9] 

   @nStartLine+50,nStartColumn+05 PRINT RECTANGLE TO nStartLine+54,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+51,nStartColumn+06 print "      Código" font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+05 PRINT RECTANGLE TO nStartLine+58,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+62,nStartColumn+01 PRINT RECTANGLE TO nStartLine+66,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+02 print "30" font "arial" size 6 color aColor[9] 

   @nStartLine+62,nStartColumn+05 PRINT RECTANGLE TO nStartLine+66,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+06 print "Ano: "+cAnoLetivoAtual font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+01 PRINT RECTANGLE TO nStartLine+76,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+02 print "40" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+05 PRINT RECTANGLE TO nStartLine+76,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+06 print "Classe" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+05 PRINT RECTANGLE TO nStartLine+80,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+07 print "T" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+10 PRINT RECTANGLE TO nStartLine+80,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+12 print " " font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+15 PRINT RECTANGLE TO nStartLine+80,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+17 print "S" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+20 PRINT RECTANGLE TO nStartLine+80,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+22 print "t" font "arial" size 6 color aColor[9] 

   @nStartLine+80,nStartColumn+05 PRINT RECTANGLE TO nStartLine+84,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+08 PRINT if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+80,nStartColumn+10 PRINT RECTANGLE TO nStartLine+84,nStartColumn+15 PENWIDTH 0.1

   @nStartLine+80,nStartColumn+15 PRINT RECTANGLE TO nStartLine+84,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+18 print substr(alltrim(setor->set_descri),1,1) font "arial" size 6 color aColor[9]

   @nStartLine+80,nStartColumn+20 PRINT RECTANGLE TO nStartLine+84,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+81,nStartColumn+22 print substr(alltrim(setor->set_descri),2,2) font "arial" size 6 color aColor[9]

   @nStartLine+86,nStartColumn+06 print "Carimbo da UE:" font "arial" size 6 color aColor[9]

   @nStartLine+126,nStartColumn+01 print line TO nStartLine+126,nStartColumn+25 penwidth 0.1
   @nStartLine+128,nStartColumn+01 print "Secretário(a) de Escola" font "arial" size 6 color aColor[9]

   @nStartLine+136,nStartColumn+05 PRINT RECTANGLE TO nStartLine+143,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+137,nStartColumn+06 print "NO VERSO ATA" font "arial" size 6 color aColor[9] 
   @nStartLine+140,nStartColumn+06 print "DO CONSELHO"  font "arial" size 6 color aColor[9] 

   @nStartLine+146,nStartColumn+05 PRINT RECTANGLE TO nStartLine+157,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+147,nStartColumn+06 print "   VIDE FICHA " font "arial" size 6 color aColor[9] 
   @nStartLine+150,nStartColumn+06 print "   INDIVIDUAL " font "arial" size 6 color aColor[9] 
   @nStartLine+153,nStartColumn+06 print "   DO ALUNO" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+01 PRINT RECTANGLE TO nStartLine+178,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+02 print "60" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+05 PRINT RECTANGLE TO nStartLine+192,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+06 print " AULAS DADAS" font "arial" size 6 color aColor[9] 
   @nStartLine+179,nStartColumn+06 print " Sub-total  " font "arial" size 6 color aColor[9] 
   @nStartLine+182,nStartColumn+06 print " Acumulado  " font "arial" size 6 color aColor[9] 
   @nStartLine+187,nStartColumn+06 print " Total      " font "arial" size 6 color aColor[9] 
   @nStartLine+189,nStartColumn+06 print "(Observar Reposição)" font "arial" size 5 color aColor[9] 
   @nStartLine+189,nStartColumn+26 print image "SETADIREITA" width 5 height 5

   nStartColumn:=(nStartColumn+28)

   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      nContaAlunos:=0
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))

      @nStartLine+00 ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+03,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+0.2,(nStartColumn+06)+(y*18) PRINT alltrim(substr(cargos->car_descri,1,12)) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @nStartLine+04 ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+06.6,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+07)+(y*18) PRINT "ANO"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+04 ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+06.6,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+17)+(y*18) PRINT "BIM"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+09.2,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+07)+(y*18) PRINT cAnoLetivoAtual FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+09.2,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+17)+(y*18) PRINT cBimestreAtual  FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+9.2,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+11.8,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+9.4,(nStartColumn+08)+(y*18) PRINT " CLASSE "      FONT "arial" SIZE 6.5 COLOR aColor[9]
      
      @nStartLine+11.8,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+06)+(y*18) PRINT "T" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+10)+(y*18) PRINT "G" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+15)+(y*18) PRINT "S" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+14.4,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+19)+(y*18) PRINT "t" FONT "arial" SIZE 6.5 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+14.4,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+06)+(y*18) PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+10)+(y*18) PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+15)+(y*18) PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+16.7,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+19)+(y*18) PRINT substr(alltrim(setor->set_descri),2,2) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+16.7,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+19.3,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+16.9,(nStartColumn+07)+(y*18) PRINT "COMP.CUR." FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+19.3,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+21.9,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+19.5,(nStartColumn+09)+(y*18) PRINT cargos->car_compon FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+21.9,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+06)+(y*18) PRINT "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+10)+(y*18) PRINT "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+15)+(y*18) PRINT "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+24.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+19)+(y*18) PRINT "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) PRINT turmas->tur_chamad FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+10)+(y*18) PRINT "TR" FONT "arial" SIZE 6.5 COLOR aColor[9] 
         else 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+11)+(y*18) PRINT notas->not_nota FONT "arial" SIZE 7.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+15)+(y*18) PRINT notas->not_faltas FONT "arial" SIZE 7.5 COLOR aColor[9]
 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.1,(nStartColumn+19)+(y*18) PRINT notas->not_compen FONT "arial" SIZE 7.5 COLOR aColor[9]
         nContaAlunos++
         nChamada:=val(turmas->tur_chamad)         
         turmas->(dbskip(1))
      enddo
      for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 65
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+09)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+14)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+18)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
      next i
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5     ,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.5 ,(nStartColumn+06)+(y*18) PRINT "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+3   ,(nStartColumn+06)+(y*18) PRINT substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 4.9 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+8.2 ,(nStartColumn+06)+(y*18) PRINT "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+11  ,(nStartColumn+06)+(y*18) PRINT "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+05)+(y*18) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+17,(nStartColumn+22)+(y*18) PENWIDTH 0.1 //retangulo para colocar reposição de aulas
      atribuir->(dbskip(1))
   enddo
   end PRINTPAGE
   setor->(dbskip(1))
enddo   

notas->(dbsetorder(5)) //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_SETOR+NOTAS->NOT_ALUNO+NOTAS->NOT_CHAMAD
conselho->(dbsetorder(2))  //CONSELHO->CON_EMPRE+CONSELHO->CON_ANO+CONSELHO->CON_SETOR+CONSELHO->CON_BIM
setor->(dbgotop())

do while !setor->(eof())
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif

   if cBimestreAtual=="5"
      if !conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+"4"))
         *msgbox("Não achei conselho bimestre:"+cBimestreAtual+"-cEmpresa:"+cEmpresa+"-Ano:"+cAnoLetivoAtual+"-setor:"+setor->set_codigo+"-Ordem:"+conselho->(indexkey()))
         setor->(dbskip(1))
         loop
      endif
   else
      if !conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+cBimestreAtual))
         *msgbox("Não achei conselho bimestre:"+cBimestreAtual+"-cEmpresa:"+cEmpresa+"-Ano:"+cAnoLetivoAtual+"-setor:"+setor->set_codigo+"-Ordem:"+conselho->(indexkey()))
         setor->(dbskip(1))
         loop
      endif
   endif

   START PRINTPAGE

   nStartColumn:=10
   nStartLine=10

   @nStartLine+00,nStartColumn+01 PRINT RECTANGLE TO nStartLine+04,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+02 print "10" font "arial" size 6 color aColor[9] 

   @nStartLine+00,nStartColumn+05 PRINT RECTANGLE TO nStartLine+14,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+06 print "ATA DO CONSELHO" font "arial" size 6 color aColor[9] 

   @nStartLine+05,nStartColumn+07 PRINT RECTANGLE TO nStartLine+07,nStartColumn+09 PENWIDTH 0.1
   @nStartLine+05.2,nStartColumn+7.4 print "X" font "arial" size 6 color aColor[9] 
   @nStartLine+05,nStartColumn+11 print "DE CLASSE" font "arial" size 6 color aColor[9] 
   @nStartLine+10,nStartColumn+07 PRINT RECTANGLE TO nStartLine+12,nStartColumn+09 PENWIDTH 0.1
   @nStartLine+10,nStartColumn+11 print "DE SÉRIE" font "arial" size 6 color aColor[9] 

   @nStartLine+32,nStartColumn+01 PRINT RECTANGLE TO nStartLine+36,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+33,nStartColumn+02 print "20" font "arial" size 6 color aColor[9] 
   @nStartLine+32,nStartColumn+05 PRINT RECTANGLE TO nStartLine+36,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+33,nStartColumn+11 PRINT "DATA" font "arial" size 6 color aColor[9] 
   @nStartLine+36,nStartColumn+05 PRINT RECTANGLE TO nStartLine+43,nStartColumn+12 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+07 print substr(dtoc(conselho->con_data),1,2) font "arial" size 7 color aColor[9] 
   @nStartLine+36,nStartColumn+12 PRINT RECTANGLE TO nStartLine+43,nStartColumn+19 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+14 print substr(dtoc(conselho->con_data),4,2) font "arial" size 7 color aColor[9] 
   @nStartLine+36,nStartColumn+19 PRINT RECTANGLE TO nStartLine+43,nStartColumn+28 PENWIDTH 0.1
   @nStartLine+38,nStartColumn+21 print substr(dtoc(conselho->con_data),7,4) font "arial" size 7 color aColor[9] 

   @nStartLine+50,nStartColumn+02 print "  FICA A CRITÉRIO  " font "arial" size 6 color aColor[9] 
   @nStartLine+52,nStartColumn+02 print "    DA DIREÇÃO A   " font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+02 print "FORMA DE UTILIZAÇÃO" font "arial" size 6 color aColor[9] 
   @nStartLine+56,nStartColumn+02 print "    DOS CAMPOS E   " font "arial" size 6 color aColor[9] 
   @nStartLine+58,nStartColumn+02 print "ESPAÇOS DISPONÍVEIS" font "arial" size 6 color aColor[9] 

   @nStartLine+170,nStartColumn+01 print line TO nStartLine+170,nStartColumn+25 penwidth 0.1
   @nStartLine+172,nStartColumn+07 print "DIRETOR" font "arial" size 6 color aColor[9]

   nStartColumn:=(nStartColumn+28)

   @nStartLine+00,nStartColumn+07 print RECTANGLE TO nStartLine+04,nStartColumn+11 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+08 print "30" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+11 PRINT RECTANGLE TO nStartLine+04,nStartColumn+70 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+12 print "CAUSAS PROVÁVEIS" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+72 PRINT RECTANGLE TO nStartLine+04,nStartColumn+76 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+73 print "40" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+76 PRINT RECTANGLE TO nStartLine+04,nStartColumn+131 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+77 print "PROPOSTAS DE SOLUÇÃO" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+133 PRINT RECTANGLE TO nStartLine+04,nStartColumn+137 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+134 print "50" font "arial" size 6 color aColor[9]

   @nStartLine+00,nStartColumn+137 PRINT RECTANGLE TO nStartLine+04,nStartColumn+305 PENWIDTH 0.1
   @nStartLine+01,nStartColumn+138 print "ESPAÇO DESTINADO ÀS OBSERVAÇÕES SOBRE OS ALUNOS" font "arial" size 6 color aColor[9]
   @nStartLine+04,nStartColumn+133 PRINT RECTANGLE TO nStartLine+08,nStartColumn+290 PENWIDTH 0.1

   for x = 0 to 11  //imprime 12 caixas de Causas para colocar mencoes do conselho
      @nStartLine+04,nStartColumn+11+(4*x)    PRINT RECTANGLE TO nStartLine+08,nStartColumn+15+(4*x) PENWIDTH 0.1
   next x
   //acaba de preencher coluna de Causas
   @nStartLine+04,nStartColumn+59         PRINT RECTANGLE TO nStartLine+08,nStartColumn+70 PENWIDTH 0.1

   for x = 0 to 11  //imprime 12 caixas de Encaminhamentos colocar mencoes do conselho
      @nStartLine+04,nStartColumn+76+(4*x)    PRINT RECTANGLE TO nStartLine+08,nStartColumn+80+(4*x) PENWIDTH 0.1
   next x
   //acaba de preencher coluna de Encaminhamentos
   @nStartLine+04,nStartColumn+115 PRINT RECTANGLE TO nStartLine+08,nStartColumn+131 PENWIDTH 0.1

   mencoes->(dbsetorder(2))
   mencoes->(dbgotop())
   x:=0
   cLetrasCausas:=""
   do while !mencoes->(eof())
      if alltrim(mencoes->men_tipo) = "CAUSAS"
         @nStartLine+(04+1),nStartColumn+(11+1.5)+(4*x) PRINT mencoes->men_letra FONT "arial" SIZE 6.5 COLOR aColor[9]
         cLetrasCausas+=mencoes->men_letra 
         x++
      endif
      mencoes->(dbskip(1))
   enddo   
   mencoes->(dbgotop())
   x:=0
   cLetrasEncaminhamentos:=""
   do while !mencoes->(eof())
      if alltrim(mencoes->men_tipo) = "ENCAMINHAMENTOS"
         @nStartLine+(04+1),nStartColumn+(76+1.5)+(4*x) PRINT mencoes->men_letra FONT "arial" SIZE 6.5 COLOR aColor[9] 
         cLetrasEncaminhamentos+=mencoes->men_letra
         x++
      endif
      mencoes->(dbskip(1))
   enddo   
   if !consitem->(dbseek(cEmpresa+conselho->con_codigo))
      msgbox("Não achei consitem")
   endif   

   nContaAlunos:=nChamada:=0

   do while !consitem->(eof()) .and. consitem->cit_conse = conselho->con_codigo
      notas->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+conselho->con_setor+consitem->cit_aluno+consitem->cit_chamad))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
      cMencaoA:=cMencaoB:=cMencaoC:=cMencaoD:=cMencaoE:=cMencaoF:=cMencaoG:=cMencaoH:=cMencaoI:=cMencaoJ:=cMencaoK:=cMencaoL:=.f.
      do while !notas->(eof()) .and. notas->not_setor = setor->set_codigo
         if notas->not_aluno=consitem->cit_aluno
            if notas->not_mencaa
               cMencaoA:=notas->not_mencaa
            endif   
            if notas->not_mencab
               cMencaoB:=notas->not_mencab
            endif   
            if notas->not_mencac
               cMencaoC:=notas->not_mencac
            endif   
            if notas->not_mencad
               cMencaoD:=notas->not_mencad
            endif   
            if notas->not_mencae
               cMencaoE:=notas->not_mencae
            endif   
            if notas->not_mencaf
               cMencaoF:=notas->not_mencaf
            endif   
            if notas->not_mencag
               cMencaoG:=notas->not_mencag
            endif   
            if notas->not_mencah
               cMencaoH:=notas->not_mencah
            endif   
            if notas->not_mencai
               cMencaoI:=notas->not_mencai
            endif   
            if notas->not_mencaj
               cMencaoJ:=notas->not_mencaj
            endif   
            if notas->not_mencak
               cMencaoK:=notas->not_mencak
            endif   
            if notas->not_mencal
               cMencaoL:=notas->not_mencal
            endif   
         endif
         notas->(dbskip(1))
      enddo
      @ nStartLine+(nContaAlunos*2.5)+08,(nStartColumn+7)   PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+11) PENWIDTH 0.1
      @ nStartLine+(nContaAlunos*2.5)+8.5,(nStartColumn+8) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 

      cMencoes:=""

      //Imprime as mencoes de Causas
      nColunaMencaoInicio:=11  //coluna inicial para mencoes "Causas"
      nColunaMencaoFim:=15  //coluna final para mencoes "Causas"
      for x = 1 to len(cLetrasCausas) //imprime menções do conselho de classe
         cLetraMencao:=substr(cLetrasCausas,x,1)
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         if mencoes->(dbseek(cEmpresa+"CAUSAS         "+cLetraMencao))
            @ nStartLine+(nContaAlunos*2.5)+08+0.3,(nStartColumn+(nColunaMencaoInicio+1)) PRINT if(&("cMencao"+cLetraMencao),"X","") FONT "arial" SIZE 6.5 COLOR aColor[9] 
            cMencoes+=mencoes->men_letra+"-"+rtrim(upper(substr(mencoes->men_descri,1,1)))+rtrim(lower(substr(mencoes->men_descri,2)))+"; "
         endif   
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x
      for x = len(cLetrasCausas) to 12 //imprime demais colunas das menções do conselho de classe
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //Imprime as mencoes de Encaminhamentos
      nColunaMencaoInicio:=76  //coluna inicial para mencoes "Encaminhamentos"
      nColunaMencaoFim:=80  //coluna final para mencoes "Encaminhamentos"
      for x = 1 to len(cLetrasEncaminhamentos) //imprime menções do conselho de classe
         cLetraMencao:=substr(cLetrasEncaminhamentos,x,1)
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         if mencoes->(dbseek(cEmpresa+"ENCAMINHAMENTOS"+cLetraMencao))
            @ nStartLine+(nContaAlunos*2.5)+08+0.3,(nStartColumn+(nColunaMencaoInicio+1)) PRINT if(&("cMencao"+cLetraMencao),"X","") FONT "arial" SIZE 6.5 COLOR aColor[9] 
            cMencoes+=mencoes->men_letra+"-"+rtrim(upper(substr(mencoes->men_descri,1,1)))+rtrim(lower(substr(mencoes->men_descri,2)))+"; "
         endif   
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      for x = len(cLetrasEncaminhamentos) to 12 //imprime demais menções do conselho de classe
         @ nStartLine+(nContaAlunos*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //completa os quadros de causas e encaminhamentos
      @ nStartLine+(nContaAlunos*2.5)+08,nStartColumn+59 PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,nStartColumn+70 PENWIDTH 0.1
      @ nStartLine+(nContaAlunos*2.5)+08,nStartColumn+124 PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,nStartColumn+131 PENWIDTH 0.1
*-------------------------------------
      //imprime a linha com observações gerais de cada aluno
      @ nStartLine+(nContaAlunos*2.5)+08,(nStartColumn+133) PRINT RECTANGLE TO nStartLine+(nContaAlunos*2.5)+08+2.5,(nStartColumn+305) PENWIDTH 0.1
      cObserva:=""
      if cBimestreAtual ="5"
         cObserva+=if(consitem->cit_situac=0,"",if(consitem->cit_situac=1,"",if(consitem->cit_situac=2,"promovido(a)",if(consitem->cit_situac=3,"retido(a)",if(consitem->cit_situac=4, "promovido(a) parcialmente (veja dependência em vermelho)",if(consitem->cit_situac=5,"promovido(a) pelo conselho (veja conceitos vermelhos)","promovido(a) pela progressão continuada (veja conceitos vermelhos)"))))))
      endif 
      cObserva+=if(!(consitem->cit_indis1$"0@ "),"Indisciplina "+consitem->cit_indis1+". ","")
      cObserva+=if(consitem->cit_parabe,"Parabéns! ","")
      cObserva+=if(consitem->cit_evadid,"Evadido. ","")
      cObserva+=if(consitem->cit_naoalf,"Não Alfabetizado. ","")
      cObserva+=consitem->cit_observ

      @ nStartLine+(nContaAlunos*2.5)+08+0.2,(nStartColumn+134) PRINT ALLTRIM(cObserva) FONT "arial" SIZE 6 COLOR aColor[9] 

      nContaAlunos++
      consitem->(dbskip(1))
   enddo

   for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 60
      @ nStartLine+((nContaAlunos+i)*2.5)+08      ,(nStartColumn+07) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+11) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+08.5+0.2,(nStartColumn+08) PRINT strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9]

      //Imprime as mencoes de Causas
      nColunaMencaoInicio:=11  //coluna inicial para mencoes "Causas"
      nColunaMencaoFim:=15  //coluna final para mencoes "Causas"
      for x = 1 to 12 //imprime menções do conselho de classe
         @ nStartLine+((nContaAlunos+i)*2.5)+08, (nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //Imprime as mencoes de Encaminhamentos
      nColunaMencaoInicio:=76  //coluna inicial para mencoes "Encaminhamentos"
      nColunaMencaoFim:=80  //coluna final para mencoes "Encaminhamentos"
      for x = 1 to 12 //imprime menções do conselho de classe
         @ nStartLine+((nContaAlunos+i)*2.5)+08    ,(nStartColumn+nColunaMencaoInicio) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+nColunaMencaoFim) PENWIDTH 0.1
         nColunaMencaoInicio+=4 
         nColunaMencaoFim+=4
      next x

      //completa os quadros de causas e encaminhamentos
      @ nStartLine+((nContaAlunos+i)*2.5)+08,nStartColumn+59 PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,nStartColumn+70 PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+08,nStartColumn+124 PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,nStartColumn+131 PENWIDTH 0.1
*-------------------------------------
      //imprime a linha com observações gerais de cada aluno
      @ nStartLine+((nContaAlunos+i)*2.5)+08,(nStartColumn+133) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+2.5,(nStartColumn+305) PENWIDTH 0.1
   next i

   cProfessores:=""
   for y = 1 to 120 step 6
      funciona->(dbseek(cEmpresa+substr(conselho->con_funcio,y,6)))
      cProfessores+=upper(substr(funciona->fun_alcunh,1,1))+rtrim(lower(substr(funciona->fun_alcunh,2)))+"; "
   next i

   @ nStartLine+((nContaAlunos+i)*2.5)+08+2 ,(nStartColumn+07) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+6,(nStartColumn+11) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+3 ,(nStartColumn+08) PRINT "60" FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+2 ,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+6,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+3 ,(nStartColumn+12) PRINT "OBSERVAÇÕES GERAIS:         Legenda Indisciplina-> 1 = Prejudica-se / 2 = Prejudica-se e os pares / 3 = Prejudica-se, os pares e o professor / 4 = Indisciplina Gravíssima   -  Série: "+setor->set_descri FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+6 ,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+10,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+7 ,(nStartColumn+12) PRINT "Participantes: "+cProfessores FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+10,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+14,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+11,(nStartColumn+12) PRINT "Legenda de Menções-> "+cMencoes FONT "arial" SIZE 6.5 COLOR aColor[9]
   @ nStartLine+((nContaAlunos+i)*2.5)+08+14,(nStartColumn+11) PRINT RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+08+18,(nStartColumn+305) PENWIDTH 0.1
   @ nStartLine+((nContaAlunos+i)*2.5)+08+15,(nStartColumn+12) PRINT "Perfil da Sala-> "+upper(substr(conselho->con_observ,1,1))+rtrim(lower(substr(conselho->con_observ,2))) FONT "arial" SIZE 6.5 COLOR aColor[9]

   end PRINTPAGE
   setor->(dbskip(1))
enddo   
end PRINTDOC
capabime->(dbsetorder(2))
setor->(dbsetfilter())
return

//------------------------------------------------------------------------------
procedure ImpResultadosAvaliacao2() //maior imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nContaAlunos, nNotaChamada:=0
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
turmas->(dbsetorder(2)) //ordem de chamada
nStartLine:=0
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
setor->(dbgotop())
START PRINTDOC

do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PRINTPAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      if y > 8
         y:=0
         END PRINTPAGE
         START PRINTPAGE
      endif   
      nStartLine:=2
      produtos->(dbseek(cEmpresa+setor->set_produt))
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
      @nStartLine+04,05+y*22 PRINT RECTANGLE TO nStartLine+8,(y*22)+15 PENWIDTH 0.1
      @nStartLine+05,06+y*22 PRINT "ANO"  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+04,15+y*22 PRINT RECTANGLE TO nStartLine+8,(y*22)+25 PENWIDTH 0.1
      @nStartLine+05,16+y*22 PRINT "BIM"  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+08,05+y*22 PRINT RECTANGLE TO nStartLine+12,(y*22)+15 PENWIDTH 0.1
      @nStartLine+09,06+y*22 PRINT cAnoLetivoAtual FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+08,15+y*22 PRINT RECTANGLE TO nStartLine+12,(y*22)+25 PENWIDTH 0.1
      @nStartLine+09,16+y*22 PRINT cBimestreAtual  FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+12,05+y*22 PRINT RECTANGLE TO nStartLine+16,(y*22)+25 PENWIDTH 0.1
      @nStartLine+13,06+y*22 PRINT " CLASSE " FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,05+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+10 PENWIDTH 0.1
      @nStartLine+17,06+y*22 PRINT "T" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,10+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+15 PENWIDTH 0.1
      @nStartLine+17,11+y*22 PRINT "G" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,15+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+20 PENWIDTH 0.1
      @nStartLine+17,16+y*22 PRINT "S" FONT "arial" SIZE 7 COLOR aColor[9]
      @nStartLine+16,20+y*22 PRINT RECTANGLE TO nStartLine+20,(y*22)+25 PENWIDTH 0.1
      @nStartLine+17,21+y*22 PRINT "t" FONT "arial" SIZE 7 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+20,05+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+10 PENWIDTH 0.1
      @ nStartLine+21,06+y*22 PRINT  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+20,10+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+15 PENWIDTH 0.1
      @ nStartLine+21,11+y*22 PRINT alltrim(produtos->pro_tipo) FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+20,15+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+20 PENWIDTH 0.1
      @ nStartLine+21,16+y*22 PRINT substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartLine+20,20+y*22 PRINT RECTANGLE TO nStartLine+24,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+21,21+y*22 PRINT substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 8 COLOR aColor[9]
      @ nStartLine+24,05+y*22 PRINT RECTANGLE TO nStartLine+28,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+25,06+y*22 PRINT "COMP.CUR." FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+28,05+y*22 PRINT RECTANGLE TO nStartLine+32,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+29,06+y*22 PRINT cargos->car_compon FONT "arial" SIZE 7 COLOR aColor[9]
      @ nStartLine+32,05+y*22 PRINT RECTANGLE TO nStartLine+36,(y*22)+10 PENWIDTH 0.1
      @ nStartLine+32.5,06+y*22 PRINT "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,10+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+15 PENWIDTH 0.1
      @ nStartLine+32.5,11+y*22 PRINT "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,15+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+20 PENWIDTH 0.1
      @ nStartLine+32.5,16+y*22 PRINT "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+32,20+y*22   PRINT RECTANGLE TO nStartLine+36,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+32.5,21+y*22 PRINT "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      nStartLine:=38

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         nContaAlunos++
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine  ,05+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+10 PENWIDTH 0.1
         @ nStartLine+1,06+y*22 PRINT turmas->tur_chamad FONT "arial" SIZE 7 COLOR aColor[9] 

         @ nStartLine  ,10+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+15 PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+0.5,11+y*22 PRINT "TR" FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         else 
            @ nStartLine+1,11+y*22 PRINT notas->not_nota FONT "arial" SIZE 7 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif
 
         @ nStartLine  ,15+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+20 PENWIDTH 0.1
         @ nStartLine+1,16+y*22 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]
 
         @ nStartLine  ,20+y*22 PRINT RECTANGLE TO nStartLine+4,(y*22)+25 PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+1,21+y*22 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]

         nStartLine+=4
         turmas->(dbskip(1))
      enddo
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine   ,05+y*22 PRINT RECTANGLE TO nStartLine+30,(y*22)+25 PENWIDTH 0.1
      @ nStartLine+1 ,06+y*22 PRINT "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+5 ,06+y*22 PRINT substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+9,06+y*22 PRINT "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+13,06+y*22 PRINT "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      atribuir->(dbskip(1))
   enddo
   end PRINTPAGE
   setor->(dbskip(1))
enddo   
end PRINTDOC
return

*------------------------------------------------------------------------------*
Procedure ImpResultadoAvaliacaoDevolutivaAluno() //Imprime resultado da avaliacao para entregar para alunos (devolutiva)
*------------------------------------------------------------------------------*
Local lSuccess, nStartLine, nQtdeAcertoSala:=0, y, x, nContaColuna:=0, i, arrQuestao:=array(60)
afill(arrQuestao,0)
SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
START PRINTDOC
START PRINTPAGE

if !turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
   msgstop("PAREI! Não achei turma.")
   close gabarito
   return
endif 

avaliar->(dbgotop())
do while !avaliar->(eof())
   if turmas->tur_setor$avaliar->av_setor
      exit
   endif
   avaliar->(dbskip())
enddo
if avaliar->(eof())
   msgstop("PAREI! Não encontrei setor solicitado em Avaliar.")
   return
endif   

do while !turmas->(eof()) .and. turmas->tur_setor = alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if !gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
      msgstop("PAREI! Não achei gabarito - nº chamada: "+turmas->tur_chamad)
   endif

   for i = 1 to val(avaliar->av_nroques)
       if !avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(i,3,0)))
          msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - i = "+STRZERO(i,3,0))
          return
       endif   
       if i < 10
          if alltrim(gabarito->&('q'+strzero(i,1,0))) == alltrim(avalques->avq_respo) 
             arrQuestao[i]++
          endif   
       else
          if alltrim(gabarito->&('q'+strzero(i,2,0))) == alltrim(avalques->avq_respo)
             arrQuestao[i]++
          endif                
       endif
   next i    
   turmas->(dbskip(1))
enddo   

if !turmas->(dbseek(cEmpresa+alltrim(GetProperty("FrmImpressao","TxtSerie","value"))))
   msgstop("PAREI! Não achei turma:"+GetProperty("FrmImpressao","TxtSerie","value"))
   return
endif 
if !setor->(dbseek(cEmpresa+turmas->tur_setor))
   msgstop("PAREI! Não achei setor: "+turmas->tur_setor)
endif   

do while !turmas->(eof()) .and. turmas->tur_setor = alltrim(GetProperty("FrmImpressao","TxtSerie","value")) 
   if nContaColuna>10
      end printpage
      start printpage 
      nContaColuna:=0
   endif         

   nStartLine:=0

   @ nStartLine+04,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+7,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+05,06+(nContaColuna*25) PRINT "Série: "+alltrim(setor->set_descri) FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+04,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+7,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+05,16+(nContaColuna*25) PRINT "Nº: "+turmas->tur_chamad  FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+07,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+10,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+08,06+(nContaColuna*25) PRINT "Ano: "+cAnoLetivoAtual FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+07,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+10,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+08,16+(nContaColuna*25) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,10+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,06+(nContaColuna*25) PRINT "Ques" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,06+(nContaColuna*25) PRINT "tão " FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,15+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,11+(nContaColuna*25) PRINT "Sua" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,11+(nContaColuna*25) PRINT "Resp" FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,20+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,16+(nContaColuna*25) PRINT "Resp" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,16+(nContaColuna*25) PRINT "Corr" FONT "arial" SIZE 5 COLOR aColor[9]

   @ nStartLine+10,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+15,25+(nContaColuna*25) PENWIDTH 0.1
   @ nStartLine+11,21+(nContaColuna*25) PRINT "Acer" FONT "arial" SIZE 5 COLOR aColor[9]
   @ nStartLine+13,21+(nContaColuna*25) PRINT "Sala" FONT "arial" SIZE 5 COLOR aColor[9]

   avaliar->(dbgotop())
   do while !avaliar->(eof())
      if turmas->tur_setor$avaliar->av_setor
         exit
      endif
      avaliar->(dbskip())
   enddo
   if avaliar->(eof())
      msgstop("PAREI. Não encontrei setor:"+turmas->tur_setor+" solicitado em Avaliar")
      return
   endif   

   nStartLine:=15

   if !gabarito->(dbseek(cEmpresa+cAnoLetivoAtual+cBimestreAtual+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
      msgstop("PAREI! Não achei gabarito. Aluno:"+turmas->tur_aluno)
      return
   endif
   for x = 1 to val(avaliar->av_nroques)
       if !avalques->(dbseek(cEmpresa+avaliar->av_codigo+strzero(x,3,0)))
          msgstop("PAREI! Não achei avalques - Avaliar->av_codigo"+AVALIAR->AV_CODIGO+" - x = "+STRZERO(x,3,0))
          return
       endif   
       @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
       @ nStartLine+1,06+(nContaColuna*25) PRINT strzero(x,2,0) FONT "arial" SIZE 5 COLOR aColor[9]

       @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
       if x < 10
          @ nStartLine+1,11+(nContaColuna*25) PRINT gabarito->&('q'+strzero(x,1,0)) FONT "arial" SIZE 5 COLOR aColor[9] 
       else
          @ nStartLine+1,11+(nContaColuna*25) PRINT gabarito->&('q'+strzero(x,2,0)) FONT "arial" SIZE 5 COLOR aColor[9]             
       endif
       @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
       @ nStartLine+1,16+(nContaColuna*25) PRINT avalques->avq_respo FONT "arial" SIZE 5 COLOR aColor[9]

       @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
       @ nStartLine+1,21+(nContaColuna*25) PRINT strzero(arrQuestao[x],2,0) FONT "arial" SIZE 5 COLOR aColor[9]
       nStartLine+=3
   next x
   if resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno))
      @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,06+(nContaColuna*25) PRINT "GER" FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,11+(nContaColuna*25) PRINT str(resultav->res_geral,5,2) FONT "arial" SIZE 5 COLOR aColor[9]

      @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,16+(nContaColuna*25) PRINT resultav->res_nome01 FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1
      @ nStartLine+1,21+(nContaColuna*25) PRINT str(resultav->res_grup01,5,2) FONT "arial" SIZE 5 COLOR aColor[9]
      for y = 2 to 15 step 2
         nStartLine+=3
         @ nStartLine  ,05+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,10+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,06+(nContaColuna*25) PRINT alltrim(resultav->&('res_nome'+strzero(y,2,0))) FONT "arial" SIZE 5 COLOR aColor[9]
         @ nStartLine  ,10+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,15+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,11+(nContaColuna*25) PRINT str(resultav->&('res_grup'+strzero(y,2,0)),5,2) FONT "arial" SIZE 5 COLOR aColor[9]

         @ nStartLine  ,15+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,20+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,16+(nContaColuna*25) PRINT alltrim(resultav->&('res_nome'+strzero(y+1,2,0))) FONT "arial" SIZE 5 COLOR aColor[9]
         @ nStartLine  ,20+(nContaColuna*25) PRINT RECTANGLE TO nStartLine+3,25+(nContaColuna*25) PENWIDTH 0.1
         @ nStartLine+1,21+(nContaColuna*25) PRINT str(resultav->&('res_grup'+strzero(y+1,2,0)),5,2) FONT "arial" SIZE 5 COLOR aColor[9]
      next y
   else
      msgstop("PAREI! Não achei RESULTAV - Aluno: "+turmas->tur_aluno)
      return
   endif 
   turmas->(dbskip(1))
   ncontaColuna++
enddo
end printpage
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure ImpBoletim() //Imprime boletim
//------------------------------------------------------------------------------
Local y:=0, x:=-1, lSuccess, nStartLine, nStartColumn, ncontaAlunos, nNotaChamada:=0, cProblemas, cEncaminha, cMencoes, nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0, nNotaRecAtual
Private aColor [11], nTotalAnualAlunoFaltas:=nTotalBimProfClasse:=nTotalBimNotaClasse:=0
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
LimpaRelacoes()
turmas->(dbsetorder(2))
nStartLine:=0
setor->(dbsetorder(1))
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
alunos->(dbsetorder(1))
cargos->(dbsetorder(1))
conselho->(dbsetorder(2))
consitem->(dbsetorder(2))
setor->(dbgotop())
START PRINTDOC
START PRINTPAGE

nStartColumn:=val(c_MargemEsquerda)

do while !setor->(eof()) 
   if !setor->set_EhAula; setor->(dbskip(1)); loop; endif  //nao processa setores que nao sao sala de aula
   if !turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual));setor->(dbskip(1));endif  //verifica se tem turma cadastrada neste setor
   do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo .and. turmas->tur_ano = cAnoLetivoAtual
      if turmas->tur_status = "MATRICULADO(A)"
         x++  //conta 4 boletins por página
         if x = 4
            END PRINTPAGE
            START PRINTPAGE
            x:=0
         endif
         nStartLine:=val(c_MargemSuperior)+(x*70)
         cProblemas:=cEncaminha:=cMencoes:=" "
         alunos->(dbseek(cEmpresa+turmas->tur_aluno))

         conselho->(dbseek(cEmpresa+cAnoLetivoAtual+setor->set_codigo+cBimestreAtual))
         consitem->(dbseek(cEmpresa+conselho->con_codigo+turmas->tur_chamad+turmas->tur_aluno))  

         @nStartLine+04,nStartColumn+06 PRINT "BOLETIM - "+alltrim(setor->set_descri)+" - Bim.: "+cBimestreAtual+" - Ano: "+cAnoLetivoAtual+" - Aluno: "+turmas->tur_chamad+" - "+alltrim(substr(alunos->alu_nome,1,40))+" - Data matrícula: "+dtoc(turmas->tur_datast) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+07,nStartColumn+06 PRINT "MATÉRIA                PROFESSOR                                     NOTA        FALTAS    AC" FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+8.5,nStartColumn+06 PRINT replicate("-",132) FONT "arial" SIZE 7 COLOR aColor[9]
         y:=nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0
         atribuir->(dbseek(cEmpresa+setor->set_codigo))      
         do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
            y++  //soma quantidade de linhas de atribuições
            nStartLine:=(val(c_MargemSuperior)+8)+(x*70)
            cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
            funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
            @nStartLine+(3.5*y),nStartColumn+06 PRINT substr(cargos->car_descri,1,12) FONT "arial" SIZE 7 COLOR aColor[9]
            @nStartLine+(3.5*y),nStartColumn+28 PRINT substr(funciona->fun_nome,1,25) FONT "arial" SIZE 7 COLOR aColor[9]

            if notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))
               @nStartLine+(3.5*y),nStartColumn+72 PRINT notas->not_nota   FONT "arial" SIZE 7 COLOR aColor[9]
               @nStartLine+(3.5*y),nStartColumn+85 PRINT notas->not_faltas FONT "arial" SIZE 7 COLOR aColor[9]
               @nStartLine+(3.5*y),nStartColumn+95 PRINT notas->not_compen FONT "arial" SIZE 7 COLOR aColor[9]

               nTotalBimAlunoFaltas+=val(notas->not_faltas)
               nTotalBimAlunoFaltas-=val(notas->not_compen)
               nTotalBimAlunoNotas+=val(notas->not_nota)
               nTotalBimProf++
            endif   
            atribuir->(dbskip(1))
         enddo

         nNotaRecAtual:=notas->(recno())
         notas->(dbsetorder(1))
         notas->(dbgoto(nNotaRecAtual))
         SomaClasseBimAtual()
         SomaMediaClasseAlunoAnual(turmas->tur_aluno)
         @nStartLine+00,nStartColumn+126 PRINT "Total Faltas Ano      : "+strzero(nTotalAnualAlunoFaltas,3,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+04,nStartColumn+126 PRINT "Total Faltas Bimestre : "+strzero(nTotalBimAlunoFaltas,3,0) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+08,nStartColumn+126 PRINT "Média do Aluno no Bimestre : "+alltrim(str(nTotalBimAlunoNotas/nTotalBimProf)) FONT "arial" SIZE 7 COLOR aColor[9]
         @nStartLine+12,nStartColumn+126 PRINT "Média da Classe no Bimestre: "+alltrim(str(nTotalBimNotaClasse/nTotalBimProfClasse)) FONT "arial" SIZE 7 COLOR aColor[9]

         nStartLine:=(val(c_MargemSuperior)+8)+(y*3.5)+(x*70)
         cProblemas+=if(consitem->cit_assidu,"  * Faltas Excessivas","")
         cProblemas+=if(consitem->cit_falcom,"  * Descompromisso","")
         cProblemas+=if(consitem->cit_naorea,"  * Não Faz Atividades","")
         cProblemas+=if(consitem->cit_falest,"  * Não Estuda","")
         cProblemas+=if(consitem->cit_difapr,"  * Dificuldade Aprendizagem","")
         @nStartLine+05,nStartColumn+06 PRINT "Problemas Detectados : "+cProblemas  FONT "arial" SIZE 7 COLOR aColor[9]
  
         cEncaminha+=if(consitem->cit_conpai,"  * Conversar c/Responsável","")
         cEncaminha+=if(consitem->cit_recpar,"  * Recuperação Paralela","")
         cEncaminha+=if(consitem->cit_reccon,"  * Recuperação Contínua","")
         cEncaminha+=if(consitem->cit_habest,"  * Criar hábito de estudo","")
         @nStartLine+09,nStartColumn+06 PRINT "Encaminhamentos : "+cEncaminha  FONT "arial" SIZE 7 COLOR aColor[9]
  
         cMencoes+=if(consitem->cit_parabe,"  * PARABÉNS!!!","")
         cMencoes+=if(consitem->cit_naoalf,"  * Não Alfabetizado","")
         cMencoes+=if(consitem->cit_evadid,"  * Evadido(a)","")
         cMencoes+=if(consitem->cit_indis1="1","  * Indisciplina 1 de 4 : Prejudica a si próprio","")
         cMencoes+=if(consitem->cit_indis1="2","  * Indisciplina 2 de 4 : Prejudica a si e aos colegas","")
         cMencoes+=if(consitem->cit_indis1="3","  * Indisciplina 3 de 4 : Prejudica a si, aos colegas e ao professor","")
         cMencoes+=if(consitem->cit_indis1="4","  * Indisciplina 4 de 4 : Indisciplina Grave","")
         @nStartLine+13,nStartColumn+06 PRINT "Outras Menções : "+cMencoes FONT "arial" SIZE 7 COLOR aColor[9]
      endif
      turmas->(dbskip(1))
   enddo
   setor->(dbskip(1))
enddo   
end PRINTPAGE
end PRINTDOC
capabime->(dbsetorder(2))
LimpaRelacoes()
return

/*
//------------------------------------------------------------------------------
procedure ImpBoletim1() //Imprime boletim
//------------------------------------------------------------------------------
Local y:=0, x:=-1, lSuccess, nStartLine, nStartColumn, ncontaAlunos, nNotaChamada:=0, cProblemas, cEncaminha, cMencoes, nTotalBimAlunoFaltas:=nTotalBimAlunoNotas:=nTotalBimProf:=0, nNotaRecAtual
Private aColor [11], nTotalAnualAlunoFaltas:=nTotalBimProfClasse:=nTotalBimNotaClasse:=0
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

SELECT PRINTER DIALOG TO lSuccess PREVIEW
if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif

START PRINTDOC
START PRINTPAGE

nStartColumn:=val(c_MargemEsquerda)

cConsitemMemoField:=consitem->cit_observ

if !produtos->(dbseek(cEmpresa+setor->set_produt))
   msgExclamation("Não encontrei curso.")
endif

aItens:={}

if consitem->cit_empre = cEmpresa .and. consitem->cit_conse = conselho->con_codigo
   if !atribuir->(dbseek(cEmpresa+conselho->con_setor))
      msgStop("Não encontrei Atribuição de professores. Entre em contato com o administrador do sistema.")
   endif
   do while !atribuir->(eof()) .and. atribuir->atr_setor = conselho->con_setor
      cNota1Bim:=cNota2Bim:=cNota3Bim:=cNota4Bim:=cNota5Bim:=cFaltas1Bim:=cFaltas2Bim:=cFaltas3Bim:=cFaltas4Bim:=" "
      cRegNumeroBimAtual:=""

      if !cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
         msgStop("PAREI! Não encontrei cargo. Contatar administrador do sistema.")
         return
      endif 
      if !funciona->(dbseek(cEmpresa+atribuir->atr_funcio))
         msgStop("PAREI! Não encontrei funcionário. Contatar administrador do sistema.")
         return
      endif 
      
      notas->(dbsetorder(4)) //NOTAS->NOT_EMPRE+NOTAS->NOT_ANO+NOTAS->NOT_BIM+NOTAS->NOT_ALUNO+NOTAS->NOT_CARGO+NOTAS->NOT_CHAMAD

      for i = 1 to (val(produtos->pro_qtdbim)+1) //pega as notas de todos os bimestres (inclusive o conceito final) para o aluno atual a fim de preencher grid do conselho
         if notas->(dbseek(cEmpresa+consitem->cit_ano+strzero(i,1,0)+consitem->cit_aluno+cargos->car_codigo))
            lContinua:=.t.
            do while lContinua
               if val(notas->not_bim)<>i .or. notas->not_aluno<>consitem->cit_aluno
                  lContinua:=.f.
                  loop
               endif   
               //procura em que turma o aluno está matriculado, pois ele vai ter também registro de nota na turma onde encontra-se com status de remanejado, e este registro em branco deve ser descartado
               if !turmas->(dbseek(cEmpresa+notas->not_aluno+notas->not_chamad+notas->not_setor+cAnoLetivoAtual))
                  if msgyesno("PAREI! Não achei turma. Aluno:"+notas->not_aluno+" Chamada:"+notas->not_chamad+" Setor:"+notas->not_setor+" Deleta?")
                     notas->(rlock())
                     notas->(dbdelete())
                     notas->(dbunlockall())
                  endif   
                  return
               endif   

               dDataLimBimTemp:=if(notas->not_bim = "1", anoletiv->ano_li1bim, if(notas->not_bim="2",anoletiv->ano_li2bim,if(notas->not_bim="3",anoletiv->ano_li3bim,anoletiv->ano_li4bim)))

               //embora esteja remanejado/transferido/reclassificado em algumas turmas, dependendo da data ele vai com nota nesta mesma turma
               if (alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDataLimBimTemp)) .or. (alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDataLimBimTemp)) 
                  notas->(dbskip(1))
                  loop
               endif

               if !empty(notas->not_nota) .and. i = val(cBimestreAtual) .and. notas->not_aluno = consitem->cit_aluno .and. notas->not_setor = conselho->con_setor
                  if !(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual))
                     if !(alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual))
                        nTotalBimAlunoFaltas+=val(notas->not_faltas)  //se não achou nota é porque professor ainda não lançou notas. Na hora de salvar item do conselho, a nota será acrescentada.
                        nTotalBimAlunoNotas+=val(alltrim(notas->not_nota))
                        nTotalBimProf++
                     endif   
                  endif
               endif 
               lContinua:=.f.
            enddo       
            &('cNota'+strzero(i,1,0)+'Bim'):=notas->not_nota
            &('cFaltas'+strzero(i,1,0)+'Bim'):=strzero(val(notas->not_faltas),2,0)
            if notas->not_bim = strzero(i,1,0)
               cRegNumeroBimAtual:=strzero(notas->(recno()),6,0)
            endif
            if cBimestreAtual = notas->not_bim
               lMencaoA:=notas->not_mencaa
               lMencaoB:=notas->not_mencab
               lMencaoC:=notas->not_mencac
               lMencaoD:=notas->not_mencad
               lMencaoE:=notas->not_mencae
               lMencaoF:=notas->not_mencaf
               lMencaoG:=notas->not_mencag 
               lMencaoH:=notas->not_mencah
               lMencaoI:=notas->not_mencai
               lMencaoJ:=notas->not_mencaj
               lMencaoK:=notas->not_mencak
               lMencaoL:=notas->not_mencal
            endif
         else
            &('cNota'+strzero(i,1,0)+'Bim'):=" "
            &('cFaltas'+strzero(i,1,0)+'Bim'):=" "
         endif
      next i
      //volta para a turma do conselho atual
      turmas->(dbseek(cEmpresa+consitem->cit_aluno+consitem->cit_chamad+conselho->con_setor+cAnoLetivoAtual))

      //Localiza a capa do bimestre onde encontram-se os totais de Aulas Previstas e Aulas Dadas
      capabime->(dbseek(cEmpresa+conselho->con_setor+atribuir->atr_funcio+cargos->car_codigo+consitem->cit_ano+cBimestreAtual)) 

      if !conselho->con_fecha .and. (!(alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual)) .and. !(alltrim(turmas->tur_status)$"MATRICULADO(A)" .and. dtos(turmas->tur_datast) > dtos(dDtLimBimAtual)))  
         add item &(aGridCam1) to Grd_Notas of FrmConselho
         setproperty("FrmConselho","Grd_Notas","Enabled", .t.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .t.)
         setproperty("FrmConselho","Button_Salva","Enabled", .t.)
         setproperty("FrmConselho","SliderIndisci","Enabled", .t.)
         setproperty("FrmConselho","LblSliderIndisci","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador0","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador1","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador2","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador3","Enabled", .t.)
         setproperty("FrmConselho","LblSliderMarcador4","Enabled", .t.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .t.)
         setproperty("FrmConselho","Chk_Parabens","Enabled", .t.)
         setproperty("FrmConselho","Chk_Evadido","Enabled", .t.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .t.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .t.)
         if !(val(cBimestreAtual)==val(produtos->pro_qtdbim))  //não mostra este controle se não for o último bimestre
            setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         endif
      else
         //desabilita controles quando o aluno não estiver matriculado mais na turma.
         setproperty("FrmConselho","Grd_Notas","Enabled", .f.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
         setproperty("FrmConselho","Button_Salva","Enabled", .f.)
         setproperty("FrmConselho","SliderIndisci","Enabled", .f.)
         setproperty("FrmConselho","LblSliderIndisci","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador0","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador1","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador2","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador3","Enabled", .f.)
         setproperty("FrmConselho","LblSliderMarcador4","Enabled", .f.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         setproperty("FrmConselho","Chk_Parabens","Enabled", .f.)
         setproperty("FrmConselho","Chk_Evadido","Enabled", .f.)
         setproperty("FrmConselho","Combo_Situacao","Enabled", .f.)
         setproperty("FrmConselho","Combo_Hipotese","Enabled", .f.)
      endif   

      if pAcao = "PRIMEIRO" // preenche fotos dos professores e seta do prof coordenador somente na primeira vez
         nContaProfAtribuicao++
         if setor->set_procoo = atribuir->atr_funcio  //se professor coordenador da sala é o professor atual
            setproperty("FrmConselho","SetaProfCoord","Col" ,(nContaProfAtribuicao*56)-30)  //move seta para indicar coordenador da sala
         endif
         if empty(alltrim(funciona->fun_foto)) .and. nContaProfAtribuicao<15 //não cabe 15 professores na tela
            setproperty("FrmConselho","Prof"+strzero(nContaProfAtribuicao,2,0),"Picture","teacher")
         else
            setproperty("FrmConselho","Prof"+strzero(nContaProfAtribuicao,2,0),"Picture", rtrim(c_PastaFotos)+"\"+alltrim(funciona->fun_foto))
         endif
         setproperty("FrmConselho","LblProf"+strzero(nContaProfAtribuicao,2,0),"value",substr(funciona->fun_alcunh,1,9))
      endif
      atribuir->(dbskip(1))
   enddo   

   setproperty("FrmConselho","LblIDAluno"    ,"Value", alltrim(alunos->alu_nome))
   setproperty("FrmConselho","LblIDChamada"  ,"Value", "Nº: "+substr(consitem->cit_chamad,1,2))
   setproperty("FrmConselho","LblIdade"      ,"Value", "IDADE: "+substr(alltrim(str(val(dtos(date()))-val(dtos(alunos->alu_nasc)))),1,2)+" ANOS")
   setproperty("FrmConselho","lBlStatus"     ,"Value", alltrim(turmas->tur_status)+"-"+dtoc(turmas->tur_datast)+if(!empty(turmas->tur_observ)," - "+alltrim(turmas->tur_observ),""))
   setproperty("FrmConselho","LblIDSetor08"  ,"Value", alltrim(produtos->pro_descri))
   setproperty("FrmConselho","LblTotalFaltasBimestre01","Value", strzero(nTotalBimAlunoFaltas,3,0))
   setproperty("FrmConselho","LblTotalFaltasAno01"     ,"Value", strzero(nTotalAnualAlunoFaltas,3,0))
   setproperty("FrmConselho","LblMediaAluno01"  ,"Value", transform(alltrim(str(nTotalBimAlunoNotas/nTotalBimProf)),"999")) 
   setproperty("FrmConselho","LblMediaAluno01" ,"FontColor", if((nTotalBimAlunoNotas/nTotalBimProf)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblMediaClasse01" ,"Value", transform(alltrim(str(nTotalBimNotaClasse/nTotalBimProfClasse)),"999"))
   setproperty("FrmConselho","LblMediaClasse01" ,"FontColor",if((nTotalBimNotaClasse/nTotalBimProfClasse)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblAnualAluno01"  ,"Value", transform(alltrim(str(nTotalAnualNotaAluno/nTotalAnualProfAluno)),"999"))
   setproperty("FrmConselho","LblAnualAluno01" ,"FontColor",if((nTotalAnualNotaAluno/nTotalAnualProfAluno)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblAnualClasse01" ,"Value", transform(alltrim(str(nTotalAnualNotaClasse/nTotalAnualProfClasse)),"999"))
   setproperty("FrmConselho","LblAnualClasse01" ,"FontColor",if((nTotalAnualNotaClasse/nTotalAnualProfClasse)<5,{255,0,0},{0,0,255}))
   setproperty("FrmConselho","LblQtAzul01" ,"Value", strzero(nQtNotaAzul,3,0))
   setproperty("FrmConselho","LblQtVerm01" ,"Value", strzero(nQtNotaVerm,3,0))
   if empty(rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto)) .or. !file(rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
      setproperty("FrmConselho","ImgAluno","Picture", "FOTO")   
   else
      setproperty("FrmConselho","ImgAluno","Picture", rtrim(c_PastaFotos)+"\"+alltrim(alunos->alu_foto))
   endif   
   setproperty("FrmConselho","Combo_Situacao","Value", consitem->cit_situac)
   setproperty("FrmConselho","Combo_Hipotese","Value", alunos->alu_hipote)
   setproperty("FrmConselho","SliderIndisci","Value", val(consitem->cit_indis1))
   setproperty("FrmConselho","Chk_Parabens","Value", consitem->cit_parabe)
   setproperty("FrmConselho","Chk_Evadido","Value", turmas->tur_evadid)
else
   msgInfo("Fim dos itens do conselho")
   if pAcao = "PROXIMO"
      consitem->(dbskip(-1))
   elseif pAcao = "ANTERIOR"
      consitem->(dbskip(1))
   endif
endif
do case   //poe a cor do bimestre atual em vermelho
   case cBimestreAtual = "1"
      setproperty("FrmConselho","TxtNotas1Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "2"
      setproperty("FrmConselho","TxtNotas2Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "3"
      setproperty("FrmConselho","TxtNotas3Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "4"
      setproperty("FrmConselho","TxtNotas4Bim","FONTCOLOR", {255,0,0})
   case cBimestreAtual = "5"
      setproperty("FrmConselho","TxtNotas5Bim","FONTCOLOR", {255,0,0})
endcase



end PRINTPAGE
end PRINTDOC
capabime->(dbsetorder(2))
LimpaRelacoes()
return

  */

*------------------------------------------------------------------------------*
Procedure marceloGeral() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local lPrimeiroAluno, lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 
      lPrimeiroAluno:=.t.
      nStartPrint:=0
      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr

         if lPrimeiroAluno
            @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,06+(nContaColuna*22) PRINT "Nº" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,06+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,11+(nContaColuna*22) PRINT "Nota" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,11+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,17+(nContaColuna*22) PRINT "GERAL" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
            lPrimeiroAluno:=.f.
            nStartPrint:=15
         endif

         @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,06+(nContaColuna*22) PRINT turmas->tur_chamad FONT "arial" SIZE 6 COLOR aColor[9]
   
         @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,11+(nContaColuna*22) PRINT if(resultav->(found()),str(resultav->res_geral,5,2),"  -  ") FONT "arial" SIZE 6 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 

         @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         nStartPrint+=3
         turmas->(dbskip(1))
      enddo   
      ncontaColuna++
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

*------------------------------------------------------------------------------*
Procedure marceloEspecifico() // Análise de erros e acertos por questao. (para o professor)
*------------------------------------------------------------------------------*
Local u, lPrimeiroAluno, lSuccess, nStartPrint, y, x, nContaColuna:=0, i, arrQuestao:=array(60), nSomaParticipantesProva:=0, nSomaQuestoesBranco:=0, lTemGabarito

SELECT PRINTER DIALOG TO lSuccess PREVIEW

limparelacoes()

if !lSuccess
   MsgInfo('Fim de Impressão')
   return
endif
gabarito->(dbsetorder(2))
avalques->(dbsetorder(2))
turmas->(dbsetorder(2))
atribuir->(dbsetorder(4))
funciona->(dbsetorder(1))
funciona->(dbgotop())
setor->(dbsetorder(1))
START PRINTDOC

do while !funciona->(eof())
   START PRINTPAGE
   @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]

   nContaColuna:=0
   atribuir->(dbseek(cEmpresa+funciona->fun_codigo))
   do while !atribuir->(eof()) .and. atribuir->atr_funcio = funciona->fun_codigo
      setor->(dbseek(cEmpresa+atribuir->atr_setor))
      if !setor->set_EhAula
         atribuir->(dbskip(1))
         loop
      endif
      nSomaQuestoesBranco:=nSomaParticipantesProva:=0
      arrQuestao:=array(60)
      lTemGabarito:=.f.
      afill(arrQuestao,0)
   
      avaliar->(dbgotop())
      do while !avaliar->(eof())
         if setor->set_codigo$avaliar->av_setor .and. avaliar->av_bim = cBimestreAtual .and. avaliar->av_ano = cAnoLetivoAtual
            exit
         endif
         avaliar->(dbskip())
      enddo
      if avaliar->(eof())
         msgbox("Não encontrei Avaliação para o Setor, Ano e Bimestre solicitados. Setor:"+setor->set_codigo+" - "+setor->set_descri)
         setor->(dbskip(1))
         loop
      endif   

      if !turmas->(dbseek(cEmpresa+setor->set_codigo))
         msgbox("Não achei turma. Setor:"+setor->set_codigo)
         setor->(dbskip(1))
         loop
      endif 
      lPrimeiroAluno:=.t.
      nStartPrint:=0
      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         
         if resultav->(dbseek(cEmpresa+avaliar->av_codigo+turmas->tur_aluno)) //respeitando o formato do codigo do aluno no gabarito por conta do programa pcomr
            for u = 1 to 20
               if &('resultav->res_nome'+strzero(u,2,0)) = cargos->car_resumo
                  msgbox("achei nome resumido na posição "+str(u)+" - cargo="+cargos->car_resumo+" - resumo="+&('resultav->res_nome'+strzero(u,2,0)))
                  exit
               endif
            next u      
         endif
         if u > 20
            u:=20
         endif   
         if lPrimeiroAluno
            @ nStartPrint+04,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+7,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,06+(nContaColuna*22) PRINT alltrim(setor->set_descri) FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+04,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+05,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+07,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,06+(nContaColuna*22) PRINT cAnoLetivoAtual FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+07,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+10,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+08,17+(nContaColuna*22) PRINT "Bim :"+cBimestreAtual  FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,10+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,06+(nContaColuna*22) PRINT "Nº" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,06+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,16+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,11+(nContaColuna*22) PRINT "Nota" FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,11+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
         
            @ nStartPrint+10,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+15,24+(nContaColuna*22) PENWIDTH 0.1
            @ nStartPrint+11,17+(nContaColuna*22) PRINT cargos->car_resumo FONT "arial" SIZE 6 COLOR aColor[9]
            @ nStartPrint+13,17+(nContaColuna*22) PRINT "" FONT "arial" SIZE 6 COLOR aColor[9]
            lPrimeiroAluno:=.f.
            nStartPrint:=15
         endif

         @ nStartPrint  ,05+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,10+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,06+(nContaColuna*22) PRINT turmas->tur_chamad FONT "arial" SIZE 6 COLOR aColor[9]
   
         @ nStartPrint  ,10+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,16+(nContaColuna*22) PENWIDTH 0.1
         @ nStartPrint+1,11+(nContaColuna*22) PRINT if(resultav->(found()),str(&('resultav->res_grup'+strzero(u,2,0)),5,2),"  -  ") FONT "arial" SIZE 6 COLOR if(resultav->res_geral>=5, aColor[11],aColor[3]) 

         @ nStartPrint  ,16+(nContaColuna*22) PRINT RECTANGLE TO nStartPrint+3,24+(nContaColuna*22) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         nStartPrint+=3
         turmas->(dbskip(1))
      enddo   
      ncontaColuna++
      if nContaColuna==12
         end printpage
         start printpage 
         nContaColuna:=0
         @ 0,06 PRINT "Professor: "+funciona->fun_codigo+" - "+funciona->fun_nome FONT "arial" SIZE 6 COLOR aColor[9]
      endif         
      atribuir->(dbskip(1))
   enddo
   end printpage
   funciona->(dbskip(1))
enddo
end PRINTDOC
return 

//------------------------------------------------------------------------------
procedure Impwinprint() //menor imprime notas da avaliacao dos alunos
//------------------------------------------------------------------------------
Local i, y:=0, u, lSuccess, nStartLine, nStartColumn:=35, nContaAlunos, nChamada:=0
Private aColor [11]
aColor [1] := YELLOW	
aColor [2] := PINK	
aColor [3] := RED	
aColor [4] := FUCHSIA	
aColor [5] := BROWN	
aColor [6] := ORANGE	
aColor [7] := GRAY	
aColor [8] := PURPLE	
aColor [9] := BLACK	
aColor [10] := WHITE
aColor [11] := BLUE

INIT PRINTSYS

SELECT DEFAULT PREVIEW

DEFINE FONT "F0" NAME "arial" SIZE 6

turmas->(dbsetorder(2)) //ordem de chamada
nContaAlunos:=0
atribuir->(dbsetorder(2))
funciona->(dbsetorder(1))
setor->(dbsetorder(1))
notas->(dbsetorder(1))
capabime->(dbsetorder(2))

START DOC


do while !setor->(eof()) //.and. setor->set_codigo > cSetorIni .and. setor->set_codigo < cSetorFim
   y:=-1
   if !setor->set_EhAula
      setor->(dbskip(1))
      loop
   endif
   START PAGE
   atribuir->(dbseek(cEmpresa+setor->set_codigo))
   nStartColumn:=10
   nStartLine=10

   @nStartLine+00,nStartColumn+01,nStartLine+18,nStartColumn+25 RECTANGLE
   @nStartLine+02,nStartColumn+02 say "REGISTRO E"  font "f0" to print
   @nStartLine+06,nStartColumn+02 say "CONTROLE DO" font "f0" to print 
   @nStartLine+10,nStartColumn+02 say "RENDIMENTO " font "f0" to print
   @nStartLine+14,nStartColumn+02 say "ESCOLAR"     font "f0" to print
  
/*
   @nStartLine+00 ,nStartColumn+29 say RECTANGLE TO nStartLine+04,nStartColumn+33 PENWIDTH 0.1
   @nStartLine+1.2,nStartColumn+30 say "50" FONT "arial" SIZE 6 COLOR aColor[9]

   @nStartLine+22,nStartColumn+01 say RECTANGLE TO nStartLine+26,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+02 say "10" font "arial" size 6 color aColor[9] 

   @nStartLine+22,nStartColumn+05 say RECTANGLE TO nStartLine+26,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+23,nStartColumn+06 say "Bimestre" font "arial" size 6 color aColor[9] 

   @nStartLine+26,nStartColumn+05 say RECTANGLE TO nStartLine+30,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+27,nStartColumn+06 say "Média Final" font "arial" size 6 color aColor[9] 

   @nStartLine+30,nStartColumn+05 say RECTANGLE TO nStartLine+34,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+31,nStartColumn+06 say "Recuperação" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+01 say RECTANGLE TO nStartLine+46,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+02 say "20" font "arial" size 6 color aColor[9] 

   @nStartLine+42,nStartColumn+05 say RECTANGLE TO nStartLine+46,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+43,nStartColumn+06 say "Curso/Habilitação" font "arial" size 6 color aColor[9] 

   @nStartLine+46,nStartColumn+05 say RECTANGLE TO nStartLine+50,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+50,nStartColumn+05 say RECTANGLE TO nStartLine+54,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+51,nStartColumn+06 say "    Código" font "arial" size 6 color aColor[9] 
   @nStartLine+54,nStartColumn+05 say RECTANGLE TO nStartLine+58,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+62,nStartColumn+01 say RECTANGLE TO nStartLine+66,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+02 say "30" font "arial" size 6 color aColor[9] 

   @nStartLine+62,nStartColumn+05 say RECTANGLE TO nStartLine+66,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+63,nStartColumn+06 say "Ano" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+01 say RECTANGLE TO nStartLine+76,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+02 say "40" font "arial" size 6 color aColor[9] 

   @nStartLine+72,nStartColumn+05 say RECTANGLE TO nStartLine+76,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+73,nStartColumn+06 say "Classe" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+05 say RECTANGLE TO nStartLine+80,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+06 say "T" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+10 say RECTANGLE TO nStartLine+80,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+11 say "E" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+15 say RECTANGLE TO nStartLine+80,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+16 say "S" font "arial" size 6 color aColor[9] 

   @nStartLine+76,nStartColumn+20 say RECTANGLE TO nStartLine+80,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+77,nStartColumn+22 say "+" font "arial" size 6 color aColor[9] 

   @nStartLine+80,nStartColumn+05 say RECTANGLE TO nStartLine+84,nStartColumn+10 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+10 say RECTANGLE TO nStartLine+84,nStartColumn+15 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+15 say RECTANGLE TO nStartLine+84,nStartColumn+20 PENWIDTH 0.1
   @nStartLine+80,nStartColumn+20 say RECTANGLE TO nStartLine+84,nStartColumn+25 PENWIDTH 0.1

   @nStartLine+86,nStartColumn+06 say "Carimbo da UE:" font "arial" size 6 color aColor[9]

   @nStartLine+126,nStartColumn+01 say line TO nStartLine+126,nStartColumn+25 penwidth 0.1
   @nStartLine+128,nStartColumn+01 say "Secretário(a) de Escola" font "arial" size 6 color aColor[9]

   @nStartLine+136,nStartColumn+05 say RECTANGLE TO nStartLine+143,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+137,nStartColumn+06 say "NO VERSO ATA" font "arial" size 6 color aColor[9] 
   @nStartLine+140,nStartColumn+06 say "DO CONSELHO"  font "arial" size 6 color aColor[9] 

   @nStartLine+146,nStartColumn+05 say RECTANGLE TO nStartLine+157,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+147,nStartColumn+06 say "   VIDE FICHA " font "arial" size 6 color aColor[9] 
   @nStartLine+150,nStartColumn+06 say "   INDIVIDUAL " font "arial" size 6 color aColor[9] 
   @nStartLine+153,nStartColumn+06 say "   DO ALUNO" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+01 say RECTANGLE TO nStartLine+178,nStartColumn+05 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+02 say "60" font "arial" size 6 color aColor[9] 

   @nStartLine+174,nStartColumn+05 say RECTANGLE TO nStartLine+192,nStartColumn+25 PENWIDTH 0.1
   @nStartLine+175,nStartColumn+06 say " AULAS DADAS" font "arial" size 6 color aColor[9] 
   @nStartLine+179,nStartColumn+06 say " Sub-total  " font "arial" size 6 color aColor[9] 
   @nStartLine+182,nStartColumn+06 say " Acumulado  " font "arial" size 6 color aColor[9] 
   @nStartLine+187,nStartColumn+06 say " Total      " font "arial" size 6 color aColor[9] 
   @nStartLine+189,nStartColumn+06 say "(Observar Reposição)" font "arial" size 5 color aColor[9] 
   @nStartLine+189,nStartColumn+26 say image "SETADIREITA" width 5 height 5

   nStartColumn:=(nStartColumn+28)

   do while !atribuir->(eof()) .and. atribuir->atr_setor = setor->set_codigo
      y++
      nContaAlunos:=0
      produtos->(dbseek(cEmpresa+setor->set_PRODUT))
      cargos->(dbseek(cEmpresa+atribuir->atr_cargo))
      funciona->(dbseek(cEmpresa+atribuir->atr_funcio))

      @nStartLine+00 ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+03,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+0.2,(nStartColumn+06)+(y*18) say alltrim(substr(cargos->car_descri,1,12)) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @nStartLine+04 ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+06.6,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+07)+(y*18) say "ANO"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+04 ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+06.6,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+4.2,(nStartColumn+17)+(y*18) say "BIM"           FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+09.2,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+07)+(y*18) say cAnoLetivoAtual FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+6.6,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+09.2,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+6.8,(nStartColumn+17)+(y*18) say cBimestreAtual  FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+9.2,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+11.8,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+9.4,(nStartColumn+08)+(y*18) say " CLASSE "      FONT "arial" SIZE 6.5 COLOR aColor[9]
      
      @nStartLine+11.8,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+06)+(y*18) say "T" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+10)+(y*18) say "G" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+15)+(y*18) say "S" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @nStartLine+11.8,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+14.4,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @nStartLine+12  ,(nStartColumn+19)+(y*18) say "t" FONT "arial" SIZE 6.5 COLOR aColor[9]

      turmas->(dbseek(cEmpresa+setor->set_codigo+cAnoLetivoAtual))

      @ nStartLine+14.4,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+06)+(y*18) say  if(alltrim(setor->set_period)="NOITE","5",if(alltrim(setor->set_period)="TARDE","3","1")) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+10)+(y*18) say alltrim(produtos->pro_tipo) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+15)+(y*18) say substr(alltrim(setor->set_descri),1,1) FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+14.4,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+16.7,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+14.6,(nStartColumn+19)+(y*18) say substr(alltrim(setor->set_descri),2,1) FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+16.7,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+19.3,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+16.9,(nStartColumn+07)+(y*18) say "COMP.CUR." FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+19.3,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+21.9,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+19.5,(nStartColumn+09)+(y*18) say cargos->car_compon FONT "arial" SIZE 6.5 COLOR aColor[9]

      @ nStartLine+21.9,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+06)+(y*18) say "Nº" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+10)+(y*18) say "M" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+15)+(y*18) say "F" FONT "arial" SIZE 6.5 COLOR aColor[9]
      @ nStartLine+21.9,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+24.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+22.1,(nStartColumn+19)+(y*18) say "AC" FONT "arial" SIZE 6.5 COLOR aColor[9]

      *nStartLine:=25.5

      do while !turmas->(eof()) .and. turmas->tur_setor = setor->set_codigo
         notas->(dbseek(cEmpresa+setor->set_codigo+atribuir->atr_funcio+atribuir->atr_cargo+cAnoLetivoAtual+cBimestreAtual+turmas->tur_chamad+turmas->tur_aluno))  //não verifica se achou resultado, pois assim é impresso o resultado de alunos que não realizaram a prova, isso é, TRAÇO.
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) say turmas->tur_chamad FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         if alltrim(turmas->tur_status)$"REMANEJADO(A)¦TRANSFERIDO(A)¦RECLASSIFICADO" .and. dtos(turmas->tur_datast) < dtos(dDtLimBimAtual) 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+10)+(y*18) say "TR" FONT "arial" SIZE 6.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         else 
            @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+11)+(y*18) say notas->not_nota FONT "arial" SIZE 6.5 COLOR if(val(notas->not_nota)>=5, aColor[11],aColor[3]) 
         endif 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+15)+(y*18) say notas->not_faltas FONT "arial" SIZE 6.5 COLOR aColor[9]
 
         @ nStartLine+(nContaAlunos*2.5)+25.5    ,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+(nContaAlunos*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
         @ nStartLine+(nContaAlunos*2.5)+25.5+0.2,(nStartColumn+19)+(y*18) say notas->not_compen FONT "arial" SIZE 6.5 COLOR aColor[9]

         nContaAlunos++
         nChamada:=val(turmas->tur_chamad)         
         turmas->(dbskip(1))
      enddo
      for i = 0 to (59-nContaAlunos) //acaba de preencher lista de numeros de chamada até 65
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+09)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.2,(nStartColumn+06)+(y*18) say strzero(++nChamada,2,0) FONT "arial" SIZE 6.5 COLOR aColor[9] 
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+09)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+14)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+14)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+18)+(y*18) PENWIDTH 0.1
         @ nStartLine+((nContaAlunos+i)*2.5)+25.5    ,(nStartColumn+18)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+2.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1  //Ausências Compensadas não previstas no sistema
      next i
      capabime->(dbseek(cEmpresa+setor->set_codigo+funciona->fun_codigo+cargos->car_codigo+cAnoLetivoAtual+cBimestreAtual))
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5     ,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+22)+(y*18) PENWIDTH 0.1
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+0.5 ,(nStartColumn+06)+(y*18) say "Rubr.Prof."      FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+3   ,(nStartColumn+06)+(y*18) say substr(funciona->fun_nome,1,17)  FONT "arial" SIZE 4.9 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+8.2 ,(nStartColumn+06)+(y*18) say "Aulas Previstas: "+capabime->cap_aulapr FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+11  ,(nStartColumn+06)+(y*18) say "Aulas Dadas: "+capabime->cap_aulada     FONT "arial" SIZE 5 COLOR aColor[9]
      @ nStartLine+((nContaAlunos+i)*2.5)+25.5+13.5,(nStartColumn+05)+(y*18) say RECTANGLE TO nStartLine+((nContaAlunos+i)*2.5)+25.5+17,(nStartColumn+22)+(y*18) PENWIDTH 0.1 //retangulo para colocar reposição de aulas
      atribuir->(dbskip(1))
   enddo
*/
   end PAGE
   setor->(dbskip(1))
enddo   
end DOC
capabime->(dbsetorder(2))
RELEASE PRINTSYS
return
