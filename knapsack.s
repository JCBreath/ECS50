.globl knapsack
.equ ws, 4


.text
knapsack:
  #on entry stack looks like
  #esp + 20:cur_value
  #esp + 16:capacity
  #esp + 12:num_itmes
  #esp + 8:values
  #esp + 4:weights
  #esp: return address
  
  #prologue
  push %ebp
  movl %esp, %ebp
  
  #func vars
  .equ weights, ws
  .equ values, 2ws
  .equ num_items, 3ws
  .equ capacity, 4ws
  .equ cur_value, 5ws


  #esi will alternate between weight[i] and value[i]
  #edi will hold best_value
  #ecx will be i 
  #eax will be used for temp storage. no push because eax does not contain a live value
  #ebx will be used for temp storage
  push %esi
  push %ecx
  push %edi
  
  
  xorl %ecx, %ecx 				# i = 0. this is a quick way to set a register to 0
  movl 6*ws(%ebp), %edi			# best_value = cur_value
  # i < num_items
  # negation i - num_items >=0
  i_for:
    movl 4*ws(%ebp), %ebx			# num_items into ebx
    cmpl %ebx, %ecx 				# (i - num_items)
    jae end_i_for				# if (i - num_items) >= 0
	if: 
	    movl 2*ws(%ebp), %esi 	# put *weights into %esi
	    movl (%esi, %ecx, ws), %esi   # put weights[i] into %esi
	    movl 5*ws(%ebp), %ebx 	# capacity
	    cmpl %esi, %ebx			# (capacity - weights[i])
            jl if_end
	    # inside if
	    # prepare for recursive call

	    # cur_value + values[i]
	    movl 3*ws(%ebp), %esi 	# put *values into %esi
	    movl (%esi, %ecx, ws), %esi 	# put values[i] into %esi
            movl 6*ws(%ebp), %eax 	# put cur_value in %eax
	    addl %esi, %eax 			# values[i] + cur_value into %eax
            push %eax

	    # capacity - weight[i]
	    movl 2*ws(%ebp), %esi 	# put *weights int %esi
	    movl (%esi, %ecx, ws), %esi 	# put weights[i] into %esi
	    movl 5*ws(%ebp), %ebx 	# put capacity into %ebx
	    subl %esi, %ebx			# capacity - weights[i]
	    movl %ebx, %eax
	    push %eax

	    # num_items - i - 1
	    movl 4*ws(%ebp), %ebx 	# put num_items into %ebx
	    decl %ebx				# num_items - 1
	    subl %ecx, %ebx			# num_items - 1 - i
	    movl %ebx, %eax 
	    push %eax

	    # values + i + 1
	    movl 3*ws(%ebp), %eax 	# put *values into %esi
	    leal ws(%eax,%ecx,ws), %eax	# values+i+1
	    push %eax

	    # weights + i + 1
	    movl 2*ws(%ebp), %eax 	# put *weight into %eax
	    leal ws(%eax,%ecx,ws), %eax	# weights+i+1
	    push %eax

	    call knapsack

	    #clear arguments off of the stack
	    addl $(5*ws), %esp
	    
	    cmpl %eax, %edi			# best_value - knapsack
	    jb result				# knapsack > best_value
	    jmp if_end	 			# because %edi remains the same   
	    
	    result:
		movl %eax, %edi			# update best value 
	    
         if_end: 
	    incl %ecx 				# i++
	    jmp i_for
  end_i_for:
      
  #put the return value in eax
  movl %edi, %eax
  
  #restore registers
  pop %edi
  pop %ecx
  pop %esi
  
  
  #epilogue
  movl %ebp, %esp
  pop %ebp
  ret
