.data 
var_i:    .word 0
for_output0:     .asciiz "Integer Input:"
for_output1:     .asciiz "\n"
var_i_str:     .asciiz "                                                  "
for_output2:     .asciiz "String Input:"
for_output3:     .asciiz "\n"
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_i
li $t1 , 5
add $t0 , $t1 , $zero
sw $t0 , var_i
li $v0 , 5
syscall
sw $v0 , var_i
li $v0 , 4
la $a0 , for_output0
syscall
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 4
la $a0 , for_output1
syscall
li $v0 , 8
li $a1 , 50
la $a0 , var_i_str
syscall
li $v0 , 4
la $a0 , for_output2
syscall
li $v0 , 4
la $a0 , var_i_str
syscall
li $v0 , 4
la $a0 , for_output3
syscall
li $v1 , 0
li $t1 , 0
add $t0 , $t1 , $zero
j $ra
