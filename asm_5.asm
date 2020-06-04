.model small
.stack 100h
.data

flag dw 3,3,3 dup(?)
flag2 dw 3,3,3 dup(?)
schet dw ?
msg1 db "Score: ",'$'                        
.code
    main proc
    mov ax, @data
    mov ds, ax    
        
    mov ax, 0b800h
    mov es, ax

    mov ah, 00
    mov al, 03
    int 10h                                         ; set videorejim
                                  
    mov cx, 23
    mov si, 0                                      ; s kakogo elementa  
    mov schet, 0
start:
    call input
    add si, 2
    cmp si, 160
    je next
    jmp start 
                                                                            
next:
    call input
    add si, 158
    call input
    add si, 2
    dec cx
    cmp cx, 0
    jne next

    mov cx, 80
next_otrisovka:
    call input
    add si, 2
    dec cx
    cmp cx, 0
    jne next_otrisovka
                     
    mov bx, 1
    mov si, 2726
otrisovka_urovna:
    mov cx, 2
    add si, 70
otrisovka_urovna1:
    call input_karta
    add si, 2
    loop otrisovka_urovna1
    add si, 320
    dec bx
    cmp bx, 0
    jne otrisovka_urovna
    
    mov flag, 1
    mov di, 3428
    mov si, 3580
start_igri:
    call score
    call otrisovka_poneli                           ; risuem ponel
    call proverca_stolknovenia_shara
next_start_igri:
    call score
    call otrisovka_shara                            ; risuem shar 
    mov dx, 65535
    mov ah, 86h
    int 15h
    mov dx, 65535
    mov ah, 86h
    int 15h
    mov dx, 65535
    mov ah, 86h
    int 15h
    mov ah, 1
    int 16h
    jz start_igri
    mov ah, 00h
    ;mov al, 00h
    int 16h
    mov bl, 219                                     ; simvol
    mov bh, 01000010b                               ; atributi
    cmp es:[si+18], bx
    je proverka_na_stolknovenie
    cmp es:[si-2], bx
    je proverka_na_stolknovenie1
proverka_na_stolknovenie_1:
    cmp al, 2dh                                     ; knopka '-'
    je endk
    cmp al, 44h                                     ; knopka 'D'
    je vpravo
    cmp al, 64h                                     ; knopka 'd'
    je vpravo                   
    cmp al, 41h                                     ; knopka 'A'
    je vlevo
    cmp al, 61h                                     ; knopka 'a'
    je vlevo
    jmp start_igri
                                
proverka_na_stolknovenie:
    sub si, 2
    jmp proverka_na_stolknovenie_1
proverka_na_stolknovenie1:
    add si, 2
    jmp proverka_na_stolknovenie_1
                                       
vpravo:
    mov al, 0                                       ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[si], ax                                 ; vizov
    mov es:[si-2], ax                               ; vizov
    add si, 2
    jmp start_igri
                                 
vlevo:
    mov al, 0                                       ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[si+16], ax                              ; vizov
    mov es:[si+18], ax                              ; vizov
    sub si, 2
    jmp start_igri
                                     
input proc
    mov al, 219                                     ; simvol
    mov ah, 01000010b                               ; atributi
    mov es:[si], ax                                 ; vizov
    ret
    endp input
                                    
input_karta proc
    mov al, 42                                      ; simvol
    mov ah, 00110100b                               ; atributi
    mov es:[si], ax                                 ; vizov
    ret
    endp input

otrisovka_shara proc
    cmp flag, 1
    je otrisovka_1
    cmp flag, 2
    je otrisovka_2
    cmp flag, 3
    je otrisovka_3
    cmp flag, 4
    je otrisovka_4
otrisovka_1_1:
    ret
    endp otrisovka_shara

otrisovka_1:
    sub di, 158
    mov al, 015                                     ; simvol
    mov ah, 00001100b                               ; atributi
    mov es:[di], ax
    mov al, 0                                     ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[di+158], ax
    jmp otrisovka_1_1
    
otrisovka_2:
    add di, 162
    mov al, 015                                     ; simvol
    mov ah, 00001100b                               ; atributi
    mov es:[di], ax
    mov al, 0                                     ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[di-162], ax
    jmp otrisovka_1_1

