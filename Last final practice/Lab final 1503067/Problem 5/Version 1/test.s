
#start
.text
.globl main
main:
addiu $t7, $sp, 1000

#ld_int
li $a0, 2
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#ld_int
li $a0, 3
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#halt
li $v0, 10
syscall
