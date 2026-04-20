pila segment para stack 'stack'
    db 1024 dup(?)
pila ends

datos segment para public 'data'
    cad        db "Ingrese su nombre: $"
    bienvenida db "Bienvenido al programa, $"
    nombre     db 30 dup('$')     ; buffer para el nombre
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
    mov es,ax       ; <-- ahora stosb escribe en datos

    ; Limpia pantalla
    mov ah,06h
    mov al,0
    mov bh,07h
    mov cx,0000h
    mov dx,184Fh
    int 10h

    ; Mueve cursor a fila 1, col 1
    mov ah,02h
    mov bh,0
    mov dh,1
    mov dl,1
    int 10h

    ; Mostrar mensaje de entrada
    lea dx,cad
    mov ah,09h
    int 21h

    ; Capturar nombre
    lea di,nombre
leer:
    mov ah,01h
    int 21h
    cmp al,13          ; Enter?
    je fin_lectura
    stosb              ; guardar carácter en 'nombre'
    jmp leer

fin_lectura:
    mov al,'$'
    stosb              ; terminar la cadena con $

    ; Mostrar mensaje de bienvenida
    lea dx,bienvenida
    mov ah,09h
    int 21h

    ; Mueve cursor a fila 2, col 20
    mov ah,02h
    mov bh,0
    mov dh,2
    mov dl,23
    int 10h

    ; Mostrar el nombre ingresado
    lea dx,nombre
    mov ah,09h
    int 21h

    ; Nueva línea
    mov dl,13
    mov ah,02h
    int 21h
    mov dl,10
    mov ah,02h
    int 21h

    mov ah,07h
    int 21h
    ret
compa endp
codigo ends
end compa