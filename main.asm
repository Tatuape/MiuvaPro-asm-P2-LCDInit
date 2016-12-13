; ***********************************************************
; Intesc Electronics & Embedded - Daniel Hernández Rodríguez
; Agosto 2016
;
; Práctica 4: Display LCD en modo 4 bits
;
; Descripción: Uso de la LCD de 2x16 en modo 4 bits mediante
; la librería MiuvaLCD.inc
; ************************************************************
    
LIST    P = 18F87J50	;PIC a utilizar
INCLUDE <P18F87J50.INC>

;************************************************************
;Configuración de fusibles
CONFIG  FOSC = HS
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***************************************************
    ;Ubicación de los pines de EN y RS en Miuva
#define LCD_EN   PORTE,3
#define LCD_RS   PORTE,1
#define LCD_RW   PORTE,2

CBLOCK 
    NIBBLE  ;Variable para escribir en la LCD
    Ret1    ;Variables para crear retardos
    Ret2
ENDC

ORG 0x00    ;Iniciar el programa en el registro 0x00
    
    movlw   0x00
    movwf   TRISE   ;Configurar puerto D como salida
;*****************************************************************************;
;Ejemplo de envío de instrucción					      ;
;									      ;
;   RS	    _________________________	1: DATOS | 0: INSTRUCCIONES	      ;
;									      ;   
;   RW	    _________________________	1: LECTURA  |	0: ESCRITURA          ;
;		  ___      ___                                                ;
;   EN	    _____/   \____/   \______	LEE EN FLANCOS DE BAJADA              ;
;									      ;
;	    _________________________					      ;
;   D7:D4   ___/_4 MSB_\/_4_LSB_\____	PARA ENVIAR LOS 8 BITS DE INSTRUCCION ;
;					PRIMERO SE ENVIAN LOS 4 MÁS           ;
;					SIGNIFICATIVOS Y POSTERIORMENTE LOS   ;
;					4 MENOS SIGNIFICATIVOS                ;
;									      ;
;*****************************************************************************;
;Se carga D7:D4 de la LCD en los bits D3:D0 de Miuva    

;*****************************************************************************;
;				    LCD_Init				      ;
;   Inicializa la LCD, esta función se debe ejecutar antes de cualquier otra  ;
;   que involucre el uso de la LCD.					      ;
;									      ;
;   Ejemplo de uso:							      ;
;	call    LCD_Init						      ;
;								              ;
;*****************************************************************************;
	bcf		LCD_RW
LCD_Init    
    bcf     LCD_EN		;Enable = LOW
    call    Retardo15ms		
    bcf     LCD_RS		;RS = LOW
    
    ;Inicia secuencia de inicialización
    
    ;Function set
	movlw	b'00110000'
	movwf	PORTE
    bsf	    LCD_EN	;Activa el bit de ENABLE
    call    Retardo100us    
    bcf	    LCD_EN	;Lee Function set
    call    Retardo4_1ms
	
    ;Function set
	movlw	b'00110000'
	movwf	PORTE
    bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	;Lee Function set
    call    Retardo100us
	
    ;Function set
    movlw	b'00110000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	;Lee Function set
    call    Retardo4_1ms
    
    ;Function set
    movlw	b'00100000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	;Lee Function set
    call    Retardo4_1ms
	
    ;Function set
    movlw	b'00100000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'11100000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
	
    ;Display off
    movlw	b'00000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'10000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
	
    ;Display clear
    movlw	b'00000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'00010000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms

    ;Entry mode set
    movlw	b'00000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'01100000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
	
    ;DDRAM ACCES
    movlw	b'10000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'00000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
	
    ;Display on
    movlw	b'00000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms
    movlw	b'11000000'
	movwf	PORTE
	bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN	
    call    Retardo4_1ms

    ;MANDAR LETRA I
    bsf	    LCD_RS
;    movlw   b'00100100'
	movlw	b'01000010'
    movwf   PORTE
    bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN
    call    Retardo4_1ms
