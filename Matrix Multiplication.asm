section .text
global matrix_multiplication

; =======================================================
; FUNCTION: Matrix Multiplication of 2 integer matrices
;   d = matrix_multiplication(m0, m1)
; Arguments:
;   [esp+4] m0 (int*)   - Pointer to the start of m0
;   [esp+8] rows_m0     - # of rows (height) of m0
;   [esp+12] cols_m0    - # of columns (width) of m0
;   [esp+16] m1 (int*)  - Pointer to the start of m1
;   [esp+20] rows_m1    - # of rows (height) of m1
;   [esp+24] cols_m1    - # of columns (width) of m1
;   [esp+28] d (int*)   - Pointer to the start of d
; Returns:
;   None (void), sets d = matrix_multiplication(m0, m1)
; Exceptions:
;   - If dimensions are invalid, exits with code 38.
; =======================================================
matrix_multiplication:
    ; Error checks
    li t0 1 ; 1 for bounds check
    blt a1 t0 error
    blt a2 t0 error
    blt a4 t0 error
    blt a5 t0 error
    bne a2 a4 error

    ; Prologue
    push ebp
    mov ebp, esp
    sub esp, 32          ; Allocate space for local variables
    push esi             ; Save caller-saved registers
    push edi
    push ebx

    ; Load arguments
    mov eax, [ebp+8]     ; rows_m0
    cmp eax, 1
    jl error             ; Check rows_m0 >= 1

    mov eax, [ebp+12]    ; cols_m0
    cmp eax, 1
    jl error             ; Check cols_m0 >= 1

    mov eax, [ebp+20]    ; rows_m1
    cmp eax, 1
    jl error             ; Check rows_m1 >= 1

    mov eax, [ebp+24]    ; cols_m1
    cmp eax, 1
    jl error             ; Check cols_m1 >= 1

    ; Check cols_m0 == rows_m1
    mov eax, [ebp+12]    ; cols_m0
    cmp eax, [ebp+20]    ; rows_m1
    jne error

    ; Initialize pointers and indices
    mov esi, [ebp+4]     ; m0 pointer
    mov edi, [ebp+16]    ; m1 pointer
    mov ebx, [ebp+28]    ; d pointer
    mov ecx, 0           ; Outer loop index (i)

outer_loop_start:
    cmp ecx, [ebp+8]     ; i < rows_m0 ?
    jge outer_loop_end

    ; Inner loop: iterate over columns of m1
    push ecx             ; Save i
    mov edx, 0           ; Inner loop index (k)

inner_loop_start:
    cmp edx, [ebp+24]    ; k < cols_m1 ?
    jge inner_loop_end

    ; Calculate pointers for row of m0 and column of m1
    mov eax, ecx         ; i
    imul eax, [ebp+12]   ; i * cols_m0
    shl eax, 2           ; Offset for row of m0
    add eax, esi         ; Pointer to row i of m0
    push eax             ; Save row pointer

    mov eax, edx         ; k
    imul eax, [ebp+20]   ; k * rows_m1
    shl eax, 2           ; Offset for column of m1
    add eax, edi         ; Pointer to column k of m1
    push eax             ; Save column pointer

    ; Call dot
    push ebx             ; Result pointer (d)
    push [ebp+12]        ; cols_m0 (elements to use)
    push 1               ; Stride for m0
    push [ebp+24]        ; Stride for m1
    call dot
    add esp, 16          ; Clean up stack

    ; Store result in d
    pop eax              ; Restore column pointer
    pop eax              ; Restore row pointer
    mov [ebx], eax       ; Store result in d
    add ebx, 4           ; Advance d pointer

    inc edx              ; Increment k
    jmp inner_loop_start

inner_loop_end:
    pop ecx              ; Restore i
    inc ecx              ; Increment i
    jmp outer_loop_start

outer_loop_end:
    jmp cleanup

error:
    mov eax, 38          ; Exit code for invalid dimensions
    jmp exit

cleanup:
    ; Epilogue
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
