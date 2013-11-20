*--------------------------------------------------------------------*
* Geracao dos arquivos eSocial                                       *
* Este progeto pode gerar 48 arquivos, atualmente estou invocando    *
* a classe para gerar apenas um arquivo, mas pode ser gerados individual   
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


function Main()
**  exemplo de utilizacao ***

cPasta := LEFT(hb_cmdargargv(),RAT(HB_OSpathseparator(),hb_cmdargargv())) 
IF RIGHT(cPasta,1) != HB_OSpathseparator()
   cPasta += HB_OSpathseparator()
ENDIF




*--- Geracao do arquivo ---*
oSocial:= eSocial()
oSocial:Empresa := " "
oSocial:DtVenc  := DATE()
oSocial:Open()
oSocial:Execute( )   //:add()



cPasta+=oSocial:NomeArq   // temporario para conferir se gerou o arquivo 
*--- Finaliza a geracao do arquivo ---*
oSocial:Close()   // Finaliza 

msgstop(cPasta,"Aviso")

return nil 

*------------------------------------------------------------------------------*
*  Geracao de arquivo E-SOCIAL                                                 *
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
   
   DATA versao             INIT "123"
   DATA cNpjEmp            INIT "99999999999999"
   

   DATA Empresa            INIT ""

   METHOD New() CONSTRUCTOR
   METHOD Execute( )
   METHOD OPEN()
   
   METHOD S1000() //Informacoes do empregador 
   METHOD S1010() //Tabela de rubricas 
   METHOD S1020() //Tabela de lotacoes 
   METHOD S1030() //Tabela de cargos 
   METHOD S1040() //Tabela de funcoes 
   METHOD S1050() //Tabela de Horários/Turnos de Trabalho
   METHOD S1060() //Tabela de Estabelecimentos
   METHOD S1070() //Tabela de Processos
   METHOD S1080() //Tabela de Operadores Portuários
   METHOD S1100() //eSocial Mensal - Abertura
   METHOD S1200() //eSocial Mensal - Remuneração
   METHOD S1310() //eSocial Mensal - Outras Informações - Serv. Tomados
   METHOD S1320() //eSocial Mensal - Outras Informações - Serv. Prestados
   METHOD S1330() //eSocial Mensal - Outras Informações - Serv. Tomados de Coop.
   METHOD S1340() //eSocial Mensal - Outras Informações - Serv. Prestados
   METHOD S1350() //eSocial Mensal - Outras Informações - Aquisição de Produção
   METHOD S1360() //eSocial Mensal - Outras Informações - Comercialização da Produção
   METHOD S1370() //eSocial Mensal - Outras Informações - Rec. Recebidos

   METHOD S1400() //eSocial Mensal - Bases de Cálculo, Retenção, Deduções e Contribuições
   METHOD S2100() //Evento Cadastramento Inicial do Vínculo
   METHOD S2200() //Evento Admissão
   METHOD S2220() //Alteração de Dados Cadastrais
   METHOD S2240() //Alteração Contratual
   METHOD S2260() //Comunicação de Acidente de Trabalho
   METHOD S2280() //Atestado de Saúde Ocupacional

   METHOD S2300() //Aviso de Férias
   METHOD S2320() //Afastamento Temporário
   METHOD S2325() //Alteração do Motivo do Afastamento
   METHOD S2330() //Retorno do Afastamento
   METHOD S2340() //Estabilidade - Início
   METHOD S2345() //Estabilidade - Término
   METHOD S2360() //Condição Diferenciada de Trabalho - Início
   METHOD S2365() //Condição Diferenciada de Trabalho - Término
   METHOD S2400() //Aviso Prévio
   METHOD S2405() //Cancelamento de Aviso Prévio
   METHOD S2420() //Atividades Desempenhadas
   METHOD S2440() //Comunicação Fato Relevante
   METHOD S2600() //Trabalhador Sem Vínculo de Emprego - Início
   METHOD S2620() //Trabalhador Sem Vínculo de Emprego - Alteração Contratual
   METHOD S2680() //Trabalhador Sem Vínculo de Emprego - Término
   METHOD S2800() //Desligamento
   METHOD S2820() //Reintegração
   METHOD S2900() //Exclusão de Eventos
   
   METHOD Add()

   METHOD Line()
   METHOD IncluiTag(nTipo,cTag,cValor)
   METHOD CLOSE()

ENDCLASS
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*
*
* -----------------------------------------------------------------------------*
METHOD Execute( ) CLASS eSocial


::add(Self)
//42 metodos 
::S1000() //Informacoes do empregador 
::S1010() //Tabela de rubricas 
::S1020() //Tabela de lotacoes 
::S1030() //Tabela de cargos 
::S1040() //Tabela de funcoes 
::S1050() //Tabela de Horários/Turnos de Trabalho
::S1060() //Tabela de Estabelecimentos
::S1070() //Tabela de Processos
::S1080() //Tabela de Operadores Portuários
::S1100() //eSocial Mensal - Abertura
::S1200() //eSocial Mensal - Remuneração
::S1310() //eSocial Mensal - Outras Informações - Serv. Tomados
::S1320() //eSocial Mensal - Outras Informações - Serv. Prestados
::S1330() //eSocial Mensal - Outras Informações - Serv. Tomados de Coop.
::S1340() //eSocial Mensal - Outras Informações - Serv. Prestados
::S1350() //eSocial Mensal - Outras Informações - Aquisição de Produção
::S1360() //eSocial Mensal - Outras Informações - Comercialização da Produção
::S1370() //eSocial Mensal - Outras Informações - Rec. Recebidos
::S1400() //eSocial Mensal - Bases de Cálculo, Retenção, Deduções e Contribuições
::S2100() //Evento Cadastramento Inicial do Vínculo
::S2200() //Evento Admissão
::S2220() //Alteração de Dados Cadastrais
::S2240() //Alteração Contratual
::S2260() //Comunicação de Acidente de Trabalho
::S2280() //Atestado de Saúde Ocupacional
::S2300() //Aviso de Férias
::S2320() //Afastamento Temporário
::S2325() //Alteração do Motivo do Afastamento
::S2330() //Retorno do Afastamento
::S2340() //Estabilidade - Início
::S2345() //Estabilidade - Término
::S2360() //Condição Diferenciada de Trabalho - Início
::S2365() //Condição Diferenciada de Trabalho - Término
::S2400() //Aviso Prévio
::S2405() //Cancelamento de Aviso Prévio
::S2420() //Atividades Desempenhadas
::S2440() //Comunicação Fato Relevante
::S2600() //Trabalhador Sem Vínculo de Emprego - Início
::S2620() //Trabalhador Sem Vínculo de Emprego - Alteração Contratual
::S2680() //Trabalhador Sem Vínculo de Emprego - Término
::S2800() //Desligamento
::S2820() //Reintegração
::S2900() //Exclusão de Eventos

RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
* S-1000 – Informações do Empregador                                           *
* -----------------------------------------------------------------------------*
METHOD S1000() CLASS eSocial

LOCAL cCNPJ, cTIPOCNPJ,cNomeEmpresa
 **      SELECT EMPRESA
 **      IF !EMPTY(EMPRESA->CGC)
 **        cTIPOCNPJ:='1'
 **        cCNPJ    := EMPRESA->CGC
 **      ELSE
 **         cTIPOCNPJ:='2'
 **         cCNPJ    := EMPRESA->RECEI
 **      ENDIF
 **      cNomeEmpresa := ALLTRIM(EMPRESA->NOME)



::incluiTag(1,"evtInfoEmpregador")       //G - 1-1 - - Evento de informações do empregador
::incluiTag(2,"versao",::versao)              //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")               //G - 1-1 - - Informações do evento
::incluiTag(3,"idEvento","x ")            //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento","x ")           //G - 1-1 - - Informações de Identificação do Evento
::incluiTag(3,"tpAmb","1")               //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","x ")             //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","x ")         //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","001")           //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(4,"ideEmpregador")           //G - 1-1 - - Informações de identificação do empregador
::incluiTag(5,"tpInscricao","x ")         //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao",::cNpjEmp )         //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"/ideEmpregador")
::incluiTag(3,"infoEmpregador")          //CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e
::incluiTag(4,"inclusao")                //G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"idePeriodo")              //G - 1-1 - - Período de validade das informações incluídas
::incluiTag(6,"dtIniValidade","x ")       //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ")       //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/idePeriodo")
::incluiTag(5,"infoCadastro")            //G - 1-1 - - Informações do empregador
::incluiTag(6,"nomeRazao","x ")           //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(6,"classTrib","x ")           //E N 1-1 002 - Preencher com o código correspondente à classificação
::incluiTag(6,"natJuridica","x ")         //E N 1-1 004 - Preencher com o código da Natureza Jurídica do Contribuinte,
::incluiTag(6,"cnaePreponderante","x ")   //E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"indCooperativa","x ")      //E N 1-1 001 - Indicativo de Cooperativa:
::incluiTag(6,"indConstrutora","x ")      //E N 1-1 001 - Indicativo de Construtora:
::incluiTag(6,"aliqGilrat")              //G - 0-1 - - Informações de apuração da alíquota GILRAT
::incluiTag(7,"aliqRat","x ")             //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(7,"fap","x ")                 //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(7,"aliqRatAjustada","x ")     //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(7,"procAdmJudRat")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso","x ")          // E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso","x ")          // E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudRat")
::incluiTag(7,"procAdmJudFap")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso","x ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso","x ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudFap")
::incluiTag(6,"/aliqGilrat")
::incluiTag(6,"dadosIsencao")            //G - 0-1 - - Informações Complementares - Empresas Isentas - Dados da
::incluiTag(7,"siglaMin","x ")            //E C 1-1 008 - Identificação do Ministério/Lei que concedeu o Certificado:
::incluiTag(7,"nrCertificado","x ")       //E C 1-1 040 - Número do Certificado de Entidade Beneficente de Assistência
::incluiTag(7,"dtEmissaoCertificado","x ")//E D 1-1 010 - Data de Emissão do Certificado/publicação da Lei
::incluiTag(7,"dtVenctoCertificado","x ") //E D 1-1 010 - Data de Vencimento do Certificado
::incluiTag(7,"nrProtRenovacao","x ")     //E C 0-1 040 - Número do protocolo de pedido de renovação
::incluiTag(7,"dtProtRenovacao","x ")     //E D 0-1 010 - Data do protocolo de renovação
::incluiTag(7,"dtDou","x ")               //E D 0-1 010 - Preencher com a data de publicação no Diário Oficial da União
::incluiTag(7,"pagDou","x ")              //E N 0-1 005 - Preencher com o número da página no DOU referente à
::incluiTag(6,"/dadosIsencao")
::incluiTag(6,"contato")                 //G - 1-1 - - Informações de contato
::incluiTag(7,"nomeContato","x ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"cpfContato","x ")          //E N 1-1 011 - Preencher com o CPF do contato
::incluiTag(7,"foneFixo","x ")            //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"foneCelular","x ")         //E C 0-1 012 - Telefone celular
::incluiTag(7,"fax","x ")                 //E C 0-1 011 - Número do Fax, com DDD
::incluiTag(7,"email","x ")               //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/contato")
::incluiTag(6,"infBancarias")            //G - 0-1 - - Informações Bancárias
::incluiTag(7,"banco","237")               //E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
::incluiTag(7,"agencia","0420")             //E C 0-1 015 - Preencher com o código da agência, no caso de depósito
::incluiTag(7,"tpContaBancaria","1")     //E N 1-1 001 - Tipo de Conta:
::incluiTag(7,"nrContaBancaria","145237")     //E C 1-1 020 - Número da Conta Bancária
::incluiTag(6,"/infBancarias")
::incluiTag(6,"infoFGTS")                //G - 1-1 - - Informações exclusivas para o FGTS
::incluiTag(7,"utilizaFinanciamento","x ")//E C 1-1 001 - Utilização de recursos do FGTS em financiamentos:
::incluiTag(7,"debitoAutomatico","x ")    //E C 1-1 001 - Débito automático do FGTS:
::incluiTag(7,"avisosSMS","x ")           //E C 1-1 001 - Adesão aos serviços de SMS:
::incluiTag(7,"agendaRecolhimento","x ")  //E C 1-1 001 - Agendamento de recolhimento do FGTS:
::incluiTag(6,"/infoFGTS")
::incluiTag(6,"softwareHouse")                 //G - 0-1 - - Informações da empresa de Software
::incluiTag(7,"cnpjSoftwareHouse"," ")   //E N 1-1 014 - CNPJ da Software House
::incluiTag(7,"nomeRazao"," ")//E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(7,"nomeContato"," ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"telefone"," ")           //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"codMunicipio"," ")        //E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"uf","SP")                       //E C 0-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(7,"email"," ") //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/softwareHouse")
::incluiTag(5,"/infoCadastro")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")               //G - 0-1 - - Alteração das informações
::incluiTag(5,"idePeriodo")              //G - 1-1 - - Período de validade das informações alteradas
::incluiTag(6,"dtIniValidade","x ")       //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ")       //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/idePeriodo")
::incluiTag(5,"infoCadastro")            //G - 1-1 - - Informações do empregador
::incluiTag(6,"nomeRazao","x ")           //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(6,"classTrib","x ")           //E N 1-1 002 - Preencher com o código correspondente à classificação
::incluiTag(6,"natJuridica","x ")         //E N 1-1 004 - Preencher com o código da Natureza Jurídica do Contribuinte,
::incluiTag(6,"cnaePreponderante","x ")   //E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"indCooperativa","x ")      //E N 1-1 001 - Indicativo de Cooperativa:
::incluiTag(6,"indConstrutora","x ")      //E N 1-1 001 - Indicativo de Construtora:
::incluiTag(6,"aliqGilrat")              //G - 0-1 - - Informações de apuração da alíquota GILRAT
::incluiTag(7,"aliqRat","x ")             //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(7,"fap","x ")                 //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(7,"aliqRatAjustada","x ")     //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(7,"procAdmJudRat")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso","x ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso","x ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudRat")
::incluiTag(7,"procAdmJudFap")           //G - 0-1 - - Registro que identifica, em caso de existência, o processo
::incluiTag(8,"tpProcesso","x ")          //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(8,"nrProcesso","x ")          //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"/procAdmJudFap")
::incluiTag(6,"/aliqGilrat")
::incluiTag(6,"dadosIsencao")            //G - 0-1 - - Informações Complementares - Empresas Isentas - Dados da
::incluiTag(7,"siglaMin","x ")            //E C 1-1 008 - Identificação do Ministério/Lei que concedeu o Certificado:
::incluiTag(7,"nrCertificado","x ")       //E C 1-1 040 - Número do Certificado de Entidade Beneficente de Assistência
::incluiTag(7,"dtEmissaoCertificado","x ")//E D 1-1 010 - Data de Emissão do Certificado/publicação da Lei
::incluiTag(7,"dtVenctoCertificado","x ") //E D 1-1 010 - Data de Vencimento do Certificado
::incluiTag(7,"nrProtRenovacao","x ")     //E C 0-1 040 - Número do protocolo de pedido de renovação
::incluiTag(7,"dtProtRenovacao","x ")     //E D 0-1 010 - Data do protocolo de renovação
::incluiTag(7,"dtDou","x ")               //E D 0-1 010 - Preencher com a data de publicação no Diário Oficial da União
::incluiTag(7,"pagDou","x ")              //E N 0-1 005 - Preencher com o número da página no DOU referente à
::incluiTag(6,"/dadosIsencao")
::incluiTag(6,"contato")                 //G - 1-1 - - Informações de contato
::incluiTag(7,"nomeContato","x ")         //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"cpfContato","x ")          //E N 1-1 011 - Preencher com o CPF do contato
::incluiTag(7,"foneFixo","x ")            //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"foneCelular","x ")         //E C 0-1 012 - Telefone celular
::incluiTag(7,"fax","x ")                 //E C 0-1 011 - Número do Fax, com DDD
::incluiTag(7,"email","x ")               //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/contato")
::incluiTag(6,"infBancarias")            //G - 0-1 - - Informações Bancárias
::incluiTag(7,"banco","x ")               //E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
::incluiTag(7,"agencia","x ")             //E C 0-1 015 - Preencher com o código da agência, no caso de depósito
::incluiTag(7,"tpContaBancaria","x ")     //E N 1-1 001 - Tipo de Conta:
::incluiTag(7,"nrContaBancaria","x ")     //E C 1-1 020 - Número da Conta Bancária
::incluiTag(6,"/infBancarias")
::incluiTag(6,"infoFGTS")                //G - 1-1 - - Informações exclusivas para o FGTS
::incluiTag(7,"utilizaFinanciamento","x ")//E C 1-1 001 - Utilização de recursos do FGTS em financiamentos:
::incluiTag(7,"debitoAutomatico","x ")    //E C 1-1 001 - Débito automático do FGTS:
::incluiTag(7,"avisosSMS","x ")           //E C 1-1 001 - Adesão aos serviços de SMS:
::incluiTag(7,"agendaRecolhimento","x ")  //E C 1-1 001 - Agendamento de recolhimento do FGTS:
::incluiTag(6,"/infoFGTS")
::incluiTag(6,"softwareHouse")          //G - 0-1 - - Informações da empresa de Software
::incluiTag(7,"cnpjSoftwareHouse","x ")  //E N 1-1 014 - CNPJ da Software House
::incluiTag(7,"nomeRazao","x ")          //E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
::incluiTag(7,"nomeContato","x ")        //E C 1-1 080 - Nome do contato na empresa
::incluiTag(7,"telefone","x ")           //E C 0-1 012 - Informar o número do telefone, com DDD.
::incluiTag(7,"codMunicipio","x ")       //E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"uf","x ")                 //E C 0-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(7,"email","x ")              //E C 0-1 060 - Endereço eletrônico
::incluiTag(6,"/softwareHouse")
::incluiTag(5,"/infoCadastro")
::incluiTag(5,"novaValidade>")          //G - 1-1 - - Informação preenchida exclusivamente em caso de alteração do
::incluiTag(5,"dtIniValidade","x ")      //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","x ")      //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")               // G - 0-1 - - Exclusão das informações
::incluiTag(5,"idePeriodo")             // G - 1-1 - - Informação destinada a localizar corretamente as informações já
::incluiTag(6,"dtIniValidade","x ")      // E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ")      // E D 0-1 010 - Preencher com a data de fim da validade das informações, se
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

::incluiTag(0,"evtTabRubrica ")   // 01 G - 1-1 - - Evento destinada a incluir, alterar ou excluir informações da
::incluiTag(1,"versao",::versao)       // 02 A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")        // 03 G - 1-1 - - Informações do evento
::incluiTag(3,"idEvento","x ")     // 04 A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")        // 05 G - 1-1 - - Informações de Identificação do Evento
::incluiTag(4,"tpAmb","x ")        // 06 E N 1-1 001 - Identificação do ambiente:
::incluiTag(4,"procEmi","x ")      // 07 E N 1-1 001 - Processo de emissão do evento:
::incluiTag(4,"indSegmento","x ")  // 08 E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(4,"verProc","x ")      // 09 E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(4,"ideEmpregador")    // 10 G - 1-1 - - Informações de identificação do empregador
::incluiTag(5,"tpInscricao","x ")  // 11 E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao",::cNpjEmp)  // 12 E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"/ideEmpregador")
::incluiTag(3,"infoRubrica")      // 13 CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e
::incluiTag(4,"inclusao")         // 14 G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"ideRubrica")       // 15 G - 1-1 - - Informações de identificação da rubrica e validade das
::incluiTag(6,"codRubrica","x ")   // 16 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(6,"dtIniValidade","x ")// 17 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ")// 18 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideRubrica")
::incluiTag(5,"dadosRubrica")     // 19 G - 1-1 - - Detalhamento das informações da rubrica que está sendo
::incluiTag(6,"descRubrica","x ")  // 20 E C 1-1 100 - informar a descrição (nome) da rubrica no sistema de folha de
::incluiTag(6,"natRubrica","x ")   // 21 E N 1-1 004 - Informar o código de classificação da rubrica de acordo com a
::incluiTag(6,"indProvDesc","x ")  // 22 E C 1-1 001 - Indicativo do tipo de rubrica:
::incluiTag(6,"codIncidCP","x ")   // 23 E N 1-1 002 - Código de incidência tributária da rubrica para a Previdência
::incluiTag(6,"codIncidIRRF","x ") // 24 E N 1-1 002 - Código de incidência tributária da rubrica para o IRRF:
::incluiTag(6,"codIncidFGTS","x ") // 25 E N 1-1 002 - Código de incidência tributária da rubrica para o FGTS:
::incluiTag(6,"codIncidSIND","x ") // 26 E N 1-1 002 - Código de incidência tributária da rubrica para a Contribuição
::incluiTag(6,"repDSR","x ")       // 27 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do Descanso Semanal
::incluiTag(6,"repDecTerceiro","x ")// 28 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do 13º Salário
::incluiTag(6,"repFerias","x ")     // 29 E C 1-1 001 - Indicar se a rubrica repercute no cálculo das Férias.
::incluiTag(6,"repRescisao","x ")   // 30 E C 1-1 001 - Indicar se a rubrica repercute no cálculo da Rescisão.
::incluiTag(6,"fatorRubrica","x ")  // 31 E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necessário.
::incluiTag(6,"ideProcessoCP")     // 32 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 33 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 34 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"extDecisao","x ")    // 35 E N 1-1 001 - Extensão da Decisão/Sentença:
::incluiTag(6,"/ideProcessoCP")
::incluiTag(6,"ideProcessoIRRF")   // 36 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 37 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 38 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoIRRF")
::incluiTag(6,"ideProcessoFGTS")   // 39 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 40 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 41 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoFGTS")
::incluiTag(6,"ideProcessoSIND")   // 42 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 43 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 44 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoSIND")
::incluiTag(5,"/dadosRubrica")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")         // 45 G - 0-1 - - Alteração de informações já existentes
::incluiTag(5,"ideRubrica")        // 46 G - 1-1 - - Grupo de informações de identificação da rubrica, apresentando
::incluiTag(6,"codRubrica","x ")    // 47 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(6,"dtIniValidade","x ") // 48 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ") // 49 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(6,"dadosRubrica")      // 50 G - 1-1 - - Informações da rubrica
::incluiTag(7,"descRubrica","x ")   // 51 E C 1-1 100 - informar a descrição (nome) da rubrica no sistema de folha de
::incluiTag(7,"natRubrica","x ")    // 52 E N 1-1 004 - Informar o código de classificação da rubrica de acordo com a
::incluiTag(7,"indProvDesc","x ")   // 53 E C 1-1 001 - Indicativo do tipo de rubrica:
::incluiTag(7,"codIncidCP","x ")    // 54 E N 1-1 002 - Código de incidência tributária da rubrica para a Previdência
::incluiTag(7,"codIncidIRRF","x ")  // 55 E N 1-1 002 - Código de incidência tributária da rubrica para o IRRF:
::incluiTag(7,"codIncidFGTS","x ")  // 56 E N 1-1 002 - Código de incidência tributária da rubrica para o FGTS:
::incluiTag(7,"codIncidSIND","x ")  // 57 E N 1-1 002 - Código de incidência tributária da rubrica para a Contribuição
::incluiTag(7,"repDSR","x ")        // 58 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do Descanso Semanal
::incluiTag(7,"repDecTerceiro","x ")// 59 E C 1-1 001 - Indicar se a rubrica repercute no cálculo do 13º Salário
::incluiTag(7,"repFerias","x ")     // 60 E C 1-1 001 - Indicar se a rubrica repercute no cálculo das Férias.
::incluiTag(7,"repRescisao","x ")   // 61 E C 1-1 001 - Indicar se a rubrica repercute no cálculo da Rescisão.
::incluiTag(7,"fatorRubrica","x ")  // 62 E N 0-1 005 2 Informar o fator, percentual, etc, da rubrica, quando necessário.
::incluiTag(6,"/dadosRubrica")
::incluiTag(6,"ideProcessoCP")     // 63 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 64 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 65 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(7,"extDecisao","x ")    // 66 E N 1-1 001 - Extensão da Decisão/Sentença:
::incluiTag(6,"/ideProcessoCP")
::incluiTag(6,"ideProcessoIRRF")   // 67 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 68 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 69 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoIRRF")
::incluiTag(6,"ideProcessoFGTS")   // 70 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 71 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 72 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoFGTS")
::incluiTag(6,"ideProcessoSIND")   // 73 G - 0-1 - - Caso a empresa possua processo judicial com decisão/sentença
::incluiTag(7,"tpProcesso","x ")    // 74 E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(7,"nrProcesso","x ")    // 75 E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(6,"/ideProcessoSIND")
::incluiTag(6,"novaValidade")      // 76 G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
::incluiTag(7,"dtIniValidade","x ") // 77 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(7,"dtFimValidade","x ") // 78 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(6,"/novaValidade")
::incluiTag(5,"/ideRubrica")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")          // 79 G - 0-1 - - Exclusão de informações
::incluiTag(5,"ideRubrica")        // 80 G - 1-1 - - Grupo de informações que identifica a rubrica que será
::incluiTag(6,"codRubrica","x ")    // 81 E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(6,"dtIniValidade","x ") // 82 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dtFimValidade","x ") // 83 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
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

::incluiTag(1,"evtTabLotacao")       //1  G - 1-1 - - Definição do Evento de tabela de lotações.
::incluiTag(2,"infEvento")           //3  G - 1-1 - - Informações do evento
::incluiTag(4,"idEvento","x ")        //4  A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")           //5  G - 1-1 - - Informações de Identificação do Evento
::incluiTag(4,"tpAmb","x ")           //6  E N 1-1 001 - Identificação do ambiente:
::incluiTag(4,"procEmi","x ")         //7  E N 1-1 001 - Processo de emissão do evento:
::incluiTag(4,"indSegmento","x ")     //8  E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(4,"verProc","x ")         //9  E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")       //10 G - 1-1 - - Informações de identificação do empregador
::incluiTag(4,"tpInscricao","x ")     //11 E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao",::cNpjEmp)     //12 E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoLotacao")                  //13 CG - 1-1 - - Identificação da operação (inclusão, alteração ou exclusão) e
::incluiTag(4,"inclusao")                  //14 G - 0-1 - - Inclusão de novas informações
::incluiTag(5,"ideLotacao")                   //15 G - 1-1 - - Informações de identificação da lotação e validade das
::incluiTag(6,"dadosLotacao","x ")         //16 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(6,"dadosLotacao","x ")         //17 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"dadosLotacao","x ")         //18 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")
::incluiTag(5,"dadosLotacao")             //19 G - 1-1 - - Detalhamento das informações da lotação que está sendo
::incluiTag(6,"enderecodescLotacao","x ")              //20 E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
::incluiTag(6,"enderecotpLotacao","x ")                //21 E N 1-1 002 - Preencher com o código correspondente ao tipo de lotação,
::incluiTag(6,"enderecotpInscEstab","x ")             //22 E N 0-1 001 - Tipo de inscrição do estabelecimento ao qual está vinculada a
::incluiTag(6,"endereconrInscEstab","x ")              //23 E N 0-1 014 - Preencher com o número de Inscrição do Estabelecimento
::incluiTag(6,"endereco")              //24 G - 0-1 - - Informação complementar contendo os dados do endereço da
::incluiTag(7,"enderecotpLogradouro","x ")                 //25 E C 1-1 010 - Tipo de Logradouro
::incluiTag(7,"enderecodescLogradouro","x ")               //26 E C 1-1 080 - Descrição do logradouro
::incluiTag(7,"endereconrLogradouro","x ")                 //27 E C 0-1 010 - Número do logradouro.
::incluiTag(7,"enderecocomplemento","x ")                  //28 E C 0-1 030 - Complemento do logradouro.
::incluiTag(7,"enderecobairro","x ")                       //29 E C 0-1 030 - Nome do bairro/distrito
::incluiTag(7,"enderecocep","x ")                         //30 E N 1-1 008 - Código de Endereçamento Postal
::incluiTag(7,"enderecocodMunicipio","x ")                //31 E N 1-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"enderecouf","x ")                          //32 E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(6,"/endereco")
::incluiTag(6,"fpasLotacao")               //33 G - 0-1 - - Registro preenchido exclusivamente para lotação com tipo de
::incluiTag(7,"infoEmprParcialfpas","x")                      //34 E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(7,"infoEmprParcialcodTerceiros","x")             //35 E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"/fpasLotacao")
::incluiTag(6,"infoEmprParcial")          //36 G - 0-1 - - Informação complementar que apresenta identificação do
::incluiTag(7,"infoEmprParcialtpInscContratante","x ")    //37 E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(7,"infoEmprParcialnrInscContratante"," x")    //38 E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(7,"infoEmprParcialtpInscProprietario","x ")    //39 E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(7,"infoEmprParcialnrInscProprietario","x ")    //40 E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(6,"/infoEmprParcial")
::incluiTag(5,"/dadosLotacao")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")              //41 G - 0-1 - - Alteração de informações já existentes
::incluiTag(5,"ideLotacao")                  //42 G - 1-1 - - Grupo de informações de identificação da lotação, apresentando
::incluiTag(6,"ideLotacaocodLotacao","x")               //43 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(6,"ideLotacaodtIniValidade","x ")              //44 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"ideLotacaodtFimValidade","x ")              //45 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")
::incluiTag(5,"dadosLotacao")               //46 G - 1-1 - - Informações da lotação
::incluiTag(6,"descLotacao","x ")              //47 E C 1-1 100 - Para {tpLotacao} igual a [01], informar o nome do
::incluiTag(6,"tpLotacao","x ")                //48 E N 1-1 002 - Preencher com o código correspondente ao tipo de lotação,
::incluiTag(6,"tpInscEstab","x ")             //49 E N 0-1 001 - Tipo de inscrição do estabelecimento ao qual está vinculada a
::incluiTag(6,"nrInscEstab","x ")             //50 E N 0-1 014 - Preencher com o número de Inscrição do Estabelecimento
::incluiTag(5,"/dadosLotacao")
::incluiTag(6,"endereco")               //51 G - 0-1 - - Informação complementar contendo os dados do endereço da
::incluiTag(7,"enderecotpLogradouro","x ")                //52 E C 1-1 010 - Tipo de Logradouro
::incluiTag(7,"enderecodescLogradouro","x ")               //53 E C 1-1 080 - Descrição do logradouro
::incluiTag(7,"endereconrLogradouro","x ")                 //54 E C 0-1 010 - Número do logradouro.
::incluiTag(7,"enderecocomplemento","x ")                 //55 E C 0-1 030 - Complemento do logradouro.
::incluiTag(7,"enderecobairro","x ")                       //56 E C 0-1 030 - Nome do bairro/distrito
::incluiTag(7,"enderecocep","x ")                          //57 E N 1-1 008 - Código de Endereçamento Postal
::incluiTag(7,"enderecocodMunicipio","x ")                 //58 E N 1-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(7,"enderecouf","x ")                           //59 E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(6,"/endereco")
::incluiTag(6,"fpasLotacao")          //60 G - 0-1 - - Registro preenchido exclusivamente para lotação com tipo de
::incluiTag(7,"fpasLotacaofpas","x ")                     //61 E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(7,"fpasLotacaocodTerceiros","x ")              //62 E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"/fpasLotacao")
::incluiTag(6,"infoEmprParcial")         //63 G - 0-1 - - Informação complementar que apresenta identificação do
::incluiTag(7,"infoEmprParcialtpInscContratante","x ")    //64 E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(7,"infoEmprParcialnrInscContratante","x ")    //65 E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(7,"infoEmprParcialtpInscProprietario","x ")   //66 E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(7,"infoEmprParcialnrInscProprietario","x ")   //67 E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(6,"/infoEmprParcial")
::incluiTag(5,"novaValidade")                    //68 G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
::incluiTag(6,"novaValidadedtIniValidade","x") //69 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"novaValidadedtFimValidade","x") //70 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")                  //71 G - 0-1 - - Exclusão de informações
::incluiTag(5,"ideLotacao")                //72 G - 1-1 - - Grupo de informações que identifica a lotação que será
::incluiTag(6,"ideLotacao","ideLotacao ")  //73 E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(6,"ideLotacao","ideLotacao ")  //74 E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(6,"ideLotacao","ideLotacao ")  //75 E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideLotacao")
::incluiTag(4,"/exclusao") 
::incluiTag(3,"/infoLotacao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabLotacao")


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S-1030 - Tabela de Cargos
* -----------------------------------------------------------------------------*
METHOD S1030() CLASS eSocial

::incluiTag(1,"evtTabCargo")                          //G - 1-1 - - Evento utilizado para inclusão, alteração e exclusão de registros
::incluiTag(2,"versao",::versao)                      //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")                            //G - 1-1 - - Informações do evento
::incluiTag(2,"idEvento","infEvento")                 //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(4,"ideEvento")                            //G - 1-1 - - Informações de Identificação do Evento
::incluiTag(4,"tpAmb","ideEvento")                    //E N 1-1 001 - Identificação do ambiente:
::incluiTag(4,"procEmi","ideEvento")                  //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(4,"indSegmento","ideEvento")              //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(4,"verProc","ideEvento")                  //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")                        //G - 1-1 - - Informações de identificação do empregador
::incluiTag(4,"tpInscricao","ideEmpregador")          //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao",::cNpjEmp  )              //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
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
::incluiTag(5,"novaValidade")                      //G - 0-1 - - Informação preenchida exclusivamente em caso de alteração do
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
*::incluiTag(3,"/idEvento")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabCargo")


RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S-1040 - Tabela de Funcoes
* -----------------------------------------------------------------------------*
METHOD S1040() CLASS eSocial

::incluiTag(1,"evtTabFuncao")
::incluiTag(1,"versao",::versao)         //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")   //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"tpAmb","ideEvento")       //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")     //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento") //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")     //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )     //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoFuncao")
::incluiTag(4,"inclusao")
::incluiTag(5,"ideFuncao")
::incluiTag(5,"codFuncao","ideFuncao")    //E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(5,"dtIniValidade","ideFuncao")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideFuncao")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideFuncao")
::incluiTag(5,"dadosFuncao")
::incluiTag(5,"descFuncao","dadosFuncao") //E C 1-1 100 - Descrição da Função
::incluiTag(5,"/dadosFuncao")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")
::incluiTag(5,"ideFuncao")
::incluiTag(5,"codFuncao","ideFuncao")    //E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(5,"dtIniValidade","ideFuncao")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideFuncao")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se


::incluiTag(5,"/ideFuncao")
::incluiTag(5,"dadosFuncao")
::incluiTag(5,"descFuncao","dadosFuncao")  //E C 1-1 100 - Descrição da Função

::incluiTag(5,"/dadosFuncao")
::incluiTag(5,"novaValidade")
::incluiTag(5,"dtIniValidade","novaValidade")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","novaValidade")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")
::incluiTag(5,"ideFuncao")
::incluiTag(5,"codFuncao","ideFuncao")    //E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(5,"dtIniValidade","ideFuncao")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideFuncao")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideFuncao")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoFuncao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabFuncao")
RETURN Self
*------------------------------------------------------------------------------*





