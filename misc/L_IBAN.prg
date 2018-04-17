FUNCTION IBAN(verIBAN1,NIVEL)
NIVEL:=IF(NIVEL=NIL,0,NIVEL)
***NIVEL 0 = COMPROBAR CUENTA DC S/RESPUESTA LOGICO
***NIVEL 1 = COMPROBAR CUENTA DC C/RESPUESTA LOGICO
***NIVEL 2 = DEVOLVER LA CUENTA CORRECTA
***NIVEL 24 = cuenta sin espacios
***NIVEL 29 = cuenta con espacios

/*
Cómo se calcula los dígitos de control del IBAN
a) Se añade al final de la BBAN, el código del país según la norma ISO 3166-1 y dos ceros.
b) Si en el IBAN hay letras, convierte estas letras en números del 10 al 35, siguiendo el orden del abecedario; A=10 y Z=35.
c) Divide el número por 97, y quédate con el resto.
d) Réstale a 98 el resto que te quede
e) Ya tenemos los dígitos de control, si la diferencia es menor a 10, añade un 0 a la izquierda.
*/

verIBAN1:=STRTRAN(verIBAN1," ","")
verIBAN1:=STRTRAN(verIBAN1,"-","")
verIBAN1:=STRTRAN(verIBAN1,"/","")
verIBAN1:=STRTRAN(verIBAN1,".","")

IF NIVEL<24
	DO CASE
	CASE LEN(RTRIM(verIBAN1))=0
		verIBAN2:=""
	CASE ISALPHA(verIBAN1)=.T.
		verIBAN2:=LEFT(verIBAN1,2)+ "00" + SUBSTR(verIBAN1,5,LEN(verIBAN1))
	OTHERWISE
		verIBAN2:="ES00" + verIBAN1
	ENDCASE

	verIBAN3:=STR(ASC(SUBSTR(verIBAN2,1,1))-55)+STR(ASC(SUBSTR(verIBAN2,2,1))-55)+SUBSTR(verIBAN2,3,2)
	verIBAN3:=STRTRAN(verIBAN3," ","")

	verIBAN3:=SUBSTR(verIBAN2,5,LEN(verIBAN2))+verIBAN3

*** dividir el numero en fracciones de 9 digitos***
	verIBAN4:=verIBAN3
	DO WHILE LEN(verIBAN4)>=9
		verIBAN4:=LTRIM(STR(VAL(LEFT(verIBAN4,9))%97,15,0)) + SUBSTR(verIBAN4,10,LEN(verIBAN4))
	ENDDO
	verIBAN4:=VAL(verIBAN4)%97
*** FIN dividir el numero en fracciones de 9 digitos***

	verIBAN4:=STRZERO(98-verIBAN4,2)
ENDIF


DO CASE
CASE NIVEL=0 .OR. NIVEL=1
	IF SUBSTR(verIBAN2,3,2)=verIBAN4 .OR. LEN(RTRIM(verIBAN1))=0
		verIBAN99:=.T.
	ELSE
		verIBAN99:=.F.
	ENDIF
	IF NIVEL=1 .AND. verIBAN99=.F.
		MSGSTOP("IBAN Erroneo")
	ENDIF
CASE NIVEL=2
	verIBAN99:=LEFT(verIBAN2,2)+ verIBAN4 + SUBSTR(verIBAN2,5,LEN(verIBAN2))
CASE NIVEL=24
	verIBAN99:=verIBAN1
CASE NIVEL=29
	verIBAN99:=""
	FOR NverIBAN1=1 TO LEN(verIBAN1) STEP 4
		verIBAN99:=verIBAN99+SUBSTR(verIBAN1,NverIBAN1,4)+" "
	NEXT
ENDCASE


RETURN(verIBAN99)


