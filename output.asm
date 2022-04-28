.data 
var_ff:    .word 0
var_i:    .word 0
for_output:     .asciiz "output: "
.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_ff
li $t1 , 20
add $t0 , $t1 , $zero
sw $t0 , var_ff
lw $t0 , var_i
li $t1 , 5
add $t0 , $t1 , $zero
sw $t0 , var_i
lw $t0 , var_i
lw $t1 , var_ff
bge $t0 , $t1 , Label_0
lw $t1 , var_ff
li $t2 , 20
bne $t1 , $t2 , Label_0
lw $t0 , var_i
lw $t0 , var_i
li $t3 , 2
add $t0 , $t0 , $t3
sw $t0 , var_i
sw $t1 , var_ff
j Label_1
Label_0:
lw $t0 , var_i
lw $t0 , var_i
li $t1 , 1
add $t0 , $t0 , $t1
sw $t0 , var_i
Label_1:
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 4
la $a0 , for_output
syscall
li $v0 , 1
lw $a0 , var_ff
syscall
