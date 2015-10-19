.equ	SIZE_PER_NODE,		8
.equ	node_next,			4
.equ	node_data,			0


.section .rodata
msg_d1:
	.string "\n[start] -> "
msg_d2:
	.string " [%d] -> "
msg_d3:
	.string "[end]\n"
msg_p1:
	.string "\n\txcalloc : fatal : out of memory\n"
sibd_err1:
	.string "\n\t Data not found\n"
siad_err1:
	.string "\n\t Data not found\n"
msg_check:
	.string "\n\t prev-> data : %d\n"


.section .text
.globl singly_insert_beg
.type singly_insert_beg @ function
.equ pp_head, 8
.equ data, 12
.equ newnode, -4
.equ temp, -8
singly_insert_beg:
	pushl	%ebp	
	movl	%esp, %ebp
	subl	$32, %esp
	movl	data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	get_node
	movl	%eax, newnode (%ebp)
	jmp		sib_cond1
sib_else:
	movl	pp_head (%ebp), %eax
	movl	newnode (%ebp), %edx
	movl	(%eax), %eax
	movl	%eax, node_next (%edx) 
	movl	pp_head (%ebp), %eax
	movl	newnode (%ebp), %edx
	movl	%edx, (%eax)
	jmp		sib_out_s
sib_cond1:
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	jne		sib_else
	movl	newnode (%ebp), %edx
	movl	%edx, (%eax)
sib_out_s:	
	movl	%ebp, %esp
	popl	%ebp	
	ret



.section .text 
.globl singly_insert_end
.type singly_insert_end @ function
.equ pp_head, 8
.equ data, 12
.equ newnode, -4
.equ temp, -8
singly_insert_end :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	get_node
	movl	%eax, newnode (%ebp)
	jmp		app_cond1
app_else:
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, temp(%ebp)
	jmp		app_cond2
	app_while:
		movl	temp (%ebp), %eax
		movl	node_next (%eax), %eax
		movl	%eax, temp (%ebp)
	app_cond2:
		movl	temp (%ebp), %eax
		cmpl	$0, node_next (%eax)
		jne		app_while
	
	movl	temp(%ebp), %eax
	movl	newnode (%ebp), %edx
	movl	%edx, node_next (%eax)
	jmp		app_out
app_cond1:
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	jne		app_else
app_if:
	movl	newnode (%ebp), %edx
	movl	pp_head (%ebp), %eax
	movl	%edx, (%eax)
app_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl singly_insert_after_data
.type singly_insert_after_data @ function
.equ pp_head, 8
.equ data, 12
.equ n_data, 16
.equ newnode, -4
.equ temp, -8
.equ prev, -12
singly_insert_after_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	n_data ( %ebp), %eax
	movl	%eax, 0(%esp)
	call	get_node
	movl	%eax, newnode (%ebp)
	movl	$0, prev (%ebp)
	leal	prev (%ebp), %ecx
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	data (%ebp), %edx
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, 8(%esp)
	call	search_node
	cmpl	$0, %eax
	je		siaf_out_f
	movl	%eax, temp (%ebp)
	movl	temp (%ebp), %eax	
	movl	node_next (%eax), %eax
	movl	newnode (%ebp), %edx
	movl	%eax, node_next (%edx)	
	movl	temp (%ebp), %eax
	movl	%edx, node_next (%eax)
	jmp		siaf_out_s
siaf_out_f:
	movl	$siad_err1, 0(%esp)
	call	printf
siaf_out_s:
	movl	%ebp, %esp
	popl	%ebp	
	ret


.section .text
.globl singly_insert_before_data
.type singly_insert_before_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ n_data, 16
.equ newnode, -4
.equ temp, -8
.equ prev, -12
singly_insert_before_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, temp (%ebp)
	movl	$0, prev (%ebp)
	movl	n_data (%ebp), %edx
	movl	%edx, 0(%esp)
	call	get_node 
	movl	%eax, newnode (%ebp)
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	leal	prev (%ebp), %edx
	movl	e_data (%ebp), %ecx
	movl	%eax, 0(%esp)
	movl	%ecx, 4(%esp)
	movl	%edx, 8(%esp)
	call	search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, temp (%ebp)
	je		sibd_else
sibd_if:
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, prev (%ebp)
	jne		sibd_if_else
	sibd_if_1:
		movl	pp_head ( %ebp), %eax
		movl	(%eax), %eax
		movl	newnode (%ebp), %edx
		movl	%eax, node_next (%edx)
		movl	pp_head (%ebp), %eax
		movl	newnode (%ebp), %edx
		movl	%edx, (%eax)
		jmp		sibd_out
	sibd_if_else:
		movl	temp (%ebp), %eax
		movl	newnode (%ebp), %edx
		movl	%eax, node_next (%edx)
		movl	newnode ( %ebp), %eax
		movl	prev (%ebp), %edx
		movl	%eax, node_next (%edx)
		jmp		sibd_out
sibd_else:
	movl	$sibd_err1, 0(%esp)
	call	printf
sibd_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.section .text
.globl singly_delete_before_data
.type singly_delete_before_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ temp, -4
.equ prev, -8
singly_delete_before_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, temp (%ebp)
	movl	$0, prev (%ebp)
	
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	e_data (%ebp), %edx
	leal	prev (%ebp), %ecx
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, 8(%esp)
	call	search_node
	movl	%eax, temp (%ebp)

	cmpl	$0, %eax
	je		sdbd_out_f
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, prev (%ebp)
	jne		sdbd_else
sdbd_if:
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	movl	pp_head (%ebp), %edx
	movl	%eax, (%edx)
	jmp		free_data
sdbd_else:
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	movl	prev (%ebp), %edx
	movl	%eax, node_next (%edx)
