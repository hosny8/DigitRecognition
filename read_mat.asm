global read_matrix

section .text
read_matrix:
    ; Prologue
    push ebp
    mov ebp, esp
    sub esp, 28

    push ebx
    push esi
    push edi

    ; Save arguments
    mov esi, [ebp + 8]   ; s0 = filename
    mov edi, [ebp + 12]  ; s1 = pointer to rows
    mov ebx, [ebp + 16]  ; s2 = pointer to columns

    ; FOPEN
    mov eax, esi         ; filename
    mov ecx, 0           ; mode = 0 (read mode)
    call fopen           ; fopen(filename, "r")
    test eax, eax
    js fopen_error       ; Error if return is -1
    mov edx, eax         ; s3 = file pointer

    ; FREAD for rows
    mov eax, edx         ; file pointer
    mov ecx, edi         ; pointer to store rows
    mov edx, 4           ; size to read
    call fread           ; fread(&rows, 4, 1, fp)
    cmp eax, 4
    jne fread_error      ; Error if bytes read != 4

    ; FREAD for columns
    mov eax, edx         ; file pointer
    mov ecx, ebx         ; pointer to store columns
    mov edx, 4           ; size to read
    call fread           ; fread(&cols, 4, 1, fp)
    cmp eax, 4
    jne fread_error      ; Error if bytes read != 4

    ; MALLOC for matrix
    mov eax, [edi]       ; rows
    mov ecx, [ebx]       ; cols
    imul eax, ecx        ; rows * cols
    shl eax, 2           ; * 4 (size of int)
    call malloc          ; malloc(rows * cols * 4)
    test eax, eax
    jz malloc_error      ; Error if malloc fails
    mov esi, eax         ; s4 = allocated memory pointer

    ; FREAD for matrix data
    mov eax, edx         ; file pointer
    mov ecx, esi         ; allocated matrix memory
    mov edx, [edi]       ; size = rows * cols * 4
    call fread           ; fread(matrix, 4, rows * cols, fp)
    cmp eax, [edi]
    jne fread_error      ; Error if bytes read != total elements

    ; FCLOSE
    mov eax, edx         ; file pointer
    call fclose          ; fclose(fp)
    test eax, eax
    jnz fclose_error     ; Error if fclose != 0

    ; Return the matrix pointer in EAX
    mov eax, esi

    ; Epilogue
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Error Handling
fopen_error:
    mov eax, 27          ; fopen error code
    jmp exit

fread_error:
    mov eax, 29          ; fread error code
    jmp exit

malloc_error:
    mov eax, 26          ; malloc error code
    jmp exit

fclose_error:
    mov eax, 28          ; fclose error code
    jmp exit
