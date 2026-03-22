[BITS 16]
[ORG 0x7C00]

start:
    ; ========================================================
    ; EL ARREGLO: Inicializar la memoria (Data Segment)
    ; ========================================================
    xor ax, ax      ; Truco hacker para poner AX a 0 rápidamente
    mov ds, ax      ; DS (Data Segment) = 0. ¡Ahora sabrá leer el texto!
    mov es, ax      ; ES (Extra Segment) = 0
    mov ss, ax      ; SS (Stack Segment) = 0
    mov sp, 0x7C00  ; Inicializamos la Pila (Stack)
    cld             ; Le decimos que lea el texto de izquierda a derecha
    ; ========================================================

    ; 1. Activar modo gráfico VGA (320x200 píxeles)
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; 2. Pintar el fondo azul
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 64000
    mov al, 1       ; Color 1 = Azul
    rep stosb

    ; 3. Dibujar la ventana blanca en el centro
    mov di, 16110   
    mov bx, 50      
dibujar_fila:
    mov cx, 100     
    mov al, 15      ; Color 15 = Blanco
    rep stosb       
    add di, 220     
    dec bx          
    jnz dibujar_fila

    ; 4. Mover el "Cursor invisible" dentro de la ventana blanca
    mov ah, 0x02    
    mov bh, 0x00    
    mov dh, 11      ; Fila (Y) - Ajustado un poco más abajo
    mov dl, 14      ; Columna (X) - Ajustado para centrar mejor
    int 0x10

    ; 5. Imprimir nuestro mensaje letra a letra
    mov si, mensaje 
imprimir_letra:
    lodsb           
    cmp al, 0       
    je hang         
    
    mov ah, 0x0E    
    mov bl, 4       ; Color 0 = Negro
    int 0x10        
    jmp imprimir_letra 

    ; 6. Bucle infinito
hang:
    hlt
    jmp hang

; Nuestros datos
mensaje db 'Hola BecaOS!', 0

; Rellenar con ceros y firma
times 510-($-$$) db 0
dw 0xAA55