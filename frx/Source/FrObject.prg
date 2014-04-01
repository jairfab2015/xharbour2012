/*
 * Xailer source code:
 *
 * Component.prg
 * Clase TFrObject()
 *
 * Copyright 2003, 2007 Jose F. Gimenez
 * Copyright 2003, 2007 Xailer.com
 * All rights reserved
 *
 */

#include "frh.ch"

//--------------------------------------------------------------------------

CLASS XFrObject

EXPORTED:
   VAR Cargo
   VAR oParent

   METHOD New( oParent ) CONSTRUCTOR
   METHOD Create( oParent ) CONSTRUCTOR

   METHOD Free()     VIRTUAL
   METHOD End()

RESERVED:
   DATA lCreated  INIT .F. READONLY

END CLASS

//--------------------------------------------------------------------------

METHOD New( oParent ) CLASS XFrObject

   IF oParent = NIL
      ::oParent := oParent
   ENDIF

RETURN Self

//--------------------------------------------------------------------------

METHOD Create( oParent ) CLASS XFrObject

   IF oParent = NIL
      ::oParent := oParent
   ENDIF

   ::lCreated := .T.

RETURN Self

//--------------------------------------------------------------------------

METHOD End() CLASS XFrObject

   ::Free()
   ::lCreated := .F.
   Self := Nil

RETURN Nil

//--------------------------------------------------------------------------
