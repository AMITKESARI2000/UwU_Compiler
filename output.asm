.data 
var_i:    .word 0
for_output0:     .asciiz "hi\n"
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_say_hi_from_out:
subu $sp,$sp,0 
sw $ra,($sp)
li $v0 , 4
la $a0 , for_output0
syscall
li $v1 , 0
li $t1 , 0
add $t0 , $t1 , $zero
j $ra
Label_main:
lw $t0 , var_i
li $t1 , 0
add $t0 , $t1 , $zero
sw $t0 , var_i
j Label_say_hi_from_out
li $v1 , 0
li $t1 , 0
add $t0 , $t1 , $zero
j $ra
