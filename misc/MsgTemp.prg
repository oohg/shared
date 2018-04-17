#include 'minigui.ch'

/*------------------------------------------------------------------------------*
* Aporte Original de Sergio Castellari
* Contribucion a los calculos de las cadenas de Grigory Filatov
* Colaboracion de Ciro Vargas Clemow
* Desarrollado por Renan Zapata el 23-12-2008


* MsgTemp() Visualiza en pantalla un mensaje temporal.
* Recibe:
* cMensaje = Texto a Visualizar -obligatorio- . Para visializar varias lineas, separelas con CRLF
* cTitulo = Texto de cabecera *
* nTiempo = segundos a visualizarlo -optativo- default 3 segs. *
* cColor = Color de la Fuentes *
* nTamanio = Tamaño de la Fuente *
* nWidth = Ancho de la Ventana *
* nHeight = Alto de la Ventana *


* GTH()  Devuelve el alto en pixeles de una cadena de caracteres segun el tamaño de la letra utilizada
* Recibe:
* cStr = Cadena de caracteres a evaluar
* nFont = Tamaño de la letra utilizada en puntos
* Devuelve = Numero de pixeles de alto


* GTW()  Devuelve el ancho en pixeles de una cadena de caracteres segun el tamaño de la letra utilizada
* Recibe:
* cStr = Cadena de caracteres a evaluar
* nFont = Tamaño de la letra utilizada en puntos
* Devuelve = Numero de pixeles de ancho

*---------------------------------------------------------------- 10-03-2007 --*
*---------------------------------------------------------------- 21-11-2008 --*
*---------------------------------------------------------------- 23-12-2008 --*/
Function MsgTemp (cMensaje,cTitulo,nTiempo,cColor,nTamanio,nWidth,nHeight)
	local aux := ARRAY(3), I

	DEFAULT nTiempo TO 3, ;
	cColor TO BLACK, ;
	nTamanio TO 9, ;
	cTitulo TO '¡ Ojo !'

	//	determinamos cuantas lineas contiene el mensaje
	AUX[1] := mlcount(cMensaje)
	//	AHORA DETERMINAMOS LA MAYOR ALTURA X LINEA Y EL MAYOR LARGO
 	IF nWidth = NIL
		AUX[2] := 0
		nWidth := 0
		FOR I := 1 TO AUX[1]
			AUX[2] := MAX(nWidth, GTW(ALLTRIM(MEMOLINE(cMensaje,,I)), nTamanio))
			nWidth := AUX[2]
		NEXT
*		nWidth := (AUX[2]*nTamanio*3/4)
	ENDIF

	IF nHeight = NIL
		nHeight := GTH(MEMOLINE(cMensaje,,1), nTamanio) * MLCOUNT(cMensaje)
*		nHeight := ((nTamanio*4/3)+5)*MLCOUNT(cMensaje)
	ENDIF

	DEFINE WINDOW frmMensajes AT 0,0 WIDTH nWidth+20 HEIGHT nHeight+60 TITLE cTitulo MODAL NOSYSMENU
		DEFINE LABEL lblMensajes
			ROW 10
			COL 10
			WIDTH nWidth
			HEIGHT nHeight
			VALUE AllTrim(cMensaje)
			FONTSIZE nTamanio
			FONTCOLOR cColor
			FONTBOLD .t.
			CENTERALIGN .t.
		END LABEL
	END WINDOW
	CENTER WINDOW frmMensajes
	ACTIVATE WINDOW frmMensajes NOWAIT
	DO WHILE nTiempo>=0
		DO EVENTS
		Inkey(.5)
		nTiempo:=nTiempo-.5
	ENDDO
	frmMensajes.RELEASE
Return .t.



*-----------------------------------------------------------------------------*
func GTH(cStr, nFont)
*-----------------------------------------------------------------------------*
Return GetTextHeight( NIL, cStr, nFont )



*-----------------------------------------------------------------------------*
func GTW(cStr, nFont)
*-----------------------------------------------------------------------------*
Return GetTextWidth( NIL, cStr, nFont )



*-----------------------------------------------------------------------------*
*Function _GetFontHandle( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
*Return ( _HMG_aControlFontHandle [ GetControlIndex ( ControlName, ParentForm ) ] )



#pragma BEGINDUMP



#include <windows.h>

#include "hbapi.h"

#include "hbapiitm.h"



HB_FUNC( GETTEXTWIDTH )  // returns the width of a string in pixels

{

    HDC   hDC        = ( HDC ) hb_parnl( 1 );

    HWND  hWnd;

    DWORD dwSize;

    BOOL  bDestroyDC = FALSE;

    HFONT hFont = ( HFONT ) hb_parnl( 3 );

    HFONT hOldFont;

    SIZE sz;



    if( ! hDC )

    {

       bDestroyDC = TRUE;

       hWnd = GetActiveWindow();

       hDC = GetDC( hWnd );

    }



    if( hFont )

       hOldFont = ( HFONT ) SelectObject( hDC, hFont );



    GetTextExtentPoint32( hDC, hb_parc( 2 ), hb_parclen( 2 ), &sz );

    dwSize = sz.cx;



    if( hFont )

       SelectObject( hDC, hOldFont );



    if( bDestroyDC )

        ReleaseDC( hWnd, hDC );



    hb_retni( LOWORD( dwSize ) );

}



HB_FUNC( GETTEXTHEIGHT ) // returns the height of a string in pixels

{

    HDC   hDC = ( HDC ) hb_parnl( 1 );

    HWND  hWnd;

    DWORD dwSize;

    BOOL  bDestroyDC = FALSE;

    HFONT hFont = ( HFONT ) hb_parnl( 3 );

    HFONT hOldFont;

    SIZE  sz;



    if( !hDC )

    {

       bDestroyDC = TRUE;

       hWnd = GetActiveWindow();

       hDC = GetDC( hWnd );

    }



    if( hFont )

    {

       hOldFont = ( HFONT ) SelectObject( hDC, hFont );

    }



    GetTextExtentPoint32( hDC, hb_parc(2), hb_parclen(2), &sz );

    dwSize = sz.cy;



    if( hFont )

    {

       SelectObject( hDC, hOldFont );

    }



    if( bDestroyDC )

    {

       ReleaseDC( hWnd, hDC );

    }



    hb_retni( LOWORD(dwSize) );

}
