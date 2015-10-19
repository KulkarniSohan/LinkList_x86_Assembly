.section .rodata
msg_s1:
	.string "%d"
msg_p1:
	.string "\n\t Enter exsisting data : "
msg_p2:
	.string "--------------------------------------------------------------------------------------------------------------------------------\n"

.section .data
.globl arr
.type arr @ object
.size arr, 32
.align 4
arr:
	.long 10, 20, 30, 40, 50, 60, 70, 80



.section .text
.globl main
.type main @ function
.equ head, -4
.equ i, -8
.equ s_data, -12
.equ n_data, -16
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$32, %esp	
	movl	$0, i (%ebp)
	movl	$0, head (%ebp)
	jmp		mn_cond1
mn_for1:
	movl	arr (, %eax, 4), %eax
	leal	head (%ebp), %edx
	movl	%edx, 0(%esp)
	movl	%eax, 4(%esp)
	call	singly_insert_beg
	addl	$1, i (%ebp)
mn_cond1:
	movl	i(%ebp), %eax
	cmpl	$4, %eax
	jl		mn_for1
	movl	head (%ebp), %edx
	movl	%edx, 0(%esp)
	call	display
	movl	$4, i(%ebp)
	jmp		mn_cond2
mn_for2:
	movl	arr(, %eax, 4), %eax
	leal	head (%ebp), %edx
	movl	%edx, 0(%esp)
	movl	%eax, 4(%esp)
	call	singly_insert_end
	addl	$1, i (%ebp)
mn_cond2:
	movl	i(%ebp), %eax
	cmpl	$8, %eax
	jl		mn_for2
	
	movl	head (%ebp), %edx
	movl	%edx, 0(%esp)
	call	display


	movl	$msg_p1, 0(%esp)
	call	printf 

	leal	s_data (%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$msg_s1, 0(%esp)
	call	scanf
	
	movl	$100, n_data (%ebp)
	
	leal	head (%ebp), %edx
	movl	s_data (%ebp), %eax
	movl	n_data (%ebp), %ecx
	movl	%edx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, 8(%esp)
	call	singly_insert_after_data
	
	movl    head (%ebp), %edx
    movl    %edx, 0(%esp)
    call    display


	movl	$200, n_data (%ebp)
	
	movl	s_data (%ebp), %eax
	movl	n_data (%ebp), %ecx
	leal	head (%ebp), %edx
	movl	s_data (%ebp), %eax
	movl	n_data (%ebp), %ecx
	movl	%edx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, 8(%esp)
	call	singly_insert_before_data
	
	movl	head (%ebp), %edx
	movl	%edx, 0(%esp)
	call	display
	
	leal	head (%ebp), %eax
	movl	%eax, 0(%esp)
	call	singly_delete_end
	
	movl	head (%ebp), %edx
	movl	%edx, 0(%esp)
	call	display

	leal	head (%ebp), %eax
	movl	%eax, 0(%esp)
	call	singly_delete_beg 
	
	movl	head (%ebp), %eax
	movl	%eax, 0(%esp)
	call	display	
	
	movl    $msg_p1, 0(%esp)
    call    printf

    leal    s_data (%ebp), %eax
    movl    %eax, 4(%esp)
    movl    $msg_s1, 0(%esp)
    call    scanf
	
	movl	s_data (%ebp), %edx
	leal	head (%ebp), %eax
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	call	singly_delete_after_data
	
	movl	$msg_p2, 0(%esp)
	call	printf

	movl	head (%ebp), %eax
	movl	%eax, 0(%esp)
	call	display 

	movl	$msg_p2, 0(%esp)
	call	printf		

	movl	s_data (%ebp), %edx
	leal	head (%ebp), %eax
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	call	singly_delete_before_data

	movl	head (%ebp), %eax
	movl	%eax, 0(%esp)
	call	display
	
		
	
	movl	$0, (%esp)
	call	exit


