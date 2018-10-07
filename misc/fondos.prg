/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 * http://www.geocities.com/harbour_minigui/
 *
 * Adapted for ooHG by Gustavo Asborno <gustavo@lahersistemas.com.ar>
 * 
*/

#include "oohg.ch"

#define ROJO     1
#define VERDE    2
#define AZUL     3
#define MORADO   4
#define AZULC    5
#define AMACAFE  6
#define BLANCO   7
#define ANGULO   90    // Angulo del Difuminado
#define SEPARA   .F.   // Separa el difuminado

Function Main
DEFINE WINDOW Form_1 AT 0,0 WIDTH 500 HEIGHT 450 MAIN ;
  ON PAINT Difuminado( "Form_1", 500, 450, ANGULO, VERDE, SEPARA ) ;
  NOSIZE NOMAXIMIZE BACKCOLOR BLACK ;
  TITLE ' FONDOS DE VENTANA '

	DEFINE MAIN MENU

		POPUP 'File'
			ITEM 'Blue' 	ACTION  Difuminado( "Form_1", 500, 450, ANGULO, AZUL, SEPARA )
			ITEM 'Green' 	ACTION  Difuminado( "Form_1", 500, 450, ANGULO, VERDE, SEPARA )
			ITEM 'Red' 		ACTION  Difuminado( "Form_1", 500, 450, ANGULO, ROJO, SEPARA )
			ITEM 'White' 	ACTION  Difuminado( "Form_1", 500, 450, ANGULO, BLANCO, SEPARA )
			ITEM 'Background image' Action PonerImagen()
			SEPARATOR
			ITEM 'Exit' 	ACTION MsgInfo ('File:Exit')
		END POPUP

		POPUP 'Test' 
			ITEM 'Item 1' 		ACTION MsgInfo ('Item 1')
			ITEM 'Item 2' 		ACTION MsgInfo ('Item 2')
			POPUP 'Item 3' name test
				ITEM 'Item 3.1' 		ACTION MsgInfo ('Item 3.1') 
				ITEM 'Item 3.2' 		ACTION MsgInfo ('Item 3.2')
				POPUP 'Item 3.3'
					ITEM 'Item 3.3.1' 		ACTION MsgInfo ('Item 3.3.1')
					ITEM 'Item 3.3.2' 		ACTION MsgInfo ('Item 3.3.2')
					POPUP 'Item 3.3.3' 	
						ITEM 'Item 3.3.3.1' 		ACTION MsgInfo ('Item 3.3.3.1')
						ITEM 'Item 3.3.3.2' 		ACTION MsgInfo ('Item 3.3.3.2')
						ITEM 'Item 3.3.3.3' 		ACTION MsgInfo ('Item 3.3.3.3')
						ITEM 'Item 3.3.3.4' 		ACTION MsgInfo ('Item 3.3.3.4')
						ITEM 'Item 3.3.3.5' 		ACTION MsgInfo ('Item 3.3.3.5')
						ITEM 'Item 3.3.3.6' 		ACTION MsgInfo ('Item 3.3.3.6')  
					END POPUP
					ITEM 'Item 3.3.4' 		ACTION MsgInfo ('Item 3.3.4')
				END POPUP
			END POPUP
			ITEM 'Item 4' 		ACTION MsgInfo ('Item 4')
		END POPUP
		POPUP 'Help'
			ITEM 'About' 		ACTION MsgInfo ('Help:ABout')
		END POPUP
	END MENU
       
   END WINDOW

   CENTER WINDOW Form_1
   ACTIVATE WINDOW Form_1

Return Nil
*---------------------------------------------------*
Static Function PonerImagen()
DrawPicture(Form_1.hWnd, "Wall.bmp", 1)
return

