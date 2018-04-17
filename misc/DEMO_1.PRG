/*
* MiniGUI ComboBox Demo
* (c) 2002 Roberto Lopez
*/

#include "minigui.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'ComboBox Demo' ;
		ON INIT Crear_Tablas();
		MAIN 

		DEFINE COMBOBOX COMBO_MAE
			ROW 10
			COL 10
			WIDTH 200
			HEIGHT 200
			ITEMSOURCE mae->(str(codigo))+' | '+mae->nombre
			VALUESOURCE mae->codigo
			ON CHANGE filtro()
		END COMBOBOX
		
		DEFINE COMBOBOX COMBO_AUX
			ROW 50
			COL 10
			WIDTH 200
			HEIGHT 200
			ITEMSOURCE aux->(str(codigo))+' | '+aux->(alltrim(descri))
			VALUESOURCE aux->codigo
		END COMBOBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

procedure filtro()
	local codigo := form_1.combo_mae.value
	aux->( ordScope(0, codigo ) )
	aux->( ordScope(1, codigo ) )
	aux->( dbgotop() )
	form_1.combo_aux.refresh()
	form_1.combo_aux.value := 1
return

procedure Crear_tablas()
	local cmae, caux
	local j := 1
	
	cmae = 'maestro.dbf'
	caux = 'auxiliar.dbf'
	iaux = 'auxiliar.ntx'
	
	dbcreate( cmae, {{'CODIGO','N',10,0},{'NOMBRE','C',50,0}})
	dbcreate( caux, {{'CODIGO','N',10,0},{'Descri','c',50,0}})
	use ( caux )
	index on codigo to ( iaux )
	use
	
	dbusearea( .t.,, cmae,'mae', .t. )
	dbusearea( .t.,, caux,'aux', .t. ); dbsetindex( iaux )
	
	For i = 1 to 10
		mae->( dbappend() )
		mae->( fieldput( 1, i ) )
		mae->( fieldput( 2, 'Maestro_'+alltrim(str(i))))
		for j= 1 to 8
			aux->( dbappend() )
			aux->( fieldput( 1, i ) )
			aux->( fieldput( 2, 'Auxiliar_linea_'+alltrim(str(j))))
		next	
	Next	
return


