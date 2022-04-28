.data 
var_arr:    .space 16
ERROR:     .asciiz "Semantic Error"

.text 
.globl main
main:
j Label_main
Label_main:
li $t1 , 10
li $t2 , 11
add $t0 , $t1 , $t2
li $t4 , 0
add $t3 , $t4 , $zero
li $t6 , 1
add $t5 , $t6 , $zero
li $t6 ,  1
mul $t6 , $t5 , $t6
add $t3 , $t3 , $t6
li $t7 ,  4
mul $t5 , $t5 , $t7
li $t7 ,  4
mul $t3 , $t3 , $t7
sw $t0 , var_arr($t3)
li $t1 , 0
add $t0 , $t1 , $zero
li $t3 , 1
add $t2 , $t3 , $zero
li $t3 ,  1
mul $t3 , $t2 , $t3
add $t0 , $t0 , $t3
li $t4 ,  4
mul $t2 , $t2 , $t4
li $t4 ,  4
mul $t0 , $t0 , $t4
li $v0 , 1
lw $a0 , var_arr($t0)
syscall