otrisovka_3:
    add di, 158
    mov al, 015                                     ; simvol
    mov ah, 00001100b                               ; atributi
    mov es:[di], ax
    mov al, 0                                     ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[di-158], ax
    jmp otrisovka_1_1

otrisovka_4:
    sub di, 162
    mov al, 015                                     ; simvol
    mov ah, 00001100b                               ; atributi
    mov es:[di], ax
    mov al, 0                                     ; simvol
    mov ah, 00000000b                               ; atributi
    mov es:[di+162], ax
    jmp otrisovka_1_1
                                
otrisovka_poneli proc                               ; risuem ponel
    mov cx, 9
    mov dx, si
panel:
    mov al, 219                                     ; simvol
    mov ah, 01101110b                               ; atributi
    mov es:[si], ax                                 ; vizov
    add si, 2
    loop panel
    mov si, dx
    ret
    endp otrisovka_poneli

zatiranie_v_p proc
    mov bl, 000                                     ; simvol
    mov bh, 000000000b                               ; atributi
    mov es:[di+158], bx
    ret 
    endp zatiranie

proverca_stolknovenia_shara proc
    cmp flag, 1
    je sravnenie_1
    cmp flag, 2
    je sravnenie_2
    cmp flag, 3
    je sravnenie_3
    cmp flag, 4
    je sravnenie_4
sravnenie_1_1:
    ret
    endp proverca_stolknovenia_shara

sravnenie_1:
    mov al, 42                                      ; simvol
    mov ah, 00110100b 
    cmp es:[di-160], ax
    je udalenie_1_1
    cmp es:[di+2], ax
    je udalenie_1_3
    cmp es:[di-158], ax
    je udalenie_1_5
udalenie_1_6:
    mov al, 219                                     ; simvol
    mov ah, 01000010b
    cmp es:[di-160], ax
    je flag_2
    cmp es:[di+2], ax
    je flag_4
    jmp sravnenie_1_1
    
sravnenie_2:
    cmp di, 3680
    ja game_over
    mov al, 42                                      ; simvol
    mov ah, 00110100b 
    cmp es:[di+160], ax
    je udalenie_2_1
    cmp es:[di+2], ax
    je udalenie_2_3
    cmp es:[di+162], ax
    je udalenie_2_5
udalenie_2_6:
    mov al, 219                                     ; simvol
    mov ah, 01101110b
    cmp es:[di+160], ax
    je flag_1
    cmp es:[di+2], ax
    je flag_3
    mov al, 219                                     ; simvol
    mov ah, 01000010b
    cmp es:[di+160], ax
    je flag_1
    cmp es:[di+2], ax
    je flag_3
    jmp sravnenie_1_1

sravnenie_3:
    cmp di, 3680
    ja game_over
    mov al, 42                                      ; simvol
    mov ah, 00110100b 
    cmp es:[di+160], ax
    je udalenie_3_1
    cmp es:[di-2], ax
    je udalenie_3_3
    cmp es:[di+158], ax
    je udalenie_3_5
udalenie_3_6:
    mov al, 219                                     ; simvol
    mov ah, 01101110b
    cmp es:[di+160], ax
    je flag_4
    cmp es:[di-2], ax
    je flag_2
    mov al, 219                                     ; simvol
    mov ah, 01000010b
    cmp es:[di+160], ax
    je flag_4
    cmp es:[di-2], ax
    je flag_2
    jmp sravnenie_1_1

sravnenie_4:
    mov al, 42                                      ; simvol
    mov ah, 00110100b 
    cmp es:[di-160], ax
    je udalenie_4_1
    cmp es:[di-2], ax
    je udalenie_4_3
    cmp es:[di-162], ax
    je udalenie_4_5
udalenie_4_6:    
    mov al, 219                                     ; simvol
    mov ah, 01000010b
    cmp es:[di-160], ax
    je flag_3
    cmp es:[di-2], ax
    je flag_1
    jmp sravnenie_1_1

udalenie_1_1:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-160], ax
    mov flag, 2
    add schet, 1
    jmp udalenie_1_6

udalenie_1_3:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+2], ax
    mov flag, 4
    add schet, 1
    jmp udalenie_1_6
    
udalenie_1_5:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-158], ax
    mov flag, 2
    add schet, 1
    jmp udalenie_1_6    

