.global main

    .text
    .align 3
handler:
    stp x29, x30, [sp, -48]!
    stp x19, x20, [sp, 16]
    str x21, [sp, 32]
    mov w21, wzr
    mov x20, x1
    adrp x19, html
    add x19, x19, :lo12:html
    mov x0, x19
    bl strlen
    mov x1, x19
    mov w2, 2
    bl MHD_create_response_from_buffer
    mov x19, x0
    cbnz x0, success
    b skip
success:
    mov x2, x0
    mov x0, x20
    mov w1, 200 
    bl MHD_queue_response
    mov w21, w0
    mov x0, x19
    bl MHD_destroy_response
skip:
    mov w0, w21
    ldr x21, [sp, 32]
    ldp x19, x20, [sp, 16]
    ldp x29, x30, [sp], 48                                            
    ret

main:
    stp x29, x30, [sp, -32]!
    mov x0, 8
    mov x1, 8888
    mov x2, xzr
    mov x3, xzr
    adrp x4, handler
    add x4, x4, :lo12:handler
    mov x5, xzr
    mov x6, xzr
    bl MHD_start_daemon
    str x0, [sp, 16]
    bl getchar
    ldr x0, [sp, 16]
    bl MHD_stop_daemon
    ldp x29, x30, [sp], 32
    ret

    .data
    .align 3
html:
    .string "<html><body>Olá, mundo!</body></html>"
