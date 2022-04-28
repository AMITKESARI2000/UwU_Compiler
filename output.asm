.data 
var_k:    .asciiz "hello"
var_i:    .word 0
for_output0:     .asciiz "\n"
for_output1:     .asciiz "Bad \n"
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_k
li $t1 , "hello"
add $t0 , $t1 , $zero
sw $t0 , var_k
lw $t0 , var_i
li $t1 , 0
add $t0 , $t1 , $zero
sw $t0 , var_i
lw $t0 , var_k
li $t1 , "hello"
bne $t0 , $t1 , Label_4
lw $t2 , var_i
li $t3 , 0
add $t2 , $t3 , $zero
sw $t0 , var_k
sw $t2 , var_i
Label_0:
lw $t0 , var_i
li $t1 , 10
bge $t0 , $t1 , Label_1
li $v0 , 1
lw $a0 , var_k
syscall
li $v0 , 4
la $a0 , for_output0
syscall
lw $t0 , var_i
lw $t0 , var_i
li $t2 , 1
add $t0 , $t0 , $t2
sw $t0 , var_i
j Label_0
Label_1:
j Label_5
Label_4:
lw $t0 , var_i
li $t1 , 0
add $t0 , $t1 , $zero
sw $t0 , var_i
Label_2:
lw $t0 , var_i
li $t1 , 10
bge $t0 , $t1 , Label_3
li $v0 , 4
la $a0 , for_output1
syscall
lw $t0 , var_i
lw $t0 , var_i
li $t2 , 1
add $t0 , $t0 , $t2
sw $t0 , var_i
j Label_2
Label_3:
Label_5:
