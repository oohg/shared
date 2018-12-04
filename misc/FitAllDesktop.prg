/*
* MiniGUI Demo
*(c) 2004 Jacek Kubica <kubica@wssk.wroc.pl>
*
* This demo shows how to get width and height of the client area for a full-screen window 
* on the primary display monitor, in pixels and get the coordinates of the portion of the screen 
* not obscured by the system taskbar or by application desktop toolbars
*
* MINIGUI - Harbour Win32 GUI library 
* Copyright 2002-03 Roberto Lopez <roblez@ciudad.com.ar>
*/

#include "minigui.ch"

Function Main
	DEFINE WINDOW Form_1 obj Ventana ;
		AT GetDesktopRealTop(),GetDesktopRealLeft() ;
		WIDTH GETDESKTOPREALWIDTH() ;
		HEIGHT GETDESKTOPREALHEIGHT() ;
		TITLE 'Hello World!' ;
		MAIN ;
    ON INIT (Ventana:txt_Top:value    := Ventana:row, ;
             Ventana:txt_Left:value   := Ventana:col, ;
             Ventana:txt_Width:value  := Ventana:width, ;
             Ventana:txt_Height:value := Ventana:height)

    @ 030, 050 label   lbl_Top    value "Top:"
    @ 030, 100 textbox txt_Top    numeric
    @ 060, 050 label   lbl_Left   value "Left:"
    @ 060, 100 textbox txt_Left   numeric
    @ 090, 050 label   lbl_Width  value "Width:"
    @ 090, 100 textbox txt_Width  numeric
    @ 120, 050 label   lbl_Height value "Height:"
    @ 120, 100 textbox txt_Height numeric

    ON KEY ESCAPE OF (thiswindow:name()) ACTION thiswindow:release
	END WINDOW
	
	ACTIVATE WINDOW Form_1
Return

#pragma BEGINDUMP
#define _WIN32_WINNT 0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"

HB_FUNC (GETDESKTOPREALTOP) 
{
	RECT rect;
	int t ;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
	t = rect.top ;

	hb_retni(t);

}
HB_FUNC (GETDESKTOPREALLEFT) 
{
	RECT rect;
	int l ;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
	l = rect.left ;

	hb_retni(l);

}

HB_FUNC (GETDESKTOPREALWIDTH) 
{
	RECT rect;
	int w ;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
	w = rect.right - rect.left ;

	hb_retni(w);

}

HB_FUNC (GETDESKTOPREALHEIGHT) 
{
	RECT rect;
	int h ;
        SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
        h = rect.bottom - rect.top ;
	hb_retni(h);
}


