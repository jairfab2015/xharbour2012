CREATE PROCEDURE MAPA_TRIBUTACAOVENDAS (
    datai date,
    dataf date,
    modelo varchar(2),
    status char(1),
    cnpj varchar(18))
returns (
    dataemissao date,
    docini integer,
    docfim integer,
    st000_tributado double precision,
    st040_isento double precision,
    st060_substtributado double precision,
    st090_outros double precision,
    valorcontabil double precision,
    st060_combustivel double precision,
    st060_derivadopetroleo double precision,
    st060_produto double precision,
    piscofins double precision)
as
declare variable icodigonf integer;
declare variable idataemissao date;
declare variable i2dataemissao date;
declare variable doc integer;
declare variable vdoc integer;
declare variable vst000_tributado double precision;
declare variable vst040_isento double precision;
declare variable vst060_substtributado double precision;
declare variable vst090_outros double precision;
declare variable vvalorcontabil double precision;
declare variable vst060_combustivel double precision;
declare variable vst060_produto double precision;
declare variable vst060_derivadopetroleo double precision;
declare variable vpiscofins double precision;
declare variable tst000_tributado double precision;
declare variable tst040_isento double precision;
declare variable tst060_substtributado double precision;
declare variable tst090_outros double precision;
declare variable tvalorcontabil double precision;
declare variable tst060_combustivel double precision;
declare variable tst060_produto double precision;
declare variable tst060_derivadopetroleo double precision;
declare variable tpiscofins double precision;
BEGIN
    TST000_TRIBUTADO        = 0;
    TST040_ISENTO           = 0;
    TST060_SUBSTTRIBUTADO   = 0;
    TST090_OUTROS           = 0;
    TVALORCONTABIL          = 0;
    TST060_COMBUSTIVEL      = 0;
    TST060_PRODUTO          = 0;
    TST060_DERIVADOPETROLEO = 0;
    TPISCOFINS              = 0;

    FOR SELECT NF.CODIGONF, NF.DATAEMISSAO, NF.DOCUMENTO, NF.VALORPISCOFINS
        FROM NOTAFISCAL NF
        WHERE NF.DATAEMISSAO BETWEEN :DATAI AND :DATAF
        AND ((NF.STATUS = '#') OR (NF.STATUS = :STATUS))
        AND NF.TIPOMOVIMENTO STARTING 'S'
        AND NF.NOTAFISCALCANCELADA = 0
        AND NF.MODELO = :MODELO
        AND NF.CNPJ = :CNPJ ORDER BY DATAEMISSAO
        INTO :ICODIGONF, :DATAEMISSAO, :DOC, :VPISCOFINS DO BEGIN

            IF (VPISCOFINS IS NULL) THEN VPISCOFINS = 0;

            TPISCOFINS = TPISCOFINS + VPISCOFINS;

            IF (DOCINI IS NULL) THEN DOCINI = VDOC;

            IF ((DATAEMISSAO <> IDATAEMISSAO) AND (IDATAEMISSAO IS NOT NULL)) THEN BEGIN
                I2DATAEMISSAO           = DATAEMISSAO;
                DATAEMISSAO             = IDATAEMISSAO;
                ST000_TRIBUTADO         = TST000_TRIBUTADO;
                ST040_ISENTO            = TST040_ISENTO;
                ST060_SUBSTTRIBUTADO    = TST060_SUBSTTRIBUTADO;
                ST090_OUTROS            = TST090_OUTROS;
                VALORCONTABIL           = TVALORCONTABIL;
                ST060_COMBUSTIVEL       = TST060_COMBUSTIVEL;
                ST060_PRODUTO           = TST060_PRODUTO;
                ST060_DERIVADOPETROLEO  = TST060_DERIVADOPETROLEO;

                PISCOFINS               = TPISCOFINS;
                DOCFIM                  = VDOC;

                TST000_TRIBUTADO        = 0;
                TST040_ISENTO           = 0;
                TST060_SUBSTTRIBUTADO   = 0;
                TST090_OUTROS           = 0;
                TVALORCONTABIL          = 0;
                TST060_COMBUSTIVEL      = 0;
                TST060_PRODUTO          = 0;
                TST060_DERIVADOPETROLEO = 0;
                TPISCOFINS              = 0;

                SUSPEND;
                DATAEMISSAO = I2DATAEMISSAO;
                DOCINI      = NULL;
            END

            VDOC         = DOC;
            IDATAEMISSAO = DATAEMISSAO;

            VST000_TRIBUTADO        = 0;
            VST040_ISENTO           = 0;
            VST060_SUBSTTRIBUTADO   = 0;
            VST090_OUTROS           = 0;
            VVALORCONTABIL          = 0;
            VST060_COMBUSTIVEL      = 0;

            SELECT
            SUM((CASE WHEN SUBSTRING(NFC.CODIGOTRIBUTACAO FROM 1 FOR 3) = '000' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ST000_TRIBUTADO,
            SUM((CASE WHEN SUBSTRING(NFC.CODIGOTRIBUTACAO FROM 1 FOR 3) = '040' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ST040_ISENTO,
            SUM((CASE WHEN SUBSTRING(NFC.CODIGOTRIBUTACAO FROM 1 FOR 3) = '060' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ST060_SUBSTTRIBUTADO,
            SUM((CASE WHEN SUBSTRING(NFC.CODIGOTRIBUTACAO FROM 1 FOR 3) = '090' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ST090_OUTROS,
            SUM((CASE WHEN NFC.VALORTOTAL IS NULL THEN 0 ELSE NFC.VALORTOTAL - NFC.VALORDESCONTO END)) AS VALORCONTABIL,
            SUM((CASE WHEN SUBSTRING(NFC.CODIGOTRIBUTACAO FROM 1 FOR 3) = '060' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ST060_COMBUSTIVEL
            FROM NOTAFISCALCOMBUSTIVEL NFC
            WHERE NFC.CODIGONF = :ICODIGONF
            INTO :VST000_TRIBUTADO, :VST040_ISENTO, :VST060_SUBSTTRIBUTADO, :VST090_OUTROS, :VVALORCONTABIL, :VST060_COMBUSTIVEL;

            IF (VST000_TRIBUTADO        IS NULL) THEN VST000_TRIBUTADO      = 0;
            IF (VST040_ISENTO           IS NULL) THEN VST040_ISENTO         = 0;
            IF (VST060_SUBSTTRIBUTADO   IS NULL) THEN VST060_SUBSTTRIBUTADO = 0;
            IF (VST090_OUTROS           IS NULL) THEN VST090_OUTROS         = 0;
            IF (VVALORCONTABIL          IS NULL) THEN VVALORCONTABIL        = 0;
            IF (VST060_COMBUSTIVEL      IS NULL) THEN VST060_COMBUSTIVEL    = 0;

            TST000_TRIBUTADO        = TST000_TRIBUTADO      + VST000_TRIBUTADO;
            TST040_ISENTO           = TST040_ISENTO         + VST040_ISENTO;
            TST060_SUBSTTRIBUTADO   = TST060_SUBSTTRIBUTADO + VST060_SUBSTTRIBUTADO;
            TST090_OUTROS           = TST090_OUTROS         + VST090_OUTROS;
            TVALORCONTABIL          = TVALORCONTABIL        + VVALORCONTABIL;
            TST060_COMBUSTIVEL      = TST060_COMBUSTIVEL    + VST060_COMBUSTIVEL;

            SELECT
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '000' THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST000_TRIBUTADO,
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '040' THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST040_ISENTO,
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '060' THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST060_SUBSTTRIBUTADO,
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '090' THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST090_OUTROS,
            SUM((CASE WHEN NFP.VALORTOTAL IS NULL THEN 0 ELSE NFP.VALORTOTAL - NFP.VALORDESCONTO END)) AS VALORCONTABIL,
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '060' AND (P.LUBRIFICANTE = 0) THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST060_PRODUTO,
            SUM((CASE WHEN SUBSTRING(NFP.CODIGOTRIBUTACAO FROM 1 FOR 3) = '060' AND (P.LUBRIFICANTE = 1) THEN NFP.VALORTOTAL - NFP.VALORDESCONTO ELSE 0 END)) AS ST060_DERIVADOPETROLEO
            FROM NOTAFISCALPRODUTO NFP, PRODUTO P
            WHERE NFP.CODIGONF = :ICODIGONF
            AND NFP.CODIGOPRODUTO = P.CODIGO
            INTO :VST000_TRIBUTADO, :VST040_ISENTO, :VST060_SUBSTTRIBUTADO, :VST090_OUTROS, :VVALORCONTABIL, :VST060_PRODUTO, :VST060_DERIVADOPETROLEO;

            IF (VST000_TRIBUTADO        IS NULL) THEN VST000_TRIBUTADO          = 0;
            IF (VST040_ISENTO           IS NULL) THEN VST040_ISENTO             = 0;
            IF (VST060_SUBSTTRIBUTADO   IS NULL) THEN VST060_SUBSTTRIBUTADO     = 0;
            IF (VST090_OUTROS           IS NULL) THEN VST090_OUTROS             = 0;
            IF (VVALORCONTABIL          IS NULL) THEN VVALORCONTABIL            = 0;
            IF (VST060_PRODUTO          IS NULL) THEN VST060_PRODUTO            = 0;
            IF (VST060_DERIVADOPETROLEO IS NULL) THEN VST060_DERIVADOPETROLEO   = 0;

            TST000_TRIBUTADO        = TST000_TRIBUTADO          + VST000_TRIBUTADO;
            TST040_ISENTO           = TST040_ISENTO             + VST040_ISENTO;
            TST060_SUBSTTRIBUTADO   = TST060_SUBSTTRIBUTADO     + VST060_SUBSTTRIBUTADO;
            TST090_OUTROS           = TST090_OUTROS             + VST090_OUTROS;
            TVALORCONTABIL          = TVALORCONTABIL            + VVALORCONTABIL;
            TST060_PRODUTO          = TST060_PRODUTO            + VST060_PRODUTO;
            TST060_DERIVADOPETROLEO = TST060_DERIVADOPETROLEO   + VST060_DERIVADOPETROLEO;

            SELECT
            SUM((CASE WHEN NFS.VALORTOTAL IS NULL THEN 0 ELSE NFS.VALORTOTAL - NFS.VALORDESCONTO END)) AS VALORCONTABIL
            FROM NOTAFISCALSERVICO NFS
            WHERE NFS.CODIGONF = :ICODIGONF
            INTO :VVALORCONTABIL;

            IF (VVALORCONTABIL IS NULL) THEN VVALORCONTABIL = 0;

            TVALORCONTABIL = TVALORCONTABIL + VVALORCONTABIL;

        END
        ST000_TRIBUTADO         = TST000_TRIBUTADO;
        ST040_ISENTO            = TST040_ISENTO;
        ST060_SUBSTTRIBUTADO    = TST060_SUBSTTRIBUTADO;
        ST090_OUTROS            = TST090_OUTROS;
        VALORCONTABIL           = TVALORCONTABIL;
        ST060_COMBUSTIVEL       = TST060_COMBUSTIVEL;
        ST060_PRODUTO           = TST060_PRODUTO;
        ST060_DERIVADOPETROLEO  = TST060_DERIVADOPETROLEO;
        PISCOFINS               = TPISCOFINS;
        DOCFIM                  = DOC;

        SUSPEND;
END
