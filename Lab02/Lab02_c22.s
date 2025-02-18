.section .data
	newline: .string "\n"
	notify: .string "Nhap MSSV (8 ky tu):"
	len = . - notify
.section .bss
	.lcomm input, 8
	.lcomm output, 6

.section .text
	.globl _start
_start:
	movl $4, %eax	#sys_write
	movl $1, %ebx	#stdout
	movl $notify, %ecx 	#address of the string need to be printed
	movl $len, %edx		#length of string
	int $0x80

#enter mssv
	movl $3, %eax	#sys_read
	movl $0, %ebx	#stdin - accept input from keyboard
	movl $8, %edx	#length of inputed string
	movl $input, %ecx 	#address of inputed string
	int $0x80

# resovle MSSV to discard char 3, 4
	movl $input, %esi
	movl $output, %edi
	movl $1, %ecx	#represents i

	jmp condition

loop:
	cmpl $0, (%esi) 	#check null
	je end

	cmpl $3, %ecx		# i = 3 end
	je continue

	cmpl $4, %ecx		# i = 4 end
	je continue

	movb (%esi), %al	#take the first byte of %esi
	movb %al, (%edi)
	incl %edi		# edi will point to the next char

continue:
	incl %ecx		# i++
	incl %esi		# esi will point to the next byte
	cmpl $9, %ecx
	je end
	jmp loop

condition:
	cmpl $9, %ecx
	je end
	jmp loop
end:
	movl $4, %eax
	movl $1, %ebx
	movl $6, %edx
	movl $output, %ecx
	int $0x80

#adding newline
	movl $4, %eax
	movl $1, %ebx
	movl $1, %edx
	movl $newline, %ecx
	int $0x80

#exit
	movl $1, %eax
	int $0x80
