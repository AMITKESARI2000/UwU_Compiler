.data 
var_a:    .word 0
var_b:    .word 0
var_c:    .word 0
var_d:    .asciiz "amit"
var_e:    .asciiz "is good"
.text 
.globl main
main:
j Label_main
Label_main:
lw $t0 , var_a
li $t1 , 10
add $t0 , $t1 , $zero
sw $t0 , var_a
lw $t0 , var_b
li $t1 , 20
add $t0 , $t1 , $zero
sw $t0 , var_b
lw $t0 , var_c
lw $t1 , var_a
lw $t2 , var_b
add $t0 , $t1 , $t2
sw $t0 , var_c
sw $t1 , var_a
sw $t2 , var_b
la $t0 , var_d
sw $t0 , var_d
la $t0 , var_e
sw $t0 , var_e
lw $t0 , var_a
lw $t0 , var_a
li $t1 , 1
add $t0 , $t0 , $t1
sw $t0 , var_a
la $t0 , var_e
lw $t0 , var_e
lw $t1 , var_d
la $a0 , var_e
la $a1 , var_d
la $a2 , var_e

concat:
    lb $t0, 0($a0)          
    beq $t0, $0, string2    
    sb $t0, 0($a2)          
    addi $a0, $a0, 1        
    addi $a2, $a2, 1        
    j concat     

string2:
    lb $t0, 0($a1)          
    beq $t0, $0, done       
    sb $t0, 0($a2)          
    addi $a1, $a1, 1        
    addi $a2, $a2, 1        
    j string2    

done:
    sb $0, 0($a2)

                
sw $t0 , var_e
sw $t1 , var_d
