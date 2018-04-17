/*        IDE: HMI+
*     Project: C:\sys3000
*        Item: Main1.prg
* Description:
*      Author:
*/

#include 'minigui.ch'
#include 'set.ch'
*------------------------------------------------------*
Function Main1()
*------------------------------------------------------*
   LOCAL Color_dia1 := { || IIF( INT(ORDKEYNO()/2)=ORDKEYNO()/2 , RGB(208,241,249) ,  RGB(255,255,255)) }
   SET CENTURY ON
   SET DATE FRENCH
   SET DELETE ON
   SET BROWSESYNC ON
   SET INTERACTIVECLOSE ON
   SET SOFTSEEK OFF
   SET NAVIGATION EXTENDED
   SET AUTOPEN ON

   REQUEST DBFCDX
   RDDSETDEFAULT("DBFCDX")
   IF FILE('fm.log')
      FERASE('fm.log')
   ENDIF

   oWnd98   := ''
   lHayMovStk := .F.
   LOAD WINDOW excel2precios
   CENTER WINDOW excel2precios
   oWin:=GETFORMOBJECT("excel2precios")
   ACTIVATE WINDOW excel2precios

   CIERRA()
RETURN(NIL)


STATIC FUNCTION nuevoarchivo()
   LOCAL cLinea,cFolder
   STATIC cFolder1
   cArchivo := GETFILE({{'Planilla de Precios','*.xls'}},'Seleccione planilla Excel...',,.F.,.T.)
   IF EMPTY(cArchivo)
      RETURN(NIL)
   ENDIF

   cFolder := GETFOLDER('Seleccione carpeta de datos de la empresa a actualizar...',GETCURRENTFOLDER())
   nContador := nActu := 0
   IF EMPTY(cFolder)
      RETURN(NIL)
   ENDIF
   cFolder1 := de88 := cFolder
   SET DEFAULT TO (de88)
   IF ABREBASE(cFolder+'\listas','lis',0)
      lis->(ORDSETFOCUS('lis_full'))
   ELSE
      MSGBOX('Precios MAL '+cFolder)
      RETURN(NIL)
   ENDIF

   IF MSGOKCANCEL('Confirma proceso ?')
      nNumero := TRATO_FORMUL('03','9999')
      nContador := 1
      excel2precios.statusbar.item(1):=' PERIODO procesando...'
      CurSorWait()
      ********************* EMPIEZA TRABAJO CON PLANILLA ***********************
      oExcel := TOleAuto():New( "Excel.Application" )
      IF Ole2TxtError() != 'S_OK'
         MSGSTOP('Excel no está disponible!' )
         RETURN(NIL)
      ENDIF
      IF FILE(cArchivo)
         oWorkBook := oExcel:WorkBooks:Open(cArchivo,,.T.)
         //oExcel:WorkBooks:Open(cArchivo,,.T.)      // Abre en forma readonly
      ELSE
         MSGSTOP('Archivo no encontrado','Lectura de Excel')
         RETURN(NIL)
      ENDIF
      oExcel:Sheets(1):Select()
      oHoja := oExcel:Get("ActiveSheet")
      oExcel:Visible := .F.
      oExcel:DisplayAlerts := .F.    // <---- esta elimina mensajes
      ************** LOOP LECTURA PLANILLA EXCEL ******************
      nFilas := oHoja:UsedRange:Rows:Count()
      nColumnas := oHoja:UsedRange:Columns:Count()
      MSGBOX('Se van a procesar '+STRZERO(nFilas,6)+' filas')
      CARTEL('ACTUALIZANDO BASES DE '+cFolder)
      oWnd98:progress98:show()
      FOR I=1 TO nFilas
          excel2precios.statusbar.item(2):=STRZERO(++nContador,8)
          IF nContador%100=0
             oWnd98:label_4:value     := TRANSFORM(ROUND(nContador*100/nFilas,1),'@E 999.9')+' %'
             oWnd98:progress98:value  := nContador*100/nFilas
          ENDIF

          uCodArt   := oHoja:cells(I,1):value
          cDescrip  := oHoja:cells(I,2):value
          uPrecio   := oHoja:cells(I,3):value

          IF VALTYPE(uPrecio)='N'
             nPrecio := uPrecio
             IF VALTYPE(uCodArt)='N'
                cCodArt := STR(uCodArt,13)
             ELSE
                cCodArt := ALLTRIM(uCodArt)
             ENDIF
             cDescrip := LEFT(cDescrip,30)

             IF !EMPTY(cCodArt)
                ACTUALIZASYS2003(ALLTRIM(cCodArt),nPrecio,cDescrip)
             ENDIF
          ENDIF
          DO EVENTS
      NEXT
      *************************************************************

      oExcel:DisplayAlerts := .F.    // <---- esta elimina mensajes
      oWorkBook:Close()
      oExcel:Quit()
      oWorkBook := NIL
      oHoja     := NIL
      oExcel    := NIL
      RELEASE oWorkBook
      RELEASE oHoja
      RELEASE oExcel

      BORRACARTEL()
      DBCOMMITALL()
      excel2precios.statusbar.item(1):=' PERIODO '
      //oWin:Browse_1:value := RECNO()
      //oWin:Browse_1:setfocus()
      MSGBOX('Proceso finalizado...')
      SALIR()
   ENDIF
