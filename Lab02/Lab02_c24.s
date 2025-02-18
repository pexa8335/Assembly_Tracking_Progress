.section .data
	str: .string "Nhap chuoi 4 ky tu: "
	str_len = . - str

	nhapn: .string "Nhap n in range [0;9]: "
	n_len = . - nhapn

	newline: .string "\n"

.section .bss
.lcomm string, 5	#contain null
.lcomm n, 2		#contain null

.section .text
	.globl _start
_start:

#notify input
	movl $4, %eax
	movl $1, %ebx
	movl $str_len, %edx
	movl $str, %ecx
	int $0x80

#input part
	movl $3, %eax
	movl $0, %ebx
	movl $string, %ecx
	movl $5, %edx
	int $0x80

#notify input n
	movl $4, %eax
	movl $1, %ebx
	movl $nhapn, %ecx
	movl $n_len, %edx
	int $0x80

#input n
	movl $3, %eax
	movl $0, %ebx
	movl $n, %ecx
	movl $2, %edx
	int $0x80

#calculate part
	movl $0, %edi		#index to traverse in string [0-3]
	movl $0, %eax		#set eax = 0 
loop:
	cmpb $'\n', string(%edi)	#string[i] = newline -> stop
	je end

	cmpb $'\0', string(%edi) #string [i] = null -> stop
	je end

	xor %eax, %eax		#clear %eax
	movb string(%edi), %al	#string[i] assign to eax
	subb $'a', %al		#sub 'a' in rage [0;25] and convert to num
	
#adding n, %26 to ensure in range [0; 25]
	xor %ebx, %ebx		#clear %ebx
	movb n, %bl
	subb $48, %bl		#convert to number
	addb %bl, %al		#result = char - 'a' + n
	
#keep in range [0;25]
	movb $26, %bl
	xor %ah, %ah
	divb %bl		#%al contains res, ah contains remainder


#convert to new char: adding 'a' and convert to ascii
	addb $'a', %ah
	
#add to string[i]
	movb %ah, string(%edi)
	incl %edi		#i++
	jmp loop

end:
	movl $4, %eax
	movl $1, %ebx
	movl $string, %ecx
	movl $5, %edx
	int $0x80

#exit
	movl $1, %eax
	int $0x80
