section .data
    msg_input db "Digite um numero: ", 0  ; Mensagem para solicitar a entrada
    msg_result db "A media e: ", 0        ; Mensagem para mostrar o resultado
    newline db 0xA                         ; Nova linha

section .bss
    num1 resd 1    ; Reservar espaço para o primeiro número
    num2 resd 1    ; Reservar espaço para o segundo número
    result resd 1  ; Reservar espaço para o resultado

section .text
    global _start

_start:
    ; Solicita o primeiro número
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg_input      ; mensagem para solicitar número
    mov edx, 17             ; tamanho da mensagem
    int 0x80                ; chamada ao kernel

    ; Lê o primeiro número
    mov eax, 3              ; syscall: sys_read
    mov ebx, 0              ; stdin
    mov ecx, num1           ; armazenar o número
    mov edx, 4              ; tamanho de leitura
    int 0x80                ; chamada ao kernel

    ; Solicita o segundo número
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg_input      ; mensagem para solicitar número
    mov edx, 17             ; tamanho da mensagem
    int 0x80                ; chamada ao kernel

    ; Lê o segundo número
    mov eax, 3              ; syscall: sys_read
    mov ebx, 0              ; stdin
    mov ecx, num2           ; armazenar o número
    mov edx, 4              ; tamanho de leitura
    int 0x80                ; chamada ao kernel

    ; Convertendo os números de string para inteiro (assume números de 1 dígito)
    mov eax, [num1]         ; move o valor de num1 para eax
    sub eax, '0'            ; converte o caractere ASCII para número
    mov [num1], eax         ; armazena o número convertido em num1

    mov eax, [num2]         ; move o valor de num2 para eax
    sub eax, '0'            ; converte o caractere ASCII para número
    mov [num2], eax         ; armazena o número convertido em num2

    ; Calcula a média (num1 + num2) / 2
    mov eax, [num1]         ; carrega num1 em eax
    add eax, [num2]         ; adiciona num2 a eax
    shr eax, 1              ; divide por 2 (shift right)
    mov [result], eax       ; armazena o resultado

    ; Exibe a mensagem de resultado
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg_result     ; mensagem de resultado
    mov edx, 12             ; tamanho da mensagem
    int 0x80                ; chamada ao kernel

    ; Exibe o valor do resultado
    mov eax, [result]       ; carrega o resultado
    add eax, '0'            ; converte o número para ASCII
    mov [result], eax       ; armazena o valor ASCII

    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; stdout
    mov ecx, result         ; mostrar o resultado
    mov edx, 1              ; tamanho do resultado
    int 0x80                ; chamada ao kernel

    ; Nova linha
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; stdout
    mov ecx, newline        ; caractere de nova linha
    mov edx, 1              ; tamanho de 1 byte
    int 0x80                ; chamada ao kernel

    ; Finaliza o programa
    mov eax, 1              ; syscall: sys_exit
    xor ebx, ebx            ; código de saída 0
    int 0x80                ; chamada ao kernel
nasm -f elf32 -o media.o media.asm
ld -m elf_i386 -o media media.o
./media
