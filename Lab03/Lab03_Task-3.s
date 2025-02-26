.section .data
    noti: .string "Enter a number (1-digit): "
    noti_len = . - noti

    count: .string "Count 4x: "
    c_len = . - count

    newline: .string "\n"
.section .bss
    .lcomm input, 4
    .lcomm output, 4
.section .text
    .globl _start
_start:
    movl $0, %esi   #i = 0
    movl $0, %edi   #count = 0
loop:
    cmpl $5, %esi
    je end

    #notify
    movl $4, %eax
    movl $1, %ebx
    movl $noti, %ecx
    movl $noti_len, %edx
    int $0x80

    #get input
    movl $3, %eax
    movl $0, %ebx
    movl $input, %ecx
    movl $4, %edx
    int $0x80

    #convert to ascii to calculate
    movb (input), %al
    subb $'0', %al

    #check divisable
    movb $4, %bl
    divb %bl

    cmpb $0, %ah    #check remainder
    jne not_count
    incl %edi
    
not_count:
    incl %esi
    jmp loop

end:
    #convert result to ascii
    addl $'0', %edi
    movl %edi, (output)
    #move result to count
    movl %edi, (output)

    #print "Count 4x"
    movl $4, %eax
    movl $1, %ebx
    movl $count, %ecx
    movl $c_len, %edx
    int $0x80

    #print count result
    movl $4, %eax
    movl $1, %ebx
    movl $output, %ecx
    movl $4, %edx
    int $0x80

    #newline
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    #exit
    movl $1, %eax
    int $0x80