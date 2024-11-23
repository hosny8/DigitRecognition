global write_matrix

section .text

write_matrix:
    ; Prologue
    push ebp
    mov ebp, esp
    sub esp, 36
    push ebx
    push esi
    push edi

    ; Save arguments
    mov esi, [ebp + 8]   ; s0 = filename
    mov edi, [ebp + 12]  ; s1 = matrix pointer
    mov ebx, [ebp + 16]  ; s2 = rows
    mov ecx, [ebp + 20]  ; s3 = cols

    ; FOPEN
    mov eax, esi         ; filename
    mov edx, 1           ; mode = 1 (write mode)
    call fopen
    test eax, eax
    js fopen_error       ; Error if return is -1
    mov edx, eax         ; s4 = file pointer

    ; Write rows
    push ebx             ; push rows (s2)
    lea eax, [esp]       ; pointer to rows
    mov ecx, 1           ; count = 1
    mov edx, 4           ; size = 4 bytes
    call fwrite
    add esp, 4           ; clean stack
    cmp eax, 1
    jne fwrite_error

    ; Write columns
    push ecx             ; push cols (s3)
    lea eax, [esp]       ; pointer to cols
    mov ecx, 1           ; count = 1
    mov edx, 4           ; size = 4 bytes
    call fwrite
    add esp, 4           ; clean stack
    cmp eax, 1
    jne fwrite_error

    ; Calculate size of matrix in bytes
    mov eax, ebx         ; rows
    imul eax, ecx        ; rows * cols
    shl eax, 2           ; multiply by 4 (int size in bytes)

    ; Write matrix data
    mov ecx, eax         ; total size in bytes
    mov eax, edx         ; file pointer
    mov ebx, edi         ; matrix pointer
    call fwrite
    cmp eax, ecx
    jne fwrite_error

    ; FCLOSE
    mov eax, edx         ; file pointer
    call fclose
    test eax, eax
    jnz fclose_error

    ; Epilogue
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Error handling
fopen_error:
    mov eax, 27          ; fopen error code
    jmp exit

fwrite_error:
    mov eax, 30          ; fwrite error code
    jmp exit

fclose_error:
    mov eax, 28          ; fclose error code
    jmp exit
