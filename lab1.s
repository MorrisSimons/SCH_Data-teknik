.equ UART_BASE, 0xff201000
.equ STACK_BASE, 0x10000000
.equ NEW_LINE, 0x0A

.global _start
.text

idiv:
    MOV r2, r1
    MOV r1, r0
    MOV r0, #0
    B _loop_check
    _loop:
    ADD r0, r0, #1
    SUB r1, r1, r2
    _loop_check:
    CMP r1, r2
    BHS _loop
    BX lr

print_number:
    PUSH {r0-r5, lr}
    MOV r5, #0
    _div_loop:
    ADD r5, r5, #1
    MOV r1, #10
    BL idiv
    PUSH {r1}
    CMP r0, #0
    BHI _div_loop
    _print_loop:
    POP {r0}
    LDR r2, =#UART_BASE
    ADD r0, r0, #0x30
    STR r0, [r2]
    SUB r5, r5, #1
    CMP r5, #0
    BNE _print_loop
    MOV r0, #NEW_LINE
    STR r0, [r2]
    POP {r0-r5, pc}

factorial:
    push {r4, lr}
    cmp r0, #1
    ble end_factorial
    mov r4, r0
    sub r0, r0, #1
    bl factorial
    mul r0, r0, r4
    pop {r4, pc}
end_factorial:
    mov r0, #1
    pop {r4, pc}

_start:
    mov r4, #1

main_loop:
    cmp r4, #11
    bge end_loop
    mov r0, r4
    bl factorial
    bl print_number
    add r4, r4, #1
    b main_loop
end_loop:
    BAL end_loop