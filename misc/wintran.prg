/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 * http://www.geocities.com/harbour_minigui/
 *
 * Adapted from "Transparency Sample By Grigory Filatov"
*/

#include "oohg.ch"

static on_change

PROCEDURE Main

  local Ventana

	DEFINE WINDOW Form_1 OBJ Ventana ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		MAIN ;
		NOMINIMIZE ;
		NOMAXIMIZE ;
		NOSIZE ;
		NOSYSMENU ;
		NOCAPTION ;
  	BACKCOLOR BLACK ;
		ON INIT ( Ventana:Slider_1:enabled := .f., ;
              RemoveTransparency( Ventana ), ;
              Ventana:TextBox_1:enabled := .f., ;
              Ventana:Button_1:enabled := .t., ;
              Ventana:Button_2:enabled := .f.)
              
    on key ESCAPE of Form_1 action ( Ventana:Slider_1:enabled := .f., ;
              RemoveTransparency( Ventana ), ;
              Ventana:TextBox_1:enabled := .f., ;
              Ventana:Button_1:enabled := .t., ;
              Ventana:Button_2:enabled := .f.)

		@ 10, 200 LABEL lbl_aviso ;
			VALUE	"PRESS ESCAPE TO RESTORE INVISIBLE WINDOW" ;
			WIDTH	190 ;
			HEIGHT 40 ;
			BACKCOLOR BLACK ;
      FONTCOLOR BLUE

		@ 10, 10 BUTTON Button_1 ;
			CAPTION 'Set Transparency ON' ;
			WIDTH	140 ;
			NOTRANSPARENT ;
			ACTION ( Ventana:Slider_1:enabled := .t., ;
               Ventana:TextBox_1:enabled := .t., ;
               Ventana:Button_1:enabled := .f., ;
               Ventana:Button_2:enabled := .t., ;
               Ventana:Slider_1:Value := 180)

		@ 40, 10 BUTTON Button_2 ;
			CAPTION 'Set Transparency OFF' ;
			WIDTH	140 ;
			ACTION ( Ventana:Slider_1:enabled := .f., ;
               RemoveTransparency( Ventana ), ;
               Ventana:TextBox_1:enabled := .f., ;
               Ventana:Button_1:enabled := .t., ;
               Ventana:Button_2:enabled := .f. )

		@ 50, 200 BUTTON Button_3 ;
			CAPTION "Invisible Background" ;
			WIDTH	140 ;
      ACTION MakeBackgroundInvisible( Ventana )
    Ventana:Button_3:backcolor := BLACK
    Ventana:Button_3:fontcolor := YELLOW

		DEFINE SLIDER Slider_1
			ROW	80
			COL	10
			VALUE	255
			WIDTH	310
			HEIGHT	50
			RANGEMIN 0
			RANGEMAX 255
			ON CHANGE Slider_Change( Ventana )
		END SLIDER

		@ 140, 10 LABEL lbl_transparent ;
			VALUE	"TRANSPARENT" ;
			WIDTH	100 ;
			HEIGHT 24

		@ 140, 220 LABEL lbl_opaque ;
			VALUE	"OPAQUE" ;
			WIDTH	100 ;
			HEIGHT 24 ;
      TRANSPARENT ;
      RIGHTALIGN

		@ 85, 330 TEXTBOX TextBox_1 ;
			VALUE	255 ;
			INPUTMASK "999" ;
			WIDTH	50 ;
			HEIGHT 24 ;
			DISABLED ;
			ON CHANGE TextBox_Change( Ventana )

	END WINDOW

  on_change := .f.
  
	Ventana:center()
	Ventana:activate()

Return

/*
*/
Function TextBox_Change (Ventana)

  if on_change
    return
  endif
  on_change := .t.
  
  with object Ventana
    :Slider_1:Value := :TextBox_1:Value

  	If .not. SetTransparency( :hWnd, :Slider_1:Value )
  		MsgStop( "This Sample Runs In Win2000/XP Only!", "Error" )
  	EndIf
  end with

  on_change := .f.
  
Return Nil

