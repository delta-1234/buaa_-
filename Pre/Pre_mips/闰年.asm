.text
li $v0,5
syscall#����һ��int����n

move $s0,$v0#������n������s0�Ĵ���
li $t0,100
li $t1,4
li $t2,400
div $s0,$t0#n/100
mfhi $t3#������������t3��
beq $t3,$0,if_else1#���t3����0����n%100==0����ת��if_else1
div $s0,$t1#n/4
mfhi $t3
beq $t3,$0,if_else2#���t3����0����n%4==0��n%100��=0������ת��if_else2
li $a0,0#���0����������
li $v0,1
syscall
li $v0,10
syscall#��������

if_else2:#��n%100!=0&&n%4==0
li $a0,1
li $v0,1
syscall#���1��������
li $v0,10
syscall#��������

if_else1:#n%100==0
div $s0,$t2#n/400
mfhi $t3
beq $t3,$0,if_else3#���n%400==0��תif_else3
li $a0,0#���0����������
li $v0,1
syscall
li $v0,10
syscall#��������

if_else3:
li $a0,1
li $v0,1
syscall#���1��������
li $v0,10
syscall#��������
