#include 'oohg.ch'

FUNCTION Main

   DEFINE WINDOW Main ;
      WIDTH 500 ;
      HEIGHT 500

      @ 10, 10 LABEL lbl_1 ;
         VALUE "Message:" ;
         WIDTH 60

      @ 10, 80 TEXTBOX txt_msg ;
         WIDTH 200

      @ 40, 10 LABEL lbl_2 ;
         VALUE "Title:" ;
         WIDTH 60

      @ 40, 80 TEXTBOX txt_ttl ;
         WIDTH 200

      @ 70, 10 LABEL lbl_3 ;
         VALUE "Size:" ;
         WIDTH 60

      @ 70, 80 TEXTBOX txt_sz ;
         WIDTH 40 ;
         NUMERIC

      @ 100, 10 BUTTON but ;
         CAPTION "Show" ;
         ACTION MsgTemp( Main.txt_msg.value, Main.txt_ttl.value, 5, GREEN, Main.txt_sz.value )

      ON KEY ESCAPE ACTION ThisWindow.Release()
   END WINDOW

   CENTER WINDOW Main
   ACTIVATE WINDOW Main

RETURN NIL

/*------------------------------------------------------------------------------*
* Aporte Original de Sergio Castellari
* Contribucion a los calculos de las cadenas de Grigory Filatov
* Colaboracion de Ciro Vargas Clemow
* Desarrollado por Renan Zapata el 23-12-2008
* Adaptado para OOHG por Fernando Yurisich el 17/04/18
*
* MsgTemp() Visualiza en pantalla un mensaje temporal.
* Recibe:
* cMensaje = Texto a Visualizar -obligatorio- . Para visializar varias lineas, separelas con CRLF
* cTitulo = Texto de cabecera *
* nTiempo = segundos a visualizarlo -optativo- default 3 segs. *
* cColor = Color de la Fuentes *
* nTamanio = Tamaño de la Fuente *
* nWidth = Ancho de la Ventana *
* nHeight = Alto de la Ventana *
*
* GTH()  Devuelve el alto en pixeles de una cadena de caracteres segun el tamaño de la letra utilizada
* Recibe:
* cStr = Cadena de caracteres a evaluar
* nFont = Tamaño de la letra utilizada en puntos
* Devuelve = Numero de pixeles de alto
*
* GTW()  Devuelve el ancho en pixeles de una cadena de caracteres segun el tamaño de la letra utilizada
* Recibe:
* cStr = Cadena de caracteres a evaluar
* nFont = Tamaño de la letra utilizada en puntos
* Devuelve = Numero de pixeles de ancho
*------------------------------------------------------------------------------*/

FUNCTION MsgTemp( cMensaje, cTitulo, nTiempo, cColor, nTamanio, nWidth, nHeight )

   LOCAL aux := Array(3), i, uFont

   DEFAULT nTiempo  TO 3, ;
           cColor   TO BLACK, ;
           nTamanio TO 9, ;
           cTitulo  TO '¡ See !'

   uFont := InitFont( "Arial", nTamanio, .F., .F., .F., .F., 0, DEFAULT_CHARSET, 0, 0, .F. )

   // determinamos cuantas lineas contiene el mensaje
   aux[1] := MLCount( cMensaje )
   // ahora determinamos la mayor altura x linea y el mayor largo
   IF nWidth = NIL
      aux[2] := 0
      nWidth := 0
      FOR i := 1 TO aux[1]
         aux[2] := Max( nWidth, GTW( AllTrim( MemoLine( cMensaje, 254, i ) ), uFont ) )
         nWidth := aux[2]
      NEXT
   ENDIF

   IF nHeight = NIL
      nHeight := GTH( MemoLine( cMensaje, 254, 1 ), uFont ) * MLCount( cMensaje )
   ENDIF

   DEFINE WINDOW frmMensajes AT 0,0 WIDTH ( nWidth + 50 ) HEIGHT ( nHeight + 60 ) TITLE cTitulo MODAL NOSYSMENU
      DEFINE LABEL lblMensajes
         ROW 10
         COL 10
         WIDTH ( nWidth + 10 )
         HEIGHT nHeight
         VALUE cMensaje
         FONTSIZE nTamanio
         FONTCOLOR cColor
         BORDER .T.
      END LABEL
   END WINDOW

   CENTER WINDOW frmMensajes
   ACTIVATE WINDOW frmMensajes NOWAIT

   DO WHILE nTiempo >= 0
      DO EVENTS
      Inkey( 0.5 )
      nTiempo := nTiempo - 0.5
   ENDDO

   frmMensajes.Release()

   DeleteObject( uFont )

RETURN .T.


FUNCTION GTH( cStr, uFont )
RETURN GetTextHeight( NIL, cStr, uFont )


FUNCTION GTW( cStr, uFont )
RETURN GetTextWidth( NIL, cStr, uFont )

/*
 * EOF
 */
