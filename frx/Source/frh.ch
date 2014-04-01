/*
 * Proyect: FastReport for [x]Harbour
 * Description: Include file
 * Copyright: Ignacio Ortiz de Zúñiga, Xailer
 *
 * This source code is not free software. You can not redistribute it
 * in any manner, even partially.
 * You may only modify it for personal needs, but in no case to make a
 * a product that can compete with FastReport for [x]Harbour
 */

#ifdef __XHARBOUR__
   #translate OTHERWISE => DEFAULT
   #xtranslate CurPath() => CurDrive() + ":\" + CurDir()
#else
   #xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
   #xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
   #xcommand THROW(<oErr>) => (Eval(ErrorBlock(), <oErr>), Break(<oErr>))
   #xcommand FINALLY => ALWAYS
   #xcommand TEXT INTO <v> => #pragma __text|<v>+=%s+hb_eol();<v>:=""
   #xtranslate CurPath() => hb_CurDrive() + ":\" + CurDir()
#endif

#include "HbClass.ch"

#define FR_DLLNAME   "Frx.DLL"

#define PROPERTY_NULO 0
#define PROPERTY_NUMERO_ENTERO 1
#define PROPERTY_NUMERO_DOBLE 2
#define PROPERTY_FECHA 3
#define PROPERTY_LOGICO 4
#define PROPERTY_CADENA 5
#define PROPERTY_BLOB 6

#define ON_AFTER_PRINT 1 //sObjName
#define ON_AFTER_PRINTREPORT 2
#define ON_BEFORE_CONNECT 3 //sConnectName
#define ON_BEFORE_PRINT 4 //sObjName
#define ON_BEGIN_DOC 5
#define ON_CLICK_OBJ 6 //sObjName, nButton
#define ON_END_DOC 7
#define ON_GET_VALUE 8 //sVarName
#define ON_MOUSE_OVER_OBJ 9 //sObjName
#define ON_PREVIEW 10
#define ON_PRINT_PAGE 11
#define ON_PRINT_REPORT 12
#define ON_PROGRESS 13 //nProgressType , nProgress
#define ON_PROGRESS_STOP 14 //nProgressType , nProgress
#define ON_PROGRESS_START 15 //nProgressType , nProgress
#define ON_USER_FUNCTION 16 //sFuncName , aParams --> xRet
#define ON_END_PREVIEW 17

#define ON_DS_CLOSE 101 // --> Nil
#define ON_DS_FIRST 102 // --> Nil
#define ON_DS_NEXT 103 // --> Nil
#define ON_DS_OPEN 104 // --> Nil
#define ON_DS_PRIOR 105 // --> Nil

#define simMessageBoxes 0
#define simReThrow 1
#define simSilent 2
#define ppAll  0
#define ppEven 1
#define ppOdd  2
#define zmDefault 0
#define zmWholePage 1
#define zmPageWidth 2
#define zmManyPages 3

// Compatibility

#translate RESERVED FUNCTION => FUNCTION
#translate RESERVED: => EXPORTED:



