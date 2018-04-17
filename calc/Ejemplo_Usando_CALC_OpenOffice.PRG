

*
*
* EJEMPLO DE FUNCIONES USANDO "OPEN OFFICE"  www.openoffice.org
*
* www.oohg.org      https://groups.google.com/d/forum/oohg
*
* Consultas a jogabar@yahoo.com
*







Informe.cEstado.AddItem ( TIME() + "  Abriendo OpenOffice" )
Informe.cEstado.Show

* Para saltar el proceso de llenar Ran2Tmp ordeno por lo solicitado y directamente
* voy a llenar la planilla.

*'N# O.C.'   ,'Desde',    'Venc.','Cliente'     ,'Cod',  'Suc','Depto','Articulo'       ,'Col',   'Precio', '34','36','38','40','42','44','46','48','50','52','L','M','S','XL','XXL','Cant','Total'
*'142326    ','20/08/07','20/09/07','HTS       ','000005','IND','WF ','1110857         ','IND','    15.814','    ','    ','   2','   7','   8','   6','   6','   2','    ','    ','    ','    ','    ','    ','    ','  31','    '


*
* INICIALIZA Y CREA UNA PLANILLA EN BLANCO  "private:factory/scalc"
*
oServiceManager := TOleAuto():New("com.sun.star.ServiceManager")

oDesktop  := oServiceManager:createInstance("com.sun.star.frame.Desktop")
oPlanilla := oDesktop:loadComponentFromURL("private:factory/scalc","_blank", 0, {})
oHoja     := oPlanilla:GetSheets:GetByIndex( 0 )	// Hoja1
oColumnas := oHoja:GetColumns()			// Columnas
oLocale   := oServiceManager:createInstance("com.sun.star.lang.locale")

IF Ole2TxtError() != "S_OK"

   * MsgStop("Open Office no está disponible.", "Error")
   Informe.cEstado.AddItem ( TIME() + "  No se pudo abrir OpenOffice" )
   Informe.cEstado.Show

   DBCLOSEALL()
   RETURN

endif

Informe.cEstado.AddItem ( TIME() + "  Exportando a Planilla .xls" )
Informe.cEstado.Show


*
* Columna, Fila    ..el formato de fecha separacion de miles lo hago al final porque este informes son más de 20.000 lineas
*
* oHoja:GetCellByPosition( columna, fila ):SetString(...)

oHoja:GetCellByPosition( 0, 0 ):SetString( "NOMBRE-DE-MI-EMPRESA" )

* tamaño letra para "NOMBRE-DE-MI-EMPRESA"
oHoja:GetCellByPosition( 0, 0 ):CharHeight := 14 	// Font Size

oHoja:GetCellByPosition( 0, 2 ):SetString( "Detalle General Pedidos Nuevos:  "+dtoc(desde)+ "  al  "+dtoc(hasta) )
oHoja:GetCellByPosition( 0, 2 ):CharHeight := 14 	// Font Size
oHoja:GetCellByPosition( 7, 0 ):SetString( "Emitido el: " + DTOC( DATE() )  + "  " + TIME() )
oHoja:GetCellByPosition( 7, 0 ):CharHeight := 12 	// Font Size

oHoja:GetCellByPosition(  0, 7 ):SetString( "Cliente" )	// Width :=  2450 * .5
oHoja:GetCellByPosition(  1, 7 ):SetString( "Articulo" ) // Width :=  2450 * 1
oHoja:GetCellByPosition(  2, 7 ):SetString( "Color" )	// Width :=  2450 * .7
oHoja:GetCellByPosition(  3, 7 ):SetString( "Vcto." )
oHoja:GetCellByPosition(  4, 7 ):SetString( "Desde" )
oHoja:GetCellByPosition(  5, 7 ):SetString( "Estado" )
oHoja:GetCellByPosition(  6, 7 ):SetString( "Precio" )

