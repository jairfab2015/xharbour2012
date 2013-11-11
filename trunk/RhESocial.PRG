*--------------------------------------------------------------------*
* Geracao dos arquivos eSocial                                       *
*--------------------------------------------------------------------*
#define CRLF CHR(13)+CHR(10)
#command DEFAULT <param> := <val> [, <paramn> := <valn> ];
         => ;
         <param> := IIF(<param> = NIL, <val>, <param> ) ;
         [; <paramn> := IIF(<paramn> = NIL, <valn>, <paramn> ) ]

#include "harbourboleto.ch"
#include "hbclass.ch"
#include "fileio.ch"
#include "common.ch"
#Translate StoD(<p>) => CTOD(RIGHT(<p>, 2) + "/" + SUBSTR(<p>, 5, 2) + "/" + LEFT(<p>, 4))

*------------------------------------------------------------------------------*
*  Geracao de arquivo bancario  CNAB240                                        *
*                                                                              *
* -----------------------------------------------------------------------------*
CLASS eSocial

   DATA cLine              INIT "" PROTECTED
   DATA nSeqReg            INIT 2  PROTECTED 
   DATA cFillTrailer       INIT "" PROTECTED
   DATA DtEmis             INIT DATE()
   DATA DtVenc             INIT DATE()
   DATA cData
   DATA NomeArq            INIT ""
   DATA Destino            INIT ""
   DATA nHandle            INIT ""

   DATA Empresa            INIT ""

   METHOD New() CONSTRUCTOR
   METHOD Execute( )
   METHOD OPEN()
   
   METHOD S1000()
   METHOD S1010()
   METHOD S1020()
   METHOD S1030()
   
   METHOD Add()

   METHOD Line()
   METHOD IncluiTag(nTipo,cTag,cValor)
   METHOD CLOSE()

ENDCLASS
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S-1030 - Tabela de Cargos
* -----------------------------------------------------------------------------*
METHOD S1030() CLASS eSocial

::incluiTag(1,"evtTabCargo")                          //G - 1-1 - - Evento utilizado para inclusão, alteração e exclusão de registros
::incluiTag(2,"versao","evtTabCargo")                 //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")                            //G - 1-1 - - Informações do evento
::incluiTag(3,"idEvento")                             //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(4,"ideEvento")                            //G - 1-1 - - Informações de Identificação do Evento
::incluiTag(4,"tpAmb","ideEvento")                    //E N 1-1 001 - Identificação do ambiente:
::incluiTag(4,"procEmi","ideEvento")                  //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(4,"indSegmento","ideEvento")              //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(4,"verProc","ideEvento")                  //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")

::incluiTag(3,"ideEmpregador")                        //G - 1-1 - - Informações de identificação do empregador
::incluiTag(4,"tpInscricao","ideEmpregador")          //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEmpregador")          //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")

::incluiTag(3,"infoCargo")                            //CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e

::incluiTag(4,"inclusao")                             //G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"ideCargo")                             //G - 1-1 - - Informações de identificação do cargo e validade das
::incluiTag(6,"codCargo","ideCargo")                  //E C 1-1 030 - Preencher com o código do cargo
::incluiTag(6,"dtIniValidade","ideCargo")             //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","ideCargo")             //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideCargo") 

::incluiTag(5,"dadosCargo")                           //G - 1-1 - - Detalhamento das informações do cargo que está sendo incluído
::incluiTag(6,"descCargo","dadosCargo")               //E C 1-1 100 - Preencher com descrição do cargo
::incluiTag(6,"codCBO","dadosCargo")                  //E N 1-1 006 - Código Brasileiro de Ocupação
::incluiTag(5,"/dadosCargo")
::incluiTag(4,"/inclusao")


::incluiTag(4,"alteracao")                           //G - 0-1 - - Alteração de informações já existentes
::incluiTag(5,"ideCargo")                            //G - 1-1 - - Grupo de informações de identificação do cargo, apresentando
::incluiTag(6,"codCargo"," ")                        //E C 1-1 030 - Preencher com o código do cargo
::incluiTag(6,"dtIniValidade","ideCargo")            //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","ideCargo")            //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"dadosCargo")                          //G - 1-1 - - Informações do cargo
::incluiTag(6,"descCargo","dadosCargo")              //E C 1-1 100 - Preencher com descrição do cargo
::incluiTag(6,"codCBO","dadosCargo")                 //E N 1-1 006 - Código Brasileiro de Ocupação
::incluiTag(5,"/dadosCargo")
::incluiTag(5,"/ideCargo")

::incluiTag(5,"novaValidade")                        //G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
  ::incluiTag(6,"dtIniValidade","novaValidade")      //E D 1-1 010 - Preencher com a data de início da validade das informações
  ::incluiTag(6,"dtFimValidade","novaValidade")      //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")

::incluiTag(4,"exclusao")                            //G - 0-1 - - Exclusão de informações
::incluiTag(5,"ideCargo")                            //G - 1-1 - - Identificação do registro que será excluído
  ::incluiTag(6,"codCargo","ideCargo")               //E C 1-1 030 - Preencher com o código do cargo
  ::incluiTag(6,"dtIniValidade","ideCargo")          //E D 1-1 010 - Preencher com a data de início da validade das informações
  ::incluiTag(6,"dtFimValidade","ideCargo")          //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideCargo")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoCargo")
