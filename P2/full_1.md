# 全排列

## 具体要求

1. 使用mips实现全排列生成算法。
2. 以0x00000000为数据段起始地址。
3. 输入一个小于等于6的正整数，求出n的全排列，并按照字典序输出。
4. 每组数据最多执行500,000条指令。
5. 请使用syscall结束程序

## C代码

使用dfs实现

```C
#include<stdio.h>
int symbol[7],array[7];
int n;
void FullArray(int index)
{
    int i;
    if(index>=n)
    {
        for(i=0;i<n;i++)
        {
            printf("%d ",array[i]);
        }
        printf("\n");
        return;
    }
    for(i=0;i<n;i++)
    {
        if(symbol[i]==0)
        {
            array[index]=i+1;
            symbol[i]=1;
            FullArray(index+1);
            symbol[i]=0;
        }
    }
}
int main()
{
    scanf("%d",&n);
    FullArray(0);
    return 0;
}
```

## MIPS

按照C代码翻译即可，注意把会丢失的变量压入栈中保存

```mips
.macro exit
li $v0,10
syscall
.end_macro

.macro scanInt(%d)
li $v0,5
syscall
move %d,$v0
.end_macro

.macro printInt(%d)
move $a0,%d
li $v0,1
syscall
.end_macro

.macro printStr(%str)
la $a0,%str
li $v0,4
syscall
.end_macro

.macro push(%src)
sw %src, 0($sp)
subi $sp, $sp, 4
.end_macro

.macro pop(%des)
addi $sp, $sp, 4
lw %des, 0($sp) 
.end_macro

.data
symbol: .space 28
array: .space 28
space: .asciiz " "
enter: .asciiz "\n"

.text
#main
scanInt($s0)#scanf("%d",&n)
li $a0,0#传参index
jal FullArray#调用函数
exit#结束程序
#main结束

#函数FullArray
FullArray:
	push($ra)#地址入栈
	push($a0)#参数入栈
	li $t0,0#循环变量i
	sub $t1,$a0,$s0
	if:
	bltz $t1,else
	loop_1_begin:
		beq $t0,$s0,loop_1_end
		sll $t2,$t0,2
		lw $t3,array($t2)
		printInt($t3)
		printStr(space)
		addi $t0,$t0,1
		j loop_1_begin
	loop_1_end:
	printStr(enter)
	pop($a0)
	pop($ra)
	jr $ra
	else:
	li $t0,0
	loop_2_begin:
		beq $t0,$s0,loop_2_end
		if1:
		sll $t2,$t0,2
		lw $t3,symbol($t2)
		beq $t3,$0,else1
		addi $t0,$t0,1
		j loop_2_begin		
		else1:
		addi $t2,$t0,1
		sll $t3,$a0,2
		sw $t2,array($t3)#arry[index]=i+1
		sll $t2,$t0,2
		li $t3,1
		sw $t3,symbol($t2)#symbol[i]=1
		addi $a0,$a0,1#传入index+1
		push($t0)
		jal FullArray
		pop($t0)
		subi $a0,$a0,1
		sll $t2,$t0,2
		sw $0,symbol($t2)
		addi $t0,$t0,1
		j loop_2_begin
	loop_2_end:
	pop($a0)
	pop($ra)
	jr $ra
#函数结束
```