* Formatea celdas para fechas.
oFormats := oPlanilla:getNumberFormats()
oLocale := OOoCreateStruct( "com.sun.star.lang.Locale" )
* com.sun.star.util.NumberFormat.DATE = 2
nDateKey := oFormats:getStandardFormat( 2, oLocale )
oCell := oHoja:getCellRangeByName( "B8:C20000" )
oCell:NumberFormat := nDateKey


* Asigna a una columna por Numero de columna
oColumnas:GetByIndex(1):Width :=  2450 * 1         // ARTICULO: inches (2.54 cm per inch)
oColumnas:GetByIndex(2):Width :=  2450 * .7        // COLOR: inches (2.54 cm per inch)
oColumnas:GetByIndex(0):Width :=  2450 * .5 	   // DEPTO.: inches (2.54 cm per inch)

* 'N# O.C.'   ,'Desde',    'Venc.','Cliente'     ,'Cod',  'Suc','Depto','Articulo'       ,'Col',   'Precio', '34','36','38','40','42','44','46','48','50','52','L','M','S','XL','XXL','Cant','Total'
* '142326    ','20/08/07','20/09/07','HTS       ','000005','IND','WF ','1110857         ','IND','    15.814','    ','    ','   2','   7','   8','   6','   6','   2','    ','    ','    ','    ','    ','    ','    ','  31','    '

* Asigno la columna a cada talla
FOR nPos := 1 TO nQTallas
    AADD(aColTalla, 6+nPos )					    // Comienza en la 10
    oHoja:GetCellByPosition(6+nPos,7):SetString( aTalla[nPos] )    // Nombre columna talla
    oColumnas:GetByIndex(6+nPos):Width :=  2450 * .4 		  // inches (2.54 cm per inch)
NEXT

nColTotal := 6+nQTallas+1  	// por ser columnas variables obtengo las ultimas que son para total y otra talla que no este definida

nColOtra  := 6+nQTallas+2

oHoja:GetCellByPosition( nColTotal, 7):SetString( "Total" )	// Nombre columna Total talla
oHoja:GetCellByPosition( nColOtra, 7):SetString( "OtraTalla" )	// Nombre columna Otras tallas
oColumnas:GetByIndex(nColTotal):Width :=  2450 * .5 		  // inches (2.54 cm per inch)
oColumnas:GetByIndex(nColOtra):Width :=  2450 * .5 		  // inches (2.54 cm per inch)

* "nombre" es el Depto. que compra, ej.: Señora, Juvenil, etc.

nQDiasXVencer := DATE() + 5	// Se consideran por vencer hasta Hoy + 4 dias
				// pongo 5 para consulta sea solo "<"

