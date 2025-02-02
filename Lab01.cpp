#include <stdio.h>


//Task 1.1 - Thực hiện | bit 2 số nguyên (không dùng | chỉ dùng & và ~).
//Explanation: De Morgan's principle
int bitOr(int a, int b){
    return ~(~a & ~b);
}

//Task 1.2 - Tính giá trị của -x mà không dùng dấu trừ.
//Explanation: Two's complement ~x + 1
int negative(int x){
    return ~x + 1;
}

//Task 1.3 - Lật 1 byte thứ n của số nguyên x, từ bit 0 thành 1 và ngược lại.
//Explanation: using XOR cuz 1 xor 1 = 0, 0 xor 1 = 1
//Create a mask with full of 1. In case of n = 1, flip bit from 8 -> 15, add 8 zero bit
//from the right. 1111 1111 will place on byte 0, if n = 1, it should be 1111 1111 0000 0000
//=> use shift left.
int flipByte(int x, int n){
    if (n < 0 || n > 3) 
        return 0;

    int bitMask = 0xFF << (n * 8);

    return x ^ bitMask;
}


//Task 1.4 - Tính kết quả phép chia lấy dư x % 2^n.
//Explanation: The remainder is the n-lowest bit (8 is 1000 and all posible remainder 
//is from 0 - 7, which only take 3 bit to represent = n bit).
//Taking n-lowest bit? 2^n - 1
//2^n? 1 << n
int mod2n(int x, int n){
    int mask = (1 << n) - 1;

    return x & mask;
}

//Task 1.5 - Res x / 2^n signed 
//Explanation: abs = (n ^ mask) + (~mask + 1).
//with negative n, x / 2^(-n) <=> x * 2^n <=> x << n
//with positive n, x / 2^n <=> x >> n
int divpw2(int x, int n) {
    unsigned int mask = n >> 31;//determine sign of n
    unsigned int abs_n = (n ^ mask) + (~mask + 1);//count_shift bit is positive => take abs
    
    //Neg n: mask = 0xFFFF FFFF => mask & abs = abs = shift_count needed
    //If shift left, don't need to shift right => ~mask & abs to make the shift_count = 0
    return (x << (mask & abs_n)) >> ((~mask) & abs_n);
}

//Task 2.1 - check if x = y (operator (+-*/&&==..) is banned)
//Explanation: XOR cuz 2 equal bit will return 0, demand: equal return 1 => xnor
int isEqual(int x, int y){
    return !(x^y);
}

//Task 2.2 - check if no remainder
//Explanation: find remainder of x / 16 <=> x / 2^4 <=> remainder = x & mask of 4 last bit
int is16x(int x){
    int mask = (1 << 4) - 1;//1111
    return !(x & mask);
}

//Task 2.3 - check if positive
//Explanation: x >> 31 & x to prevent test case 0 with result 1.
int isPositive(int x){
    return !(x >> 31) & x;
}

//Task 2.4 - check if x >= 2^n
//Explanation: find result of 2^n = 1 << n
//Check sign of the subtraction
int isGE2n(int x, int n){
    int res2PowerN = 1 << n;
    int subtraction = x + (~res2PowerN + 1);
    return !(subtraction >> 31);
}
int main(){


    //Task 1.1
    int a, b;
    scanf("%d %d", &a, &b);
    printf("Result %d\n", bitOr(a, b));

    //Task 1.2
    int a2;
    scanf("\n%d", &a2);
    printf ("\nResult %d\n", negative(a2));

    //Task 1.3
    int x, n;
    scanf("\n%x %d", &x, &n);
    printf("\nResult %x\n", flipByte(x, n));

    //Task 1.4
    int x1, n1;
    scanf("\n%d %d", &x1, &n1);
    printf("\n%d\n", mod2n(x1, n1));

    //Task 1.5
    int x2, n2;
    scanf("\n%d %d", &x2, &n2);
    printf("\nResult = %d\n", divpw2(x2, n2));

    //Task 2.1
    int x3, n3;
    scanf("\n%d %d", &x3, &n3);
    printf("\nResult = %d\n", isEqual(x3, n3));

    //Task 2.2
    int n4;
    scanf("\n%d", &n4);
    printf("\nResult = %d\n", is16x(n4));

    //Task 2.3
    int n5;
    scanf("\n%d", &n5);
    printf("\nResult = %d\n", isPositive(n5));

    //Task 2.4
    int x6, n6;
    scanf("\n%d %d", &x6, &n6);
    printf ("\nresult = %d\n", isGE2n(x6, n6));
}
