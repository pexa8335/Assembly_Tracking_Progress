.section .data

notify: .string "Enter a number < 10:"
noti_len = . - notify

newline: .string "\n"

.section .bss

.lcomm input, 4
.lcomm sum, 4
.lcomm average, 4

.section .text
	.globl _start
_start:
	movl $0, %edi		#int i = 0
	movl $0, sum		#sum = 0
	jmp condition		#for loop

loop:

#notify "enter a number"
	movl $4, %eax
	movl $1, %ebx
	movl $notify, %ecx
	movl $noti_len, %edx
	int $0x80
	

#input 
	movl $3, %eax
	movl $0, %ebx
	movl $input, %ecx
	movl $3, %edx		#3 byte: number, newline, null
	int $0x80

#convert to integer
	movl input, %eax 	#load inputed number
	subl $48, %eax		#-48 to convert to integer

#count sum
	addl %eax, sum		#sum = sum + eax, sum to access memory
	incl %edi		#i++
	
condition:
	cmpl $4, %edi		# i = 4 thi cut'
	je avg
	jmp loop

avg:
#count average
	movl sum, %eax
	sarl $2, %eax		#shift right to divide 4
	addl $48, %eax		#convert back to ascii
	movl %eax, average	#store in average

#display avg
	movl $4, %eax
	movl $1, %ebx
	movl $average, %ecx
	movl $4, %edx
	int $0x80

end:
	movl $1, %eax
	int $0x80