* LLenar planilla recorriendo un archivo
WHILE !EOF()

  cOC     := Inf_tmp->OC
  cCodigo := Inf_tmp->Codigo
  cColor  := Inf_tmp->Color
  dVcto   := Inf_tmp->fHasta
  cRazon  := Inf_tmp->Razon

  oHoja:GetCellByPosition( 0, nFila ):SetString( LEFT(cRazon,10) )
  oHoja:GetCellByPosition( 1, nFila ):SetString( cCodigo )
  oHoja:GetCellByPosition( 2, nFila ):SetString( LEFT( inf_tmp->Color,3) )

  *oHoja:GetCellByPosition( 4, nFila ):SetFormula( inf_tmp->fDesde )
  *oHoja:GetCellByPosition( 3, nFila ):SetFormula( inf_tmp->fHasta )
  oHoja:GetCellByPosition( 3, nFila ):SetFormula( "=DATE(" + ;
  		STR(year(inf_tmp->fHasta),4)+";" +;
  		STR(Month(inf_tmp->fHasta),2)+";" +;
  		STR(day(inf_tmp->fHasta),2) + ")" )


  *
  * Asignando una FORMULA
  *
  oHoja:GetCellByPosition( 4, nFila ):SetFormula( "=DATE(" + ;
  		STR(year(inf_tmp->fDesde),4)+";" +;
  		STR(Month(inf_tmp->fDesde),2)+";" +;
  		STR(day(inf_tmp->fDesde),2) + ")" )

  *
  * Estado del pedido según dias indico su estado y con color diferente
  *
  IF inf_tmp->fHasta < Date()
     oHoja:GetCellByPosition( 5, nFila ):CharColor := 16711680  // Rojo
     oHoja:GetCellByPosition( 5, nFila ):SetString( "Vencido" )
  ELSEIF inf_tmp->fDesde > Date()
     oHoja:GetCellByPosition( 5, nFila ):CharColor := 32768  // Verde
     oHoja:GetCellByPosition( 5, nFila ):SetString( "Futura" )
  ELSEIF inf_tmp->fHasta < nQDiasXVencer
     oHoja:GetCellByPosition( 5, nFila ):CharColor := 255  // Azul
     oHoja:GetCellByPosition( 5, nFila ):SetString( "XVencer" )
  ELSE
     oHoja:GetCellByPosition( 5, nFila ):SetString( "Vcto>5Dias")    // Negro
  ENDIF

  oHoja:GetCellByPosition( 6, nFila ):SetValue( inf_tmp->precio )



  AFILL( aSumas, 0 )
  DO WHILE cColor  = Inf_tmp->Color  .AND. ;	// Sea Cliente+vcto+Articulo+Color
     	   cCodigo = Inf_tmp->Codigo .AND. ;
           dVcto   = Inf_tmp->fHasta .AND. ;
           cRazon  = Inf_tmp->Razon  .AND. ;
           .NOT. EOF()

     *
     * Posiciono la talla
     * La cantidad está en "inf_tmp->Canti"  y no en  "inf_tmp->Saldo"
     *
     nCol := ASCAN( aTalla, inf_tmp->Talla )
     IF nCol > 0
        aSumas[ nCol ] += inf_tmp->Canti
     ELSE
       aSumas[ nQTallas+1 ] += inf_tmp->Canti	//Es por si no encuentra ==> Otras Tallas
     ENDIF

     inf_tmp->( DBSKIP() )

  ENDDO

  lNegativos := .F.
  nSuma := 0
  FOR i := 1 TO nQTallas

     *
     * Posiciono la talla
     *
     nCol := aColTalla[ i ]	// columna de la talla

     * Solo mostrar negativos y positivos, ceros no.
     IF aSumas[ i ] # 0

        oHoja:GetCellByPosition( nCol, nFila ):SetValue( aSumas[ i ] )

        IF aSumas[ i ] < 0	// mostrar en rojo
           lNegativos := .T.
           oHoja:GetCellByPosition( nCol, nFila ):CharColor := 16711680  // numeros en rojo RGB
        ENDIF

     ENDIF

     nSuma += aSumas[ i ]

  NEXT

  *
  * Columna Total
  *
  IF nSuma < 0  .OR. lNegativos
       oHoja:GetCellByPosition( nColTotal, nFila ):CharColor := 16711680  // numeros en rojo RGB
  ENDIF
  oHoja:GetCellByPosition( nColTotal, nFila ):SetValue( nSuma )

  *
  * Columna Otra Talla    (Si es cero no se muestra nada)
  *
  IF aSumas[ nQTallas + 1 ] # 0

       oHoja:GetCellByPosition( nColOtra, nFila ):SetValue( aSumas[ nQTallas + 1] )

       IF aSumas[ nQTallas + 1 ] < 0
          oHoja:GetCellByPosition( nColOtra, nFila ):CharColor := 16711680  // numeros en rojo RGB
       ENDIF

  ENDIF


  nFila++

