.model small
.stack 100h
.data
    regAX dw ?
	regBX dw ?
	regCX dw ?
	regDX dw ?
    regSP dw ?
	regBP dw ?
	regSI dw ?
	regDI dw ?
	
	baitas1 db ?
	baitas2 db ?
	baitas3 db ?
	baitas4 db ?
	
	msg1 db "Zingsninis pertraukimas! $"
	msg2 db "Ne sbb komanda! $" 
	msg3 db "Poslinkis$"
	opk db "sbb $" 
    space db ", $"
	enteris db 10, 13, "$"
	
	opAX db "ax$"
	opBX db "bx$"
	opCX db "cx$"
	opDX db "dx$"
	opAL db "al$"
	opBL db "bl$"
	opCL db "cl$"
	opDL db "dl$"
	opAH db "ah$"
	opBH db "bh$"
	opCH db "ch$"
	opDH db "dh$"
	opSP db "sp$"
	opBP db "bp$"
	opDI db "di$"
	opSI db "si$" 
	
	modd db ?
	reg db ?
	rm db ?
	w db ?
	
	opr1CheckBW db ?
	opr2CheckPosl db ?
	opr2CheckBW db ? 
	checkPosl db ? 
	posl db ? 
	
	op1 dw ?
	op1Word dw ?
	op1Baitas db ? 
	op2Pirmas dw ?  
	op2Antras dw ?
	op2PirmasB db ?
	op2PirmasTemp dw ?
	op2AntrasTemp dw ?
	
	tempop dw ?
	tempWord dw ?
	tempBaitas db ?
	tempCheck db ?
.code

start:
    mov ax, @data
    mov ds, ax
    
    mov ax, 0
    mov es, ax
    
    push es:[4]
    push es:[6]
    
    mov word ptr es:[4], offset pertraukimas
    mov es:[6], cs
     
    pushf
    pushf 
    pop ax
    OR ax, 0100h     
    push ax
    popf
    nop
    
    sbb al, dl
	sbb bx, [bx+si]
    sbb cx, [bx+si+24h]
    sbb cx, [bx+di+3789h]
    sbb cx, [bp+si+1625h]
    sbb cx, [bp+di+2h]
    sbb cx, [si+178h]
    adc cx, [di+10h]
    adc cx, [bx+0h] 
    adc cx, [bp+7586]    
    
	popf
    
    pop es:[6]
    pop es:[4]
    
    mov ah, 4Ch
    mov al, 0
    int 21h
    
pertraukimas: 
    mov regAX, ax
    mov regBX, bx
    mov regCX, cx
    mov regDX, dx
    mov regSP, sp
    mov regBP, bp
    mov regSI, si
    mov regDI, di
     
    mov ax, @data
    mov ds, ax
    
    pop si
    pop di
    push di
    push si
     
    mov ax, cs:[si]
    mov bx, cs:[si+2]
    
    mov baitas1, al
    mov baitas2, ah
    mov baitas3, bl
    mov baitas4, bh
    
    AND al, 0FCh        
    cmp al, 18h
    je skaiciavimas
    
    mov ah, 9
    mov dx, offset msg2
    int 21h   
    mov ah, 9
    mov dx, offset enteris
    int 21h 
    jmp pabaiga
    
    
