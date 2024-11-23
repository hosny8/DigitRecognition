section .data

section .text
global abs

; =================================================================
; FUNCTION: Given an int, return its absolute value.
; Arguments:
;   - Pointer to the integer is passed in the stack (x86-32 calling convention)
; Returns:
;   None (modifies the integer in place)
; =================================================================
abs:
    push ebp               ; Save base pointer
    mov ebp, esp           ; Set up stack frame
    sub esp, 4             ; Allocate space for local variables if needed

    mov eax, [ebp+8]       ; Load the address of the integer (1st argument)
    mov ebx, [eax]         ; Load the value at the address into ebx

    cmp ebx, 0             ; Compare the value with 0
    jge done               ; If greater or equal, jump to done

    neg ebx                ; Negate the value
    mov [eax], ebx         ; Store the result back to memory

done:
    mov esp, ebp           ; Restore stack pointer
    pop ebp                ; Restore base pointer
    ret                    ; Return to caller
