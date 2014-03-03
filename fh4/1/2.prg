#include "FastRepH.ch"

PROCEDURE main

   USE Labels NEW
   FrPrn := frReportManager():new()
   FrPrn:LoadFromFile("Labels.fr3")
   FrPrn:DesignReport()
   FrPrn:DestroyFR()
   QUIT
  
RETURN
