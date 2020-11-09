.model small
.data 
;Variables Inicio
	Guiones DB '   -------------------------------------------------------------------', '$'
	Bienvenida DB '   |Bienvenido al Generador y Validador de UUID, ingrese una opcion: | ', '$'
	Opciones1 DB '   |                       1: Generar UUID                           |', '$'
	Opciones2 DB '   |                       2: Validar UUID                           |', '$'
	Num db ?
	ErrorI DB 'Ingrese opcion valida', '$'
;Variable Generador
    Numero1 DB '86245C80124C11EB0000000000000000$',0 
    Aux1    DB '00000000000000000000000000000000$',0
    Prueba  DB  'Ingrese un numero de 2 digitos: $',0
    Final   DB 36 dup (24h),'$'
    NumA      DB 00h
    Itera     DB ?
    RandN     DB 00h
    AuxD      DB ?
    AuxAB      DB ?
    NumB      DB 00h
    Carry     DB 00h
    FirstA    DB 00h
    FirstB    DB 00h
    FirstC    DB 00h
    FirstD    DB 00h
    FirstE    DB 00h
    AuxA      DW ?
    AuxB      DW ?
;Variables Validador
	Texto1 db 'Ingrese cadena a validar: ', '$'
	Acerto db 'Valido $'
	No db 'No Valido $'
	UUID db 36 dup('$')
	P db 1
	S db 1
	T db 1
	C db 1
.stack
.code
Proyecto:
	MOV AX, @DATA
	MOV DS, AX 
	MOV AH, 09H
	LEA DX, Guiones
	INT 21H
	
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	
	MOV AH, 09h
	LEA DX, Bienvenida
	INT 21h
	
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	
	MOV AH, 09h
	LEA DX, Opciones1
	INT 21h
	
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	
	MOV AH, 09h
	LEA DX, Opciones2
	INT 21h
		
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	
	MOV AH, 09H
	LEA DX, Guiones
	INT 21H
	
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H

	MOV AH, 01H
	int 21h
	MOV Num, Al
	
	CMP AL, 31H
	JE GeneradorUUID
	JNZ Opcion2
Opcion2 proc
	CMP AL, 32H
	JMP ValidadorFinal
	JNZ ErrorT
Opcion2 endp
ErrorT proc
	MOV AH, 09h
	LEA DX, ErrorI
	INT 21h
	
	MOV AH, 4Ch
	INT 21h