skaiciavimas:
    mov opr1CheckBW, 0h
	mov opr2CheckPosl, 0h
	mov opr2CheckBW, 0h
	mov checkPosl, 0h  
	mov posl, 0h

    mov ah, 9
    mov dx, offset msg1
    int 21h 
    
    mov ax, di
    call printAX
    
    mov ah, 2
	mov dl, ":"
	int 21h
		
	mov ax, si
	call printAX
	
	mov ah, 2
	mov dl, " "
    int 21h
	
	call check 
	
	mov dl, " "
	mov ah, 2
	int 21h 
	
	mov al, baitas1
	and al, 01h 
	mov w, al
	mov al, baitas2
	and al, 38h
	mov reg, al
	mov al, baitas2
	and al, 07h
	mov rm, al 
     
	mov dx, offset opk
    mov ah, 9
    int 21h
	
	call printREG
	
	mov dx, offset space
	mov ah, 9
	int 21h
	
	call operandas2
	
	mov dl, ";"
	mov ah, 2
	int 21h
	
	mov dl, " "
	mov ah, 2
	int 21h  
	
	mov dx, op1
	mov ah, 9
	int 21h
	
	mov dl, "="
	mov ah, 2
	int 21h
	
	cmp opr1CheckBW, 1h
	je opr1Word
	
	mov al, op1Baitas
	call printAL
	mov dx, offset space
	mov ah, 9
	int 21h
	jmp testi
	
	opr1Word:	
	mov ax, op1Word
	call printAX
	mov dx, offset space
	mov ah, 9
	int 21h 
	
	testi:
	cmp opr2CheckPosl, 1h
	je opr2PoslVienas
	
	mov dx, op2Pirmas
	mov ah, 9
	int 21h 
	
	mov dl, "="
	mov ah, 2
	int 21h
	
	mov ax, op2PirmasTemp
	call printAX
	
	mov dx, offset space
	mov ah, 9
	int 21h
	
	mov dx, op2Antras
	mov ah, 9
	int 21h
	
	mov dl, "="
	mov ah, 2
	int 21h 
	
	mov ax, op2AntrasTemp
	call printAX
	
	mov ah, 9
    mov dx, offset space
    int 21h
	
	mov ah, 9
    mov dx, offset msg3
    int 21h
	
	mov dl, "="
	mov ah, 2
	int 21h
	
	mov al, baitas3
	call printAL
	
	mov al, baitas4
	call printAL
	
	mov ah, 9
    mov dx, offset enteris
    int 21h
	
	jmp pabaiga
	
	opr2PoslVienas: 
	mov dx, op2Pirmas
	mov ah, 9
	int 21h 
	
	mov dl, "="
	mov ah, 2
	int 21h
	
	cmp opr2CheckBW, 1h 
	je opr2Word 
	
	mov al, op2PirmasB 
	call printAL
	
	mov ah, 9
    mov dx, offset enteris
    int 21h
    jmp pabaiga
	
	opr2Word:	
	mov ax, op2PirmasTemp
	call printAX
	
	mov ah, 9
    mov dx, offset space
    int 21h
	
	mov ah, 9
    mov dx, offset msg3
    int 21h
	
	mov dl, "="
	mov ah, 2
	int 21h
	
	mov al, baitas3
	call printAL
	
	mov al, baitas4
	call printAL
	
	mov ah, 9
    mov dx, offset enteris
    int 21h
    
	
pabaiga:
    mov ax, regAX
    mov bx, regBX
    mov cx, regCX
    mov dx, regDX
    mov sp, regSP
    mov bp, regBP
    mov si, regSI
    mov di, regDI
IRET

printAX:
	push ax
	mov al, ah
	call printAL
	pop ax
	call printAL
RET

printAL:
	push ax
	mov cl, 4
	shr al, cl
	call printHexSkaitmuo
	pop ax
	call printHexSkaitmuo
RET

printHexSkaitmuo:	
	and al, 0Fh 
	cmp al, 9
	jbe PrintHexSkaitmuo_0_9
	jmp PrintHexSkaitmuo_A_F
	
	PrintHexSkaitmuo_A_F: 
	sub al, 10 
	add al, 41h
	mov dl, al
	mov ah, 2
	int 21h
	jmp PrintHexSkaitmuo_grizti
	
	
	PrintHexSkaitmuo_0_9:
	mov dl, al
	add dl, 30h
	mov ah, 2
	int 21h
	
	PrintHexSkaitmuo_grizti:
RET

