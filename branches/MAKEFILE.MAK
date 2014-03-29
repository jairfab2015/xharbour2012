#*******************************************************
# ESTA PARTE ES FIJA Y NO SE DEBERIA TOCAR             *
# ENTRE LOS DIVERSOS MAKEFILES.                        *
#                                                      *
# SI QUEREMOS RECOMPILAR TODO USAREMOS MAKE -B         *
#                                                      *
# SI DESEAMOS GUARDAR LOS FICHEROS TEMPORALES MAKE -K  *
#                                                      *
#*******************************************************
#
# ATENCION LA DOBLE BARRA AL FINAL DEL
# NOMBRE DE LOS DIRECTORIOS SIRVE PARA
# QUE MAKE TOME UNA DE ELLAS COMO PARTE
# DE LA ETIQUETA
#
HARBOUR  = J:\MINIGUI\HARBOUR\\
MINIGUI  = J:\MINIGUI\\
BORLAND  = J:\BCC55\\

HARBOUR_EXE = $(HARBOUR)BIN\HARBOUR.EXE
BCC_EXE = $(BORLAND)BIN\BCC32.EXE
ILINK_EXE = $(BORLAND)BIN\ILINK32.EXE
BRC_EXE = $(BORLAND)BIN\BRC32.EXE

#
#DIRECTIVAS DE MAKE
#
.silent				#no muestra los comandos antes de ejecutarlos
.autodepend		#activar la autodependencia. por si acaso alguien la quito
#

#ORDEN DE BUSQUEDA DE LOS FICHEROS
#
.suffixes: .prg .c .obj .rc

#
# CAMINOS A TENER EN CUENTA 
#
INCLUDES_DE_HARBOUR = -I$(HARBOUR)INCLUDE;$(MINIGUI)INCLUDE
INCLUDES_DEL_COMPILADOR = -I$(HARBOUR)INCLUDE;$(MINIGUI)INCLUDE;$(BORLAND)INCLUDE
LIBRERIAS_DEL_COMPILADOR = -L$(HARBOUR)lib;$(BORLAND)LIB;$(BORLAND)LIB\PSDK
LIBRERIAS_DEL_ENLAZADO = -L$(HARBOUR)lib;$(BORLAND)LIB;$(BORLAND)LIB\PSDK

# PARAMETROS DE HARBOUR. 
# -n no crear un procedimiento implicito de arranque
# -wx nivel de avisos de 1 a 3, 0->sin avisos, 1->compatible clipper, 2->clipper+harbour, 3->chequeo de tipos, 4->operaciones sospechosas
# -esx nivel de gravedad para la salida, 0->se ignoran los warning, 1->genera output pero el codigo de salida no es cero, 2->no se genera output
# -q0 no presenta mensajes de linea ni copyright
# -o drive/directorio/nombre de los ficheros c
FLAGS_DE_HARBOUR = -n -w2 -es1 -q0 -o$@

# PARAMETROS DEL COMPILADOR.
# -c compilar unicamente
# -5 optimizar para pentium. 3 ->386, 4->486, 5->Pentium, 6->Pentium pro
# -Ox nivel de optimizaciones. 0 nada, 1 tamaño, 2 velocidad
# -tW crear aplicacion de windows. tWc->aplicacion de consola, tWd->generar dll, existen mas opciones
# -M generar el mapa de linkado
# -q no presenta mensajes. A pesar de la opcion, siempre presenta el fichero tratado
# -o drive/directorio/nombre de los ficheros obj
# por defecto, el compilador intenta crear codigo optimizado para Windows 2000 y Windows XP
# mediante la variable -DWINVER=0x400 le indicamos que nuestro sistema es Windows 95, Windows 98 o Windows NT 3.51
# mediante la variable -D_WIN32_WINNT=0x400 le indicamos que nuestro sistema es Windows NT 4.0
# se pueden incluir ambas variables
FLAGS_DE_COMPILADOR  = -c -5 -O2 -tW -M -q -o$@ -DWINVER=0x400 -D_WIN32_WINNT=0x400

# PARAMETROS DEL ENLAZADOR.
# -Gn desabilitar el enlazado incremental 
# -Tpe el enlazador genera un fichero exe de 32 bits en modo protegido para Windows
# -aa el enlazador genera un ejecutable en modo protegido que corre usando el API de Windows de 32 bits
# -q no presenta mensajes. 
# -j busca los obj en el directorio especificado
FLAGS_DEL_ENLAZADOR = -Gn -Tpe -aa -q -j$(DIRECTORIO)OBJ


#*******************************************
# ESTA PARTE ES VARIABLE Y DEPENDE DE CADA *
# PROYECTO                                 *
#*******************************************

#
# NOMBRE FINAL DE LA APLICACION
#
APLICACION = XXX.EXE

#
# FUENTE PRINCIPAL
#
NOMBRE	 = YYY

#
# DIRECTORIO DE LOS PROGRAMAS FUENTES
#
DIRECTORIO = J:\ZZZ\\


#
#DIRECTORIOS DE LOS DIVERSOS TIPOS DE PROGRAMA
#
.path.prg = $(DIRECTORIO)
.path.c = $(DIRECTORIO)OBJ
.path.obj = $(DIRECTORIO)OBJ

#
# OBJ QUE COMPONEN LA APLICACION 
#
FICHEROS_OBJ = 	FILE1.OBJ FILE2.OBJ

# OBJ QUE SE DESEA INCLUIR EN EL EJECUTABLE
# INCLUIR LA RUTA COMPLETA. EJEMPLO J:\MIS_OBJ\UN_OBJ.OBJ
# DEBE PONERSE COMO COMENTARIO SI NO EXISTEN FICHERO. #OBJ_EXTERNOS=
#
#OBJ_EXTERNOS=