* Asi es el archivo que genera Dimasoft
* 'N# O.C.'   ,'Desde',    'Venc.','Cliente'     ,'Cod',  'Suc','Depto','Articulo'       ,'Col',   'Precio', '34','36','38','40','42','44','46','48','50','52','L','M','S','XL','XXL','Cant','Total'
* '142326    ','20/08/07','20/09/07','HTS       ','000005','IND','WF ','1110857         ','IND','    15.814','    ','    ','   2','   7','   8','   6','   6','   2','    ','    ','    ','    ','    ','    ','    ','  31','    '
* titu:="'"+OC+"','"+DTOC(FDESDE)+"','"+DTOC(FHASTA)+"','"+substr(Descrip,1,10)+"','"+codsuc+"','"+SUBSTR(SUC,1,3)+"','" +Depto+"','"  +Codigo+"','"+SUBSTR(COLOR,1,3)+"','"+trans(precio,mPrec)+"'"


ENDDO

IF nFila = nInicioDetalle    // SI EL ARCHIVO NO ARROJO DATOS...
   oHoja:GetCellByPosition( 4, nInicioDetalle+5 ):SetString( "SIN MOVIMIENTOS" )
   oHoja:GetCellByPosition( 4, nInicioDetalle+5 ):CharHeight := 14 	// Font Size
ENDIF


* Formateo Fechas
*oFormatos := oPlanilla.GetNumberFormats()
*oLocal :=
*oHoja:GetCellRangeByName( "B"+LTRIM(STR(nInicioDetalle,2)), "B"+LTRIM(STR(nFila,6)) ).SetValue( nFila )


*
* Nombrando el Archivo destino, ejemplo: "F:/Informes/Stock.xls"
*
IF EMPTY( cCarpetaDestino )
   archi := "F:/Informes/Stock.xls"
ELSE
   * Verifico "\" antes del nombre del archivo
   IF RIGTH(cCarpetaDestino,1) # "/" .or. RIGTH(cCarpetaDestino,1) # "\"
      cCarpetaDestino += "/"     // si no tiene ultimo carater lo agrego para agregar el nombre del archivo
   ENDIF
   archi := cCarpetaDestino + "UltimasOC.xls"
ENDIF
IF UPPER(right( archi, 4)) # ".XLS"  // verifico tenga extencion
   archi += ".xls"
ENDIF

IF FILE( archi )
   ERASE ( archi )		// Elimino el informe anterior.
ENDIF


*
* Esta funcion cambia forma de referenciar archivos.
*
archi := ConvierteAURL( archi )

oPlanilla:StoreToURL( archi , { OOoMakePropertyValue("FilterName", "MS Excel 97" ) })

*INLINE ::oDoc:storeToURL( "file:///" + ::ConvertToURL( cFile ),;
*                                      { ::GetPropertyValue( "FilterName", "MS Excel 97" ) } )

*
* Cerrando Planilla
*
oPlanilla:Close( .T. )


*
*
***************************************************************  Fin Programa




*
* OTRAS FORMAS DE CAMBIAR FORMATOS A TODA UNA COLUMNA O RANGO, ESO DA RAPIDEZ.
*

*
* Formateo Fechas y Numeros de la hoja activa (cliente)
*
* "DD/MM/AA"
*oRango := oHoja:getCellRangeByName( "E..:F...." )
oRango := oHoja:getCellRangeByName( "E"+LTRIM(STR(nInicioDetalle,2))+":F"+LTRIM(STR(nFila,6)) )
oRango:NumberFormat := nFormatoFecha
* "#.###;[RED]-#.##"
*oRango := oHoja:getCellRangeByName( "K..:AZ...." )
oRango := oHoja:getCellRangeByName( "K"+LTRIM(STR(nInicioDetalle,2))+":AZ"+LTRIM(STR(nFila,6)) )
oRango:NumberFormat := nFormatoNumerico

