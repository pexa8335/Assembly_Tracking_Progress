.section .data
    str: .string "Enter a string (<255 chars): "
    str_len = . - str

.section .bss
    .lcomm input, 256
    .lcomm prev, 1
.section .text
    .globl _start
_start:

    #notify-------
    movl $4, %eax
    movl $1, %ebx
    movl $str, %ecx
    movl $str_len, %edx
    int $0x80

    #get input-------
    movl $3, %eax
    movl $0, %ebx
    movl $input, %ecx
    movl $256, %edx
    int $0x80

    #initialize --------
    movl $input, %esi   #source index - đưa vào thanh ghi để có thể thao tác tăng giảm
    
    #set prev = a[0], capitalize-------------------
    movb (%esi), %al    #the first byte of (%esi)
    cmpb $'a', %al
    jl skip             #if %al < 'a' => don't convert

    cmpb $'z', %al      # %al > 'z' => skip
    jg skip

    #capitalize -----------------
    subb $32, %al       #uppercase
    movb %al, (%esi)    #assign back to source string

skip:
    movb %al, (prev)    #prev = a[0]

loop:
    incl %esi           #move to next byte - char[1]
    #execute with byte -> move byte to %al
    movb (%esi), %al    #al = a[1]

    cmpb $0, %al        #compare NULL
    je result
    cmpb $10, %al       #compare newline
    je result

    #check if prev char is space
    movb (prev), %bl    #bl = prev
    cmpb $32, %bl       #if prev == ' '
    je after_space

    #not after_space case
    cmpb $'A', %al
    jl store_char
    cmpb $'Z', %al
    jg store_char
    addb $32, %al 
    jmp store_char

after_space:
    #if %al not in range [a; z] -> skip
    cmpb $'a', %al
    jl store_char
    cmpb $'z', %al
    jg store_char
    subb $32, %al

store_char:
    movb %al, (%esi)        #save change in inputed string
    movb %al, (prev)
    jmp loop

result:     
    movl $4, %eax
    movl $1, %ebx
    movl $input, %ecx
    movl $256, %edx
    int $0x80
    
#exit
    movl $1, %eax
    int $0x80

