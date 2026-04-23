pila segment para stack 'stack'
    db 1024 dup(?)
pila ends

datos segment para public 'data'
    cad        db "Ingrese su nombre: $"
    bienvenida db 13,10,"Bienvenido, $"
    nombre     db 30 dup('$')

    m1 db 13,10,"Ingresa una opcion:$"
    opc1 db 13,10,"1. Conversion a binario$"
    opc2 db 13,10,"2. Clasificar numero (par/impar)$"
    opc3 db 13,10,"3. Raiz cuadrada$"
    opc4 db 13,10,"4. Salir$"

    numero db 13,10,"Ingresa un numero (0-65535): $"
    msgBin db 13,10,"Binario: $"
    msgPar db 13,10,"Es PAR$"
    msgImpar db 13,10,"Es IMPAR$"
    msgRaiz db 13,10,"Raiz aproximada: $"

    num  dw ?
    aprox dw ?
datos ends

codigo segment para public 'code'
public compa

compa proc far
assume cs:codigo, ds:datos, ss:pila

push ds
mov ax,0
push ax

mov ax,datos
mov ds,ax
mov es,ax

; ===== LIMPIAR =====
mov ah,06h
mov al,0
mov bh,07h
mov cx,0000h
mov dx,184Fh
int 10h

; ===== PEDIR NOMBRE =====
lea dx,cad
mov ah,09h
int 21h

lea di,nombre
leer:
    mov ah,01h
    int 21h
    cmp al,13
    je fin_lectura
    stosb
    jmp leer

fin_lectura:
    mov al,'$'
    stosb

inicio:

; ===== MENU =====
lea dx,bienvenida
mov ah,09h
int 21h

lea dx,nombre
mov ah,09h
int 21h

lea dx,m1
mov ah,09h
int 21h

lea dx,opc1
mov ah,09h
int 21h

lea dx,opc2
mov ah,09h
int 21h

lea dx,opc3
mov ah,09h
int 21h

lea dx,opc4
mov ah,09h
int 21h

; ===== LEER OPCION =====
mov ah,01h
int 21h

cmp al,'1'
jne op2
call conversion
jmp inicio

op2:
cmp al,'2'
jne op3
call clasificacion
jmp inicio

op3:
cmp al,'3'
jne op4
call raiz
jmp inicio

op4:
cmp al,'4'
jne inicio
jmp salir

; ============================================
; ===== LEER NUMERO ==========================
; ============================================
leer_numero proc
    xor bx,bx

leer_dig:
    mov ah,01h
    int 21h
    cmp al,13
    je fin_leer

    sub al,30h
    mov ah,0         ; AX = dígito

    push ax          ; guardar dígito

    mov ax,bx
    mov cx,10
    mul cx           ; AX = numero * 10

    pop dx           ; recuperar dígito
    add ax,dx        ; AX = numero*10 + digito

    mov bx,ax
    jmp leer_dig

fin_leer:
    mov ax,bx
    ret
leer_numero endp

; ============================================
; ===== CONVERSION BINARIO ===================
; ============================================
conversion proc
    lea dx,numero
    mov ah,09h
    int 21h

    call leer_numero

    lea dx,msgBin
    mov ah,09h
    int 21h

    mov cx,16
bin_loop:
    shl ax,1
    jc uno

    mov dl,'0'
    jmp imprimir

uno:
    mov dl,'1'

imprimir:
    mov ah,02h
    int 21h
loop bin_loop

ret
conversion endp

; ============================================
; ===== CLASIFICACION ========================
; ============================================
clasificacion proc
    lea dx,numero
    mov ah,09h
    int 21h

    call leer_numero

    test ax,1
    jz es_par

    lea dx,msgImpar
    mov ah,09h
    int 21h
    ret

es_par:
    lea dx,msgPar
    mov ah,09h
    int 21h
    ret
clasificacion endp

; ============================================
; ===== RAIZ CUADRADA ========================
; ============================================
raiz proc
    lea dx,numero
    mov ah,09h
    int 21h

    call leer_numero
    mov num,ax

    mov ax,num
    mov cx,2
    xor dx,dx
    div cx
    mov aprox,ax

    mov cx,7
iteracion:
    mov ax,num
    mov bx,aprox
    xor dx,dx
    div bx

    add ax,aprox
    shr ax,1

    mov aprox,ax
loop iteracion

    lea dx,msgRaiz
    mov ah,09h
    int 21h

    mov ax,aprox
    call imprimir_numero
    ret
raiz endp

; ============================================
; ===== IMPRIMIR NUMERO ======================
; ============================================
imprimir_numero proc
    mov bx,10
    mov cx,0

    cmp ax,0
    jne extrae

    push ax
    inc cx
    jmp imprime

extrae:
    cmp ax,0
    je imprime

    xor dx,dx
    div bx
    push dx
    inc cx
    jmp extrae

imprime:
    pop dx
    add dl,30h
    mov ah,02h
    int 21h
    loop imprime

    ret
imprimir_numero endp

; ============================================
salir:
mov ah,4Ch
int 21h

compa endp
codigo ends
end compa