;    movlw   b'00101001'
	movlw	b'10010010'
    movwf   PORTE
    bsf	    LCD_EN
    call    Retardo100us
    bcf	    LCD_EN
    call    Retardo4_1ms
    
    
    BUCLE
    goto    BUCLE
;*****************************************************************************;
;			Funciones de retardos				      ;
;   Estas funciones se utilizaron para los tiempos requeridos mientras se     ;
;   envían los datos o instrucciones a la LCD, está predefinidos para el      ;
;   oscilador de Miuva (8MHz). En caso de usar otro oscilador se tendrían     ;
;   que ajustar los retardos para satisfacer los tiempo solicitados.	      ;
;									      ;
;		fosc = 8MHz						      ;
;		Ciclo Reloj = 1/fosc = 1/8M = 125ns			      ;
;		Ciclo Instruccion = 4*Ciclo Reloj = 500ns		      ;
;		La funcion DECFSZ tarda 3 ciclos en ejecutarse		      ;
;		Retardo 15ms						      ;
;		Tiempo = Ret1*Ret2*(3*500ns)				      ;
;		Tiempo = Ret1*Ret2*(1.5us)				      ;
;		Ret1 = 255						      ;
;		Ret2 = 40						      ;
;		Tiempo = (255*40)(1.5us) = .0153 = 15.3ms		      ;
;*****************************************************************************;

Retardo15ms
    movlw 	.255
    movwf 	Ret1
    movlw 	.40
    movwf	Ret2
Ret15ms
    decfsz	Ret1, F
    bra	Ret15ms
    decfsz	Ret2, F
    bra	Ret15ms
    return
    
;Retardo 40ms
;Tiempo = Ret1*Ret2*(3*500ns) 
;Tiempo = Ret1*Ret2*(1.5us)
;Ret1 = 255
;Ret2 = 105
;Tiempo = (255*105)(1.5us) = .0402 = 40.2ms
Retardo40ms
    movlw 	.255
    movwf 	Ret1
    movlw 	.105
    movwf	Ret2
Ret40ms
    decfsz	Ret1, F
    bra	Ret15ms
    decfsz	Ret2, F
    bra	Ret15ms
    return

;Retardo 5ms
;Tiempo = Ret1*Ret2*(3*500ns) 
;Tiempo = Ret1*Ret2*(1.5us)
;Ret1 = 255
;Ret2 = 14
;Tiempo = (255*14)(1.5us) = .005355 = 5.355ms
Retardo5ms
    movlw   .255
    movwf   Ret1
    movlw   .14
    movwf   Ret2
Ret5ms
    decfsz  Ret1,F
    bra	    Ret5ms
    decfsz  Ret2,F
    bra	    Ret5ms
    return
    
;Retardo 4.1ms
;Tiempo = Ret1*Ret2*(3*500ns) 
;Tiempo = Ret1*Ret2*(1.5us)
;Ret1 = 255
;Ret2 = 11
;Tiempo = (255*11)(1.5us) = .0042 = 4.2ms
Retardo4_1ms
    movlw 	.255
    movwf 	Ret1
    movlw 	.11
    movwf	Ret2
Ret4_1ms
    decfsz	Ret1, F
    bra	Ret15ms
    decfsz	Ret2, F
    bra	Ret15ms
    return
    
    
;Retardo 100us
;Tiempo = Ret1*(3*500ns) 
;Tiempo = Ret1*(1.5us)
;Ret1 = 67
;Tiempo = (67)(1.5us) = .0001005 = 100.5us
Retardo100us
    movlw 	.67
    movwf 	Ret1
Ret100us
    decfsz	Ret1, F
    return
    
;Retardo 40us
;Tiempo = Ret1*(3*500ns) = Ret1*(1.5us)
;Ret1 = 27
;Tiempo = (27)(1.5us) = .0000405 = 40.5us
Retardo40us
    movlw	.27
    movwf	Ret1
Ret40us
    decfsz	Ret1,F
    return
    
END