ErrorT endp 
GeneradorUUID proc
MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
MOV DX, offset Prueba
        MOV AH, 09h
        INT 21h

        MOV AH, 01h ;Obtener el primer digito de izquierda a derecha
        INT 21h
        
        SUB AL,30h  ;Obtener el digito correspondiente
        MOV BL,0Ah
        MUL BL ;Multiplicar por 100 para obtener las centenas

        MOV Itera,AL ;Guardar en una variable el resultado
        XOR AX,AX
        MOV AH, 01h ;Se obtiene el ultimo digito
        INT 21h
        SUB AL,30h
        ADD Itera, AL ;Al ser de unidades solo se suma al numero principal XXX

        MOV DL, 0Ah
        MOV AH, 02h
        INT 21h
        XOR DX,DX
        XOR CX,CX
        XOR AX,AX
        dec Itera
        PC:      
        ;Inicializar random y sumar al numero principal 
        call Principal      
        Mov BL,Itera
        dec Itera
        CMP BL,0
        JG PC
        jmp Finalizar1

        ;Procedimientos
        Principal proc near
        XOR AX,AX
        XOR DX,DX 
        LEA SI, Numero1
        LEA DI, Aux1
        Mov NumA,11
        l1:      
        ;Inicializar random y sumar al numero principal 
        call Random     ;Generar Numero Random
        call SumaProc        
        Mov BL,NumA     
        dec NumA
        CMP BL,0
        JG l1
        MOV AuxD,03h
        l2:      
        Mov RandN,00h  
        Mov Carry,00h        
        call SumaProc        
        Mov BL,AuxD     
        dec AuxD
        CMP BL,0
        JG l2

        call RandomRange4
        XOR DX,DX
        XOR BX,BX
        Mov DL,AuxAB
        CMP Dl,00h
        JE JOcho
        CMP DL,01h
        JE JNueve
        CMp DL,02h
        JE JDiez
        CMP DL,03h
        JE JOnce
		
        JOcho:
        MOV BL, '8'
        MOV [DI],BL
        INC DI
        Jmp SegA
        JNueve:
        MOV BL, '9'
        MOV [DI],BL
        INC DI
        Jmp SegA
        JDiez:
        MOV BL, 'A'
        MOV [DI],BL
        INC DI
        Jmp SegA
        JOnce:
        MOV BL, 'B'
        MOV [DI],BL
        INC DI
        Jmp SegA
       
        SegA:
        XOR AX,AX
        XOR BX,BX
        XOR CX,CX
        Mov NumB,14
        l3:      
        ;Inicializar random y sumar al numero principal 
        call Random     ;Generar Numero Random
        call SumaProc        
        Mov BL,NumB    
        dec NumB
        CMP BL,0
        JG l3

        LEA SI,Final
        Lea Di,Aux1
        Mov FirstA,7
        l4:      
        MOV AL,[DI]
        MOV [SI],AL
        inc SI
        inc DI
        Mov BL,FirstA    
        dec FirstA
        CMP BL,0
        JG l4

        Mov Cl,'-'
        MOV [SI],Cl
        inc SI

        Mov FirstB,3
        l5:      
        MOV AL,[DI]
        MOV [SI],AL
        inc SI
        inc DI
        Mov BL,FirstB    
        dec FirstB
        CMP BL,0
        JG l5

        Mov Cl,'-'
        MOV [SI],Cl
        inc SI

        Mov FirstC,3
        l6:      
        MOV AL,[DI]
        MOV [SI],AL
        inc SI
        inc DI
        Mov BL,FirstC    
        dec FirstC
        CMP BL,0
        JG l6

        Mov Cl,'-'
        MOV [SI],Cl
        inc SI

        Mov FirstD,3
        l7:      
        MOV AL,[DI]
        MOV [SI],AL
        inc SI
        inc DI
        Mov BL,FirstD
        dec FirstD
        CMP BL,0
        JG l7

        Mov Cl,'-'
        MOV [SI],Cl
        inc SI

        Mov FirstE,11
        l8:      
        MOV AL,[DI]
        MOV [SI],AL
        inc SI
        inc DI
        Mov BL,FirstE
        dec FirstE
        CMP BL,0
        JG l8
        XOR DX,DX
        XOR CX,CX
        XOR AX,AX
        XOR BX,BX
        MOV DL, 0Ah
        MOV AH, 02h
        INT 21h
        xor dx,dx
        MOV DX, offset Final
        MOV AH, 09h
        INT 21h 
        ret
        Principal endp
        Random proc near
        XOR CX,CX
        XOR DX,DX
        ; start delay
        mov AuxA, 23690
        mov AuxB, 23690
        delay2:
        dec AuxA
        nop
        jnz delay2
        dec AuxB
        Mov BX,AuxB
        cmp BX,0    
        jnz delay2
        ; end delay
        XOR BX,BX
        MOV AH, 00h  ; interrupts to get system time        
        INT 1AH      ; CX:DX now hold number of clock ticks since midnight
        mov  ax, dx
        xor  dx, dx
        mov  cx, 15    
        div  cx       ; here dx contains the remainder of the division - from 0 to 9
        Mov RandN,DL  
        ret
        Random endp
        RandomRange4 proc near
        XOR CX,CX
        XOR DX,DX
        ; start delay
        mov AuxA, 23690
        mov AuxB, 23690
        delayA:
        dec AuxA
        nop
        jnz delayA
        dec AuxB
        Mov BX,AuxB
        cmp BX,0    
        jnz delayA
        ; end delay
        XOR BX,BX
        MOV AH, 00h  ; interrupts to get system time        
        INT 1AH      ; CX:DX now hold number of clock ticks since midnight
        mov  ax, dx
        xor  dx, dx
        mov  cx, 4    
        div  cx       ; here dx contains the remainder of the division - from 0 to 9
        Mov AuxAB,DL  
        ret
        RandomRange4 endp

        SumaProc proc near ;Sumar digitos del numero principal con digitos randomizados
        XOR DX,DX 
        XOR BX,BX
        XOR AX,AX
        MOV Dl,[SI]       ;Obtener el Digito en el apuntador SI
        call LetraANum      ;Obtener el valor real del digito
        ADD Dl,RandN       ;Obtener el numero que se randomizo
        Mov BL,Carry        ;Existe carry de un numero anterior?
        CMP BL,00h          ;Comparar si carry esta vacio
        JG  SumaCarry       ;Si no lo esta se suma el carry
        CMP Dl,09h          ;Si no se le suma el carry comparar si la suma es mayor a 9
        JG  LetraNum        ;para comparar si se tiene que poner digito o letra o ya son 2 digitos
        jmp AddAsc
        SumaCarry:
        ADD Dl,Carry
        Mov Carry,00h
        CMP Dl,09h
        JG LetraNum
        jmp AddAsc

        LetraNum:
        CMP DL,0Fh
        JG  Sumar
        CMP Dl,0Ah
        JE NA
        CMP Dl,0Bh
        JE NB
        CMP Dl,0Ch
        JE NC
        CMP Dl,0Dh
        JE ND
        CMP Dl,0Eh
        JE NEL
        CMP Dl,0Fh
        JE NF  

        NA:
        MOV DL,'A'
        jmp Insert
        NB:
        MOV DL,'B'
        jmp Insert
        NC:
        MOV DL,'C'
        jmp Insert
        ND:
        MOV DL,'D'
        jmp Insert
        NEL:
        MOV DL,'E'
        jmp Insert
        NF:       
        MOV DL,'F'
        jmp Insert 

        Sumar:
        SUB DL,10h
        inc Carry
        CMP DL,0Fh
        JGE Sumar
        jmp AddAsc

        AddAsc:
        Add DL,30h
        
        Insert:
        MOV [DI],DL        
        INC SI
        INC DI
        ret
        SumaProc endp

        LetraANum proc near 
        SUB DL,30h
        CMP DL,09h
        JG  MayorA
        jmp Fin
        MayorA:
        SUB DL,07h
        Fin:
        ret 
        LetraANum endp
        ;Finalizar Programa
        Finalizar1:
        MOV AH,4Ch
        INT 21h
