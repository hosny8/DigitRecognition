section .text
global argmax

; =================================================================
; FUNCTION: Given an int array, return the index of the largest
;   element. If there are multiple, return the one
;   with the smallest index.
; Arguments:
;   - [ebp+8] (int*) Pointer to the start of the array
;   - [ebp+12] (int) Number of elements in the array
; Returns:
;   - eax (int) Index of the largest element
; Exceptions:
;   - If the length of the array is less than 1, terminates
;     with error code 36
; =================================================================
argmax:
    ; Prologue
    push ebp                ; Save base pointer
    mov ebp, esp            ; Set up stack frame
    sub esp, 4              ; Allocate space for local variables
    push esi                ; Save registers used
    push edi

    ; Load arguments
    mov esi, [ebp+8]        ; Load pointer to the start of the array (a0)
    mov ecx, [ebp+12]       ; Load number of elements (a1)

    ; Error check: if length < 1, terminate
    cmp ecx, 1              ; Compare length with 1
    jl error                ; Jump to error handling if length < 1

    ; Initialization
    mov edi, 0              ; Index (t0) = 0
    mov eax, [esi]          ; Current max value (t3) = array[0]
    xor ebx, ebx            ; Max index (t4) = 0

loop_start:
    cmp edi, ecx            ; Check if index >= array length
    jge loop_end            ; Exit loop if all elements are processed

    mov edx, [esi]          ; Load array[edi] into edx (t2)
    cmp edx, eax            ; Compare array[edi] with current max
    jle loop_continue       ; If array[edi] <= current max, skip update

    ; Update max value and max index
    mov eax, edx            ; Update max value
    mov ebx, edi            ; Update max index

loop_continue:
    add esi, 4              ; Move to next element (pointer increment)
    inc edi                 ; Increment index
    jmp loop_start          ; Repeat loop

loop_end:
    ; Return the index of the largest element
    mov eax, ebx            ; Return max index (t4)

    ; Epilogue
    pop edi                 ; Restore registers
    pop esi
    mov esp, ebp            ; Restore stack pointer
    pop ebp                 ; Restore base pointer
    ret                     ; Return to caller

error:
    ; Error handling: terminate program with error code 36
    mov eax, 36             ; Error code
    jmp exit                ; Jump to program exit