udalenie_2_1:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+160], ax
    mov flag, 1
    add schet, 1
    jmp udalenie_2_6

udalenie_2_3:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+2], ax
    mov flag, 3
    add schet, 1
    jmp udalenie_2_6
    
udalenie_2_5:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+162], ax
    mov flag, 1
    add schet, 1
    jmp udalenie_2_6

udalenie_3_1:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+160], ax
    mov flag, 4
    add schet, 1
    jmp udalenie_3_6

udalenie_3_3:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-2], ax
    mov flag, 2
    add schet, 1
    jmp udalenie_3_6
    
udalenie_3_5:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di+158], ax
    mov flag, 4
    add schet, 1
    jmp udalenie_3_6

udalenie_4_1:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-160], ax
    mov flag, 3
    add schet, 1
    jmp udalenie_4_6

udalenie_4_3:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-2], ax
    mov flag, 1
    add schet, 1
    jmp udalenie_4_6
    
udalenie_4_5:
    mov al, 0                                      ; simvol
    mov ah, 00000000b 
    mov es:[di-162], ax
    mov flag, 3
    add schet, 1
    jmp udalenie_4_6

flag_1:
    mov flag, 1
    jmp next_start_igri

flag_2:
    mov flag, 2
    jmp next_start_igri

flag_3:
    mov flag, 3
    jmp next_start_igri
    
flag_4:
    mov flag, 4
    jmp next_start_igri  

;vivod_score:
    

score proc
    mov al, 83                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3682], ax
    mov al, 99                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3684], ax
    mov al, 111                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3686], ax
    mov al, 114                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3688], ax
    mov al, 101                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3690], ax
    mov al, 58                                    ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3692], ax
    mov al, 32                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[3694], ax
    mov bx, 3700
    mov cx, schet
    mov dl, 0ah
metka_1:
    mov ax, cx
    div dl
    add ah, 30h
    mov cl, al
    mov al, ah                                     ; simvol
    mov ah, 00001111b                               ; atributi
    mov es:[bx], ax
    sub bx, 2
    mov al, cl 
    cmp al, 0
    jne metka_1
    cmp schet, 2
    je endk
    ret 
    endp score

game_over:
    mov al, 219          ; G                            
    mov ah, 00001111b 
    mov es:[1950], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1952], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1954], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1956], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2110], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2270], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2430], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2590], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2436], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2592], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2594], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2596], ax
    
    mov al, 219           ; A                           
    mov ah, 00001111b 
    mov es:[1964], ax     
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2122], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2282], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2286], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2126], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2442], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2440], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2600], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2444], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2446], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2448], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2608], ax
    
    mov al, 219           ; M                            
    mov ah, 00001111b 
    mov es:[1972], ax     
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1974], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1982], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[1984], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2132], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2134], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2142], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2144], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2292], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2296], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2300], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2304], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2452], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2456], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2460], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2464], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2612], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2618], ax
    mov al, 219                                      
    mov ah, 00001111b 
    mov es:[2624], ax
    
    mov al, 219           ; E                          
    mov ah, 00001111b 
    mov es:[1988], ax        
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[1990], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[1992], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[1994], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2148], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2308], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2310], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2312], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2314], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2468], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2628], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2630], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2632], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2634], ax
    
    mov al, 219          ; O                           
    mov ah, 00001111b 
    mov es:[2004], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2006], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2008], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2010], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2164], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2170], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2324], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2330], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2484], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2490], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2644], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2646], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2648], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2650], ax
    
    mov al, 219           ; V                          
    mov ah, 00001111b 
    mov es:[2014], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2022], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2174], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2182], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2336], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2340], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2496], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2500], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2658], ax
    
    mov al, 219            ; E                         
    mov ah, 00001111b 
    mov es:[2026], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2028], ax 
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2030], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2032], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2186], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2346], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2348], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2350], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2352], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2506], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2666], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2668], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2670], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2672], ax
    
    mov al, 219           ; R                          
    mov ah, 00001111b 
    mov es:[2036], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2038], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2040], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2042], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2196], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2198], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2200], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2202], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2356], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2358], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2516], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2520], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2676], ax
    mov al, 219                                     
    mov ah, 00001111b 
    mov es:[2682], ax
    jmp endk
 
endk:
    mov ax,4C00h
    int 21h