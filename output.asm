.data 
var_i:    .word 0
for_output0:     .asciiz "one"
for_output1:     .asciiz "\n"
for_output2:     .asciiz "two"
for_output3:     .asciiz "\n"
for_output4:     .asciiz "three"
for_output5:     .asciiz "\n"
for_output6:     .asciiz "hello"
for_output7:     .asciiz "End"
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_i
li $t1 , 0
add $t0 , $t1 , $zero
sw $t0 , var_i
Label_5:
lw $t0 , var_i
li $t1 , 10
bge $t0 , $t1 , Label_1
lw $t0 , var_i
li $t2 , 5
bge $t0 , $t2 , Label_4
li $v0 , 4
la $a0 , for_output0
syscall
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 4
la $a0 , for_output1
syscall
j Label_2
Label_4:
lw $t0 , var_i
li $t2 , 5
blt $t0 , $t2 , Label_0
lw $t0 , var_i
li $t3 , 7
bge $t0 , $t3 , Label_0
li $v0 , 4
la $a0 , for_output2
syscall
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 4
la $a0 , for_output3
syscall
j Label_2
Label_0:
lw $t0 , var_i
li $t1 , 10
bge $t0 , $t1 , Label_1
li $v0 , 4
la $a0 , for_output4
syscall
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 4
la $a0 , for_output5
syscall
j Label_1
Label_2:
li $v0 , 4
la $a0 , for_output6
syscall
lw $t0 , var_i
lw $t0 , var_i
li $t4 , 1
add $t0 , $t0 , $t4
sw $t0 , var_i
j Label_5
Label_1:
li $v0 , 4
la $a0 , for_output7
syscall
