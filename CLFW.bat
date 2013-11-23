@ECHO OFF
CLS


REM ****************************************************************************
REM Verificar se o Fonte foi Especificado e se Existe.
REM ****************************************************************************
IF A%1 == A       GOTO :SINTAX
IF NOT EXIST %1.* GOTO :NOEXIST

SET NAME_EXE=%1


GOTO BCC

:BCC
CLS
ECHO *****************
ECHO *** Bcc       ***
ECHO *****************
ECHO.
SET FW_LIB_ADD =-lfiveh -lfivehc
SET HB_LIB_ADD =-lhbct -lhbtip -lpng -lhbfship -lhbxpp -lhbwin -lxhb
SET CC_LIB_ADD =-lpsapi -lVersion -lOleDlg
GOTO ENV

REM ****************************************************************************
REM Definiçao do Ambiente e Diretorios.
REM ****************************************************************************
:ENV
SET HB_DIR =C:\MINIGUI\HARBOUR
SET CC_DIR =C:\Bcc55
SET HB_LIB =%HB_DIR%\Lib\win\bcc
SET FW_DIR =C:\FwH

SET INCLUDE =%CC_DIR%\INCLUDE;%HB_DIR%\INCLUDE;%FW_DIR%\INCLUDE
SET LIB     =%CC_DIR%\Lib;%HB_LIB%;%FW_DIR%\Lib
SET PATH    =%CC_DIR%\Bin;%HB_DIR%\Bin;%FW_DIR%

SET OBJ_DIR =.\win\%COMP_CC%\obj
SET LOG_DIR =.\win\%COMP_CC%\log
SET BIN_DIR =.\win\%COMP_CC%\bin

IF NOT EXIST %OBJ_DIR% md %OBJ_DIR%
IF NOT EXIST %BIN_DIR% md %BIN_DIR%
IF NOT EXIST %LOG_DIR% md %LOG_DIR%

SET LIB_GUI =-i%FW_DIR%\include -L%FW_DIR%\lib %FW_LIB_ADD% %HB_LIB_ADD% %CC_LIB_ADD%

GOTO BUILD


REM ****************************************************************************
REM COMPILAÇAO.
REM ****************************************************************************
:BUILD
IF EXIST %OBJ_DIR%\%1.obj del %OBJ_DIR%\%1.obj
IF EXIST %OBJ_DIR%\%1.c   del %OBJ_DIR%\%1.c
IF EXIST %BIN_DIR%\%NAME_EXE%.exe del %BIN_DIR%\%NAME_EXE%.exe
ECHO Compilando....
hbmk2.exe -gui -trace -inc -comp=bcc -workdir=%OBJ_DIR% -o%BIN_DIR%\%NAME_EXE% %LIB_GUI% %1 >%LOG_DIR%\bcc.log
IF ERRORLEVEL 1 GOTO HBMK2ERROR
%BIN_DIR%\%NAME_EXE%.exe
GOTO EXIT


REM ****************************************************************************
REM Saidas do Batch.
REM ****************************************************************************
:NOEXIST
ECHO O Arquivo %1 especificado nao existe.
GOTO EXIT

:SINTAX
ECHO Nao foi especificado nenhum Arquivo Fonte.
ECHO sintax: hbmkbc [fontes]/[scripts]
ECHO         Default:APP GUI
GOTO EXIT

:HBMK2ERROR
ECHO Nao foi possivel Criar o Executavel.
GOTO EXIT

:EXIT
ECHO.
ECHO.
PAUSE
