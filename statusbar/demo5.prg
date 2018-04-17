/*
 * ooHG Demo5 Textbox and Progressbar in Statusbar
 * (c) 2011 Gustavo Carlos Asborno
 * gcasborno@yahoo.com.ar
*/

#include "oohg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 600 HEIGHT 400 ;
		TITLE 'MiniGUI StatusBar Demo' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE MAIN MENU 
			POPUP '&StatusBar Test'
        ITEM 'TextBox' ACTION fTextbox()
        ITEM 'RadioGroup' ACTION fRadiogroup()
      END POPUP
			POPUP '&Help'
				ITEM '&About'		ACTION MsgInfo ("MiniGUI StatusBar Demo") 
			END POPUP
		END MENU

    DEFINE STATUSBAR FONT "Arial" SIZE 14 BOLD
      STATUSITEM '' Width 250
      STATUSITEM 'oStatusBar' Width 150
			CLOCK 
		END STATUSBAR

	END WINDOW

  ostatus:=GetControlobject('Statusbar','Form_1')

  @ 3,10 PROGRESSBAR ProgressBar_1 Widt 200 Height 18 Of (oStatus);
    Range 0,100000 Smooth

  @ 1,5 Textbox Text_1 width 200 height 20 of (oStatus) ;
    Font "Arial" SIZE 10 Bold   ; 
    On enter (MSgbox(Form_1.text_1.Value),Form_1.text_1.visible:=.F.)

  Form_1.progressbar_1.visible:=.F.
  Form_1.text_1.visible:=.F.

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

*-----------------------------------------------------------------------------*
Procedure fTextbox()
*-----------------------------------------------------------------------------*
Form_1.text_1.visible:=.T.
Form_1.text_1.Setfocus
Return Nil

*-----------------------------------------------------------------------------*
Procedure fRadiogroup
Form_1.progressbar_1.visible:=.T.
For I=1 to 100000
  do events
  Form_1.progressbar_1.value:=I
*  Inkey(.05)
Next
Form_1.progressbar_1.visible:=.F.

*-----------------------------------------------------------------------------*
Return Nil