::incluiTag(3,"/idEvento")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabCargo")

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Add(oBol) CLASS eSocial

LOCAL cMsg, cCart

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD CLOSE() CLASS eSocial

*   ::nSeqReg += 2
*   *--- Trailer Arquivo ---*
*   ::cLine += ::cCodBco        // codigo do banco
*   ::cLine += "9999"           // lote de servico
*   ::cLine += "9"              // tipo de registro
*   ::cLine += SPACE(9)         // use exclusivo FEBRABAN
*   ::cLine += "000001"         // Quantidade de lotes do arquivo
*   ::cLine += STRZERO((::nSeqReg),6)             // Quantidade de registros do arquivo
*   ::cLine += SPACE(211) +CHR(10)+CHR(26)        // uso exclusivo FEBRABAN

* ::Line()
   ::cLine += '</ESOCIAL>'
   ::Line()

 FCLOSE(::nHandle)
RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
* Grava a linha para arquivo txt                                               *
* -----------------------------------------------------------------------------*
METHOD Line() CLASS eSocial

*::cLine := UPPER(::cLine)
FWRITE(::nHandle,::cLine+CRLF)
::cLine := ""

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Execute( ) CLASS eSocial


::add(Self)
::S1000()
::S1010()
::S1020()
::S1030()
** FAZER O PROCESSAMENTO AQUI 

RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*
* -----------------------------------------------------------------------------*
METHOD new() CLASS eSocial

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
* Criacao do arquivo txt                                                       *
* -----------------------------------------------------------------------------*
METHOD OPEN() CLASS eSocial

LOCAL NomeArquivo:=""

LOCAL nI := 1 , cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 

::cData := STRZERO(DAY(::DtEmis),2)+STRZERO(MONTH(::DtEmis),2)+RIGHT(STR(YEAR(::DtEmis)),2)

*--- Nome do arquivo ---*
IF EMPTY(::NomeArq)
   ::NomeArq := "ES"+RIGHT(STR(YEAR(::DtEmis)),2)+STRZERO(MONTH(::DtEmis),2)+STRZERO(DAY(::DtEmis),2)+".XML"
ENDIF 


IF EMPTY(::Destino)
   cPasta := ALLTRIM(cPasta)
   IF RIGHT(cPasta,1) != HB_OSpathseparator()
      cPasta += HB_OSpathseparator()
   ENDIF

   IF !IsDirectory(cPASTA)
      MAKEDIR(ALLTRIM(cPASTA))
   ENDIF
   ::Destino := cPASTA

   IF !IsDirectory(cPASTA)
      MAKEDIR(ALLTRIM(cPASTA))
   ENDIF
ELSE 

   *--- Verifica se tem a pasta, se nao tem cria ---*
   IF !IsDirectory(::Destino)
      MAKEDIR(ALLTRIM(::Destino))
   ENDIF
   
ENDIF


*--- Ja tem o arquivo, neste caso apaga para cria um novo arquivo ---*
NomeArquivo := ::Destino+::NomeArq
msgstop(NomeArquivo,'aviso')
IF FILE(NomeArquivo)
   FERASE(NomeArquivo)
ENDIF 

*--- Cria o arquivo txt ---*
::nHandle := FCREATE(::Destino+::NomeArq,FC_NORMAL)


::cLine := ""
IF ::nHandle < 0  // Header

ELSE 

  *::cData := STRZERO(DAY(::DtEmis),2)+STRZERO(MONTH(::DtEmis),2)+RIGHT(STR(YEAR(::DtEmis)),4)

   // Header Arquivo
   ::cLine += '<?xml version="1.0" encoding="ISO-8859-1" ?>'
   ::Line()
   ::cLine += '<ESOCIAL>'
   ::Line()

ENDIF

RETURN ::nHandle
*------------------------------------------------------------------------------*

*	::cXMLSaida := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">' + '<infNFe versao="2.00" Id="NFe'+cChaveNFe+'">'
*	::incluiTag('ide')
*    ::incluiTag('cUF',::aIde[ "cUF" ])



