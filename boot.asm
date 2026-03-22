[BITS 16]
[ORG 0x7C00]

start:
    ; 1. Inicializar la memoria (Data Segment)
    xor ax, ax      
    mov ds, ax      
    mov es, ax      
    mov ss, ax      
    mov sp, 0x7C00  
    cld             

    ; 2. Activar modo gráfico VGA (320x200 píxeles)
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; 3. Pintar el fondo azul
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 64000
    mov al, 1       ; Color 1 = Azul
    rep stosb

    ; 4. Dibujar la ventana blanca en el centro
    mov di, 16110   
    mov bx, 50      
dibujar_fila:
    mov cx, 100     
    mov al, 15      ; Color 15 = Blanco
    rep stosb       
    add di, 220     
    dec bx          
    jnz dibujar_fila

    ; 5. Mover el "Cursor" dentro de la ventana blanca (Título)
    mov ah, 0x02    
    mov bh, 0x00    
    mov dh, 10      ; Fila (Y) 
    mov dl, 14      ; Columna (X) 
    int 0x10

    ; 6. Imprimir el mensaje de bienvenida
    mov si, mensaje 
imprimir_letra:
    lodsb           
    cmp al, 0       
    je iniciar_teclado ; ¡NUEVO! Cuando termine de saludar, salta al teclado
    
    mov ah, 0x0E    
    mov bl, 4       ; Color 4 = Rojo (Para el título)
    int 0x10        
    jmp imprimir_letra 

    ; ========================================================
    ; FASE 3: EL TECLADO (El Bucle Principal del OS)
    ; ========================================================
iniciar_teclado:
    ; Mover el cursor a la línea de abajo para que empieces a escribir
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 12      ; Dos filas más abajo que el saludo
    mov dl, 12      ; Alineado un poco a la izquierda
    int 0x10

bucle_teclado:
    ; a) Escuchar al teclado
    mov ah, 0x00    ; Función de la BIOS: "Esperar tecla"
    int 0x16        ; ¡La CPU se pausa aquí hasta que pulses algo!
                    ; Cuando pulsas, el código de la letra se guarda en el registro AL.

    ; b) Dibujar la tecla que acabas de pulsar
    mov ah, 0x0E    ; Función de la BIOS: "Imprimir letra"
    mov bl, 4       ; Color 0 = Negro (Para tu texto)
    int 0x10        ; Dibuja la letra que está en AL en la pantalla

    ; c) Volver a empezar
    jmp bucle_teclado

; Nuestros datos
mensaje db 'BecaOS', 0

; Rellenar con ceros y firma
times 510-($-$$) db 0
dw 0xAA55