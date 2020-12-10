	    .data
str_sp:   .asciiz " "
str_new:  .asciiz "Integer to store "
str_srch: .asciiz "Search for integer "
str_nl:   .asciiz "\n"
	  
	.text
	.globl main
main:
	jal node_alloc	#allocate mem
	add $s0, $0, $2	#head points to first node
	add $s1, $0, $2	#tail points to first node
	sw  $0, 0($s0)	#head->data=0
	sw  $0, 4($s0)	#head->next=0
first:
	addi $v0, $0, 4	
	la   $a0, str_new	
	syscall
	jal  read_int	
	slt $t0, $0, $v0	
	beq $t0, $0, second 
	add $s2, $0, $v0	#$s2 has the new data
	jal node_alloc	#allocate mem for a new node
	sw  $s2, 0($v0) 	#newnode->data=data
	sw  $0,  4($v0)	#newnode->next=0
	sw  $v0, 4($s1)	#tail->next=newnode
	add $s1, $0, $v0	#tail=newnode
	j first
second:
	addi $v0, $0, 4
	la   $a0, str_nl
	syscall
	la   $a0, str_srch
	syscall
	jal read_int	#read integer to begin search
	add $s1, $0, $v0
	slt $t0, $0, $s1
	beq $t0, $0, main
	add $a0, $0, $s0	#1st argument for search list (head of list)
	add $a1, $0, $s1	#2nd argument for search list (data to search)
	jal search_list
	j second

node_alloc:
	addi $sp, $sp, -4 #allocate 4 bytes on stack because of syscall
	sw   $ra, 0($sp)	#save return adress
	addi $a0, $0, 8
	addi $v0, $0, 9
	syscall
	lw   $ra, 0($sp)	
	addi $sp, $sp, 4	#deallocate 4 bytes of the stack
	jr   $ra

read_int:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	addi $v0, $0, 5
	syscall
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra

search_list:
	addi $sp, $sp, -4 #allocate 4 bytes on stack because of print_node
	sw   $ra, 0($sp)
	add  $s1, $0, $a1	#$s1=data
	add  $s2, $0, $a0	#$s2=head
	lw   $s2, 4($s2)  #head=head->next (because of "dummy")
start:
	beq  $s2, $0, end	#if[head==0(null)] ends
	add  $a0, $0, $s2 #1st arg of print_node (address of node)
	add  $a1, $0, $s1 #2nd arg of print_node (data)
	jal print_node	
	lw   $s2, 4($s2)  #head=head->next (go to the next node)
	j start
end:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra

print_node:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	lw   $t0, 0($a0)	 #$t0=node->data
	slt  $t1, $t0, $a1 #if(node->data<data) print node->data else return
	beq  $t1, $0, exit 
	add  $a0, $0, $t0
	addi $v0, $0, 1
	syscall
	la   $a0, str_sp
	addi $v0, $0, 4
	syscall
exit:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
	