check:    
   mov al, baitas2
   and al, 0C0h
   mov modd, al
   cmp al, 0C0h
   je poslNera
   cmp al, 0h
   je poslNera
   cmp al, 40h
   je poslVieno
   cmp al, 80h
   je poslDvieju
   
   poslNera:   
   mov al, baitas1
   call printAL
   mov al, baitas2
   call printAL
   
   jmp pabaiga1
   
   poslVieno:   
   mov al, baitas1
   call printAL
   mov al, baitas2
   call printAL
   mov al, baitas3
   call printAL 
   mov posl, 1h
   
   jmp pabaiga1
   
   poslDvieju:  
   mov al, baitas1
   call printAL
   mov al, baitas2
   call printAL
   mov al, baitas3
   call printAL 
   mov al, baitas4
   call printAL 
   mov posl, 2h
                 
   pabaiga1:   
ret

printREG:         
    cmp w, 1h
    je wordas
    jmp baitas
    
    wordas:  
    cmp reg, 0h
    jne w1
    jmp regiAX
    w1:
    cmp reg, 8h
    jne w2
    jmp regiCX
    w2:
    cmp reg, 10h
    jne w3
    jmp regiDX
    w3:
    cmp reg, 18h
    jne w4
    jmp regiBX
    w4:
    cmp reg, 20h
    jne w5
    jmp regiSP
    w5:
    cmp reg, 28h
    jne w6
    jmp regiBP
    w6:
    cmp reg, 30h
    jne w7
    jmp regiSI
    w7:
    jmp regiDI
    
    
    regiAX:    
    mov dx, offset opAX
    mov op1, dx
    mov ax, regAX 
    mov op1Word, ax 
    mov ah, 9
    int 21h
    mov opr1CheckBW, 1h   
    
    jmp pabaiga2
    
    regiCX:    
    mov dx, offset opCX
    mov op1, dx
    mov ax, regCX
    mov op1Word, ax 
    mov ah, 9
    int 21h
    mov opr1CheckBW, 1h     
    
    jmp pabaiga2
    
    regiDX:  
    mov dx, offset opDX
    mov op1, dx
    mov ax, regDX 
    mov op1Word, ax 
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 1h    
    
    jmp pabaiga2
    
    regiBX: 
    mov dx, offset opBX
    mov op1, dx
    mov ax, regBX 
    mov op1Word, ax 
    mov ah, 9
    int 21h
    mov opr1CheckBW, 1h     
    
    jmp pabaiga2
    
    regiSP:
    mov dx, offset opSP
    mov ax, regSP
    mov op1Word, ax 
    mov op1, dx
    mov ah, 9
    int 21h  
    mov opr1CheckBW, 1h     
    
    jmp pabaiga2
    
    regiBP:  
    mov dx, offset opBP
    mov op1, dx  
    mov ax, regBP
    mov op1Word, ax 
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 1h     
    
    jmp pabaiga2
    
    regiSI: 
    mov dx, offset opSI
    mov op1, dx
    mov ax, regSI
    mov op1Word, ax 
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 1h  
    
    jmp pabaiga2
    
    regiDI:  
    mov dx, offset opDI
    mov op1, dx
    mov ax, regDI 
    mov op1Word, ax 
    mov ah, 9
    int 21h
    mov opr1CheckBW, 1h    
    
    jmp pabaiga2
    
    baitas: 
    cmp reg, 0h
    jne b1
    jmp regiAL
    b1:
    cmp reg, 8h
    jne b2
    jmp regiCL
    b2:
    cmp reg, 10h
    jne b3
    jmp regiDL
    b3:
    cmp reg, 18h
    jne b4
    jmp regiBL
    b4:
    cmp reg, 20h
    jne b5
    jmp regiAH
    b5:
    cmp reg, 28h
    jne b6
    jmp regiCH
    b6:
    cmp reg, 30h
    jne b7
    jmp regiDH
    b7:
    jmp regiBH
    
    
    regiAL: 
    mov dx, offset opAL
    mov op1, dx    
    mov ax, regAX
    mov op1Baitas, al
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 2h 
    
    jmp pabaiga2
    
    regiCL:  
    mov dx, offset opCL
    mov op1, dx 
    mov cx, regCX
    mov op1Baitas, cl
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 2h  
    
    jmp pabaiga2
      
    regiDL:      
    mov dx, offset opDL
    mov ah, 9
    int 21h 
    
    mov op1, dx
    mov dx, regDX
    mov op1Baitas, dl
    mov opr1CheckBW, 2h 
    
    jmp pabaiga2
    
    regiBL:    
    mov dx, offset opBL
    mov op1, dx 
    mov bx, regBX
    mov op1Baitas, bl
    mov ah, 9
    int 21h
    mov opr1CheckBW, 2h   
    
    jmp pabaiga2
    
    regiAH:    
    mov dx, offset opAH
    mov op1, dx
    mov ax, regAX
    mov op1Baitas, ah
    mov ah, 9
    int 21h
    mov opr1CheckBW, 2h       
    
    jmp pabaiga2
    
    regiCH:   
    mov dx, offset opCH
    mov op1, dx
    mov cx, regCX
    mov op1Baitas, ch
    mov ah, 9
    int 21h 
    mov opr1CheckBW, 2h    
    
    jmp pabaiga2
    
    regiDH:    
    mov dx, offset opDH
    mov ah, 9
    int 21h
    
    mov op1, dx
    mov dx, regDX
    mov op1Baitas, dh
    mov opr1CheckBW, 2h  
    
    jmp pabaiga2
    
    regiBH:    
    mov dx, offset opBH
    mov op1, dx          
    mov bx, regBX
    mov op1Baitas, bh
    mov ah, 9  
    int 21h 
    mov opr1CheckBW, 2h

    
    pabaiga2:
ret 
    
operandas2:      
    cmp modd, 0C0h 
    jne mod00
    jmp mod11
    
    mod00:
    mov ah,2
    mov dl, "["
    int 21h
        
    cmp rm, 00h
    jne rm1
    jmp rm000
    rm1:
    cmp rm, 01h
    jne rm2
    jmp rm001
    rm2:
    cmp rm, 02h
    jne rm3
    jmp rm010
    rm3:
    cmp rm, 03h
    jne rm4
    jmp rm011
    rm4:
    cmp rm, 04h
    jne rm5
    jmp rm100
    rm5:
    cmp rm, 05h
    jne rm6
    jmp rm101
    rm6:
    cmp rm, 06h
    jne rm7
    jmp rm110
    rm7:
    jmp rm111
    
    rm000:
    mov dx, offset opBX
    mov ah, 9
    int 21h
    mov op2Pirmas, dx  
    mov ax, regBX
    mov op2PirmasTemp, ax 
    
    mov dl, "+"
    mov ah, 2
    int 21h
    
    mov dx, offset opSI
    mov ah, 9
    int 21h 
    mov op2Antras, dx
    mov ax, regSI
    mov op2AntrasTemp, ax 
    mov opr2CheckPosl, 2h
    
    call mod0110
    jmp operandoPabaiga 
    
    rm001:
    mov dx, offset opBX
    mov ah, 9
    int 21h
    mov op2Pirmas, dx
    mov ax, regBX
    mov op2PirmasTemp, ax 
    
    mov dl, "+"
    mov ah, 2
    int 21h
    
    mov dx, offset opDI
    mov ah, 9
    int 21h 
    mov op2Antras, dx
    mov ax, regDI
    mov op2AntrasTemp, ax
    mov opr2CheckPosl, 2h
    
    call mod0110 
    jmp operandoPabaiga 
    
    rm010:
    mov dx, offset opBP
    mov ah, 9
    int 21h
    mov op2Pirmas, dx 
    mov ax, regBP
    mov op2PirmasTemp, ax 
    
    mov dl, "+"
    mov ah, 2
    int 21h
    
    mov dx, offset opSI
    mov ah, 9
    int 21h 
    mov op2Antras, dx 
    mov ax, regSI
    mov op2AntrasTemp, ax
    mov opr2CheckPosl, 2h 
    
    call mod0110 
    jmp operandoPabaiga 
    
    rm011:
    mov dx, offset opBP
    mov ah, 9
    int 21h
    mov op2Pirmas, dx
    mov ax, regBP
    mov op2PirmasTemp, ax 
    
    mov dl, "+"
    mov ah, 2
    int 21h
    
    mov dx, offset opDI
    mov ah, 9
    int 21h 
    mov op2Antras, dx 
    mov ax, regDI
    mov op2AntrasTemp, ax
    mov opr2CheckPosl, 2h
    
    call mod0110 
    jmp operandoPabaiga 
     
    rm100:
    mov dx, offset opSI
    mov ah, 9
    int 21h
    mov op2Pirmas, dx 
    mov ax, regSI
    mov op2PirmasTemp, ax
    mov opr2CheckPosl, 1h 
    mov opr2CheckBW, 1h 
    
    call mod0110 
    jmp operandoPabaiga 
    
    rm101:
    mov dx, offset opDI
    mov ah, 9
    int 21h
    mov op2Pirmas, dx 
    mov ax, regDI    
    mov op2PirmasTemp, ax
    mov opr2CheckPosl, 1h 
    mov opr2CheckBW, 1h
    
    call mod0110 
    jmp operandoPabaiga 
     
    
    rm110:
    cmp posl, 0
    jne pos 
    mov al, baitas3
    call printAL
    mov al, baitas4
    call printAL 
    jmp operandoPabaiga 
    
    pos:
    mov dx, offset opBP
    mov ah, 9
    int 21h
    mov op2Pirmas, dx
    mov ax, regBP
    mov op2PirmasTemp, ax
    mov opr2CheckPosl, 1h 
    mov opr2CheckBW, 1h
    call mod0110 
    jmp operandoPabaiga 
    
    
    rm111:
    mov dx, offset opBX
    mov ah, 9
    int 21h
    mov op2Pirmas, dx
    mov ax, regBX
    mov op2PirmasTemp, ax 
    mov opr2CheckPosl, 1h
    mov opr2CheckBW, 1h
    
    call mod0110 
    jmp operandoPabaiga 
    
    operandoPabaiga:
    mov dl, "]"
    mov ah, 2
    int 21h
    jmp pabaiga3
    
    mod11:
    mov opr2CheckPosl, 1h
    mov al, rm
    mov cl, 3
    shl al, cl
    mov reg, al
    mov ax, op1
    mov tempop, ax
    mov ax, op1Word
    mov tempWord, ax
    mov al, op1Baitas
    mov tempBaitas, al
    mov al, opr1CheckBW
    mov tempCheck, al
     
    call printREG
      
    mov ax, op1
    mov op2Pirmas, ax
    mov ax, tempop
    mov op1, ax
    mov ax, op1Word
    mov op2PirmasTemp, ax
    mov ax, tempWord
    mov op1Word, ax
    mov al, op1Baitas
    mov op2PirmasB, al
    mov al, tempBaitas
    mov op1Baitas, al
    mov al, opr1CheckBW
    mov opr2CheckBW, al
    mov al, tempCheck
    mov opr1CheckBW, al
    
    pabaiga3:
ret 

mod0110: 
    cmp modd, 00
    je mod0
   
    mov dl, "+"
    mov ah, 2
    int 21h 
     
    cmp posl, 1h
    je poslVienas
    jmp poslDu
    
    poslVienas:  
    mov al, baitas3
    call printAL 
    jmp mod0
   
    poslDu:
    mov al, baitas3
    call printAL
    mov al, baitas4
    call  printAL 
    
    mod0:
ret
end start
	
	
    
	
	
	