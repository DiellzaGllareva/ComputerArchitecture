
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
    #e ruajme v1 (dmth n) te adresa e n-it a1
    sw $v1, 0($a1)
    jal unazaKalimit
   populloVektorin:
   #Vendosja e vektorit ne regjistrin $s0
    move $s0, $a0
    #Vendosja e n ne regjistrin $s1
    move $s1, $a1
	# Printimi i tekstit1
	la $a0, teksti1
	li $v0, 4
	syscall
	
    #Marrja e inputit nga useri
        li $v0, 5
        syscall
	#Vendosja e n me nje regjister tjeter $s1
	move $s1, $v0
	# i eshte ne $s2
	# array  eshte ne $t0
	addi $s2, $zero, 1
	add $t0, $s0, $zero
	
	# shfaqja e tekstit
        la $a0, teksti2
        li $v0, 4
        syscall
	
for_loop:
#Kushti
	bgt $s2, $s1, end_loop
      #Marrja e inputit nga useri
        li $v0, 5
        syscall
        #Mbushja e vektorit
        sw $v0, ($t0)
        #Kalimi ne elementin tjeter
        addi $t0, $t0, 4
        #Inkremetimi
        addi $s2, $s2, 1
        j for_loop
end_loop:
 move $v1, $s1
#kthehemi ne main me return address ra
 j $ra    
unazaKalimit:
	la $a0, newline
	li $v0, 4
	syscall
    #Vektori eshte ne a0
	add $a0, $s0, $zero
    #a1 merr vleren 0
	li $a1, 0
    #n eshte ne a2
	add $a2, $s1, $zero
	jal sortimi

Inicializimi:
	# i eshte ne $s2
	# array[k]  eshte ne $t0 (si pointer)
	li $s2, 0
	add $t0, $s0, $zero
	
	la $a0, teksti3
	li $v0, 4
	syscall
	
Printimi:
        #Kushti
        bge $s2, $s1, fundi
        #Mbushja e vektorit
        lw $a0, ($t0)
        li $v0, 1
        syscall
        
        #Kalimi ne rreshtin tjeter
        la $a0, newline
        li $v0, 4
        syscall
        
        #Kalimi ne elementin e radhes
        addiu $t0, $t0, 4
        #Inkrementimi i i-se
        addi $s2, $s2, 1
        j Printimi
	
	#Mbyllja e programit pas printimit
fundi:
	li $v0, 10                                  
	syscall		

Shkembimi:
#t8 nkete rast eshte temporary value dmth temp-i
	lw $t8, ($a0)
	lw $t9, ($a1)
    #Shkembimi
	sw $t8, ($a1)
	sw $t9, ($a0)
	jr $ra

sortimi:
    # $s6 = n
	add $s6, $a2, $zero
    #$s7 = a[]
	add $s7, $a0, $zero
    # $t2 = n-1, 
	addi $t2, $a2, -1
    # $t0 = p
	add $t0, $zero, $zero
    #$t3 = a[p] pointer
	add $t3, $a0, $zero

SortLoop:
    #Kushti
	bge $t0, $t2, endSortLoop
    #Dergimi i a0 ne unazaVlerave dhe barazimi me min
	add $a0, $s7, $zero
    #Dergimi i a1 ne unazaVlerave dhe barazimi me loc
	add $a1, $t0, $zero
	jal unazaVlerave
#Dergimi i parametrave te shkembimi
	add $a0, $v0, $zero
	add $a1, $t3 , $zero
	jal Shkembimi
	# Inkrementi
	addi $t0, $t0, 1
	addiu $t3, $t3, 4
	j SortLoop

endSortLoop:
	j Inicializimi

unazaVlerave:
	# $t9 = k
	add $t9, $a1, $zero
    # $t7 = n
	add $t7, $a2, $zero
    # $t5 = min 
	mul $t5, $a1, 4 
    # $t6 = a[p] pointer
	add $t6, $a0, $t5
     # $t8 = a[p] 
	lw $t8, ($t6)
    # $v0 = min pointer
	add $v0, $t6, $zero
	lw $t5, ($v0)
	#Vendosja e p ne nje parameter tjeter
	move $t4, $t0
    #k=p+1
	addi $t9, $t4, 1
    #Kalimi ne elementin e radhes
	addiu $t6, $t6, 4
    #Deklarimi i loc
	move $t1, $a1
minimumi:
#Kushti
        bge $t9, $t7, endminimumi
        #a[p]=a[p]*
        lw $t8, ($t6)
        #Kushti if
	bge $t8, $t5, perfundo
    #Marrja e vleres a[p]*
	add $v0, $t6, $zero
    #min=a[p]
	lw $t5, ($v0)
    #loc=k
    move $t1,$t9
perfundo:
#k++
	addi $t9, $t9, 1
    #kalimi ne elementin e radhes
	addiu $t6, $t6, 4
        j minimumi
        
endminimumi:
	jr $ra
	