# LIB QUE SE DESEA INCLUIR EN EL EJECUTABLE
# INCLUIR LA RUTA COMPLETA. EJEMPLO J:\MIS_LIB\MI_LIB.LIB
# DEBE PONERSE COMO COMENTARIO SI NO EXISTEN LIBRERIAS. #MIS_LIBRERIAS=
#
#MIS_LIBRERIAS=

#
# LIBRERIAS DE HARBOUR A INCLUIR EN EL EJECUTABLE
#
ODBC=NO
ZIP=NO
ADS=NO
MYSQL=NO

# FICHERO DE RECURSOS. 
# DEBE PONERSE COMO COMENTARIO SI NO EXISTE FICHERO DE RECURSOS. #RECUSOS=
# INCLUIR SIN EXTENSION
#
RECURSOS=WWW

# SI EXISTE FICHERO DE RECURSOS LO INCLUIMOS EN LAS DEPENDENCIAS
# SI NO EXISTE INCLUIMOS SOLO LOS OBJ
#
!if $d(RECURSOS)
TODO= $(FICHEROS_OBJ) $(DIRECTORIO)$(RECURSOS).Res
!else
TODO= $(FICHEROS_OBJ)
!endif

!message *
!message *
!message Empezando la tarea
!message *
!message *

$(DIRECTORIO)$(APLICACION): $(TODO)
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO enlazando el programa
  ECHO * 
  ECHO * 
  ECHO * 
		$(ILINK_EXE)  $(FLAGS_DEL_ENLAZADOR) $(LIBRERIAS_DEL_ENLAZADOR) @&&|     # &&| abrimos fichero temporal, @ para ILINK32
		$(FICHEROS_OBJ) + 				# esto incluye todos los obj
!if $d(OBJ_EXTERNOS)
		$(OBJ_EXTERNOS) +
!endif
		$(BORLAND)LIB\c0w32.obj, +
		$(DIRECTORIO)$(APLICACION),$(DIRECTORIO)MAPA.map, +
		$(MINIGUI)LIB\minigui.LIB +
		$(HARBOUR)LIB\rtl.lib +
		$(HARBOUR)LIB\vm.lib +
		$(HARBOUR)LIB\rdd.lib +
		$(HARBOUR)LIB\dbfcdx.lib +
		$(HARBOUR)LIB\dbfntx.lib +
		$(HARBOUR)LIB\lang.lib +
		$(HARBOUR)LIB\macro.lib +
		$(HARBOUR)LIB\debug.lib +
		$(HARBOUR)LIB\common.lib +
		$(HARBOUR)LIB\pp.lib +
		$(HARBOUR)LIB\gtwin.lib +
		$(HARBOUR)LIB\libct.lib +
		$(HARBOUR)LIB\libmisc.lib +
		$(HARBOUR)LIB\urlmon.lib +
		$(HARBOUR)LIB\codepage.lib +
!if $(ODBC)==SI
		$(HARBOUR)LIB\hbodbc.lib +
		$(HARBOUR)LIB\odbc32.lib +
!endif
!if $(ZIP)==SI
		$(HARBOUR)LIB\zlib1.lib +
		$(HARBOUR)LIB\ziparchive.lib +
!endif
!if $(ADS)==SI
		$(HARBOUR)LIB\rddads.lib +
		$(HARBOUR)LIB\ace32.lib +
!endif
!if $(MYSQL)==SI
		$(HARBOUR)LIB\mysql.lib +
		$(HARBOUR)LIB\libmysql.lib +
!endif
!if $d(MIS_LIBRERIAS)
		$(MIS_LIBRERIAS) +
!endif
		$(BORLAND)LIB\cw32.lib +
		$(BORLAND)LIB\import32.lib, 		
!if $d(RECURSOS)
		$(DIRECTORIO)$(RECURSOS).Res +
!endif
		$(MINIGUI)RESOURCES\MINIGUI.RES
|                       # | cerramos fichero temporal, el signo | debe estar en la primera columna
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO resultado correcto. Hemos creado el fichero $(DIRECTORIO)$(APLICACION)
  ECHO * 
  ECHO * 
  ECHO * 
  ECHO * 
		

# LOS FUENTES EN C SE ESCRIBIRAN EN EL DIRECTORIO OBJ
.prg.c:
  ECHO * 
  ECHO vamos a procesar con Harbour el fichero $<
  ECHO * 
    $(HARBOUR_EXE) $(FLAGS_DE_HARBOUR) $(INCLUDES_DE_HARBOUR);$(DIRECTORIO)  {$< } 
  ECHO * 
  ECHO * 

# LOS FICHEROS OBJ SE ESCRIBIRAN EN EL DIRECTORIO OBJ
.c.obj:
  ECHO * 
  ECHO vamos a procesar con bcc32 el fichero $<
  ECHO * 
    $(BCC_EXE) $(FLAGS_DE_COMPILADOR) $(INCLUDES_DEL_COMPILADOR);$(DIRECTORIO) $(LIBRERIAS_DEL_COMPILADOR)  {$< }
  ECHO * 
  ECHO * 

.rc.res:
	$(BRC_EXE) -d__BORLANDC__ -r -fo$(DIRECTORIO)$(RECURSOS).Res $(DIRECTORIO)$(RECURSOS).Rc 

clean:
# el - delante del if consigue que el make no se pare si detecta un error
  ECHO * 
  ECHO Proceso de limpieza previo a la compilacion/enlazado
  ECHO * 
    -if exists *.tds del *.tds
    -if exists *.map del *.map