RETURN(NIL)


STATIC FUNCTION reindexa()
RETURN(NIL)


STATIC FUNCTION actualizasys2003(cCodArt,nPrecio,cDescrip)
   SELE lis
   DBGOTOP()
   ORDSETFOCUS('lis_full')
   IF !DBSEEK('     55'+cCodArt,.F.)
      NAPPEND()
   ELSE
      NRLOCK()
   ENDIF
   REPLACE codlista   WITH 55,;
           articulo   WITH HB_ANSITOOEM(cCodArt),;
           descrip    WITH HB_ANSITOOEM(cDescrip),;
           precio     WITH nPrecio
RETURN(NIL)


STATIC FUNCTION salir()
   oWin:release()
RETURN(NIL)


STATIC FUNCTION defineventanaprogress()
   DEFINE WINDOW ventprogress OBJ oWnd99 ;
      AT 0,0 ;
      WIDTH 300 HEIGHT 130 ;
      TITLE 'Avance' MODAL BACKCOLOR {87,147,139}

      @ 30,10 PROGRESSBAR progress99 OF ventprogress ;
        RANGE 0,100 SMOOTH ;
        WIDTH 260
   END WINDOW
   CENTER WINDOW ventprogress
   ACTIVATE WINDOW ventprogress
RETURN(NIL)


STATIC FUNCTION cartel(cTitulo1,cTitulo2,cTitulo3,cTitulo4)
   SET INTERACTIVECLOSE OFF
   DEFAULT cTitulo1 TO ' '
   DEFAULT cTitulo2 TO ' '
   DEFAULT cTitulo3 TO ' '
   DEFAULT cTitulo4 TO ' '
   DEFINE WINDOW cartel OBJ oWnd98 ;
      AT 0,0 ;
      WIDTH 288 HEIGHT 140 ;
      TITLE 'Espere...' MODAL BACKCOLOR {150,216,201}

      @ 05,10 LABEL label_1 OF cartel ;
        VALUE cTitulo1 ;
        WIDTH 260 HEIGHT 25 ;
        FONT 'Arial' ;
        BOLD ;
        SIZE 09 ;
        TRANSPARENT
      @ 22,10 LABEL label_2 OF cartel ;
        VALUE cTitulo2 ;
        WIDTH 260 HEIGHT 25 ;
        FONT 'Arial' ;
        BOLD ;
        SIZE 09 ;
        TRANSPARENT
      @ 39,10 LABEL label_3 OF cartel ;
        VALUE cTitulo3 ;
        WIDTH 260 HEIGHT 25 ;
        FONT 'Arial' ;
        BOLD ;
        SIZE 09 ;
        TRANSPARENT
      @ 56,10 LABEL label_4 OF cartel ;
        VALUE cTitulo4 ;
        WIDTH 260 HEIGHT 25 ;
        FONT 'Arial' ;
        BOLD ;
        SIZE 09 ;
        TRANSPARENT
      @ 73,10 PROGRESSBAR progress98 OF cartel ;
        RANGE 0,100 SMOOTH ;
        WIDTH 260
   END WINDOW
   oWnd98:progress98:hide()
   CENTER WINDOW cartel
   ACTIVATE WINDOW cartel NOWAIT
   CURSORWAIT()
RETURN(NIL)


STATIC FUNCTION borracartel()
   CURSORARROW()
   RELEASE WINDOW cartel
   SET INTERACTIVECLOSE ON
RETURN(NIL)


STATIC FUNCTION ayuda()
   shellexecute(0,'open','notepad.exe','ayuda1.txt',,1)
RETURN(NIL)
