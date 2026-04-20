pila segment para stack 'stack'
    db 1024 dup(?)
pila ends

datos segment para public 'data'
    cad        db "Ingrese su nombre: $"
    bienvenida db "Bienvenido al programa, $"
    nombre     db 30 dup('$')     ; buffer para el nombre
    msg1 db "Ingrese un numero (0-65535): $"
    msg2 db 13,10,"Raiz aproximada: $"
    num  dw ?
    aprox dw ?
    m1 db "Ingresa una opción: $"
    opc1 db "1. Conversión de números. $"
    opc2 db "2. Clasificar un número. $"
    opc3 db "3. Calcular la raíz cuadrada de un número. $"
    numero db "Ingresa un número (0 - 65535): $"
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
 ;aqui debe ir el codigo para procesar la raiz cuadrada
    ; Mostrar mensaje
    lea dx, msg1
    mov ah, 09h
    int 21h

    ; Leer número desde teclado (simplificado: aquí deberías implementar rutina para convertir cadena a número)
    ; Para ejemplo, cargamos un valor fijo:
    mov num, 400      ; N = 400

    ; Aproximación inicial: N/2
    mov ax, num
    mov cx, 2
    div cx            ; AX = N/2
    mov aprox, ax

    ; Iteraciones del método babilónico
    mov cx, 5         ; repetir 5 veces
iteracion:
    mov ax, num
    mov bx, aprox
    div bx            ; AX = N / aprox
    add ax, aprox     ; AX = aprox + (N/aprox)
    shr ax, 1         ; AX = (aprox + N/aprox)/2
    mov aprox, ax
    loop iteracion

    ; Mostrar mensaje resultado
    lea dx, msg2
    mov ah, 09h
    int 21h

    ; Convertir aprox a texto e imprimir (rutina aparte)
    ; Aquí solo mostramos un carácter como ejemplo
    mov ax, aprox
    add ax, '0'
    mov dl, al
    mov ah, 02h
    int 21h


    mov ah,07h
    int 21h
    ret
compa endp
codigo ends
end compa