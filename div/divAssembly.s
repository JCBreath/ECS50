# Author: Siyuan Yao

.global _start

.data

dividend:
	.long 0

divisor:
	.long 0

.text

_start:
	movl $0, %eax			# eax = quotient
	movl $0, %edx			# edx = remainder
	movl $31, %ecx			# ecx = i = 31
	movl $1, %esi			# bit

	for_loop_start:				# for(int i = 31; i >= 0; i--)
		cmpl $0, %ecx			# i >= 0
			jl for_loop_end		

		shll $1, %edx			# remainder = remainder << 1; 

		if_start1:			# if(dividend & (1<<i)) 
			movl $1, %esi
			shll %cl, %esi		# (1<<i)
			andl dividend, %esi 	# dividend & (1<<i)
			cmpl $0, %esi		# if()
				je if_end1
			addl $1, %edx		# remainder++;
		if_end1:

		if_start2:			# if(remainder >= divisor)
			movl divisor, %ebx
			cmpl %ebx, %edx		# remainder >= divisor
				jl if_end2	# remainder < divisor
			subl divisor, %edx	# remainder -= divisor;
			movl $1, %esi		# 1
			shll %cl, %esi		# 1<<i
			orl %esi, %eax		# quotient |= (1<<i);
		if_end2:

		decl %ecx			# i--

		jmp for_loop_start		# for

	for_loop_end:

done:
	movl %eax, %eax
