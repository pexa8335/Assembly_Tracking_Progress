.section .data
    age_pr: .string "Tuoi: "

    l18: .string "Chua vao UIT"
    l18_len = . - l18

    g18: .string "Dang hoc tai UIT"
    g18_len = . - g18

    g22: .string "Da tot nghiep"
    g22_len = . - g22

    prompt: .string "Nhap nam sinh (4 ky tu): "
    prompt_len = . - prompt

    l18_ft: .string "Nam du kien vao UIT: "
    l18_ft_len = . - l18_ft

    g18_ft: .string "Nam du kien TN: "
    g18_ft_len = . - g18_ft

    g22_ft: .string "Nam da TN"
    g22_ft_len = . - g22_ft

    newline: .string "\n"
.section .bss
    .lcomm age, 5       #age in ascii to print
    .lcomm age_int, 5   #age in integer
    .lcomm year, 5      #birthday
    .lcomm year_int, 5
    .lcomm year_calculate_last, 5
.section .text
    .globl _start
_start:
    #prompt enter
    movl $4, %eax
    movl $1, %ebx
    movl $prompt, %ecx
    movl $prompt_len, %edx
    int $0x80

    #enter year
    movl $3, %eax
    movl $0, %ebx
    movl $year, %ecx
    movl $5, %edx
    int $0x80

    #convert year from ascii to integer (1997) - birth
    movzbl year, %eax   #'1' - 48 * 1000
    subl $48, %eax
    imull $1000, %eax

    movzbl year + 1, %ebx   # '9' - 48 * 100
    subl $48, %ebx
    imull $100, %ebx
    addl %eax, %ebx         #1000 + 900

    movzbl year + 2, %eax
    subl $48, %eax
    imull $10, %eax         #9 * 10
    addl %eax, %ebx         #1900 + 90

    movzbl year + 3, %eax    # 7
    subl $48, %eax
    addl %eax, %ebx         #ebx = year = 1997 (in integer)
    movl %ebx, year_int     #birthday integer form
    #calculate age (integer)
    movl $2025, %eax        #2025 - 1997 = 28 store in eax
    subl %ebx, %eax         #%eax contains age in integer
    movl %eax, age_int      #age_int contain age in integer

    cmpl $18, %eax
    jl chua_vao_UIT

    cmpl $22, %eax
    jl graduated

    cmpl $18, %eax
    jg undergraduate

chua_vao_UIT:
    movl $4, %eax
    movl $1, %ebx
    movl $l18, %ecx
    movl $l18_len, %edx
    int $0x80
    jmp Age_calculation
graduated:
    movl $4, %eax
    movl $1, %ebx
    movl $g18, %ecx
    movl $g18_len, %edx
    int $0x80
    jmp Age_calculation

undergraduate:
    movl $4, %eax
    movl $1, %ebx
    movl $g22, %ecx
    movl $g22_len, %edx
    int $0x80
    jmp Age_calculation

Age_calculation:
    #newline
    movl $4, %eax
    movl $1, %ebx
    movl $1, %edx
    movl $newline, %ecx
    int $0x80

    #empty register
    xor %eax, %eax
    xor %ebx, %ebx
    xor %edx, %edx

    movl age_int, %eax      #assign value back to eax
    
    #convert age_int to age - from int to ascii to print
    movl $10, %ebx
    divl %ebx
    addl $'0', %eax
    movb %al, age
    movl %edx, %eax         #edx holds remainder, eax holds value
    addl $'0', %eax
    movb %al, age + 1      #year[1] = edx


    #prompt "Tuoi: "
    movl $4, %eax
    movl $1, %ebx
    movl $age_pr, %ecx
    movl $6, %edx
    int $0x80


    #Age of user
    movl $4, %eax
    movl $1, %ebx
    movl $age, %ecx
    movl $2, %edx
    int $0x80

    #newline
    movl $4, %eax
    movl $1, %ebx
    movl $1, %edx
    movl $newline, %ecx
    int $0x80

    #empty register
    xor %eax, %eax

    #check age < 18
    movl age_int, %eax          #age in integer into eax

    cmpl $18, %eax
    jl du_kien_uit

    cmpl $22, %eax
    jg da_tn

    cmpl $18, %eax
    jg du_kien_tn
du_kien_uit:
    #prompt "Nam du kien vao uit"
    movl $4, %eax
    movl $1, %ebx
    movl $l18_ft, %ecx
    movl $l18_ft_len, %edx
    int $0x80

    xor %eax, %eax
    xor %ebx, %ebx
    #Nam du kien vao UIT = 2025 + 18 - age
    movl $2025, %esi        #esi = 2025
    addl $18, %esi          #2025 + 18
    subl age_int, %esi      #2025 + 18 - age #integer form 

    jmp end

da_tn:
    #prompt "nam tot nghiep"
    movl $4, %eax
    movl $1, %ebx
    movl $g22_ft, %ecx
    movl $g22_ft_len, %edx
    int $0x80

    #calc nam tot nghiep = birth + 22
    movl year_int, %esi
    addl $22, %esi
    jmp end

du_kien_tn:
    #prompt "Du kien tot nghiep: "
    movl $4, %eax
    movl $1, %ebx
    movl $g18_ft, %ecx
    movl $g18_ft_len, %edx
    int $0x80

    #calc nam tot nghiep = birth + 22
    movl year_int, %esi
    addl $22, %esi
    jmp end

end:
    xor %ebx, %ebx
    xor %eax, %eax
    #convert integer to ascii
    movl $10, %ebx
    xor %edx, %edx

    movl %esi, %eax
    divl %ebx               #eax = 299, edx = 9
    addl $'0', %edx
    movb %dl, year_calculate_last + 3

    xor %edx, %edx
    divl %ebx               #eax = 29, edx = 9
    addl $'0', %edx
    movb %dl, year_calculate_last + 2

    xor %edx, %edx
    divl %ebx               #eax = 2, eax = 9
    addl $48, %edx
    addl $48, %eax
    movb %dl, year_calculate_last + 1
    movb %al, year_calculate_last

    #print last prompt
    movl $4, %eax
    movl $1, %ebx
    movl $year_calculate_last, %ecx
    movl $5, %edx
    int $0x80

    #newline
    movl $4, %eax
    movl $1, %ebx
    movl $1, %edx
    movl $newline, %ecx
    int $0x80

    #exit
    movl $1, %eax
    int $0x80