*------------------------------------------------------------------------------*
*S1050() //Tabela de Horários/Turnos de Trabalho
* -----------------------------------------------------------------------------*
METHOD S1050() CLASS eSocial

::incluiTag(1,"evtTabJornada")
::incluiTag(1,"versao",::versao)       // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")  //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"tpAmb","ideEvento")      //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")    //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")//E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")    //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )     //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoJornada")
::incluiTag(4,"inclusao")
::incluiTag(5,"ideJornada")
::incluiTag(5,"codJornada","ideJornada")   //E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada
::incluiTag(5,"dtIniValidade","ideJornada")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideJornada")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideJornada")
::incluiTag(5,"dadosJornada")
::incluiTag(5,"horaEntrada","dadosJornada") //E N 1-1 004 - informar hora da entrada, no formato HHMM
::incluiTag(5,"horaSaida","dadosJornada")   //E N 1-1 004 - informar hora da saída, no formato HHMM
::incluiTag(5,"tpIntervalo","dadosJornada") //E N 1-1 001 - Preencher com o tipo de intervalo.
::incluiTag(5,"durIntervalo","dadosJornada")//E N 0-1 003 - Preencher com o tempo de duração do intervalo, em minutos.

::incluiTag(6,"horarioIntervalo")
::incluiTag(6,"inicioIntervalo","horarioIntervalo") //E N 1-1 004 - informar a hora de início do intervalo, no formato HHMM
::incluiTag(6,"terminoIntervalo","horarioIntervalo")//E N 1-1 004 - informar a hora de termino do intervalo, no formato HHMM

::incluiTag(6,"/horarioIntervalo")
::incluiTag(5,"/dadosJornada")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")
::incluiTag(5,"ideJornada")
::incluiTag(5,"codJornada","ideJornada")   //E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada
::incluiTag(5,"dtIniValidade","ideJornada")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideJornada")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideJornada")
::incluiTag(5,"dadosJornada")
::incluiTag(5,"horaEntrada","dadosJornada") //E N 1-1 004 - informar hora da entrada, no formato HHMM
::incluiTag(5,"horaSaida","dadosJornada")   //E N 1-1 004 - informar hora da saída, no formato HHMM
::incluiTag(5,"tpIntervalo","dadosJornada") //E N 1-1 001 - Preencher com o tipo de intervalo.
::incluiTag(5,"durIntervalo","dadosJornada")//E N 0-1 003 - Preencher com o tempo de duração do intervalo, em minutos.

::incluiTag(6,"horarioIntervalo")
::incluiTag(6,"inicioIntervalo","horarioIntervalo") //E N 1-1 004 - informar a hora de início do intervalo, no formato HHMM
::incluiTag(6,"terminoIntervalo","horarioIntervalo")//E N 1-1 004 - informar a hora de termino do intervalo, no formato HHMM

::incluiTag(6,"/horarioIntervalo")
::incluiTag(5,"/dadosJornada")   
::incluiTag(5,"novaValidade")
::incluiTag(5,"dtIniValidade","novaValidade")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","novaValidade")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")
::incluiTag(5,"ideJornada")
::incluiTag(5,"codJornada","ideJornada")   //E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada
::incluiTag(5,"dtIniValidade","ideJornada")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideJornada")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideJornada")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoJornada")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabJornada")


RETURN Self
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*S1060 - Tabela de Estabelecimentos
* -----------------------------------------------------------------------------*
METHOD S1060() CLASS eSocial


::incluiTag(1,"evtTabEstab")
::incluiTag(1,"versao",::versao)        //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")    //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"tpAmb","ideEvento")      //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")    //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")//E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")    //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )     //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoEstab")
::incluiTag(4,"inclusao")
::incluiTag(5,"ideEstab")
::incluiTag(5,"tpInscricao","ideEstab")     //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao","ideEstab")     //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"dtIniValidade","ideEstab")   //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideEstab")   //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideEstab")
::incluiTag(5,"dadosEstab")
::incluiTag(5,"fpas","dadosEstab")            //E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(5,"codTerceiros","dadosEstab")    //E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"cnaeEstab")
::incluiTag(6,"cnaePreponderante","cnaeEstab")//E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"aliqRat","cnaeEstab")          //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(6,"aliqRatAjustada","cnaeEstab")  //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(6,"/cnaeEstab")
::incluiTag(5,"/dadosEstab")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")
::incluiTag(5,"ideEstab")
::incluiTag(5,"tpInscricao","ideEstab")     //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao",::cNpjEmp )     //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"dtIniValidade","ideEstab")   //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideEstab")   //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideEstab")
::incluiTag(5,"dadosEstab")
::incluiTag(5,"fpas","dadosEstab")            //E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(5,"codTerceiros","dadosEstab")    //E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(6,"cnaeEstab")
::incluiTag(6,"cnaePreponderante","cnaeEstab")//E N 1-1 007 - Preencher com o código do CNAE 2.0 conforme tabela
::incluiTag(6,"aliqRat","cnaeEstab")          //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(6,"aliqRatAjustada","cnaeEstab")  //E N 1-1 006 4 Alíquota após ajuste pelo FAP
::incluiTag(6,"/cnaeEstab")
::incluiTag(5,"/dadosEstab")
::incluiTag(5,"novaValidade")
::incluiTag(5,"dtIniValidade","novaValidade") //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","novaValidade") //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")
::incluiTag(5,"ideEstab")
::incluiTag(5,"tpInscricao","ideEstab")    //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao",::cNpjEmp )    //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"dtIniValidade","ideEstab")  //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideEstab")  //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideEstab")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoEstab")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabEstab")


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S1070 - Tabela de Processos
* -----------------------------------------------------------------------------*
METHOD S1070() CLASS eSocial

::incluiTag(1,"evtTabProcesso")
::incluiTag(1,"versao",::versao)         //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")    //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"tpAmb","ideEvento")       //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")     //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento") //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")     //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoProcesso")
::incluiTag(4,"inclusao")
::incluiTag(5,"ideProcesso")
::incluiTag(5,"tpProcesso","ideProcesso")   //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(5,"nrProcesso","ideProcesso")   //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(5,"dtIniValidade","ideProcesso")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideProcesso")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideProcesso")
::incluiTag(5,"dadosProcesso")
::incluiTag(5,"indDecisao","dadosProcesso")  //E N 1-1 001 - Indicativo de Decisão:
::incluiTag(5,"dtDecisao","dadosProcesso")   //E D 1-1 010 - Data da decisão, sentença ou despacho administrativo.
::incluiTag(5,"indDeposito","dadosProcesso") //E C 1-1 001 - Indicativo de Depósito do Montante Integral:
::incluiTag(6,"dadosProcJud")
::incluiTag(6,"ufVara","dadosProcJud")       //E C 1-1 002 - Identificação da UF da Seção Judiciária
::incluiTag(6,"codMunicipio","dadosProcJud") //E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(6,"idVara","dadosProcJud")       //E C 1-1 002 - Código de Identificação da Vara
::incluiTag(6,"indAutoria","dadosProcJud")   //E N 1-1 001 - Preencher com [1] se o próprio contribuinte é o autor da ação,
::incluiTag(6,"/dadosProcJud")
::incluiTag(5,"/dadosProcesso")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")
::incluiTag(5,"ideProcesso")
::incluiTag(5,"tpProcesso","ideProcesso")   //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(5,"nrProcesso","ideProcesso")   //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(5,"dtIniValidade","ideProcesso")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideProcesso")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideProcesso")
::incluiTag(5,"dadosProcesso")
::incluiTag(5,"indDecisao","dadosProcesso") //E N 1-1 001 - Indicativo de Decisão:
::incluiTag(5,"dtDecisao","dadosProcesso")  //E D 1-1 010 - Data da decisão, sentença ou despacho administrativo.
::incluiTag(5,"indDeposito","dadosProcesso")//E C 1-1 001 - Indicativo de Depósito do Montante Integral:

::incluiTag(6,"dadosProcJud")
::incluiTag(6,"ufVara","dadosProcJud")      //E C 1-1 002 - Identificação da UF da Seção Judiciária
::incluiTag(6,"codMunicipio","dadosProcJud")//E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(6,"idVara","dadosProcJud")      //E C 1-1 002 - Código de Identificação da Vara
::incluiTag(6,"indAutoria","dadosProcJud")  //E N 1-1 001 - Preencher com [1] se o próprio contribuinte é o autor da ação,
::incluiTag(6,"/dadosProcJud")
::incluiTag(5,"/dadosProcesso")
::incluiTag(5,"novaValidade")
::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")
::incluiTag(5,"ideProcesso")
::incluiTag(5,"tpProcesso","ideProcesso")    //E C 1-1 001 - Preencher com o código correspondente ao tipo de processo:
::incluiTag(5,"nrProcesso","ideProcesso")    //E C 1-1 020 - Informar o número do processo administrativo/judicial.
::incluiTag(5,"dtIniValidade","ideProcesso") //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideProcesso") //E D 0-1 010 - Preencher com a data de fim da validade das informações, se
::incluiTag(5,"/ideProcesso")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoProcesso")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabProcesso")

RETURN Self
*------------------------------------------------------------------------------*






*------------------------------------------------------------------------------*
*S1080 - Tabela de Operadores Portuários
* -----------------------------------------------------------------------------*
METHOD S1080() CLASS eSocial

::incluiTag(1,"evtTabOperPortuario")
::incluiTag(1,"versao",::versao)             // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")        //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"tpAmb","ideEvento")           //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")         //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")     //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")         //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//            E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//            E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoOperPortuario")
::incluiTag(4,"inclusao")
::incluiTag(5,"ideOperPortuario")
::incluiTag(5,"cnpjOpPortuario","ideOperPortuario")//E N 1-1 014 - Preencher com o CNPJ do operador portuário
::incluiTag(5,"dtIniValidade","ideOperPortuario")  //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideOperPortuario")  //E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideOperPortuario")
::incluiTag(5,"dadosOperPortuario")
::incluiTag(5,"aliqRat","dadosOperPortuario")        //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(5,"fap","dadosOperPortuario")            //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(5,"aliqRatAjustada","dadosOperPortuario")//E N 1-1 006 4 Alíquota após ajuste pelo FAP

::incluiTag(5,"/dadosOperPortuario")
::incluiTag(4,"/inclusao")
::incluiTag(4,"alteracao")
::incluiTag(5,"ideOperPortuario")
::incluiTag(5,"cnpjOpPortuario","ideOperPortuario")//E N 1-1 014 - Preencher com o CNPJ do operador portuário
::incluiTag(5,"dtIniValidade","ideOperPortuario")  //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideOperPortuario")  //E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideOperPortuario")
::incluiTag(5,"dadosOperPortuario")
::incluiTag(5,"aliqRat","dadosOperPortuario")        //E N 1-1 001 - Preencher com a alíquota definida no Decreto 3.048/99 para a
::incluiTag(5,"fap","dadosOperPortuario")            //E N 1-1 006 4 Fator Acidentário de Prevenção
::incluiTag(5,"aliqRatAjustada","dadosOperPortuario")//E N 1-1 006 4 Alíquota após ajuste pelo FAP

::incluiTag(5,"/dadosOperPortuario")
::incluiTag(5,"novaValidade")
::incluiTag(5,"dtIniValidade","novaValidade")//E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","novaValidade")//E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/novaValidade")
::incluiTag(4,"/alteracao")
::incluiTag(4,"exclusao")
::incluiTag(5,"ideOperPortuario")
::incluiTag(5,"cnpjOpPortuario","ideOperPortuario")//E N 1-1 014 - Preencher com o CNPJ do operador portuário
::incluiTag(5,"dtIniValidade","ideOperPortuario")  //E D 1-1 010 - Preencher com a data de início da validade das informações
::incluiTag(5,"dtFimValidade","ideOperPortuario")  //E D 0-1 010 - Preencher com a data de fim da validade das informações, se

::incluiTag(5,"/ideOperPortuario")
::incluiTag(4,"/exclusao")
::incluiTag(3,"/infoOperPortuario")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTabOperPortuario")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S1100() - eSocial Mensal - Abertura
* -----------------------------------------------------------------------------*
METHOD S1100() CLASS eSocial

::incluiTag(1,"evtFpAbertura")
::incluiTag(1,"versao",::versao)           //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento  ")    //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(2,"ideEvento","infEvento ")    //G - 1-1 - - Informações de identificação do evento
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")//E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo"," ideEvento")     //E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao"," ideEvento")  //E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao"," ideEvento")  //E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb"," ideEvento")        //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi"," ideEvento")      //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento"," ideEvento")  //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc"," ideEvento")      //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideRespInformacao")
::incluiTag(3,"nomeResponsavel","ideRespInformacao")//E C 1-1 080 - Nome do responsável pelas informações
::incluiTag(3,"cpfResponsavel","ideRespInformacao") //E N 1-1 011 - Preencher com o CPF do responsável
::incluiTag(3,"telefone","ideRespInformacao")      //E C 1-1 012 - Informar o número do telefone, com DDD.
::incluiTag(3,"fax","ideRespInformacao")           //E C 0-1 011 - Número do Fax, com DDD
::incluiTag(3,"email","ideRespInformacao")         //E C 0-1 060 - Endereço eletrônico