*
* Formateo Color Azul en columna Total y Stock
*
* Color Azul
*oRango := oHoja:getCellRangeByName( "I...:I...." )
oRango := oHoja:getCellRangeByName( "I"+LTRIM(STR(nInicioDetalle-1,2))+":I"+LTRIM(STR(nFila,6)) )
oRango:CharColor := 255  // Texto en Azul
* Color Rojo
*oRango := oHoja:getCellRangeByName( "J...:J...." )
oRango := oHoja:getCellRangeByName( "J"+LTRIM(STR(nInicioDetalle-1,2))+":J"+LTRIM(STR(nFila,6)) )
oRango:CharColor := 16711680  // Texto en Rojo









*************************************************************************************
*
* Mis Funciones    derivadas de De VisualFox
*
* Create a com.sun.star.beans.PropertyValue struct and return it.
FUNCTION OOoMakePropertyValue( cName, uValue, nHandle, nState )
   LOCAL oPropertyValue
   oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )

   oPropertyValue:Name := cName
   oPropertyValue:Value := uValue

   IF TYPE([nHandle])="N"
      oPropertyValue:Handle = nHandle
   ENDIF
   IF TYPE([nState])="N"
      oPropertyValue:State = nState
   ENDIF

RETURN ( oPropertyValue )



* Sugar coated routine to create any UNO struct.
* Use the Bridge_GetStruct() feature of the OLE-UNO bridge.
FUNCTION OOoCreateStruct( cTypeName )
   LOCAL oServiceManager, oStruct, cOldErrHandler

   oServiceManager := OOoGetServiceManager()

   *cOldErrHandler = ON( "ERROR" )
   *ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )

      oStruct = oServiceManager:Bridge_GetStruct( cTypeName )

   *ON ERROR &cOldErrHandler

   *IF ISNULL( oStruct )
   *   =__OOoReleaseCachedVars()
   *   oServiceManager = OOoGetServiceManager()
   *   oStruct = oServiceManager.Bridge_GetStruct( cTypeName )
   *ENDIF

RETURN ( oStruct )

* Sugar coated routine to ask the service manager to
*  create you an instance of some other OpenOffice.org UNO object.
FUNCTION OOoServiceManager_CreateInstance( cServiceName )
   LOCAL oServiceManager, oInstance, cOldErrHandler
   oServiceManager := OOoGetServiceManager()

   *cOldErrHandler = ON( "ERROR" )
   *ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
      oInstance := oServiceManager:createInstance( cServiceName )
   *ON ERROR &cOldErrHandler

   *IF ISNULL( oInstance )
   *   =__OOoReleaseCachedVars()
   *   oServiceManager = OOoGetServiceManager()
   *   oInstance = oServiceManager.createInstance( cServiceName )
   *ENDIF

RETURN ( oInstance )



* Return the OpenOffice.org service manager object.
* Cache it in a global variable.
* Create it if not already cached.
FUNCTION OOoGetServiceManager()
   IF (TYPE([goOOoServiceManager])!="O")  .OR.  empty( goOOoServiceManager )
      PUBLIC goOOoServiceManager
      goOOoServiceManager := TOleAuto():New("com.sun.star.ServiceManager")
   ENDIF
RETURN ( goOOoServiceManager )


*Function MakePropertyValue (oServiceManager, cName, xValue)
Function MakePropertyValue (cName, xValue)

    Local oStruct := oServiceManager:Bridge_GetStruct("com.sun.star.beans.PropertyValue")

    oStruct:Name := cName
    oStruct:Value := xValue

Return oStruct



********************
*
* Convierte a URL()
STATIC FUNCTION ConvierteAURL( cFile )

cFile :=  STRTRAN( cFile, "\" , "/" )
IF UPPER(LEFT( cFile, 5 )) # "FILE:"
   cFile := "file:///" + cFile
ENDIF

RETURN cFile




*NumberFormats = Doc.NumberFormats
*NumberFormatString = "#,##0.000"
*#.##0;[RED]-#.##0    Separador de miles, negativos en rojo

