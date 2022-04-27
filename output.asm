.data 
var_arr:    .space 1600
var_a:    .word 0
var_b:    .word 0
var_c:    .word 0
var_d:    .asciiz "amit kesari"
.text 
.globl main
main:
j Label_main
Label_main:
li $t1 , 0
add $t0 , $t1 , $zero
li $t3 , 1
add $t2 , $t3 , $zero
li $t4 ,  10
mul $t4 , $t2 , $t4
add $t0 , $t0 , $t4
li $t5 ,  20
mul $t2 , $t2 , $t5
li $t3 ,  1
mul $t3 , $t2 , $t3
add $t0 , $t0 , $t3
li $t6 ,  2
mul $t2 , $t2 , $t6
li $t6 ,  2
mul $t6 , $t2 , $t6
add $t0 , $t0 , $t6
li $t4 ,  10
mul $t2 , $t2 , $t4
li $t1 , 0
li $t8 , 11
add $t7 , $t1 , $t8
sw $t7 , arr($t0)
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
lw $t0 , var_d
li $t1 , "amit kesari"
add $t0 , $t1 , $zero
sw $t0 , var_d
lw $t0 , var_a
lw $t0 , var_a
li $t1 , 1
add $t0 , $t0 , $t1
sw $t0 , var_a

blt     $s0, $s1, string1_short
    la      $a1, string1
    jal     strcat

    la      $a1, string2
    jal     strcat

    j       print_full
    string1_short:
    # string 2 is longer -- append to output
    la      $a1,string2
    jal     strcat

    # string 1 is shorter -- append to output
    la      $a1,string1
    jal     strcat

# show results
print_full:
    # output the prefix message for the full string
    li      $v0,4
    la      $a0,full
    syscall

    # output the combined string
    li      $v0,4
    la      $a0,string3
    syscall

    # finish the line
    li      $v0,4
    la      $a0,newline
    syscall

    li      $v0,10
    syscall

# prompt -- prompt user for string
#
# RETURNS:
#   v0 -- length of string (with newline stripped)
#
# arguments:
#   a0 -- address of prompt string
#   a1 -- address of string buffer
#
# clobbers:
#   v1 -- holds ASCII for newline
prompt:
    # output the prompt
    li      $v0,4                   # syscall to print string
    syscall

    # get string from user
    li      $v0,8                   # syscall for string read
    move    $a0,$a1                 # place to store string
    li      $a1,256                 # maximum length of string
    syscall

    li      $v1,0x0A                # ASCII value for newline
    move    $a1,$a0                 # remember start of string

# strip newline and get string length
prompt_nltrim:
    lb      $v0,0($a0)              # get next char in string
    addi    $a0,$a0,1               # pre-increment by 1 to point to next char
    beq     $v0,$v1,prompt_nldone   # is it newline? if yes, fly
    bnez    $v0,prompt_nltrim       # is it EOS? no, loop

prompt_nldone:
    subi    $a0,$a0,1               # compensate for pre-increment
    sb      $zero,0($a0)            # zero out the newline
    sub     $v0,$a0,$a1             # get string length
    jr      $ra                     # return

# strcat -- append string
#
# RETURNS:
#   a0 -- updated to end of destination
#
# arguments:
#   a0 -- pointer to destination buffer
#   a1 -- pointer to source buffer
#
# clobbers:
#   v0 -- current char
strcat:
    lb      $v0,0($a1)              # get the current char
    beqz    $v0,strcat_done         # is char 0? if yes, done

    sb      $v0,0($a0)              # store the current char

    addi    $a0,$a0,1               # advance destination pointer
    addi    $a1,$a1,1               # advance source pointer
    j       strcat

strcat_done:
    sb      $zero,0($a0)            # add EOS
    jr      $ra                     # return