METHOD incluiTag(nTipo,cTag,cValor) CLASS eSocial

   IF nTipo = Nil
      nTipo := 0
   ENDIF 

   IF cValor = Nil
       IF nTipo = 0
          ::cLine += '<'+cTag+'>'
       ELSEIF nTipo = 1
          ::cLine += SPACE(3)+'<'+cTag+'>'
       ELSEIF nTipo = 2
          ::cLine += SPACE(6)+'<'+cTag+'>'
       ELSEIF nTipo = 3
          ::cLine += SPACE(9)+'<'+cTag+'>'
       ELSEIF nTipo = 4
          ::cLine += SPACE(12)+'<'+cTag+'>'
       ELSEIF nTipo = 5
          ::cLine += SPACE(15)+'<'+cTag+'>'
       ELSEIF nTipo = 6
          ::cLine += SPACE(18)+'<'+cTag+'>'
       ELSEIF nTipo = 7
          ::cLine += SPACE(21)+'<'+cTag+'>'
       ELSEIF nTipo = 8
          ::cLine += SPACE(24)+'<'+cTag+'>'
       ELSE
          ::cLine += SPACE(21)+'<'+cTag+'>'
       ENDIF 

   ELSEIF EMPTY(cValor)

       IF nTipo = 0
          ::cLine += '<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 1
          ::cLine += SPACE(3) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 2
          ::cLine += SPACE(6) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 3
          ::cLine += SPACE(9) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 4
          ::cLine += SPACE(12) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 5
          ::cLine += SPACE(15) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 6
          ::cLine += SPACE(18) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 7
          ::cLine += SPACE(21) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 8
          ::cLine += SPACE(24) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSE
          ::cLine += SPACE(21) +'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ENDIF 
       
   ELSE

       IF nTipo = 0
          ::cLine += '<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 1
          ::cLine += SPACE(3)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 2
          ::cLine += SPACE(6)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 3
          ::cLine += SPACE(9)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 4
          ::cLine += SPACE(12)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 5
          ::cLine += SPACE(15)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 6
          ::cLine += SPACE(18)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 7
          ::cLine += SPACE(21)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSEIF nTipo = 8
          ::cLine += SPACE(24)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ELSE 
          ::cLine += SPACE(21)+'<'+cTag+'>'+cValor+'</'+cTag+'>'
       ENDIF 

   ENDIF

   *::cLine := UPPER(::cLine)
   FWRITE(::nHandle,::cLine+CRLF)
   ::cLine := ""

   
RETURN Nil





*------------------------------------------------------------------------------*
* S-1000 – Informações do Empregador                                           *
* -----------------------------------------------------------------------------*
METHOD S1000() CLASS eSocial

LOCAL cCNPJ, cTIPOCNPJ,cNomeEmpresa
       SELECT EMPRESA
       IF !EMPTY(EMPRESA->CGC)
         cTIPOCNPJ:='1'
         cCNPJ    := EMPRESA->CGC
       ELSE
          cTIPOCNPJ:='2'
          cCNPJ    := EMPRESA->RECEI
       ENDIF
       cNomeEmpresa := ALLTRIM(EMPRESA->NOME)



::incluiTag(1,"evtInfoEmpregador")       //G - 1-1 - - Evento de informações do empregador
::incluiTag(2,"versao"," ")              //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")               //G - 1-1 - - Informações do evento
::incluiTag(3,"idEvento"," ")            //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento"," ")           //G - 1-1 - - Informações de Identificação do Evento
::incluiTag(3,"tpAmb","1")               //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi"," ")             //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento"," ")         //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","001")             //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(4,"ideEmpregador")           //G - 1-1 - - Informações de identificação do empregador
::incluiTag(5,"tpInscricao",cTIPOCNPJ)        //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao",cCNPJ)         //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"/ideEmpregador")

::incluiTag(3,"infoEmpregador")          //CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e

::incluiTag(4,"inclusao")                //G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"idePeriodo")              //G - 1-1 - - Período de validade das informações incluídas
::incluiTag(6,"dtIniValidade"," ")       //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade"," ")       //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/idePeriodo")

::incluiTag(5,"infoCadastro")            //G - 1-1 - - Informações do empregador
::incluiTag(6,"nomeRazao",cNomeEmpresa)           //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(6,"classTrib"," ")           //E N 1-1 002 - Preencher com o código correspondente à classificação
::incluiTag(6,"natJuridica"," ")         //E N 1-1 004 - Preencher com o código da Natureza Jurídica do Contribuinte,
::incluiTag(6,"cnaePreponderante"," ")   //E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"indCooperativa"," ")      //E N 1-1 001 - Indicativo de Cooperativa:
::incluiTag(6,"indConstrutora"," ")      //E N 1-1 001 - Indicativo de Construtora:
  
::incluiTag(6,"aliqGilrat")              //G - 0-1 - - Informações de apuração da alíquota GILRAT
::incluiTag(7,"aliqRat"," ")             //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(7,"fap"," ")                 //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(7,"aliqRatAjustada"," ")     //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(7,"procAdmJudRat")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo

::incluiTag(8,"tpProcesso"," ")          // E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso"," ")          // E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudRat")
::incluiTag(7,"procAdmJudFap")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso"," ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso"," ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudFap")
::incluiTag(6,"/aliqGilrat")

::incluiTag(6,"dadosIsencao")            //G - 0-1 - - Informações Complementares - Empresas Isentas - Dados da
::incluiTag(7,"siglaMin"," ")            //E C 1-1 008 - Identificação do Ministério/Lei que concedeu o Certificado:
::incluiTag(7,"nrCertificado"," ")       //E C 1-1 040 - Número do Certificado de Entidade Beneficente de Assistência
::incluiTag(7,"dtEmissaoCertificado"," ")//E D 1-1 010 - Data de Emissão do Certificado/publicação da Lei
::incluiTag(7,"dtVenctoCertificado"," ") //E D 1-1 010 - Data de Vencimento do Certificado
::incluiTag(7,"nrProtRenovacao"," ")     //E C 0-1 040 - Número do protocolo de pedido de renovação
::incluiTag(7,"dtProtRenovacao"," ")     //E D 0-1 010 - Data do protocolo de renovação
::incluiTag(7,"dtDou"," ")               //E D 0-1 010 - Preencher com a data de publicação no Diário Oficial da União
::incluiTag(7,"pagDou"," ")              //E N 0-1 005 - Preencher com o número da página no DOU referente à
::incluiTag(6,"/dadosIsencao")

