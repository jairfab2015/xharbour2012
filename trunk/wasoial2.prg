
#define CRLF CHR(13)+CHR(10)

*--- HTMPPRINT.PRG  ----*
#command DEFAULT <param> := <val> [, <paramn> := <valn> ];
=> ;
         <param> := IIF(<param> = NIL, <val>, <param> ) ;
         [; <paramn> := IIF(<paramn> = NIL, <valn>, <paramn> ) ]


#include "harbourboleto.ch"
#include "hbclass.ch"
#include "fileio.ch"
#include "common.ch"

#Translate StoD(<p>) => CTOD(RIGHT(<p>, 2) + "/" + SUBSTR(<p>, 5, 2) + "/" + LEFT(<p>, 4))


function main

LOCAL oBol

   oBol   := oRemessa(cBanco)
   **Empresa->CGC
   *oBol:Cedente     := SUBSTR( EMPRESA->NOME, 1, 30 )
   oBol:DtVenc      := DATE()
   oBol:Open()
   oBol:Execute( )


*--- Finaliza a geracao do arquivo ---*
oBol:Close()


RETURN ( NIL )
*----------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*  Geracao de arquivo bancario  CNAB240                                        *
*                                                                              *
* -----------------------------------------------------------------------------*
CLASS oRemessa

   DATA cLine              INIT ""  PROTECTED
   DATA nSeqReg            INIT 2   PROTECTED  // Sequencial do Registro
   DATA cFillTrailer       INIT " " PROTECTED  // Caracter para preencher a ultima linha do arquivo
   DATA DtEmis             INIT DATE()
   DATA DtVenc             INIT DATE()
   DATA NomeRem            INIT "TEST.TXT"
   nHandle                 INIT ""

   METHOD New() CONSTRUCTOR
   
   METHOD Execute( )

   METHOD OPEN()

   METHOD Add()

   METHOD CLOSE()

   METHOD Line()

ENDCLASS
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*      
* -----------------------------------------------------------------------------*
METHOD new() CLASS oRemessa

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD OPEN() CLASS oRemessa

LOCAL nI := 1 , cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 

::cData := STRZERO(DAY(::DtEmis),2)+STRZERO(MONTH(::DtEmis),2)+RIGHT(STR(YEAR(::DtEmis)),2)
*--- Nome do arquivo ---*
cArq := "CB"+RIGHT(STR(YEAR(::DtEmis)),2)+STRZERO(MONTH(::DtEmis),2)+STRZERO(DAY(::DtEmis),2)



IF EMPTY(::Destino)
   cPasta := ALLTRIM(cPasta)
   IF RIGHT(cPasta,1) != HB_OSpathseparator()
      cPasta += HB_OSpathseparator()
   ENDIF

   IF !IsDirectory(cPASTA)
      MAKEDIR(ALLTRIM(cPASTA))
   ENDIF


ENDIF

IF EMPTY(::Destino)
   FERASE(::Destino+::NomeRem)
ENDIF 
   ::nHandle := FCREATE(::Destino+::NomeRem,FC_NORMAL)



::cLine := ""


IF ::nHandle < 0  // Header

ELSE  // FEBRABAN  CNAB240 

  * ::cData := STRZERO(DAY(::DtEmis),2)+STRZERO(MONTH(::DtEmis),2)+RIGHT(STR(YEAR(::DtEmis)),4)

   // Header Arquivo
   ::cLine += "S-1000 - Informa��es do Empregador"
   ::Line()

ENDIF

RETURN ::nHandle
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Add(oBol) CLASS oRemessa

LOCAL cMsg, cCart

*::nTitLote ++
*::nSeqReg ++
*::nValorTotal += ::nValor // Acumula o valoor 

*::sDtVenc := STRZERO(DAY(::DtVenc),2)+STRZERO(MONTH(::DtVenc),2)+RIGHT(STR(YEAR(::DtVenc)),4)
*::sDtVenc := SUBSTR( DTOC(::DtVenc), 1, 2 ) + SUBSTR( DTOC(::DtVenc), 4, 2 ) + STR( YEAR(::DtVenc), 4 )

// Registro detalhe Segmento A
// Registro detalhe Segmento A
::cLine += "S-1010 Tabela de Rubricas"
::Line()

::cLine += " S-1010 Tabela de Rubricas"
::Line()
::cLine += " S-1020 Tabela de Lota��es/Departamentos"
::Line()
::cLine += " S-1030 Tabela de Cargos"
::Line()
::cLine += " S-1040 Tabela de Fun��es"
::Line()
::cLine += " S-1050 Tabela de Hor�rios/Turnos de Trabalho"
::Line()
::cLine += " S-1060 Tabela de Estabelecimentos/Obras"
::Line()
::cLine += " S-1070 Tabela de Processos Administrativos/Judiciais"
::Line()
::cLine += " S-1080 Tabela de Operadores Portu�rios"
::Line()
::cLine += " S-1100 eSocial Mensal � Abertura"
::Line()
::cLine += " S-1200 eSocial Mensal � Remunera��o do Trabalhador"
::Line()
::cLine += " S-1310 eSocial Mensal � Outras Informa��es - Serv. Tomados (Cess�o de M�o de Obra)"
::Line()
::cLine += " S-1320 eSocial Mensal � Outras Informa��es - Serv. Prestados (Cess�o de M�o de Obra)"
::Line()
::cLine += " S-1330 eSocial Mensal � Outras Informa��es - Serv. Tomados de Cooperativa de Trabalho"
::Line()
::cLine += " S-1340 eSocial Mensal � Outras Informa��es - Serv. Prestados pela Cooperativa de Trabalho"
::Line()
::cLine += " S-1350 eSocial Mensal � Outras Informa��es - Aquisi��o de Produ��o"
::Line()
::cLine += " S-1360 eSocial Mensal � Outras Informa��es - Comercializa��o da Produ��o"
::Line()
::cLine += " S-1370 eSocial Mensal � Outras Informa��es - Rec. Recebidos ou Repassados p/ Clube de Futebol"
::Line()
::cLine += " S-1400 eSocial Mensal � Bases, Reten��o, Dedu��es e e Contribui��es"
::Line()
::cLine += " S-1500 eSocial Mensal � Resumo da Folha e Encerramento das Informa��es"
::Line()
::cLine += " S-2100 EVENTO - Cadastramento Inicial do V�nculo"
::Line()
::cLine += " S-2200 EVENTO - Admiss�o de Trabalhador"
::Line()
::cLine += " S-2220 EVENTO - Altera��o de Dados Cadastrais do Trabalhador"
::Line()
::cLine += " S-2240 EVENTO - Altera��o de Contrato de Trabalho"
::Line()
::cLine += " S-2260 EVENTO - Comunica��o de Acidente de Trabalho "
::Line()
::cLine += " S-2280 EVENTO - Atestado de Sa�de Ocupacional"
::Line()
::cLine += " S-2300 EVENTO - Aviso de F�rias"
::Line()
::cLine += " S-2320 EVENTO - Afastamento Tempor�rio"
::Line()
::cLine += " S-2325 EVENTO - Altera��o de Motivo de Afastamento"
::Line()
::cLine += " S-2330 EVENTO - Retorno de Afastamento Tempor�rio"
::Line()
::cLine += " S-2340 EVENTO - Estabilidade � In�cio"
::Line()
::cLine += " S-2345 EVENTO - Estabilidade � T�rmino "
::Line()
::cLine += " S-2360 EVENTO - Condi��o Diferenciada de Trabalho - In�cio "
::Line()
::cLine += " S-2365 EVENTO - Condi��o Diferenciada de Trabalho - T�rmino"
::Line()
::cLine += " S-2400 EVENTO - Aviso Pr�vio "
::Line()
::cLine += " S-2405 EVENTO - Cancelamento de Aviso Pr�vio"
::Line()
::cLine += " S-2420 EVENTO - Atividades Desempenhadas pelo Trabalhador "
::Line()
::cLine += " S-2440 EVENTO - Comunica��o de Fato Relevante "
::Line()
::cLine += " S-2600 EVENTO - Trabalhador Sem V�nculo de Emprego - In�cio "
::Line()
::cLine += " S-2620 EVENTO - Trabalhador Sem V�nculo de Emprego - Alt. Contratual "
::Line()
::cLine += " S-2680 EVENTO - Trabalhador Sem V�nculo de Emprego - Desligamento "
::Line()
::cLine += " S-2800 EVENTO � Desligamento "
::Line()
::cLine += " S-2820 EVENTO - Reintegra��o por Determina��o Judicial"
::Line()
::cLine += " S-2900 EVENTO - Exclus�o de Evento Enviado Indevidamente"
::Line()




RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD CLOSE() CLASS oRemessa

*   ::nSeqReg += 2
*
*   *--- Trailer Arquivo ---*
*   ::cLine += ::cCodBco        // codigo do banco
*   ::cLine += "9999"           // lote de servico
*   ::cLine += "9"              // tipo de registro
*   ::cLine += SPACE(9)         // use exclusivo FEBRABAN
*   ::cLine += "000001"         // Quantidade de lotes do arquivo
*   ::cLine += STRZERO((::nSeqReg),6)             // Quantidade de registros do arquivo
*   ::cLine += SPACE(211) +CHR(10)+CHR(26)        // uso exclusivo FEBRABAN
*   ::Line()
   FCLOSE(::nHandle)



RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Line() CLASS oRemessa

::cLine := UPPER(::cLine)
FWRITE(::nHandle,::cLine+CRLF)
*IF LEN(::cLine) != 240            // Erro!
*   FWRITE(::nHandle,STRZERO(LEN(::cLine),5)+CRLF)
*ENDIF
::cLine := ""

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Execute( ) CLASS oRemessa

LOCAL cNsNm, dDataBase, cFatorVenc, cDGCB, cCodBar, nX, nY, cC1RN, cC2RN, cC3RN, cC4RN, cC5RN, cRNCB,;
      cInstr, cCpoLivre := "", cAgCC, cCarteira, cNumAgencia, cCVT := "", cDataHSBC

::add(Self)
** FAZER O PROCESSAMENTO AQUI 

RETURN Self
*------------------------------------------------------------------------------*






