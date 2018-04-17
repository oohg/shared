* ------------------------------------------------------ *
* SISTEMA     : INFO-PEDIDOS                             *
* PRG         : FTPS.PRG                                 *
* CREADO      : 15-12-2005                               *
* ACTUALIZADO : 04-04-2007                               *
* AUTOR       : EDUARDO V. FLORES RIVAS                  *
* COMENTARIOS : DIRECTIVAS PARA USAR FTP                 *
* VARIABLES   : LAS SIGUIENTES VARIABLES DEBEN DEFINIRSE *
*               PARA QUE ESTA RUTINA CORRA:              *
*               SYS_SERVER   = 'ftp.miftp.com'           *
*               SYS_NETUSER  = 'minombredeusuario'       *
*               SYS_PASSWORD = 'miclavedeusuario'        *
* ------------------------------------------------------ *

#define FILE_ATTRIBUTE_ARCHIVE 128
#define INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
#define INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
#define INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
#define INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS
#define INTERNET_INVALID_PORT_NUMBER    0                   // use the protocol-specific default
#define INTERNET_DEFAULT_FTP_PORT       21                  // default for FTP servers
#define INTERNET_DEFAULT_GOPHER_PORT    70                  //    "     " gopher "
#define INTERNET_DEFAULT_HTTP_PORT      80                  //    "     " HTTP   "
#define INTERNET_DEFAULT_HTTPS_PORT     443                 //    "     " HTTPS  "
#define INTERNET_DEFAULT_SOCKS_PORT     1080                // default for SOCKS firewall servers.
#define INTERNET_SERVICE_FTP     1
#define INTERNET_SERVICE_GOPHER  2
#define INTERNET_SERVICE_HTTP    3
#define INTERNET_FLAG_TRANSFER_ASCII  1
#define INTERNET_FLAG_TRANSFER_BINARY 2
#DEFINE INTERNET_FLAG_PASSIVE           134217728            //&H8000000     //    ' used for FTP connections
#DEFINE MAX_PATH = 260


*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------

FUNC NETBajar
PARA aArchivoRemoto, aArchivoLocal

    LOCAL hInternet, hConnect, lSuccess := .t.

    MENSABOX('Descargando...')

    IF aArchivoLocal = NIL
      aArchivoLocal := aArchivoRemoto
    ENDIF

    hLib = LOADLIBRARY( "wininet.dll" )

    hInternet = INETOPEN( "Anystring", INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0 )

    hConnect = INETCONNECT( hInternet, SYS_SERVER, INTERNET_INVALID_PORT_NUMBER, SYS_NETUSER, SYS_PASSWORD, INTERNET_SERVICE_FTP, 0, 0 )

    FOR nFile = 1 TO LEN(aArchivoRemoto)
       cArchivoRemoto := aArchivoRemoto[nFile]
       cArchivoLocal  := aArchivoLocal[nFile]
       IF FTPGETFILE( hConnect , cArchivoRemoto , cArchivoLocal , 0 , FILE_ATTRIBUTE_ARCHIVE , 0 , 0 ) = 0
         lSuccess := .f.
         MsgStop( "Error mientras se descargaban los archivos.  Intentelo luego." )
         EXIT
      ENDIF
    NEXT

    INETCLOSEHANDLE( hConnect )

    INETCLOSEHANDLE( hInternet )

    FREELIBRARY( hLib )

    MENSABOX()


RETURN( lSuccess )


*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------

FUNC NETSubir
PARA aArchivoLocal , aArchivoRemoto , aDirRemoto

    LOCAL hInternet, hConnect, lSuccess := .t.

    MENSABOX('Enviando archivo...')

    IF aArchivoRemoto = NIL
       aArchivoRemoto := aArchivoLocal
    ENDIF

    hLib = LOADLIBRARY( "wininet.dll" )

    hInternet = INETOPEN( "Anystring", INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0 )

    hConnect = INETCONNECT( hInternet, SYS_SERVER, INTERNET_INVALID_PORT_NUMBER, SYS_NETUSER, SYS_PASSWORD, INTERNET_SERVICE_FTP, 0, 0 )

    FOR nFile = 1 TO LEN(aArchivoLocal)
       cArchivoLocal  := aArchivoLocal[nFile]
       cArchivoRemoto := aArchivoRemoto[nFile]
//       IF aDirRemoto <> NIL
//          FtpSetCurrentDirectory( hConnect , aDirRemoto[nFile] )
//       ENDIF
       IF FTPPUTFILE( hConnect , cArchivoLocal , cArchivoRemoto , 0 , 0 ) = 0
         lSuccess := .f.
         MsgStop( "Error mientras se enviaban sus archivos"+Chr(13)+'Vuelva a intentarlo en algunos minutos' )
         EXIT
       ENDIF
    NEXT

    INETCLOSEHANDLE( hConnect )

    INETCLOSEHANDLE( hInternet )

    FREELIBRARY( hLib )

    MENSABOX()


RETURN( lSuccess )