::incluiTag(3,"/ideRespInformacao")
::incluiTag(3,"infoSubstPatronal")
::incluiTag(3,"indSubstPatronal","infoSubstPatronal")//E N 1-1 001 - Indicativo de Substituição:
::incluiTag(3,"percAliqPatronal","infoSubstPatronal")//E N 1-1 005 2 Informar ZERO se {indSubstPatronal} = 1. Caso contrário,

::incluiTag(3,"/infoSubstPatronal")
::incluiTag(3,"recExpServicos")
::incluiTag(3,"recBrutaExp12m","recExpServicos")     //E N 1-1 14 2 Receita Bruta da venda de serviços para o mercado externo, nos
::incluiTag(3,"recBrutaTot12m","recExpServicos")     //E N 1-1 14 2 Receita Bruta Total de vendas de bens e serviços nos 12 meses
::incluiTag(3,"vlrTribRecBruta"," recExpServicos")   //E N 1-1 14 2 Valor dos Impostos e contribuições incidentes sobre a receita
::incluiTag(3,"qtdMesesAtiv"," recExpServicos")      //E N 0-1 002 - Preencher com a quantidade de meses em atividade, ou deixar
::incluiTag(3,"percReducaoLei11774","recExpServicos")//E N 1-1 006 4 Percentual de redução a ser aplicado na alíquota da

::incluiTag(3,"/recExpServicos")
::incluiTag(3,"recAtivConcomitante")
::incluiTag(3,"recBrutaTotMes","recAtivConcomitante") //E N 1-1 14 2 Informar o valor da receita bruta no mês a que se refere a folha
::incluiTag(3,"recBrutaTotAno","recAtivConcomitante") //E N 1-1 14 2 Informar o valor da receita bruta total da empresa, acumulada
::incluiTag(3,"recBrutaAtssMes","recAtivConcomitante")//E N 1-1 14 2 Informar o valor da receita bruta da atividade sem substituição
::incluiTag(3,"recBrutaAtssAno","recAtivConcomitante")//E N 1-1 14 2 Informar o valor da receita bruta da atividade sem substituição
::incluiTag(3,"fatorMes","recAtivConcomitante")       //E N 1-1 005 4 Informe o fator a ser utilizado para cálculo da contribuição
::incluiTag(3,"fator13","recAtivConcomitante ")       //E N 1-1 005 2 Informe o fator a ser utilizado para cálculo da contribuição

::incluiTag(3,"/recAtivConcomitante")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpAbertura")


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S1200() - eSocial Mensal - Remuneração
* -----------------------------------------------------------------------------*
METHOD S1200() CLASS eSocial

::incluiTag(1,"evtFpRemuneracao")
::incluiTag(1,"versao",::versao)          //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")     //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")//E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")      //E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")   //E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")   //E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento")         //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")       //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")   //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")//     //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideTrabalhador")
::incluiTag(3,"cpfTrab","ideTrabalhador")   //E N 1-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab","ideTrabalhador")   //E N 0-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"qtdDepSF","ideTrabalhador")  //E N 1-1 002 - Preencher com a quantidade de dependentes do trabalhador para
::incluiTag(3,"qtdDepIRRF","ideTrabalhador")//E N 1-1 002 - Preencher com a quantidade de dependentes do trabalhador para

::incluiTag(4,"infoMultiplosVinculos")
::incluiTag(4,"indMV","infoMultiplosVinculos")       //E N 1-1 001 - Indicador de desconto/recolhimento da contribuição

::incluiTag(5,"remunOutrasEmpresas")
::incluiTag(5,"tpInscricao","remunOutrasEmpresas")   //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao","remunOutrasEmpresas")   //E C 1-1 014 - Indicar o número de inscrição do CNPJ da empresa que
::incluiTag(5,"vlrRemuneracao","remunOutrasEmpresas")//E N 1-1 014 2 Preencher com o valor da remuneração recebida pelo

::incluiTag(5,"/remunOutrasEmpresas")
::incluiTag(4,"/infoMultiplosVinculos")
::incluiTag(4,"infoSimplesAtivConcomitante")
::incluiTag(4,"indSimples","infoSimplesAtivConcomitante")//E N 1-1 001 - Indicador de Contribuição Substituída:

::incluiTag(4,"/infoSimplesAtivConcomitante")
::incluiTag(4,"infoComplementares")
::incluiTag(4,"nomeTrab","infoComplementares")//E C 1-1 080 - Nome do Trabalhador
::incluiTag(4,"dtNascto","infoComplementares")//E D 1-1 010 - Preencher com a data de nascimento
::incluiTag(4,"codCBO","infoComplementares")  //E N 1-1 006 - Código Brasileiro de Ocupação

::incluiTag(4,"/infoComplementares")
::incluiTag(4,"infoTrabAvulso")
::incluiTag(4,"cnpjSindicato","infoTrabAvulso")//E N 1-1 014 - CNPJ do Sindicato ao qual os trabalhadores avulsos não
::incluiTag(4,"fpasSindicato","infoTrabAvulso")//E N 1-1 003 - Preencher com o código FPAS do Sindicato
::incluiTag(4,"codTerceiros","infoTrabAvulso") //E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.

::incluiTag(4,"/infoTrabAvulso")
::incluiTag(3,"/ideTrabalhador")
::incluiTag(3,"infoPeriodoApuracao")
::incluiTag(3,"ideEstabLotacao","infoPeriodoApuracao")//G - 1-50 - - Identificação do estabelecimento e lotação

::incluiTag(4,"ideEstabLotacao")
::incluiTag(5,"remunPeriodoApuracao")
::incluiTag(5,"matricula","remunPeriodoApuracao")   //E C 0-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(5,"codCateg","remunPeriodoApuracao")    //E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(5,"bcCP","remunPeriodoApuracao")        //E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição
::incluiTag(5,"bcIRRF","remunPeriodoApuracao")      //E N 1-1 14 2 Informar o valor total da base de cálculo IRRF para o
::incluiTag(5,"bcFGTS","remunPeriodoApuracao")      //E N 1-1 14 2 Informar o valor total da base de cálculo do FGTS para o
::incluiTag(5,"descCP","remunPeriodoApuracao")      //E N 1-1 14 2 preencher com o valor descontado do segurado referente
::incluiTag(5,"vlrProventos","remunPeriodoApuracao")//E N 1-1 14 2 Informar o valor total dos proventos
::incluiTag(5,"vlrDescontos","remunPeriodoApuracao")//E N 1-1 14 2 Preencher com o valor total dos descontos
::incluiTag(5,"vlrLiquido","remunPeriodoApuracao")  //E N 1-1 14 2 Preencher com o valor líquido
::incluiTag(5,"itensRemun","remunPeriodoApuracao")  //G - 0-100 - - Registro que relaciona as rubricas que compõe a remuneração

::incluiTag(6,"itensRemun")
::incluiTag(6,"codRubrica","itensRemun")//E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(6,"qtdRubrica","itensRemun")//E N 0-1 004 - Informar a quantidade de referência para apuração (em horas,
::incluiTag(6,"vlrRubrica","itensRemun")//E N 1-1 14 2 Valor da Rubrica

::incluiTag(6,"/itensRemun")
::incluiTag(6,"infoAgenteNocivo")
::incluiTag(9,"grauExp","infoAgenteNocivo")//E N 1-1 001 - Preencher com o código que representa o grau de exposição a

::incluiTag(6,"/infoAgenteNocivo")
::incluiTag(6,"infoRescisao")
::incluiTag(6,"nrReciboDeslig","infoRescisao")//E N 1-1 015 - Preencher com o número do recibo do evento de desligamento

::incluiTag(6,"/infoRescisao")
::incluiTag(5,"/remunPeriodoApuracao")
::incluiTag(4,"/ideEstabLotacao")
::incluiTag(3,"/infoPeriodoApuracao")
::incluiTag(3,"infoPeriodoAnterior")
::incluiTag(3,"ideAcordoDissidio","infoPeriodoAnterior")//G - 1-50 - - Identificação do Acordo/Convenção/Dissídio

::incluiTag(4,"ideAcordoDissidio")
::incluiTag(4,"dtAcordo","ideAcordoDissidio")//E D 1-1 010 - Preencher com a data do acordo, convenção ou dissídio
::incluiTag(4,"tpAcordo","ideAcordoDissidio")//E C 1-1 001 - Tipo de Acordo:

::incluiTag(5,"idePeriodo")
::incluiTag(5,"perReferencia","idePeriodo")  //E N 1-1 006 - Informar o período ao qual se refere o complemento de


::incluiTag(6,"ideEstabLotacao")
::incluiTag(6,"tpInscricao","ideEstabLotacao")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(6,"nrInscricao","ideEstabLotacao")//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(6,"codLotacao","ideEstabLotacao") //E C 1-1 030 - Informar o código atribuído pela empresa para a lotação

::incluiTag(7,"remunPeriodoAnterior")
::incluiTag(7,"matricula","remunPeriodoAnterior")//E C 0-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(7,"codCateg"," remunPeriodoAnterior")//E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(7,"bcCP","remunPeriodoAnterior")     //E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição
::incluiTag(7,"bcIRRF","remunPeriodoAnterior")   //E N 1-1 14 2 Informar o valor total da base de cálculo IRRF para o
::incluiTag(7,"bcFGTS","remunPeriodoAnterior")   //E N 1-1 14 2 Informar o valor total da base de cálculo do FGTS para o
::incluiTag(7,"descCP","remunPeriodoAnterior")   //E N 1-1 14 2 preencher com o valor descontado do segurado referente
::incluiTag(7,"vlrProventos","remunPeriodoAnterior")//E N 1-1 14 2 Informar o valor total dos proventos
::incluiTag(7,"vlrDescontos","remunPeriodoAnterior")//E N 1-1 14 2 Preencher com o valor total dos descontos
::incluiTag(7,"vlrLiquido","remunPeriodoAnterior")  //E N 1-1 14 2 Preencher com o valor líquido

::incluiTag(8,"itensRemun")
::incluiTag(8,"codRubrica","itensRemun")//E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(8,"qtdRubrica","itensRemun")//E N 0-1 004 - Informar a quantidade de referência para apuração (em horas,
::incluiTag(8,"vlrRubrica","itensRemun")//E N 1-1 14 2 Valor da Rubrica

::incluiTag(8,"/itensRemun")
::incluiTag(8,"infoAgenteNocivo")
::incluiTag(8,"/infoAgenteNocivo")
::incluiTag(7,"/remunPeriodoAnterior")
::incluiTag(6,"/ideEstabLotacao")
::incluiTag(5,"/idePeriodo")
::incluiTag(4,"/ideAcordoDissidio")

::incluiTag(3,"/infoPeriodoAnterior")
::incluiTag(3,"infoPagtosEfetuados")
::incluiTag(3,"dtPagto","infoPagtosEfetuados")      //E D 1-1 010 - Data do Pagamento
::incluiTag(3,"tpPagto","infoPagtosEfetuados")      //E N 1-1 001 - Tipo de Pagamento:
::incluiTag(3,"perReferencia","infoPagtosEfetuados")//E N 1-1 006 - Informar o período ao qual se refere o pagamento, no formato
::incluiTag(4,"pagtoTrabalhador")
::incluiTag(4,"vlrPagto","pagtoTrabalhador")        //E N 1-1 14 2 Preencher com o valor do pagamento efetuado na data de
::incluiTag(4,"vlrBaseIRRF"," pagtoTrabalhador")    //E N 1-1 14 2 Preencher com o valor da base de cálculo do IRRF relativa ao
::incluiTag(4,"descIRRF"," pagtoTrabalhador")       //E N 1-1 014 2 Valor descontado do trabalhador referente ao Imposto de Renda

::incluiTag(4,"/pagtoTrabalhador")
::incluiTag(4,"pagtoBeneficiario")
::incluiTag(4,"dtNasctoBeneficiario","pagtoBeneficiario")//E D 1-1 010 - Data de nascimento do beneficiário da pensão
::incluiTag(4,"cpfBeneficiario","pagtoBeneficiario ")    //E N 0-1 011 CPF do beneficiário da pensão alimentícia
::incluiTag(4,"nomeBeneficiario","pagtoBeneficiario")    //E C 1-1 080 - Nome do beneficiário da pensão alimentícia
::incluiTag(4,"vlrPagto","pagtoBeneficiario")            //E N 1-1 14 2 Preencher com o valor do pagamento efetuado na data de
::incluiTag(4,"vlrBaseIRRF","pagtoBeneficiario")         //E N 1-1 14 2 Preencher com o valor da base de cálculo do IRRF relativa ao

::incluiTag(4,"/pagtoBeneficiario")

::incluiTag(3,"totRemuneracao")
::incluiTag(3,"perReferencia","totRemuneracao")//E N 1-1 006 - Período de referência da remuneração.
::incluiTag(3,"matricula","totRemuneracao    ")//E C 0-1 030 - Matrícula atribuída ao trabalhador pela empresa, informada nas
::incluiTag(3,"codCateg","totRemuneracao     ")//E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(3,"bcCP","totRemuneracao  ")       //E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição
::incluiTag(3,"bcFGTS","totRemuneracao")       //E N 1-1 14 2 Informar o valor total da base de cálculo do FGTS para o
::incluiTag(3,"bcIRRF","totRemuneracao")       //E N 1-1 14 2 Informar o valor total da base de cálculo IRRF para o
::incluiTag(3,"descCP","totRemuneracao")       //E N 1-1 14 2 preencher com o valor descontado do segurado referente
::incluiTag(3,"/totRemuneracao")

::incluiTag(3,"/infoPagtosEfetuados")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpRemuneracao")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*s1310 eSocial Mensal - Outras Informações - Serv. Tomados
* -----------------------------------------------------------------------------*
METHOD S1310() CLASS eSocial

::incluiTag(1,"evtFpServTomados")
::incluiTag(1,"versao",::versao)          //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")     //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")//E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")      //E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")   //E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")   //E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento")         //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")       //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")   //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")       //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoServTomados")

::incluiTag(4,"ideEstabelecimento")
::incluiTag(4,"tpInscricao","ideEstabelecimento")//     E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabelecimento")//     E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"idePrestadorServicos")
::incluiTag(5,"cnpjPrestador","idePrestadorServicos")//       E N 1-1 014 - CNPJ do Prestador de Serviços
::incluiTag(5,"vlrBruto","idePrestadorServicos")//            E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(5,"vlrBaseRetencao","idePrestadorServicos")//     E N 1-1 14 2 Base de cálculo da retenção.
::incluiTag(5,"vlrRetencao","idePrestadorServicos")//         E N 1-1 14 2 Soma do valor da retenção das notas fiscais de serviço
::incluiTag(5,"vlrAdicional","idePrestadorServicos")//        E N 1-1 14 2 Soma do valor do adicional de retenção das notas fiscais
::incluiTag(5,"vlrNaoRetido","idePrestadorServicos")//        E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante
::incluiTag(6,"nfsTerceiros")
::incluiTag(6,"serie","nfsTerceiros")//                       E C 1-1 005 - Informar o número de série da nota fiscal/fatura
::incluiTag(6,"numDocto","nfsTerceiros")//                    E C 1-1 010 - Número da Nota Fiscal/Fatura
::incluiTag(6,"dtEmissaoNF","nfsTerceiros")//                 E D 1-1 010 - Data de Emissão da Nota Fiscal/Fatura
::incluiTag(6,"dtPagtoNF","nfsTerceiros")//                   E D 0-1 010 - Caso já tenha sido efetuado o pagamento, informar a data.
::incluiTag(6,"tpServico","nfsTerceiros")//                   E N 1-1 002 - Informar o tipo de serviço, conforme tabela 6.
::incluiTag(6,"indObra","nfsTerceiros")//                     E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(6,"nrCno","nfsTerceiros")//                       E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(6,"vlrBaseRetencao","nfsTerceiros")//             E N 1-1 14 2 Base de cálculo da retenção.
::incluiTag(6,"vlrBruto","nfsTerceiros")//                    E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(6,"vlrRetencaoApurada","nfsTerceiros")//          E N 1-1 14 2 Preencher com o valor da retenção apurada relativa aos serviços
::incluiTag(6,"vlrRetencaoSubEmpreitada","nfsTerceiros")//    E N 1-1 14 2 Informar o valor da retenção destacada na nota fiscal relativo
::incluiTag(6,"vlrRetencao","nfsTerceiros")//                 E N 1-1 14 2 Informar o valor retido.
::incluiTag(6,"vlrAdicional","nfsTerceiros")//                E N 1-1 14 2 Adicional de retenção da nota fiscal, caso os serviços tenham

::incluiTag(7,"servPrestCondEspeciais")
::incluiTag(7,"vlrServicos15","servPrestCondEspeciais")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos20","servPrestCondEspeciais")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos25","servPrestCondEspeciais")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"/servPrestCondEspeciais")
::incluiTag(7,"infoProcJudicial")
::incluiTag(7,"nrProcJud","infoProcJudicial")//               E C 1-1 020 - Preencher com o número do processo judicial;
::incluiTag(7,"vlrNaoRetido","infoProcJudicial")//           E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante
::incluiTag(7,"/infoProcJudicial")
::incluiTag(7,"proprietarioCNO")
::incluiTag(7,"tpInscProprietario","proprietarioCNO")//       E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(7,"nrInscProprietario","proprietarioCNO")//       E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(7,"/proprietarioCNO")
::incluiTag(6,"/nfsTerceiros")
::incluiTag(5,"/idePrestadorServicos")
::incluiTag(4,"/ideEstabelecimento")
::incluiTag(3,"/infoServTomados")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpServTomados")



RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*1320 - eSocial Mensal - Outras Informações - Serv. Prestados
* -----------------------------------------------------------------------------*
METHOD S1320() CLASS eSocial

::incluiTag(1,"evtFpServPrestados")
::incluiTag(1,"versao",::versao)            //             A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")//                    A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")//              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento      ")//              E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento   ")//              E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento   ")//              E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento        ")//              E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento      ")//              E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento  ")//              E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento      ")//              E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//            E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//            E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoServPrestados")
::incluiTag(4,"ideEstabPrestador")
::incluiTag(4,"tpInscricao","ideEstabPrestador")//        E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabPrestador")//        E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(5,"ideContratante")
::incluiTag(5,"tpInscContratante","ideContratante")//     E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(5,"nrInscContratante","ideContratante")//     E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(5,"vlrBruto","ideContratante   ")//           E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(5,"vlrServicos","ideContratante")//           E N 1-1 14 2 Preencher com a soma do valor dos serviços das notas fiscais
::incluiTag(5,"vlrBaseRetencao","ideContratante")//       E N 1-1 14 2 Preencher com a soma da base de cálculo da retenção das notas
::incluiTag(5,"vlrRetencao","ideContratante ")//          E N 1-1 14 2 Soma do valor da retenção das notas fiscais de serviço emitidas
::incluiTag(5,"vlrAdicional","ideContratante")//          E N 1-1 14 2 Soma do valor do adicional de retenção das notas fiscais
::incluiTag(5,"vlrNaoRetido","ideContratante")//          E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante

::incluiTag(6,"nfsEmitidas")
::incluiTag(6,"serie","nfsEmitidas")//                    E C 1-1 005 - Informar o número de série da nota fiscal/fatura
::incluiTag(6,"numDocto","nfsEmitidas")//                 E C 1-1 010 - Número da Nota Fiscal/Fatura
::incluiTag(6,"dtEmissaoNF","nfsEmitidas")//              E D 1-1 010 - Data de Emissão da Nota Fiscal/Fatura
::incluiTag(6,"dtPagtoNF","nfsEmitidas")//                E D 0-1 010 - Caso já tenha sido efetuado o pagamento, informar a data.
::incluiTag(6,"tpServico","nfsEmitidas")//                E N 1-1 002 - Informar o tipo de serviço, conforme tabela 6.
::incluiTag(6,"indObra","nfsEmitidas")//                  E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(6,"nrCno","nfsEmitidas")//                    E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(6,"vlrBruto","nfsEmitidas")//                 E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(6,"vlrServicos","nfsEmitidas")//              E N 1-1 14 2 Preencher com o valor dos serviços da nota fiscal.
::incluiTag(6,"vlrDeducoes","nfsEmitidas")//              E N 1-1 14 2 Valor das deduções legais de auxílio-alimentação e vale
::incluiTag(6,"vlrBaseRetencao","nfsEmitidas")//          E N 1-1 14 2 Base de cálculo da retenção.
::incluiTag(6,"vlrRetencaoApurada","nfsEmitidas")//       E N 1-1 14 2 Preencher com o valor da retenção apurada relativa aos serviços
::incluiTag(6,"nfsEmitidas"," ")                 //       E N 1-1 14 2 Informar o valor da retenção destacada na nota fiscal relativo
::incluiTag(6,"vlrRetencao","nfsEmitidas")//              E N 1-1 14 2 Informar o valor da retenção
::incluiTag(6,"vlrAdicional","nfsEmitidas")//             E N 1-1 14 2 Adicional de retenção da nota fiscal, caso os serviços tenham

::incluiTag(7,"servPrestCondEspeciais")
::incluiTag(7,"vlrServicos15","servPrestCondEspeciais")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos20","servPrestCondEspeciais")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos25","servPrestCondEspeciais")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"/servPrestCondEspeciais")
::incluiTag(7,"infoProcJudicial")
::incluiTag(7,"nrProcJud","infoProcJudicial")//           E C 1-1 020 - Preencher com o número do processo judicial, conforme padrão
::incluiTag(7,"vlrNaoRetido","infoProcJudicial")//        E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante
::incluiTag(7,"/infoProcJudicial")
::incluiTag(7,"servSubempreitados")
::incluiTag(7,"cnpjSubempreiteiro","servSubempreitados     ")//   E N 1-1 014 - CNPJ do Subempreiteiro
::incluiTag(7,"vlrRetidoSubempreitada","servSubempreitados ")//   E N 1-1 14 2 Informar o valor da retenção efetuada em relação aos serviços
::incluiTag(7,"proprietarioCNO","servSubempreitados        ")//   G - 0-1 - - Identificação do proprietário do CNO em caso de serviços
::incluiTag(8,"proprietarioCNO")
::incluiTag(8,"tpInscProprietario","proprietarioCNO")//          E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(8,"nrInscProprietario","proprietarioCNO")//          E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(8,"/proprietarioCNO")
::incluiTag(7,"/servSubempreitados")
::incluiTag(6,"/nfsEmitidas")
::incluiTag(5,"/ideContratante")
::incluiTag(4,"/ideEstabPrestador")
::incluiTag(3,"/infoServPrestados")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpServPrestados")




RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*1330 - eSocial Mensal - Outras Informações - Serv. Tomados de Coop.
* -----------------------------------------------------------------------------*
METHOD S1330() CLASS eSocial

::incluiTag(1,"evtFpServTomadosCoop")
::incluiTag(1,"versao",::versao)              //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")//                A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao"," ideEvento")//        E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")//              E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")//           E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")//           E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento  ")//               E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")//               E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")//           E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")    //           E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//        E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//        E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoServTomados")
::incluiTag(4,"ideEstabelecimento")
::incluiTag(4,"tpInscricao","ideEstabelecimento ")//      E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabelecimento ")//      E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"nfsTerceiros","ideEstabelecimento")//      G - 1-999 - - Registro que detalha as notas fiscais emitidas por Cooperativas