* S1000 - Informa��es do Empregador
* S1010 Tabela de Rubricas
* S1020 Tabela de Lota��es/Departamentos
* S1030 Tabela de Cargos
* S1040 Tabela de Fun��es
* S1050 Tabela de Hor�rios/Turnos de Trabalho
* S1060 Tabela de Estabelecimentos/Obras
* S1070 Tabela de Processos Administrativos/Judiciais
* S1080 Tabela de Operadores Portu�rios
* S1100 eSocial Mensal � Abertura
* S1200 eSocial Mensal � Remunera��o do Trabalhador
* S1310 eSocial Mensal � Outras Informa��es - Serv. Tomados (Cess�o de M�o de Obra)
* S1320 eSocial Mensal � Outras Informa��es - Serv. Prestados (Cess�o de M�o de Obra)
* S1330 eSocial Mensal � Outras Informa��es - Serv. Tomados de Cooperativa de Trabalho
* S1340 eSocial Mensal � Outras Informa��es - Serv. Prestados pela Cooperativa de Trabalho
* S1350 eSocial Mensal � Outras Informa��es - Aquisi��o de Produ��o
* S1360 eSocial Mensal � Outras Informa��es - Comercializa��o da Produ��o
* S1370 eSocial Mensal � Outras Informa��es - Rec. Recebidos ou Repassados p/ Clube de Futebol
* S1400 eSocial Mensal � Bases, Reten��o, Dedu��es e e Contribui��es
* S1500 eSocial Mensal � Resumo da Folha e Encerramento das Informa��es
* S2100 EVENTO - Cadastramento Inicial do V�nculo
* S2200 EVENTO - Admiss�o de Trabalhador
* S2220 EVENTO - Altera��o de Dados Cadastrais do Trabalhador
* S2240 EVENTO - Altera��o de Contrato de Trabalho
* S2260 EVENTO - Comunica��o de Acidente de Trabalho
* S2280 EVENTO - Atestado de Sa�de Ocupacional
* S2300 EVENTO - Aviso de F�rias
* S2320 EVENTO - Afastamento Tempor�rio
* S2325 EVENTO - Altera��o de Motivo de Afastamento
* S2330 EVENTO - Retorno de Afastamento Tempor�rio
* S2340 EVENTO - Estabilidade � In�cio
* S2345 EVENTO - Estabilidade � T�rmino
* S2360 EVENTO - Condi��o Diferenciada de Trabalho - In�cio
* S2365 EVENTO - Condi��o Diferenciada de Trabalho - T�rmino
* S2400 EVENTO - Aviso Pr�vio
* S2405 EVENTO - Cancelamento de Aviso Pr�vio
* S2420 EVENTO - Atividades Desempenhadas pelo Trabalhador
* S2440 EVENTO - Comunica��o de Fato Relevante
* S2600 EVENTO - Trabalhador Sem V�nculo de Emprego - In�cio
* S2620 EVENTO - Trabalhador Sem V�nculo de Emprego - Alt. Contratual
* S2680 EVENTO - Trabalhador Sem V�nculo de Emprego - Desligamento
* S2800 EVENTO � Desligamento
* S2820 EVENTO - Reintegra��o por Determina��o Judicial
* S2900 EVENTO - Exclus�o de Evento Enviado Indevidamente
* 
* 
* 
* ////  methodos 
* S-1000 � Informa��es do Empregador
* 1 evtInfoEmpregador                 G - 1-1 - - Evento de informa��es do empregador
* 2 versao evtInfoEmpregador          A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtInfoEmpregador       G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento               G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                   E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                 E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento             E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                 E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento          G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoEmpregador infEvento         CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoEmpregador          G - 0-1 - - Inclus�o de novas informa��es
* 15 idePeriodo inclusao              G - 1-1 - - Per�odo de validade das informa��es inclu�das
* 16 dtIniValidade idePeriodo         E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 17 dtFimValidade idePeriodo         E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 18 infoCadastro inclusao            G - 1-1 - - Informa��es do empregador
* 19 nomeRazao infoCadastro           E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 20 classTrib infoCadastro           E N 1-1 002 - Preencher com o c�digo correspondente � classifica��o
* 21 natJuridica infoCadastro         E N 1-1 004 - Preencher com o c�digo da Natureza Jur�dica do Contribuinte,
* 22 cnaePreponderante infoCadastro   E N 1-1 007 - Preencher com o c�digo do CNAE 2.0 conforme tabela
* 23 indCooperativa infoCadastro      E N 1-1 001 - Indicativo de Cooperativa:
* 24 indConstrutora infoCadastro      E N 1-1 001 - Indicativo de Construtora:
* 25 aliqGilrat infoCadastro          G - 0-1 - - Informa��es de apura��o da al�quota GILRAT
* 26 aliqRat aliqGilrat               E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 27 fap aliqGilrat                   E N 1-1 006 4 Fator Acident�rio de Preven��o
* 28 aliqRatAjustada aliqGilrat       E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 29 procAdmJudRat aliqGilrat         G - 0-1 - - Registro que identifica, em caso de exist�ncia, o processo
* 30 tpProcesso procAdmJudRat         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 31 nrProcesso procAdmJudRat         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 32 procAdmJudFap aliqGilrat         G - 0-1 - - Registro que identifica, em caso de exist�ncia, o processo
* 33 tpProcesso procAdmJudFap         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 34 nrProcesso procAdmJudFap         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 35 dadosIsencao infoCadastro        G - 0-1 - - Informa��es Complementares - Empresas Isentas - Dados da
* 36 siglaMin dadosIsencao            E C 1-1 008 - Identifica��o do Minist�rio/Lei que concedeu o Certificado:
* 37 nrCertificado dadosIsencao       E C 1-1 040 - N�mero do Certificado de Entidade Beneficente de Assist�ncia
* 38 dtEmissaoCertificado dadosIsencao E D 1-1 010 - Data de Emiss�o do Certificado/publica��o da Lei
* 39 dtVenctoCertificado dadosIsencao E D 1-1 010 - Data de Vencimento do Certificado
* 40 nrProtRenovacao dadosIsencao     E C 0-1 040 - N�mero do protocolo de pedido de renova��o
* 41 dtProtRenovacao dadosIsencao     E D 0-1 010 - Data do protocolo de renova��o
* 42 dtDou dadosIsencao               E D 0-1 010 - Preencher com a data de publica��o no Di�rio Oficial da Uni�o
* 43 pagDou dadosIsencao              E N 0-1 005 - Preencher com o n�mero da p�gina no DOU referente �
* 44 contato infoCadastro             G - 1-1 - - Informa��es de contato
* 45 nomeContato contato              E C 1-1 080 - Nome do contato na empresa
* 46 cpfContato contato               E N 1-1 011 - Preencher com o CPF do contato
* 47 foneFixo contato                 E C 0-1 012 - Informar o n�mero do telefone, com DDD.
* 48 foneCelular contato              E C 0-1 012 - Telefone celular
* 49 fax contato                      E C 0-1 011 - N�mero do Fax, com DDD
* 50 email contato                    E C 0-1 060 - Endere�o eletr�nico
* 51 infBancarias infoCadastro        G - 0-1 - - Informa��es Banc�rias
* 52 banco infBancarias               E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 53 agencia infBancarias             E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 54 tpContaBancaria infBancarias     E N 1-1 001 - Tipo de Conta:
* 55 nrContaBancaria infBancarias     E C 1-1 020 - N�mero da Conta Banc�ria
* 56 infoFGTS infoCadastro            G - 1-1 - - Informa��es exclusivas para o FGTS
* 57 utilizaFinanciamento infoFGTS    E C 1-1 001 - Utiliza��o de recursos do FGTS em financiamentos:
* 58 debitoAutomatico infoFGTS        E C 1-1 001 - D�bito autom�tico do FGTS:
* 59 avisosSMS infoFGTS               E C 1-1 001 - Ades�o aos servi�os de SMS:
* 60 agendaRecolhimento infoFGTS      E C 1-1 001 - Agendamento de recolhimento do FGTS:
* 61 softwareHouse infoCadastro       G - 0-1 - - Informa��es da empresa de Software
* 62 cnpjSoftwareHouse softwareHouse  E N 1-1 014 - CNPJ da Software House
* 63 nomeRazao softwareHouse          E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 64 nomeContato softwareHouse        E C 1-1 080 - Nome do contato na empresa
* 65 telefone softwareHouse           E C 0-1 012 - Informar o n�mero do telefone, com DDD.
* 66 codMunicipio softwareHouse       E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 67 uf softwareHouse                 E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 68 email softwareHouse              E C 0-1 060 - Endere�o eletr�nico
* 69 alteracao infoEmpregador         G - 0-1 - - Altera��o das informa��es
* 70 idePeriodo alteracao             G - 1-1 - - Per�odo de validade das informa��es alteradas
* 71 dtIniValidade idePeriodo         E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 72 dtFimValidade idePeriodo         E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 73 infoCadastro alteracao           G - 1-1 - - Informa��es do empregador
* 74 nomeRazao infoCadastro           E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 75 classTrib infoCadastro           E N 1-1 002 - Preencher com o c�digo correspondente � classifica��o
* 76 natJuridica infoCadastro         E N 1-1 004 - Preencher com o c�digo da Natureza Jur�dica do Contribuinte,
* 77 cnaePreponderante infoCadastro   E N 1-1 007 - Preencher com o c�digo do CNAE 2.0 conforme tabela
* 78 indCooperativa infoCadastro      E N 1-1 001 - Indicativo de Cooperativa:
* 79 indConstrutora infoCadastro      E N 1-1 001 - Indicativo de Construtora:
* 80 aliqGilrat infoCadastro          G - 0-1 - - Informa��es de apura��o da al�quota GILRAT
* 81 aliqRat aliqGilrat               E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 82 fap aliqGilrat                   E N 1-1 006 4 Fator Acident�rio de Preven��o
* 83 aliqRatAjustada aliqGilrat       E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 84 procAdmJudRat aliqGilrat         G - 0-1 - - Registro que identifica, em caso de exist�ncia, o processo
* 85 tpProcesso procAdmJudRat         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 86 nrProcesso procAdmJudRat         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 87 procAdmJudFap aliqGilrat         G - 0-1 - - Registro que identifica, em caso de exist�ncia, o processo
* 88 tpProcesso procAdmJudFap         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 89 nrProcesso procAdmJudFap         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 90 dadosIsencao infoCadastro        G - 0-1 - - Informa��es Complementares - Empresas Isentas - Dados da
* 91 siglaMin dadosIsencao            E C 1-1 008 - Identifica��o do Minist�rio/Lei que concedeu o Certificado:
* 92 nrCertificado dadosIsencao       E C 1-1 040 - N�mero do Certificado de Entidade Beneficente de Assist�ncia
* 93 dtEmissaoCertificado dadosIsencao E D 1-1 010 - Data de Emiss�o do Certificado/publica��o da Lei
* 94 dtVenctoCertificado dadosIsencao  E D 1-1 010 - Data de Vencimento do Certificado
* 95 nrProtRenovacao dadosIsencao      E C 0-1 040 - N�mero do protocolo de pedido de renova��o
* 96 dtProtRenovacao dadosIsencao      E D 0-1 010 - Data do protocolo de renova��o
* 97 dtDou dadosIsencao                E D 0-1 010 - Preencher com a data de publica��o no Di�rio Oficial da Uni�o
* 98 pagDou dadosIsencao               E N 0-1 005 - Preencher com o n�mero da p�gina no DOU referente �
* 99 contato infoCadastro             G - 1-1 - - Informa��es de contato
* 100 nomeContato contato             E C 1-1 080 - Nome do contato na empresa
* 101 cpfContato contato              E N 1-1 011 - Preencher com o CPF do contato
* 102 foneFixo contato                E C 0-1 012 - Informar o n�mero do telefone, com DDD.
* 103 foneCelular contato             E C 0-1 012 - Telefone celular
* 104 fax contato                     E C 0-1 011 - N�mero do Fax, com DDD
* 105 email contato                   E C 0-1 060 - Endere�o eletr�nico
* 106 infBancarias infoCadastro       G - 0-1 - - Informa��es Banc�rias
* 107 banco infBancarias              E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 108 agencia infBancarias            E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 109 tpContaBancaria infBancarias    E N 1-1 001 - Tipo de Conta:
* 110 nrContaBancaria infBancarias    E C 1-1 020 - N�mero da Conta Banc�ria
* 111 infoFGTS infoCadastro           G - 1-1 - - Informa��es exclusivas para o FGTS
* 112 utilizaFinanciamento infoFGTS   E C 1-1 001 - Utiliza��o de recursos do FGTS em financiamentos:
* 113 debitoAutomatico infoFGTS       E C 1-1 001 - D�bito autom�tico do FGTS:
* 114 avisosSMS infoFGTS              E C 1-1 001 - Ades�o aos servi�os de SMS:
* 115 agendaRecolhimento infoFGTS     E C 1-1 001 - Agendamento de recolhimento do FGTS:
* 116 softwareHouse infoCadastro      G - 0-1 - - Informa��es da empresa de Software
* 117 cnpjSoftwareHouse softwareHouse E N 1-1 014 - CNPJ da Software House
* 118 nomeRazao softwareHouse         E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 119 nomeContato softwareHouse       E C 1-1 080 - Nome do contato na empresa
* 120 telefone softwareHouse          E C 0-1 012 - Informar o n�mero do telefone, com DDD.
* 121 codMunicipio softwareHouse      E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 122 uf softwareHouse                E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 123 email softwareHouse             E C 0-1 060 - Endere�o eletr�nico
* 124 novaValidade alteracao          G - 1-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 125 dtIniValidade novaValidade      E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 126 dtFimValidade novaValidade      E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 127 exclusao infoEmpregador         G - 0-1 - - Exclus�o das informa��es
* 128 idePeriodo exclusao             G - 1-1 - - Informa��o destinada a localizar corretamente as informa��es j�
* 129 dtIniValidade idePeriodo        E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 130 dtFimValidade idePeriodo        E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* 
* S-1010 - Tabela de Rubricas
* 
* 1 evtTabRubrica                     G - 1-1 - - Evento destinada a incluir, alterar ou excluir informa��es da
* 2 versao evtTabRubrica              A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabRubrica           G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento               G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                   E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                 E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento             E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                 E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento          G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoRubrica infEvento            CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoRubrica             G - 0-1 - - Inclus�o de novas informa��es
* 15 ideRubrica inclusao              G - 1-1 - - Informa��es de identifica��o da rubrica e validade das
* 16 codRubrica ideRubrica            E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 17 dtIniValidade ideRubrica         E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideRubrica         E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosRubrica inclusao            G - 1-1 - - Detalhamento das informa��es da rubrica que est� sendo
* 20 descRubrica dadosRubrica         E C 1-1 100 - informar a descri��o (nome) da rubrica no sistema de folha de
* 21 natRubrica dadosRubrica          E N 1-1 004 - Informar o c�digo de classifica��o da rubrica de acordo com a
* 22 indProvDesc dadosRubrica         E C 1-1 001 - Indicativo do tipo de rubrica:
* 23 codIncidCP dadosRubrica          E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para a Previd�ncia
* 24 codIncidIRRF dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para o IRRF:
* 25 codIncidFGTS dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para o FGTS:
* 26 codIncidSIND dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para a Contribui��o
* 27 repDSR dadosRubrica              E C 1-1 001 - Indicar se a rubrica repercute no c�lculo do Descanso Semanal
* 28 repDecTerceiro dadosRubrica      E C 1-1 001 - Indicar se a rubrica repercute no c�lculo do 13� Sal�rio
* 29 repFerias dadosRubrica           E C 1-1 001 - Indicar se a rubrica repercute no c�lculo das F�rias.
* 30 repRescisao dadosRubrica         E C 1-1 001 - Indicar se a rubrica repercute no c�lculo da Rescis�o.
* 31 fatorRubrica dadosRubrica        E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necess�rio.
* 32 ideProcessoCP dadosRubrica       G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 33 tpProcesso ideProcessoCP         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 34 nrProcesso ideProcessoCP         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 35 extDecisao ideProcessoCP         E N 1-1 001 - Extens�o da Decis�o/Senten�a:
* 36 ideProcessoIRRF dadosRubrica     G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 37 tpProcesso ideProcessoIRRF       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 38 nrProcesso ideProcessoIRRF       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 39 ideProcessoFGTS dadosRubrica     G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 40 tpProcesso ideProcessoFGTS       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 41 nrProcesso ideProcessoFGTS       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 42 ideProcessoSIND dadosRubrica     G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 43 tpProcesso ideProcessoSIND       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 44 nrProcesso ideProcessoSIND       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 45 alteracao infoRubrica            G - 0-1 - - Altera��o de informa��es j� existentes
* 46 ideRubrica alteracao             G - 1-1 - - Grupo de informa��es de identifica��o da rubrica, apresentando
* 47 codRubrica ideRubrica            E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 48 dtIniValidade ideRubrica         E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 49 dtFimValidade ideRubrica         E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 50 dadosRubrica alteracao           G - 1-1 - - Informa��es da rubrica
* 51 descRubrica dadosRubrica         E C 1-1 100 - informar a descri��o (nome) da rubrica no sistema de folha de
* 52 natRubrica dadosRubrica          E N 1-1 004 - Informar o c�digo de classifica��o da rubrica de acordo com a
* 53 indProvDesc dadosRubrica         E C 1-1 001 - Indicativo do tipo de rubrica:
* 54 codIncidCP dadosRubrica          E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para a Previd�ncia
* 55 codIncidIRRF dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para o IRRF:
* 56 codIncidFGTS dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para o FGTS:
* 57 codIncidSIND dadosRubrica        E N 1-1 002 - C�digo de incid�ncia tribut�ria da rubrica para a Contribui��o
* 58 repDSR dadosRubrica              E C 1-1 001 - Indicar se a rubrica repercute no c�lculo do Descanso Semanal
* 59 repDecTerceiro dadosRubrica      E C 1-1 001 - Indicar se a rubrica repercute no c�lculo do 13� Sal�rio
* 60 repFerias dadosRubrica           E C 1-1 001 - Indicar se a rubrica repercute no c�lculo das F�rias.
* 61 repRescisao dadosRubrica         E C 1-1 001 - Indicar se a rubrica repercute no c�lculo da Rescis�o.
* 62 fatorRubrica dadosRubrica        E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necess�rio.
* 63 ideProcessoCP dadosRubrica       G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 64 tpProcesso ideProcessoCP         E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 65 nrProcesso ideProcessoCP         E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 66 extDecisao ideProcessoCP         E N 1-1 001 - Extens�o da Decis�o/Senten�a:
* 67 ideProcessoIRRF dadosRubrica     G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 68 tpProcesso ideProcessoIRRF       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 69 nrProcesso ideProcessoIRRF       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 70 ideProcessoFGTS dadosRubrica G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 71 tpProcesso ideProcessoFGTS       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 72 nrProcesso ideProcessoFGTS       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 73 ideProcessoSIND dadosRubrica     G - 0-1 - - Caso a empresa possua processo judicial com decis�o/senten�a
* 74 tpProcesso ideProcessoSIND       E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 75 nrProcesso ideProcessoSIND       E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 76 novaValidade alteracao           G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 77 dtIniValidade novaValidade       E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 78 dtFimValidade novaValidade       E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 79 exclusao infoRubrica             G - 0-1 - - Exclus�o de informa��es
* 80 ideRubrica exclusao              G - 1-1 - - Grupo de informa��es que identifica a rubrica que ser�
* 81 codRubrica ideRubrica            E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 82 dtIniValidade ideRubrica         E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 83 dtFimValidade ideRubrica         E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* 
* S-1020 - Tabela de Lota��es
* 
* 1 evtTabLotacao                 G - 1-1 - - Defini��o do Evento de tabela de lota��es.
* 2 versao evtTabLotacao          A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabLotacao       G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento            A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento           G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento               E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento             E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento         E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento             E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento      G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador    E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador    E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoLotacao infEvento        CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoLotacao         G - 0-1 - - Inclus�o de novas informa��es
* 15 ideLotacao inclusao          G - 1-1 - - Informa��es de identifica��o da lota��o e validade das
* 16 codLotacao ideLotacao        E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 17 dtIniValidade ideLotacao     E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideLotacao     E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosLotacao inclusao        G - 1-1 - - Detalhamento das informa��es da lota��o que est� sendo
* 20 descLotacao dadosLotacao     E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
* 21 tpLotacao dadosLotacao       E N 1-1 002 - Preencher com o c�digo correspondente ao tipo de lota��o,
* 22 tpInscEstab dadosLotacao     E N 0-1 001 - Tipo de inscri��o do estabelecimento ao qual est� vinculada a
* 23 nrInscEstab dadosLotacao     E N 0-1 014 - Preencher com o n�mero de Inscri��o do Estabelecimento
* 24 endereco dadosLotacao        G - 0-1 - - Informa��o complementar contendo os dados do endere�o da
* 25 tpLogradouro endereco        E C 1-1 010 - Tipo de Logradouro
* 26 descLogradouro endereco      E C 1-1 080 - Descri��o do logradouro
* 27 nrLogradouro endereco        E C 0-1 010 - N�mero do logradouro.
* 28 complemento endereco         E C 0-1 030 - Complemento do logradouro.
* 29 bairro endereco              E C 0-1 030 - Nome do bairro/distrito
* 30 cep endereco                 E N 1-1 008 - C�digo de Endere�amento Postal
* 31 codMunicipio endereco        E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 32 uf endereco                  E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 33 fpasLotacao dadosLotacao     G - 0-1 - - Registro preenchido exclusivamente para lota��o com tipo de
* 34 fpas fpasLotacao             E N 1-1 003 - Preencher com o c�digo relativo ao FPAS.
* 35 codTerceiros fpasLotacao     E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 36 infoEmprParcial dadosLotacao G - 0-1 - - Informa��o complementar que apresenta identifica��o do
* 37 tpInscContratante infoEmprParcial    E N 1-1 001 - Tipo de Inscri��o do contratante
* 38 nrInscContratante infoEmprParcial    E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 39 tpInscProprietario infoEmprParcial   E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 40 nrInscProprietario infoEmprParcial   E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 41 alteracao infoLotacao                G - 0-1 - - Altera��o de informa��es j� existentes
* 42 ideLotacao alteracao                 G - 1-1 - - Grupo de informa��es de identifica��o da lota��o, apresentando
* 43 codLotacao ideLotacao                E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 44 dtIniValidade ideLotacao             E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 45 dtFimValidade ideLotacao             E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 46 dadosLotacao alteracao               G - 1-1 - - Informa��es da lota��o
* 47 descLotacao dadosLotacao             E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
* 48 tpLotacao dadosLotacao               E N 1-1 002 - Preencher com o c�digo correspondente ao tipo de lota��o,
* 49 tpInscEstab dadosLotacao             E N 0-1 001 - Tipo de inscri��o do estabelecimento ao qual est� vinculada a
* 50 nrInscEstab dadosLotacao             E N 0-1 014 - Preencher com o n�mero de Inscri��o do Estabelecimento
* 51 endereco dadosLotacao                G - 0-1 - - Informa��o complementar contendo os dados do endere�o da
* 52 tpLogradouro endereco                E C 1-1 010 - Tipo de Logradouro
* 53 descLogradouro endereco              E C 1-1 080 - Descri��o do logradouro
* 54 nrLogradouro endereco                E C 0-1 010 - N�mero do logradouro.
* 55 complemento endereco                 E C 0-1 030 - Complemento do logradouro.
* 56 bairro endereco                      E C 0-1 030 - Nome do bairro/distrito
* 57 cep endereco                         E N 1-1 008 - C�digo de Endere�amento Postal
* 58 codMunicipio endereco                E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 59 uf endereco                          E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 60 fpasLotacao dadosLotacao             G - 0-1 - - Registro preenchido exclusivamente para lota��o com tipo de
* 61 fpas fpasLotacao                     E N 1-1 003 - Preencher com o c�digo relativo ao FPAS.
* 62 codTerceiros fpasLotacao             E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 63 infoEmprParcial dadosLotacao         G - 0-1 - - Informa��o complementar que apresenta identifica��o do
* 64 tpInscContratante infoEmprParcial    E N 1-1 001 - Tipo de Inscri��o do contratante
* 65 nrInscContratante infoEmprParcial    E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 66 tpInscProprietario infoEmprParcial   E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 67 nrInscProprietario infoEmprParcial   E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 68 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 69 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 70 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 71 exclusao infoLotacao                 G - 0-1 - - Exclus�o de informa��es
* 72 ideLotacao exclusao                  G - 1-1 - - Grupo de informa��es que identifica a lota��o que ser�
* 73 codLotacao ideLotacao                E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 74 dtIniValidade ideLotacao             E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 75 dtFimValidade ideLotacao             E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* S-1030 - Tabela de Cargos
* 
* 1 evtTabCargo                           G - 1-1 - - Evento utilizado para inclus�o, altera��o e exclus�o de registros
* 2 versao evtTabCargo                    A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabCargo                 G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoCargo infEvento                  CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoCargo                   G - 0-1 - - Inclus�o de novas informa��es
* 15 ideCargo inclusao                    G - 1-1 - - Informa��es de identifica��o do cargo e validade das
* 16 codCargo ideCargo                    E C 1-1 030 - Preencher com o c�digo do cargo
* 17 dtIniValidade ideCargo               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideCargo               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosCargo inclusao                  G - 1-1 - - Detalhamento das informa��es do cargo que est� sendo inclu�do
* 20 descCargo dadosCargo                 E C 1-1 100 - Preencher com descri��o do cargo
* 21 codCBO dadosCargo                    E N 1-1 006 - C�digo Brasileiro de Ocupa��o
* 22 alteracao infoCargo                  G - 0-1 - - Altera��o de informa��es j� existentes
* 23 ideCargo alteracao                   G - 1-1 - - Grupo de informa��es de identifica��o do cargo, apresentando
* 24 codCargo ideCargo                    E C 1-1 030 - Preencher com o c�digo do cargo
* 25 dtIniValidade ideCargo               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 26 dtFimValidade ideCargo               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 27 dadosCargo alteracao                 G - 1-1 - - Informa��es do cargo
* 28 descCargo dadosCargo                 E C 1-1 100 - Preencher com descri��o do cargo
* 29 codCBO dadosCargo                    E N 1-1 006 - C�digo Brasileiro de Ocupa��o
* 30 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 31 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 32 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 33 exclusao infoCargo                   G - 0-1 - - Exclus�o de informa��es
* 34 ideCargo exclusao                    G - 1-1 - - Identifica��o do registro que ser� exclu�do
* 35 codCargo ideCargo                    E C 1-1 030 - Preencher com o c�digo do cargo
* 36 dtIniValidade ideCargo               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 37 dtFimValidade ideCargo               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* 
* S-1040 - Tabela de Fun��es
* 
* 1 evtTabFuncao                          G - 1-1 - - Evento utilizado para inclus�o, altera��o e exclus�o de registros
* 2 versao evtTabFuncao                   A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabFuncao                G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoFuncao infEvento                 CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoFuncao                  G - 0-1 - - Inclus�o de novas informa��es
* 15 ideFuncao inclusao                   G - 1-1 - - Informa��es de identifica��o da fun��o e validade das
* 16 codFuncao ideFuncao                  E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 17 dtIniValidade ideFuncao              E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideFuncao              E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosFuncao inclusao                 G - 1-1 - - Detalhamento das informa��es da fun��o que est� sendo
* 20 descFuncao dadosFuncao               E C 1-1 100 - Descri��o da Fun��o
* 21 alteracao infoFuncao                 G - 0-1 - - Altera��o de informa��es j� existentes
* 22 ideFuncao alteracao                  G - 1-1 - - Grupo de informa��es de identifica��o da fun��o, apresentando
* 23 codFuncao ideFuncao                  E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 24 dtIniValidade ideFuncao              E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 25 dtFimValidade ideFuncao              E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 26 dadosFuncao alteracao                G - 1-1 - - Informa��es da fun��o
* 27 descFuncao dadosFuncao               E C 1-1 100 - Descri��o da Fun��o
* 28 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 29 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 30 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 31 exclusao infoFuncao                  G - 0-1 - - Exclus�o de informa��es
* 32 ideFuncao exclusao                   G - 1-1 - - Grupo de informa��es que identifica a fun��o que ser�
* 33 codFuncao ideFuncao                  E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 34 dtIniValidade ideFuncao              E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 35 dtFimValidade ideFuncao              E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* S-1050 - Tabela de Hor�rios/Turnos de Trabalho
* 
* 1 evtTabJornada                         G - 1-1 - - Evento Tabela de Hor�rios/Turnos de Trabalho
* 2 versao evtTabJornada                  A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabJornada               G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoJornada infEvento                CG - 1-1 - - Identifica��o da opera��o (inclus�o, altera��o ou exclus�o) e
* 14 inclusao infoJornada                 G - 0-1 - - Inclus�o de novas informa��es
* 15 ideJornada inclusao                  G - 1-1 - - Informa��es de identifica��o da jornada e validade das
* 16 codJornada ideJornada                E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 17 dtIniValidade ideJornada             E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideJornada             E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosJornada inclusao                G - 1-1 - - Detalhamento das informa��es da jornada que est� sendo
* 20 horaEntrada dadosJornada             E N 1-1 004 - informar hora da entrada, no formato HHMM
* 21 horaSaida dadosJornada               E N 1-1 004 - informar hora da sa�da, no formato HHMM
* 22 tpIntervalo dadosJornada             E N 1-1 001 - Preencher com o tipo de intervalo.
* 23 durIntervalo dadosJornada            E N 0-1 003 - Preencher com o tempo de dura��o do intervalo, em minutos.
* 24 horarioIntervalo dadosJornada        G - 0-5 - - Registro que detalha os hor�rios de in�cio e t�rmino do intervalo
* 25 inicioIntervalo horarioIntervalo     E N 1-1 004 - informar a hora de in�cio do intervalo, no formato HHMM
* 26 terminoIntervalo horarioIntervalo    E N 1-1 004 - informar a hora de termino do intervalo, no formato HHMM
* 27 alteracao infoJornada                G - 0-1 - - Altera��o de informa��es j� existentes
* 28 ideJornada alteracao                 G - 1-1 - - Grupo de informa��es de identifica��o da jornada,
* 29 codJornada ideJornada                E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 30 dtIniValidade ideJornada             E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 31 dtFimValidade ideJornada             E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 32 dadosJornada alteracao               G - 1-1 - - Informa��es da jornada
* 33 horaEntrada dadosJornada             E N 1-1 004 - informar hora da entrada, no formato HHMM
* 34 horaSaida dadosJornada               E N 1-1 004 - informar hora da sa�da, no formato HHMM
* 35 tpIntervalo dadosJornada             E N 1-1 001 - Preencher com o tipo de intervalo.
* 36 durIntervalo dadosJornada            E N 0-1 003 - Preencher com o tempo de dura��o do intervalo, em minutos.
* 37 horarioIntervalo dadosJornada        G - 0-5 - - Registro que detalha os hor�rios de in�cio e t�rmino do intervalo
* 38 inicioIntervalo horarioIntervalo     E N 1-1 004 - informar a hora de in�cio do intervalo, no formato HHMM
* 39 terminoIntervalo horarioIntervalo    E N 1-1 004 - informar a hora de termino do intervalo, no formato HHMM
* 40 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 41 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 42 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 43 exclusao infoJornada                 G - 0-1 - - Exclus�o de informa��es
* 44 ideJornada exclusao                  G - 1-1 - - Grupo de informa��es que identifica a jornada que ser�
* 45 codJornada ideJornada                E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 46 dtIniValidade ideJornada             E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 47 dtFimValidade ideJornada             E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* S-1060 - Tabela de Estabelecimentos
* 
* 1 evtTabEstab                           G - 1-1 - - Evento tabela de estabelecimentos/obras de constru��o civil
* 2 versao evtTabEstab                    A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabEstab                 G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoEstab infEvento                  CG - 1-1 - - Informa��es do Estabelecimento/Obra
* 14 inclusao infoEstab                   G - 0-1 - - Inclus�o de novas informa��es
* 15 ideEstab inclusao                    G - 1-1 - - Informa��es de identifica��o do estabelecimento/obra e
* 16 tpInscricao ideEstab                 E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 17 nrInscricao ideEstab                 E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 18 dtIniValidade ideEstab               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 19 dtFimValidade ideEstab               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 20 dadosEstab inclusao                  G - 1-1 - - Detalhamento das informa��es do estabelecimento/obra que
* 21 fpas dadosEstab                      E N 1-1 003 - Preencher com o c�digo relativo ao FPAS.
* 22 codTerceiros dadosEstab              E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 23 cnaeEstab dadosEstab                 G - 1-1 - - Informa��o da atividade preponderante e al�quota RAT relativas
* 24 cnaePreponderante cnaeEstab          E N 1-1 007 - Preencher com o c�digo do CNAE 2.0 conforme tabela
* 25 aliqRat cnaeEstab                    E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 26 aliqRatAjustada cnaeEstab            E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 27 alteracao infoEstab                  G - 0-1 - - Altera��o de informa��es j� existentes
* 28 ideEstab alteracao                   G - 1-1 - - Grupo de informa��es de identifica��o do
* 29 tpInscricao ideEstab                 E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 30 nrInscricao ideEstab                 E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 31 dtIniValidade ideEstab               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 32 dtFimValidade ideEstab               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 33 dadosEstab alteracao                 G - 1-1 - - Informa��es do estabelecimento/obra
* 34 fpas dadosEstab                      E N 1-1 003 - Preencher com o c�digo relativo ao FPAS.
* 35 codTerceiros dadosEstab              E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 36 cnaeEstab dadosEstab                 G - 1-1 - - Informa��o da atividade preponderante e al�quota RAT relativas
* 37 cnaePreponderante cnaeEstab          E N 1-1 007 - Preencher com o c�digo do CNAE 2.0 conforme tabela
* 38 aliqRat cnaeEstab                    E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 39 aliqRatAjustada cnaeEstab            E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 40 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 41 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 42 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 43 exclusao infoEstab                   G - 0-1 - - Exclus�o de informa��es
* 44 ideEstab exclusao                    G - 1-1 - - Grupo de informa��es que identifica o estabelecimento que ser�
* 45 tpInscricao ideEstab                 E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 46 nrInscricao ideEstab                 E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 47 dtIniValidade ideEstab               E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 48 dtFimValidade ideEstab               E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* S-1070 - Tabela de Processos
* 
* 1 evtTabProcesso                        G - 1-1 - - Evento Tabela de Processos
* 2 versao evtTabProcesso                 A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabProcesso              G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoProcesso infEvento               CG - 1-1 - - Informa��es do Processo
* 14 inclusao infoProcesso                G - 0-1 - - Inclus�o de novas informa��es
* 15 ideProcesso inclusao                 G - 1-1 - - Informa��es de identifica��o do Processo e validade das
* 16 tpProcesso ideProcesso               E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 17 nrProcesso ideProcesso               E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 18 dtIniValidade ideProcesso            E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 19 dtFimValidade ideProcesso            E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 20 dadosProcesso inclusao               G - 1-1 - - Detalhamento das informa��es do processo que est� sendo
* 21 indDecisao dadosProcesso             E N 1-1 001 - Indicativo de Decis�o:
* 22 dtDecisao dadosProcesso              E D 1-1 010 - Data da decis�o, senten�a ou despacho administrativo.
* 23 indDeposito dadosProcesso            E C 1-1 001 - Indicativo de Dep�sito do Montante Integral:
* 24 dadosProcJud dadosProcesso           G - 0-1 - - Informa��es Complementares do Processo Judicial
* 25 ufVara dadosProcJud                  E C 1-1 002 - Identifica��o da UF da Se��o Judici�ria
* 26 codMunicipio dadosProcJud            E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 27 idVara dadosProcJud                  E C 1-1 002 - C�digo de Identifica��o da Vara
* 28 indAutoria dadosProcJud              E N 1-1 001 - Preencher com [1] se o pr�prio contribuinte � o autor da a��o,
* 29 alteracao infoProcesso               G - 0-1 - - Altera��o de informa��es j� existentes
* 30 ideProcesso alteracao                G - 1-1 - - Grupo de informa��es de identifica��o do processo,
* 31 tpProcesso ideProcesso               E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 32 nrProcesso ideProcesso               E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 33 dtIniValidade ideProcesso            E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 34 dtFimValidade ideProcesso            E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 35 dadosProcesso alteracao              G - 1-1 - - Informa��es do Processo
* 36 indDecisao dadosProcesso             E N 1-1 001 - Indicativo de Decis�o:
* 37 dtDecisao dadosProcesso              E D 1-1 010 - Data da decis�o, senten�a ou despacho administrativo.
* 38 indDeposito dadosProcesso            E C 1-1 001 - Indicativo de Dep�sito do Montante Integral:
* 39 dadosProcJud dadosProcesso           G - 0-1 - - Informa��es Complementares do Processo Judicial
* 40 ufVara dadosProcJud                  E C 1-1 002 - Identifica��o da UF da Se��o Judici�ria
* 41 codMunicipio dadosProcJud            E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 42 idVara dadosProcJud                  E C 1-1 002 - C�digo de Identifica��o da Vara
* 43 indAutoria dadosProcJud              E N 1-1 001 - Preencher com [1] se o pr�prio contribuinte � o autor da a��o,
* 44 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 45 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 46 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 47 exclusao infoProcesso                G - 0-1 - - Exclus�o de informa��es
* 48 ideProcesso exclusao                 G - 1-1 - - Grupo de informa��es que identifica o processo que ser�
* 49 tpProcesso ideProcesso               E C 1-1 001 - Preencher com o c�digo correspondente ao tipo de processo:
* 50 nrProcesso ideProcesso               E C 1-1 020 - Informar o n�mero do processo administrativo/judicial.
* 51 dtIniValidade ideProcesso            E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 52 dtFimValidade ideProcesso            E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* 
* S-1080 - Tabela de Operadores Portu�rios
* 
* 1 evtTabOperPortuario                   G - 1-1 - - Evento Tabela de Operadores Portu�rios
* 2 versao evtTabOperPortuario            A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTabOperPortuario         G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 tpAmb ideEvento                       E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento                     E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento                 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento                     E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoOperPortuario infEvento          CG - 1-1 - - Informa��es do Operador Portu�rio
* 14 inclusao infoOperPortuario           G - 0-1 - - Inclus�o de novas informa��es
* 15 ideOperPortuario inclusao            G - 1-1 - - Informa��es de identifica��o do Operador Portu�rio e validade
* 16 cnpjOpPortuario ideOperPortuario     E N 1-1 014 - Preencher com o CNPJ do operador portu�rio
* 17 dtIniValidade ideOperPortuario       E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 18 dtFimValidade ideOperPortuario       E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 19 dadosOperPortuario inclusao          G - 1-1 - - Detalhamento das informa��es do Operador Portu�rio que est�
* 20 aliqRat dadosOperPortuario           E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 21 fap dadosOperPortuario               E N 1-1 006 4 Fator Acident�rio de Preven��o
* 22 aliqRatAjustada dadosOperPortuario   E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 23 alteracao infoOperPortuario          G - 0-1 - - Altera��o de informa��es j� existentes
* 24 ideOperPortuario alteracao           G - 1-1 - - Grupo de informa��es de identifica��o do operador portu�rio,
* 25 cnpjOpPortuario ideOperPortuario     E N 1-1 014 - Preencher com o CNPJ do operador portu�rio
* 26 dtIniValidade ideOperPortuario       E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 27 dtFimValidade ideOperPortuario       E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 28 dadosOperPortuario alteracao         G - 1-1 - - Informa��es do Operador Portu�rio
* 29 aliqRat dadosOperPortuario           E N 1-1 001 - Preencher com a al�quota definida no Decreto 3.048/99 para a
* 30 fap dadosOperPortuario               E N 1-1 006 4 Fator Acident�rio de Preven��o
* 31 aliqRatAjustada dadosOperPortuario   E N 1-1 006 4 Al�quota ap�s ajuste pelo FAP
* 32 novaValidade alteracao               G - 0-1 - - Informa��o preenchida exclusivamente em caso de altera��o do
* 33 dtIniValidade novaValidade           E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 34 dtFimValidade novaValidade           E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 35 exclusao infoOperPortuario           G - 0-1 - - Exclus�o de informa��es
* 36 ideOperPortuario exclusao            G - 1-1 - - Grupo de informa��es que identifica o operador portu�rio que
* 37 cnpjOpPortuario ideOperPortuario     E N 1-1 014 - Preencher com o CNPJ do operador portu�rio
* 38 dtIniValidade ideOperPortuario       E D 1-1 010 - Preencher com a data de in�cio da validade das informa��es
* 39 dtFimValidade ideOperPortuario       E D 0-1 010 - Preencher com a data de fim da validade das informa��es, se
* 
* S-1100 - eSocial Mensal - Abertura
* 
* 
* 1 evtFpAbertura                         G - 1-1 - - Evento Abertura de Folha de Pagamentos
* 2 versao evtFpAbertura                  A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpAbertura               G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                    E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento                 E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento                 E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                      E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                    E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento                E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                    E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 ideRespInformacao infEvento          G - 1-1 - - Respons�vel pelas informa��es
* 18 nomeResponsavel ideRespInformacao    E C 1-1 080 - Nome do respons�vel pelas informa��es
* 19 cpfResponsavel ideRespInformacao     E N 1-1 011 - Preencher com o CPF do respons�vel
* 20 telefone ideRespInformacao           E C 1-1 012 - Informar o n�mero do telefone, com DDD.
* 21 fax ideRespInformacao                E C 0-1 011 - N�mero do Fax, com DDD
* 22 email ideRespInformacao              E C 0-1 060 - Endere�o eletr�nico
* 23 infoSubstPatronal infEvento          G - 0-1 - - Registro preenchido exclusivamente por empresa enquadrada
* 24 indSubstPatronal infoSubstPatronal   E N 1-1 001 - Indicativo de Substitui��o:
* 25 percAliqPatronal infoSubstPatronal   E N 1-1 005 2 Informar ZERO se {indSubstPatronal} = 1. Caso contr�rio,
* 26 recExpServicos infEvento             G - 0-1 - - Registro complementar, cujo preenchimento � obrigat�rio para
* 27 recBrutaExp12m recExpServicos        E N 1-1 14 2 Receita Bruta da venda de servi�os para o mercado externo, nos
* 28 recBrutaTot12m recExpServicos        E N 1-1 14 2 Receita Bruta Total de vendas de bens e servi�os nos 12 meses
* 29 vlrTribRecBruta recExpServicos       E N 1-1 14 2 Valor dos Impostos e contribui��es incidentes sobre a receita
* 30 qtdMesesAtiv recExpServicos          E N 0-1 002 - Preencher com a quantidade de meses em atividade, ou deixar
* 31 percReducaoLei11774 recExpServicos   E N 1-1 006 4 Percentual de redu��o a ser aplicado na al�quota da
* 32 recAtivConcomitante infEvento        G - 0-1 - - Registro complementar, cujo preenchimento � obrigat�rio se
* 33 recBrutaTotMes recAtivConcomitante   E N 1-1 14 2 Informar o valor da receita bruta no m�s a que se refere a folha
* 34 recBrutaTotAno recAtivConcomitante   E N 1-1 14 2 Informar o valor da receita bruta total da empresa, acumulada
* 35 recBrutaAtssMes recAtivConcomitante  E N 1-1 14 2 Informar o valor da receita bruta da atividade sem substitui��o
* 36 recBrutaAtssAno recAtivConcomitante  E N 1-1 14 2 Informar o valor da receita bruta da atividade sem substitui��o
* 37 fatorMes recAtivConcomitante         E N 1-1 005 4 Informe o fator a ser utilizado para c�lculo da contribui��o
* 38 fator13 recAtivConcomitante          E N 1-1 005 2 Informe o fator a ser utilizado para c�lculo da contribui��o
* 
* S-1200 - eSocial Mensal - Remunera��o
* 
* 1 evtFpRemuneracao                      G - 1-1 - - Evento Remunera��o
* 2 versao evtFpRemuneracao               A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpRemuneracao            G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                    E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento                 E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento                 E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                      E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                    E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento                E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                    E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 ideTrabalhador infEvento             G - 1-1 - - Registro que apresenta a identifica��o b�sica do trabalhador ao
* 18 cpfTrab ideTrabalhador               E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 19 nisTrab ideTrabalhador               E N 0-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 20 qtdDepSF ideTrabalhador              E N 1-1 002 - Preencher com a quantidade de dependentes do trabalhador para
* 21 qtdDepIRRF ideTrabalhador            E N 1-1 002 - Preencher com a quantidade de dependentes do trabalhador para
* 22 infoMultiplosVinculos ideTrabalhador G - 0-1 - - Registro preenchido exclusivamente em caso de trabalhador que
* 23 indMV infoMultiplosVinculos          E N 1-1 001 - Indicador de desconto/recolhimento da contribui��o
* 24 remunOutrasEmpresas infoMultiplosVinculos    G - 0-10 - - Registro que complementa as informa��es relativas ao
* 25 tpInscricao remunOutrasEmpresas              E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 26 nrInscricao remunOutrasEmpresas              E C 1-1 014 - Indicar o n�mero de inscri��o do CNPJ da empresa que
* 27 vlrRemuneracao remunOutrasEmpresas           E N 1-1 014 2 Preencher com o valor da remunera��o recebida pelo
* 28 infoSimplesAtivConcomitanteideTrabalhador    G - 0-1 - - O registro detalha a situa��o do trabalhador em rela��o a
* 29 indSimples infoSimplesAtivConcomitante       E N 1-1 001 - Indicador de Contribui��o Substitu�da:
* 30 infoComplementares ideTrabalhador            G - 0-1 - - Registro preenchido exclusivamente quando o evento de
* 31 nomeTrab infoComplementares                  E C 1-1 080 - Nome do Trabalhador
* 32 dtNascto infoComplementares                  E D 1-1 010 - Preencher com a data de nascimento
* 33 codCBO infoComplementares                    E N 1-1 006 - C�digo Brasileiro de Ocupa��o
* 34 infoTrabAvulso ideTrabalhador                G - 0-1 - - Registro preenchido exclusivamente quando a empresa
* 35 cnpjSindicato infoTrabAvulso                 E N 1-1 014 - CNPJ do Sindicato ao qual os trabalhadores avulsos n�o
* 36 fpasSindicato infoTrabAvulso                 E N 1-1 003 - Preencher com o c�digo FPAS do Sindicato
* 37 codTerceiros infoTrabAvulso                  E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 38 infoPeriodoApuracao infEvento                G - 0-1 - - Registro que identifica o Estabelecimento/Lota��o no qual o
* 39 ideEstabLotacao infoPeriodoApuracao          G - 1-50 - - Identifica��o do estabelecimento e lota��o
* 40 tpInscricao ideEstabLotacao                  E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 41 nrInscricao ideEstabLotacao                  E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 42 codLotacao ideEstabLotacao                   E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 43 remunPeriodoApuracao ideEstabLotacao         G - 1-50 - - Registro onde s�o prestadas as informa��es relativas a
* 44 matricula remunPeriodoApuracao               E C 0-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 45 codCateg remunPeriodoApuracao                E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 46 bcCP remunPeriodoApuracao                    E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 47 bcIRRF remunPeriodoApuracao                  E N 1-1 14 2 Informar o valor total da base de c�lculo IRRF para o
* 48 bcFGTS remunPeriodoApuracao                  E N 1-1 14 2 Informar o valor total da base de c�lculo do FGTS para o
* 49 descCP remunPeriodoApuracao                  E N 1-1 14 2 preencher com o valor descontado do segurado referente
* 50 vlrProventos remunPeriodoApuracao            E N 1-1 14 2 Informar o valor total dos proventos
* 51 vlrDescontos remunPeriodoApuracao            E N 1-1 14 2 Preencher com o valor total dos descontos
* 52 vlrLiquido remunPeriodoApuracao              E N 1-1 14 2 Preencher com o valor l�quido
* 53 itensRemun remunPeriodoApuracao              G - 0-100 - - Registro que relaciona as rubricas que comp�e a remunera��o
* 54 codRubrica itensRemun                        E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 55 qtdRubrica itensRemun                        E N 0-1 004 - Informar a quantidade de refer�ncia para apura��o (em horas,
* 56 vlrRubrica itensRemun                        E N 1-1 14 2 Valor da Rubrica
* 57 infoAgenteNocivo remunPeriodoApuracao        G - 0-1 - - Registro preenchido exclusivamente em rela��o a remunera��o
* 58 grauExp infoAgenteNocivo                     E N 1-1 001 - Preencher com o c�digo que representa o grau de exposi��o a
* 59 infoRescisao remunPeriodoApuracao            G - 0-1 - - Registro que apresenta as informa��es relativas ao evento de
* 60 nrReciboDeslig infoRescisao                  E N 1-1 015 - Preencher com o n�mero do recibo do evento de desligamento
* 61 infoPeriodoAnterior infEvento                G - 0-1 - - Remunera��o em Per�odos Anteriores
* 62 ideAcordoDissidio infoPeriodoAnterior        G - 1-50 - - Identifica��o do Acordo/Conven��o/Diss�dio
* 63 dtAcordo ideAcordoDissidio                   E D 1-1 010 - Preencher com a data do acordo, conven��o ou diss�dio
* 64 tpAcordo ideAcordoDissidio                   E C 1-1 001 - Tipo de Acordo:
* 65 idePeriodo ideAcordoDissidio                 G - 1-50 - - Identifica��o do per�odo ao qual se referem as diferen�as de
* 66 perReferencia idePeriodo                     E N 1-1 006 - Informar o per�odo ao qual se refere o complemento de
* 67 ideEstabLotacao idePeriodo                   G - 1-50 - - O registro identifica o estabelecimento e lota��o ao qual se
* 68 tpInscricao ideEstabLotacao                  E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 69 nrInscricao ideEstabLotacao                  E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 70 codLotacao ideEstabLotacao                   E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 71 remunPeriodoAnterior ideEstabLotacao         G - 1-50 - - Registro que totaliza a remunera��o relativa ao diss�dio,
* 72 matricula remunPeriodoAnterior               E C 0-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 73 codCateg remunPeriodoAnterior                E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 74 bcCP remunPeriodoAnterior                    E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 75 bcIRRF remunPeriodoAnterior                  E N 1-1 14 2 Informar o valor total da base de c�lculo IRRF para o
* 76 bcFGTS remunPeriodoAnterior                  E N 1-1 14 2 Informar o valor total da base de c�lculo do FGTS para o
* 77 descCP remunPeriodoAnterior                  E N 1-1 14 2 preencher com o valor descontado do segurado referente
* 78 vlrProventos remunPeriodoAnterior            E N 1-1 14 2 Informar o valor total dos proventos
* 79 vlrDescontos remunPeriodoAnterior            E N 1-1 14 2 Preencher com o valor total dos descontos
* 80 vlrLiquido remunPeriodoAnterior              E N 1-1 14 2 Preencher com o valor l�quido
* 81 itensRemun remunPeriodoAnterior              G - 1-50 - - Registro que relaciona as rubricas que comp�e a remunera��o
* 82 codRubrica itensRemun                        E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 83 qtdRubrica itensRemun                        E N 0-1 004 - Informar a quantidade de refer�ncia para apura��o (em horas,
* 84 vlrRubrica itensRemun                        E N 1-1 14 2 Valor da Rubrica
* 85 infoAgenteNocivo remunPeriodoAnterior        G - 1-1 - - Registro preenchido exclusivamente em rela��o a remunera��o
* 86 grauExp infoAgenteNocivo                     E N 1-1 001 - Preencher com o c�digo que representa o grau de exposi��o a
* 87 infoPagtosEfetuados infEvento                G - 0-50 - - Registro que relaciona os pagamentos efetuados ao trabalhador
* 88 dtPagto infoPagtosEfetuados                  E D 1-1 010 - Data do Pagamento
* 89 tpPagto infoPagtosEfetuados                  E N 1-1 001 - Tipo de Pagamento:
* 90 perReferencia infoPagtosEfetuados            E N 1-1 006 - Informar o per�odo ao qual se refere o pagamento, no formato
* 91 pagtoTrabalhador infoPagtosEfetuados         G - 0-1 - - Pagamento efetuado ao trabalhador
* 92 vlrPagto pagtoTrabalhador                    E N 1-1 14 2 Preencher com o valor do pagamento efetuado na data de
* 93 vlrBaseIRRF pagtoTrabalhador                 E N 1-1 14 2 Preencher com o valor da base de c�lculo do IRRF relativa ao
* 94 descIRRF pagtoTrabalhador                    E N 1-1 014 2 Valor descontado do trabalhador referente ao Imposto de Renda
* 95 pagtoBeneficiario infoPagtosEfetuados        G - 0-99 - - Pagamentos efetuados a benefici�rios de pens�o aliment�cia
* 96 dtNasctoBeneficiario pagtoBeneficiario       E D 1-1 010 - Data de nascimento do benefici�rio da pens�o
* 97 cpfBeneficiario pagtoBeneficiario            E N 0-1 011 CPF do benefici�rio da pens�o aliment�cia
* 98 nomeBeneficiario pagtoBeneficiario           E C 1-1 080 - Nome do benefici�rio da pens�o aliment�cia
* 99 vlrPagto pagtoBeneficiario                   E N 1-1 14 2 Preencher com o valor do pagamento efetuado na data de
* 100 vlrBaseIRRF pagtoBeneficiario               E N 1-1 14 2 Preencher com o valor da base de c�lculo do IRRF relativa ao
* 101 totRemuneracao infEvento                    G - 1-99 - - Apresenta a totaliza��o das remunera��es do trabalhador, tanto
* 102 perReferencia totRemuneracao                E N 1-1 006 - Per�odo de refer�ncia da remunera��o.
* 103 matricula totRemuneracao                    E C 0-1 030 - Matr�cula atribu�da ao trabalhador pela empresa, informada nas
* 104 codCateg totRemuneracao                     E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 105 bcCP totRemuneracao                         E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 106 bcFGTS totRemuneracao                       E N 1-1 14 2 Informar o valor total da base de c�lculo do FGTS para o
* 107 bcIRRF totRemuneracao                       E N 1-1 14 2 Informar o valor total da base de c�lculo IRRF para o
* 108 descCP totRemuneracao                       E N 1-1 14 2 preencher com o valor descontado do segurado referente
* 
* S-1310 - eSocial Mensal - Outras Informa��es - Serv. Tomados (Cess�o de M�o de Obra)
* 
* 
* 1 evtFpServTomados                  G - 1-1 - - Evento Serv. Tomados (Cess�o de M�o de Obra ou Empreitada)
* 2 versao evtFpServTomados           A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpServTomados        G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento               G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento          E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento             E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento             E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                  E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento            E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento          G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoServTomados infEvento        G - 1-1 - - Serv. Tomados (Cess�o de M�o de Obra ou Empreitada)
* 18 ideEstabelecimento infoServTomados G - 1-999 - - Identifica��o do estabelecimento "tomador" dos servi�os
* 19 tpInscricao ideEstabelecimento     E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabelecimento     E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 idePrestadorServicos ideEstabelecimento  G - 1-999 - - O registro apresenta a totaliza��o dos servi�os contratados de
* 22 cnpjPrestador idePrestadorServicos       E N 1-1 014 - CNPJ do Prestador de Servi�os
* 23 vlrBruto idePrestadorServicos            E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 24 vlrBaseRetencao idePrestadorServicos     E N 1-1 14 2 Base de c�lculo da reten��o.
* 25 vlrRetencao idePrestadorServicos         E N 1-1 14 2 Soma do valor da reten��o das notas fiscais de servi�o
* 26 vlrAdicional idePrestadorServicos        E N 1-1 14 2 Soma do valor do adicional de reten��o das notas fiscais
* 27 vlrNaoRetido idePrestadorServicos        E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 28 nfsTerceiros idePrestadorServicos        G - 1-999 - - Detalhamento das notas fiscais de servi�os prestados pela
* 29 serie nfsTerceiros                       E C 1-1 005 - Informar o n�mero de s�rie da nota fiscal/fatura
* 30 numDocto nfsTerceiros                    E C 1-1 010 - N�mero da Nota Fiscal/Fatura
* 31 dtEmissaoNF nfsTerceiros                 E D 1-1 010 - Data de Emiss�o da Nota Fiscal/Fatura
* 32 dtPagtoNF nfsTerceiros                   E D 0-1 010 - Caso j� tenha sido efetuado o pagamento, informar a data.
* 33 tpServico nfsTerceiros                   E N 1-1 002 - Informar o tipo de servi�o, conforme tabela 6.
* 34 indObra nfsTerceiros                     E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 35 nrCno nfsTerceiros                       E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 36 vlrBaseRetencao nfsTerceiros             E N 1-1 14 2 Base de c�lculo da reten��o.
* 37 vlrBruto nfsTerceiros                    E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 38 vlrRetencaoApurada nfsTerceiros          E N 1-1 14 2 Preencher com o valor da reten��o apurada relativa aos servi�os
* 39 vlrRetencaoSubEmpreitada nfsTerceiros    E N 1-1 14 2 Informar o valor da reten��o destacada na nota fiscal relativo
* 40 vlrRetencao nfsTerceiros                 E N 1-1 14 2 Informar o valor retido.
* 41 vlrAdicional nfsTerceiros                E N 1-1 14 2 Adicional de reten��o da nota fiscal, caso os servi�os tenham
* 42 servPrestCondEspeciais nfsTerceiros      G - 0-1 - - Registro preenchido caso os servi�os relativos a nota fiscal
* 43 vlrServicos15 servPrestCondEspeciais     E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 44 vlrServicos20 servPrestCondEspeciais     E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 45 vlrServicos25 servPrestCondEspeciais     E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 46 infoProcJudicial nfsTerceiros            G - 0-1 - - Registro preenchido exclusivamente pelo tomador de servi�os
* 47 nrProcJud infoProcJudicial               E C 1-1 020 - Preencher com o n�mero do processo judicial;
* 48 vlrNaoRetido infoProcJudicial            E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 49 proprietarioCNO nfsTerceiros             G - 0-1 - - Identifica��o do propriet�rio do CNO em caso de servi�os
* 50 tpInscProprietario proprietarioCNO       E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 51 nrInscProprietario proprietarioCNO       E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 
* S-1320 - eSocial Mensal - Outras Informa��es - Serv. Prestados (Cess�o de M�o de Obra
* 
* 1 evtFpServPrestados                    G - 1-1 - - Evento Serv. Prestados (Cess�o de M�o de Obra ou
* 2 versao evtFpServPrestados             A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpServPrestados          G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                    E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento                 E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento                 E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                      E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                    E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento                E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                    E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoServPrestados infEvento          G - 1-1 - - Servi�os Prestados (Cess�o de M�o de Obra ou Empreitada)
* 18 ideEstabPrestador infoServPrestados  G - 1-999 - - Registro que identifica o estabelecimento "prestador" de
* 19 tpInscricao ideEstabPrestador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabPrestador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 ideContratante ideEstabPrestador     G - 1-999 - - O registro apresenta a totaliza��o dos servi�os prestados
* 22 tpInscContratante ideContratante     E N 1-1 001 - Tipo de Inscri��o do contratante
* 23 nrInscContratante ideContratante     E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 24 vlrBruto ideContratante              E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 25 vlrServicos ideContratante           E N 1-1 14 2 Preencher com a soma do valor dos servi�os das notas fiscais
* 26 vlrBaseRetencao ideContratante       E N 1-1 14 2 Preencher com a soma da base de c�lculo da reten��o das notas
* 27 vlrRetencao ideContratante           E N 1-1 14 2 Soma do valor da reten��o das notas fiscais de servi�o emitidas
* 28 vlrAdicional ideContratante          E N 1-1 14 2 Soma do valor do adicional de reten��o das notas fiscais
* 29 vlrNaoRetido ideContratante          E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 30 nfsEmitidas ideContratante           G - 1-999 - - Notas Fiscais de Servi�os (CMO) - Emitidas pelo Contribuinte
* 31 serie nfsEmitidas                    E C 1-1 005 - Informar o n�mero de s�rie da nota fiscal/fatura
* 32 numDocto nfsEmitidas                 E C 1-1 010 - N�mero da Nota Fiscal/Fatura
* 33 dtEmissaoNF nfsEmitidas              E D 1-1 010 - Data de Emiss�o da Nota Fiscal/Fatura
* 34 dtPagtoNF nfsEmitidas                E D 0-1 010 - Caso j� tenha sido efetuado o pagamento, informar a data.
* 35 tpServico nfsEmitidas                E N 1-1 002 - Informar o tipo de servi�o, conforme tabela 6.
* 36 indObra nfsEmitidas                  E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 37 nrCno nfsEmitidas                    E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 38 vlrBruto nfsEmitidas                 E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 39 vlrServicos nfsEmitidas              E N 1-1 14 2 Preencher com o valor dos servi�os da nota fiscal.
* 40 vlrDeducoes nfsEmitidas              E N 1-1 14 2 Valor das dedu��es legais de aux�lio-alimenta��o e vale
* 41 vlrBaseRetencao nfsEmitidas          E N 1-1 14 2 Base de c�lculo da reten��o.
* 42 vlrRetencaoApurada nfsEmitidas       E N 1-1 14 2 Preencher com o valor da reten��o apurada relativa aos servi�os
* 43 nfsEmitidas                          E N 1-1 14 2 Informar o valor da reten��o destacada na nota fiscal relativo
* 44 vlrRetencao nfsEmitidas              E N 1-1 14 2 Informar o valor da reten��o
* 45 vlrAdicional nfsEmitidas             E N 1-1 14 2 Adicional de reten��o da nota fiscal, caso os servi�os tenham
* 46 servPrestCondEspeciais nfsEmitidas   G - 0-1 - - Registro preenchido caso os servi�os relativos a nota fiscal
* 47 vlrServicos15 servPrestCondEspeciais E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 48 vlrServicos20 servPrestCondEspeciais E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 49 vlrServicos25 servPrestCondEspeciais E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 50 infoProcJudicial nfsEmitidas         G - 0-1 - - Registro preenchido exclusivamente pela empresa prestadora de
* 51 nrProcJud infoProcJudicial           E C 1-1 020 - Preencher com o n�mero do processo judicial, conforme padr�o
* 52 vlrNaoRetido infoProcJudicial        E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 53 servSubempreitados nfsEmitidas       G - 0-1 - - Registro preenchido com o detalhamento das informa��es
* 54 cnpjSubempreiteiro servSubempreitados        E N 1-1 014 - CNPJ do Subempreiteiro
* 55 vlrRetidoSubempreitada servSubempreitados    E N 1-1 14 2 Informar o valor da reten��o efetuada em rela��o aos servi�os
* 56 proprietarioCNO servSubempreitados           G - 0-1 - - Identifica��o do propriet�rio do CNO em caso de servi�os
* 57 tpInscProprietario proprietarioCNO           E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 58 nrInscProprietario proprietarioCNO           E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 
* S-1330 - eSocial Mensal - Outras Informa��es - Serv. Tomados de Coop. de Trabalho
* 
* 1 evtFpServTomadosCoop              G - 1-1 - - Evento Servi�os Tomados de Cooperativa de Trabalho
* 2 versao evtFpServTomadosCoop       A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpServTomadosCoop    G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento               G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento          E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento             E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento             E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                  E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento            E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento          G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoServTomados infEvento        G - 1-1 - - Serv. Tomados (prestados por Cooperativa de Trabalho)
* 18 ideEstabelecimento infoServTomados   G - 1-999 - - Identifica��o do estabelecimento "tomador" dos servi�os
* 19 tpInscricao ideEstabelecimento       E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabelecimento       E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 nfsTerceiros ideEstabelecimento      G - 1-999 - - Registro que detalha as notas fiscais emitidas por Cooperativas
* 22 cnpjCooperativa nfsTerceiros         E N 1-1 014 - CNPJ da cooperativa prestadora de servi�os
* 23 serie nfsTerceiros                   E C 1-1 005 - Informar o n�mero de s�rie da nota fiscal/fatura
* 24 numDocto nfsTerceiros                E C 1-1 010 - N�mero da Nota Fiscal/Fatura
* 25 dtEmissaoNF nfsTerceiros             E D 1-1 010 - Data de Emiss�o da Nota Fiscal/Fatura
* 26 dtPagtoNF nfsTerceiros               E D 0-1 010 - Caso j� tenha sido efetuado o pagamento, informar a data.
* 27 indObra nfsTerceiros                 E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 28 nrCno nfsTerceiros                   E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 29 vlrBruto nfsTerceiros                E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 30 vlrMatEquip nfsTerceiros             E N 1-1 14 2 Valor dos materiais e equipamentos fornecidos, desde que
* 31 vlrServicos nfsTerceiros             E N 1-1 14 2 Valor dos servi�os contidos na nota fiscal/fatura, j� deduzidos
* 32 vlrDeducoes nfsTerceiros             E N 1-1 14 2 Valor das dedu��es legais de aux�lio-alimenta��o e vale
* 33 vlrBaseCoop nfsTerceiros             E N 1-1 14 2 Base de c�lculo da contribui��o incidente sobre o valor pago �
* 34 servCoopCondEspeciais nfsTerceiros   G - 0-1 - - Caso tenha ocorrido, em rela��o aos servi�os contidos na nota
* 35 vlrServicos15 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 36 vlrServicos20 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 37 vlrServicos25 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 38 servPrestAtivConcomitantes nfsTerceiros  G - 0-1 - - Registro preenchido exclusivamente por empresa optante pelo
* 39 vlrBaseCoop servPrestAtivConcomitantes   E N 1-1 14 2 Valor da base de c�lculo correspondente aos servi�os prestados
* 40 vlrBaseCoop15 servPrestAtivConcomitantes E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 41 vlrBaseCoop20 servPrestAtivConcomitantes E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 42 vlrBaseCoop25 servPrestAtivConcomitantes E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 43 proprietarioCNO nfsTerceiros             G - 0-1 - - Identifica��o do propriet�rio do CNO em caso de servi�os
* 44 tpInscProprietario proprietarioCNO       E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 45 nrInscProprietario proprietarioCNO       E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 46 totBaseCoop ideEstabelecimento           G - 1-1 - - Registro que totaliza, por estabelecimento, os valores pagos �s
* 47 indIncidencia totBaseCoop                E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de incid�ncia
* 48 vlrBaseCoop totBaseCoop E                N 1-1 14 2 Valor total da base de c�lculo da contribui��o
* 49 vlrBaseCoop15 totBaseCoop                E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 50 vlrBaseCoop20 totBaseCoop                E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 51 vlrBaseCoop25 totBaseCoop                E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 
* S-1340 - eSocial Mensal - Outras Informa��es - Serv. Prestados pela Coop. de Trabalho
* 
* 1 evtFpServPrestadosCoop                G - 1-1 - - Informa��es do Evento Servi�os Prestados pela Coop. de
* 2 versao evtFpServPrestadosCoop         A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpServPrestadosCoop      G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento                   G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                    E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento                 E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento                 E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                      E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                    E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento                E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                    E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento              G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador            E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador            E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoServPrestados infEvento          G - 1-1 - - Servi�os prestados � terceiros pela Cooperativa de Trabalho
* 18 ideEstabPrestador infoServPrestados  G - 1-999 - - Registro que identifica o estabelecimento "prestador" de
* 19 tpInscricao ideEstabPrestador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabPrestador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 ideContratante ideEstabPrestador     G - 1-999 - - O registro apresenta a totaliza��o dos servi�os prestados por
* 22 tpInscContratante ideContratante     E N 1-1 001 - Tipo de Inscri��o do contratante
* 23 nrInscContratante ideContratante     E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 24 vlrBruto ideContratante              E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 25 vlrBaseCoop ideContratante           E N 1-1 14 2 Informar o valor total da base de c�lculo da(s) nota(s) fiscal(is)
* 26 nfsEmitidas ideContratante           G - 1-999 - - Registro que detalha as notas fiscais emitidas pela Cooperativa
* 27 serie nfsEmitidas                    E C 1-1 005 - Informar o n�mero de s�rie da nota fiscal/fatura
* 28 numDocto nfsEmitidas                 E C 1-1 010 - N�mero da Nota Fiscal/Fatura
* 29 dtEmissaoNF nfsEmitidas              E D 1-1 010 - Data de Emiss�o da Nota Fiscal/Fatura
* 30 dtPagtoNF nfsEmitidas                E D 0-1 010 - Caso j� tenha sido efetuado o pagamento, informar a data.
* 31 indObra nfsEmitidas                  E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 32 nrCno nfsEmitidas                    E N 1-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 33 vlrBruto nfsEmitidas                 E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 34 vlrMatEquip nfsEmitidas              E N 1-1 14 2 Valor dos materiais e equipamentos fornecidos, desde que
* 35 vlrServicos nfsEmitidas              E N 1-1 14 2 Preencher com a soma do valor dos servi�os das notas fiscais
* 36 vlrDeducoes nfsEmitidas              E N 1-1 14 2 Valor das dedu��es legais de aux�lio-alimenta��o e vale
* 37 vlrBaseCoop nfsEmitidas              E N 1-1 14 2 Informar o valor total da base de c�lculo da(s) nota(s) fiscal(is)
* 38 servCoopCondEspeciais nfsEmitidas    G - 0-1 - - Caso tenha ocorrido, em rela��o aos servi�os contidos na nota
* 39 vlrServicos15 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 40 vlrServicos20 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 41 vlrServicos25 servCoopCondEspeciais  E N 1-1 14 2 Valor dos Servi�os prestados por segurados em condi��es
* 42 proprietarioCNO nfsEmitidas          G - 0-1 - - Identifica��o do propriet�rio do CNO em caso de servi�os
* 43 tpInscProprietario proprietarioCNO   E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 44 nrInscProprietario proprietarioCNO   E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 
* S-1350 - eSocial Mensal - Outras Informa��es - Aquisi��o de Produ��o
* 
* 
* 1 evtFpAquisProducao                G - 1-1 - - Evento Aquisi��o de Produ��o
* 2 versao evtFpAquisProducao         A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpAquisProducao      G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento               G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento          E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento                E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento             E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento             E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento                  E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento                E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento            E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento                E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento          G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador        E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador        E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoAquisProducao infEvento      G - 1-1 - - Informa��o da Aquisi��o de Produ��o
* 18 ideEstabAdquirente infoAquisProducao G - 1-999 - - Identifica��o do estabelecimento adquirente da produ��o. Em
* 19 tpInscricao ideEstabAdquirente       E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabAdquirente       E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 tipoAquisicao ideEstabAdquirente     G - 1-3 - - Registro preenchido por Pessoa Jur�dica em geral, quando o
* 22 indAquisicao tipoAquisicao           E N 1-1 001 - Indicativo da Aquisi��o:
* 23 vlrTotalAquisicao tipoAquisicao      E N 1-1 14 2 Valor total da aquisi��o correspondente ao indicativo informado
* 24 ideProdutor tipoAquisicao            G - 1-999 - - Registro que identifica os produtores rurais dos quais foi
* 25 tpInscricao ideProdutor              E N 1-1 001 - Preencher com [1] (CNPJ) ou [2] (CPF)
* 26 nrInscricao ideProdutor              E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 27 vlrBruto ideProdutor                 E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 28 vlrContribDescPR ideProdutor         E N 1-1 14 2 Preencher com o valor da Contribui��o Previdenci�ria
* 29 vlrGilratDescPR ideProdutor          E N 1-1 14 2 Valor da contribui��o destinada ao financiamento dos
* 30 vlrSenarDescPR ideProdutor           E N 1-1 14 2 Valor da contribui��o destinada ao SENAR, incidente sobre a
* 31 notasFiscais ideProdutor             G - 0-999 - - O registro detalha as notas fiscais de aquisi��o da produ��o
* 32 serie notasFiscais                   E C 1-1 005 - Informar o n�mero de s�rie da nota fiscal/fatura
* 33 numDocto notasFiscais                E C 1-1 010 - N�mero da Nota Fiscal/Fatura
* 34 dtEmissaoNF notasFiscais             E D 1-1 010 - Data de Emiss�o da Nota Fiscal/Fatura
* 35 vlrBruto notasFiscais                E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
* 36 vlrContribDescPR notasFiscais        E N 1-1 14 2 Preencher com o valor da Contribui��o Previdenci�ria
* 37 vlrGilratDescPR notasFiscais         E N 1-1 14 2 Valor da contribui��o destinada ao financiamento dos
* 38 vlrSenarDescPR notasFiscais          E N 1-1 14 2 Valor da contribui��o destinada ao SENAR, incidente sobre a
* 39 infoProcJudicial ideProdutor         G - 0-1 - - Registro preenchido quando o Produtor Rural (pessoa f�sica ou
* 40 nrProcJud infoProcJudicial           E C 1-1 020 - Preencher com o n�mero do processo judicial, conforme padr�o
* 
* 
* S-1360 - eSocial Mensal - Outras Informa��es - Comercializa��o da Produ��o
* 
* 1 evtFpComercProducao G - 1-1 - - Evento Comercializa��o da Produ��o
* 2 versao evtFpComercProducao A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpComercProducao G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoComercProducao infEvento G - 1-1 - - Informa��o da Comercializa��o de Produ��o
* 18 ideEstabelecimento infoComercProducao G - 1-999 - - Registro que identifica o estabelecimento que comercializou a
* 19 tpInscricao ideEstabelecimento E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 20 nrInscricao ideEstabelecimento E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 21 tipoComercializacao ideEstabelecimento G - 1-5 - - Registro que apresenta o valor total da comercializa��o por
* 22 indComercializacao tipoComercializacao E N 1-1 001 - Indicativo de Comercializa��o:
* 23 vlrTotalComercializacao tipoComercializacao E N 1-1 14 2 Preencher com o valor total da comercializa��o
* 24 ideAdquirente tipoComercializacao G - 0-999 - - Identifica��o dos Adquirentes da Produ��o. Em arquivo
* 25 tpInscricao ideAdquirente E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 26 nrInscricao ideAdquirente E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 27 vlrComercializacao ideAdquirente E N 1-1 14 2 Valor bruto da comercializa��o da produ��o
* 28 vlrRetidoProdRural ideAdquirente E N 0-1 14 2 Valor total retido pelo adquirente
* 
* S-1370 - eSocial Mensal - Outras Informa��es - Rec. Recebidos ou Repassados p/ Clube de Futebol
* 
* 1 evtFpAssocDesportiva G - 1-1 - - Evento Recursos Recebidos ou Repassados p/ Clube de Futebol
* 2 versao evtFpAssocDesportiva A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpAssocDesportiva G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 infoRecursoRecebido infEvento G - 0-1 - - Registro preenchido exclusivamente por associa��o desportiva
* 18 recursosRecebidos infoRecursoRecebido G - 1-999 - - Detalhamento dos recursos recebidos
* 19 cnpjEmpOrigemRecurso recursosRecebidos E N 1-1 014 - Preencher com o CNPJ da empresa que repassou recursos
* 20 tpRepasse recursosRecebidos E N 1-1 001 - Tipo de repasse, conforme tabela abaixo:
* 21 dtRepasse recursosRecebidos E D 1-1 010 - Data do repasse
* 22 vlrRepasse recursosRecebidos E N 1-1 14 2 Valor do repasse recebido � t�tulo de patroc�nio, publicidade,
* 23 infoRecursoRepassado infEvento G - 0-1 - - Registro preenchido por Pessoa Jur�dica que efetua repasse �
* 24 ideEstabelecimento infoRecursoRepassado G - 1-999 - - Registro que identifica o estabelecimento que efetuou o repasse
* 25 tpInscricao ideEstabelecimento E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 26 nrInscricao ideEstabelecimento E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 27 vlrTotalRepasses ideEstabelecimento E N 1-1 14 2 Valor total dos repasses efetuados pelo estabelecimento �(s)
* 28 recursosRepassados ideEstabelecimento G - 1-999 - - Detalhamento dos repasses efetuados �s Associa��es
* 29 cnpjAssocDesportiva recursosRepassados E N 1-1 014 - Preencher com o CNPJ da associa��o desportiva que mant�m
* 30 tpRepasse recursosRepassados E N 1-1 001 - Tipo de repasse, conforme tabela abaixo:
* 31 dtRepasse recursosRepassados E D 1-1 010 - Data do repasse
* 32 vlrRepasse recursosRepassados E N 1-1 14 2 Valor do repasse efetuado � t�tulo de patroc�nio, publicidade,
* 
* 
* S-1400 - eSocial Mensal - Bases de C�lculo, Reten��o, Dedu��es e Contribui��es
* 
* 1 evtFpBasesContrib G - 1-1 - - Evento Bases de C�lculo e Contribui��es
* 2 versao evtFpBasesContrib A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtFpBasesContrib G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de identifica��o do evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 indApuracao ideEvento E N 1-1 001 - Indicativo de per�odo de apura��o:
* 9 perApuracao ideEvento E N 1-1 006 - Informar o m�s/ano (formato MMAAAA) da folha de
* 10 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 11 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 12 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 13 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 14 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 15 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 16 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 17 ideConteudo infEvento G - 1-1 - - Identifica��o do conte�do do evento
* 18 indConteudo ideConteudo E N 1-1 001 - Indicativo de Conte�do:
* 19 infoBasesContrib infEvento G - 0-1 - - Bases de C�lculo, Dedu��es e Contribui��es
* 20 ideEstabelecimento infoBasesContrib G - 1-999 - - Identifica o estabelecimento do contribuinte para os quais �
* 21 tpInscricao ideEstabelecimento E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o do
* 22 nrInscricao ideEstabelecimento E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 23 basesPorCategoria ideEstabelecimento - 0-99 - - Totaliza��o das bases de c�lculo por categoria de segurado
* 24 indIncidencia basesPorCategoria E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de incid�ncia
* 25 codCateg basesPorCategoria E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 26 vlrBcCP basesPorCategoria E N 1-1 14 2 Valor total da base de c�lculo da contribui��o previdenci�ria
* 27 vlrBcCP15 basesPorCategoria E N 1-1 14 2 Preencher com a base de c�lculo da contribui��o adicional para
* 28 vlrBcCP20 basesPorCategoria E N 1-1 14 2 Preencher com a base de c�lculo da contribui��o adicional para
* 29 vlrBcCP25 basesPorCategoria E N 1-1 14 2 Preencher com a base de c�lculo da contribui��o adicional para
* 30 vlrDescCP basesPorCategoria E N 1-1 14 2 preencher com o valor total da contribui��o descontada dos
* 31 vlrSalFam basesPorCategoria E N 1-1 14 2 Preecher com o valor total do sal�rio-fam�lia para a categoria.
* 32 vlrSalMat basesPorCategoria E N 1-1 14 2 Preencher com o valor total do sal�rio-maternidade para a
* 33 basesPorOperPortuario ideEstabelecimento G - 0-99 - - Registro preenchido exclusivamente em arquivo gerado por
* 34 cnpjOpPortuario basesPorOperPortuario E N 1-1 014 - Preencher com o CNPJ do operador portu�rio
* 35 vlrBcOpPortuario basesPorOperPortuario E N 1-1 14 2 Preencher com o valor total da base de c�lculo da Gilrat relativa
* 36 basesPorFpas ideEstabelecimento G - 0-99 - - Registro que apresenta a base de c�lculo das contribui��es
* 38 codTerceiros basesPorFpas E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 39 bcTerceiros basesPorFpas E N 1-1 14 2 Informar o valor total da base de c�lculo das contribui��es
* 40 contribPrevSocial ideEstabelecimento G - 0-99 - - Registro de apura��o das contribui��es destinadas � Previd�ncia
* 41 indTpContrib contribPrevSocial E N 1-1 003 - Preencher com c�digo relativo � contribui��o apurada,
* 42 vlrContribuicao contribPrevSocial E N 1-1 14 2 Preencher com o valor da contribui��o
* 43 contribOutrasEntidades   ideEstabelecimento G - 0-99 - - Registro que totaliza, por estabelecimento, as contribui��es
* 44 fpas contribOutrasEntidades E N 1-1 003 - Preencher com o c�digo relativo ao FPAS.
* 45 codTerceiros contribOutrasEntidades E N 1-1 004 - Preencher com o c�digo de terceiros, conforme tabela 4.
* 46 vlrTotTerceiros contribOutrasEntidades E N 1-1 14 2 Preencher com o valor total das contriubui��es destinadas a
* 47 contribTerceiro contribOutrasEntidades G - 0-9 - - Detalhamento das Contribui��es Destinadas a Outras Entidades
* 48 codTerceiro contribTerceiro E N 1-1 004 - Informar o C�digo de Terceiro
* 49 aliqTerceiro contribTerceiro E N 1-1 005 2 Preencher com a al�quota da Contribui��o destinada ao terceiro,
* 50 vlrTerceiro contribTerceiro E N 1-1 14 2 Preencher com o valor da contribui��o
* 51 infoCessaoMaoObra infEvento G - 0-1 - - Informa��es sobre cess�o de m�o de obra (reten��es efetuadas,
* 52 retencaoEfetuada infoCessaoMaoObra G - 0-1 - - Informa��es de totaliza��o das reten��es efetuadas pela
* 53 idePrestadorObra retencaoEfetuada G - 1-999 - - Registro que totaliza, por prestador de servi�os e matr�cula
* 54 cnpjPrestador idePrestadorObra E N 1-1 014 - CNPJ do Prestador de Servi�os
* 55 indObra idePrestadorObra E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 56 nrCno idePrestadorObra E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 58 vlrAdicional idePrestadorObra E N 1-1 14 2 Soma do valor do adicional de reten��o das notas fiscais
* 59 vlrNaoRetido idePrestadorObra E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 60 proprietarioCNO idePrestadorObra G - 0-1 - - Identifica��o do propriet�rio do CNO. A identifica��o n�o �
* 61 tpInscProprietario proprietarioCNO E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 62 nrInscProprietario proprietarioCNO E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 63 retencaoSofrida infoCessaoMaoObra G - 0-1 - - Informa��es de totaliza��o das reten��es sofridas pela empresa
* 64 ideContratanteObra retencaoSofrida G - 1-999 - - Registro que totaliza, por contratante de servi�os e matr�cula
* 65 tpInscContratante ideContratanteObra E N 1-1 001 - Tipo de Inscri��o do contratante
* 66 nrInscContratante ideContratanteObra E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 67 indObra ideContratanteObra E N 1-1 001 - Indicativo de Presta��o de Servi�os em Obra de Constru��o
* 68 nrCno ideContratanteObra E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 69 vlrRetencao ideContratanteObra E N 1-1 14 2 Soma do valor da reten��o das notas fiscais de servi�o
* 70 vlrAdicional ideContratanteObra E N 1-1 14 2 Soma do valor do adicional de reten��o das notas fiscais
* 71 vlrNaoRetido ideContratanteObra E N 1-1 14 2 Valor da reten��o que deixou de ser efetuada pelo contratante
* 72 proprietarioCNO ideContratanteObra G - 0-1 - - Identifica��o do propriet�rio do CNO. Se {indObra} for igual
* 73 tpInscProprietario proprietarioCNO E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 74 nrInscProprietario proprietarioCNO E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 75 remunPorContratante infoCessaoMaoObra G - 0-999 - - Registro que totaliza as remunera��es dos trabalhadores
* 76 tpInscContratante remunPorContratante E N 1-1 001 - Tipo de Inscri��o do contratante
* 77 nrInscContratante remunPorContratante E C 1-1 014 - N�mero de Inscri��o (CNPJ/CPF) do Contrante
* 78 nrCno remunPorContratante E N 0-1 012 - Preencher com o n�mero de inscri��o no Cadastro Nacional de
* 79 codCateg remunPorContratante E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 80 bcCP remunPorContratante E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 81 proprietarioCNO remunPorContratante G - 0-1 - - Identifica��o do propriet�rio do CNO indicado no registro
* 82 tpInscProprietario proprietarioCNO E N 1-1 001 - Tipo de Inscri��o do propriet�rio do CNO
* 83 nrInscProprietario proprietarioCNO E C 1-1 014 - Preencher com o n�mero de inscri��o (CNPJ/CPF) do
* 
* 
* S-2100 - Evento Cadastramento Inicial do V�nculo
* 
* 1 evtCadInicial G - 1-1 - - Evento Cadastramento Inicial do V�nculo
* 2 versao evtCadInicial A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtCadInicial G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 trabalhador infEvento G - 1-1 - - Grupo de Informa��es do Trabalhador
* 16 cpfTrab trabalhador E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab trabalhador E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 nomeTrab trabalhador E C 1-1 080 - Nome do Trabalhador
* 19 sexo trabalhador E C 1-1 001 - Sexo do Trabalhador:
* 20 racaCor trabalhador E N 1-1 001 - Ra�a e cor do trabalhador, conforme tabela abaixo:
* 21 estadoCivil trabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 22 grauInstrucao trabalhador E N 1-1 002 - Grau de instru��o do trabalhador, conforme tabela:
* 23 nascimento trabalhador G - 1-1 - - Grupo de informa��es do nascimento do trabalhador
* 24 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 25 codMunicipio nascimento E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 26 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 27 paisNascto nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nascimento do trabalhador,
* 28 paisNacionalidade nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nacionalidade do
* 29 nomeMae nascimento E C 0-1 080 - Nome da m�e do trabalhador
* 30 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador
* 31 documentos trabalhador G - 0-1 - - Informa��es dos documentos pessoais do trabalhador
* 32 CTPS documentos G - 0-1 - - Informa��es da Carteira de Trabalho e Previd�ncia Social
* 33 nrCtps CTPS E C 1-1 011 - N�mero da carteira de trabalho e Previd�ncia Social do
* 34 serieCtps CTPS E C 1-1 004 - N�mero de s�rie da CTPS.
* 35 ufCtps CTPS E C 1-1 002 - UF da expedi��o da CTPS.
* 36 RIC documentos G - 0-1 - - Informa��es do Registro de Identidade �nico (RIC)
* 37 nrRic RIC E N 1-1 014 - N�mero do RIC
* 38 orgaoEmissor RIC E C 1-1 020 - �rg�o emissor do documento
* 39 dtExpedicao RIC E D 1-1 010 - Data da expedi��o do documento
* 40 RG documentos G - 0-1 - - Informa��es do Registro Geral (RG)
* 41 nrRg RG E C 1-1 014 - N�mero do RG
* 42 orgaoEmissor RG E C 1-1 020 - �rg�o emissor do documento
* 43 dtExpedicao RG E D 1-1 010 - Data da expedi��o do documento
* 44 RNE documentos G - 0-1 - - Informa��es do Registro Nacional de Estrangeiro
* 45 nrRne RNE E C 1-1 014 - N�mero de inscri��o no Registro Nacional de Estrangeiros
* 46 orgaoEmissor RNE E C 1-1 020 - �rg�o emissor do documento
* 47 dtExpedicao RNE E D 1-1 010 - Data da expedi��o do documento
* 48 OC documentos G - 0-1 - - Informa��es do n�mero de registro em �rg�o de Classe (OC)
* 49 nrOc OC E C 1-1 014 - N�mero de Inscri��o no �rg�o de Classe
* 50 orgaoEmissor OC E C 1-1 020 - �rg�o emissor do documento
* 51 dtExpedicao OC E D 1-1 010 - Data da expedi��o do documento
* 52 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.
* 53 CNH documentos G - 0-1 - - Informa��es da Carteira Nacional de Habilita��o (CNH)
* 54 nrCnh CNH E N 1-1 014 - N�mero da CNH
* 55 orgaoEmissor CNH E C 1-1 020 - �rg�o emissor do documento
* 56 dtExpedicao CNH E D 1-1 010 - Data da expedi��o do documento
* 57 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.
* 58 endereco trabalhador CG - 1-1 - - Grupo de informa��es do endere�o do Trabalhador
* 59 brasil endereco G - 0-1 - - Preenchimento obrigat�rio para trabalhador residente no Brasil.
* 60 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 61 descLogradouro brasil E C 1-1 080 - Descri��o do logradouro
* 62 nrLogradouro brasil E C 0-1 010 - N�mero do logradouro.
* 63 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 64 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 65 cep brasil E N 1-1 008 - C�digo de Endere�amento Postal
* 66 codMunicipio brasil E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 67 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 68 exterior endereco G - 0-1 - - Preenchido em caso de trabalhador residente no exterior.
* 69 paisResidencia exterior E N 1-1 005 - Preencher com o c�digo do pa�s, conforme tabela de pa�ses da
* 70 descLogradouro exterior E C 1-1 080 - Descri��o do logradouro
* 71 nrLogradouro exterior E C 0-1 010 - N�mero do logradouro.
* 72 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 73 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 74 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 75 codPostal exterior E C 0-1 010 - C�digo de Endere�amento Postal
* 76 infoCasaPropria trabalhador G - 0-1 - - Informa��es da Casa Pr�pria
* 77 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a resid�ncia pertence ao trabalhador
* 78 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o im�vel pr�prio foi adquirido com
* 79 trabEstrangeiro trabalhador G - 0-1 - - Grupo de informa��es do Trabalhador Estrangeiro
* 80 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 81 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturaliza��o brasileira em caso de estrangeiro
* 82 casadoBr trabEstrangeiro E C 1-1 001 - Condi��o de casado com brasileiro(s) em caso de trabalhador
* 83 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,
* 84 infBancarias trabalhador G - 0-1 - - Informa��es Banc�rias do Trabalhador
* 85 banco infBancarias E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 86 agencia infBancarias E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 87 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 88 nrContaBancaria infBancarias E C 1-1 020 - N�mero da Conta Banc�ria
* 89 infoDeficiencia trabalhador G - 0-1 - - Pessoa com Defici�ncia
* 90 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia motora.
* 91 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia visual
* 92 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia auditiva.
* 93 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador � reabilitado.
* 94 observacao infoDeficiencia E C 0-1 255 - Observa��o
* 95 dependente trabalhador G - 0-50 - - Informa��es dos dependentes
* 96 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 97 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 98 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 99 cpfDep dependente E N 0-1 011 - N�mero de Inscri��o no CPF
* 100 depIRRF dependente E C 1-1 001 - Informar se � dependente para fins de dedu��o do IRRF.
* 101 depSF dependente E C 1-1 001 - Informar se � dependente para fins de recebimento do benef�cio
* 102 contato trabalhador G - 0-1 - - Informa��es de Contato
* 103 fonePrincipal contato E N 0-1 012 - N�mero de telefone do trabalhador
* 104 foneAlternativo contato E N 0-1 012 - N�mero de telefone do trabalhador
* 105 emailPrincipal contato E C 0-1 060 - Endere�o eletr�nico
* 106 emailAlternativo contato E C 0-1 060 - Endere�o eletr�nico
* 107 vinculo infEvento G - 1-1 - - Grupo de informa��es do v�nculo
* 108 matricula vinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 109 dtAdmissao vinculo E D 1-1 010 - Preencher com a data de admiss�o do trabalhador no respectivo
* 110 tpAdmissao vinculo E N 1-1 001 - Tipo de admiss�o do trabalhador, conforme tabela abaixo:
* 111 indAdmissao vinculo E N 1-1 001 - Indicativo de Admiss�o:
* 112 indPrimeiroEmprego vinculo E C 1-1 001 - Indicar se trata-se do primeiro emprego do trabalhador.
* 113 contrato vinculo G - 1-1 - - Informa��es do Contrato de Trabalho
* 114 tpRegimeTrab contrato E N 1-1 001 - Tipo de regime trabalhista
* 115 tpRegimePrev contrato E N 1-1 001 - Tipo de regime previdenci�rio conforme tabela abaixo:
* 116 natAtividade contrato E N 1-1 001 - Tipo de v�nculo trabalhista, conforme tabela abaixo:
* 117 codCateg contrato E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 118 codCargo contrato E C 1-1 030 - Preencher com o c�digo do cargo
* 119 codFuncao contrato E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 120 remuneracao contrato G - 1-1 - - Informa��es da remunera��o e periodicidade de pagamento
* 121 vlrSalFixo remuneracao E N 1-1 14 2 Sal�rio fixo do trabalhador, correspondente � parte fixa da
* 122 unidSalFixo remuneracao E N 1-1 001 - Unidade de pagamento da parte fixa da remunera��o, conforme
* 123 vlrSalVariavel remuneracao E N 0-1 14 2 Sal�rio vari�vel do trabalhador. Corresponde � parte vari�vel da
* 124 unidSalVariavel remuneracao E N 0-1 001 - Unidade de pagamento da parte vari�vel da remunera��o,
* 125 duracao contrato G - 1-1 - - Dura��o do Contrato de Trabalho
* 126 tpContrato duracao E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
* 127 dtTermino duracao E D 0-1 010 - Data do T�rmino
* 128 localTrabalho contrato G - 1-1 - - Informa��es do local de trabalho
* 129 tpInscricao localTrabalho E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 130 nrInscricao localTrabalho E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 131 codLotacao localTrabalho E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 132 descComplementar localTrabalho E C 0-1 080 - Descri��o complementar do local de trabalho.
* 133 jornada contrato G - 1-1 - - Informa��es da jornada de trabalho
* 134 jornadaPadrao jornada G - 0-1 - - Informa��es da Jornada Regular
* 135 qtdHoras jornadaPadrao E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 136 codJornadaSegSexta jornadaPadrao E C 1-1 030 - C�digo do hor�rio de segunda a sexta
* 137 codJornadaSab jornadaPadrao E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 138 jornadaTurnoFixo jornada G - 0-1 - - Informa��es de Jornada em turnos fixos
* 139 qtdHoras jornadaTurnoFixo E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 140 codJornadaSeg jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � segunda-feira
* 141 codJornadaTer jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � ter�a-feira
* 142 codJornadaQua jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quarta-feira
* 143 codJornadaQui jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quinta-feira
* 144 codJornadaSex jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � sexta-feira
* 145 codJornadaSab jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 146 codJornadaDom jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao domingo
* 147 jornadaTurnoFlexivel jornada G - 0-1 - - Informa��es da jornada em turnos flex�veis
* 148 turno jornadaTurnoFlexivel E N 1-1 001 - Sequencial de identifica��o do turno
* 149 codJornada jornadaTurnoFlexivel E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 150 jornadaEspecial jornada G - 0-1 - - Informa��es da Jornada especial
* 151 tpEscala jornadaEspecial E N 1-1 002 - Tipo de Escala:
* 152 qtdHoras jornadaEspecial E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 153 codJornada jornadaEspecial E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 154 filiacaoSindical contrato G - 0-1 - - Filia��o Sindical do Trabalhador
* 155 cnpjSindTrabalhador filiacaoSindical E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador
* 156 alvaraJudicial contrato G - 0-1 - - Informa��es do alvar� judicial, preenchimento obrigat�rio em
* 157 nrProcJud alvaraJudicial E C 1-1 020 - Preencher com o n�mero do processo judicial.
* 158 FGTS vinculo G - 1-1 - - Informa��es do Fundo de Garantia por Tempo de Servi�o
* 159 optanteFGTS FGTS E N 1-1 001 - Informar a op��o pelo FGTS
* 160 dtOpcaoFGTS FGTS E D 0-1 010 - Informar a data de op��o pelo FGTS do trabalhador
* 161 sucessaoVinc vinculo G - 0-1 - - Grupo de informa��es da sucess�o de v�nculo trabalhista
* 162 cnpjEmpregadorAnterior sucessaoVinc E N 1-1 014 - Preencher com o n�mero do CNPJ do empregador anterior
* 163 matriculaAnterior sucessaoVinc E C 1-1 030 - Matr�cula do trabalhador na empresa que deu origem ao v�nculo
* 164 dtInicioVinculo sucessaoVinc E D 1-1 010 - Data de in�cio do v�nculo trabalhista.
* 165 observacao sucessaoVinc E C 0-1 255 - Observa��o
* 166 cessaoTrab vinculo G - 0-1 - - Grupo de informa��es de cess�o de trabalhador
* 167 cnpjCedente cessaoTrab E N 1-1 014 - Informar o CNPJ da empresa cedente
* 168 matriculaCedente cessaoTrab E C 1-1 030 - Preencher com a matr�cula do trabalhador na empresa de
* 169 dtAdmissaoCedente cessaoTrab E D 1-1 010 - Preencher com a data de admiss�o do trabalhador na
* 170 infoOnus cessaoTrab E N 1-1 001 - Informar se o trabalhador foi cedido com �nus ou sem �nus
* 171 ASO vinculo G - 0-1 - - Informa��es do atestado de sa�de ocupacional
* 172 dtAso ASO E D 1-1 010 - Data do Atestado de Sa�de Ocupacional.
* 173 medico ASO G - 1-1 - - M�dico respons�vel
* 174 nomeMedico medico E C 1-1 080 - Preencher com o nome do m�dico encarregado do exame
* 175 crm medico G - 1-1 - - CRM
* 176 nrCRM crm E C 1-1 008 - N�mero de inscri��o do m�dico encarregado do exame no
* 177 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedi��o do CRM.
* 178 exame ASO G - 0-N - - Exames realizados
* 179 dtExame exame E D 1-1 010 - Data do exame realizado
* 180 descExame exame E C 1-1 080 - Informar a descri��o do exame realizado (ex: RX T�rax,
* 
* S-2200 - Evento Admiss�o
* 
* 1 evtAdmissao G - 1-1 - - Evento Admiss�o
* 2 versao evtAdmissao A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAdmissao G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 trabalhador infEvento G - 1-1 - - Grupo de Informa��es do Trabalhador
* 16 cpfTrab trabalhador E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab trabalhador E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 nomeTrab trabalhador E C 1-1 080 - Nome do Trabalhador
* 19 sexo trabalhador E C 1-1 001 - Sexo do Trabalhador:
* 20 racaCor trabalhador E N 1-1 001 - Ra�a e cor do trabalhador, conforme tabela abaixo:
* 21 estadoCivil trabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 22 grauInstrucao trabalhador E N 1-1 002 - Grau de instru��o do trabalhador, conforme tabela:
* 23 nascimento trabalhador G - 1-1 - - Grupo de informa��es do nascimento do trabalhador
* 24 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 25 codMunicipio nascimento E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 26 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 27 paisNascto nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nascimento do trabalhador,
* 28 paisNacionalidade nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nacionalidade do
* 29 nomeMae nascimento E C 0-1 080 - Nome da m�e do trabalhador
* 30 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador
* 31 documentos trabalhador G - 0-1 - - Informa��es dos documentos pessoais do trabalhador
* 32 CTPS documentos G - 0-1 - - Informa��es da Carteira de Trabalho e Previd�ncia Social
* 33 nrCtps CTPS E C 1-1 011 - N�mero da carteira de trabalho e Previd�ncia Social do
* 34 serieCtps CTPS E C 1-1 004 - N�mero de s�rie da CTPS.
* 35 ufCtps CTPS E C 1-1 002 - UF da expedi��o da CTPS.
* 36 RIC documentos G - 0-1 - - Informa��es do Registro de Identidade �nico (RIC)
* 37 nrRic RIC E N 1-1 014 - N�mero do RIC
* 38 orgaoEmissor RIC E C 1-1 020 - �rg�o emissor do documento
* 39 dtExpedicao RIC E D 1-1 010 - Data da expedi��o do documento
* 40 RG documentos G - 0-1 - - Informa��es do Registro Geral (RG)
* 41 nrRg RG E C 1-1 014 - N�mero do RG
* 42 orgaoEmissor RG E C 1-1 020 - �rg�o emissor do documento
* 43 dtExpedicao RG E D 1-1 010 - Data da expedi��o do documento
* 44 RNE documentos G - 0-1 - - Informa��es do Registro Nacional de Estrangeiro
* 45 nrRne RNE E C 1-1 014 - N�mero de inscri��o no Registro Nacional de Estrangeiros
* 46 orgaoEmissor RNE E C 1-1 020 - �rg�o emissor do documento
* 47 dtExpedicao RNE E D 1-1 010 - Data da expedi��o do documento
* 48 OC documentos G - 0-1 - - Informa��es do n�mero de registro em �rg�o de Classe (OC)
* 49 nrOc OC E C 1-1 014 - N�mero de Inscri��o no �rg�o de Classe
* 50 orgaoEmissor OC E C 1-1 020 - �rg�o emissor do documento
* 51 dtExpedicao OC E D 1-1 010 - Data da expedi��o do documento
* 52 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.
* 53 CNH documentos G - 0-1 - - Informa��es da Carteira Nacional de Habilita��o (CNH)
* 54 nrCnh CNH E N 1-1 014 - N�mero da CNH
* 55 orgaoEmissor CNH E C 1-1 020 - �rg�o emissor do documento
* 56 dtExpedicao CNH E D 1-1 010 - Data da expedi��o do documento
* 57 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.
* 58 endereco trabalhador CG - 1-1 - - Grupo de informa��es do endere�o do Trabalhador
* 59 brasil endereco G - 0-1 - - Preenchimento obrigat�rio para trabalhador residente no Brasil.
* 60 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 61 descLogradouro brasil E C 1-1 080 - Descri��o do logradouro
* 62 nrLogradouro brasil E C 0-1 010 - N�mero do logradouro.
* 63 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 64 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 65 cep brasil E N 1-1 008 - C�digo de Endere�amento Postal
* 66 codMunicipio brasil E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 67 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 68 exterior endereco G - 0-1 - - Preenchido em caso de trabalhador residente no exterior.
* 69 paisResidencia exterior E N 1-1 005 - Preencher com o c�digo do pa�s, conforme tabela de pa�ses da
* 70 descLogradouro exterior E C 1-1 080 - Descri��o do logradouro
* 71 nrLogradouro exterior E C 0-1 010 - N�mero do logradouro.
* 72 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 73 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 74 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 75 codPostal exterior E C 0-1 010 - C�digo de Endere�amento Postal
* 76 infoCasaPropria trabalhador G - 0-1 - - Informa��es da Casa Pr�pria
* 77 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a resid�ncia pertence ao trabalhador
* 78 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o im�vel pr�prio foi adquirido com
* 79 trabEstrangeiro trabalhador G - 0-1 - - Grupo de informa��es do Trabalhador Estrangeiro
* 80 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 81 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturaliza��o brasileira em caso de estrangeiro
* 82 casadoBr trabEstrangeiro E C 1-1 001 - Condi��o de casado com brasileiro(s) em caso de trabalhador
* 83 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,
* 84 infBancarias trabalhador G - 0-1 - - Informa��es Banc�rias do Trabalhador
* 85 banco infBancarias E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 86 agencia infBancarias E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 87 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 88 nrContaBancaria infBancarias E C 1-1 020 - N�mero da Conta Banc�ria
* 89 infoDeficiencia trabalhador G - 0-1 - - Pessoa com Defici�ncia
* 90 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia motora.
* 91 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia visual
* 92 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia auditiva.
* 93 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador � reabilitado.
* 94 observacao infoDeficiencia E C 0-1 255 - Observa��o
* 95 dependente trabalhador G - 0-50 - - Informa��es dos dependentes
* 96 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 97 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 98 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 99 cpfDep dependente E N 0-1 011 - N�mero de Inscri��o no CPF
* 100 depIRRF dependente E C 1-1 001 - Informar se � dependente para fins de dedu��o do IRRF.
* 101 depSF dependente E C 1-1 001 - Informar se � dependente para fins de recebimento do benef�cio
* 102 contato trabalhador G - 0-1 - - Informa��es de Contato
* 103 fonePrincipal contato E N 0-1 012 - N�mero de telefone do trabalhador
* 104 foneAlternativo contato E N 0-1 012 - N�mero de telefone do trabalhador
* 105 emailPrincipal contato E C 0-1 060 - Endere�o eletr�nico
* 106 emailAlternativo contato E C 0-1 060 - Endere�o eletr�nico
* 107 vinculo infEvento G - 1-1 - - Grupo de informa��es do v�nculo
* 108 matricula vinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 109 dtAdmissao vinculo E D 1-1 010 - Preencher com a data de admiss�o do trabalhador no respectivo
* 110 tpAdmissao vinculo E N 1-1 001 - Tipo de admiss�o do trabalhador, conforme tabela abaixo:
* 111 indAdmissao vinculo E N 1-1 001 - Indicativo de Admiss�o:
* 112 indPrimeiroEmprego vinculo E C 1-1 001 - Indicar se trata-se do primeiro emprego do trabalhador.
* 113 infoContrato vinculo G - 1-1 - - Informa��es do Contrato de Trabalho
* 114 tpRegimeTrab infoContrato E N 1-1 001 - Tipo de regime trabalhista
* 115 tpRegimePrev infoContrato E N 1-1 001 - Tipo de regime previdenci�rio conforme tabela abaixo:
* 116 natAtividade infoContrato E N 1-1 001 - Tipo de v�nculo trabalhista, conforme tabela abaixo:
* 117 codCateg infoContrato E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 118 codCargo infoContrato E C 1-1 030 - Preencher com o c�digo do cargo
* 119 codFuncao infoContrato E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 120 remuneracao infoContrato G - 1-1 - - Informa��es da remunera��o e periodicidade de pagamento
* 121 vlrSalFixo remuneracao E N 1-1 14 2 Sal�rio fixo do trabalhador, correspondente � parte fixa da
* 122 unidSalFixo remuneracao E N 1-1 001 - Unidade de pagamento da parte fixa da remunera��o, conforme
* 123 vlrSalVariavel remuneracao E N 0-1 14 2 Sal�rio vari�vel do trabalhador. Corresponde � parte vari�vel da
* 124 unidSalVariavel remuneracao E N 0-1 001 - Unidade de pagamento da parte vari�vel da remunera��o,
* 125 duracao infoContrato G - 1-1 - - Dura��o do Contrato de Trabalho
* 126 tpContrato duracao E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
* 127 dtTermino duracao E D 0-1 010 - Data do T�rmino
* 128 localTrabalho infoContrato G - 1-1 - - Informa��es do local de trabalho
* 129 tpInscricao localTrabalho E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 130 nrInscricao localTrabalho E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 131 codLotacao localTrabalho E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 132 descComplementar localTrabalho E C 0-1 080 - Descri��o complementar do local de trabalho.
* 133 jornada infoContrato G - 1-1 - - Informa��es da jornada de trabalho
* 134 jornadaPadrao jornada G - 0-1 - - Informa��es da Jornada Regular
* 135 qtdHoras jornadaPadrao E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 136 codJornadaSegSexta jornadaPadrao E C 1-1 030 - C�digo do hor�rio de segunda a sexta
* 137 codJornadaSab jornadaPadrao E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 138 jornadaTurnoFixo jornada G - 0-1 - - Informa��es de Jornada em turnos fixos
* 139 qtdHoras jornadaTurnoFixo E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 140 codJornadaSeg jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � segunda-feira
* 141 codJornadaTer jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � ter�a-feira
* 142 codJornadaQua jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quarta-feira
* 143 codJornadaQui jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quinta-feira
* 144 codJornadaSex jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � sexta-feira
* 145 codJornadaSab jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 146 codJornadaDom jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao domingo
* 147 jornadaTurnoFlexivel jornada G - 0-1 - - Informa��es da jornada em turnos flex�veis
* 148 turno jornadaTurnoFlexivel E N 1-1 001 - Sequencial de identifica��o do turno
* 149 codJornada jornadaTurnoFlexivel E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 150 jornadaEspecial jornada G - 0-1 - - Informa��es da Jornada especial
* 151 tpEscala jornadaEspecial E N 1-1 002 - Tipo de Escala:
* 152 qtdHoras jornadaEspecial E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 153 codJornada jornadaEspecial E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 154 filiacaoSindical infoContrato G - 0-1 - - Filia��o Sindical do Trabalhador
* 155 cnpjSindTrabalhador filiacaoSindical E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador
* 156 alvaraJudicial infoContrato G - 0-1 - - Informa��es do alvar� judicial, preenchimento obrigat�rio em
* 157 nrProcJud alvaraJudicial E C 1-1 020 - Preencher com o n�mero do processo judicial.
* 158 FGTS vinculo G - 1-1 - - Informa��es do Fundo de Garantia por Tempo de Servi�o
* 159 optanteFGTS FGTS E N 1-1 001 - Informar a op��o pelo FGTS
* 160 dtOpcaoFGTS FGTS E D 0-1 010 - Informar a data de op��o pelo FGTS do trabalhador
* 161 sucessaoVinc vinculo G - 0-1 - - Grupo de informa��es da sucess�o de v�nculo trabalhista
* 162 cnpjEmpregadorAnterior sucessaoVinc E N 1-1 014 - Preencher com o n�mero do CNPJ do empregador anterior
* 163 matriculaAnterior sucessaoVinc E C 1-1 030 - Matr�cula do trabalhador na empresa que deu origem ao v�nculo
* 164 dtInicioVinculo sucessaoVinc E D 1-1 010 - Data de in�cio do v�nculo trabalhista.
* 165 observacao sucessaoVinc E C 0-1 255 - Observa��o
* 166 cessaoTrab vinculo G - 0-1 - - Grupo de informa��es de cess�o de trabalhador
* 167 cnpjCedente cessaoTrab E N 1-1 014 - Informar o CNPJ da empresa cedente
* 168 matriculaCedente cessaoTrab E C 1-1 030 - Preencher com a matr�cula do trabalhador na empresa de
* 169 dtAdmissaoCedente cessaoTrab E D 1-1 010 - Preencher com a data de admiss�o do trabalhador na
* 170 infoOnus cessaoTrab E N 1-1 001 - Informar se o trabalhador foi cedido com �nus ou sem �nus
* 171 ASO vinculo G - 0-1 - - Informa��es do atestado de sa�de ocupacional
* 172 dtAso ASO E D 1-1 010 - Data do Atestado de Sa�de Ocupacional.
* 173 medico ASO G - 1-1 - - M�dico respons�vel
* 174 nomeMedico medico E C 1-1 080 - Preencher com o nome do m�dico encarregado do exame
* 175 crm medico G - 1-1 - - CRM
* 176 nrCRM crm E C 1-1 008 - N�mero de inscri��o do m�dico encarregado do exame no
* 177 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedi��o do CRM.
* 178 exame ASO G - 0-N - - Exames realizados
* 179 dtExame exame E D 1-1 010 - Data do exame realizado
* 180 descExame exame E C 1-1 080 - Informar a descri��o do exame realizado (ex: RX T�rax,
* 
* 
* S-2220 - Altera��o de Dados Cadastrais
* 
* 1 evtAltCadastral G - 1-1 - - Evento Altera��o Cadastral do Trabalhador
* 2 versao evtAltCadastral A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAltCadastral G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 alteracao infEvento G - 1-1 - - Altera��o de Dados Cadastrais do Trabalhador
* 16 dtAlteracao alteracao E D 1-1 010 - Preencher com a data da altera��o das informa��es
* 17 dadosTrabalhador alteracao G - 1-1 - - Dados Cadastrais
* 18 cpfTrab dadosTrabalhador E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 19 nisTrab dadosTrabalhador E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 20 nomeTrab dadosTrabalhador E C 1-1 080 - Nome do Trabalhador
* 21 sexo dadosTrabalhador E C 1-1 001 - Sexo do Trabalhador:
* 22 racaCor dadosTrabalhador E N 1-1 001 - Ra�a e cor do trabalhador, conforme tabela abaixo:
* 23 estadoCivil dadosTrabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 24 grauInstrucao dadosTrabalhador E N 1-1 002 - Grau de instru��o do trabalhador, conforme tabela:
* 25 nascimento dadosTrabalhador G - 1-1 - - Grupo de informa��es do nascimento do trabalhador
* 26 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 27 codMunicipio nascimento E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 28 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 29 paisNascto nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nascimento do trabalhador,
* 30 paisNacionalidade nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nacionalidade do
* 31 nomeMae nascimento E C 0-1 080 - Nome da m�e do trabalhador
* 32 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador
* 33 documentos dadosTrabalhador G - 0-1 - - Informa��es dos documentos pessoais do trabalhador
* 34 CTPS documentos G - 0-1 - - Informa��es da Carteira de Trabalho e Previd�ncia Social
* 35 nrCtps CTPS E C 1-1 011 - N�mero da carteira de trabalho e Previd�ncia Social do
* 36 serieCtps CTPS E C 1-1 004 - N�mero de s�rie da CTPS.
* 37 ufCtps CTPS E C 1-1 002 - UF da expedi��o da CTPS.
* 38 RIC documentos G - 0-1 - - Informa��es do Registro de Identidade �nico (RIC)
* 39 nrRic RIC E N 1-1 014 - N�mero do RIC
* 40 orgaoEmissor RIC E C 1-1 020 - �rg�o emissor do documento
* 41 dtExpedicao RIC E D 1-1 010 - Data da expedi��o do documento
* 42 RG documentos G - 0-1 - - Informa��es do Registro Geral (RG)
* 43 nrRg RG E C 1-1 014 - N�mero do RG
* 44 orgaoEmissor RG E C 1-1 020 - �rg�o emissor do documento
* 45 dtExpedicao RG E D 1-1 010 - Data da expedi��o do documento
* 46 RNE documentos G - 0-1 - - Informa��es do Registro Nacional de Estrangeiro
* 47 nrRne RNE E C 1-1 014 - N�mero de inscri��o no Registro Nacional de Estrangeiros
* 48 orgaoEmissor RNE E C 1-1 020 - �rg�o emissor do documento
* 49 dtExpedicao RNE E D 1-1 010 - Data da expedi��o do documento
* 50 OC documentos G - 0-1 - - Informa��es do n�mero de registro em �rg�o de Classe (OC)
* 51 nrOc OC E C 1-1 014 - N�mero de Inscri��o no �rg�o de Classe
* 52 orgaoEmissor OC E C 1-1 020 - �rg�o emissor do documento
* 53 dtExpedicao OC E D 1-1 010 - Data da expedi��o do documento
* 54 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.
* 55 CNH documentos G - 0-1 - - Informa��es da Carteira Nacional de Habilita��o (CNH)
* 56 nrCnh CNH E N 1-1 014 - N�mero da CNH
* 57 orgaoEmissor CNH E C 1-1 020 - �rg�o emissor do documento
* 58 dtExpedicao CNH E D 1-1 010 - Data da expedi��o do documento
* 59 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.
* 60 endereco dadosTrabalhador CG - 1-1 - - Grupo de informa��es do endere�o do Trabalhador
* 61 brasil endereco G - 0-1 - - Preenchimento obrigat�rio para trabalhador residente no Brasil.
* 62 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 63 descLogradouro brasil E C 1-1 080 - Descri��o do logradouro
* 64 nrLogradouro brasil E C 0-1 010 - N�mero do logradouro.
* 65 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 66 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 67 cep brasil E N 1-1 008 - C�digo de Endere�amento Postal
* 68 codMunicipio brasil E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 69 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 70 exterior endereco G - 0-1 - - Preenchido em caso de trabalhador residente no exterior.
* 71 paisResidencia exterior E N 1-1 005 - Preencher com o c�digo do pa�s, conforme tabela de pa�ses da
* 72 descLogradouro exterior E C 1-1 080 - Descri��o do logradouro
* 73 nrLogradouro exterior E C 0-1 010 - N�mero do logradouro.
* 74 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 75 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 76 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 77 codPostal exterior E C 0-1 010 - C�digo de Endere�amento Postal
* 78 infoCasaPropria dadosTrabalhador G - 0-1 - - Informa��es da Casa Pr�pria
* 79 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a resid�ncia pertence ao trabalhador
* 80 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o im�vel pr�prio foi adquirido com
* 81 trabEstrangeiro dadosTrabalhador G - 0-1 - - Grupo de informa��es do Trabalhador Estrangeiro
* 82 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 83 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturaliza��o brasileira em caso de estrangeiro
* 84 casadoBr trabEstrangeiro E C 1-1 001 - Condi��o de casado com brasileiro(s) em caso de trabalhador
* 85 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,
* 86 infBancarias dadosTrabalhador G - 0-1 - - Informa��es Banc�rias do Trabalhador
* 87 banco infBancarias E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 88 agencia infBancarias E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 89 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 90 nrContaBancaria infBancarias E C 1-1 020 - N�mero da Conta Banc�ria
* 91 infoDeficiencia dadosTrabalhador G - 0-1 - - Pessoa com Defici�ncia
* 92 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia motora.
* 93 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia visual
* 94 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia auditiva.
* 95 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador � reabilitado.
* 96 observacao infoDeficiencia E C 0-1 255 - Observa��o
* 97 dependente dadosTrabalhador G - 0-50 - - Informa��es dos dependentes
* 98 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 99 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 100 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 101 cpfDep dependente E N 0-1 011 - N�mero de Inscri��o no CPF
* 102 depIRRF dependente E C 1-1 001 - Informar se � dependente para fins de dedu��o do IRRF.
* 103 depSF dependente E C 1-1 001 - Informar se � dependente para fins de recebimento do benef�cio
* 104 contato dadosTrabalhador G - 0-1 - - Informa��es de Contato
* 105 fonePrincipal contato E N 0-1 012 - N�mero de telefone do trabalhador
* 106 foneAlternativo contato E N 0-1 012 - N�mero de telefone do trabalhador
* 107 emailPrincipal contato E C 0-1 060 - Endere�o eletr�nico
* 108 emailAlternativo contato E C 0-1 060 - Endere�o eletr�nico
* 
* S-2240 - Altera��o Contratual
* 
* 
* 1 evtAltContratual G - 1-1 - - Evento Altera��o Contratual
* 2 versao evtAltContratual A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAltContratual G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 altContratual infEvento G - 1-1 - - Informa��es do Contrato de Trabalho
* 20 dtAlteracao altContratual E D 1-1 010 - Preencher com a data da altera��o das informa��es
* 21 infoContrato altContratual G - 1-1 - - Informa��es do Contrato de Trabalho
* 22 tpRegimeTrab infoContrato E N 1-1 001 - Tipo de regime trabalhista
* 23 tpRegimePrev infoContrato E N 1-1 001 - Tipo de regime previdenci�rio conforme tabela abaixo:
* 24 natAtividade infoContrato E N 1-1 001 - Tipo de v�nculo trabalhista, conforme tabela abaixo:
* 25 codCateg infoContrato E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 26 codCargo infoContrato E C 1-1 030 - Preencher com o c�digo do cargo
* 27 codFuncao infoContrato E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 28 remuneracao infoContrato G - 1-1 - - Informa��es da remunera��o e periodicidade de pagamento
* 29 vlrSalFixo remuneracao E N 1-1 14 2 Sal�rio fixo do trabalhador, correspondente � parte fixa da
* 30 unidSalFixo remuneracao E N 1-1 001 - Unidade de pagamento da parte fixa da remunera��o, conforme
* 31 vlrSalVariavel remuneracao E N 0-1 14 2 Sal�rio vari�vel do trabalhador. Corresponde � parte vari�vel da
* 32 unidSalVariavel remuneracao E N 0-1 001 - Unidade de pagamento da parte vari�vel da remunera��o,
* 33 duracao infoContrato G - 1-1 - - Dura��o do Contrato de Trabalho
* 34 tpContrato duracao E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
* 35 dtTermino duracao E D 0-1 010 - Data do T�rmino
* 36 localTrabalho infoContrato G - 1-1 - - Informa��es do local de trabalho
* 37 tpInscricao localTrabalho E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 38 nrInscricao localTrabalho E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 39 codLotacao localTrabalho E C 1-1 030 - Informar o c�digo atribu�do pela empresa para a lota��o
* 40 descComplementar localTrabalho E C 0-1 080 - Descri��o complementar do local de trabalho.
* 41 jornada infoContrato G - 1-1 - - Informa��es da jornada de trabalho
* 42 jornadaPadrao jornada G - 0-1 - - Informa��es da Jornada Regular
* 43 qtdHoras jornadaPadrao E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 44 codJornadaSegSexta jornadaPadrao E C 1-1 030 - C�digo do hor�rio de segunda a sexta
* 45 codJornadaSab jornadaPadrao E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 46 jornadaTurnoFixo jornada G - 0-1 - - Informa��es de Jornada em turnos fixos
* 47 qtdHoras jornadaTurnoFixo E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 48 codJornadaSeg jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � segunda-feira
* 49 codJornadaTer jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � ter�a-feira
* 50 codJornadaQua jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quarta-feira
* 51 codJornadaQui jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � quinta-feira
* 52 codJornadaSex jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo � sexta-feira
* 53 codJornadaSab jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao s�bado
* 54 codJornadaDom jornadaTurnoFixo E C 0-1 030 - C�digo do hor�rio relativo ao domingo
* 55 jornadaTurnoFlexivel jornada G - 0-1 - - Informa��es da jornada em turnos flex�veis
* 56 turno jornadaTurnoFlexivel E N 1-1 001 - Sequencial de identifica��o do turno
* 57 codJornada jornadaTurnoFlexivel E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 58 jornadaEspecial jornada G - 0-1 - - Informa��es da Jornada especial
* 59 tpEscala jornadaEspecial E N 1-1 002 - Tipo de Escala:
* 60 qtdHoras jornadaEspecial E N 0-1 002 - Quantidade/M�dia de horas relativas a jornada semanal do
* 61 codJornada jornadaEspecial E C 1-1 030 - Preencher com o c�digo atribu�do pelo empresa para a jornada
* 62 filiacaoSindical infoContrato G - 0-1 - - Filia��o Sindical do Trabalhador
* 63 cnpjSindTrabalhador filiacaoSindical E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador
* 64 alvaraJudicial infoContrato G - 0-1 - - Informa��es do alvar� judicial, preenchimento obrigat�rio em
* 65 nrProcJud alvaraJudicial E C 1-1 020 - Preencher com o n�mero do processo judicial.
* 
* 
* S-2260 - Comunica��o de Acidente de Trabalho
* 
* 1 evtCAT G - 1-1 - - Evento Comunica��o de Acidente de Trabalho
* 2 versao evtCAT A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtCAT G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideTrabalhador infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador
* 16 cpfTrab ideTrabalhador E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 infoAdicionais ideTrabalhador G - 0-1 - - Registro preenchido exclusivamente em caso de acidente
* 18 codCateg infoAdicionais E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 19 nomeTrab infoAdicionais E C 1-1 080 - Nome do Trabalhador
* 20 nisTrab infoAdicionais E N 0-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 21 dtNascto infoAdicionais E D 1-1 010 - Preencher com a data de nascimento
* 22 codCargo infoAdicionais E C 1-1 030 - Preencher com o c�digo do cargo
* 23 cat infEvento G - 1-1 - - Comunica��o de Acidente de Trabalho.
* 24 dtAcidente cat E D 1-1 010 - Data do Acidente
* 25 horaAcidente cat E N 1-1 004 - Hora do Acidente
* 26 horasTrabAntesAcidente cat E N 1-1 004 - Horas trabalhadas antes do acidente
* 27 tpAcidente cat E N 1-1 001 - Tipo de Acidente de Trabalho, conforme tabela abaixo:
* 28 tpCat cat E N 1-1 001 - Tipo de CAT, conforme tabela abaixo:
* 29 indCatParcial cat E C 1-1 001 - Indicar se trata-se de CAT parcial ou n�o.
* 30 indCatObito cat E C 1-1 001 - Indicar se houve �bito do trabalhador
* 31 indComunicPolicia cat E C 1-1 001 - Houve comunica��o � autoridade policial:
* 32 codSitGeradora cat E N 0-1 009 - preencher com o c�digo da situa��o geradora do acidente,
* 33 localAcidente cat G - Um
* 34 tpLocal localAcidente E N 1-1 001 - Tipo do Local do acidente:
* 35 descLocal localAcidente E C 0-1 080 - Especifica��o do local do acidente (p�tio, rampa de acesso,
* 36 descLogradouro localAcidente E C 0-1 080 - Descri��o do logradouro
* 37 nrLogradouro localAcidente E C 0-1 010 - N�mero do logradouro.
* 38 codMunicipio localAcidente E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 39 uf localAcidente E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 40 cnpjLocalAcidente localAcidente E N 0-1 014 - Deve ser preenchido quando o acidente ou doen�a ocupacional
* 41 parteAtingida cat G - 1-N - - Detalhamento da(s) parte(s) atingida(s) pelo acidente de
* 42 codParteAtingida parteAtingida E N 1-1 009 - Preencher com o c�digo correspondente a parte atingida,
* 43 agenteCausador cat G - 1-N - - Detalhamento do(s) agente(s) causador(es) do acidente de
* 44 codAgenteCausador agenteCausador E N 1-1 009 - Preencher com o c�digo correspondente ao agente causador do
* 45 testemunhas cat G - 0-50 - - Testemunhas do Acidente
* 46 nomeTestemunha testemunhas E C 1-1 080 - Nome da testemunha
* 47 descLogradouro testemunhas E C 1-1 080 - Descri��o do logradouro
* 48 nrLogradouro testemunhas E C 0-1 010 - N�mero do logradouro.
* 49 bairro testemunhas E C 0-1 030 - Nome do bairro/distrito
* 50 codMunicipio testemunhas E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 51 uf testemunhas E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 52 cep testemunhas E N 0-1 008 - C�digo de Endere�amento Postal
* 53 telefone testemunhas E C 0-1 012 - Informar o n�mero do telefone, com DDD.
* 54 atestado cat G - 0-1 - - Atestado M�dico
* 55 codCNES atestado E N 1-1 007 - C�digo da unidade de atendimento m�dico no Cadastro
* 56 dtAtendimento atestado E D 1-1 010 - Data do atendimento
* 57 hrAtendimento atestado E N 1-1 004 - Hora do atendimento
* 58 indInternacao atestado E C 1-1 001 - Indicativo de Interna��o:
* 59 durTratamento atestado E N 1-1 004 - Dura��o estimada do tratamento, em dias
* 60 indAfastamento atestado E C 1-1 001 - Indicativo do afastamento:
* 61 descLesao atestado E C 0-1 400 - Descri��o e natureza da les�o
* 62 diagProvavel atestado E C 0-1 100 - Diagn�stico Prov�vel
* 63 codCID atestado E C 1-1 005 - Informar o c�digo na tabela de classifica��o internacional de
* 64 observacao atestado E C 0-1 255 - Observa��o
* 65 medico atestado G - 1-1 - - M�dico respons�vel
* 66 nomeMedico medico E C 1-1 080 - Preencher com o nome do m�dico encarregado do exame
* 67 crm medico G - 1-1 - - CRM
* 68 nrCRM crm E C 1-1 008 - N�mero de inscri��o do m�dico encarregado do exame no
* 69 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedi��o do CRM.
* 70 catOrigem cat G - 0-1 - - Registro obrigat�rio que indica a CAT de origem, preenchido
* 71 dtCatOrigem catOrigem E D 1-1 010 - Informar a data da CAT de origem
* 72 nrCatOrigem catOrigem E C 1-1 015 - Informar o n�mero da CAT de origem, quando tratar-se de CAT
* 
* 
* S-2280 - Atestado de Sa�de Ocupacional
* 
* 1 evtASO G - 1-1 - - Evento ASO
* 2 versao evtASO A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtASO G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 aso infEvento G - 1-1 - - Detalhamento das informa��es do ASO
* 20 dtAso aso E D 1-1 010 - Data do Atestado de Sa�de Ocupacional.
* 21 tpAso aso E N 1-1 001 - Tipo de Atestado de Sa�de Ocupacional emitido, conforme
* 22 resultadoAso aso E N 1-1 001 - Resultado do ASO, conforme tabela abaixo:
* 23 exames aso G - 0-50 - - Registro que detalha os exames complementares porventura
* 24 dtExame exames E D 1-1 010 - Data do exame realizado
* 25 descExame exames E C 1-1 080 - Informar a descri��o do exame realizado (ex: RX T�rax,
* 26 riscos aso G - 0-50 - - Detalhar, caso exista, a ocorr�ncia de exposi��o a agentes
* 27 codAgente riscos E C 1-1 005 - Informar o c�digo do agente, conforme tabela 7.
* 28 medico aso G - 1-1 - - M�dico respons�vel
* 29 nomeMedico medico E C 1-1 080 - Preencher com o nome do m�dico encarregado do exame
* 30 crm medico G - 1-1 - - CRM
* 31 nrCRM crm E C 1-1 008 - N�mero de inscri��o do m�dico encarregado do exame no
* 32 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedi��o do CRM.
* 
* S-2300 - Aviso de F�rias
* 
* 1 evtAvisoFerias G - 1-1 - - Evento Aviso de F�rias
* 2 versao evtAvisoFerias A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAvisoFerias G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoAviso infEvento G - 1-1 - - Detalhamento do aviso de f�rias do trabalhador.
* 20 dtAvisoFerias infoAviso E D 1-1 010 - Data do Aviso de F�rias
* 21 dtIniGozo infoAviso E D 1-1 010 - Data do prevista para in�cio do gozo das F�rias.
* 22 dtFimGozo infoAviso E D 1-1 010 - Data do prevista para t�rmino do gozo das F�rias.
* 23 dtIniPerAquisicao infoAviso E D 1-1 010 - Data do in�cio do per�odo aquisitivo a que se refere o Aviso de
* 24 dtFimPerAquisicao infoAviso E D 1-1 010 - Data do t�rmino do per�odo aquisitivo a que se refere o Aviso
* 25 indAbonoPecuniario infoAviso E C 1-1 001 - Indica se parte das f�rias foi transformada em pec�nia:
* 26 tpFerias infoAviso E N 1-1 001 - Tipo de F�rias:
* 27 observacao infoAviso E C 0-1 255 - Observa��o
* 
* 
* S-2320 - Afastamento Tempor�rio
* 
* 1 evtAfastTemp G - 1-1 - - Evento Afastamento Tempor�rio
* 2 versao evtAfastTemp A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAfastTemp G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoAfastamento infEvento G - 1-1 - - Informa��es do Afastamento Tempor�rio
* 20 dtAfastamento infoAfastamento E D 1-1 010 - Data do Afastamento
* 21 codMotAfastamento infoAfastamento E N 1-1 002 - Preencher com o c�digo do motivo de afastamento tempor�rio,
* 22 tpAcidenteTransito infoAfastamento E C 0-1 001 - Tipo de Acidente de Tr�nsito:
* 23 observacao infoAfastamento E C 0-1 255 - Observa��o
* 24 infoAtestado infoAfastamento G - 0-1 - - Informa��es complementares do evento de Afastamento
* 25 codCID infoAtestado E C 1-1 005 - Informar o c�digo na tabela de classifica��o internacional de
* 26 qtdDiasAfastamento infoAtestado E N 1-1 003 - Quantidade de dias de afastamento concedidos pelo m�dico
* 27 medico infoAtestado G - 1-1 - - M�dico respons�vel
* 28 nomeMedico medico E C 1-1 080 - Preencher com o nome do m�dico encarregado do exame
* 29 crm medico G - 1-1 - - CRM
* 30 nrCRM crm E C 1-1 008 - N�mero de inscri��o do m�dico encarregado do exame no
* 31 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedi��o do CRM.
* 32 infoCessao infoAfastamento G - 0-1 - - Registro preenchido exclusivamente nos casos de afastamento
* 33 cnpjCessionario infoCessao E N 1-1 014 - Preencher com o CNPJ do �rg�o/entidade para o qual o
* 34 infoOnus infoCessao E N 1-1 001 - Informar se o trabalhador foi cedido com �nus ou sem �nus
* 35 infoMandadoSindical infoAfastamento G - 0-1 - - Informa��es Complementares - afastamento para exerc�cio de
* 36 cnpjSindicato infoMandadoSindical E N 1-1 014 - CNPJ do Sindicato no qual o trabalhador exercer� o mandato.
* 37 infoOnusRemuneracao infoMandadoSindical E N 1-1 001 - Informar se o trabalhador foi afastado com �nus ou sem �nus
* 
* S-2325 - Altera��o do Motivo do Afastamento
* 
* 1 evtAltMotAfast G - 1-1 - - Evento Altera��o do Motivo do Afastamento
* 2 versao evtAltMotAfast A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAltMotAfast G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoAltMotivo infEvento G - 1-1 - - Altera��o do Motivo do Afastamento
* 20 dtAltMotivo infoAltMotivo E D 1-1 010 - Preencher com a data da altera��o do motivo de afastamento
* 21 codMotivoAnterior infoAltMotivo E N 1-1 002 - Motivo anterior do afastamento, conforme tabela 18.
* 22 codMotAfastamento infoAltMotivo E N 1-1 002 - Preencher com o c�digo do motivo de afastamento tempor�rio,
* 23 indEfeitoRetroativo infoAltMotivo E C 1-1 001 - Informar se a altera��o de motivo tem efeito retroativo � a data
* 
* 
* 
* S-2330 - Retorno do Afastamento
* 
* 1 evtAfastRetorno G - 1-1 - - Evento Retorno do Afastamento
* 2 versao evtAfastRetorno A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAfastRetorno G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoRetorno infEvento G - 1-1 - - Informa��es do Retorno do Afastamento
* 20 dtRetorno infoRetorno E D 1-1 010 - Preencher com a data do retorno do afastamento
* 21 codMotAfastamento infoRetorno E N 1-1 002 - Preencher com o c�digo do motivo de afastamento tempor�rio,
* 22 observacao infoRetorno E C 0-1 255 - Observa��o
* 
* S-2340 - Estabilidade - In�cio
* 
* 1 evtEstabInicio G - 1-1 - - Evento Estabilidade - In�cio
* 2 infEvento evtEstabInicio G - 1-1 - - Informa��es do evento
* 3 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 4 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 5 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 6 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 7 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 8 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 9 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 10 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 11 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 12 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 13 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 14 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 15 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 16 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 17 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 18 infoEstabInicio infEvento G - 1-1 - - In�cio de Estabilidade
* 19 dtIniEstabilidade infoEstabInicio E D 1-1 010 - Preencher com a data de in�cio da estabilidade
* 20 codMotivoEstabilidade infoEstabInicio E N 1-1 001 - C�digo do motivo da estabilidade:
* 21 observacao infoEstabInicio E C 0-1 255 - Observa��o
* 
* 
* S-2345 - Estabilidade - T�rmino
* 
* 1 evtEstabTermino G - 1-1 - - Evento Estabilidade - T�rmino
* 2 infEvento evtEstabTermino G - 1-1 - - Informa��es do evento
* 3 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 4 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 5 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 6 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 7 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 8 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 9 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 10 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 11 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 12 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 13 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 14 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 15 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 16 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 17 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 18 infoEstabTermino infEvento G - 1-1 - - T�rmino de Estabilidade
* 19 dtFimEstabilidade infoEstabTermino E D 1-1 010 - Preencher com a data do t�rmino da estabilidade
* 20 codMotivoEstabilidade infoEstabTermino E N 1-1 001 - C�digo do motivo da estabilidade:
* 21 observacao infoEstabTermino E C 0-1 255 - Observa��o
* 
* S-2360 - Condi��o Diferenciada de Trabalho - In�cio
* 
* 1 evtCDTInicio G - 1-1 - - Evento Condi��o Diferenciada de Trabalho - In�cio
* 2 versao evtCDTInicio A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtCDTInicio G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoCDTInicio infEvento G - 1-1 - - Condi��o de Trabalho
* 20 dtIniCondicao infoCDTInicio E D 1-1 010 - Informar a data a partir da qual o trabalhador est� sujeito �s
* 21 tpCondicao infoCDTInicio E N 1-1 002 - Preencher com o c�digo relativo ao tipo de condi��o
* 22 fatoresRisco infoCDTInicio G - 0-50 - - O registro apresenta o detalhamento dos agentes nocivos aos
* 23 codAgente fatoresRisco E C 1-1 005 - Informar o c�digo do agente, conforme tabela 7.
* 24 intensidConcentracao fatoresRisco E C 0-1 015 - Intensidade ou Concentra��o da exposi��o do trabalhador ao
* 25 tecMedicao fatoresRisco E C 0-1 040 - T�cnica utilizada para medi��o da intensidade ou concentra��o
* 26 utilizacaoEPC fatoresRisco E N 1-1 001 - Utiliza��o de Equipamento de Prote��o Coletiva.
* 27 utilizacaoEPI fatoresRisco E N 1-1 001 - Utiliza��o de Equipamento de Prote��o Individual
* 28 epi fatoresRisco G - 0-50 - - Equipamentos de Prote��o Individual
* 29 caEPI epi E C 0-1 020 - Preenchimento obrigat�rio se {utilizacaoEPI} for igual a [1,2]
* 30 requisitosEPI infoCDTInicio G - 0-1 - - Registro onde s�o prestadas as informa��es sobre o
* 31 medProtecao requisitosEPI E C 1-1 001 - Informar "S" ou "N".
* 32 condFuncionamento requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 33 prazoValidade requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 34 periodicTroca requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 35 higienizacao requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 
* 
* S-2365 - Condi��o Diferenciada de Trabalho - T�rmino
* 
* 1 evtCDTTermino G - 1-1 - - Evento Condi��o Diferenciada de Trabalho - T�rmino
* 2 versao evtCDTTermino A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtCDTTermino G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoCDTTermino infEvento G - 1-1 - - Registro que detalha as informa��es do evento.
* 20 dtFimCondicao infoCDTTermino E D 1-1 010 - Informar a data at� a qual o trabalhador esteve sujeito �s
* 21 tpCondicao infoCDTTermino E N 1-1 002 - Preencher com o c�digo relativo ao tipo de condi��o
* 22 fatoresRisco infoCDTTermino G - 0-50 - - O registro apresenta o detalhamento do agente nocivo ao qual o
* 23 codAgente fatoresRisco E C 1-1 005 - Informar o c�digo do agente, conforme tabela 7.
* 
* S-2400 - Aviso Pr�vio
* 
* 1 evtAvisoPrevio G - 1-1 - - Evento Aviso Pr�vio
* 2 versao evtAvisoPrevio A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAvisoPrevio G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoAvisoPrevio infEvento G - 1-1 - - Detalha as informa��es do evento trabalhista
* 20 dtAvisoPrevio infoAvisoPrevio E D 1-1 010 - Data em que o trabalhador ou o empregador recebeu o aviso de
* 21 dtProjAfastamento infoAvisoPrevio E D 1-1 010 - Data projetada para o afastamento do trabalhador
* 22 tpAvisoPrevio infoAvisoPrevio E N 1-1 001 - Tipo de Aviso Pr�vio. Indica quem avisou o desligamento,
* 23 observacao infoAvisoPrevio E C 0-1 255 - Observa��o
* 
* 
* S-2405 - Cancelamento de Aviso Pr�vio
* 
* 1 evtCancAvisoPrevio G - 1-1 - - Evento Cancelamento de Aviso Pr�vio
* 2 versao evtCancAvisoPrevio A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtCancAvisoPrevio G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoCancAvisoPrevio infEvento G - 1-1 - - Cancelamento do Aviso Pr�vio
* 20 dtCancAvisoPrevio infoCancAvisoPrevio E D 1-1 010 - Preencher com a data do cancelamento do aviso pr�vio
* 21 observacao infoCancAvisoPrevio E C 0-1 255 - Observa��o
* 22 motivoCancAvisoPrevio infoCancAvisoPrevio E N 1-1 001 - Motivo do Cancelamento do Aviso Pr�vio:
* 
* S-2420 - Atividades Desempenhadas
* 
* 1 evtAtivDesemp G - 1-1 - - Evento Atividades Desempenhadas
* 2 versao evtAtivDesemp A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtAtivDesemp G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoAtivDesemp infEvento G - 1-1 - - Altera��o das Atividades Desempenhadas
* 20 dtAltAtivDesemp infoAtivDesemp E D 1-1 010 - Preencher com a data a partir da qual houve altera��o das
* 21 descAtividade infoAtivDesemp G - 0-50 - - Descri��o das Atividades Desempenhadas
* 22 descAtivDesemp descAtividade E C 1-1 255 - Descri��o da atividade desempenhada
* 
* 
* S-2440 - Comunica��o Fato Relevante
* 
* 1 evtComunicFatoRelevante G - 1-1 - - Evento Comunica��o de Fato Relevante
* 2 versao evtComunicFatoRelevante A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtComunicFatoRelevante G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoComunicFato infEvento G - 1-1 - - Comunica��o do Fato Relevante
* 20 dtFatoRelevante infoComunicFato E D 1-1 010 - Data do fato relevante
* 21 tpFatoRelevante infoComunicFato E C 1-1 001 - Tipo de fato relevante, conforme tabela:
* 22 descFatoRelevante infoComunicFato E C 1-1 - - Detalhar o fato relevante ocorrido.
* 
* 
* S-2600 - Trabalhador Sem V�nculo de Emprego - In�cio
* 
* 1 evtTSVInicio G - 1-1 - - Evento Trabalhador Sem V�nculo - In�cio
* 2 versao evtTSVInicio A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTSVInicio G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 trabalhador infEvento G - 1-1 - - Grupo de Informa��es do Trabalhador
* 16 cpfTrab trabalhador E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab trabalhador E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 nomeTrab trabalhador E C 1-1 080 - Nome do Trabalhador
* 19 sexo trabalhador E C 1-1 001 - Sexo do Trabalhador:
* 20 racaCor trabalhador E N 1-1 001 - Ra�a e cor do trabalhador, conforme tabela abaixo:
* 21 estadoCivil trabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 22 grauInstrucao trabalhador E N 1-1 002 - Grau de instru��o do trabalhador, conforme tabela:
* 23 nascimento trabalhador G - 1-1 - - Grupo de informa��es do nascimento do trabalhador
* 24 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 25 codMunicipio nascimento E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 26 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federa��o
* 27 paisNascto nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nascimento do trabalhador,
* 28 paisNacionalidade nascimento E N 1-1 005 - Preencher com o c�digo do pa�s de nacionalidade do
* 29 nomeMae nascimento E C 0-1 080 - Nome da m�e do trabalhador
* 30 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador
* 31 documentos trabalhador G - 0-1 - - Informa��es dos documentos pessoais do trabalhador
* 32 CTPS documentos G - 0-1 - - Informa��es da Carteira de Trabalho e Previd�ncia Social
* 33 nrCtps CTPS E C 1-1 011 - N�mero da carteira de trabalho e Previd�ncia Social do
* 34 serieCtps CTPS E C 1-1 004 - N�mero de s�rie da CTPS.
* 35 ufCtps CTPS E C 1-1 002 - UF da expedi��o da CTPS.
* 36 RIC documentos G - 0-1 - - Informa��es do Registro de Identidade �nico (RIC)
* 37 nrRic RIC E N 1-1 014 - N�mero do RIC
* 38 orgaoEmissor RIC E C 1-1 020 - �rg�o emissor do documento
* 39 dtExpedicao RIC E D 1-1 010 - Data da expedi��o do documento
* 40 RG documentos G - 0-1 - - Informa��es do Registro Geral (RG)
* 41 nrRg RG E C 1-1 014 - N�mero do RG
* 42 orgaoEmissor RG E C 1-1 020 - �rg�o emissor do documento
* 43 dtExpedicao RG E D 1-1 010 - Data da expedi��o do documento
* 44 RNE documentos G - 0-1 - - Informa��es do Registro Nacional de Estrangeiro
* 45 nrRne RNE E C 1-1 014 - N�mero de inscri��o no Registro Nacional de Estrangeiros
* 46 orgaoEmissor RNE E C 1-1 020 - �rg�o emissor do documento
* 47 dtExpedicao RNE E D 1-1 010 - Data da expedi��o do documento
* 48 OC documentos G - 0-1 - - Informa��es do n�mero de registro em �rg�o de Classe (OC)
* 49 nrOc OC E C 1-1 014 - N�mero de Inscri��o no �rg�o de Classe
* 50 orgaoEmissor OC E C 1-1 020 - �rg�o emissor do documento
* 51 dtExpedicao OC E D 1-1 010 - Data da expedi��o do documento
* 52 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.
* 53 CNH documentos G - 0-1 - - Informa��es da Carteira Nacional de Habilita��o (CNH)
* 54 nrCnh CNH E N 1-1 014 - N�mero da CNH
* 55 orgaoEmissor CNH E C 1-1 020 - �rg�o emissor do documento
* 56 dtExpedicao CNH E D 1-1 010 - Data da expedi��o do documento
* 57 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.
* 58 endereco trabalhador CG - 1-1 - - Grupo de informa��es do endere�o do Trabalhador
* 59 brasil endereco G - 0-1 - - Preenchimento obrigat�rio para trabalhador residente no Brasil.
* 60 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 61 descLogradouro brasil E C 1-1 080 - Descri��o do logradouro
* 62 nrLogradouro brasil E C 0-1 010 - N�mero do logradouro.
* 63 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 64 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 65 cep brasil E N 1-1 008 - C�digo de Endere�amento Postal
* 66 codMunicipio brasil E N 1-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 67 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 68 exterior endereco G - 0-1 - - Preenchido em caso de trabalhador residente no exterior.
* 69 paisResidencia exterior E N 1-1 005 - Preencher com o c�digo do pa�s, conforme tabela de pa�ses da
* 70 descLogradouro exterior E C 1-1 080 - Descri��o do logradouro
* 71 nrLogradouro exterior E C 0-1 010 - N�mero do logradouro.
* 72 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 73 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 74 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 75 codPostal exterior E C 0-1 010 - C�digo de Endere�amento Postal
* 76 infoCasaPropria trabalhador G - 0-1 - - Informa��es da Casa Pr�pria
* 77 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a resid�ncia pertence ao trabalhador
* 78 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o im�vel pr�prio foi adquirido com
* 79 trabEstrangeiro trabalhador G - 0-1 - - Grupo de informa��es do Trabalhador Estrangeiro
* 80 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 81 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturaliza��o brasileira em caso de estrangeiro
* 82 casadoBr trabEstrangeiro E C 1-1 001 - Condi��o de casado com brasileiro(s) em caso de trabalhador
* 83 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,
* 84 infBancarias trabalhador G - 0-1 - - Informa��es Banc�rias do Trabalhador
* 85 banco infBancarias E N 0-1 003 - Preencher com o c�digo do banco, no caso de dep�sito banc�rio
* 86 agencia infBancarias E C 0-1 015 - Preencher com o c�digo da ag�ncia, no caso de dep�sito
* 87 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 88 nrContaBancaria infBancarias E C 1-1 020 - N�mero da Conta Banc�ria
* 89 infoDeficiencia trabalhador G - 0-1 - - Pessoa com Defici�ncia
* 90 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia motora.
* 91 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia visual
* 92 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui defici�ncia auditiva.
* 93 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador � reabilitado.
* 94 observacao infoDeficiencia E C 0-1 255 - Observa��o
* 95 dependente trabalhador G - 0-50 - - Informa��es dos dependentes
* 96 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 97 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 98 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 99 cpfDep dependente E N 0-1 011 - N�mero de Inscri��o no CPF
* 100 depIRRF dependente E C 1-1 001 - Informar se � dependente para fins de dedu��o do IRRF.
* 101 depSF dependente E C 1-1 001 - Informar se � dependente para fins de recebimento do benef�cio
* 102 contato trabalhador G - 0-1 - - Informa��es de Contato
* 103 fonePrincipal contato E N 0-1 012 - N�mero de telefone do trabalhador
* 104 foneAlternativo contato E N 0-1 012 - N�mero de telefone do trabalhador
* 105 emailPrincipal contato E C 0-1 060 - Endere�o eletr�nico
* 106 emailAlternativo contato E C 0-1 060 - Endere�o eletr�nico
* 107 infoTSVInicio infEvento CG - 1-1 - - Trabalhador Sem V�nculo - In�cio
* 108 trabalhadorAvulso infoTSVInicio G - 0-1 - - Informa��es do Trabalhador Avulso
* 109 dtInicio trabalhadorAvulso E D 1-1 010 - Data de ingresso no ogmo ou no Sindicato
* 110 codCateg trabalhadorAvulso E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 111 fgts trabalhadorAvulso G - 1-1 - - Informa��es relativas ao FGTS do trabalhador avulso
* 112 optanteFGTS fgts E N 1-1 001 - Informar a op��o pelo FGTS
* 113 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de op��o pelo FGTS do trabalhador
* 114 contribIndividual infoTSVInicio G - 0-1 - - Informa��es de contribuinte individual (diretor n�o empregado,
* 115 codCateg contribIndividual E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 116 dtInicio contribIndividual E D 1-1 010 - Para o diretor n�o empregado, preencher com a data de posse
* 117 codCargo contribIndividual E C 1-1 030 - Preencher com o c�digo do cargo
* 118 codFuncao contribIndividual E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 119 fgts contribIndividual G - 0-1 - - Informa��es relativas ao FGTS, exclusiva para a categoria de
* 120 optanteFGTS fgts E N 1-1 001 - Informar a op��o pelo FGTS
* 121 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de op��o pelo FGTS do trabalhador
* 122 servPubIndConselho infoTSVInicio G - 0-1 - - Servidor P�blico indicado para Conselho ou �rg�o
* 123 dtInicio servPubIndConselho E D 1-1 010 - Data de posse no cargo
* 124 codCateg servPubIndConselho E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 125 codCargo servPubIndConselho E C 1-1 030 - Preencher com o c�digo do cargo
* 126 codFuncao servPubIndConselho E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 127 dirigenteSindical infoTSVInicio G - 0-1 - - Dirigente Sindical
* 128 dtInicio dirigenteSindical E D 1-1 010 - Data de in�cio do mandato no sindicato
* 129 codCateg dirigenteSindical E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 130 empresaOrigem dirigenteSindical G - 1-1 - - Empresa de Origem do Dirigente Sindical
* 131 categOrigem empresaOrigem E N 1-1 003 - preencher com o c�digo correspondente � categoria de origem
* 132 cnpjOrigem empresaOrigem E N 0-1 014 - Preencher com o CNPJ da empresa de origem do dirigente
* 133 dtAdmissaoOrigem empresaOrigem E D 0-1 010 - Preencher com a data de admiss�o do dirigente sindical na
* 134 matricOrigem empresaOrigem E C 0-1 030 - Preencher com a matr�cula do trabalhador na empresa de
* 135 fgts dirigenteSindical G - 0-1 - - Informa��es relativas ao FGTS do dirigente sindical
* 136 optanteFGTS fgts E N 1-1 001 - Informar a op��o pelo FGTS
* 137 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de op��o pelo FGTS do trabalhador
* 138 estagiario infoTSVInicio G - 0-1 - - informa��es do estagi�rio
* 139 dtInicio estagiario E D 1-1 010 - Data do in�cio do est�gio
* 140 codCateg estagiario E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 141 natEstagio estagiario E C 1-1 001 - Natureza do Est�gio:
* 142 nivEstagio estagiario E C 1-1 001 - N�vel:
* 143 areaAtuacao estagiario E C 0-1 050 - �rea de atua��o do estagi�rio
* 144 nrApolice estagiario E C 0-1 030 - Nr. Ap�lice de Seguro
* 145 vlrBolsa estagiario E N 0-1 14 2 Preencher com o valor da bolsa, se o est�gio for remunerado.
* 146 dtPrevistaTermino estagiario E D 1-1 010 - Data prevista para o t�rmino do est�gio
* 147 instEnsino estagiario G - 1-1 - - Institui��o de Ensino
* 148 cnpjInstEnsino instEnsino E N 1-1 014 - Preencher com o cnpj da institui��o de ensino.
* 149 nomeRazao instEnsino E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 150 descLogradouro instEnsino E C 1-1 080 - Descri��o do logradouro
* 151 nrLogradouro instEnsino E C 0-1 010 - N�mero do logradouro.
* 152 bairro instEnsino E C 0-1 030 - Nome do bairro/distrito
* 153 cep instEnsino E N 1-1 008 - C�digo de Endere�amento Postal
* 154 codMunicipio instEnsino E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 155 uf instEnsino E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 156 ageIntegracao estagiario G - 1-1 - - Agente de Integra��o
* 157 cnpjAgenteIntegracao ageIntegracao E N 1-1 014 - CNPJ do agente de integra��o
* 158 nomeRazao ageIntegracao E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 159 descLogradouro ageIntegracao E C 1-1 080 - Descri��o do logradouro
* 160 nrLogradouro ageIntegracao E C 0-1 010 - N�mero do logradouro.
* 161 bairro ageIntegracao E C 0-1 030 - Nome do bairro/distrito
* 162 cep ageIntegracao E N 1-1 008 - C�digo de Endere�amento Postal
* 163 codMunicipio ageIntegracao E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 164 uf ageIntegracao E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 165 coordEstagio estagiario G - 1-1 - - Coordenador do Est�gio
* 166 cpfCoordenador coordEstagio E N 1-1 011 - CPF do coordenador do est�gio
* 167 nomeCoordenador coordEstagio E C 1-1 080 - Nome do Coordenador do Est�gio
* 
* 
* S-2620 - Trabalhador Sem V�nculo de Emprego - Altera��o Contratual
* 
* 1 evtTSVAltContratual G - 1-1 - - Evento Trabalhador Sem V�nculo - Altera��o Contratual
* 2 versao evtTSVAltContratual A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTSVAltContratual G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 infoTSVAlteracao infEvento CG - 1-1 - - Trabalhador Sem V�nculo - Altera��o Contratual
* 16 cpfTrab infoTSVAlteracao E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab infoTSVAlteracao E N 0-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 dtAlteracao infoTSVAlteracao E D 1-1 010 - Preencher com a data da altera��o das informa��es
* 19 contribIndividual infoTSVAlteracao G - 0-1 - - Informa��es do Contribuinte Individual
* 20 codCateg contribIndividual E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 21 codCargo contribIndividual E C 1-1 030 - Preencher com o c�digo do cargo
* 22 codFuncao contribIndividual E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 23 servPubIndConselho infoTSVAlteracao G - 0-1 - - Servidor P�blico indicado para Conselho ou �rg�o
* 24 codCargo servPubIndConselho E C 1-1 030 - Preencher com o c�digo do cargo
* 25 codFuncao servPubIndConselho E C 0-1 030 - Preencher com o c�digo da fun��o, se utilizado pela empresa
* 26 estagiario infoTSVAlteracao G - 0-1 - - informa��es do estagi�rio
* 27 natEstagio estagiario E C 1-1 001 - Natureza do Est�gio:
* 28 nivEstagio estagiario E C 1-1 001 - N�vel:
* 29 areaAtuacao estagiario E C 0-1 050 - �rea de atua��o do estagi�rio
* 30 nrApolice estagiario E C 0-1 030 - Nr. Ap�lice de Seguro
* 31 vlrBolsa estagiario E N 0-1 14 2 Preencher com o valor da bolsa, se o est�gio for remunerado.
* 32 dtPrevistaTermino estagiario E D 1-1 010 - Data prevista para o t�rmino do est�gio
* 33 instEnsino estagiario G - 1-1 - - Institui��o de Ensino
* 34 cnpjInstEnsino instEnsino E N 1-1 014 - Preencher com o cnpj da institui��o de ensino.
* 35 nomeRazao instEnsino E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 36 descLogradouro instEnsino E C 1-1 080 - Descri��o do logradouro
* 37 nrLogradouro instEnsino E C 0-1 010 - N�mero do logradouro.
* 38 bairro instEnsino E C 0-1 030 - Nome do bairro/distrito
* 39 cep instEnsino E N 1-1 008 - C�digo de Endere�amento Postal
* 40 codMunicipio instEnsino E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 41 uf instEnsino E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 42 ageIntegracao estagiario G - 1-1 - - Agente de Integra��o
* 43 cnpjAgenteIntegracao ageIntegracao E N 1-1 014 - CNPJ do agente de integra��o
* 44 nomeRazao ageIntegracao E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa f�sica, ou a
* 45 descLogradouro ageIntegracao E C 1-1 080 - Descri��o do logradouro
* 46 nrLogradouro ageIntegracao E C 0-1 010 - N�mero do logradouro.
* 47 bairro ageIntegracao E C 0-1 030 - Nome do bairro/distrito
* 48 cep ageIntegracao E N 1-1 008 - C�digo de Endere�amento Postal
* 49 codMunicipio ageIntegracao E N 0-1 007 - Preencher com o c�digo do munic�pio, conforme tabela do
* 50 uf ageIntegracao E C 1-1 002 - Preencher com a sigla da Unidade da Federa��o
* 51 coordEstagio estagiario G - 1-1 - - Coordenador do Est�gio
* 52 cpfCoordenador coordEstagio E N 1-1 011 - CPF do coordenador do est�gio
* 53 nomeCoordenador coordEstagio E C 1-1 080 - Nome do Coordenador do Est�gio
* 
* 
* 
* S-2680 - Trabalhador Sem V�nculo de Emprego - T�rmino
* 1 evtTSVTermino G - 1-1 - - Evento Trabalhador Sem V�nculo de Emprego - T�rmino
* 2 versao evtTSVTermino A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtTSVTermino G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 infoTSVTermino infEvento CG - 1-1 - - Trabalhador Sem V�nculo de Emprego - T�rmino
* 16 cpfTrab infoTSVTermino E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab infoTSVTermino E N 0-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 trabalhadorAvulso infoTSVTermino G - 0-1 - - Informa��es do Trabalhador Avulso
* 19 dtTermino trabalhadorAvulso E D 0-1 010 - Data do T�rmino
* 20 contribIndividual infoTSVTermino G - 0-1 - - Informa��es do Contribuinte Individual (diretor n�o empregado
* 21 codCateg contribIndividual E N 1-1 003 - Preencher com o c�digo da categoria do trabalhador, conforme
* 22 dtTermino contribIndividual E D 1-1 010 - Data do T�rmino
* 23
* 24 verbasRescisorias contribIndividual G - 0-1 - - Registro onde s�o prestadas as informa��es relativas �s verbas
* 25 bcCP verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 26 bcIRRF verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo IRRF para o
* 27 bcFGTS verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo do FGTS para o
* 28 bcFGTSVerbasIndeniz verbasRescisorias E N 0-1 14 2 Base de C�lculo do FGTS relativo �s verbas indenizat�rias
* 29 bcFgtsMesAnt verbasRescisorias E N 1-1 14 2 Informar a base de c�lculo do FGTS do m�s anterior, caso ainda
* 30 descCP verbasRescisorias E N 1-1 14 2 preencher com o valor descontado do segurado referente
* 31 vlrProventos verbasRescisorias E N 1-1 14 2 Informar o valor total dos proventos
* 32 vlrDescontos verbasRescisorias E N 1-1 14 2 Preencher com o valor total dos descontos
* 33 vlrLiquido verbasRescisorias E N 1-1 14 2 Preencher com o valor l�quido
* 34 itensRemuneracao verbasRescisorias G - 1-50 - - Registro que relaciona as rubricas que comp�e a remunera��o
* 35 codRubrica itensRemuneracao E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 36 qtdRubrica itensRemuneracao E N 0-1 004 - Informar a quantidade de refer�ncia para apura��o (em horas,
* 37 vlrRubrica itensRemuneracao E N 1-1 14 2 Valor da Rubrica
* 38 servPubIndConselho infoTSVTermino G - 0-1 - - Servidor P�blico indicado para Conselho ou �rg�o
* 39 dtTermino servPubIndConselho E D 0-1 010 - Data do T�rmino
* 40 dirigenteSindical infoTSVTermino G - 0-1 - - Dirigente Sindical
* 41 dtTermino dirigenteSindical E D 0-1 010 - Data do T�rmino
* 42 estagiario infoTSVTermino G - 0-1 - - informa��es do estagi�rio
* 43 dtTermino estagiario E D 0-1 010 - Data do T�rmino
* 
* 
* S-2800 - Desligamento
* 
* 1 evtDesligamento G - 1-1 - - Evento Desligamento
* 2 versao evtDesligamento A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtDesligamento G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoDesligamento infEvento G - 1-1 - - Apresenta as informa��es relativas ao desligamento do v�nculo
* 20 motivoDesligamento infoDesligamento E N 1-1 002 - C�digo de Motivo do Desligamento, conforme tabela 19.
* 21 dtDesligamento infoDesligamento E D 0-1 010 - Preencher com a data de desligamento do trabalhador para o
* 22 indPagtoAPI infoDesligamento E C 1-1 001 - Indicativo de pagamento de Aviso Pr�vio Indenizado:
* 23 nrAtestadoObito infoDesligamento E C 0-1 030 - N�mero que identifica o registro do Atestado de �bito. Campo
* 24 nrProcTrabalhista infoDesligamento E C 0-1 020 - N�mero que identifica o processo trabalhista, quando o
* 25 bcFgtsMesAnt infoDesligamento E N 1-1 14 2 Informar a base de c�lculo do FGTS do m�s anterior, caso ainda
* 26 observacao infoDesligamento E C 0-1 255 - Preencher com qualquer anota��o relevante sobre o
* 27 sucessaoVinculo infoDesligamento G - 0-1 - - Registro preenchido exclusivamente nos casos de sucess�o do
* 28 cnpjSucessora sucessaoVinculo E N 1-1 014 - Preencher com o CNPJ da empresa sucessora.
* 29 verbasRescisorias infoDesligamento G - 0-1 - - Registro onde s�o prestadas as informa��es relativas �s verbas
* 30 bcCP verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo da contribui��o
* 31 bcIRRF verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo IRRF para o
* 32 bcFGTS verbasRescisorias E N 1-1 14 2 Informar o valor total da base de c�lculo do FGTS para o
* 33 bcFGTSVerbasIndeniz verbasRescisorias E N 0-1 14 2 Base de C�lculo do FGTS relativo �s verbas indenizat�rias
* 34 descCP verbasRescisorias E N 1-1 14 2 preencher com o valor descontado do segurado referente
* 35 vlrProventos verbasRescisorias E N 1-1 14 2 Informar o valor total dos proventos
* 36 vlrDescontos verbasRescisorias E N 1-1 14 2 Preencher com o valor total dos descontos
* 37 vlrLiquido verbasRescisorias E N 1-1 14 2 Preencher com o valor l�quido
* 38 itensRemuneracao verbasRescisorias G - 1-50 - - Registro que relaciona as rubricas que comp�e a remunera��o
* 39 codRubrica itensRemuneracao E C 1-1 030 - Informar o c�digo atribu�do pela empresa e que identifica a
* 40 qtdRubrica itensRemuneracao E N 0-1 004 - Informar a quantidade de refer�ncia para apura��o (em horas,
* 41 vlrRubrica itensRemuneracao E N 1-1 14 2 Valor da Rubrica
* 42 expAgenteNocivo verbasRescisorias G - 1-1 - - Registro que permite o detalhamento do grau de exposi��o do
* 43 grauExp expAgenteNocivo E N 1-1 001 - Preencher com o c�digo que representa o
* 
* 
* S-2820 - Reintegra��o
* 1 evtReintegracao G - 1-1 - - Evento Reintegra��o
* 2 versao evtReintegracao A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtReintegracao G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de Identifica��o do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o n�mero do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 12 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 15 ideVinculo infEvento G - 1-1 - - Informa��es de Identifica��o do Trabalhador e do V�nculo
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matr�cula atribu�da ao trabalhador pela empresa
* 19 infoReintegracao infEvento G - 1-1 - - Reintegra��o
* 20 tpReintegracao infoReintegracao E N 1-1 001 - Tipo de Reintegra��o:
* 21 nrProcJud infoReintegracao E C 0-1 020 - Em caso de reintegra��o por determina��o judicial, preencher
* 22 nrLeiAnistia infoReintegracao E C 0-1 020 - N�mero da Lei de Anistia:
* 23 dtEfeito infoReintegracao E D 1-1 010 - Preencher com a data a partir da qual o trabalhador dever� ser
* 24 dtEfeitoRetorno infoReintegracao E D 1-1 010 - Informar a data do efetivo retorno ao trabalho
* 
* 
* S-2900 - Exclus�o de Eventos
* 1 evtExclusao G - 1-1 - - Exclus�o de Evento Enviado Indevidamente
* 2 versao evtExclusao A C 1-1 005 - Deve ser informado o c�digo do leiaute utilizado para gera��o
* 3 infEvento evtExclusao G - 1-1 - - Informa��es do evento
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informa��es de identifica��o do evento
* 6 tpAmb ideEvento E N 1-1 001 - Identifica��o do ambiente:
* 7 procEmi ideEvento E N 1-1 001 - Processo de emiss�o do evento:
* 8 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 9 verProc ideEvento E C 1-1 020 - Vers�o do processo de emiss�o do evento. Informar a vers�o do
* 10 ideEmpregador infEvento G - 1-1 - - Informa��es de identifica��o do empregador
* 11 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o c�digo correspondente ao tipo de inscri��o,
* 12 nrInscricao ideEmpregador E C 1-1 014 - Indicar o n�mero de inscri��o do contribuinte, conforme
* 13 infoExclusao infEvento G - 1-1 - - Registro que identifica o evento objeto da exclus�o.
* 14 tpEvento infoExclusao E C 1-1 006 - Preencher com o tipo de evento, conforme tabela 9.
* 15 nrReciboEvento infoExclusao E N 0-1 015 - Preencher com o n�mero do recibo do evento que ser� exclu�do.
* 16 cpfTrab infoExclusao E N 0-1 011 - Preencher com o n�mero do CPF do trabalhador
* 17 nisTrab infoExclusao E N 0-1 011 - Preencher com o n�mero de inscri��o do segurado, o qual pode
* 