::incluiTag(6,"contato")                 //G - 1-1 - - Informações de contato
::incluiTag(7,"nomeContato"," ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"cpfContato"," ")          //E N 1-1 011 - Preencher com o CPF do contato
::incluiTag(7,"foneFixo"," ")            //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"foneCelular"," ")         //E C 0-1 012 - Telefone celular
::incluiTag(7,"fax"," ")                 //E C 0-1 011 - Número do Fax, com DDD
::incluiTag(7,"email"," ")               //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/contato")

::incluiTag(6,"infBancarias")            //G - 0-1 - - Informações Bancárias
::incluiTag(7,"banco","237")               //E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
::incluiTag(7,"agencia","0420")             //E C 0-1 015 - Preencher com o código da agência, no caso de depósito
::incluiTag(7,"tpContaBancaria","1")     //E N 1-1 001 - Tipo de Conta:
::incluiTag(7,"nrContaBancaria","145237")     //E C 1-1 020 - Número da Conta Bancária
::incluiTag(6,"/infBancarias")

::incluiTag(6,"infoFGTS")                //G - 1-1 - - Informações exclusivas para o FGTS
::incluiTag(7,"utilizaFinanciamento"," ")//E C 1-1 001 - Utilização de recursos do FGTS em financiamentos:
::incluiTag(7,"debitoAutomatico"," ")    //E C 1-1 001 - Débito automático do FGTS:
::incluiTag(7,"avisosSMS"," ")           //E C 1-1 001 - Adesão aos serviços de SMS:
::incluiTag(7,"agendaRecolhimento"," ")  //E C 1-1 001 - Agendamento de recolhimento do FGTS:
::incluiTag(6,"/infoFGTS")

::incluiTag(6,"softwareHouse")                 //G - 0-1 - - Informações da empresa de Software
::incluiTag(7,"cnpjSoftwareHouse","SOFTLOGIC INFORMATICA LTDA")   //E N 1-1 014 - CNPJ da Software House
::incluiTag(7,"nomeRazao","JOSE PAULO CESARIO")//E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(7,"nomeContato","CESARIO")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"telefone","55741100")           //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"codMunicipio","3100000")        //E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"uf","SP")                       //E C 0-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(7,"email","jair@softlogic.com.br") //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/softwareHouse")

::incluiTag(5,"/infoCadastro")
::incluiTag(4,"/inclusao")

::incluiTag(4,"alteracao")               //G - 0-1 - - Alteração das informações
::incluiTag(5,"idePeriodo")              //G - 1-1 - - Período de validade das informações alteradas
::incluiTag(6,"dtIniValidade"," ")       //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade"," ")       //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/idePeriodo")
  			 
::incluiTag(5,"infoCadastro")            //G - 1-1 - - Informações do empregador
::incluiTag(6,"nomeRazao"," ")           //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(6,"classTrib"," ")           //E N 1-1 002 - Preencher com o código correspondente à classificação
::incluiTag(6,"natJuridica"," ")         //E N 1-1 004 - Preencher com o código da Natureza Jurídica do Contribuinte,
::incluiTag(6,"cnaePreponderante"," ")   //E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"indCooperativa"," ")      //E N 1-1 001 - Indicativo de Cooperativa:
::incluiTag(6,"indConstrutora"," ")      //E N 1-1 001 - Indicativo de Construtora:
::incluiTag(6,"aliqGilrat")              //G - 0-1 - - Informações de apuração da alíquota GILRAT
::incluiTag(7,"aliqRat"," ")             //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(7,"fap"," ")                 //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(7,"aliqRatAjustada"," ")     //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(7,"procAdmJudRat")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso"," ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso"," ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudRat")
::incluiTag(7,"procAdmJudFap")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso"," ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso"," ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudFap")
::incluiTag(6,"/aliqGilrat")

::incluiTag(6,"dadosIsencao")            //G - 0-1 - - Informações Complementares - Empresas Isentas - Dados da
::incluiTag(7,"siglaMin"," ")            //E C 1-1 008 - Identificação do Ministério/Lei que concedeu o Certificado:
::incluiTag(7,"nrCertificado"," ")       //E C 1-1 040 - Número do Certificado de Entidade Beneficente de Assistência
::incluiTag(7,"dtEmissaoCertificado"," ")//E D 1-1 010 - Data de Emissão do Certificado/publicação da Lei
::incluiTag(7,"dtVenctoCertificado"," ") //E D 1-1 010 - Data de Vencimento do Certificado
::incluiTag(7,"nrProtRenovacao"," ")     //E C 0-1 040 - Número do protocolo de pedido de renovação
::incluiTag(7,"dtProtRenovacao"," ")     //E D 0-1 010 - Data do protocolo de renovação
::incluiTag(7,"dtDou"," ")               //E D 0-1 010 - Preencher com a data de publicação no Diário Oficial da União
::incluiTag(7,"pagDou"," ")              //E N 0-1 005 - Preencher com o número da página no DOU referente à
::incluiTag(6,"/dadosIsencao")
::incluiTag(6,"contato")                 //G - 1-1 - - Informações de contato
::incluiTag(7,"nomeContato"," ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"cpfContato"," ")          //E N 1-1 011 - Preencher com o CPF do contato
::incluiTag(7,"foneFixo"," ")            //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"foneCelular"," ")         //E C 0-1 012 - Telefone celular
::incluiTag(7,"fax"," ")                 //E C 0-1 011 - Número do Fax, com DDD
::incluiTag(7,"email"," ")               //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/contato")
::incluiTag(6,"infBancarias")            //G - 0-1 - - Informações Bancárias
::incluiTag(7,"banco"," ")               //E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
::incluiTag(7,"agencia"," ")             //E C 0-1 015 - Preencher com o código da agência, no caso de depósito
::incluiTag(7,"tpContaBancaria"," ")     //E N 1-1 001 - Tipo de Conta:
::incluiTag(7,"nrContaBancaria"," ")     //E C 1-1 020 - Número da Conta Bancária
::incluiTag(6,"/infBancarias")
::incluiTag(6,"infoFGTS")                //G - 1-1 - - Informações exclusivas para o FGTS
::incluiTag(7,"utilizaFinanciamento"," ")//E C 1-1 001 - Utilização de recursos do FGTS em financiamentos:
::incluiTag(7,"debitoAutomatico"," ")    //E C 1-1 001 - Débito automático do FGTS:
::incluiTag(7,"avisosSMS"," ")           //E C 1-1 001 - Adesão aos serviços de SMS:
::incluiTag(7,"agendaRecolhimento"," ")  //E C 1-1 001 - Agendamento de recolhimento do FGTS:
::incluiTag(6,"/infoFGTS")
::incluiTag(6,"softwareHouse")           //G - 0-1 - - Informações da empresa de Software
::incluiTag(7,"cnpjSoftwareHouse"," ")   //E N 1-1 014 - CNPJ da Software House
::incluiTag(7,"nomeRazao"," ")           //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(7,"nomeContato"," ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"telefone"," ")            //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"codMunicipio"," ")        //E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"uf"," ")                  //E C 0-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(7,"email"," ")               //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/softwareHouse")
::incluiTag(5,"/infoCadastro")
 
::incluiTag(5,"novaValidade>")           //G - 1-1 - - Informação preenchida exclusivamente em caso de alteração do
::incluiTag(5,"dtIniValidade"," ")       //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade"," ")       //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
 		  

::incluiTag(4,"exclusao")               // G - 0-1 - - Exclusão das informações
::incluiTag(5,"idePeriodo")             // G - 1-1 - - Informação destinada a localizar corretamente as informações já
::incluiTag(6,"dtIniValidade"," ")       // E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade"," ")       // E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/idePeriodo")

::incluiTag(4,"/exclusao")

::incluiTag(3,"/infoEmpregador")
::incluiTag(2,"/infEvento")
   

::incluiTag(1,"/evtInfoEmpregador")


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
* S-1010 - Tabela de Rubricas
* -----------------------------------------------------------------------------*
METHOD S1010() CLASS eSocial


::incluiTag(0,"evtTabRubrica ")         // 01 G - 1-1 - - Evento destinada a incluir, alterar ou excluir informações da
  ::incluiTag(1,"versao"," ")           // 02 A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
  ::incluiTag(2,"infEvento")            // 03 G - 1-1 - - Informações do evento
    ::incluiTag(3,"idEvento"," ")       // 04 A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
    ::incluiTag(3,"ideEvento")        // 05 G - 1-1 - - Informações de Identificação do Evento
      ::incluiTag(4,"tpAmb"," ")          // 06 E N 1-1 001 - Identificação do ambiente:
      ::incluiTag(4,"procEmi"," ")        // 07 E N 1-1 001 - Processo de emissão do evento:
      ::incluiTag(4,"indSegmento"," ")    // 08 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
      ::incluiTag(4,"verProc"," ")        // 09 E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
      ::incluiTag(4,"ideEmpregador")        // 10 G - 1-1 - - Informações de identificação do empregador
         ::incluiTag(5,"tpInscricao"," ")   // 11 E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
         ::incluiTag(5,"nrInscricao"," ")   // 12 E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
      ::incluiTag(4,"/ideEmpregador")

      ::incluiTag(3,"infoRubrica")         // 13 CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e
         ::incluiTag(4,"inclusao")            // 14 G - 0-1 - - Inclusão de novas informações
            ::incluiTag(5,"ideRubrica")          // 15 G - 1-1 - - Informações de identificação da rubrica e validade das
              ::incluiTag(6,"codRubrica"," ")   // 16 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
              ::incluiTag(6,"dtIniValidade"," ")// 17 E D 1-1 010 - Preencher com a data de início da validade das informações
              ::incluiTag(6,"dtFimValidade"," ")// 18 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
            ::incluiTag(5,"/ideRubrica")
			::incluiTag(5,"dadosRubrica")        // 19 G - 1-1 - - Detalhamento das informações da rubrica que está sendo
              ::incluiTag(6,"descRubrica"," ")   // 20 E C 1-1 100 - informar a descrição (nome) da rubrica no sistema de folha de
              ::incluiTag(6,"natRubrica"," ")    // 21 E N 1-1 004 - Informar o código de classificação da rubrica de acordo com a
              ::incluiTag(6,"indProvDesc"," ")   // 22 E C 1-1 001 - Indicativo do tipo de rubrica:
              ::incluiTag(6,"codIncidCP"," ")    // 23 E N 1-1 002 - Código de incidência tributária da rubrica para a Previdência
              ::incluiTag(6,"codIncidIRRF"," ")  // 24 E N 1-1 002 - Código de incidência tributária da rubrica para o IRRF:
              ::incluiTag(6,"codIncidFGTS"," ")  // 25 E N 1-1 002 - Código de incidência tributária da rubrica para o FGTS:
              ::incluiTag(6,"codIncidSIND"," ")  // 26 E N 1-1 002 - Código de incidência tributária da rubrica para a Contribuição
              ::incluiTag(6,"repDSR"," ")        // 27 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do Descanso Semanal
              ::incluiTag(6,"repDecTerceiro"," ")// 28 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do 13º Salário
              ::incluiTag(6,"repFerias"," ")     // 29 E C 1-1 001 - Indicar se a rubrica repercute no cálculo das Férias.
              ::incluiTag(6,"repRescisao"," ")   // 30 E C 1-1 001 - Indicar se a rubrica repercute no cálculo da Rescisão.
              ::incluiTag(6,"fatorRubrica"," ")  // 31 E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necessário.
              
			  ::incluiTag(6,"ideProcessoCP")    // 32 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                 ::incluiTag(7,"tpProcesso"," ")    // 33 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                 ::incluiTag(7,"nrProcesso"," ")    // 34 E C 1-1 020 - Informar o número do processo administrativo/judicial.
                 ::incluiTag(7,"extDecisao"," ")    // 35 E N 1-1 001 - Extensão da Decisão/Sentença:
              ::incluiTag(6,"/ideProcessoCP")
			  
			  ::incluiTag(6,"ideProcessoIRRF")        // 36 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                 ::incluiTag(7,"tpProcesso"," ")      // 37 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                 ::incluiTag(7,"nrProcesso"," ")      // 38 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoIRRF")
			  
			  ::incluiTag(6,"ideProcessoFGTS")        // 39 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")       // 40 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")       // 41 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoFGTS")
			  
			  ::incluiTag(6,"ideProcessoSIND")        // 42 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")       // 43 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")       // 44 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoSIND")
 
          ::incluiTag(5,"/dadosRubrica")
          ::incluiTag(4,"/inclusao")
		
		
		 ::incluiTag(4,"alteracao")           // 45 G - 0-1 - - Alteração de informações já existentes
           ::incluiTag(5,"ideRubrica")            // 46 G - 1-1 - - Grupo de informações de identificação da rubrica, apresentando
              ::incluiTag(6,"codRubrica"," ")            // 47 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
              ::incluiTag(6,"dtIniValidade"," ")         // 48 E D 1-1 010 - Preencher com a data de início da validade das informações
              ::incluiTag(6,"dtFimValidade"," ")         // 49 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
              
			  ::incluiTag(6,"dadosRubrica")          // 50 G - 1-1 - - Informações da rubrica
                ::incluiTag(7,"descRubrica"," ")      // 51 E C 1-1 100 - informar a descrição (nome) da rubrica no sistema de folha de
                ::incluiTag(7,"natRubrica"," ")       // 52 E N 1-1 004 - Informar o código de classificação da rubrica de acordo com a
                ::incluiTag(7,"indProvDesc"," ")      // 53 E C 1-1 001 - Indicativo do tipo de rubrica:
                ::incluiTag(7,"codIncidCP"," ")       // 54 E N 1-1 002 - Código de incidência tributária da rubrica para a Previdência
                ::incluiTag(7,"codIncidIRRF"," ")     // 55 E N 1-1 002 - Código de incidência tributária da rubrica para o IRRF:
                ::incluiTag(7,"codIncidFGTS"," ")     // 56 E N 1-1 002 - Código de incidência tributária da rubrica para o FGTS:
                ::incluiTag(7,"codIncidSIND"," ")     // 57 E N 1-1 002 - Código de incidência tributária da rubrica para a Contribuição
                ::incluiTag(7,"repDSR"," ")           // 58 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do Descanso Semanal
                ::incluiTag(7,"repDecTerceiro"," ")   // 59 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do 13º Salário
                ::incluiTag(7,"repFerias"," ")        // 60 E C 1-1 001 - Indicar se a rubrica repercute no cálculo das Férias.
                ::incluiTag(7,"repRescisao"," ")      // 61 E C 1-1 001 - Indicar se a rubrica repercute no cálculo da Rescisão.
                ::incluiTag(7,"fatorRubrica"," ")     // 62 E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necessário.
              ::incluiTag(6,"/dadosRubrica")
			  
			  ::incluiTag(6,"ideProcessoCP")    // 63 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")     // 64 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")     // 65 E C 1-1 020 - Informar o número do processo administrativo/judicial.
                ::incluiTag(7,"extDecisao"," ")     // 66 E N 1-1 001 - Extensão da Decisão/Sentença:
              ::incluiTag(6,"/ideProcessoCP")
			  
			  ::incluiTag(6,"ideProcessoIRRF")      // 67 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")     // 68 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")     // 69 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoIRRF")
			  
			  ::incluiTag(6,"ideProcessoFGTS")      // 70 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")     // 71 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")     // 72 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoFGTS")
			  
			  ::incluiTag(6,"ideProcessoSIND")      // 73 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
                ::incluiTag(7,"tpProcesso"," ")     // 74 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
                ::incluiTag(7,"nrProcesso"," ")     // 75 E C 1-1 020 - Informar o número do processo administrativo/judicial.
              ::incluiTag(6,"/ideProcessoSIND")
              
			  ::incluiTag(6,"novaValidade")         // 76 G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
                ::incluiTag(7,"dtIniValidade"," ")       // 77 E D 1-1 010 - Preencher com a data de início da validade das informações
                ::incluiTag(7,"dtFimValidade"," ")       // 78 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
              ::incluiTag(6,"/novaValidade")
			::incluiTag(5,"/ideRubrica")
			::incluiTag(4,"/alteracao")

            ::incluiTag(4,"exclusao")            // 79 G - 0-1 - - Exclusão de informações
              ::incluiTag(5,"ideRubrica")              // 80 G - 1-1 - - Grupo de informações que identifica a rubrica que será
                ::incluiTag(6,"codRubrica"," ")            // 81 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
                ::incluiTag(6,"dtIniValidade"," ")         // 82 E D 1-1 010 - Preencher com a data de início da validade das informações
                ::incluiTag(6,"dtFimValidade"," ")         // 83 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
              ::incluiTag(5,"/ideRubrica")
            ::incluiTag(4,"/exclusao")

          ::incluiTag(3,"/infoRubrica")
		::incluiTag(3,"/ideEvento")     
     ::incluiTag(2,"/infEvento") 
::incluiTag(0,"/evtTabRubrica ")

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S-1020 - Tabela de Lotações
* -----------------------------------------------------------------------------*
METHOD S1020() CLASS eSocial

::incluiTag(1,"evtTabLotacao")                          //1  G - 1-1 - - Definição do Evento de tabela de lotações.
* 2 versao evtTabLotacao                   //2  A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")               //3  G - 1-1 - - Informações do evento
::incluiTag(4,"idEvento"," ")                     //4  A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")                   //5  G - 1-1 - - Informações de Identificação do Evento
::incluiTag(4,"tpAmb"," ")                      //6  E N 1-1 001 - Identificação do ambiente:
::incluiTag(4,"procEmi"," ")                     //7  E N 1-1 001 - Processo de emissão do evento:
::incluiTag(4,"indSegmento"," ")                 //8  E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(4,"verProc"," ")                      //9  E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")

::incluiTag(3,"ideEmpregador")              //10 G - 1-1 - - Informações de identificação do empregador
::incluiTag(4,"tpInscricao"," ")             //11 E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao"," ")             //12 E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")

::incluiTag(3,"infoLotacao")                  //13 CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e
::incluiTag(4,"inclusao")                  //14 G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"ideLotacao")                   //15 G - 1-1 - - Informações de identificação da lotação e validade das
::incluiTag(6,"dadosLotacao"," ")         //16 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(6,"dadosLotacao"," ")         //17 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dadosLotacao"," ")         //18 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")

::incluiTag(5,"dadosLotacao")             //19 G - 1-1 - - Detalhamento das informações da lotação que está sendo
::incluiTag(6,"enderecodescLotacao"," ")              //20 E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
::incluiTag(6,"enderecotpLotacao"," ")                //21 E N 1-1 002 - Preencher com o código correspondente ao tipo de lotação,
::incluiTag(6,"enderecotpInscEstab"," ")             //22 E N 0-1 001 - Tipo de inscrição do estabelecimento ao qual está vinculada a
::incluiTag(6,"endereconrInscEstab"," ")              //23 E N 0-1 014 - Preencher com o número de Inscrição do Estabelecimento

::incluiTag(6,"endereco")              //24 G - 0-1 - - Informação complementar contendo os dados do endereço da
::incluiTag(7,"enderecotpLogradouro"," ")                 //25 E C 1-1 010 - Tipo de Logradouro
::incluiTag(7,"enderecodescLogradouro"," ")               //26 E C 1-1 080 - Descrição do logradouro
::incluiTag(7,"endereconrLogradouro"," ")                 //27 E C 0-1 010 - Número do logradouro.
::incluiTag(7,"enderecocomplemento"," ")                  //28 E C 0-1 030 - Complemento do logradouro.
::incluiTag(7,"enderecobairro"," ")                       //29 E C 0-1 030 - Nome do bairro/distrito
::incluiTag(7,"enderecocep"," ")                         //30 E N 1-1 008 - Código de Endereçamento Postal
::incluiTag(7,"enderecocodMunicipio"," ")                //31 E N 1-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"enderecouf"," ")                          //32 E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(6,"/endereco")

::incluiTag(6,"fpasLotacao")               //33 G - 0-1 - - Registro preenchido exclusivamente para lotação com tipo de
::incluiTag(7,"infoEmprParcialfpas","")                      //34 E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(7,"infoEmprParcialcodTerceiros","")             //35 E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"/fpasLotacao")

::incluiTag(6,"infoEmprParcial")          //36 G - 0-1 - - Informação complementar que apresenta identificação do
::incluiTag(7,"infoEmprParcialtpInscContratante"," ")    //37 E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(7,"infoEmprParcialnrInscContratante"," ")    //38 E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(7,"infoEmprParcialtpInscProprietario"," ")    //39 E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(7,"infoEmprParcialnrInscProprietario"," ")    //40 E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(6,"/infoEmprParcial")
::incluiTag(5,"/dadosLotacao")
::incluiTag(4,"/inclusao")

::incluiTag(4,"alteracao")              //41 G - 0-1 - - Alteração de informações já existentes
::incluiTag(5,"ideLotacao")                  //42 G - 1-1 - - Grupo de informações de identificação da lotação, apresentando
::incluiTag(6,"ideLotacaocodLotacao","")               //43 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(6,"ideLotacaodtIniValidade"," ")              //44 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"ideLotacaodtFimValidade"," ")              //45 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")

::incluiTag(5,"dadosLotacao")               //46 G - 1-1 - - Informações da lotação
::incluiTag(6,"descLotacao"," ")              //47 E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
::incluiTag(6,"tpLotacao"," ")                //48 E N 1-1 002 - Preencher com o código correspondente ao tipo de lotação,
::incluiTag(6,"tpInscEstab"," ")             //49 E N 0-1 001 - Tipo de inscrição do estabelecimento ao qual está vinculada a
::incluiTag(6,"nrInscEstab"," ")             //50 E N 0-1 014 - Preencher com o número de Inscrição do Estabelecimento
::incluiTag(5,"/dadosLotacao")

::incluiTag(6,"endereco")               //51 G - 0-1 - - Informação complementar contendo os dados do endereço da
::incluiTag(7,"enderecotpLogradouro"," ")                //52 E C 1-1 010 - Tipo de Logradouro
::incluiTag(7,"enderecodescLogradouro"," ")               //53 E C 1-1 080 - Descrição do logradouro
::incluiTag(7,"endereconrLogradouro"," ")                 //54 E C 0-1 010 - Número do logradouro.
::incluiTag(7,"enderecocomplemento"," ")                 //55 E C 0-1 030 - Complemento do logradouro.
::incluiTag(7,"enderecobairro"," ")                       //56 E C 0-1 030 - Nome do bairro/distrito
::incluiTag(7,"enderecocep"," ")                          //57 E N 1-1 008 - Código de Endereçamento Postal
::incluiTag(7,"enderecocodMunicipio"," ")                 //58 E N 1-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"enderecouf"," ")                           //59 E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(6,"/endereco")

::incluiTag(6,"fpasLotacao")          //60 G - 0-1 - - Registro preenchido exclusivamente para lotação com tipo de
::incluiTag(7,"fpasLotacaofpas"," ")                     //61 E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(7,"fpasLotacaocodTerceiros"," ")              //62 E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"/fpasLotacao")

::incluiTag(6,"infoEmprParcial")         //63 G - 0-1 - - Informação complementar que apresenta identificação do
  ::incluiTag(7,"infoEmprParcialtpInscContratante"," ")    //64 E N 1-1 001 - Tipo de Inscrição do contratante
  ::incluiTag(7,"infoEmprParcialnrInscContratante"," ")    //65 E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
  ::incluiTag(7,"infoEmprParcialtpInscProprietario"," ")   //66 E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
  ::incluiTag(7,"infoEmprParcialnrInscProprietario"," ")   //67 E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(6,"/infoEmprParcial")

::incluiTag(5,"novaValidade")                    //68 G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
  ::incluiTag(6,"novaValidadedtIniValidade"," ") //69 E D 1-1 010 - Preencher com a data de início da validade das informações
  ::incluiTag(6,"novaValidadedtFimValidade"," ") //70 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")

::incluiTag(4,"exclusao")                  //71 G - 0-1 - - Exclusão de informações
::incluiTag(5,"ideLotacao")                //72 G - 1-1 - - Grupo de informações que identifica a lotação que será
  ::incluiTag(6,"ideLotacao"," ")          //73 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
  ::incluiTag(6,"ideLotacao"," ")          //74 E D 1-1 010 - Preencher com a data de início da validade das informações
  ::incluiTag(6,"ideLotacao"," ")          //75 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")
::incluiTag(4,"/exclusao") 
::incluiTag(3,"/infoLotacao")

::incluiTag(2,"/infEvento")

::incluiTag(1,"/evtTabLotacao")


RETURN Self
*------------------------------------------------------------------------------*

