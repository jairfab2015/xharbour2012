#include "minigui.ch"
Memvar cFormAtivo, cFormAnterior, cOperacao, cBrowseTitulo, cAliasTab, aLabelsEdit, aCamposTip, i_Temp, cCodFuncionario, cFuncionarioMaster
Memvar aList, aCamposEdit, aTabPrincipal, cEmpresa, nTabPage, aExecutaAposExclusao, cAliasBrowse, nNumRecPri 
//-----------------------------------------------------------------------------------------------------------------------
procedure Editar(cReg, nNro)
//-----------------------------------------------------------------------------------------------------------------------
Local nLinha, i
Private cFormAnterior:=cFormAtivo

if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

cFormAtivo:="FrmEdita"
if cReg == "0"  //se cReg é igual a zero é porque trata-se de uma inclusao de registro
   cOperacao="INC"
   dbgobottom()
   dbskip(1)
else   
   dbgoto(val(cReg))
endif
DEFINE WINDOW FrmMestreEdita AT 0,0 WIDTH 490 HEIGHT 600 VIRTUAL WIDTH NIL VIRTUAL HEIGHT NIL TITLE cBrowseTitulo MODAL NOSYSMENU 
   DEFINE SPLITBOX
      DEFINE TOOLBAR ToolBar_Edita BUTTONSIZE 35,35 FONT "Verdana" SIZE 6
         BUTTON ButEdit1 CAPTION "Salva"    PICTURE "B_SALVA"    ACTION if(AtualizaRegistro(cAliasTab,"EDITA"),FinalizaEdit(),.t.)  //atualiza e fecha a janela
         BUTTON ButEdit2 CAPTION "Sai"      PICTURE "B_SAI"      ACTION FinalizaEdit()
      END TOOLBAR
      DEFINE WINDOW FrmEdita WIDTH 490 HEIGHT 530 VIRTUAL WIDTH 491 VIRTUAL HEIGHT 950 SPLITCHILD NOCAPTION
         nLinha:=0
         for i = 1 to len(aLabelsEdit)
            nLinha+=18
            DEFINE LABEL &("Label_"+cFormAtivo+strzero(i,2,0))
               ROW    nLinha
               COL    10
               WIDTH  108
               HEIGHT 12
               VALUE &("'"+aLabelsEdit[i]+"'")
               FONTNAME "Verdana"
               FONTSIZE 6
               FONTBOLD .t.
               TRANSPARENT .T.
            END LABEL
         next i
         nLinha:=0
         for i = 1 to len(aCamposEdit)
            nLinha+=18
            if aCamposTip[i,1] = "TEXT"
               if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
                  DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    125
                     WIDTH  90
                     HEIGHT 13
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                     UPPERCASE .T.
                     ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                     if valtype(&(aCamposEdit[i])) = "D"
                        DATE .T.
                     elseif valtype(&(aCamposEdit[i])) = "N"
                        NUMERIC .T.
                     endif
                     if !empty(aCamposTip[i,4])
                        INPUTMASK aCamposTip[i,4] 
                     endif
                     *ONLOSTFOCUS Consulta(aCamposTip[i_temp,2][1],{"Text_"+cFormAtivo+strzero(i_temp,2,0), aCamposTip[i_temp,2][2]}, aCamposTip[i_temp,2][3],.T.,2,i_temp)
                  END TEXTBOX
                  DEFINE LABEL &("Label_99"+cFormAtivo+strzero(i,2,0))  //define rótulo para colocar nome por extenso a partir do código informado pelo operador. Esse rotulo será sempre o Label_99
                     ROW    nLinha
                     COL    218
                     WIDTH  192
                     HEIGHT 12
                     *BACKCOLOR {253,253,253}
                     VALUE ""
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                  END LABEL
                  DEFINE BUTTON &("ButCon_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    412
                     WIDTH  15
                     HEIGHT 14
                     CAPTION "P"
                     ACTION Consulta(aCamposTip[i_temp,2][1],{"Text_"+cFormAtivo+strzero(i_temp,2,0), aCamposTip[i_temp,2][2]}, aCamposTip[i_temp,2][3],.f.,2,i_temp)
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                     FONTBOLD .T.
                  END BUTTON
               else 
                  DEFINE TEXTBOX &("Text_"+cFormAtivo+strzero(i,2,0))
                     ROW    nLinha
                     COL    125
                     WIDTH  290
                     HEIGHT 13
                     FONTNAME "Verdana"
                     FONTSIZE 6
                     FONTBOLD .T.
                     UPPERCASE .T.
                     if valtype(&(aCamposEdit[i])) = "D"
                        DATE .T.
                        NUMERIC .F.
                     elseif valtype(&(aCamposEdit[i])) = "N"
                        NUMERIC .T.
                        DATE .F.
                     endif
                     if !empty(aCamposTip[i,4])
                        INPUTMASK aCamposTip[i,4] 
                     endif
                  END TEXTBOX
                  if i = 1 .and. !(cReg == "0") // não deixa alterar o código, porque ele é automático (somente se não for um novo registro)
                     setproperty("FrmEdita", "Text_"+cFormAtivo+strzero(i,2,0), "enabled", .f.)
                  endif
               endif 
            elseif aCamposTip[i,1] = "COMBO" 
               DEFINE COMBOBOX &("Combo_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  290
                  HEIGHT 100
                  if aCamposTip[i,2] //se for .t. essa posição significa que os dados do combo devem vir de um arquivo dbf
                     ITEMS {""}  //inicialmente declara os itens em branco para depois de terminado a formação do combo inserir os valores de acordo com o dbf escolhido pelo programador (veja logo abaixo)
                  else
                     ITEMS &(aCamposTip[i,3]) //se for .f. significa que o operador já informou os itens que deverão ser inseridos no combo
                  endif
                  VALUE 0
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .T.
               END COMBOBOX
               if aCamposTip[i,2] //se for .t. essa posição significa que os dados do combo devem vir de um arquivo dbf
                  &(aCamposTip[i,3])->(dbgotop())
                  do while !&(aCamposTip[i,3])->(eof())
                     domethod("frmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"additem", &(aCamposTip[i,3])->&(aCamposTip[i,4]))
                     &(aCamposTip[i,3])->(dbskip(1))
                  enddo
               endif
            elseif aCamposTip[i,1] = "DATA" 
               DEFINE DATEPICKER &("Date_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  290
                  HEIGHT 14
                  VALUE nil
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .T.
               END DATEPICKER
            elseif aCamposTip[i,1] = "MEMO" 
               DEFINE EDITBOX &("Edit_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  290
                  HEIGHT 100
                  VALUE ""
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  FONTBOLD .T.
               END EDITBOX
               nLinha+=60  //como o controle Combo deve ser o último na lista de edição, colocamos o nLinha maior para o redimensionamento da janela de edição dar certo e abranger o tamanho da caixa Memo
            elseif aCamposTip[i,1] = "CHKBOX"
               DEFINE CHECKBOX &("Chk_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    125
                  WIDTH  200
                  HEIGHT 18
                  VALUE .F.
                  CAPTION " "
                  FONTNAME "Arial"
                  FONTSIZE 9
                  TOOLTIP ""
                  TABSTOP .T.
               END CHECKBOX
            elseif aCamposTip[i,1] = "LISTBOX"
               Define ListBox &("Lst_"+cFormAtivo+strzero(i,2,0))
                  Row	 nLinha
               	Col	 125
                 	Width	 20
                 	HEIGHT 15
                  TRANSPARENT .F. 
                  MULTISELECT .T.
               End ListBox
            elseif aCamposTip[i,1] = "LSTBOXDUO"
               DEFINE LISTBOX &("LstDuo_1_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    75
                  WIDTH  150
                  HEIGHT 100
                  ITEMS {''}
                  VALUE 0
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  TOOLTIP ""
                  ONCHANGE Nil
                  ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                  ONLOSTFOCUS Nil
                  FONTBOLD .F.
                  FONTITALIC .F.
                  FONTUNDERLINE .F.
                  FONTSTRIKEOUT .F.
                  *BACKCOLOR NIL
                  FONTCOLOR NIL
                  ONDBLCLICK TransfereListBoxDuo(i_temp,"FrmEdita")
                  TABSTOP .T.
                  SORT .F.
                  MULTISELECT .F.
               END LISTBOX
               DEFINE LISTBOX &("LstDuo_2_"+cFormAtivo+strzero(i,2,0))
                  ROW    nLinha
                  COL    230
                  WIDTH  150
                  HEIGHT 100
                  ITEMS {''}
                  VALUE 0
                  FONTNAME "Verdana"
                  FONTSIZE 6
                  TOOLTIP ""
                  ONCHANGE Nil
                  ONGOTFOCUS (i_temp:=val(substr(this.name,-2)))
                  ONLOSTFOCUS Nil
                  FONTBOLD .F.
                  FONTITALIC .F.
                  FONTUNDERLINE .F.
                  FONTSTRIKEOUT .F.
                  *BACKCOLOR NIL
                  FONTCOLOR NIL
                  ONDBLCLICK DeletaItemListBoxDuo(i_temp,"FrmEdita")
                  TABSTOP .T.
                  SORT .F.
                  MULTISELECT .F.
               END LISTBOX
            ENDIF
         next i
      END WINDOW
   END SPLITBOX
END WINDOW
dbunlock()
*FrmEdita.height := (nLinha+228) //recalcula tamanho da janela depois de criar todos os campos de edição
AtuaCampoRegGrid(cReg, nNro)
CENTER WINDOW FrmMestreEdita
ACTIVATE WINDOW FrmMestreEdita
Return

//---------------------------------------------------------------------------
Static Procedure AtuaCampoRegGrid(cReg, nNro) //preenche os campos a serem editados após o operador selecionar Editar, Alterar no grid
//---------------------------------------------------------------------------
Local i, x, n_for, nComboItemCount, nNroRecord
for i = 1 to len(aCamposEdit)
   if cReg == "0"  // somente preenche automaticamente os campos de edição se for Inclusão. Na alteração, os campos de edição terão o mesmo valor dos campos do DBF.
      for x = 1 to len(aTabPrincipal[nNro,4]) //verifica se alguns campos chaves devem ser preenchidos automaticamente
         if upper(aTabPrincipal[nNro,4,x,2])=upper(aCamposEdit[i])
            if valtype(&(aCamposEdit[i])) == "C"
               setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", &(aTabPrincipal[nNro,4,x,1]))
               DoMethod("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"SETFOCUS") //faz com que os campos textos com label de pesquisa (label_99?) tenham seu label atualizado (como se o operador tivesse digitado tab) na funcao TransfereRegistro() do programa Consulta.prg
            elseif valtype(&(aCamposEdit[i])) == "D"
               setproperty("FrmEdita","Date_"+cFormAtivo+strzero(i,2,0),"Value", &(aTabPrincipal[nNro,4,x,1]))
            endif               
         endif
      next x
   endif

   if aCamposTip[i,1]="TEXT"
      if cReg!="0"
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
      endif
      if cReg == "0" .and. i = 1  //se a operação é de inclusão de registro novo (reg=="0") e for o primeiro campo (i=1), significa que devemos por o número do registro nesse campo. Isso é padrão para todos os dbfs
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Value", strzero(recno(),6,0))
         setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.)
      endif
      if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
         setproperty("FrmEdita","Label_99"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposTip[i,2][1])->&(aCamposTip[i,2][3]))
      endif
   elseif aCamposTip[i,1]="DATA"
      if cReg!="0"
      setproperty("FrmEdita","Date_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))      
      endif
   elseif aCamposTip[i,1]="MEMO"
      setproperty("FrmEdita","Edit_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1] = "CHKBOX"
      setproperty("FrmEdita","Chk_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1] = "LISTBOX"
      setproperty("FrmEdita","Lst_"+cFormAtivo+strzero(i,2,0),"Value", &(aCamposEdit[i]))
   elseif aCamposTip[i,1]="COMBO"
      nComboItemCount:=getproperty("FrmEdita", "Combo_"+cFormAtivo+strzero(i,2,0), "itemcount") //conta quantos itens tem no combo
      for x = 1 to nComboItemCount
         if alltrim(&(aCamposEdit[i])) == alltrim(getproperty("FrmEdita", "Combo_"+cFormAtivo+strzero(i,2,0), "item", x))
            setproperty("FrmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"Value", x)
            exit
         endif
      next x
      if x > nComboItemCount
         setproperty("FrmEdita","Combo_"+cFormAtivo+strzero(i,2,0),"Value", 1)
      endif 
   elseif aCamposTip[i,1] = "LSTBOXDUO"
      domethod("FrmEdita","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"deleteallitems")
      domethod("FrmEdita","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"deleteallitems")

      //preenche ListboxDuo1
      nNroRecord:=&(aList[1])->(recno()) //guarda o número do registro, pois pode estar pegando os codigos no mesmo banco de dado sendo manipulado, alterando a posição do ponteiro

      &(aList[1])->(dbgotop())
      do while !&(aList[1])->(eof())
         if eval(aList[3])
            domethod("FrmEdita","LstDuo_1_"+cFormAtivo+strzero(i,2,0),"additem",eval(aList[4]))
         endif 
         &(aList[1])->(dbskip(1))
      enddo

      &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro  para operacoes com o mesmo banco de dado para os dois listboxDuo

      //preenche listboxDuo2 (se houver registros selecionados para ele)
      for n_for = 1 to len(&(aCamposEdit[i])) step 6  //step 6 é o tamanho de cada registro
         if empty(substr(&(aCamposEdit[i]),n_for,6))  //pega os codigos do campo até não ter mais (branco)
            exit
         endif
         &(aList[2])->(dbseek(cEmpresa+substr(&(aCamposEdit[i]),n_for,6)))
         domethod("FrmEdita","LstDuo_2_"+cFormAtivo+strzero(i,2,0),"additem",eval(aList[4]))
         &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro para operacoes com o mesmo banco de dado para os dois listboxDuo
      next n_for
      &(aList[1])->(dbgoto(nNroRecord)) //volta para a posição anterior, no caso de ter sido alterado o ponteiro para operacoes com o mesmo banco de dado para os dois listboxDuo
   endif
      for x = 1 to len(aTabPrincipal[nNro,4]) //verifica se alguns campos chaves devem ser preenchidos automaticamente
         if upper(aTabPrincipal[nNro,4,x,2])=upper(aCamposEdit[i])
               setproperty("FrmEdita","Text_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
               if !empty(aCamposTip[i,2])  //se a segunda posição do vetor estiver preenchido é porque este campo terá um botão de consulta e um label com a descrição do registro
                  setproperty("FrmEdita","ButCon_"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
                  setproperty("FrmEdita","Label_99"+cFormAtivo+strzero(i,2,0),"Enabled", .f.) //não deixa operador alterar campos pré-definidos
               endif
         endif
      next x

next i

//DoMethod("FrmEdita","Text_01","SETFOCUS") //posiciona a digitação no campo apropriado para o digitador (talvez dê erro se o text_01 não existir)
return

//---------------------------------------------------------------------------
Procedure DeletaGrid(nRecord)
//---------------------------------------------------------------------------
Local j
if !(cCodFuncionario = cFuncionarioMaster) //permite que funcionario master altere livremente. Esse funcionario é setado na função configurasistema em funcoes.prg
   msgStop("SEM AUTORIZAÇÃO PARA ENTRAR NESSE MÓDULO. FAVOR CONTATAR ADMINISTRADOR DO SISTEMA.")
   return 
endif

dbgoto(val(nRecord))

nTabPage:=Getproperty("TabWindow","Tab_1","value")
if msgyesno("Confirma Deleção do item selecionado?")
   if !tentaAcesso(cAliasTab);return;endif
   DBDelete()   //o banco atual é o correto, não precisa colocar o alias
   dbunlock()
   for j = 1 to len(aExecutaAposExclusao) // executa as funções pós-operações descritas em funcoes
      Eval(aExecutaAposExclusao[j])
   next j    
   RefreshGrid(nTabPage-1)
endif
return

//---------------------------------------------------------------------------
Procedure LocalizaGrd(pAlias, nNroGrd)
//---------------------------------------------------------------------------
Local i, x, nQtdeItens, aitem, nValue
nQtdeItens:=Getproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "itemcount")
if empty(nQtdeItens)
   msginfo("Não há registros para processar.")
   return
endif
For x = 1 To nQtdeItens
   if empty(GetProperty("TabWindow","Txt_"+strzero(nNroGrd,2,0),"value"))
      msginfo("Texto de pesquisa em branco!")
      return
   endif
   aItem := Getproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "item", x)  
   nValue:=Getproperty("TabWindow","ComboPesq_"+strzero(nNroGrd,2,0),"value")
   If rtrim(aItem[nValue]) = rtrim(GetProperty("TabWindow","Txt_"+strzero(nNroGrd,2,0),"value"))
      Setproperty("TabWindow", "Grd_"+strzero(nNroGrd,2,0), "value", x)
      DoMethod("TabWindow","Grd_"+strzero(nNroGrd,2,0),"REFRESH")
      DoMethod("TabWindow","Grd_"+strzero(nNroGrd,2,0),"SETFOCUS")
      Exit
   EndIf
Next x
if x > nQtdeItens
   msginfo("Registro não encontrado.")
endif
return

//---------------------------------------------------------------------------
Function FinalizaEdit()
//---------------------------------------------------------------------------
cOperacao:=""
cFormAtivo:=cFormAnterior
(cAliasBrowse)->(dbgoto(nNumRecPri)) //volta ao registro original no browse caso tenha sido alterado pelos set relations neste módulo ou no módulo consulta.prg.
FrmMestreEdita.release
Return(.t.)

//eof
