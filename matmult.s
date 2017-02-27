# by Siyuan Yao

.global matMult

.equ ws, 4

.text
matMult:
	push %ebp
	movl %esp, %ebp

	# func vars
	.equ a, 2*ws			# ebx, edx holds a,b
	.equ num_rows_a, 3*ws
	.equ num_cols_a, 4*ws
	.equ b, 5*ws
	.equ num_rows_b, 6*ws
	.equ num_cols_b, 7*ws

	subl $4*ws, %esp 		# stack for locals

	# local vars
	.equ i, -1*ws			# ecx holds i,j,k
	.equ j, -2*ws
	.equ k, -3*ws
	.equ sum, -4*ws			# edi holds sum

	# malloc
  	movl num_rows_a(%ebp), %eax
  	imull $4, %eax		# size = 4
  	push %eax
  	call malloc
  	movl %eax, %esi		# esi holds return value
  	addl $ws, %esp		# remove malloc arg

  	movl $0, i(%ebp)					# i = 0

  	for_i_start:
  		movl i(%ebp), %ecx
  		cmpl num_rows_a(%ebp), %ecx		# i < row_a
  		jge for_i_end
  		
  		# malloc
  		movl num_cols_b(%ebp), %eax
  		imull $4, %eax	# size = 4
  		push %eax
  		call malloc
  		addl $ws, %esp
  		
  		movl i(%ebp), %ecx
		movl %eax, (%esi, %ecx, ws)		# result[i] = malloc

  		movl $0, j(%ebp)				# j = 0

  		for_j_start:
  			movl j(%ebp), %ecx
  			cmpl num_cols_b(%ebp), %ecx	# j < col_b
  			jge for_j_end

  			movl $0, sum(%ebp)			# sum = 0

  			movl $0, k(%ebp)			# k = 0

  			for_k_start:
  				movl k(%ebp), %ecx
  				cmpl num_cols_a(%ebp), %ecx	# k < col_a
  				jge for_k_end

  				movl a(%ebp), %ebx
  				movl i(%ebp), %ecx
  				movl (%ebx, %ecx, ws), %ebx		# a[i]
  				movl k(%ebp), %ecx
  				movl (%ebx, %ecx, ws), %edx		# a[i][k]

  				movl b(%ebp), %ebx
  				movl (%ebx, %ecx, ws), %ebx		# b[k]
  				movl j(%ebp), %ecx
  				movl (%ebx, %ecx, ws), %ebx		# b[k][j]

  				imull %edx, %ebx				# sum = a[i][k]*b[k][j]

  				addl %ebx, sum(%ebp)

  				incl k(%ebp)			# k++

  				jmp for_k_start

  			for_k_end:

  			movl i(%ebp), %ecx
  			movl (%esi, %ecx, ws), %eax
  			movl j(%ebp), %ecx
  			movl sum(%ebp), %edi
  			movl %edi, (%eax, %ecx, ws)	# result[i][j] = sum

  			incl j(%ebp)				# j++
  			jmp for_j_start

  		for_j_end:

  		incl i(%ebp)					# i++
  		jmp for_i_start

  	for_i_end:

  	movl %esi, %eax

  	movl %ebp, %esp
  	pop %ebp

  	ret

