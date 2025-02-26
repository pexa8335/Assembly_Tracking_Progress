.section .data
	noti: .string "Enter a number (4-digits): "
	noti_len = . - noti

	incr: .string "Tang dan"
	incr_len = . - incr

	decl: .string "Khong tang dan"
	decl_len = . - decl

	newline: .string "\n"

.section .bss
	.lcomm input, 5

.section .text
	.globl _start
_start:

#print notification
	movl $4, %eax
	movl $1, %ebx
	movl $noti, %ecx
	movl $noti_len, %edx
	int $0x80

#input number
	movl $3, %eax
	movl $0, %ebx
	movl $input, %ecx
	movl $5, %edx
	int $0x80

#check increase
	movl $input, %eax	

	xor %ebx, %ebx	#empty %ebx
	xor %ecx, %ecx	#empty %ecx

	movb (%eax), %bh
	movb 1(%eax), %bl

#Compare index[0] = bh, [1] = bl
	cmpb %bh, %bl
	jl decrease

#Compare index [1] = bl, [2] = bh
	movb 2(%eax), %bh
	cmpb %bl, %bh
	jl decrease

#compare index[2] = bh, index[3] = bl
	movb 3(%eax), %bl
	cmpb %bh, %bl
	jl decrease

#if all case is passed->increase
	movl $4, %eax
	movl $1, %ebx
	movl $incr, %ecx
	movl $incr_len, %edx
	int $0x80
	jmp end

decrease:
	movl $4, %eax	
	movl $1, %ebx
	movl $decl, %ecx
	movl $decl_len, %edx
	int $0x80

end:
#newline before exit
	movl $4, %eax
	movl $1, %ebx
	movl $newline, %ecx
	movl $1, %edx
	int $0x80

#exit
	movl $1, %eax
	int $0x80