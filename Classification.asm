section .text
global classify

; =================================================================
; FUNCTION: Classify input using pre-trained matrices (m0, m1).
; Arguments:
;   [esp+4] argc  - Number of arguments
;   [esp+8] argv  - Array of argument pointers
;   [esp+12] silent - Silent mode (1 = no output)
; Returns:
;   eax - Classification result
; Exceptions:
;   - Error code 31: Incorrect number of arguments
;   - Error code 26: Malloc failure
; =================================================================
classify:
    ; Prologue
    push ebp
    mov ebp, esp
    sub esp, 52            ; Allocate space for local variables
    push esi
    push edi
    push ebx

    ; Load arguments
    mov eax, [ebp+8]       ; Load argc
    cmp eax, 5             ; Check if argc == 5
    jne args_error

    mov esi, [ebp+12]      ; Load argv
    mov edi, [ebp+16]      ; Silent mode

    ; Read matrix m0
    mov eax, [esi+4]       ; Load pointer to m0 filepath
    lea ecx, [esp-8]       ; Prepare space for row/col
    push edi               ; Save silent mode
    call read_matrix
    add esp, 4             ; Restore stack

    mov dword [esp-8], eax ; Save pointer to m0
    mov ebx, [esp-4]       ; Save m0 rows
    mov ecx, [esp-12]      ; Save m0 cols

    ; Read matrix m1
    mov eax, [esi+8]       ; Load pointer to m1 filepath
    lea ecx, [esp-16]
    push edi
    call read_matrix
    add esp, 4

    mov dword [esp-16], eax ; Save pointer to m1
    mov ebx, [esp-12]       ; Save m1 rows
    mov ecx, [esp-20]       ; Save m1 cols

    ; Read input matrix
    mov eax, [esi+12]       ; Load pointer to input matrix
    lea ecx, [esp-24]
    push edi
    call read_matrix
    add esp, 4

    mov dword [esp-24], eax ; Save pointer to input
    mov ebx, [esp-20]       ; Save input rows
    mov ecx, [esp-28]       ; Save input cols

    ; Allocate memory for h (m0_rows * input_cols * 4 bytes)
    mov eax, ebx            ; m0 rows
    imul eax, ecx           ; Multiply by input cols
    shl eax, 2              ; Multiply by 4 (word size)
    call malloc
    test eax, eax
    je malloc_error
    mov dword [esp-32], eax ; Save pointer to h

    ; Perform h = matmul(m0, input)
    push ecx                ; Save registers
    push ebx
    call matmul
    add esp, 8              ; Restore stack

    ; Compute h = relu(h)
    mov eax, [esp-32]
    push ecx
    push ebx
    call relu
    add esp, 8

    ; Allocate memory for o
    mov eax, ebx            ; m1 rows
    imul eax, ecx           ; Multiply by input cols
    shl eax, 2              ; Multiply by 4 (word size)
    call malloc
    test eax, eax
    je malloc_error
    mov dword [esp-40], eax ; Save pointer to o

    ; Perform o = matmul(m1, h)
    push ecx
    push ebx
    call matmul
    add esp, 8

    ; Write output matrix o
    mov eax, [esi+16]
    push ecx
    push ebx
    call write_matrix
    add esp, 8

    ; Compute classification with argmax
    mov eax, [esp-40]       ; Pointer to o
    imul ecx, ebx           ; o rows * o cols
    push ecx
    call argmax
    add esp, 4
    mov dword [esp-48], eax ; Save classification

    ; Print classification if not silent
    cmp edi, 1
    je cleanup
    push eax
    call print_int
    add esp, 4
    mov eax, '\n'
    call print_char

cleanup:
    ; Free all allocated memory
    mov eax, [esp-32]       ; Pointer to h
    call free
    mov eax, [esp-40]       ; Pointer to o
    call free
    mov eax, [esp-8]        ; Pointer to m0
    call free
    mov eax, [esp-16]       ; Pointer to m1
    call free
    mov eax, [esp-24]       ; Pointer to input
    call free

    ; Epilogue
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

args_error:
    mov eax, 31             ; Set error code
    call exit
    ret

malloc_error:
    mov eax, 26             ; Set error code
    call exit
    ret
