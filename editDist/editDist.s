.global _start
.equ wordsize, 4

.data
string1:
    .rept 100
        .byte 0
    .endr
string2:
    .rept 100
        .byte 0
    .endr
word1_length: .long 0
word2_length: .long 0
oldDist:
    .rept 100
        .long 0
    .endr
curDist:
    .rept 100
        .long 0
    .endr
oldptr: .long 0
curptr: .long 0

.text
min: # int min(int a, int b);
    push %ecx
    .equ a, 2*wordsize
    .equ b, 3*wordsize
    movl a(%esp), %ecx
    movl b(%esp), %eax
    cmpl %eax, %ecx 
    jl caseb
        jmp casea
    caseb:
        movl %ecx, %eax
    casea: 
        pop %ecx
        ret

_start:
# eax will have the string
# edx will have the length of the string
    movl $string1, %eax
    movl $0, %edx
    #int word1_len = strlen(word1);
    strlen1_start:
        movb (%eax), %bl
        cmpb $0, %bl 
        jz strlen1_end
        incl %edx
        incl %eax
        jmp strlen1_start
    strlen1_end:
        movl %edx, word1_length
    movl $string2, %eax
    movl $0, %edx
    #int word2_len = strlen(word2);
    strlen2_start:
        movb (%eax), %bl
        cmpb $0, %bl
        jz strlen2_end
        incl %edx
        incl %eax
        jmp strlen2_start 
    strlen2_end:
        movl %edx, word2_length

    #int* oldDist = (int*)malloc((word2_len + 1) * sizeof(int));
    movl $oldDist, %eax
    movl %eax, oldptr
    #int* curDist = (int*)malloc((word2_len + 1) * sizeof(int));
    movl $curDist, %eax
    movl %eax, curptr

    #int i,j,dist;
    movl $0, %edx # edx will hold i

    #for(i = 0; i < word2_len + 1; i++)
    initialize_distances_loop:
        # i < word2_len + 1
        # word2_len + 1 - i > 0
        cmpl %edx, word2_length   
        jb initialize_distances_end
        #oldDist[i] = i;
        movl %edx, oldDist(,%edx, wordsize)
        #curDist[i] = i;
        movl %edx, curDist(,%edx, wordsize)
        # i++
        incl %edx
        jmp initialize_distances_loop
    initialize_distances_end:

    # i = 1
    movl $1, %edi
    #for(i = 1; i < word1_len + 1; i++)
    outer_loop:
        # i < word1_len + 1
        # word1_len + 1 - i > 0
        cmpl %edi, word1_length  
        jb outer_loop_end
        #curDist[0] = i;
        movl (curptr), %edx
        movl %edi, (%edx)
        # j = 1;
        movl $1, %esi
        #for(j = 1; j < word2_len + 1; j++)
        inner_loop:
            # j < word2_len + 1
            # word2_len + 1 - j > 0
            cmpl %esi, word2_length  
            jb inner_loop_end
            #if(word1[i-1] == word2[j-1])
            if_start:
                movb (string1 - 1)(, %edi), %dl # dl = word1[i - 1]
                movb (string2 - 1)(, %esi), %al # al = word2[j - 1]
                cmpb %al, %dl
                jnz else_start
                movl (curptr), %edx
                movl (oldptr), %ebx
                movl ((-1)*wordsize)(%ebx, %esi, wordsize), %ecx
                movl %ecx, (%edx, %esi, wordsize)
                jmp if_end
            #else
            else_start:
            #curDist[j] = min(min(oldDist[j], //deletion
            #              curDist[j-1]), //insertion
            #              oldDist[j-1]) + 1;
                movl (curptr), %edx
                pushl ((-1)*wordsize)(%edx, %esi, wordsize)
                movl (oldptr), %edx
                pushl (%edx, %esi, wordsize)
                call min

                pushl %eax
                movl (oldptr), %edx
                pushl ((-1)*wordsize)(%edx, %esi, wordsize)
                call min
                incl %eax
                movl (curptr), %edx
                movl %eax, (%edx, %esi, wordsize)

            if_end:
                #j++
                incl %esi
                jmp inner_loop
        inner_loop_end:
        #swap(&oldDist, &curDist);
            push curptr
            push oldptr
            pop curptr
            pop oldptr
            #i++
            incl %edi
            jmp outer_loop

    outer_loop_end:
        #dist = oldDist[word2_len];
        movl word2_length  , %edi
        movl (oldptr), %edx
        movl (%edx, %edi, wordsize), %eax

done:
    movl %eax, %eax

