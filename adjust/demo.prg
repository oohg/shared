#include "oohg.ch"


Function main()

 DEFINE WINDOW Form_1 obj oForm1 ;
  AT 0,0 ;
  WIDTH 640 ;
  HEIGHT 480 ;
  TITLE 'TreeView Sample . ClientsAdjust' ;
  MAIN 

  DEFINE MAIN MENU
   POPUP '&File'
    ITEM 'Get Tree Value' ACTION MsgInfo('1') 
    ITEM 'Set Tree Value' ACTION MsgInfo('1')
    ITEM 'Collapse Item' ACTION MsgInfo('1') 
    ITEM 'Expand Item' ACTION MsgInfo('1')
   END POPUP
  END MENU

  DEFINE CONTEXT MENU 
   ITEM 'About'    ACTION MsgInfo ("Free GUI Library For Harbour","MiniGUI Tree Demo") 
  END MENU

  
  define label lbl_1 width 30 backcolor {0,0,255} ;
			value "Título sobre las ventanas" border adjust top  obj oLbl1 
  
  DEFINE TREE Tree_1 obj oTree AT 10,10 WIDTH 200 HEIGHT 400 VALUE 15 adjust left
  NODE 'Item 1' 
    TREEITEM 'Item 1.1'
    TREEITEM 'Item 1.2' ID 999
    TREEITEM 'Item 1.3'
   END NODE

   NODE 'Item 2'

    TREEITEM 'Item 2.1'

    NODE 'Item 2.2'
     TREEITEM 'Item 2.2.1'
     TREEITEM 'Item 2.2.2'
     TREEITEM 'Item 2.2.3'
     TREEITEM 'Item 2.2.4'
     TREEITEM 'Item 2.2.5'
     TREEITEM 'Item 2.2.6'
     TREEITEM 'Item 2.2.7'
     TREEITEM 'Item 2.2.8'
    END NODE

    TREEITEM 'Item 2.3'

   END NODE

   NODE 'Item 3'
    TREEITEM 'Item 3.1'
    TREEITEM 'Item 3.2'

    NODE 'Item 3.3'
     TREEITEM 'Item 3.3.1'
     TREEITEM 'Item 3.3.2'
    END NODE

   END NODE

  END TREE

  // otree:ClientAdjust:=3 //left

   define panel frm_1 obj oFrame1 	WIDTH   80 backcolor {200,200,100} adjust top
     @ 30,10 label lbl_2 width 100 height 18 value 'Texto Superior'
	 @ 30,100  COMBOBOX Combo_1 obj Ocombo 	ITEMS { 'Item letra A' , 'Item letra B' , 'Item letra C' } VALUE 1 
	 define button ob1 obj ob1 Caption "Plegar" width 22 adjust top action if(oFrame1:Height=24,oFrame1:Height:=80,oFrame1:Height:=24)
   end panel
   

   define FRAME frm_3 obj oFrame3 CAPTION "Fame Derecho" WIDTH   80 adjust right
  
   
   define browse browse_1 obj obrowse adjust client width 100  
		
   
   define panel frm_2 obj oFrame2 	WIDTH  80 adjust bottom
		@ 10,10 button oButton of frm_2 width 80 height 24 caption 'Oculta' action (oFrame1:Visible:=!oFrame1:Visible)
		@ 10,100 button oButton2 of frm_2 width 80 height 24 caption 'Titulo' action (oLbl1:Visible:=!oLbl1:Visible)
		@ 10,200 button oButton3 of frm_2 width 80 height 24 caption 'Tree' action (oTree:Visible:=!oTree:Visible)
		@ 35,10 button oButton4 of frm_2 width 80 height 24 caption 'Arriba' action (olbl1:nheight:=30,oLbl1:Adjust:=1)
		@ 35,90 button oButton5 of frm_2 width 80 height 24 caption 'Abajo' action (olbl1:nheight:=30,oLbl1:Adjust:=2)
		@ 35,170 button oButton6 of frm_2 width 80 height 24 caption 'Izquierda' action (olbl1:nwidth:=30,oLbl1:Adjust:=3)
		@ 35,250 button oButton7 of frm_2 width 80 height 24 caption 'Derecha' action (olbl1:nwidth:=30,oLbl1:Adjust:=4)
  end panel
   
 END WINDOW

 ACTIVATE WINDOW Form_1

Return