/*
*/
Function Slider_Change (Ventana)

  if on_change
    return
  endif
  on_change := .t.

  with object Ventana
  	:TextBox_1:Value := :Slider_1:Value
  	:redraw()

  	If .not. SetTransparency( :hWnd, :Slider_1:Value )
  		MsgStop( "This Sample Runs In Win2000/XP Only!", "Error" )
  	EndIf
  end with

  on_change := .f.

Return Nil

/*
*/
#define GWL_EXSTYLE	    (-20)
#define WS_EX_LAYERED   524288
#define LWA_COLORKEY    1
#define LWA_ALPHA       2

/*
*/
Function MakeBackgroundInvisible (Ventana)
	LOCAL nRet, lRet := .F.

  with object Ventana
  	SetWindowLong( :hWnd, GWL_EXSTYLE,  C_OR( GetWindowLong( :hWnd, GWL_EXSTYLE ), WS_EX_LAYERED ) )

  	nRet := SetLayeredWindowAttributes( :hWnd, :backcolor, 0, LWA_COLORKEY )
  	IF VALTYPE(nRet) == 'N'
  		lRet := ( nRet > 0 )
  	ENDIF
  end with

RETURN( lRet )

/*
*/
FUNCTION SetTransparency( hWnd, nAlpha )
	LOCAL nRet, lRet := .F.

	SetWindowLong( hWnd, GWL_EXSTYLE,  C_OR( GetWindowLong( hWnd, GWL_EXSTYLE ), WS_EX_LAYERED ) )

	nRet := SetLayeredWindowAttributes( hWnd, 0, nAlpha, LWA_ALPHA )
	IF VALTYPE(nRet) == 'N'
		lRet := ( nRet > 0 )
	ENDIF

RETURN( lRet )

/*
*/
PROCEDURE RemoveTransparency( Ventana )

  on_change := .t.
  
  with object Ventana
    :Slider_1:Value := 255
    :TextBox_1:Value := 255

    SetWindowLong(:hWnd, GWL_EXSTYLE, C_AND( GetWindowLong( :hWnd, GWL_EXSTYLE ), C_NOT(WS_EX_LAYERED) ) )

*	  RedrawWindow( :hWnd )
    :redraw()
  end with

  on_change := .f.

RETURN

/*
   SetLayeredWindowAttributes WRAPPER.
   The SetLayeredWindowAttributes function sets the opacity and transparency color key of a layered window.
   Parameters:
   - hwnd	Handle to the layered window.
   - crKey	Pointer to a COLORREF value that specifies the transparency color key to be used.
		(When making a certain color transparent...).
   - bAlpha	Alpha value used to describe the opacity of the layered window.
		0 = Invisible, 255 = Fully visible
   - dwFlags	Specifies an action to take. This parameter can be LWA_COLORKEY
		(When making a certain color transparent...) or LWA_ALPHA.

DECLARE DLL_TYPE_LONG SetLayeredWindowAttributes( ;
	DLL_TYPE_LONG hWnd, DLL_TYPE_INT crKey, DLL_TYPE_UINT bAlpha, DLL_TYPE_DWORD dwFlags ) ;
	IN USER32.DLL
*/

#pragma BEGINDUMP

#include "windows.h"
#include "commctrl.h"
#include "hbapi.h"
#include "oohg.h"

HB_FUNC( GETWINDOWLONG )
{
   HB_RETNL( GetWindowLong( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( SETWINDOWLONG )
{
   HB_RETNL( SetWindowLong( HWNDparam( 1 ), hb_parni( 2 ), HB_PARNL( 3 ) ) );
}

HB_FUNC( SETLAYEREDWINDOWATTRIBUTES )
{
   hb_retni( SetLayeredWindowAttributes( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parnl( 4 ) ));
}

HB_FUNC( C_AND )
{
   HB_RETNL( HB_PARNL( 1 ) & HB_PARNL( 2 ) ) ;
}

HB_FUNC( C_OR )
{
   HB_RETNL( HB_PARNL( 1 ) | HB_PARNL( 2 ) ) ;
}

HB_FUNC( C_NOT )
{
   HB_RETNL( ~ HB_PARNL( 1 ) ) ;
}

#pragma ENDDUMP

/*
EOF
*/