*---------------------------------------------------*
Static Function Difuminado( wnd, nX, nY, nAng, nCol, lSep )
Local nYY:=nY/255, i1, nSep
nSep:=IF(lSep,1,4)
FOR i1 := 0 TO 255
  DO CASE
    CASE nCol = 1
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {i1,0,0}  , nSep)
    CASE nCol = 2
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {0,i1,0}  , nSep)
    CASE nCol = 3
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {0,0,i1}  , nSep)
    CASE nCol = 4
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {i1,0,i1} , nSep)
    CASE nCol = 5
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {0,i1,i1} , nSep)
    CASE nCol = 6
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {i1,i1,0} , nSep)
    CASE nCol = 7
      DRAWLINE(wnd, INT(nYY*i1), 0, INT(nYY*(i1+nAng)), nX, {i1,i1,i1}, nSep)
  ENDCASE
NEXT
RETURN
*---------------------------------------------------*

#pragma BEGINDUMP

#define HB_OS_WIN_USED
#define _WIN32_WINNT   0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

#define NIL                        (0)  // Nothing...
//  Drawing styles

#define HB_CENTER                      0
#define HB_TILE                        1
#define HB_STRETCH                     2

HB_FUNC ( DRAWPICTURE )
{    
    HWND       hWnd = ( HWND ) hb_parnl( 1 );
    HDC        dc = GetDC( hWnd );
    HANDLE     picture;
    BITMAP     bitmap;
    HDC        bits;
    HANDLE     old;
    
    POINT      size;
    POINT      origin = { NIL,NIL };

    RECT       box;
    int        row;
    int        col;
    
    int desktopx ;
    int desktopy ;

     GetWindowRect (hWnd, &box );
     desktopx = box.right - box.left;
     desktopy = box.bottom -box.top;


    if ((picture = LoadImage (NIL,hb_parc(2),IMAGE_BITMAP,NIL,NIL,LR_LOADFROMFILE)) == NULL) {
        hb_retl (FALSE);
        }

    if ((bits = CreateCompatibleDC (dc)) == NULL) {
        DeleteObject (picture);
        hb_retl (FALSE);
        }

    if ((old = SelectObject (bits,picture)) == NULL) {
        DeleteObject (picture);
        DeleteDC (bits);
        hb_retl (FALSE);
        }
    
    SetMapMode (bits,GetMapMode (dc));
    
    if (!GetObject (picture,sizeof (BITMAP), (LPSTR) &bitmap)) {
        SelectObject (bits,old);
        DeleteObject (picture);
        DeleteDC (bits);
        hb_retl (FALSE);
        }

    size.x = bitmap.bmWidth;
    size.y = bitmap.bmHeight;
    DPtoLP (dc,&size,1);
    
    origin.x = NIL;
    origin.y = NIL;
    DPtoLP (bits,&origin,1);

    switch (hb_parnl(3)) {

        case HB_CENTER :

             box.left = (desktopx - size.x) / 2;
             box.top  = (desktopy - size.y) / 2;

             BitBlt (dc,
                     box.left,
                     box.top,
                     size.x,
                     size.y,
                     bits,
                     origin.x,
                     origin.y,
                     SRCCOPY);
             break;

        case HB_TILE :

             for (row = NIL; row < ((desktopy / size.y) + 1); row++) {

                 for (col = NIL; col < ((desktopx / size.x) + 1); col++) {

                     box.left = col * size.x;
                     box.top = row * size.y;
    
                     BitBlt (dc,
                             box.left,
                             box.top,
                             size.x,
                             size.y,
                             bits,
                             origin.x,
                             origin.y,
                             SRCCOPY);
                     }
                 }
              break;

         case HB_STRETCH :

              StretchBlt (dc,
                          NIL,
                          NIL,
                          desktopx,
                          desktopy,
                          bits,
                          origin.x,
                          origin.y,
                          size.x,
                          size.y,
                          SRCCOPY);
              break;
              }

    SelectObject (bits,old);    
    DeleteDC     (bits);
    DeleteObject (picture);
    ReleaseDC(hWnd, dc);

    hb_retl (TRUE);
}

#pragma ENDDUMP