::incluiTag(5,"nfsTerceiros")
::incluiTag(5,"cnpjCooperativa","nfsTerceiros")//         E N 1-1 014 - CNPJ da cooperativa prestadora de serviços
::incluiTag(5,"serie","nfsTerceiros")//                   E C 1-1 005 - Informar o número de série da nota fiscal/fatura
::incluiTag(5,"numDocto","nfsTerceiros")//                E C 1-1 010 - Número da Nota Fiscal/Fatura
::incluiTag(5,"dtEmissaoNF","nfsTerceiros")//             E D 1-1 010 - Data de Emissão da Nota Fiscal/Fatura
::incluiTag(5,"dtPagtoNF","nfsTerceiros")//               E D 0-1 010 - Caso já tenha sido efetuado o pagamento, informar a data.
::incluiTag(5,"indObra","nfsTerceiros")//                 E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(5,"nrCno","nfsTerceiros")//                   E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(5,"vlrBruto","nfsTerceiros")//                E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(5,"vlrMatEquip","nfsTerceiros")//             E N 1-1 14 2 Valor dos materiais e equipamentos fornecidos, desde que
::incluiTag(5,"vlrServicos","nfsTerceiros")//             E N 1-1 14 2 Valor dos serviços contidos na nota fiscal/fatura, já deduzidos
::incluiTag(5,"vlrDeducoes","nfsTerceiros")//             E N 1-1 14 2 Valor das deduções legais de auxílio-alimentação e vale
::incluiTag(5,"vlrBaseCoop","nfsTerceiros")//             E N 1-1 14 2 Base de cálculo da contribuição incidente sobre o valor pago à

