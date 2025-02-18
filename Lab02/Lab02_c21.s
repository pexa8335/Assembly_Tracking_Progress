.section .data
msg: .string "Love UIT"
msg_len = . - msg
newline: .string "\n"
.section .bss
.lcomm output, 4

.section .text
	.globl _start
_start:
	movl $msg_len, %eax
	addl $47, %eax		#+48 to convert to ascii, -1 to discard null
	movl %eax, output

#print value
	movl $4, %eax
	movl $1, %ebx
	movl $output, %ecx
	movl $1, %edx
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

