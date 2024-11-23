section .text
global relu

; ==============================================================================
; FUNCTION: Performs an in-place element-wise ReLU on an array of integers
; Arguments:
;   [esp+4] (int*) - Pointer to the array
;   [esp+8] (int)  - Number of elements in the array
; Returns:
;   None
; Exceptions:
;   - If the length of the array is less than 1,
;     this function terminates the program with error code 36
; ==============================================================================

relu:
    ; Prologue
    push ebp                ; Save the base pointer
    mov ebp, esp            ; Set up stack frame
    sub esp, 4              ; Reserve space for local variables

    push esi                ; Save registers
    push edi

    ; Load arguments
    mov esi, [ebp+8]        ; Load the array pointer into esi
    mov ecx, [ebp+12]       ; Load the number of elements into ecx (loop counter)

    ; Check for invalid array length
    cmp ecx, 1              ; Compare length to 1
    jl error                ; Jump to error if length < 1

    xor eax, eax            ; Clear eax (used to store zero for ReLU)
    xor edx, edx            ; Initialize loop index to 0 (edx)

loop_start:
    cmp edx, ecx            ; Compare index with array length
    jge loop_end            ; Exit loop if index >= array length

    mov edi, [esi]          ; Load current element into edi
    cmp edi, 0              ; Compare element with 0
    jge skip_relu           ; If element >= 0, skip ReLU

    mov [esi], eax          ; Otherwise, set element to 0

skip_relu:
    add esi, 4              ; Move to the next element in the array
    inc edx                 ; Increment the index
    jmp loop_start          ; Repeat loop

error:
    mov eax, 36             ; Exit code for invalid array length
    jmp exit                ; Exit program

loop_end:
    ; Epilogue
    pop edi                 ; Restore registers
    pop esi
    mov esp, ebp            ; Restore stack pointer
    pop ebp                 ; Restore base pointer
    ret
