CREATE PROCEDURE MAPA_TRIBUTACAO (
    datai date,
    dataf date,
    modelo varchar(2),
    status char(1),
    cnpj varchar(18))
returns (
    dataemissao date,
    base_calc_07 double precision,
    base_calc_12 double precision,
    base_calc_18 double precision,
    base_calc_25 double precision,
    base_calc_27 double precision,
    total_trib double precision,
    alcool double precision,
    diesel double precision,
    gasolina double precision,
    total_comb double precision)
as
declare variable icodigonf integer;
declare variable idataemissao date;
declare variable i2dataemissao date;
declare variable vbase_calc_07 double precision;
declare variable vbase_calc_12 double precision;
declare variable vbase_calc_18 double precision;
declare variable vbase_calc_25 double precision;
declare variable vbase_calc_27 double precision;
declare variable vtotal_trib double precision;
declare variable valcool double precision;
declare variable vdiesel double precision;
declare variable vgasolina double precision;
declare variable vtotal_comb double precision;
declare variable tbase_calc_07 double precision;
declare variable tbase_calc_12 double precision;
declare variable tbase_calc_18 double precision;
declare variable tbase_calc_25 double precision;
declare variable tbase_calc_27 double precision;
declare variable ttotal_trib double precision;
declare variable talcool double precision;
declare variable tdiesel double precision;
declare variable tgasolina double precision;
declare variable ttotal_comb double precision;
BEGIN
    TBASE_CALC_07  = 0;
    TBASE_CALC_12  = 0;
    TBASE_CALC_18  = 0;
    TBASE_CALC_25  = 0;
    TBASE_CALC_27  = 0;
    TTOTAL_TRIB    = 0;
    TALCOOL        = 0;
    TDIESEL        = 0;
    TGASOLINA      = 0;
    TTOTAL_COMB    = 0;

    FOR SELECT NF.CODIGONF, NF.DATAEMISSAO
        FROM NOTAFISCAL NF
        WHERE NF.DATAEMISSAO BETWEEN :DATAI AND :DATAF
        AND ((NF.STATUS = '#') OR (NF.STATUS = :STATUS))
        AND NF.TIPOMOVIMENTO STARTING 'S'
        AND NF.NOTAFISCALCANCELADA = 0
        AND NF.MODELO = :MODELO
        AND NF.CNPJ = :CNPJ ORDER BY DATAEMISSAO
        INTO :ICODIGONF, :DATAEMISSAO DO BEGIN

            IF ((DATAEMISSAO <> IDATAEMISSAO) AND (IDATAEMISSAO IS NOT NULL)) THEN BEGIN
                I2DATAEMISSAO  = DATAEMISSAO;
                DATAEMISSAO    = IDATAEMISSAO;
                BASE_CALC_07   = TBASE_CALC_07;
                BASE_CALC_12   = TBASE_CALC_12;
                BASE_CALC_18   = TBASE_CALC_18;
                BASE_CALC_25   = TBASE_CALC_25;
                BASE_CALC_27   = TBASE_CALC_27;
                TOTAL_TRIB     = TTOTAL_TRIB;
                ALCOOL         = TALCOOL;
                DIESEL         = TDIESEL;
                GASOLINA       = TGASOLINA;
                TOTAL_COMB     = TTOTAL_COMB;
                TBASE_CALC_07  = 0;
                TBASE_CALC_12  = 0;
                TBASE_CALC_18  = 0;
                TBASE_CALC_25  = 0;
                TBASE_CALC_27  = 0;
                TTOTAL_TRIB    = 0;
                TALCOOL        = 0;
                TDIESEL        = 0;
                TGASOLINA      = 0;
                TTOTAL_COMB    = 0;

                SUSPEND;
                DATAEMISSAO    = I2DATAEMISSAO;
            END

            IDATAEMISSAO = DATAEMISSAO;

            BASE_CALC_07    = 0;
            BASE_CALC_12    = 0;
            BASE_CALC_18    = 0;
            BASE_CALC_25    = 0;
            BASE_CALC_27    = 0;
            TOTAL_TRIB      = 0;

            SELECT
            SUM((CASE WHEN NFC.VALORICMSALIQUOTA = 07 THEN NFC.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_07,
            SUM((CASE WHEN NFC.VALORICMSALIQUOTA = 12 THEN NFC.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_12,
            SUM((CASE WHEN NFC.VALORICMSALIQUOTA = 18 THEN NFC.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_18,
            SUM((CASE WHEN NFC.VALORICMSALIQUOTA = 25 THEN NFC.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_25,
            SUM((CASE WHEN NFC.VALORICMSALIQUOTA = 27 THEN NFC.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_27,
            SUM((CASE WHEN NFC.VALORICMSBASECALCULO IS NULL THEN 0 ELSE NFC.VALORICMSBASECALCULO END)) AS TOTAL_TRIB,
            SUM((CASE WHEN C.DESCRICAO LIKE '%LCOOL%'    THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS ALCOOL,
            SUM((CASE WHEN C.DESCRICAO LIKE '%DIESEL%'   THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS DIESEL,
            SUM((CASE WHEN C.DESCRICAO LIKE '%GASOLINA%' THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS GASOLINA,
            SUM((CASE WHEN NFC.VALORTOTAL IS NOT NULL THEN NFC.VALORTOTAL - NFC.VALORDESCONTO ELSE 0 END)) AS TOTAL_COMB
            FROM NOTAFISCALCOMBUSTIVEL NFC, COMBUSTIVEL C
            WHERE C.CODIGO = NFC.CODIGOCOMBUSTIVEL
            AND NFC.CODIGONF = :ICODIGONF
            INTO :VBASE_CALC_07, :VBASE_CALC_12, :VBASE_CALC_18, :VBASE_CALC_25, :VBASE_CALC_27, :VTOTAL_TRIB,
            :VALCOOL, :VDIESEL, :VGASOLINA, :VTOTAL_COMB;

            IF (VBASE_CALC_07 IS NULL) THEN VBASE_CALC_07 = 0;
            IF (VBASE_CALC_12 IS NULL) THEN VBASE_CALC_12 = 0;
            IF (VBASE_CALC_18 IS NULL) THEN VBASE_CALC_18 = 0;
            IF (VBASE_CALC_25 IS NULL) THEN VBASE_CALC_25 = 0;
            IF (VBASE_CALC_27 IS NULL) THEN VBASE_CALC_27 = 0;
            IF (VTOTAL_TRIB   IS NULL) THEN VTOTAL_TRIB   = 0;
            IF (VALCOOL       IS NULL) THEN VALCOOL       = 0;
            IF (VDIESEL       IS NULL) THEN VDIESEL       = 0;
            IF (VGASOLINA     IS NULL) THEN VGASOLINA     = 0;
            IF (VTOTAL_COMB   IS NULL) THEN VTOTAL_COMB   = 0;

            TBASE_CALC_07   = TBASE_CALC_07 + VBASE_CALC_07;
            TBASE_CALC_12   = TBASE_CALC_12 + VBASE_CALC_12;
            TBASE_CALC_18   = TBASE_CALC_18 + VBASE_CALC_18;
            TBASE_CALC_25   = TBASE_CALC_25 + VBASE_CALC_25;
            TBASE_CALC_27   = TBASE_CALC_27 + VBASE_CALC_27;
            TTOTAL_TRIB     = TTOTAL_TRIB   + VTOTAL_TRIB;
            TALCOOL         = TALCOOL       + VALCOOL;
            TDIESEL         = TDIESEL       + VDIESEL;
            TGASOLINA       = TGASOLINA     + VGASOLINA;
            TTOTAL_COMB     = TTOTAL_COMB   + VTOTAL_COMB;

            SELECT
            SUM((CASE WHEN NFP.VALORICMSALIQUOTA = 07 THEN NFP.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_07,
            SUM((CASE WHEN NFP.VALORICMSALIQUOTA = 12 THEN NFP.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_12,
            SUM((CASE WHEN NFP.VALORICMSALIQUOTA = 18 THEN NFP.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_18,
            SUM((CASE WHEN NFP.VALORICMSALIQUOTA = 25 THEN NFP.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_25,
            SUM((CASE WHEN NFP.VALORICMSALIQUOTA = 27 THEN NFP.VALORICMSBASECALCULO ELSE 0 END)) AS BASE_CALC_27,
            SUM((CASE WHEN NFP.VALORICMSBASECALCULO IS NULL THEN 0 ELSE NFP.VALORICMSBASECALCULO END)) AS TOTAL_TRIB
            FROM NOTAFISCALPRODUTO NFP
            WHERE NFP.CODIGONF = :ICODIGONF
            INTO :VBASE_CALC_07, :VBASE_CALC_12, :VBASE_CALC_18, :VBASE_CALC_25, :VBASE_CALC_27, :VTOTAL_TRIB;

            IF (VBASE_CALC_07 IS NULL) THEN VBASE_CALC_07 = 0;
            IF (VBASE_CALC_12 IS NULL) THEN VBASE_CALC_12 = 0;
            IF (VBASE_CALC_18 IS NULL) THEN VBASE_CALC_18 = 0;
            IF (VBASE_CALC_25 IS NULL) THEN VBASE_CALC_25 = 0;
            IF (VBASE_CALC_27 IS NULL) THEN VBASE_CALC_27 = 0;
            IF (VTOTAL_TRIB   IS NULL) THEN VTOTAL_TRIB   = 0;

            TBASE_CALC_07    = TBASE_CALC_07 + VBASE_CALC_07;
            TBASE_CALC_12    = TBASE_CALC_12 + VBASE_CALC_12;
            TBASE_CALC_18    = TBASE_CALC_18 + VBASE_CALC_18;
            TBASE_CALC_25    = TBASE_CALC_25 + VBASE_CALC_25;
            TBASE_CALC_27    = TBASE_CALC_27 + VBASE_CALC_27;
            TTOTAL_TRIB      = TTOTAL_TRIB   + VTOTAL_TRIB;
        END
        BASE_CALC_07   = TBASE_CALC_07;
        BASE_CALC_12   = TBASE_CALC_12;
        BASE_CALC_18   = TBASE_CALC_18;
        BASE_CALC_25   = TBASE_CALC_25;
        BASE_CALC_27   = TBASE_CALC_27;
        TOTAL_TRIB     = TTOTAL_TRIB;
        ALCOOL         = TALCOOL;
        DIESEL         = TDIESEL;
        GASOLINA       = TGASOLINA;
        TOTAL_COMB     = TTOTAL_COMB;

        SUSPEND;
END
