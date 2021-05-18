
.data
   array: .space 20
    n: .word 0
	teksti1: .asciiz "Jep numrin e anetareve te vektorit (max. 5) : "
	teksti2: .asciiz "\nShtyp elementet nje nga nje:\n "
	teksti3: .asciiz "\nVlerat e vektorit ne fund : \n "
	newline: .asciiz "\n"

	
.text 

main: 
   la $a0, array
   la $a1, n
   jal populloVektorin
    sw $v1, 0($a1)
    jal unazaKalimit
   populloVektorin:
    move $s0, $a0
    move $s1, $a1
	la $a0, teksti1
	li $v0, 4
	syscall
	
        li $v0, 5
        syscall
	move $s1, $v0
	addi $s2, $zero, 1
	add $t0, $s0, $zero

        la $a0, teksti2
        li $v0, 4
        syscall
	
for_loop:
	bgt $s2, $s1, end_loop
        li $v0, 5
        syscall
        sw $v0, ($t0)
        addi $t0, $t0, 4
        addi $s2, $s2, 1
        j for_loop
end_loop:
 move $v1, $s1
 j $ra    
unazaKalimit:
	la $a0, newline
	li $v0, 4
	syscall
	add $a0, $s0, $zero
	li $a1, 0
	add $a2, $s1, $zero
	jal sortimi

Inicializimi:
	li $s2, 0
	add $t0, $s0, $zero
	
	la $a0, teksti3
	li $v0, 4
	syscall
	
Printimi:
        bge $s2, $s1, fundi
        lw $a0, ($t0)
        li $v0, 1
        syscall
        
        la $a0, newline
        li $v0, 4
        syscall
        
        addiu $t0, $t0, 4
        addi $s2, $s2, 1
        j Printimi
	
fundi:
	li $v0, 10                                  
	syscall		

Shkembimi:
	lw $t8, ($a0)
	lw $t9, ($a1)
	sw $t8, ($a1)
	sw $t9, ($a0)
	jr $ra

sortimi:
	add $s6, $a2, $zero
	add $s7, $a0, $zero
	addi $t2, $a2, -1
	add $t0, $zero, $zero
	add $t3, $a0, $zero

SortLoop:
	bge $t0, $t2, endSortLoop
	add $a0, $s7, $zero
	add $a1, $t0, $zero
	jal unazaVlerave
	add $a0, $v0, $zero
	add $a1, $t3 , $zero
	jal Shkembimi
	addi $t0, $t0, 1
	addiu $t3, $t3, 4
	j SortLoop

endSortLoop:
	j Inicializimi

unazaVlerave:
	add $t9, $a1, $zero
	add $t7, $a2, $zero
	mul $t5, $a1, 4 
	add $t6, $a0, $t5
	lw $t8, ($t6)
	add $v0, $t6, $zero
	lw $t5, ($v0)
	move $t4, $t0
	addi $t9, $t4, 1
	addiu $t6, $t6, 4
	move $t1, $a1
minimumi:
        bge $t9, $t7, endminimumi
        lw $t8, ($t6)
	bge $t8, $t5, perfundo
	add $v0, $t6, $zero
	lw $t5, ($v0)
    move $t1,$t9
perfundo:
	addi $t9, $t9, 1
	addiu $t6, $t6, 4
        j minimumi
        
endminimumi:
	jr $ra
	
