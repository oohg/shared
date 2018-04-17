/***
Esta funcion retornara los datos fisicos del disco duro referenciado por cDiskEval.- Si cDiskEval no es
suministrado, se utilizara el disco donde este instalado el windows
esta adaptado a OOHG y MiniGui

Devolvera un array unidimensional con los siguientes valores
1.- Numero de serial del disco
2.- Numero de serial del disco en formato hexadecimal
3.- Nombre del volumen o disco
4.- Sistema de archivos (FAT, FAT32, NTFS, etc)
5.- ID del disco evaluado (cDiskEval)

Simplemente enlazalo con tu aplicacion y disfrutala
*/
FUNCTION GetDiskInfo( cDiskEval )
	Local cVolName
	Local nSerNum
	Local nMaxName
	Local nFlags
	Local cFATName
	Local cHexSerNum
	Local cInfo := ""

	IF cDiskEval = NIL
		cDiskEval := LEFT(getwindowsfolder(), 3)             &&	ID DEL HD DEL WIN LOCAL
	ENDIF

	GetVolumeInformation( cDiskEval , @cVolName, @nSerNum , @nMaxName , @nFlags , @cFATName )

	cHexSerNum := I2Hex( nSerNum / 65535 ) + "-" + I2Hex( nSerNum )

RETURN { nSerNum, cHexSerNum, cVolName, cFATName, cDiskEval }

	#pragma BEGINDUMP

	#include <windows.h>
	#include "hbapi.h"
	#include "hbapiitm.h"

	static char * u2Hex( WORD wWord )
	{
	static far char szHex[ 5 ];

		WORD i= 3;

    do
		{
		szHex[ i ] = 48 + ( wWord & 0x000F );

			if( szHex[ i ] > 57 )
		szHex[ i ] += 7;

			wWord >>= 4;

			}
		while( i-- > 0 );

				szHex[ 4 ] = 0;

				return szHex;
				}

			HB_FUNC( I2HEX )
			{
			hb_retc( u2Hex( hb_parni( 1 ) ) );
				}

			// Code From WHAT32 by AJ Wos <andrwos@aust1.net>

			HB_FUNC(GETVOLUMEINFORMATION)
			{
			char *VolumeNameBuffer     = (char *) hb_xgrab( MAX_PATH ) ;
				DWORD VolumeSerialNumber                              ;
				DWORD MaximumComponentLength                          ;
				DWORD FileSystemFlags                                 ;
				char *FileSystemNameBuffer = (char *) hb_xgrab( MAX_PATH )  ;
				BOOL bRet;

				bRet = GetVolumeInformation( ISNIL(1) ? NULL : (LPCTSTR) hb_parc(1) ,
			(LPTSTR) VolumeNameBuffer              ,
			MAX_PATH                               ,
			&VolumeSerialNumber                    ,
			&MaximumComponentLength                ,
			&FileSystemFlags                       ,
			(LPTSTR)FileSystemNameBuffer           ,
			MAX_PATH ) ;
				if ( bRet  )
				{
				if ( ISBYREF( 2 ) )  hb_storc ((char *) VolumeNameBuffer, 2 ) ;
						if ( ISBYREF( 3 ) )  hb_stornl( (LONG)  VolumeSerialNumber, 3 ) ;
							if ( ISBYREF( 4 ) )  hb_stornl( (LONG)  MaximumComponentLength, 4 ) ;
								if ( ISBYREF( 5 ) )  hb_stornl( (LONG)  FileSystemFlags, 5 );
									if ( ISBYREF( 6 ) )  hb_storc ((char *) FileSystemNameBuffer, 6 );
										}

									hb_retl(bRet);
										hb_xfree( VolumeNameBuffer );
										hb_xfree( FileSystemNameBuffer );
										}

									#pragma ENDDUMP
