#VisualFW Borland make, (c) FiveTech Software 2005-2011

HBDIR=c:\harbour
BCDIR=c:\bcc582
FWDIR=..\

#change these paths as needed
.path.OBJ = .\obj
.path.PRG = .\
.path.CH  = $(FWDIR)\include;$(HBDIR)\include
.path.C   = .\
.path.rc  = .\

#important: Use Uppercase for filenames extensions!

PRGS =         \
.\RhEsocial.PRG               

OBJ = $(PRGS:.PRG=.OBJ)
OBJS = $(OBJ:.\=.\obj\)

PROJECT    : RhEsocial.EXE 

RhEsocial.EXE : $(OBJS) ..\lib\FiveH.lib ..\lib\FiveHC.lib
   echo off
   echo $(BCDIR)\lib\c0w32.obj + > b32.bc
   echo $(OBJS), + >> b32.bc
   echo RhEsocial.exe, + >> b32.bc
   echo RhEsocial.map, + >> b32.bc
   echo $(FWDIR)\lib\FiveH.lib $(FWDIR)\lib\FiveHC.lib + >> b32.bc
   echo $(HBDIR)\lib\hbrtl.lib + >> b32.bc
   echo $(HBDIR)\lib\hbvm.lib + >> b32.bc
   echo $(HBDIR)\lib\gtgui.lib + >> b32.bc
   echo $(HBDIR)\lib\hblang.lib + >> b32.bc
   echo $(HBDIR)\lib\hbmacro.lib + >> b32.bc
   echo $(HBDIR)\lib\hbrdd.lib + >> b32.bc
   echo $(HBDIR)\lib\rddntx.lib + >> b32.bc
   echo $(HBDIR)\lib\rddcdx.lib + >> b32.bc
   echo $(HBDIR)\lib\rddfpt.lib + >> b32.bc
   echo $(HBDIR)\lib\hbsix.lib + >> b32.bc
   echo $(HBDIR)\lib\hbdebug.lib + >> b32.bc
   echo $(HBDIR)\lib\hbcommon.lib + >> b32.bc
   echo $(HBDIR)\lib\hbpp.lib + >> b32.bc
   echo $(HBDIR)\lib\hbpcre.lib + >> b32.bc
   echo $(HBDIR)\lib\hbwin.lib + >> b32.bc
   echo $(HBDIR)\lib\hbcpage.lib + >> b32.bc
   echo $(HBDIR)\lib\hbct.lib + >> b32.bc
   echo $(HBDIR)\lib\hbcplr.lib + >> b32.bc
   echo $(HBDIR)\lib\png.lib + >> b32.bc
   echo $(HBDIR)\lib\hbzlib.lib + >> b32.bc
   echo $(HBDIR)\lib\xhb.lib + >> b32.bc

   echo $(BCDIR)\lib\cw32.lib + >> b32.bc
   echo $(BCDIR)\lib\import32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\odbc32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\nddeapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\iphlpapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\msimg32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\psapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\rasapi32.lib, >> b32.bc

   IF EXIST visualfw.res echo visualfw.res >> b32.bc
   $(BCDIR)\bin\ilink32 -Gn -aa -Tpe -s @b32.bc
   del b32.bc

.PRG.OBJ:
  $(HBDIR)\bin\harbour $< /N /W /Oobj\ /I$(FWDIR)\include;$(HBDIR)\include
  $(BCDIR)\bin\bcc32 -c -tWM -I$(HBDIR)\include -oobj\$& obj\$&.c

.C.OBJ:
  echo -c -tWM -D__HARBOUR__ > tmp
  echo -I$(HBDIR)\include;$(FWDIR)\include >> tmp
  $(BCDIR)\bin\bcc32 -oobj\$& @tmp $&.c
  del tmp

VISUALFW.RES : VISUALFW.RC
  $(BCDIR)\bin\brc32.exe -r -I$(BCDIR)\include visualfw.rc
