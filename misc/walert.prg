FUNCTION walert( cMessage, aItems, cTitle )
   LOCAL I:=0,J:=0,nStart:=1,nValue:=0,cAuxTxt:=''
   LOCAL nButtonWide:=nTextWide:=nWindowButtonWide:=nWindowTextWide:=nColTxt:=0
   LOCAL nWindowWide:=nWindowHeight:=nStartRowButton:=nTotWideButton:=nColFirstButton:=0
   LOCAL aAux            := {}
   LOCAL aTxtLines       := {}
   LOCAL cTooltipButton1 := ''
   DEFAULT aItems TO {}
   DEFAULT cMessage TO ' '
   SET INTERACTIVECLOSE OFF

   IF SET( _SET_LANGUAGE )=='ES'
      DEFAULT cTitle TO 'Seleccione...'
      cTooltipButton1 := 'pulse aqui para continuar'
   ELSE
      DEFAULT cTitle TO 'Please select...'
      cTooltipButton1 := 'push here to continue'
   ENDIF

   IF LEN(aItems)=0
      AADD(aItems,'OK')
      IF SET( _SET_LANGUAGE )=='ES'
         DEFAULT cTitle TO 'Información...'
      ELSE
         DEFAULT cTitle TO 'Information...'
      ENDIF
   ENDIF

   FOR I=1 TO LEN(cMessage)
       IF SUBST(cMessage,I,1)=';'
          AADD(aAux,I)
       ENDIF
   NEXT
   nStart := 1
   FOR I=1 TO LEN(aAux)
       cAuxTxt:=''
       FOR J=nStart TO aAux[I]-1
           cAuxTxt += SUBST(cMessage,J,1)
       NEXT
       IF EMPTY(cAuxTxt)
          AADD(aTxtLines,' ')
       ELSE
          AADD(aTxtLines,ALLTRIM(cAuxTxt))
       ENDIF
       nStart := aAux[I]+1
   NEXT
   AADD(aTxtLines,ALLTRIM(SUBST(cMessage,nStart,LEN(cMessage))))

   *********************** GLOBAL MEASUREMENTS CALCULATIONS ****************
   nButtonWide       := ROUND(MAX(FT_AEMAXLEN(aItems)*8,59),0)  //LONGITUD DEL ITEM MAS LARGO (minimo 59 pixeles)
   nTextWide         := ROUND(FT_AEMAXLEN(aTxtLines)*8.1,0)     //LONGITUD DEL TEXTO MAS LARGO
   nWindowButtonWide := (nButtonWide * LEN(aItems))+((LEN(aItems)+1)*15)
   nWindowTextWide   := nTextWide+30
   nWindowWide       := MAX(nWindowButtonWide,nWindowTextWide)
   nWindowWide       := IIF(nWindowWide>150,nWindowWide,150)
   nWindowHeight     := 118+((LEN(aTxtLines)-1)*18)

   ******************* WINDOW DFINITION ***************************
   DEFINE WINDOW walert OBJ oWalert ;
   AT 0,0 ;
   WIDTH nWindowWide HEIGHT nWindowHeight ;
   TITLE cTitle ;
   ICON 'MAIN' ;
   NOSIZE ;
   NOMAXIMIZE ;
   NOMINIMIZE ;
   MODAL
   ON INTERACTIVECLOSE {|| nValue := 0, oWalert:Release() }
   ON KEY ESCAPE OF walert ACTION {||nValue := 0, oWalert:Release() }

   FOR I=1 TO LEN(aTxtLines)
       cTexLabel := 'text'+STR(I,1)
       nColTxt := ROUND((nWindowWide-LEN(aTxtLines[I])*8.1)/2,0)
       @ (I*18)-2,nColTxt LABEL &cTexLabel WIDTH LEN(aTxtLines[I])*8.1 HEIGHT 15 VALUE aTxtLines[I] ;
          FONT 'Lucida Console' SIZE 10 CENTERALIGN
   NEXT

   nStartRowButton := ((I-1)*18)+22
   nTotWideButton   := (nButtonWide*LEN(aItems)) + ((LEN(aItems)-1)*5)
   nColFirstButton  := ROUND((nWindowWide-nTotWideButton)/2,0)

   @ nStartRowButton,nColFirstButton BUTTON Button_1 ;
   CAPTION '&'+aItems[1] ;
   ACTION {|| nValue := 1,walert.Release } ;
   FONT 'Lucida Console' ;
   SIZE 9 ;
   WIDTH nButtonWide ;
   TOOLTIP IIF(LEN(aItems)>=2,aItems[1],cTooltipButton1)

   IF LEN(aItems) >= 2
      @ nStartRowButton,nColFirstButton+((nButtonWide+5)*1) BUTTON Button_2 ;
      CAPTION '&'+aItems[2] ;
      ACTION {|| nValue := 2,walert.Release } ;
      FONT 'Lucida Console' ;
      SIZE 9 ;
      WIDTH nButtonWide ;
      TOOLTIP aItems[2]
   ENDIF

   IF LEN(aItems) >= 3
      @ nStartRowButton,nColFirstButton+((nButtonWide+5)*2) BUTTON Button_3 ;
      CAPTION '&'+aItems[3] ;
      ACTION {|| nValue := 3,walert.Release } ;
      FONT 'Lucida Console' ;
      SIZE 9 ;
      WIDTH nButtonWide ;
      TOOLTIP aItems[3]
   ENDIF

   IF LEN(aItems) >= 4
      @ nStartRowButton,nColFirstButton+((nButtonWide+5)*3) BUTTON Button_4 ;
      CAPTION '&'+aItems[4] ;
      ACTION {|| nValue := 4,walert.Release } ;
      FONT 'Lucida Console' ;
      SIZE 9 ;
      WIDTH nButtonWide ;
      TOOLTIP aItems[4]
   ENDIF

   IF LEN(aItems) >= 5
      @ nStartRowButton,nColFirstButton+((nButtonWide+5)*3) BUTTON Button_5 ;
      CAPTION '&'+aItems[5] ;
      ACTION {|| nValue := 5,walert.Release } ;
      FONT 'Lucida Console' ;
      SIZE 9 ;
      WIDTH nButtonWide ;
      TOOLTIP aItems[5]
   ENDIF
   END WINDOW
   oWalert:button_1:setfocus()

   CENTER WINDOW walert
   ACTIVATE WINDOW walert
   SET INTERACTIVECLOSE OFF
RETURN(nValue)