*-----------------------------------------------------------------------------*
DECLARE DLL_TYPE_LONG InternetOpenA( DLL_TYPE_LPSTR cAgent, DLL_TYPE_DWORD nAccessType, ;
   DLL_TYPE_LPSTR cProxyName, DLL_TYPE_LPSTR cProxyBypass, DLL_TYPE_DWORD nFlags ) ;
   IN WININET.DLL ;
   ALIAS InetOpen
*-----------------------------------------------------------------------------*
DECLARE DLL_TYPE_BOOL InternetCloseHandle( DLL_TYPE_LONG hInternet ) ;
   IN WININET.DLL ;
   ALIAS InetCloseHandle
*-----------------------------------------------------------------------------*
DECLARE DLL_TYPE_LONG InternetConnectA( DLL_TYPE_LONG hInternet, DLL_TYPE_LPSTR cServerName, ;
   DLL_TYPE_LONG nServerPort, DLL_TYPE_LPSTR cUserName, DLL_TYPE_LPSTR cPassword, ;
   DLL_TYPE_DWORD nService, DLL_TYPE_DWORD nFlags, DLL_TYPE_DWORD nContext ) ;
   IN WININET.DLL ;
   ALIAS InetConnect
*-----------------------------------------------------------------------------*
DECLARE DLL_TYPE_BOOL FtpGetFileA( DLL_TYPE_LONG hConnect, DLL_TYPE_LPSTR cRemoteFile, ;
   DLL_TYPE_LPSTR cNewFile, DLL_TYPE_LONG nFailIfExists, ;
   DLL_TYPE_DWORD nFlagsAndAttribs, DLL_TYPE_DWORD nFlags, DLL_TYPE_DWORD nContext ) ;
   IN WININET.DLL ;
   ALIAS FtpGetFile
*-----------------------------------------------------------------------------*
DECLARE DLL_TYPE_BOOL FtpPutFileA( DLL_TYPE_LONG hConnect, DLL_TYPE_LPSTR cLocalFile, ;
   DLL_TYPE_LPSTR cNewRemoteFile, DLL_TYPE_DWORD nFlags, DLL_TYPE_DWORD nContext ) ;
   IN WININET.DLL ;
   ALIAS FtpPutFile
*Private Declare Function FtpSetCurrentDirectory Lib "wininet.dll" Alias "FtpSetCurrentDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
  DECLARE DLL_TYPE_BOOL FtpSetCurrentDirectoryA(  DLL_TYPE_LONG  hFtpSession, DLL_TYPE_LPSTR   lpszDirectory );
   IN WININET.DLL ;
      ALIAS  FtpSetCurrentDirectory

***********************************
*Private Declare Function FtpGetCurrentDirectory Lib "wininet.dll" Alias "FtpGetCurrentDirectoryA" (ByVal hFtpSession As Long, ByVal lpszCurrentDirectory As String, lpdwCurrentDirectory As Long) As Long
* DECLARE DLL_TYPE_LONG  FtpGetCurrentDirectoryA( DLL_TYPE_LONG  hFtpSession, DLL_TYPE_LPSTR lpszCurrentDirectory,;
*  DLL_TYPE_DWORD     lpdwCurrentDirectory);
*    IN WININET.DLL ;
*      ALIAS FtpGetCurrentDirectory
 **********************************

*Private Declare Function FtpCreateDirectory Lib "wininet.dll" Alias "FtpCreateDirectoryA"  (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
  DECLARE DLL_TYPE_BOOL  FtpCreateDirectoryA(  DLL_TYPE_LONG hFtpSession, DLL_TYPE_LPSTR lpszDirectory);
    IN WININET.DLL ;
     ALIAS FtpCreateDirectory

*Private Declare Function FtpRemoveDirectory Lib "wininet.dll" Alias "FtpRemoveDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
     DECLARE DLL_TYPE_BOOL FtpRemoveDirectoryA(  DLL_TYPE_LONG hFtpSession, DLL_TYPE_LPSTR lpszDirectory);
    IN WININET.DLL ;
     ALIAS FtpRemoveDirectory

*Private Declare Function FtpDeleteFile Lib "wininet.dll" Alias "FtpDeleteFileA" (ByVal hFtpSession As Long, ByVal lpszFileName As String) As Boolean
 DECLARE DLL_TYPE_BOOL   FtpDeleteFileA(   DLL_TYPE_LONG  hFtpSession, DLL_TYPE_LPSTR   lpszFileName );
      IN WININET.DLL ;
      ALIAS FtpDeleteFile

*Private Declare Function FtpRenameFile Lib "wininet.dll" Alias "FtpRenameFileA" (ByVal hFtpSession As Long, ByVal lpszExisting As String, ByVal lpszNew As String) As Boolean
   DECLARE DLL_TYPE_BOOL FtpRenameFileA( DLL_TYPE_LONG  hFtpSession, DLL_TYPE_LPSTR  lpszExisting ,;
    DLL_TYPE_LPSTR   lpszNew);
       IN WININET.DLL ;
        ALIAS FtpRenameFile
