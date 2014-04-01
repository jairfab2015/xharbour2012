/*
 * Xailer source code:
 *
 * Copyright 2003-2005 Xailer.com
 * All rights reserved
 *
 */

#define __C__
#ifdef _WINDOWS_H
   #define _WINDOWS_
#endif

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbvm.h>
#include <hbdate.h>
#include <hbstack.h>
#ifndef __XHARBOUR__
   #include <hbapicls.h>
#endif

#define XA_DLL_EXPORT _declspec( dllexport )

#if defined(__EXPORT__) && defined(__XHARBOUR__)
   #define XA_EXPORT _declspec( dllexport )
#else
   #define XA_EXPORT
#endif

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

// funciones para obtener el valor de una data de un objeto
long        XA_ObjGetNL( PHB_ITEM obj, const char *varname );
double      XA_ObjGetND( PHB_ITEM obj, const char *varname );
char *      XA_ObjGetC( PHB_ITEM obj, const char *varname );
char *      XA_ObjGetCLen( PHB_ITEM obj, const char *varname, UINT *len );
long        XA_ObjGetLen( PHB_ITEM obj, const char *varname );
BOOL        XA_ObjGetL( PHB_ITEM obj, const char *varname );
void *      XA_ObjGetPtr( PHB_ITEM obj, const char *varname );
PHB_ITEM    XA_ObjGetItem( PHB_ITEM obj, const char *varname );
PHB_ITEM    XA_ObjGetItemCopy( PHB_ITEM obj, const char *varname );

//-------------------------------------------------------------------------
// funciones para llamar a un metodo pasando un parametro o
// asignar el valor de una data de un objeto
void     XA_ObjSendNil( PHB_ITEM obj, const char *member );
void     XA_ObjSendNL( PHB_ITEM obj, const char *member, long value );
void     XA_ObjSendNL2( PHB_ITEM obj, const char *member, long value1, long value2 );
void     XA_ObjSendNL3( PHB_ITEM obj, const char *member, long value1, long value2, long value3 );
void     XA_ObjSendNL4( PHB_ITEM obj, const char *member, long value1, long value2, long value3, long value4 );
void     XA_ObjSendNL5( PHB_ITEM obj, const char *member, long value1, long value2, long value3, long value4, long value5 );
void     XA_ObjSendND( PHB_ITEM obj, const char *member, double value );
void     XA_ObjSendC( PHB_ITEM obj, const char *member, const char *value );
void     XA_ObjSendL( PHB_ITEM obj, const char *member, BOOL value );
void     XA_ObjSendPtr( PHB_ITEM obj, const char *member, void * value );
void     XA_ObjSendItem( PHB_ITEM obj, const char *member, PHB_ITEM value );
void     XA_ObjSendItem2( PHB_ITEM obj, const char *member, PHB_ITEM value1, PHB_ITEM value2 );

// llama a un metodo de un objeto sin parametros
void     XA_ObjSend( PHB_ITEM obj, const char *member );