free_data:
	movl	temp (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free
	jmp		sdbd_out
sdbd_out_f:
	movl	$sibd_err1, 0(%esp)
	call	printf
sdbd_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text 
.globl singly_delete_after_data
.type singly_delete_after_data @ function
.equ pp_head, 8
.equ data, 12
.equ temp, -4
.equ forward, -8
singly_delete_after_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, temp (%ebp)
	movl	$0, forward (%ebp)
	movl	data (%ebp), %edx
	movl	pp_head (%ebp), %eax
	leal	forward (%ebp), %ecx
	movl	(%eax), %eax
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, 8(%esp)
	call	search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, temp (%ebp)
	je		sdad_out_f
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	movl	%eax, forward (%ebp)
	movl	forward (%ebp), %eax
	cmpl	$0, %eax
	je		sdad_out
	movl	node_next (%eax), %eax
	movl	temp (%ebp), %edx
	movl	%eax, node_next (%edx)
	movl	forward (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free 
	jmp		sdad_out
sdad_out_f:
	movl	$sibd_err1, 0(%esp)
	call	printf
sdad_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text 
.globl singly_delete_beg
.type singly_delete_beg @ function
.equ pp_head, 8
.equ temp, -4
singly_delete_beg :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	je		sdb_out_f
	movl	(%eax), %eax
	movl	%eax, temp (%ebp)
	movl	pp_head (%ebp), %eax
	movl	temp (%ebp), %edx
	movl	node_next (%edx), %edx
	movl	%edx, (%eax)
	movl	temp (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free
sdb_out_f:
	movl	%ebp, %esp
	popl	%ebp	
	ret


.section .text
.globl singly_delete_end
.type singly_delete_end @ function
.equ pp_head, 8
.equ temp, -4 
.equ prev, -8
singly_delete_end :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	je		sde_out_f
	movl	(%eax), %eax
	movl	%eax, temp (%ebp)
	movl	%eax, prev (%ebp)
	jmp		sde_cond1
sde_while:
	movl	temp (%ebp), %eax
	movl	%eax, prev (%ebp)
	movl	node_next (%eax), %eax
	movl	%eax, temp (%ebp)
sde_cond1:
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	cmpl	$0, %eax
	jne		sde_while
	movl	pp_head ( %ebp), %eax
	movl	prev (%ebp), %edx
	cmpl	(%eax), %edx
	jne		sde_else
sde_if:
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	movl	pp_head (%ebp), %edx
	movl	%eax, (%edx)
	jmp		sde_out
sde_else:
	movl	temp ( %ebp), %eax
	movl	prev (%ebp), %edx
	movl	node_next (%eax), %eax
	movl	%eax, node_next ( %edx)
sde_out:
	movl	temp (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free
sde_out_f:
	movl	%ebp, %esp
	popl	%ebp
	ret


.section .text
.globl display
.type display @ function
.equ head, 8
.equ temp, -4
display:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	head (%ebp), %eax
	movl	%eax, temp (%ebp)
	movl	$msg_d1, 0(%esp)
	call	printf
	jmp		d_cond1
d_while:
	movl	temp (%ebp), %eax
	movl	node_data (%eax), %eax
	movl	$msg_d2, 0(%esp)
	movl	%eax, 4(%esp)
	call	printf	
	movl	temp (%ebp), %eax
	movl	node_next (%eax), %eax
	movl	%eax, temp (%ebp)
d_cond1:
	movl	temp (%ebp), %eax
	cmpl	$0, %eax
	jne		d_while
	movl	$msg_d3, 0(%esp)
	call	printf
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl searh_node
.type search_node @ function
.equ head, 8
.equ data, 12
.equ pp_prev, 16
.equ temp, -4
search_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	pp_prev (%ebp), %ecx
	movl	head (%ebp), %eax
	movl	%eax, (%ecx)
	movl	head (%ebp), %eax
	movl	%eax, temp (%ebp)
	jmp		sn_cond1
sn_while:
	#prev = temp
	movl	pp_prev (%ebp), %ecx
	movl	temp (%ebp), %eax
	movl	%eax, (%ecx)
	movl	node_next (%eax), %eax
	movl	%eax, temp (%ebp)
	jmp		sn_cond1
sn_while_cond2:
	movl	temp (%ebp), %eax
	movl	node_data ( %eax ), %eax
	cmpl	data (%ebp), %eax
	jne		sn_while
	jmp		sn_while_out_s
sn_cond1:
	cmpl	$0, temp (%ebp)
	jne		sn_while_cond2
	movl	temp (%ebp), %eax
	cmpl	$0, %eax
	je		sn_while_out_f
sn_while_out_s:
	movl	temp (%ebp), %eax
	jmp		sn_out
sn_while_out_f:
	movl	$0, %eax
sn_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl get_node
.type get_node @ function
.equ data, 8
.equ newnode, -4
get_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$1, 0(%esp)
	movl	$SIZE_PER_NODE, 4(%esp)
	call	xcalloc
	movl	%eax, newnode (%ebp)
	movl	data (%ebp), %ebx
	movl	%ebx, node_data (%eax)
	movl	$0, node_next (%eax)
	movl	newnode (%ebp), %eax
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl xcalloc
.type xcalloc @ function
.equ no_of_elements,  8
.equ size_per_element, 12
.equ ptr, -4
xcalloc:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	no_of_elements (%ebp), %eax
	movl	size_per_element (%ebp), %ebx
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	call	calloc
	cmpl	$0, %eax
	je		xc_out_f
	movl	%eax, ptr (%ebp)
	jmp		xc_out_s	
xc_out_f:
	movl	$msg_p1, 0(%esp)
	call	printf
	movl	$0, 0(%esp)
	call	exit
xc_out_s:	
	movl	%ebp, %esp
	popl	%ebp
	ret

