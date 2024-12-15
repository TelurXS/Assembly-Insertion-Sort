section .data
    array   dq  5, 1, 6, 2, 73, 2
    length  equ ($ - array) / 8

section .text
    global main
    extern printf

main:
    push rbp
    mov rbp, rsp

    mov rdi, format_unsorted
    xor rax, rax
    call printf

    mov rdi, array
    mov rsi, length
    call print_array

    mov rdi, array
    mov rsi, length
    call insertion_sort

    mov rdi, format_sorted
    xor rax, rax
    call printf

    mov rdi, array
    mov rsi, length
    call print_array

    xor rax, rax
    leave
    ret

; Insertion Sort Function
; Input: 
;   RDI = pointer to array
;   RSI = length of array
insertion_sort:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi  ; array pointer
    mov r13, rsi  ; array length

    mov r14, 1  ; i = 1
    
outer_loop:
    cmp r14, r13
    jge end_sort  ; if i >= length, sorting complete

    mov r15, r14  ; j = i
    mov rax, [r12 + r14 * 8]  ; key = array[i]

inner_loop:
    cmp r15, 0            ; if j > 0
    jle insert_key        ; If j <= 0, insert key
    
    mov rcx, [r12 + (r15 - 1) * 8]
    cmp rax, rcx
    jge insert_key        ; if key >= previous, insert

    mov [r12 + r15 * 8], rcx
    dec r15               ; j--
    jmp inner_loop

insert_key:
    mov [r12 + r15 * 8], rax
    inc r14               ; i++
    jmp outer_loop

end_sort:
    pop r15
    pop r14
    pop r13
    pop r12
    leave
    ret

; Print Array Function
; Input:
;   RDI = pointer to array
;   RSI = length of array
print_array:
    push rbp
    mov rbp, rsp
    push r12   
    push r13
    push r14

    mov r12, rdi
    mov r13, rsi
    mov r14, 0

print_loop:
    cmp r14, r13
    jge print_done

    mov rdi, format_element
    mov rsi, [r12 + r14 * 8]
    xor rax, rax
    call printf

    inc r14
    jmp print_loop

print_done:
    mov rdi, newline
    xor rax, rax
    call printf

    pop r14
    pop r13
    pop r12
    leave
    ret

section .data
    format_unsorted db "Unsorted array: ", 0
    format_sorted   db "Sorted array:   ", 0
    format_element  db "%ld ", 0
    newline         db 10, 0