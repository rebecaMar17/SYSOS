[BITS 16]
[ORG 0x7C00]

start:
    ; 1. Activar modo gráfico VGA (320x200 píxeles)
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; 2. Pintar el fondo azul (como ya hiciste)
    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 64000
    mov al, 1       ; Color 1 = Azul
    rep stosb

    ; 3. DIBUJAR NUESTRA PRIMERA VENTANA BLANCA
    mov di, 16110   ; Coordenada X,Y calculada para el centro de la pantalla
    mov al, 15      ; Color 15 = Blanco puro

    mov bx, 50      ; Alto de la ventana (50 líneas de píxeles)
dibujar_fila:
    mov cx, 100     ; Ancho de la ventana (100 píxeles por línea)
    rep stosb       ; La CPU pinta 100 píxeles blancos seguidos a la velocidad de la luz
    
    add di, 220     ; Truco matemático: saltar al inicio de la línea siguiente
    dec bx          ; Restamos 1 a las líneas que nos faltan por pintar
    jnz dibujar_fila; Si aún quedan líneas, vuelve arriba y pinta la siguiente

    ; 4. Bucle infinito para no apagarse
hang:
    hlt
    jmp hang

; Rellenar con ceros y firma mágica
times 510-($-$$) db 0
dw 0xAA55