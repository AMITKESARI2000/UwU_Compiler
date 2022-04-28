.data 
var_i:    .word 0
var_i_str:     .asciiz "                                                  "
for_output0:     .asciiz "End"
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_i
li $t1 , 10
add $t0 , $t1 , $zero
sw $t0 , var_i
li $v0 , 5
syscall
sw $v0 , var_i
li $v0 , 1
lw $a0 , var_i
syscall
li $v0 , 8
li $a1 , 50
la $a0 , var_i_str
syscall
li $v0 , 4
la $a0 , var_i_str
syscall
li $v0 , 4
la $a0 , for_output0
syscall