::incluiTag(6,"servCoopCondEspeciais")
::incluiTag(6,"vlrServicos15","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(6,"vlrServicos20","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(6,"vlrServicos25","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições

::incluiTag(6,"/servCoopCondEspeciais")
::incluiTag(6,"servPrestAtivConcomitantes")
::incluiTag(6,"vlrBaseCoop","servPrestAtivConcomitantes  ")// E N 1-1 14 2 Valor da base de cálculo correspondente aos serviços prestados
::incluiTag(6,"vlrBaseCoop15","servPrestAtivConcomitantes")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(6,"vlrBaseCoop20","servPrestAtivConcomitantes")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(6,"vlrBaseCoop25","servPrestAtivConcomitantes")// E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições

::incluiTag(6,"/servPrestAtivConcomitantes")
::incluiTag(6,"proprietarioCNO")
::incluiTag(6,"tpInscProprietario","proprietarioCNO")//       E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(6,"nrInscProprietario","proprietarioCNO")//       E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(6,"/proprietarioCNO")
::incluiTag(5,"/nfsTerceiros")
::incluiTag(5,"totBaseCoop")
::incluiTag(5,"indIncidencia","totBaseCoop")//E N 1-1 001 - Preencher com o código correspondente ao tipo de incidência
::incluiTag(5,"vlrBaseCoop","totBaseCoop")  //N 1-1 14 2 Valor total da base de cálculo da contribuição
::incluiTag(5,"vlrBaseCoop15","totBaseCoop")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(5,"vlrBaseCoop20","totBaseCoop")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(5,"vlrBaseCoop25","totBaseCoop")//E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(5,"/totBaseCoop")
::incluiTag(4,"/ideEstabelecimento")
::incluiTag(3,"/infoServTomados")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpServTomadosCoop")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S1340() eSocial Mensal - Outras Informações - Serv. Prestados
* -----------------------------------------------------------------------------*
METHOD S1340() CLASS eSocial

::incluiTag(1,"evtFpServPrestadosCoop")
::incluiTag(1,"versao",::versao)                   //  A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")//             A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")//              E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento      ")//              E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")//                 E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")//                 E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento  ")//                    E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")//                    E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")//                E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")//                    E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoServPrestados")
::incluiTag(4,"ideEstabPrestador")
::incluiTag(4,"tpInscricao"," ideEstabPrestador")//  E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao"," ideEstabPrestador")//  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"ideContratante")
::incluiTag(5,"tpInscContratante","ideContratante")// E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(5,"nrInscContratante","ideContratante")// E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(5,"vlrBruto"," ideContratante        ")//  E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(5,"vlrBaseCoop","ideContratante      ")// E N 1-1 14 2 Informar o valor total da base de cálculo da(s) nota(s) fiscal(is)

::incluiTag(6,"nfsEmitidas")
::incluiTag(6,"serie","nfsEmitidas      ")//              E C 1-1 005 - Informar o número de série da nota fiscal/fatura
::incluiTag(6,"numDocto"," nfsEmitidas   ")//              E C 1-1 010 - Número da Nota Fiscal/Fatura
::incluiTag(6,"dtEmissaoNF"," nfsEmitidas")//              E D 1-1 010 - Data de Emissão da Nota Fiscal/Fatura
::incluiTag(6,"dtPagtoNF"," nfsEmitidas  ")//              E D 0-1 010 - Caso já tenha sido efetuado o pagamento, informar a data.
::incluiTag(6,"indObra"," nfsEmitidas    ")//              E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(6,"nrCno"," nfsEmitidas      ")//              E N 1-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(6,"vlrBruto"," nfsEmitidas   ")//              E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(6,"vlrMatEquip"," nfsEmitidas")//              E N 1-1 14 2 Valor dos materiais e equipamentos fornecidos, desde que
::incluiTag(6,"vlrServicos","nfsEmitidas")//              E N 1-1 14 2 Preencher com a soma do valor dos serviços das notas fiscais
::incluiTag(6,"vlrDeducoes","nfsEmitidas")//              E N 1-1 14 2 Valor das deduções legais de auxílio-alimentação e vale
::incluiTag(6,"vlrBaseCoop","nfsEmitidas")//              E N 1-1 14 2 Informar o valor total da base de cálculo da(s) nota(s) fiscal(is)
::incluiTag(7,"servCoopCondEspeciais")
::incluiTag(7,"vlrServicos15","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos20","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"vlrServicos25","servCoopCondEspeciais")//  E N 1-1 14 2 Valor dos Serviços prestados por segurados em condições
::incluiTag(7,"/servCoopCondEspeciais")
::incluiTag(7,"proprietarioCNO")
::incluiTag(7,"tpInscProprietario","proprietarioCNO")//   E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(7,"nrInscProprietario","proprietarioCNO")//   E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do
::incluiTag(7,"/proprietarioCNO")
::incluiTag(6,"/nfsEmitidas")
::incluiTag(5,"/ideContratante")
::incluiTag(4,"/ideEstabPrestador")
::incluiTag(3,"/infoServPrestados")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpServPrestadosCoop")


RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S1350() eSocial Mensal - Outras Informações - Aquisição de Produção
* -----------------------------------------------------------------------------*
METHOD S1350() CLASS eSocial

::incluiTag(1,"evtFpAquisProducao")
::incluiTag(1,"versao",::versao)            //A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")       //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento") //E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")       //E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")    //E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")    //E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento")          //E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")        //E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")    //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")        //E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoAquisProducao")
::incluiTag(4,"ideEstabAdquirente")
::incluiTag(4,"tpInscricao","ideEstabAdquirente")//E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabAdquirente")//E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"tipoAquisicao")
::incluiTag(5,"indAquisicao","tipoAquisicao")//           E N 1-1 001 - Indicativo da Aquisição:
::incluiTag(5,"vlrTotalAquisicao"," tipoAquisicao")//E N 1-1 14 2 Valor total da aquisição correspondente ao indicativo informado
::incluiTag(6,"ideProdutor")
::incluiTag(6,"tpInscricao","ideProdutor     ") //E N 1-1 001 - Preencher com [1] (CNPJ) ou [2] (CPF)
::incluiTag(6,"nrInscricao","ideProdutor     ") //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(6,"vlrBruto"," ideProdutor        ")//E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(6,"vlrContribDescPR","ideProdutor") //E N 1-1 14 2 Preencher com o valor da Contribuição Previdenciária
::incluiTag(6,"vlrGilratDescPR"," ideProdutor ")//E N 1-1 14 2 Valor da contribuição destinada ao financiamento dos
::incluiTag(6,"vlrSenarDescPR","ideProdutor  ") //E N 1-1 14 2 Valor da contribuição destinada ao SENAR, incidente sobre a
::incluiTag(6,"notasFiscais","ideProdutor    ") //G - 0-999 - - O registro detalha as notas fiscais de aquisição da produção

::incluiTag(7,"notasFiscais")
::incluiTag(7,"serie","notasFiscais           ")//E C 1-1 005 - Informar o número de série da nota fiscal/fatura
::incluiTag(7,"numDocto"," notasFiscais        ")//E C 1-1 010 - Número da Nota Fiscal/Fatura
::incluiTag(7,"dtEmissaoNF"," notasFiscais     ")//E D 1-1 010 - Data de Emissão da Nota Fiscal/Fatura
::incluiTag(7,"vlrBruto"," notasFiscais        ")//E N 1-1 14 2 Preencher com o valor bruto da(s) nota(s) fiscal(is)
::incluiTag(7,"vlrContribDescPR"," notasFiscais")//E N 1-1 14 2 Preencher com o valor da Contribuição Previdenciária
::incluiTag(7,"vlrGilratDescPR"," notasFiscais ")//E N 1-1 14 2 Valor da contribuição destinada ao financiamento dos
::incluiTag(7,"vlrSenarDescPR","notasFiscais  ")//E N 1-1 14 2 Valor da contribuição destinada ao SENAR, incidente sobre a
::incluiTag(7,"/notasFiscais")
::incluiTag(7,"infoProcJudicial")
::incluiTag(7,"nrProcJud","infoProcJudicial")// E C 1-1 020 - Preencher com o número do processo judicial, conforme padrão
::incluiTag(7,"/infoProcJudicial")
::incluiTag(6,"/ideProdutor")
::incluiTag(5,"/tipoAquisicao")
::incluiTag(4,"/ideEstabAdquirente")
::incluiTag(3,"/infoAquisProducao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpAquisProducao")



RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S1360() eSocial Mensal - Outras Informações - Comercialização da Produção
* -----------------------------------------------------------------------------*
METHOD S1360() CLASS eSocial

::incluiTag(1,"evtFpComercProducao")
::incluiTag(1,"versao",::versao)      // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento"," infEvento")// A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")// E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")      // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")   // E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao","ideEvento")   // E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb","ideEvento")         // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")       // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")   // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")       // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoComercProducao")
::incluiTag(4,"ideEstabelecimento")
::incluiTag(4,"tpInscricao","ideEstabelecimento")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabelecimento")// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"tipoComercializacao","ideEstabelecimento")// G - 1-5 - - Registro que apresenta o valor total da comercialização por
::incluiTag(5,"tipoComercializacao")
::incluiTag(5,"indComercializacao","tipoComercializacao")// E N 1-1 001 - Indicativo de Comercialização:
::incluiTag(5,"vlrTotalComercializacao","tipoComercializacao")// E N 1-1 14 2 Preencher com o valor total da comercialização

::incluiTag(5,"/tipoComercializacao")
::incluiTag(5,"ideAdquirente")
::incluiTag(5,"tpInscricao","ideAdquirente")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao","ideAdquirente")// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"vlrComercializacao","ideAdquirente")// E N 1-1 14 2 Valor bruto da comercialização da produção
::incluiTag(5,"vlrRetidoProdRural","ideAdquirente")// E N 0-1 14 2 Valor total retido pelo adquirente
::incluiTag(5,"/ideAdquirente")
::incluiTag(4,"/ideEstabelecimento")
::incluiTag(3,"/infoComercProducao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpComercProducao")



RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S1370() eSocial Mensal - Outras Informações - Rec. Recebidos
* -----------------------------------------------------------------------------*
METHOD S1370() CLASS eSocial

::incluiTag(1,"evtFpAssocDesportiva")
::incluiTag(1,"versao",::versao)       // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento"," infEvento") //A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento")// E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")      // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento")   // E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao"," ideEvento")  // E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb"," ideEvento")        // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi"," ideEvento")      // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento"," ideEvento")  // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc"," ideEvento")      // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao"," ideEmpregador")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoRecursoRecebido")
::incluiTag(4,"recursosRecebidos")
::incluiTag(4,"cnpjEmpOrigemRecurso","recursosRecebidos")// E N 1-1 014 - Preencher com o CNPJ da empresa que repassou recursos
::incluiTag(4,"tpRepasse"," recursosRecebidos") //E N 1-1 001 - Tipo de repasse, conforme tabela abaixo:
::incluiTag(4,"dtRepasse"," recursosRecebidos") //E D 1-1 010 - Data do repasse
::incluiTag(4,"vlrRepasse","recursosRecebidos")// E N 1-1 14 2 Valor do repasse recebido à título de patrocínio, publicidade,
::incluiTag(4,"/recursosRecebidos")
::incluiTag(3,"/infoRecursoRecebido")
::incluiTag(3,"infoRecursoRepassado")
::incluiTag(4,"ideEstabelecimento")
::incluiTag(4,"tpInscricao","ideEstabelecimento")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(4,"nrInscricao","ideEstabelecimento")// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(4,"vlrTotalRepasses","ideEstabelecimento")// E N 1-1 14 2 Valor total dos repasses efetuados pelo estabelecimento à(s)
::incluiTag(5,"recursosRepassados")
::incluiTag(5,"cnpjAssocDesportiva","recursosRepassados")// E N 1-1 014 - Preencher com o CNPJ da associação desportiva que mantém
::incluiTag(5,"tpRepasse"," recursosRepassados") //E N 1-1 001 - Tipo de repasse, conforme tabela abaixo:
::incluiTag(5,"dtRepasse"," recursosRepassados") //E D 1-1 010 - Data do repasse
::incluiTag(5,"vlrRepasse"," recursosRepassados")// E N 1-1 14 2 Valor do repasse efetuado à título de patrocínio, publicidade,
::incluiTag(5,"/recursosRepassados")
::incluiTag(4,"/ideEstabelecimento")
::incluiTag(3,"/infoRecursoRepassado")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpAssocDesportiva")

* 


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S1400() eSocial Mensal - Bases de Cálculo, Retenção, Deduções e Contribuições
* -----------------------------------------------------------------------------*
METHOD S1400() CLASS eSocial

::incluiTag(1,"evtFpBasesContrib")
::incluiTag(1,"versao",::versao) // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento") // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento") // E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo"," ideEvento") // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"indApuracao","ideEvento") // E N 1-1 001 - Indicativo de período de apuração:
::incluiTag(3,"perApuracao"," ideEvento")// E N 1-1 006 - Informar o mês/ano (formato MMAAAA) da folha de
::incluiTag(3,"tpAmb"," ideEvento") // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi"," ideEvento") // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento"," ideEvento")// E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc"," ideEvento") // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador") // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp ) // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideConteudo")
::incluiTag(3,"indConteudo","ideConteudo") // E N 1-1 001 - Indicativo de Conteúdo:

::incluiTag(3,"/ideConteudo")
::incluiTag(3,"infoBasesContrib")
::incluiTag(4,"ideEstabelecimento")
::incluiTag(4,"tpInscricao"," ideEstabelecimento") // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição do
::incluiTag(4,"nrInscricao"," ideEstabelecimento") // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(5,"basesPorCategoria")
::incluiTag(5,"indIncidencia","basesPorCategoria") // E N 1-1 001 - Preencher com o código correspondente ao tipo de incidência
::incluiTag(5,"codCateg"," basesPorCategoria") // E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(5,"vlrBcCP"," basesPorCategoria") // E N 1-1 14 2 Valor total da base de cálculo da contribuição previdenciária
::incluiTag(5,"vlrBcCP15"," basesPorCategoria") // E N 1-1 14 2 Preencher com a base de cálculo da contribuição adicional para
::incluiTag(5,"vlrBcCP20"," basesPorCategoria") // E N 1-1 14 2 Preencher com a base de cálculo da contribuição adicional para
::incluiTag(5,"vlrBcCP25"," basesPorCategoria") // E N 1-1 14 2 Preencher com a base de cálculo da contribuição adicional para
::incluiTag(5,"vlrDescCP"," basesPorCategoria") // E N 1-1 14 2 preencher com o valor total da contribuição descontada dos
::incluiTag(5,"vlrSalFam","basesPorCategoria") // E N 1-1 14 2 Preecher com o valor total do salário-família para a categoria.
::incluiTag(5,"vlrSalMat","basesPorCategoria") // E N 1-1 14 2 Preencher com o valor total do salário-maternidade para a

::incluiTag(5,"/basesPorCategoria")
::incluiTag(5,"basesPorOperPortuario")
::incluiTag(5,"cnpjOpPortuario","basesPorOperPortuario") // E N 1-1 014 - Preencher com o CNPJ do operador portuário
::incluiTag(5,"vlrBcOpPortuario"," basesPorOperPortuario")// E N 1-1 14 2 Preencher com o valor total da base de cálculo da Gilrat relativa

::incluiTag(5,"/basesPorOperPortuario")
::incluiTag(5,"basesPorFpas")
::incluiTag(5,"codTerceiros"," basesPorFpas") // E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(5,"bcTerceiros"," basesPorFpas") // E N 1-1 14 2 Informar o valor total da base de cálculo das contribuições

::incluiTag(5,"/basesPorFpas")
::incluiTag(5,"contribPrevSocial")
::incluiTag(5,"indTpContrib","contribPrevSocial") // E N 1-1 003 - Preencher com código relativo à contribuição apurada,
::incluiTag(5,"vlrContribuicao","contribPrevSocial") // E N 1-1 14 2 Preencher com o valor da contribuição

::incluiTag(5,"/contribPrevSocial")
::incluiTag(5,"contribOutrasEntidades")
::incluiTag(5,"fpas","contribOutrasEntidades") // E N 1-1 003 - Preencher com o código relativo ao FPAS.
::incluiTag(5,"codTerceiros","contribOutrasEntidades") // E N 1-1 004 - Preencher com o código de terceiros, conforme tabela 4.
::incluiTag(5,"vlrTotTerceiros","contribOutrasEntidades") // E N 1-1 14 2 Preencher com o valor total das contriubuições destinadas a
::incluiTag(5,"contribTerceiro","contribOutrasEntidades") // G - 0-9 - - Detalhamento das Contribuições Destinadas a Outras Entidades

::incluiTag(6,"contribTerceiro")
::incluiTag(6,"codTerceiro","contribTerceiro") // E N 1-1 004 - Informar o Código de Terceiro
::incluiTag(6,"aliqTerceiro"," contribTerceiro") // E N 1-1 005 2 Preencher com a alíquota da Contribuição destinada ao terceiro,
::incluiTag(6,"vlrTerceiro"," contribTerceiro") // E N 1-1 14 2 Preencher com o valor da contribuição

::incluiTag(6,"/contribTerceiro")
::incluiTag(5,"/contribOutrasEntidades")
::incluiTag(4,"/ideEstabelecimento")
::incluiTag(3,"/infoBasesContrib")
::incluiTag(3,"infoCessaoMaoObra")
::incluiTag(4,"retencaoEfetuada")
::incluiTag(5,"idePrestadorObra")
::incluiTag(5,"cnpjPrestador"," idePrestadorObra") // E N 1-1 014 - CNPJ do Prestador de Serviços
::incluiTag(5,"indObra","idePrestadorObra")// E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(5,"nrCno","idePrestadorObra") // E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(5,"vlrAdicional","idePrestadorObra") // E N 1-1 14 2 Soma do valor do adicional de retenção das notas fiscais
::incluiTag(5,"vlrNaoRetido","idePrestadorObra") // E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante

::incluiTag(6,"proprietarioCNO")
::incluiTag(6,"tpInscProprietario","proprietarioCNO") // E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(6,"nrInscProprietario","proprietarioCNO") // E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do

::incluiTag(6,"/proprietarioCNO")
::incluiTag(5,"/idePrestadorObra")
::incluiTag(4,"/retencaoEfetuada")
::incluiTag(4,"retencaoSofrida")
::incluiTag(5,"ideContratanteObra")
::incluiTag(5,"tpInscContratante","ideContratanteObra") // E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(5,"nrInscContratante","ideContratanteObra") // E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(5,"indObra","ideContratanteObra") // E N 1-1 001 - Indicativo de Prestação de Serviços em Obra de Construção
::incluiTag(5,"nrCno","ideContratanteObra") // E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(5,"vlrRetencao"," ideContratanteObra") // E N 1-1 14 2 Soma do valor da retenção das notas fiscais de serviço
::incluiTag(5,"vlrAdicional","ideContratanteObra") // E N 1-1 14 2 Soma do valor do adicional de retenção das notas fiscais
::incluiTag(5,"vlrNaoRetido","ideContratanteObra") // E N 1-1 14 2 Valor da retenção que deixou de ser efetuada pelo contratante

::incluiTag(6,"proprietarioCNO")
::incluiTag(6,"tpInscProprietario","proprietarioCNO") // Tipo de Inscrição do proprietário do CNO
::incluiTag(6,"nrInscProprietario","proprietarioCNO") // Preencher com o número de inscrição (CNPJ/CPF) do

::incluiTag(6,"/proprietarioCNO")
::incluiTag(5,"/ideContratanteObra")
::incluiTag(4,"/retencaoSofrida")
::incluiTag(4,"remunPorContratante")
::incluiTag(4,"tpInscContratante","remunPorContratante") // E N 1-1 001 - Tipo de Inscrição do contratante
::incluiTag(4,"nrInscContratante","remunPorContratante") // E C 1-1 014 - Número de Inscrição (CNPJ/CPF) do Contrante
::incluiTag(4,"nrCno","remunPorContratante") // E N 0-1 012 - Preencher com o número de inscrição no Cadastro Nacional de
::incluiTag(4,"codCateg","remunPorContratante")// E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(4,"bcCP","remunPorContratante") // E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição

::incluiTag(5,"proprietarioCNO")
::incluiTag(5,"tpInscProprietario","proprietarioCNO") // E N 1-1 001 - Tipo de Inscrição do proprietário do CNO
::incluiTag(5,"nrInscProprietario","proprietarioCNO") // E C 1-1 014 - Preencher com o número de inscrição (CNPJ/CPF) do

::incluiTag(5,"/proprietarioCNO")
::incluiTag(4,"/remunPorContratante")
::incluiTag(3,"/infoCessaoMaoObra")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtFpBasesContrib")




RETURN Self
*------------------------------------------------------------------------------*





*------------------------------------------------------------------------------*
*S2100() Evento Cadastramento Inicial do Vínculo
* -----------------------------------------------------------------------------*
METHOD S2100() CLASS eSocial

::incluiTag(1,"evtCadInicial")
::incluiTag(1,"versao",::versao)      // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
::incluiTag(2,"idEvento","infEvento")       // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
::incluiTag(3,"indRetificacao","ideEvento") // E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo"," ideEvento")      // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"tpAmb"," ideEvento")         // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi"," ideEvento")       // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento"," ideEvento ")  //E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc"," ideEvento")       // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
::incluiTag(3,"tpInscricao","ideEmpregador")  // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp ) // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"trabalhador")
::incluiTag(3,"cpfTrab"," trabalhador")       // E N 1-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab"," trabalhador")       //E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"nomeTrab"," trabalhador")      //E C 1-1 080 - Nome do Trabalhador
::incluiTag(3,"sexo"," trabalhador")          //E C 1-1 001 - Sexo do Trabalhador:
::incluiTag(3,"racaCor"," trabalhador")       //E N 1-1 001 - Raça e cor do trabalhador, conforme tabela abaixo:
::incluiTag(3,"estadoCivil"," trabalhador"    //E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
::incluiTag(3,"grauInstrucao"," trabalhador") // E N 1-1 002 - Grau de instrução do trabalhador, conforme tabela:

::incluiTag(4,"nascimento")
::incluiTag(3,"dtNascto","nascimento")       // E D 1-1 010 - Preencher com a data de nascimento
::incluiTag(3,"codMunicipio"," nascimento")  // E N 0-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(3,"uf"," nascimento")            // E C 0-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(3,"paisNascto"," nascimento")    // E N 1-1 005 - Preencher com o código do país de nascimento do trabalhador,
::incluiTag(3,"paisNacionalidade"," nascimento") // E N 1-1 005 - Preencher com o código do país de nacionalidade do
::incluiTag(3,"nomeMae"," nascimento")       // E C 0-1 080 - Nome da mãe do trabalhador
::incluiTag(3,"nomePai"," nascimento")       // E C 0-1 080 - Nome do Pai do Trabalhador

::incluiTag(4,"/nascimento")
::incluiTag(4,"documentos")
::incluiTag(5,"CTPS")
::incluiTag(5,"nrCtps"," CTPS")    // E C 1-1 011 - Número da carteira de trabalho e Previdência Social do
::incluiTag(5,"serieCtps"," CTPS") // E C 1-1 004 - Número de série da CTPS.
::incluiTag(5,"ufCtps"," CTPS")    // E C 1-1 002 - UF da expedição da CTPS.

::incluiTag(5,"/CTPS")
::incluiTag(5,"RIC")
::incluiTag(5,"nrRic"," RIC")        // E N 1-1 014 - Número do RIC
::incluiTag(5,"orgaoEmissor"," RIC") // E C 1-1 020 - Órgão emissor do documento
::incluiTag(5,"dtExpedicao"," RIC")  // E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RIC")
::incluiTag(5,"RG")
::incluiTag(5,"nrRg"," RG")         // E C 1-1 014 - Número do RG
::incluiTag(5,"orgaoEmissor"," RG") // E C 1-1 020 - Órgão emissor do documento
::incluiTag(5,"dtExpedicao"," RG")  // E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RG")
::incluiTag(5,"RNE")
::incluiTag(5,"nrRne"," RNE")        // E C 1-1 014 - Número de inscrição no Registro Nacional de Estrangeiros
::incluiTag(5,"orgaoEmissor"," RNE") // E C 1-1 020 - Órgão emissor do documento
::incluiTag(5,"dtExpedicao","RNE")   // E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RNE")
::incluiTag(5,"OC")
::incluiTag(5,"nrOc"," OC")         // E C 1-1 014 - Número de Inscrição no Órgão de Classe
::incluiTag(5,"orgaoEmissor"," OC") // E C 1-1 020 - Órgão emissor do documento
::incluiTag(5,"dtExpedicao"," OC")  // E D 1-1 010 - Data da expedição do documento
::incluiTag(5,"dtValidade"," OC")   // E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(5,"/OC")
::incluiTag(5,"CNH")
::incluiTag(5,"nrCnh"," CNH")        // E N 1-1 014 - Número da CNH
::incluiTag(5,"orgaoEmissor"," CNH") // E C 1-1 020 - Órgão emissor do documento
::incluiTag(5,"dtExpedicao"," CNH")  // E D 1-1 010 - Data da expedição do documento
::incluiTag(5,"dtValidade"," CNH")   // E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(5,"/CNH")
::incluiTag(4,"/documentos")
::incluiTag(4,"endereco")
::incluiTag(5,"brasil")
::incluiTag(5,"tpLogradouro"," brasil")   // E C 1-1 010 - Tipo de Logradouro
::incluiTag(5,"descLogradouro"," brasil") // E C 1-1 080 - Descrição do logradouro
::incluiTag(5,"nrLogradouro"," brasil")   // E C 0-1 010 - Número do logradouro.
::incluiTag(5,"complemento"," brasil")    // E C 0-1 030 - Complemento do logradouro.
::incluiTag(5,"bairro"," brasil")         // E C 0-1 030 - Nome do bairro/distrito
::incluiTag(5,"cep"," brasil")            // E N 1-1 008 - Código de Endereçamento Postal
::incluiTag(5,"codMunicipio"," brasil")   // E N 1-1 007 - Preencher com o código do município, conforme tabela do
::incluiTag(5,"uf"," brasil")             // E C 1-1 002 - Preencher com a sigla da Unidade da Federação

::incluiTag(5,"/brasil")
::incluiTag(5,"exterior")
::incluiTag(5,"paisResidencia"," exterior") // E N 1-1 005 - Preencher com o código do país, conforme tabela de países da
::incluiTag(5,"descLogradouro"," exterior") // E C 1-1 080 - Descrição do logradouro
::incluiTag(5,"nrLogradouro"," exterior")   // E C 0-1 010 - Número do logradouro.
::incluiTag(5,"complemento"," exterior")    // E C 0-1 030 - Complemento do logradouro.
::incluiTag(5,"bairro"," exterior")         // E C 0-1 030 - Nome do bairro/distrito
::incluiTag(5,"nomeCidade"," exterior")     // E C 1-1 030 - Nome da Cidade
::incluiTag(5,"codPostal"," exterior")      // E C 0-1 010 - Código de Endereçamento Postal

::incluiTag(5,"/exterior")
::incluiTag(4,"/endereco")
::incluiTag(4,"infoCasaPropria")
::incluiTag(4,"residenciaPropria"," infoCasaPropria") // E C 1-1 001 - indicar se a residência pertence ao trabalhador
::incluiTag(4,"recursoFGTS"," infoCasaPropria")       // E C 0-1 001 - Indicar se foi adquirido o imóvel próprio foi adquirido com

::incluiTag(4,"/infoCasaPropria")
::incluiTag(4,"trabEstrangeiro")
::incluiTag(4,"dtChegada"," trabEstrangeiro")       // E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
::incluiTag(4,"dtNaturalizacao"," trabEstrangeiro") // E D 0-1 010 - Data de naturalização brasileira em caso de estrangeiro
::incluiTag(4,"casadoBr"," trabEstrangeiro")        // E C 1-1 001 - Condição de casado com brasileiro(s) em caso de trabalhador
::incluiTag(4,"filhosBr"," trabEstrangeiro")        // E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,

::incluiTag(4,"/trabEstrangeiro")
::incluiTag(4,"infBancarias")
::incluiTag(4,"banco"," infBancarias")           // E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
::incluiTag(4,"agencia"," infBancarias")         // E C 0-1 015 - Preencher com o código da agência, no caso de depósito
::incluiTag(4,"tpContaBancaria"," infBancarias") // E N 1-1 001 - Tipo de Conta:
::incluiTag(4,"nrContaBancaria"," infBancarias") // E C 1-1 020 - Número da Conta Bancária

::incluiTag(4,"/infBancarias")
::incluiTag(4,"infoDeficiencia")
::incluiTag(4,"defMotora"," infoDeficiencia")    // E C 1-1 001 - Indicar se o trabalhador possui deficiência motora.
::incluiTag(4,"defVisual"," infoDeficiencia")    // E C 1-1 001 - Indicar se o trabalhador possui deficiência visual
::incluiTag(4,"defAuditiva"," infoDeficiencia")  // E C 1-1 001 - Indicar se o trabalhador possui deficiência auditiva.
::incluiTag(4,"reabilitado"," infoDeficiencia")  // E C 1-1 001 - Informar se o trabalhador é reabilitado.
::incluiTag(4,"observacao"," infoDeficiencia")   // E C 0-1 255 - Observação

::incluiTag(4,"/infoDeficiencia")
::incluiTag(4,"dependente")
::incluiTag(4,"tpDep"," dependente")    // E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
::incluiTag(4,"nomeDep"," dependente")  // E C 1-1 080 - Nome do Dependente
::incluiTag(4,"dtNascto"," dependente") // E D 1-1 010 - Preencher com a data de nascimento
::incluiTag(4,"cpfDep"," dependente")   // E N 0-1 011 - Número de Inscrição no CPF
::incluiTag(4,"depIRRF"," dependente")  // E C 1-1 001 - Informar se é dependente para fins de dedução do IRRF.
::incluiTag(4,"depSF"," dependente")    // E C 1-1 001 - Informar se é dependente para fins de recebimento do benefício

::incluiTag(4,"/dependente")
::incluiTag(4,"contato")
::incluiTag(4,"fonePrincipal"," contato")    // E N 0-1 012 - Número de telefone do trabalhador
::incluiTag(4,"foneAlternativo"," contato")  // E N 0-1 012 - Número de telefone do trabalhador
::incluiTag(4,"emailPrincipal"," contato")   // E C 0-1 060 - Endereço eletrônico
::incluiTag(4,"emailAlternativo"," contato") // E C 0-1 060 - Endereço eletrônico

::incluiTag(4,"/contato")
::incluiTag(3,"/trabalhador")
::incluiTag(3,"vinculo")
::incluiTag(4,"matricula"," vinculo")   // E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(4,"dtAdmissao"," vinculo")  // E D 1-1 010 - Preencher com a data de admissão do trabalhador no respectivo
::incluiTag(4,"tpAdmissao"," vinculo")  // E N 1-1 001 - Tipo de admissão do trabalhador, conforme tabela abaixo:
::incluiTag(4,"indAdmissao"," vinculo") // E N 1-1 001 - Indicativo de Admissão:
::incluiTag(4,"indPrimeiroEmprego"," vinculo") // E C 1-1 001 - Indicar se trata-se do primeiro emprego do trabalhador.

::incluiTag(4,"contrato")
::incluiTag(4,"tpRegimeTrab"," contrato") // E N 1-1 001 - Tipo de regime trabalhista
::incluiTag(4,"tpRegimePrev"," contrato") // E N 1-1 001 - Tipo de regime previdenciário conforme tabela abaixo:
::incluiTag(4,"natAtividade"," contrato") // E N 1-1 001 - Tipo de vínculo trabalhista, conforme tabela abaixo:
::incluiTag(4,"codCateg"," contrato")     // E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(4,"codCargo"," contrato")     // E C 1-1 030 - Preencher com o código do cargo
::incluiTag(4,"codFuncao"," contrato")    // E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa

::incluiTag(5,"remuneracao")
::incluiTag(5,"vlrSalFixo"," remuneracao  ") //E N 1-1 14 2 Salário fixo do trabalhador, correspondente à parte fixa da
::incluiTag(5,"unidSalFixo"," remuneracao ") //E N 1-1 001 - Unidade de pagamento da parte fixa da remuneração, conforme
::incluiTag(5,"vlrSalVariavel"," remuneracao  ") //E N 0-1 14 2 Salário variável do trabalhador. Corresponde à parte variável da
::incluiTag(5,"unidSalVariavel"," remuneracao ") //E N 0-1 001 - Unidade de pagamento da parte variável da remuneração,

::incluiTag(5,"/remuneracao")
::incluiTag(5,"duracao")
::incluiTag(5,"tpContrato"," duracao") // E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
::incluiTag(5,"dtTermino"," duracao")  // E D 0-1 010 - Data do Término

::incluiTag(5,"/duracao")
::incluiTag(5,"localTrabalho")
::incluiTag(5,"tpInscricao"," localTrabalho ") //E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(5,"nrInscricao"," localTrabalho ") //E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(5,"codLotacao ","localTrabalho  ") //E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
::incluiTag(5,"descComplementar"," localTrabalho ") //E C 0-1 080 - Descrição complementar do local de trabalho.

::incluiTag(5,"/localTrabalho")
::incluiTag(4,"/contrato")
::incluiTag(5,"jornada")
::incluiTag(6,"jornadaPadrao")
::incluiTag(6,"qtdHoras"," jornadaPadrao") // E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
::incluiTag(6,"codJornadaSegSexta"," jornadaPadrao") // E C 1-1 030 - Código do horário de segunda a sexta
::incluiTag(6,"codJornadaSab"," jornadaPadrao") // E C 0-1 030 - Código do horário relativo ao sábado

::incluiTag(6,"/jornadaPadrao")
::incluiTag(6,"jornadaTurnoFixo")
::incluiTag(6,"qtdHoras"," jornadaTurnoFixo")      // E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
::incluiTag(6,"codJornadaSeg"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo à segunda-feira
::incluiTag(6,"codJornadaTer"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo à terça-feira
::incluiTag(6,"codJornadaQua"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo à quarta-feira
::incluiTag(6,"codJornadaQui"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo à quinta-feira
::incluiTag(6,"codJornadaSex"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo à sexta-feira
::incluiTag(6,"codJornadaSab"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo ao sábado
::incluiTag(6,"codJornadaDom"," jornadaTurnoFixo") // E C 0-1 030 - Código do horário relativo ao domingo

::incluiTag(6,"/jornadaTurnoFixo")
::incluiTag(6,"jornadaTurnoFlexivel")
::incluiTag(6,"turno"," jornadaTurnoFlexivel") // E N 1-1 001 - Sequencial de identificação do turno
::incluiTag(6,"codJornada"," jornadaTurnoFlexivel") // E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaTurnoFlexivel")
::incluiTag(6,"jornadaEspecial")
::incluiTag(6,"tpEscala"," jornadaEspecial") // E N 1-1 002 - Tipo de Escala:
::incluiTag(6,"qtdHoras"," jornadaEspecial") // E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
::incluiTag(6,"codJornada"," jornadaEspecial") // E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaEspecial")
::incluiTag(5,"/jornada")
::incluiTag(5,"filiacaoSindical")
::incluiTag(5,"cnpjSindTrabalhador"," filiacaoSindical") // E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador

::incluiTag(5,"/filiacaoSindical")
::incluiTag(5,"alvaraJudicial")
::incluiTag(5,"nrProcJud"," alvaraJudicial") // E C 1-1 020 - Preencher com o número do processo judicial.

::incluiTag(5,"/alvaraJudicial")
::incluiTag(4,"FGTS")
::incluiTag(4,"optanteFGTS","FGTS") // E N 1-1 001 - Informar a opção pelo FGTS
::incluiTag(4,"dtOpcaoFGTS","FGTS") // E D 0-1 010 - Informar a data de opção pelo FGTS do trabalhador

::incluiTag(4,"/FGTS")
::incluiTag(4,"sucessaoVinc")
::incluiTag(4,"cnpjEmpregadorAnterior"," sucessaoVinc") // E N 1-1 014 - Preencher com o número do CNPJ do empregador anterior
::incluiTag(4,"matriculaAnterior"," sucessaoVinc")      // E C 1-1 030 - Matrícula do trabalhador na empresa que deu origem ao vínculo
::incluiTag(4,"dtInicioVinculo"," sucessaoVinc")        // E D 1-1 010 - Data de início do vínculo trabalhista.
::incluiTag(4,"observacao"," sucessaoVinc")             // E C 0-1 255 - Observação

::incluiTag(4,"/sucessaoVinc")
::incluiTag(4,"cessaoTrab")
::incluiTag(4,"cnpjCedente"," cessaoTrab") // E N 1-1 014 - Informar o CNPJ da empresa cedente
::incluiTag(4,"matriculaCedente"," cessaoTrab  ") //E C 1-1 030 - Preencher com a matrícula do trabalhador na empresa de
::incluiTag(4,"dtAdmissaoCedente"," cessaoTrab ") //E D 1-1 010 - Preencher com a data de admissão do trabalhador na
::incluiTag(4,"infoOnus"," cessaoTrab") // E N 1-1 001 - Informar se o trabalhador foi cedido com ônus ou sem ônus

::incluiTag(4,"/cessaoTrab")
::incluiTag(4,"ASO")
::incluiTag(4,"dtAso"," ASO ") //E D 1-1 010 - Data do Atestado de Saúde Ocupacional.

::incluiTag(5,"medico")
::incluiTag(5,"nomeMedico"," medico") // E C 1-1 080 - Preencher com o nome do médico encarregado do exame

::incluiTag(6,"crm")
::incluiTag(5,"nrCRM"," crm") // E C 1-1 008 - Número de inscrição do médico encarregado do exame no
::incluiTag(5,"ufCRM"," crm") // E C 1-1 002 - Preencher com a sigla da UF de expedição do CRM.

::incluiTag(6,"/crm")
::incluiTag(5,"/medico")
::incluiTag(5,"exame")
::incluiTag(5,"dtExame"," exame ")  //E D 1-1 010 - Data do exame realizado
::incluiTag(5,"descExame"," exame") // E C 1-1 080 - Informar a descrição do exame realizado (ex: RX Tórax,
::incluiTag(5,"/exame")
::incluiTag(4,"/ASO")
::incluiTag(3,"/vinculo")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtCadInicial")

RETURN Self
*------------------------------------------------------------------------------*





*------------------------------------------------------------------------------*
*S2200() //Evento Admissão
* -----------------------------------------------------------------------------*
METHOD S2200() CLASS eSocial

::incluiTag(1,"evtAdmissao")
* 2 versao ",::versao) // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"trabalhador")
* 16 cpfTrab trabalhador E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab trabalhador E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 nomeTrab trabalhador E C 1-1 080 - Nome do Trabalhador
* 19 sexo trabalhador E C 1-1 001 - Sexo do Trabalhador:
* 20 racaCor trabalhador E N 1-1 001 - Raça e cor do trabalhador, conforme tabela abaixo:
* 21 estadoCivil trabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 22 grauInstrucao trabalhador E N 1-1 002 - Grau de instrução do trabalhador, conforme tabela:

::incluiTag(4,"nascimento")
* 24 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 25 codMunicipio nascimento E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 26 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federação
* 27 paisNascto nascimento E N 1-1 005 - Preencher com o código do país de nascimento do trabalhador,
* 28 paisNacionalidade nascimento E N 1-1 005 - Preencher com o código do país de nacionalidade do
* 29 nomeMae nascimento E C 0-1 080 - Nome da mãe do trabalhador
* 30 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador

::incluiTag(4,"/nascimento")
::incluiTag(4,"documentos")
::incluiTag(5,"CTPS")
* 33 nrCtps CTPS E C 1-1 011 - Número da carteira de trabalho e Previdência Social do
* 34 serieCtps CTPS E C 1-1 004 - Número de série da CTPS.
* 35 ufCtps CTPS E C 1-1 002 - UF da expedição da CTPS.

::incluiTag(5,"/CTPS")
::incluiTag(5,"RIC")
* 37 nrRic RIC E N 1-1 014 - Número do RIC
* 38 orgaoEmissor RIC E C 1-1 020 - Órgão emissor do documento
* 39 dtExpedicao RIC E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RIC")
::incluiTag(5,"RG")
* 41 nrRg RG E C 1-1 014 - Número do RG
* 42 orgaoEmissor RG E C 1-1 020 - Órgão emissor do documento
* 43 dtExpedicao RG E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RG")
::incluiTag(5,"RNE")
* 45 nrRne RNE E C 1-1 014 - Número de inscrição no Registro Nacional de Estrangeiros
* 46 orgaoEmissor RNE E C 1-1 020 - Órgão emissor do documento
* 47 dtExpedicao RNE E D 1-1 010 - Data da expedição do documento

::incluiTag(5,"/RNE")
::incluiTag(5,"OC")
* 49 nrOc OC E C 1-1 014 - Número de Inscrição no Órgão de Classe
* 50 orgaoEmissor OC E C 1-1 020 - Órgão emissor do documento
* 51 dtExpedicao OC E D 1-1 010 - Data da expedição do documento
* 52 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(5,"/OC")
::incluiTag(5,"CNH")
* 54 nrCnh CNH E N 1-1 014 - Número da CNH
* 55 orgaoEmissor CNH E C 1-1 020 - Órgão emissor do documento
* 56 dtExpedicao CNH E D 1-1 010 - Data da expedição do documento
* 57 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(5,"/CNH")
::incluiTag(4,"/documentos")
::incluiTag(4,"endereco")
::incluiTag(5,"brasil")
* 60 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 61 descLogradouro brasil E C 1-1 080 - Descrição do logradouro
* 62 nrLogradouro brasil E C 0-1 010 - Número do logradouro.
* 63 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 64 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 65 cep brasil E N 1-1 008 - Código de Endereçamento Postal
* 66 codMunicipio brasil E N 1-1 007 - Preencher com o código do município, conforme tabela do
* 67 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federação

::incluiTag(5,"/brasil")
::incluiTag(5,"exterior")
* 69 paisResidencia exterior E N 1-1 005 - Preencher com o código do país, conforme tabela de países da
* 70 descLogradouro exterior E C 1-1 080 - Descrição do logradouro
* 71 nrLogradouro exterior E C 0-1 010 - Número do logradouro.
* 72 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 73 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 74 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 75 codPostal exterior E C 0-1 010 - Código de Endereçamento Postal

::incluiTag(5,"/exterior")
::incluiTag(4,"/endereco")
::incluiTag(4,"infoCasaPropria")
* 77 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a residência pertence ao trabalhador
* 78 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o imóvel próprio foi adquirido com

::incluiTag(4,"/infoCasaPropria")
::incluiTag(4,"trabEstrangeiro")
* 80 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 81 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturalização brasileira em caso de estrangeiro
* 82 casadoBr trabEstrangeiro E C 1-1 001 - Condição de casado com brasileiro(s) em caso de trabalhador
* 83 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,

::incluiTag(4,"/trabEstrangeiro")
::incluiTag(4,"infBancarias")
* 85 banco infBancarias E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
* 86 agencia infBancarias E C 0-1 015 - Preencher com o código da agência, no caso de depósito
* 87 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 88 nrContaBancaria infBancarias E C 1-1 020 - Número da Conta Bancária

::incluiTag(4,"/infBancarias")
::incluiTag(4,"infoDeficiencia")
* 90 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência motora.
* 91 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência visual
* 92 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência auditiva.
* 93 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador é reabilitado.
* 94 observacao infoDeficiencia E C 0-1 255 - Observação

::incluiTag(4,"/infoDeficiencia")
::incluiTag(4,"dependente")
* 96 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 97 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 98 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 99 cpfDep dependente E N 0-1 011 - Número de Inscrição no CPF
* 100 depIRRF dependente E C 1-1 001 - Informar se é dependente para fins de dedução do IRRF.
* 101 depSF dependente E C 1-1 001 - Informar se é dependente para fins de recebimento do benefício

::incluiTag(4,"/dependente")
::incluiTag(4,"contato")
* 103 fonePrincipal contato E N 0-1 012 - Número de telefone do trabalhador
* 104 foneAlternativo contato E N 0-1 012 - Número de telefone do trabalhador
* 105 emailPrincipal contato E C 0-1 060 - Endereço eletrônico
* 106 emailAlternativo contato E C 0-1 060 - Endereço eletrônico

::incluiTag(4,"/contato")
::incluiTag(3,"/trabalhador")
::incluiTag(3,"vinculo")
* 108 matricula vinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
* 109 dtAdmissao vinculo E D 1-1 010 - Preencher com a data de admissão do trabalhador no respectivo
* 110 tpAdmissao vinculo E N 1-1 001 - Tipo de admissão do trabalhador, conforme tabela abaixo:
* 111 indAdmissao vinculo E N 1-1 001 - Indicativo de Admissão:
* 112 indPrimeiroEmprego vinculo E C 1-1 001 - Indicar se trata-se do primeiro emprego do trabalhador.

::incluiTag(4,"infoContrato")
* 114 tpRegimeTrab infoContrato E N 1-1 001 - Tipo de regime trabalhista
* 115 tpRegimePrev infoContrato E N 1-1 001 - Tipo de regime previdenciário conforme tabela abaixo:
* 116 natAtividade infoContrato E N 1-1 001 - Tipo de vínculo trabalhista, conforme tabela abaixo:
* 117 codCateg infoContrato E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 118 codCargo infoContrato E C 1-1 030 - Preencher com o código do cargo
* 119 codFuncao infoContrato E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa

::incluiTag(5,"remuneracao")
* 121 vlrSalFixo remuneracao E N 1-1 14 2 Salário fixo do trabalhador, correspondente à parte fixa da
* 122 unidSalFixo remuneracao E N 1-1 001 - Unidade de pagamento da parte fixa da remuneração, conforme
* 123 vlrSalVariavel remuneracao E N 0-1 14 2 Salário variável do trabalhador. Corresponde à parte variável da
* 124 unidSalVariavel remuneracao E N 0-1 001 - Unidade de pagamento da parte variável da remuneração,

::incluiTag(5,"/remuneracao")
::incluiTag(5,"duracao")
* 126 tpContrato duracao E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
* 127 dtTermino duracao E D 0-1 010 - Data do Término

::incluiTag(5,"/duracao")
::incluiTag(5,"localTrabalho")
* 129 tpInscricao localTrabalho E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 130 nrInscricao localTrabalho E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
* 131 codLotacao localTrabalho E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
* 132 descComplementar localTrabalho E C 0-1 080 - Descrição complementar do local de trabalho.

::incluiTag(5,"/localTrabalho")
::incluiTag(5,"jornada")
::incluiTag(6,"jornadaPadrao")
* 135 qtdHoras jornadaPadrao E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 136 codJornadaSegSexta jornadaPadrao E C 1-1 030 - Código do horário de segunda a sexta
* 137 codJornadaSab jornadaPadrao E C 0-1 030 - Código do horário relativo ao sábado

::incluiTag(6,"/jornadaPadrao")
::incluiTag(6,"jornadaTurnoFixo")
* 139 qtdHoras jornadaTurnoFixo E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 140 codJornadaSeg jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à segunda-feira
* 141 codJornadaTer jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à terça-feira
* 142 codJornadaQua jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à quarta-feira
* 143 codJornadaQui jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à quinta-feira
* 144 codJornadaSex jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à sexta-feira
* 145 codJornadaSab jornadaTurnoFixo E C 0-1 030 - Código do horário relativo ao sábado
* 146 codJornadaDom jornadaTurnoFixo E C 0-1 030 - Código do horário relativo ao domingo

::incluiTag(6,"/jornadaTurnoFixo")
::incluiTag(6,"jornadaTurnoFlexivel")
* 148 turno jornadaTurnoFlexivel E N 1-1 001 - Sequencial de identificação do turno
* 149 codJornada jornadaTurnoFlexivel E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaTurnoFlexivel")
::incluiTag(6,"jornadaEspecial")
* 151 tpEscala jornadaEspecial E N 1-1 002 - Tipo de Escala:
* 152 qtdHoras jornadaEspecial E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 153 codJornada jornadaEspecial E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaEspecial")
::incluiTag(5,"/jornada")
::incluiTag(5,"filiacaoSindical")
* 155 cnpjSindTrabalhador filiacaoSindical E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador

::incluiTag(5,"/filiacaoSindical")
::incluiTag(5,"alvaraJudicial")
* 157 nrProcJud alvaraJudicial E C 1-1 020 - Preencher com o número do processo judicial.

::incluiTag(5,"/alvaraJudicial")
::incluiTag(4,"/infoContrato")
::incluiTag(4,"FGTS")
* 159 optanteFGTS FGTS E N 1-1 001 - Informar a opção pelo FGTS
* 160 dtOpcaoFGTS FGTS E D 0-1 010 - Informar a data de opção pelo FGTS do trabalhador

::incluiTag(4,"/FGTS")
::incluiTag(4,"sucessaoVinc")
* 162 cnpjEmpregadorAnterior sucessaoVinc E N 1-1 014 - Preencher com o número do CNPJ do empregador anterior
* 163 matriculaAnterior sucessaoVinc E C 1-1 030 - Matrícula do trabalhador na empresa que deu origem ao vínculo
* 164 dtInicioVinculo sucessaoVinc E D 1-1 010 - Data de início do vínculo trabalhista.
* 165 observacao sucessaoVinc E C 0-1 255 - Observação

::incluiTag(4,"/sucessaoVinc")
::incluiTag(4,"cessaoTrab")
* 167 cnpjCedente cessaoTrab E N 1-1 014 - Informar o CNPJ da empresa cedente
* 168 matriculaCedente cessaoTrab E C 1-1 030 - Preencher com a matrícula do trabalhador na empresa de
* 169 dtAdmissaoCedente cessaoTrab E D 1-1 010 - Preencher com a data de admissão do trabalhador na
* 170 infoOnus cessaoTrab E N 1-1 001 - Informar se o trabalhador foi cedido com ônus ou sem ônus

::incluiTag(4,"/cessaoTrab")
::incluiTag(4,"ASO")
* 172 dtAso ASO E D 1-1 010 - Data do Atestado de Saúde Ocupacional.
* 173 medico ASO G - 1-1 - - Médico responsável

::incluiTag(5,"medico")
* 174 nomeMedico medico E C 1-1 080 - Preencher com o nome do médico encarregado do exame

::incluiTag(6,"crm")
* 176 nrCRM crm E C 1-1 008 - Número de inscrição do médico encarregado do exame no
* 177 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedição do CRM.

::incluiTag(6,"/crm")
::incluiTag(5,"/medico")
::incluiTag(5,"exame")
* 179 dtExame exame E D 1-1 010 - Data do exame realizado
* 180 descExame exame E C 1-1 080 - Informar a descrição do exame realizado (ex: RX Tórax,
::incluiTag(5,"/exame")
::incluiTag(4,"/ASO")
::incluiTag(3,"/vinculo")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAdmissao")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2220() Alteração de Dados Cadastrais
* -----------------------------------------------------------------------------*
METHOD S2220() CLASS eSocial

::incluiTag(1,"evtAltCadastral")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"alteracao")
* 16 dtAlteracao alteracao E D 1-1 010 - Preencher com a data da alteração das informações
* 17 dadosTrabalhador alteracao G - 1-1 - - Dados Cadastrais

::incluiTag(4,"dadosTrabalhador")
* 18 cpfTrab dadosTrabalhador E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 19 nisTrab dadosTrabalhador E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 20 nomeTrab dadosTrabalhador E C 1-1 080 - Nome do Trabalhador
* 21 sexo dadosTrabalhador E C 1-1 001 - Sexo do Trabalhador:
* 22 racaCor dadosTrabalhador E N 1-1 001 - Raça e cor do trabalhador, conforme tabela abaixo:
* 23 estadoCivil dadosTrabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 24 grauInstrucao dadosTrabalhador E N 1-1 002 - Grau de instrução do trabalhador, conforme tabela:
* 25 nascimento dadosTrabalhador G - 1-1 - - Grupo de informações do nascimento do trabalhador

::incluiTag(5,"nascimento")
* 26 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 27 codMunicipio nascimento E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 28 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federação
* 29 paisNascto nascimento E N 1-1 005 - Preencher com o código do país de nascimento do trabalhador,
* 30 paisNacionalidade nascimento E N 1-1 005 - Preencher com o código do país de nacionalidade do
* 31 nomeMae nascimento E C 0-1 080 - Nome da mãe do trabalhador
* 32 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador

::incluiTag(5,"/nascimento")
::incluiTag(4,"/dadosTrabalhador")
::incluiTag(5,"documentos")
::incluiTag(6,"CTPS")
* 35 nrCtps CTPS E C 1-1 011 - Número da carteira de trabalho e Previdência Social do
* 36 serieCtps CTPS E C 1-1 004 - Número de série da CTPS.
* 37 ufCtps CTPS E C 1-1 002 - UF da expedição da CTPS.

::incluiTag(6,"/CTPS")
::incluiTag(6,"RIC")
* 39 nrRic RIC E N 1-1 014 - Número do RIC
* 40 orgaoEmissor RIC E C 1-1 020 - Órgão emissor do documento
* 41 dtExpedicao RIC E D 1-1 010 - Data da expedição do documento

::incluiTag(6,"/RIC")
::incluiTag(6,"RG")
* 43 nrRg RG E C 1-1 014 - Número do RG
* 44 orgaoEmissor RG E C 1-1 020 - Órgão emissor do documento
* 45 dtExpedicao RG E D 1-1 010 - Data da expedição do documento

::incluiTag(6,"/RG")
::incluiTag(6,"RNE")
* 47 nrRne RNE E C 1-1 014 - Número de inscrição no Registro Nacional de Estrangeiros
* 48 orgaoEmissor RNE E C 1-1 020 - Órgão emissor do documento
* 49 dtExpedicao RNE E D 1-1 010 - Data da expedição do documento

::incluiTag(6,"/RNE")
::incluiTag(6,"OC")
* 51 nrOc OC E C 1-1 014 - Número de Inscrição no Órgão de Classe
* 52 orgaoEmissor OC E C 1-1 020 - Órgão emissor do documento
* 53 dtExpedicao OC E D 1-1 010 - Data da expedição do documento
* 54 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(6,"/OC")
::incluiTag(6,"CNH")
* 56 nrCnh CNH E N 1-1 014 - Número da CNH
* 57 orgaoEmissor CNH E C 1-1 020 - Órgão emissor do documento
* 58 dtExpedicao CNH E D 1-1 010 - Data da expedição do documento
* 59 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.

::incluiTag(6,"/CNH")
::incluiTag(5,"/documentos")
::incluiTag(5,"endereco")
::incluiTag(6,"brasil")
* 62 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 63 descLogradouro brasil E C 1-1 080 - Descrição do logradouro
* 64 nrLogradouro brasil E C 0-1 010 - Número do logradouro.
* 65 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 66 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 67 cep brasil E N 1-1 008 - Código de Endereçamento Postal
* 68 codMunicipio brasil E N 1-1 007 - Preencher com o código do município, conforme tabela do
* 69 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federação

::incluiTag(6,"/brasil")
::incluiTag(6,"exterior")
* 71 paisResidencia exterior E N 1-1 005 - Preencher com o código do país, conforme tabela de países da
* 72 descLogradouro exterior E C 1-1 080 - Descrição do logradouro
* 73 nrLogradouro exterior E C 0-1 010 - Número do logradouro.
* 74 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 75 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 76 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 77 codPostal exterior E C 0-1 010 - Código de Endereçamento Postal

::incluiTag(6,"/exterior")
::incluiTag(5,"/endereco")
::incluiTag(5,"infoCasaPropria")
* 79 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a residência pertence ao trabalhador
* 80 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o imóvel próprio foi adquirido com

::incluiTag(5,"/infoCasaPropria")
::incluiTag(5,"trabEstrangeiro")
* 82 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 83 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturalização brasileira em caso de estrangeiro
* 84 casadoBr trabEstrangeiro E C 1-1 001 - Condição de casado com brasileiro(s) em caso de trabalhador
* 85 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,

::incluiTag(5,"/trabEstrangeiro")
::incluiTag(5,"infBancarias")
* 87 banco infBancarias E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
* 88 agencia infBancarias E C 0-1 015 - Preencher com o código da agência, no caso de depósito
* 89 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 90 nrContaBancaria infBancarias E C 1-1 020 - Número da Conta Bancária

::incluiTag(5,"/infBancarias")
::incluiTag(5,"infoDeficiencia")
* 92 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência motora.
* 93 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência visual
* 94 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência auditiva.
* 95 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador é reabilitado.
* 96 observacao infoDeficiencia E C 0-1 255 - Observação

::incluiTag(5,"/infoDeficiencia")
::incluiTag(5,"dependente")
* 98 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 99 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 100 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 101 cpfDep dependente E N 0-1 011 - Número de Inscrição no CPF
* 102 depIRRF dependente E C 1-1 001 - Informar se é dependente para fins de dedução do IRRF.
* 103 depSF dependente E C 1-1 001 - Informar se é dependente para fins de recebimento do benefício

::incluiTag(5,"/dependente")
::incluiTag(5,"contato")
* 105 fonePrincipal contato E N 0-1 012 - Número de telefone do trabalhador
* 106 foneAlternativo contato E N 0-1 012 - Número de telefone do trabalhador
* 107 emailPrincipal contato E C 0-1 060 - Endereço eletrônico
* 108 emailAlternativo contato E C 0-1 060 - Endereço eletrônico

::incluiTag(5,"/contato")
::incluiTag(3,"/alteracao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAltCadastral")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2240() Alteração Contratual
* -----------------------------------------------------------------------------*
METHOD S2240() CLASS eSocial

::incluiTag(1,"evtAltContratual")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa

::incluiTag(3,"/ideVinculo")
::incluiTag(3,"altContratual")
* 20 dtAlteracao altContratual E D 1-1 010 - Preencher com a data da alteração das informações
* 21 infoContrato altContratual G - 1-1 - - Informações do Contrato de Trabalho

::incluiTag(4,"infoContrato")
* 22 tpRegimeTrab infoContrato E N 1-1 001 - Tipo de regime trabalhista
* 23 tpRegimePrev infoContrato E N 1-1 001 - Tipo de regime previdenciário conforme tabela abaixo:
* 24 natAtividade infoContrato E N 1-1 001 - Tipo de vínculo trabalhista, conforme tabela abaixo:
* 25 codCateg infoContrato E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 26 codCargo infoContrato E C 1-1 030 - Preencher com o código do cargo
* 27 codFuncao infoContrato E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa

::incluiTag(5,"remuneracao")
* 29 vlrSalFixo remuneracao E N 1-1 14 2 Salário fixo do trabalhador, correspondente à parte fixa da
* 30 unidSalFixo remuneracao E N 1-1 001 - Unidade de pagamento da parte fixa da remuneração, conforme
* 31 vlrSalVariavel remuneracao E N 0-1 14 2 Salário variável do trabalhador. Corresponde à parte variável da
* 32 unidSalVariavel remuneracao E N 0-1 001 - Unidade de pagamento da parte variável da remuneração,

::incluiTag(5,"/remuneracao")
::incluiTag(5,"duracao")
* 34 tpContrato duracao E N 1-1 001 - Tipo de contrato de trabalho conforme tabela abaixo:
* 35 dtTermino duracao E D 0-1 010 - Data do Término

::incluiTag(5,"/duracao")
::incluiTag(5,"localTrabalho")
* 37 tpInscricao localTrabalho E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 38 nrInscricao localTrabalho E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
* 39 codLotacao localTrabalho E C 1-1 030 - Informar o código atribuído pela empresa para a lotação
* 40 descComplementar localTrabalho E C 0-1 080 - Descrição complementar do local de trabalho.

::incluiTag(5,"/localTrabalho")
::incluiTag(5,"jornada")
::incluiTag(6,"jornadaPadrao")
* 43 qtdHoras jornadaPadrao E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 44 codJornadaSegSexta jornadaPadrao E C 1-1 030 - Código do horário de segunda a sexta
* 45 codJornadaSab jornadaPadrao E C 0-1 030 - Código do horário relativo ao sábado

::incluiTag(6,"/jornadaPadrao")
::incluiTag(6,"jornadaTurnoFixo")
* 47 qtdHoras jornadaTurnoFixo E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 48 codJornadaSeg jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à segunda-feira
* 49 codJornadaTer jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à terça-feira
* 50 codJornadaQua jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à quarta-feira
* 51 codJornadaQui jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à quinta-feira
* 52 codJornadaSex jornadaTurnoFixo E C 0-1 030 - Código do horário relativo à sexta-feira
* 53 codJornadaSab jornadaTurnoFixo E C 0-1 030 - Código do horário relativo ao sábado
* 54 codJornadaDom jornadaTurnoFixo E C 0-1 030 - Código do horário relativo ao domingo

::incluiTag(6,"/jornadaTurnoFixo")
::incluiTag(6,"jornadaTurnoFlexivel")
* 56 turno jornadaTurnoFlexivel E N 1-1 001 - Sequencial de identificação do turno
* 57 codJornada jornadaTurnoFlexivel E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaTurnoFlexivel")
::incluiTag(6,"jornadaEspecial")
* 59 tpEscala jornadaEspecial E N 1-1 002 - Tipo de Escala:
* 60 qtdHoras jornadaEspecial E N 0-1 002 - Quantidade/Média de horas relativas a jornada semanal do
* 61 codJornada jornadaEspecial E C 1-1 030 - Preencher com o código atribuído pelo empresa para a jornada

::incluiTag(6,"/jornadaEspecial")
::incluiTag(5,"/jornada")
::incluiTag(5,"filiacaoSindical")
* 63 cnpjSindTrabalhador filiacaoSindical E N 1-1 014 - preencher com o CNPJ do sindicado ao qual o trabalhador

::incluiTag(5,"/filiacaoSindical")
::incluiTag(5,"alvaraJudicial")
* 65 nrProcJud alvaraJudicial E C 1-1 020 - Preencher com o número do processo judicial.

::incluiTag(5,"/alvaraJudicial")
::incluiTag(4,"/infoContrato")
::incluiTag(3,"/altContratual")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAltContratual")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2260() Comunicação de Acidente de Trabalho
* -----------------------------------------------------------------------------*
METHOD S2260() CLASS eSocial

::incluiTag(1,"evtCAT")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideTrabalhador")
* 16 cpfTrab ideTrabalhador E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 infoAdicionais ideTrabalhador G - 0-1 - - Registro preenchido exclusivamente em caso de acidente

::incluiTag(4,"infoAdicionais")
* 18 codCateg infoAdicionais E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 19 nomeTrab infoAdicionais E C 1-1 080 - Nome do Trabalhador
* 20 nisTrab infoAdicionais E N 0-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 21 dtNascto infoAdicionais E D 1-1 010 - Preencher com a data de nascimento
* 22 codCargo infoAdicionais E C 1-1 030 - Preencher com o código do cargo

::incluiTag(4,"/infoAdicionais")
::incluiTag(3,"/ideTrabalhador")
::incluiTag(3,"cat")
* 24 dtAcidente cat E D 1-1 010 - Data do Acidente
* 25 horaAcidente cat E N 1-1 004 - Hora do Acidente
* 26 horasTrabAntesAcidente cat E N 1-1 004 - Horas trabalhadas antes do acidente
* 27 tpAcidente cat E N 1-1 001 - Tipo de Acidente de Trabalho, conforme tabela abaixo:
* 28 tpCat cat E N 1-1 001 - Tipo de CAT, conforme tabela abaixo:
* 29 indCatParcial cat E C 1-1 001 - Indicar se trata-se de CAT parcial ou não.
* 30 indCatObito cat E C 1-1 001 - Indicar se houve óbito do trabalhador
* 31 indComunicPolicia cat E C 1-1 001 - Houve comunicação à autoridade policial:
* 32 codSitGeradora cat E N 0-1 009 - preencher com o código da situação geradora do acidente,

::incluiTag(4,"localAcidente")
* 34 tpLocal localAcidente E N 1-1 001 - Tipo do Local do acidente:
* 35 descLocal localAcidente E C 0-1 080 - Especificação do local do acidente (pátio, rampa de acesso,
* 36 descLogradouro localAcidente E C 0-1 080 - Descrição do logradouro
* 37 nrLogradouro localAcidente E C 0-1 010 - Número do logradouro.
* 38 codMunicipio localAcidente E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 39 uf localAcidente E C 0-1 002 - Preencher com a sigla da Unidade da Federação
* 40 cnpjLocalAcidente localAcidente E N 0-1 014 - Deve ser preenchido quando o acidente ou doença ocupacional

::incluiTag(4,"/localAcidente")
::incluiTag(4,"parteAtingida")
* 42 codParteAtingida parteAtingida E N 1-1 009 - Preencher com o código correspondente a parte atingida,

::incluiTag(4,"/parteAtingida")
::incluiTag(4,"agenteCausador")
* 44 codAgenteCausador agenteCausador E N 1-1 009 - Preencher com o código correspondente ao agente causador do

::incluiTag(4,"/agenteCausador")
::incluiTag(4,"testemunhas")
* 46 nomeTestemunha testemunhas E C 1-1 080 - Nome da testemunha
* 47 descLogradouro testemunhas E C 1-1 080 - Descrição do logradouro
* 48 nrLogradouro testemunhas E C 0-1 010 - Número do logradouro.
* 49 bairro testemunhas E C 0-1 030 - Nome do bairro/distrito
* 50 codMunicipio testemunhas E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 51 uf testemunhas E C 0-1 002 - Preencher com a sigla da Unidade da Federação
* 52 cep testemunhas E N 0-1 008 - Código de Endereçamento Postal
* 53 telefone testemunhas E C 0-1 012 - Informar o número do telefone, com DDD.

::incluiTag(4,"/testemunhas")
::incluiTag(4,"atestado")
* 55 codCNES atestado E N 1-1 007 - Código da unidade de atendimento médico no Cadastro
* 56 dtAtendimento atestado E D 1-1 010 - Data do atendimento
* 57 hrAtendimento atestado E N 1-1 004 - Hora do atendimento
* 58 indInternacao atestado E C 1-1 001 - Indicativo de Internação:
* 59 durTratamento atestado E N 1-1 004 - Duração estimada do tratamento, em dias
* 60 indAfastamento atestado E C 1-1 001 - Indicativo do afastamento:
* 61 descLesao atestado E C 0-1 400 - Descrição e natureza da lesão
* 62 diagProvavel atestado E C 0-1 100 - Diagnóstico Provável
* 63 codCID atestado E C 1-1 005 - Informar o código na tabela de classificação internacional de
* 64 observacao atestado E C 0-1 255 - Observação

::incluiTag(5,"medico")
::incluiTag(6,"crm")
* 68 nrCRM crm E C 1-1 008 - Número de inscrição do médico encarregado do exame no
* 69 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedição do CRM.

::incluiTag(6,"/crm")
::incluiTag(5,"/medico")
* 66 nomeMedico medico E C 1-1 080 - Preencher com o nome do médico encarregado do exame

::incluiTag(4,"/atestado")
::incluiTag(4,"catOrigem")
* 71 dtCatOrigem catOrigem E D 1-1 010 - Informar a data da CAT de origem
* 72 nrCatOrigem catOrigem E C 1-1 015 - Informar o número da CAT de origem, quando tratar-se de CAT
::incluiTag(4,"/catOrigem")
::incluiTag(3,"/cat")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtCAT")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2280() Atestado de Saúde Ocupacional
* -----------------------------------------------------------------------------*
METHOD S2280() CLASS eSocial

::incluiTag(1,"evtASO")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa

::incluiTag(3,"/ideVinculo")
::incluiTag(3,"aso")
* 20 dtAso aso E D 1-1 010 - Data do Atestado de Saúde Ocupacional.
* 21 tpAso aso E N 1-1 001 - Tipo de Atestado de Saúde Ocupacional emitido, conforme
* 22 resultadoAso aso E N 1-1 001 - Resultado do ASO, conforme tabela abaixo:

::incluiTag(4,"exames")
* 24 dtExame exames E D 1-1 010 - Data do exame realizado
* 25 descExame exames E C 1-1 080 - Informar a descrição do exame realizado (ex: RX Tórax,

::incluiTag(4,"/exames")
::incluiTag(4,"riscos")
* 27 codAgente riscos E C 1-1 005 - Informar o código do agente, conforme tabela 7.

::incluiTag(4,"/riscos")
::incluiTag(4,"medico")
* 29 nomeMedico medico E C 1-1 080 - Preencher com o nome do médico encarregado do exame

::incluiTag(5,"crm")
* 31 nrCRM crm E C 1-1 008 - Número de inscrição do médico encarregado do exame no
* 32 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedição do CRM.
::incluiTag(5,"/crm")
::incluiTag(4,"/medico")
::incluiTag(3,"/aso")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtASO")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2300() Aviso de Férias
* -----------------------------------------------------------------------------*
METHOD S2300() CLASS eSocial

::incluiTag(1,"evtAvisoFerias")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ideEmpregador E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoAviso")
* 20 dtAvisoFerias infoAviso E D 1-1 010 - Data do Aviso de Férias
* 21 dtIniGozo infoAviso E D 1-1 010 - Data do prevista para início do gozo das Férias.
* 22 dtFimGozo infoAviso E D 1-1 010 - Data do prevista para término do gozo das Férias.
* 23 dtIniPerAquisicao infoAviso E D 1-1 010 - Data do início do período aquisitivo a que se refere o Aviso de
* 24 dtFimPerAquisicao infoAviso E D 1-1 010 - Data do término do período aquisitivo a que se refere o Aviso
* 25 indAbonoPecuniario infoAviso E C 1-1 001 - Indica se parte das férias foi transformada em pecúnia:
* 26 tpFerias infoAviso E N 1-1 001 - Tipo de Férias:
* 27 observacao infoAviso E C 0-1 255 - Observação
::incluiTag(3,"/infoAviso")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAvisoFerias")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2320() Afastamento Temporário
* -----------------------------------------------------------------------------*
METHOD S2320() CLASS eSocial

::incluiTag(1,"evtAfastTemp")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")
* 5 ideEvento infEvento G - 1-1 - - Informações de Identificação do Evento
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do

::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa

::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoAfastamento")
* 20 dtAfastamento infoAfastamento E D 1-1 010 - Data do Afastamento
* 21 codMotAfastamento infoAfastamento E N 1-1 002 - Preencher com o código do motivo de afastamento temporário,
* 22 tpAcidenteTransito infoAfastamento E C 0-1 001 - Tipo de Acidente de Trânsito:
* 23 observacao infoAfastamento E C 0-1 255 - Observação

::incluiTag(4,"infoAtestado")
* 25 codCID infoAtestado E C 1-1 005 - Informar o código na tabela de classificação internacional de
* 26 qtdDiasAfastamento infoAtestado E N 1-1 003 - Quantidade de dias de afastamento concedidos pelo médico

::incluiTag(5,"medico")
* 28 nomeMedico medico E C 1-1 080 - Preencher com o nome do médico encarregado do exame

::incluiTag(6,"crm")
* 30 nrCRM crm E C 1-1 008 - Número de inscrição do médico encarregado do exame no
* 31 ufCRM crm E C 1-1 002 - Preencher com a sigla da UF de expedição do CRM.

::incluiTag(6,"/crm")
::incluiTag(5,"/medico")
::incluiTag(4,"/infoAtestado")
::incluiTag(4,"infoCessao")
* 33 cnpjCessionario infoCessao E N 1-1 014 - Preencher com o CNPJ do órgão/entidade para o qual o
* 34 infoOnus infoCessao E N 1-1 001 - Informar se o trabalhador foi cedido com ônus ou sem ônus

::incluiTag(4,"/infoCessao")
::incluiTag(4,"infoMandadoSindical")
* 36 cnpjSindicato infoMandadoSindical E N 1-1 014 - CNPJ do Sindicato no qual o trabalhador exercerá o mandato.
* 37 infoOnusRemuneracao infoMandadoSindical E N 1-1 001 - Informar se o trabalhador foi afastado com ônus ou sem ônus

::incluiTag(4,"/infoMandadoSindical")
::incluiTag(3,"/infoAfastamento")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAfastTemp")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2325() Alteração do Motivo do Afastamento
* -----------------------------------------------------------------------------*
METHOD S2325() CLASS eSocial

::incluiTag(1,"evtAltMotAfast")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
* 5 ideEvento infEvento G - 1-1 - - Informações de Identificação do Evento
::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoAltMotivo")
* 20 dtAltMotivo infoAltMotivo E D 1-1 010 - Preencher com a data da alteração do motivo de afastamento
* 21 codMotivoAnterior infoAltMotivo E N 1-1 002 - Motivo anterior do afastamento, conforme tabela 18.
* 22 codMotAfastamento infoAltMotivo E N 1-1 002 - Preencher com o código do motivo de afastamento temporário,
* 23 indEfeitoRetroativo infoAltMotivo E C 1-1 001 - Informar se a alteração de motivo tem efeito retroativo à a data
::incluiTag(3,"/infoAltMotivo")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAltMotAfast")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2330() Retorno do Afastamento
* -----------------------------------------------------------------------------*
METHOD S2330() CLASS eSocial

::incluiTag(1,"evtAfastRetorno")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoRetorno")
* 20 dtRetorno infoRetorno E D 1-1 010 - Preencher com a data do retorno do afastamento
* 21 codMotAfastamento infoRetorno E N 1-1 002 - Preencher com o código do motivo de afastamento temporário,
* 22 observacao infoRetorno E C 0-1 255 - Observação
::incluiTag(3,"/infoRetorno")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAfastRetorno")


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2340() Estabilidade - Início
* -----------------------------------------------------------------------------*
METHOD S2340() CLASS eSocial

::incluiTag(1,"evtEstabInicio")
::incluiTag(2,"infEvento")
* 3 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
* 5 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 6 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 7 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 8 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 9 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 10 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 12 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 13 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 15 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 16 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 17 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoEstabInicio")
* 19 dtIniEstabilidade infoEstabInicio E D 1-1 010 - Preencher com a data de início da estabilidade
* 20 codMotivoEstabilidade infoEstabInicio E N 1-1 001 - Código do motivo da estabilidade:
* 21 observacao infoEstabInicio E C 0-1 255 - Observação
::incluiTag(3,"/infoEstabInicio")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtEstabInicio")

RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S2345() Estabilidade - Término
* -----------------------------------------------------------------------------*
METHOD S2345() CLASS eSocial

::incluiTag(1,"evtEstabTermino")
::incluiTag(2,"infEvento")
* 3 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")
* 5 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 6 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 7 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 8 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 9 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 10 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")
* 12 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 13 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")
* 15 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 16 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 17 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoEstabTermino")
* 19 dtFimEstabilidade infoEstabTermino E D 1-1 010 - Preencher com a data do término da estabilidade
* 20 codMotivoEstabilidade infoEstabTermino E N 1-1 001 - Código do motivo da estabilidade:
* 21 observacao infoEstabTermino E C 0-1 255 - Observação
::incluiTag(3,"/infoEstabTermino")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtEstabTermino")


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S2360() Condição Diferenciada de Trabalho - Início
* -----------------------------------------------------------------------------*
METHOD S2360() CLASS eSocial

::incluiTag(1,"evtCDTInicio")
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")     // evtCDTInicio 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote

::incluiTag(3,"ideEvento")     // infEvento 3 Informações de Identificação do
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador") // infEvento 3 Informações de identificação do
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")    // infEvento 3 Informações de Identificação do
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoCDTInicio") // infEvento 3 Condição de Trabalho 1-1 - O
* 20 dtIniCondicao infoCDTInicio E D 1-1 010 - Informar a data a partir da qual o trabalhador está sujeito às
* 21 tpCondicao infoCDTInicio E N 1-1 002 - Preencher com o código relativo ao tipo de condição
* 22 fatoresRisco infoCDTInicio G - 0-50 - - O registro apresenta o detalhamento dos agentes nocivos aos
::incluiTag(4,"fatoresRisco")  // infoCDTInicio 4 Indicação dos Fatores de Riscos. 0-50 codAgente O (se {tpCondicao} for
* 23 codAgente fatoresRisco E C 1-1 005 - Informar o código do agente, conforme tabela 7.
* 24 intensidConcentracao fatoresRisco E C 0-1 015 - Intensidade ou Concentração da exposição do trabalhador ao
* 25 tecMedicao fatoresRisco E C 0-1 040 - Técnica utilizada para medição da intensidade ou concentração
* 26 utilizacaoEPC fatoresRisco E N 1-1 001 - Utilização de Equipamento de Proteção Coletiva.
* 27 utilizacaoEPI fatoresRisco E N 1-1 001 - Utilização de Equipamento de Proteção Individual
::incluiTag(5,"epi")           //  fatoresRisco 5 Equipamentos de Proteção Individual 0-50 - O (se {utilizacaoEPI} =
* 29 caEPI epi E C 0-1 020 - Preenchimento obrigatório se {utilizacaoEPI} for igual a [1,2]
* 30 requisitosEPI infoCDTInicio G - 0-1 - - Registro onde são prestadas as informações sobre o
* 31 medProtecao requisitosEPI E C 1-1 001 - Informar "S" ou "N".
* 32 condFuncionamento requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 33 prazoValidade requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 34 periodicTroca requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
* 35 higienizacao requisitosEPI E C 1-1 001 - Preencher com "S" ou "N"
::incluiTag(5,"/epi")
::incluiTag(4,"/fatoresRisco")
::incluiTag(4,"requisitosEPI") // infoCDTInicio 4 Equipamento de Proteção Individual -
::incluiTag(4,"/requisitosEPI")
::incluiTag(3,"/infoCDTInicio")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtCDTInicio")


* 19 infoCDTInicio infEvento G - 1-1 - - Condição de Trabalho

* 28 epi fatoresRisco G - 0-50 - - Equipamentos de Proteção Individual
* 


RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2365() Condição Diferenciada de Trabalho - Término
* -----------------------------------------------------------------------------*
METHOD S2365() CLASS eSocial

::incluiTag(1,"evtCDTTermino") //1 Evento Condição Diferenciada de
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")     //evtCDTTermino 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")     //infEvento     3 Informações de Identificação do
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador") //infEvento     3 Informações de identificação do
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")    //infEvento     3 Informações de Identificação do
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa

::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoCDTTermino")//infEvento     3 Condição de Trabalho - Término 1-1 - O
* 20 dtFimCondicao infoCDTTermino E D 1-1 010 - Informar a data até a qual o trabalhador esteve sujeito às
* 21 tpCondicao infoCDTTermino E N 1-1 002 - Preencher com o código relativo ao tipo de condição
* 22 fatoresRisco infoCDTTermino G - 0-50 - - O registro apresenta o detalhamento do agente nocivo ao qual o
::incluiTag(4,"fatoresRisco")  //infoCDTTermino 4 Indicação dos Fatores de Riscos. 0-50
* 23 codAgente fatoresRisco E C 1-1 005 - Informar o código do agente, conforme tabela 7.
::incluiTag(4,"/fatoresRisco")
::incluiTag(3,"/infoCDTTermino")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtCDTTermino")

RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2400() Aviso Prévio
* -----------------------------------------------------------------------------*
METHOD S2400() CLASS eSocial

::incluiTag(1,"evtAvisoPrevio")  //1 Evento Aviso Prévio 1-1 - O
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração

::incluiTag(2,"infEvento")       //evtAvisoPrevio 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")       //infEvento 3 Informações de Identificação do
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")   //infEvento 3 Informações de identificação do
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")      //infEvento 3 Informações de Identificação do
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoAvisoPrevio") //infEvento  3 Aviso Prévio
* 20 dtAvisoPrevio infoAvisoPrevio E D 1-1 010 - Data em que o trabalhador ou o empregador recebeu o aviso de
* 21 dtProjAfastamento infoAvisoPrevio E D 1-1 010 - Data projetada para o afastamento do trabalhador
* 22 tpAvisoPrevio infoAvisoPrevio E N 1-1 001 - Tipo de Aviso Prévio. Indica quem avisou o desligamento,
* 23 observacao infoAvisoPrevio E C 0-1 255 - Observação
::incluiTag(3,"/infoAvisoPrevio")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAvisoPrevio")

RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2405() Cancelamento de Aviso Prévio
* -----------------------------------------------------------------------------*
METHOD S2405() CLASS eSocial

::incluiTag(1,"evtCancAvisoPrevio") // 1 Evento Cancelamento de Aviso Prévio 1-1 - O
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")          // evtCancAvisoPrevio 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")          // infEvento 3 Informações de Identificação do
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")      // infEvento 3 Informações de identificação do
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")         // infEvento 3 Informações de Identificação do
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoCancAvisoPrevio")// infEvento 3 Cancelamento do Aviso Prévio 1-1
* 20 dtCancAvisoPrevio infoCancAvisoPrevio E D 1-1 010 - Preencher com a data do cancelamento do aviso prévio
* 21 observacao infoCancAvisoPrevio E C 0-1 255 - Observação
* 22 motivoCancAvisoPrevio infoCancAvisoPrevio E N 1-1 001 - Motivo do Cancelamento do Aviso Prévio:
::incluiTag(3,"/infoCancAvisoPrevio")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtCancAvisoPrevio")


RETURN Self
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*S2420() Atividades Desempenhadas
* -----------------------------------------------------------------------------*
METHOD S2420() CLASS eSocial

::incluiTag(1,"evtComunicFatoRelevante") // 1 Evento Comunicação de Fato
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")               // evtComunicFatoRelevante 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")               // infEvento 3 Informações de Identificação do Evento 1-1 - O
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")           // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")              // infEvento 3 Informações de Identificação do Trabalhador e do Vínculo 1-1 cpfTrab, nisTrab,matricula
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoComunicFato")         // infEvento 3 Comunicação do Fato Relevante 1-1
::incluiTag(3,"/infoComunicFato")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtComunicFatoRelevante")

* 19 infoAtivDesemp infEvento G - 1-1 - - Alteração das Atividades Desempenhadas
* 21 descAtividade infoAtivDesemp G - 0-50 - - Descrição das Atividades Desempenhadas
* 22 descAtivDesemp descAtividade E C 1-1 255 - Descrição da atividade desempenhada


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S2440() Comunicação Fato Relevante
* -----------------------------------------------------------------------------*
METHOD S2440() CLASS eSocial

::incluiTag(1,"evtAtivDesemp") // 1 Evento Atividades Desempenhadas 1-1 - O
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")     // evtAtivDesemp 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")     // infEvento 3 Informações de Identificação do
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")

::incluiTag(3,"ideEmpregador") // infEvento 3 Informações de identificação do
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")

::incluiTag(3,"ideVinculo")    // infEvento 3 Informações de Identificação do
* 16 cpfTrab ideVinculo E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab ideVinculo E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 matricula ideVinculo E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")

::incluiTag(3,"infoAtivDesemp")// infEvento 3 Alteração das Atividades
::incluiTag(4,"descAtividade") // infoAtivDesemp 4 Descrição das Atividades
::incluiTag(4,"/descAtividade")
::incluiTag(3,"/infoAtivDesemp")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtAtivDesemp")

* 19 infoComunicFato infEvento G - 1-1 - - Comunicação do Fato Relevante
* 20 dtFatoRelevante infoComunicFato E D 1-1 010 - Data do fato relevante
* 21 tpFatoRelevante infoComunicFato E C 1-1 001 - Tipo de fato relevante, conforme tabela:
* 22 descFatoRelevante infoComunicFato E C 1-1 - - Detalhar o fato relevante ocorrido.


RETURN Self
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*S2600() Trabalhador Sem Vínculo de Emprego - Início
* -----------------------------------------------------------------------------*
METHOD S2600() CLASS eSocial

::incluiTag(1,"evtTSVInicio")      // 1 Evento Trabalhador Sem Vínculo - Início 1-1 - O
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")         // evtTSVInicio 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")         // infEvento 3 Informações de Identificação do Evento 1-1 - O
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")     // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme

::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"trabalhador")       // infEvento 3 Grupo de Informações do Trabalhador 1-1 cpfTrab O
* 16 cpfTrab trabalhador E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab trabalhador E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 nomeTrab trabalhador E C 1-1 080 - Nome do Trabalhador
* 19 sexo trabalhador E C 1-1 001 - Sexo do Trabalhador:
* 20 racaCor trabalhador E N 1-1 001 - Raça e cor do trabalhador, conforme tabela abaixo:
* 21 estadoCivil trabalhador E N 1-1 001 - Estado civil do trabalhador, conforme tabela abaixo:
* 22 grauInstrucao trabalhador E N 1-1 002 - Grau de instrução do trabalhador, conforme tabela:

::incluiTag(4,"nascimento")        // trabalhador 4 Grupo de informações do nascimento  do trabalhador 1-1 - O
* 24 dtNascto nascimento E D 1-1 010 - Preencher com a data de nascimento
* 25 codMunicipio nascimento E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 26 uf nascimento E C 0-1 002 - Preencher com a sigla da Unidade da Federação
* 27 paisNascto nascimento E N 1-1 005 - Preencher com o código do país de nascimento do trabalhador,
* 28 paisNacionalidade nascimento E N 1-1 005 - Preencher com o código do país de nacionalidade do
* 29 nomeMae nascimento E C 0-1 080 - Nome da mãe do trabalhador
* 30 nomePai nascimento E C 0-1 080 - Nome do Pai do Trabalhador

::incluiTag(4,"/nascimento")
::incluiTag(4,"documentos")        // trabalhador 4 Informações dos documentos pessoais do trabalhador 0-1 - OC
::incluiTag(5,"CTPS")              // documentos 5 Carteira de Trabalho e Previdência Social 0-1 - O
* 33 nrCtps CTPS E C 1-1 011 - Número da carteira de trabalho e Previdência Social do
* 34 serieCtps CTPS E C 1-1 004 - Número de série da CTPS.
* 35 ufCtps CTPS E C 1-1 002 - UF da expedição da CTPS.
::incluiTag(5,"/CTPS")
::incluiTag(5,"RIC")               // documentos 5 Registro de Identificação 0-1 - OC
* 37 nrRic RIC E N 1-1 014 - Número do RIC
* 38 orgaoEmissor RIC E C 1-1 020 - Órgão emissor do documento
* 39 dtExpedicao RIC E D 1-1 010 - Data da expedição do documento
::incluiTag(5,"/RIC")
::incluiTag(5,"RG")                // documentos 5 Informações do Registro Geral (RG) 0-1 - OC
* 41 nrRg RG E C 1-1 014 - Número do RG
* 42 orgaoEmissor RG E C 1-1 020 - Órgão emissor do documento
* 43 dtExpedicao RG E D 1-1 010 - Data da expedição do documento
::incluiTag(5,"/RG")
::incluiTag(5,"RNE")               // documentos 5 Informações do Registro Nacional de  Estrangeiro  0-1 - OC
* 45 nrRne RNE E C 1-1 014 - Número de inscrição no Registro Nacional de Estrangeiros
* 46 orgaoEmissor RNE E C 1-1 020 - Órgão emissor do documento
* 47 dtExpedicao RNE E D 1-1 010 - Data da expedição do documento
::incluiTag(5,"/RNE")
::incluiTag(5,"OC")                // documentos 5 Informações do número de registro em  Órgão de Classe (OC) 0-1 - OC
* 49 nrOc OC E C 1-1 014 - Número de Inscrição no Órgão de Classe
* 50 orgaoEmissor OC E C 1-1 020 - Órgão emissor do documento
* 51 dtExpedicao OC E D 1-1 010 - Data da expedição do documento
* 52 dtValidade OC E D 0-1 010 - Preencher com a data de validade, se houver.
::incluiTag(5,"/OC")
::incluiTag(5,"CNH")               // documentos 5 Informações da Carteira Nacional de Habilitação (CNH) 0-1 - OC
* 54 nrCnh CNH E N 1-1 014 - Número da CNH
* 55 orgaoEmissor CNH E C 1-1 020 - Órgão emissor do documento
* 56 dtExpedicao CNH E D 1-1 010 - Data da expedição do documento
* 57 dtValidade CNH E D 0-1 010 - Preencher com a data de validade, se houver.
::incluiTag(5,"/CNH")
::incluiTag(4,"/documentos")
::incluiTag(4,"endereco")          // trabalhador 4 Endereço do Trabalhador 1-1 - O
::incluiTag(5,"brasil")            // endereco 5 Endereço no Brasil 0-1 - OC
* 60 tpLogradouro brasil E C 1-1 010 - Tipo de Logradouro
* 61 descLogradouro brasil E C 1-1 080 - Descrição do logradouro
* 62 nrLogradouro brasil E C 0-1 010 - Número do logradouro.
* 63 complemento brasil E C 0-1 030 - Complemento do logradouro.
* 64 bairro brasil E C 0-1 030 - Nome do bairro/distrito
* 65 cep brasil E N 1-1 008 - Código de Endereçamento Postal
* 66 codMunicipio brasil E N 1-1 007 - Preencher com o código do município, conforme tabela do
* 67 uf brasil E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(5,"/brasil")
::incluiTag(5,"exterior")          // endereco 5 Endereço no Exterior 0-1 - OC
* 69 paisResidencia exterior E N 1-1 005 - Preencher com o código do país, conforme tabela de países da
* 70 descLogradouro exterior E C 1-1 080 - Descrição do logradouro
* 71 nrLogradouro exterior E C 0-1 010 - Número do logradouro.
* 72 complemento exterior E C 0-1 030 - Complemento do logradouro.
* 73 bairro exterior E C 0-1 030 - Nome do bairro/distrito
* 74 nomeCidade exterior E C 1-1 030 - Nome da Cidade
* 75 codPostal exterior E C 0-1 010 - Código de Endereçamento Postal
::incluiTag(5,"/exterior")
::incluiTag(4,"/endereco")
::incluiTag(4,"infoCasaPropria")   // trabalhador 4 Informações da Casa Própria 0-1 - OC
* 77 residenciaPropria infoCasaPropria E C 1-1 001 - indicar se a residência pertence ao trabalhador
* 78 recursoFGTS infoCasaPropria E C 0-1 001 - Indicar se foi adquirido o imóvel próprio foi adquirido com
::incluiTag(4,"/infoCasaPropria")
::incluiTag(4,"trabEstrangeiro")   // trabalhador 4 Informações do Trabalhador Estrangeiro 0-1 - OC
* 80 dtChegada trabEstrangeiro E D 1-1 010 - Data de chegada do trabalhador ao Brasil, em caso de
* 81 dtNaturalizacao trabEstrangeiro E D 0-1 010 - Data de naturalização brasileira em caso de estrangeiro
* 82 casadoBr trabEstrangeiro E C 1-1 001 - Condição de casado com brasileiro(s) em caso de trabalhador
* 83 filhosBr trabEstrangeiro E C 1-1 001 - Se o trabalhador estrangeiro tem filhos com brasileiro,
::incluiTag(4,"/trabEstrangeiro")
::incluiTag(4,"infBancarias")      // trabalhador 4 Informações Bancárias do Trabalhador 0-1 - OC
* 85 banco infBancarias E N 0-1 003 - Preencher com o código do banco, no caso de depósito bancário
* 86 agencia infBancarias E C 0-1 015 - Preencher com o código da agência, no caso de depósito
* 87 tpContaBancaria infBancarias E N 1-1 001 - Tipo de Conta:
* 88 nrContaBancaria infBancarias E C 1-1 020 - Número da Conta Bancária
::incluiTag(4,"/infBancarias")
::incluiTag(4,"infoDeficiencia")   // trabalhador 4 Pessoa com Deficiência 0-1 - OC
* 90 defMotora infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência motora.
* 91 defVisual infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência visual
* 92 defAuditiva infoDeficiencia E C 1-1 001 - Indicar se o trabalhador possui deficiência auditiva.
* 93 reabilitado infoDeficiencia E C 1-1 001 - Informar se o trabalhador é reabilitado.
* 94 observacao infoDeficiencia E C 0-1 255 - Observação
::incluiTag(4,"/infoDeficiencia")
::incluiTag(4,"dependente")        // trabalhador 4 Informações dos dependentes 0-50 tpDep, nomeDep,dtNascto OC
* 96 tpDep dependente E N 1-1 002 - Tipo de dependente conforme tabela abaixo:
* 97 nomeDep dependente E C 1-1 080 - Nome do Dependente
* 98 dtNascto dependente E D 1-1 010 - Preencher com a data de nascimento
* 99 cpfDep dependente E N 0-1 011 - Número de Inscrição no CPF
* 100 depIRRF dependente E C 1-1 001 - Informar se é dependente para fins de dedução do IRRF.
* 101 depSF dependente E C 1-1 001 - Informar se é dependente para fins de recebimento do benefício
::incluiTag(4,"/dependente")
::incluiTag(4,"contato")           // trabalhador 4 Informações de Contato 0-1 - OC
* 103 fonePrincipal contato E N 0-1 012 - Número de telefone do trabalhador
* 104 foneAlternativo contato E N 0-1 012 - Número de telefone do trabalhador
* 105 emailPrincipal contato E C 0-1 060 - Endereço eletrônico
* 106 emailAlternativo contato E C 0-1 060 - Endereço eletrônico
::incluiTag(4,"/contato")
::incluiTag(3,"/trabalhador")
::incluiTag(3,"infoTSVInicio")     // infEvento 3 Trabalhador Sem Vínculo - Início 1-1 - O
* 108 trabalhadorAvulso infoTSVInicio G - 0-1 - - Informações do Trabalhador Avulso
* 109 dtInicio trabalhadorAvulso E D 1-1 010 - Data de ingresso no ogmo ou no Sindicato
* 110 codCateg trabalhadorAvulso E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 111 fgts trabalhadorAvulso G - 1-1 - - Informações relativas ao FGTS do trabalhador avulso
::incluiTag(4,"trabalhadorAvulso") // infoTSVInicio 4 Trabalhador Avulso 0-1 - OC
::incluiTag(5,"fgts")              // trabalhadorAvulso 5 Informações relativas ao FGTS do  trabalhador avulso 1-1 - O
* 112 optanteFGTS fgts E N 1-1 001 - Informar a opção pelo FGTS
* 113 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de opção pelo FGTS do trabalhador
::incluiTag(5,"/fgts")
::incluiTag(4,"/trabalhadorAvulso")
::incluiTag(4,"contribIndividual") // infoTSVInicio 4 Contribuinte Individual 0-1 - OC
* 115 codCateg contribIndividual E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 116 dtInicio contribIndividual E D 1-1 010 - Para o diretor não empregado, preencher com a data de posse
* 117 codCargo contribIndividual E C 1-1 030 - Preencher com o código do cargo
* 118 codFuncao contribIndividual E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(5,"fgts")              // contribIndividual 5 Informações relativas ao FGTS 0-1 - O (se {codCateg} = [721]) N (nos demais casos)
* 120 optanteFGTS fgts E N 1-1 001 - Informar a opção pelo FGTS
* 121 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de opção pelo FGTS do trabalhador
::incluiTag(5,"/fgts")
::incluiTag(4,"/contribIndividual")
::incluiTag(4,"servPubIndConselho")// infoTSVInicio 4 Servidor Público indicado para Conselho ou Órgão Representativo; 0-1 - OC
* 123 dtInicio servPubIndConselho E D 1-1 010 - Data de posse no cargo
* 124 codCateg servPubIndConselho E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 125 codCargo servPubIndConselho E C 1-1 030 - Preencher com o código do cargo
* 126 codFuncao servPubIndConselho E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(4,"/servPubIndConselho")
::incluiTag(4,"dirigenteSindical") // infoTSVInicio 4 Dirigente Sindical 0-1 - OC
* 128 dtInicio dirigenteSindical E D 1-1 010 - Data de início do mandato no sindicato
* 129 codCateg dirigenteSindical E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(5,"empresaOrigem")     // dirigenteSindical 5 Empresa de Origem do Dirigente Sindical 1-1 - O
* 131 categOrigem empresaOrigem E N 1-1 003 - preencher com o código correspondente à categoria de origem
* 132 cnpjOrigem empresaOrigem E N 0-1 014 - Preencher com o CNPJ da empresa de origem do dirigente
* 133 dtAdmissaoOrigem empresaOrigem E D 0-1 010 - Preencher com a data de admissão do dirigente sindical na
* 134 matricOrigem empresaOrigem E C 0-1 030 - Preencher com a matrícula do trabalhador na empresa de
::incluiTag(5,"/empresaOrigem")
::incluiTag(5,"fgts")              // dirigenteSindical 5 Informações relativas ao FGTS do dirigente sindical 0-1 - OC
* 136 optanteFGTS fgts E N 1-1 001 - Informar a opção pelo FGTS
* 137 dtOpcaoFGTS fgts E D 0-1 010 - Informar a data de opção pelo FGTS do trabalhador
::incluiTag(5,"/fgts")
::incluiTag(4,"/dirigenteSindical")
::incluiTag(4,"estagiario")        // infoTSVInicio 4 informações do estagiário 0-1 - OC
* 139 dtInicio estagiario E D 1-1 010 - Data do início do estágio
* 140 codCateg estagiario E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 141 natEstagio estagiario E C 1-1 001 - Natureza do Estágio:
* 142 nivEstagio estagiario E C 1-1 001 - Nível:
* 143 areaAtuacao estagiario E C 0-1 050 - Área de atuação do estagiário
* 144 nrApolice estagiario E C 0-1 030 - Nr. Apólice de Seguro
* 145 vlrBolsa estagiario E N 0-1 14 2 Preencher com o valor da bolsa, se o estágio for remunerado.
* 146 dtPrevistaTermino estagiario E D 1-1 010 - Data prevista para o término do estágio
::incluiTag(5,"instEnsino")        // estagiario 5 Instituição de Ensino 1-1 - O
* 148 cnpjInstEnsino instEnsino E N 1-1 014 - Preencher com o cnpj da instituição de ensino.
* 149 nomeRazao instEnsino E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
* 150 descLogradouro instEnsino E C 1-1 080 - Descrição do logradouro
* 151 nrLogradouro instEnsino E C 0-1 010 - Número do logradouro.
* 152 bairro instEnsino E C 0-1 030 - Nome do bairro/distrito
* 153 cep instEnsino E N 1-1 008 - Código de Endereçamento Postal
* 154 codMunicipio instEnsino E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 155 uf instEnsino E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(5,"/instEnsino")
::incluiTag(5,"ageIntegracao")     // estagiario 5 Agente de Integração 1-1 - O
* 157 cnpjAgenteIntegracao ageIntegracao E N 1-1 014 - CNPJ do agente de integração
* 158 nomeRazao ageIntegracao E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
* 159 descLogradouro ageIntegracao E C 1-1 080 - Descrição do logradouro
* 160 nrLogradouro ageIntegracao E C 0-1 010 - Número do logradouro.
* 161 bairro ageIntegracao E C 0-1 030 - Nome do bairro/distrito
* 162 cep ageIntegracao E N 1-1 008 - Código de Endereçamento Postal
* 163 codMunicipio ageIntegracao E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 164 uf ageIntegracao E C 1-1 002 - Preencher com a sigla da Unidade da Federação

::incluiTag(5,"/ageIntegracao")
::incluiTag(5,"coordEstagio")      // estagiario 5 Coordenador do Estágio 1-1 - O
* 166 cpfCoordenador coordEstagio E N 1-1 011 - CPF do coordenador do estágio
* 167 nomeCoordenador coordEstagio E C 1-1 080 - Nome do Coordenador do Estágio
::incluiTag(5,"/coordEstagio")
::incluiTag(4,"/estagiario")
::incluiTag(3,"/infoTSVInicio")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTSVInicio")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2620() Trabalhador Sem Vínculo de Emprego - Alteração Contratual
* -----------------------------------------------------------------------------*
METHOD S2620() CLASS eSocial

::incluiTag(1,"evtTSVAltContratual") // 1 Evento Trabalhador Sem Vínculo - Alteração Contratual 1-1 - O
* 2 versao ::versao A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")           // evtTSVAltContratual 2 Informações do evento 1-1 idEvento O
* 4 idEvento infEvento A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")           // infEvento 3 Informações de Identificação do Evento 1-1 - O
* 6 indRetificacao ideEvento E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
* 7 nrRecibo ideEvento E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
* 8 tpAmb ideEvento E N 1-1 001 - Identificação do ambiente:
* 9 procEmi ideEvento E N 1-1 001 - Processo de emissão do evento:
* 10 indSegmento ideEvento E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
* 11 verProc ideEvento E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")       // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
* 13 tpInscricao ideEmpregador E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
* 14 nrInscricao ::cNpjEmp  E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoTSVAlteracao")    // infEvento 3 Trabalhador Sem Vínculo - Alteração Contratual 1-1 - O
* 16 cpfTrab infoTSVAlteracao E N 1-1 011 - Preencher com o número do CPF do trabalhador
* 17 nisTrab infoTSVAlteracao E N 0-1 011 - Preencher com o número de inscrição do segurado, o qual pode
* 18 dtAlteracao infoTSVAlteracao E D 1-1 010 - Preencher com a data da alteração das informações
::incluiTag(4,"contribIndividual")   // infoTSVAlteracao 4 Contribuinte Individual 0-1 - OC
* 20 codCateg contribIndividual E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
* 21 codCargo contribIndividual E C 1-1 030 - Preencher com o código do cargo
* 22 codFuncao contribIndividual E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(4,"/contribIndividual")
::incluiTag(4,"servPubIndConselho")  // infoTSVAlteracao 4 Servidor Público indicado para Conselho ou Órgão Representativo;
* 24 codCargo servPubIndConselho E C 1-1 030 - Preencher com o código do cargo
* 25 codFuncao servPubIndConselho E C 0-1 030 - Preencher com o código da função, se utilizado pela empresa
::incluiTag(4,"/servPubIndConselho")
::incluiTag(4,"estagiario")          // infoTSVAlteracao 4 informações do estagiário 0-1 - OC
* 27 natEstagio estagiario E C 1-1 001 - Natureza do Estágio:
* 28 nivEstagio estagiario E C 1-1 001 - Nível:
* 29 areaAtuacao estagiario E C 0-1 050 - Área de atuação do estagiário
* 30 nrApolice estagiario E C 0-1 030 - Nr. Apólice de Seguro
* 31 vlrBolsa estagiario E N 0-1 14 2 Preencher com o valor da bolsa, se o estágio for remunerado.
* 32 dtPrevistaTermino estagiario E D 1-1 010 - Data prevista para o término do estágio
::incluiTag(5,"instEnsino")          // estagiario 5 Instituição de Ensino 1-1 - O
* 34 cnpjInstEnsino instEnsino E N 1-1 014 - Preencher com o cnpj da instituição de ensino.
* 35 nomeRazao instEnsino E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
* 36 descLogradouro instEnsino E C 1-1 080 - Descrição do logradouro
* 37 nrLogradouro instEnsino E C 0-1 010 - Número do logradouro.
* 38 bairro instEnsino E C 0-1 030 - Nome do bairro/distrito
* 39 cep instEnsino E N 1-1 008 - Código de Endereçamento Postal
* 40 codMunicipio instEnsino E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 41 uf instEnsino E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(5,"/instEnsino")
::incluiTag(5,"ageIntegracao")       // estagiario 5 Agente de Integração 1-1 - O
* 43 cnpjAgenteIntegracao ageIntegracao E N 1-1 014 - CNPJ do agente de integração
* 44 nomeRazao ageIntegracao E C 1-1 080 - Informar o nome do contribuinte, no caso de pessoa física, ou a
* 45 descLogradouro ageIntegracao E C 1-1 080 - Descrição do logradouro
* 46 nrLogradouro ageIntegracao E C 0-1 010 - Número do logradouro.
* 47 bairro ageIntegracao E C 0-1 030 - Nome do bairro/distrito
* 48 cep ageIntegracao E N 1-1 008 - Código de Endereçamento Postal
* 49 codMunicipio ageIntegracao E N 0-1 007 - Preencher com o código do município, conforme tabela do
* 50 uf ageIntegracao E C 1-1 002 - Preencher com a sigla da Unidade da Federação
::incluiTag(5,"/ageIntegracao")
::incluiTag(5,"coordEstagio")        // estagiario 5 Coordenador do Estágio 1-1 - O
* 52 cpfCoordenador coordEstagio E N 1-1 011 - CPF do coordenador do estágio
* 53 nomeCoordenador coordEstagio E C 1-1 080 - Nome do Coordenador do Estágio
::incluiTag(5,"/coordEstagio")
::incluiTag(4,"/estagiario")
::incluiTag(3,"/infoTSVAlteracao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTSVAltContratual")

RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2680() Trabalhador Sem Vínculo de Emprego - Término
* -----------------------------------------------------------------------------*
METHOD S2680() CLASS eSocial

::incluiTag(1,"evtTSVTermino")      // 1 Evento Trabalhador Sem Vínculo de Emprego - Término 1-1 - O
::incluiTag(2,"versao",::versao) // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")          // evtTSVTermino 2 Informações do evento 1-1 idEvento O
::incluiTag(2,"idEvento","infEvento") // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")          // infEvento 3 Informações de Identificação do Evento 1-1 - O
::incluiTag(3,"indRetificacao","ideEvento") // E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento") // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"tpAmb","ideEvento") // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento") // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento") // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento") // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")      // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
::incluiTag(3,"tpInscricao","ideEmpregador") // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp ) // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoTSVTermino")     // infEvento 3 Trabalhador Sem Vínculo de Emprego - Término 1-1 cpfTrab, nisTrab O
::incluiTag(3,"cpfTrab","infoTSVTermino") // E N 1-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab","infoTSVTermino") // E N 0-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"trabalhadorAvulso","infoTSVTermino") // G - 0-1 - - Informações do Trabalhador Avulso
::incluiTag(4,"trabalhadorAvulso")             // infoTSVTermino 4 Trabalhador Avulso 0-1 - OC
::incluiTag(4,"dtTermino","trabalhadorAvulso") // E D 0-1 010 - Data do Término
::incluiTag(4,"/trabalhadorAvulso")
::incluiTag(4,"contribIndividual")            // infoTSVTermino 4 Contribuinte Individual 0-1 - OC
::incluiTag(4,"codCateg","contribIndividual") // E N 1-1 003 - Preencher com o código da categoria do trabalhador, conforme
::incluiTag(4,"dtTermino","contribIndividual")// E D 1-1 010 - Data do Término
::incluiTag(5,"verbasRescisorias")            // contribIndividual 5 Verbas Rescisórias 0-1 - OC (se {codCateg} igual a
::incluiTag(5,"bcCP"," verbasRescisorias")    // E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição
::incluiTag(5,"bcIRRF","verbasRescisorias")   // E N 1-1 14 2 Informar o valor total da base de cálculo IRRF para o
::incluiTag(5,"bcFGTS","verbasRescisorias")   // E N 1-1 14 2 Informar o valor total da base de cálculo do FGTS para o
::incluiTag(5,"bcFGTSVerbasIndeniz","verbasRescisorias")   // E N 0-1 14 2 Base de Cálculo do FGTS relativo às verbas indenizatórias
::incluiTag(5,"bcFgtsMesAnt","verbasRescisorias")   // E N 1-1 14 2 Informar a base de cálculo do FGTS do mês anterior, caso ainda
::incluiTag(5,"descCP","verbasRescisorias")   // E N 1-1 14 2 preencher com o valor descontado do segurado referente
::incluiTag(5,"vlrProventos","verbasRescisorias")   // E N 1-1 14 2 Informar o valor total dos proventos
::incluiTag(5,"vlrDescontos","verbasRescisorias")   // E N 1-1 14 2 Preencher com o valor total dos descontos
::incluiTag(5,"vlrLiquido","verbasRescisorias")   // E N 1-1 14 2 Preencher com o valor líquido
::incluiTag(6,"itensRemuneracao")   // verbasRescisorias 6 Itens da Remuneração do Trabalhador 1-50 codRubrica O
::incluiTag(4,"codRubrica","itensRemuneracao") // E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(4,"qtdRubrica","itensRemuneracao") // E N 0-1 004 - Informar a quantidade de referência para apuração (em horas,
::incluiTag(4,"vlrRubrica","itensRemuneracao") // E N 1-1 14 2 Valor da Rubrica
::incluiTag(6,"/itensRemuneracao")
::incluiTag(5,"/verbasRescisorias")
::incluiTag(4,"/contribIndividual")
::incluiTag(4,"servPubIndConselho")             // infoTSVTermino 4 Servidor Público indicado para Conselho ou Órgão Representativo;
::incluiTag(4,"dtTermino","servPubIndConselho") //E D 0-1 010 - Data do Término
::incluiTag(4,"/servPubIndConselho")
::incluiTag(4,"dirigenteSindical")             // infoTSVTermino 4 Dirigente Sindical 0-1 - OC
::incluiTag(4,"dtTermino","dirigenteSindical") // E D 0-1 010 - Data do Término
::incluiTag(4,"/dirigenteSindical")
::incluiTag(4,"estagiario")             // infoTSVTermino 4 informações do estagiário 0-1 - OC
::incluiTag(4,"dtTermino","estagiario") // E D 0-1 010 - Data do Término
::incluiTag(4,"/estagiario")
::incluiTag(3,"/infoTSVTermino")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtTSVTermino")

* 40 dirigenteSindical infoTSVTermino G - 0-1 - - Dirigente Sindical
* 42 estagiario infoTSVTermino G - 0-1 - - informações do estagiário


RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2800() Desligamento
* -----------------------------------------------------------------------------*
METHOD S2800() CLASS eSocial

::incluiTag(1,"evtDesligamento")            // 1 Evento Desligamento 1-1 - O
::incluiTag(1,"versao",::versao)   // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")                  // evtDesligamento 2 Informações do evento 1-1 idEvento O
::incluiTag(2,"idEvento","infEvento")       // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")                  // infEvento 3 Informações de Identificação do Evento 1-1 - O
::incluiTag(3,"indRetificacao","ideEvento") // E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")       // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"tpAmb","ideEvento")          // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")        // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")    // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")        // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")              // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
::incluiTag(3,"tpInscricao","ideEmpregador")// E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )// E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")                 // infEvento 3 Informações de Identificação do  Trabalhador e do Vínculo 1-1 cpfTrab, nisTrab,
::incluiTag(3,"cpfTrab","ideVinculo")       // E N 1-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab","ideVinculo")       // E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"matricula","ideVinculo")     // E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoDesligamento")                      // infEvento 3 Desligamento 1-1 - O
::incluiTag(3,"motivoDesligamento","infoDesligamento") // E N 1-1 002 - Código de Motivo do Desligamento, conforme tabela 19.
::incluiTag(3,"dtDesligamento","infoDesligamento")     // E D 0-1 010 - Preencher com a data de desligamento do trabalhador para o
::incluiTag(3,"indPagtoAPI","infoDesligamento")        // E C 1-1 001 - Indicativo de pagamento de Aviso Prévio Indenizado:
::incluiTag(3,"nrAtestadoObito","infoDesligamento")    // E C 0-1 030 - Número que identifica o registro do Atestado de Óbito. Campo
::incluiTag(3,"nrProcTrabalhista","infoDesligamento")  // E C 0-1 020 - Número que identifica o processo trabalhista, quando o
::incluiTag(3,"bcFgtsMesAnt","infoDesligamento")       // E N 1-1 14 2 Informar a base de cálculo do FGTS do mês anterior, caso ainda
::incluiTag(3,"observacao","infoDesligamento")         // E C 0-1 255 - Preencher com qualquer anotação relevante sobre o
::incluiTag(4,"sucessaoVinculo")                       // infoDesligamento 4 Sucessão do Vínculo Trabalhista 0-1 - O (se
::incluiTag(4,"cnpjSucessora","sucessaoVinculo")       // E N 1-1 014 - Preencher com o CNPJ da empresa sucessora.
::incluiTag(4,"/sucessaoVinculo")
::incluiTag(4,"verbasRescisorias")            // infoDesligamento 4 Verbas Rescisórias 0-1 - OC
::incluiTag(4,"bcCP","verbasRescisorias")     // E N 1-1 14 2 Informar o valor total da base de cálculo da contribuição
::incluiTag(4,"bcIRRF","verbasRescisorias")   // E N 1-1 14 2 Informar o valor total da base de cálculo IRRF para o
::incluiTag(4,"bcFGTS","verbasRescisorias")   // E N 1-1 14 2 Informar o valor total da base de cálculo do FGTS para o
::incluiTag(4,"bcFGTSVerbasIndeniz","verbasRescisorias")  // E N 0-1 14 2 Base de Cálculo do FGTS relativo às verbas indenizatórias
::incluiTag(4,"descCP","verbasRescisorias")   // E N 1-1 14 2 preencher com o valor descontado do segurado referente
::incluiTag(4,"vlrProventos","verbasRescisorias")  // E N 1-1 14 2 Informar o valor total dos proventos
::incluiTag(4,"vlrDescontos"," verbasRescisorias")  // E N 1-1 14 2 Preencher com o valor total dos descontos
::incluiTag(4,"vlrLiquido","verbasRescisorias")  // E N 1-1 14 2 Preencher com o valor líquido
::incluiTag(4,"itensRemuneracao","verbasRescisorias")  // G - 1-50 - - Registro que relaciona as rubricas que compõe a remuneração
::incluiTag(5,"itensRemuneracao")              // verbasRescisorias 5 Itens da Remuneração do Trabalhador 1-50 codRubrica O
::incluiTag(5,"codRubrica","itensRemuneracao") // E C 1-1 030 - Informar o código atribuído pela empresa e que identifica a
::incluiTag(5,"qtdRubrica","itensRemuneracao") // E N 0-1 004 - Informar a quantidade de referência para apuração (em horas,
::incluiTag(5,"vlrRubrica","itensRemuneracao") // E N 1-1 14 2 Valor da Rubrica
::incluiTag(5,"/itensRemuneracao")
::incluiTag(5,"expAgenteNocivo")           // verbasRescisorias 5 Grau de Exposição a Agentes Nocivos 1-1 grauExp O
::incluiTag(5,"grauExp","expAgenteNocivo") // E N 1-1 001 - Preencher com o código que representa o
::incluiTag(5,"/expAgenteNocivo")
::incluiTag(4,"/verbasRescisorias")
::incluiTag(3,"/infoDesligamento")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtDesligamento")

RETURN Self
*------------------------------------------------------------------------------*




*------------------------------------------------------------------------------*
*S2820() Reintegração
* -----------------------------------------------------------------------------*
METHOD S2820() CLASS eSocial

::incluiTag(1,"evtReintegracao")         // 1 Evento Reintegração 1-1 - O
::incluiTag(1,"versao",::versao)// A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")               // evtReintegracao 2 Informações do evento 1-1 idEvento O
::incluiTag(2,"idEvento","infEvento")    // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")               // infEvento 3 Informações de Identificação do Evento 1-1 - O
::incluiTag(3,"indRetificacao","ideEvento") // E N 1-1 001 - Informe [1] para arquivo original ou [2] para arquivo de
::incluiTag(3,"nrRecibo","ideEvento")    // E N 0-1 015 - Preencher com o número do recibo do arquivo a ser retificado.
::incluiTag(3,"tpAmb","ideEvento")       // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")     // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento") // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")     // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")    // infEvento 3 Informações de identificação do empregador 1-1 tpInscricao, nrInscricao O
::incluiTag(3,"tpInscricao","ideEmpregador") // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp ) // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"ideVinculo")           // infEvento 3 Informações de Identificação do Trabalhador e do Vínculo 1-1 cpfTrab, nisTrab,
::incluiTag(3,"cpfTrab","ideVinculo") // E N 1-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab","ideVinculo") // E N 1-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"matricula","ideVinculo")// E C 1-1 030 - Matrícula atribuída ao trabalhador pela empresa
::incluiTag(3,"/ideVinculo")
::incluiTag(3,"infoReintegracao")                   // infEvento 3 Reintegração 1-1 -
::incluiTag(3,"tpReintegracao","infoReintegracao")  // E N 1-1 001 - Tipo de Reintegração:
::incluiTag(3,"nrProcJud","infoReintegracao")       // E C 0-1 020 - Em caso de reintegração por determinação judicial, preencher
::incluiTag(3,"nrLeiAnistia","infoReintegracao")    //  E C 0-1 020 - Número da Lei de Anistia:
::incluiTag(3,"dtEfeito"," infoReintegracao")       // E D 1-1 010 - Preencher com a data a partir da qual o trabalhador deverá ser
::incluiTag(3,"dtEfeitoRetorno","infoReintegracao") // E D 1-1 010 - Informar a data do efetivo retorno ao trabalho
::incluiTag(3,"/infoReintegracao")
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtReintegracao")


RETURN Self
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
*S2900() Exclusão de Eventos
* -----------------------------------------------------------------------------*
METHOD S2900() CLASS eSocial

::incluiTag(1,"evtExclusao")                   // 1 Exclusão de Evento Enviado Indevidamente 1-1 - O
::incluiTag(1,"versao",::versao)          // A C 1-1 005 - Deve ser informado o código do leiaute utilizado para geração
::incluiTag(2,"infEvento")                     // evtExclusao 2 Informações do evento 1-1 idEvento O
::incluiTag(2,"idEvento","infEvento")          // A C 1-1 020 - Identificador que representa unicamente o evento dentro do lote
::incluiTag(3,"ideEvento")                     // infEvento 3 Informações de identificação do evento 1-1 - O
::incluiTag(3,"tpAmb","ideEvento")             // E N 1-1 001 - Identificação do ambiente:
::incluiTag(3,"procEmi","ideEvento")           // E N 1-1 001 - Processo de emissão do evento:
::incluiTag(3,"indSegmento","ideEvento")       // E N 1-1 001 - Indicador do segmento da e-Social ao qual se refere o arquivo,
::incluiTag(3,"verProc","ideEvento")           // E C 1-1 020 - Versão do processo de emissão do evento. Informar a versão do
::incluiTag(3,"/ideEvento")
::incluiTag(3,"ideEmpregador")                 // infEvento 3 Informações de identificação do empregador  1-1 tpInscricao, nrInscricao O
::incluiTag(3,"tpInscricao","ideEmpregador")   // E N 1-1 001 - Preencher com o código correspondente ao tipo de inscrição,
::incluiTag(3,"nrInscricao",::cNpjEmp )   // E C 1-1 014 - Indicar o número de inscrição do contribuinte, conforme
::incluiTag(3,"/ideEmpregador")
::incluiTag(3,"infoExclusao")                  // infEvento 3 Informação do evento que será excluído 1-1
::incluiTag(3,"tpEvento","infoExclusao")       // E C 1-1 006 - Preencher com o tipo de evento, conforme tabela 9.
::incluiTag(3,"nrReciboEvento","infoExclusao") // E N 0-1 015 - Preencher com o número do recibo do evento que será excluído.
::incluiTag(3,"cpfTrab","infoExclusao")        // E N 0-1 011 - Preencher com o número do CPF do trabalhador
::incluiTag(3,"nisTrab","infoExclusao")        // E N 0-1 011 - Preencher com o número de inscrição do segurado, o qual pode
::incluiTag(3,"/infoExclusao") 
::incluiTag(2,"/infEvento")
::incluiTag(1,"/evtExclusao")


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