GeneradorUUID endp

ValidadorFinal proc 
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	MOV AH, 09h
	LEA DX, Texto1
	INT 21h
	
	MOV AH, 3FH
	MOV BX, 00
	MOV CX, 36
	MOV DX, offset[UUID]
	int 21h
	
	XOR AX, AX
	
	LEA SI, UUID
	
	MOV CX, 8
	P8:
	call ValidarNumLetras
	LOOP P8
	
	call ValidarGuion

	MOV CX, 4
	S4:
	call ValidarNumLetras
	LOOP S4
	
	call ValidarGuion
	
	call ValidarUno
	
	MOV CX, 3
	T3:
	call ValidarNumLetras
	LOOP T3
	
	call ValidarGuion
	
	call ValidarAB89
	
	MOV CX, 3
	C3:
	call ValidarNumLetras
	LOOP C3
	
	call ValidarGuion
	
	MOV CX, 12
	Q12:
	call ValidarNumLetras
	LOOP Q12
	
	call ValidarFinal
	
	;Aquí Valida solo numeros y letras
	ValidarNumLetras proc
	
		MOV AL, [SI]
		
		CMP AL, 40H
		JZ NoAcierto
		JC ComparacionNumeroMenor
		JNC ComparacionNumeroMayor
		
		ComparacionNumeroMenor:
			CMP AL, 30H
			JNC Acierto
			JMP NoAcierto
			
		ComparacionNumeroMayor:
			CMP AL, 47H
			JC Acierto
			JMP NoAcierto
			
		Acierto:
			JMP TerminarPrimeros8
		
		NoAcierto:
		 	MOV P, 0h
		
		TerminarPrimeros8:
			INC SI
			XOR AX, AX 
			ret
	ValidarNumLetras endp 
	
	;Validar si viene guion
	ValidarGuion proc
	MOV AL, [SI]
	CMP AL, 2DH
	JE GuionCorrecto
	JNZ NoGuion
	
	GuionCorrecto:
	JMP TerminarGuion
	
	NoGuion:
	MOV S, 0h
	
	TerminarGuion:
	INC SI
	XOR AX, AX
	ret
	ValidarGuion endp
	
	;Validar si viene 1
	
	ValidarUno proc
	MOV AL, [SI]
	CMP AL, 31H
	JE VieneUno
	JNZ NoViene
	
	VieneUno:
	JMP TerminarUno
	
	NoViene:
	MOV T, 0h
	
	TerminarUno:
	INC SI
	XOR AX, AX
	ret
	ValidarUno endp
	
	;Validar AB89
	ValidarAB89 proc
	MOV AL, [SI]
	CMP AL, 41H
	JE Correcto
	JNZ VieneB
	
	VieneB:
	CMP AL, 42H
	JE Correcto
	JNZ Viene8
	
	Viene8:
	CMP AL, 38H
	JE Correcto
	JNZ Viene9
	
	Viene9:
	CMP AL, 39H
	JE Correcto
	JNZ NoCorrecto
	
	Correcto:
	JMP TerminarAB89
	
	NoCorrecto:
	MOV C, 0h
	
	TerminarAB89:
	INC SI
	XOR AX, AX
	ret
	ValidarAB89 endp
	
	;Validacion Final
	ValidarFinal proc
	cmp P, 1d
	JE SegundaVal
	JNZ Malo
	
	SegundaVal:
	cmp S, 1d
	JE TerceraVal
	JNZ Malo
	
	TerceraVal:
	cmp T, 1d
	JE CuartaVal
	JNZ Malo
	
	CuartaVal:
	cmp C, 1d
	JE Bueno
	JNZ Malo
	
	Bueno:
	XOR DX, DX
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	MOV DX, offset Acerto
	MOV AH, 09H
	INT 21h
	MOV AH, 4Ch
	INT 21h
	
	Malo: 
	XOR DX, DX
	MOV AH, 02H
	MOV DL, 0Ah
	INT 21H
	MOV DX, offset No
	MOV AH, 09h
	INT 21h
	MOV AH, 4Ch
	INT 21h

	ValidarFinal endp
ValidadorFinal endp
END Proyecto