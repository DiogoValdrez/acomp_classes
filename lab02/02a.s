	.data

a: 	.word 1
b: 	.word 1
c:  .word 1

	.text
main:
	lw a2, a
	lw a3, b
	lw a4, c

	addi sp, sp, -16
	sw a2, 8(sp) #a
	sw a3, 4(sp) #b
	sw a4, 0(sp) #c
	jal rede_neuronal_xor
	lw a5, 0(sp)
	lw a4, 4(sp)
	lw a3, 8(sp)
	lw a2, 12(sp)
	addi sp, sp, 20


	addi sp, sp, -20
	sw a3, 0(sp) #xor(a,b)
	sw a4, 4(sp) #c
	sw a5, 8(sp) #b
	jal rede_neuronal_xor
	lw a6, 0(sp) #xor(xor(a,b),c)
	sw a3, 4(sp) #xor(a,b)
	lw a4, 8(sp) #b
	addi sp, sp, 24

	mv a2, a6 
	mv a3, a6
	li a4, -1	
	li a5, -1
	li a6, 1
	jal neuronio	

	li x17,1
	ecall
	li x17,10
	ecall

rede_neuronal_xor:

	sw ra, 12(sp) #salvaguarda

	lw a2, 8(sp) #x1
	lw a3, 4(sp) #x2
	li a4, 2 #w1
	li a5, -2 #w2
	li a6, -1	
	jal neuronio
	
	mv s2, a0
	li a5, 2 #w2
	li a4, -2 #w1
	jal neuronio

	mv a2, s2 #x1
	mv a3, a0 #x2
	li a4, 2 #w1
	jal neuronio
		
	addi sp, sp, -4
	sw a0, 0(sp)
	lw ra, 16(sp)

	jalr x0,x1,0
neuronio:
	addi sp, sp, -28 #salvaguarda
	sw ra, 24(sp)
	sw a2, 20(sp) #x1
	sw a3, 16(sp)
	sw a4, 12(sp) #w1
	sw a5, 8(sp)
	sw a6, 4(sp)
	sw s2, 0(sp)	
	jal multiplica
	lw a7, 0(sp) #resultado
	sw s2, 4(sp)
	lw a6, 8(sp)
	lw a5, 12(sp)
	lw a4, 16(sp)
	lw a3, 20(sp)
	lw a2, 24(sp)
	lw ra, 28(sp)
	addi sp, sp, 32
	
	addi sp, sp, -32 #salvaguarda
	sw ra, 28(sp)
	sw a2, 24(sp) 
	sw a3, 20(sp) #x2
	sw a4, 16(sp) 
	sw a5, 12(sp) #w2
	sw a6, 8(sp)
	sw s2, 4(sp)
	sw a7, 0(sp) 
	jal multiplica
	lw t6, 0(sp) #segundo resultado
	lw a7, 4(sp)
	sw s2, 8(sp)
	lw a6, 12(sp)
	lw a5, 16(sp)
	lw a4, 20(sp)
	lw a3, 24(sp)
	lw a2, 28(sp)
	lw ra, 32(sp)
	addi sp, sp, 36
	
	add t0, t6, a7
	add t0, t0, a6
	blt t0, zero, else #if/else presente no codigo em c
	li a0, 1
	jalr x0,x1,0 
else:
	li a0, 0
	jalr x0,x1,0
	
multiplica:
	lw t0, 20(sp) #x
	lw t1, 12(sp) #w
	li t2, 0
	li t3, 0 #flag
	
	bge t1, zero, continue #verificação do sinal da multiplicação
	neg t1, t1
	li t3, 1
	
continue:
	add t2, t2, t0
	addi t1, t1, -1
	bgt t1, zero, continue #loop para fazer a multiplicação
	ble t3, zero, end #verificação do sinal da multiplicação
	neg t2, t2
end:
	addi sp, sp, -4 #add do resultado á pilha
	sw t2, 0(sp)
	jalr x0,x1,0