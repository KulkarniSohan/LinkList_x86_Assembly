.equ	SIZE_PER_NODE, 12
.equ	NODE_DATA, 0
.equ	NODE_NEXT, 4
.equ	NODE_PREV, 8


.section .rodata
msg_d1:
	.string "\n\n[start]-> "
msg_d2:
	.string "[%d] -> "
msg_d3:
	.string "[end] \n\n"
msg_err1:
	.string "\n\t xcalloc : fatal : out of memory\n"
msg_err2:
	.string "\n\t Data not found\n"

.section .text
.globl doubly_insert_end
.type doubly_insert_end @ function
.equ pp_head, 8
.equ data, 12
.equ newnode, -4
.equ temp, -8
doubly_insert_end :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	doubly_get_node
	movl	%eax, newnode (%ebp)
	die_if:
		movl	pp_head (%ebp), %eax
		cmpl	$0, (%eax)
		jne		die_else
		movl	newnode (%ebp), %edx
		movl	%edx, (%eax)
		jmp		die_out
	die_else:
		movl	pp_head (%ebp), %edx
		movl	(%edx), %edx
		movl	%edx, temp (%ebp)
		jmp		die_while_cond
		die_while:
			movl	temp (%ebp), %eax
			movl	NODE_NEXT (%eax), %eax
			movl	%eax, temp (%ebp)
		die_while_cond :
			movl	temp (%ebp), %eax
			movl	NODE_NEXT (%eax), %eax
			cmpl	$0, %eax
			jne		die_while
		# temp->next = newnode;
		movl	newnode (%ebp), %eax
		movl	temp (%ebp), %edx
		movl	%eax, NODE_NEXT (%edx)
		#newnode->prev = temp;
		movl	temp (%ebp), %eax
		movl	newnode (%ebp), %edx
		movl	%eax, NODE_PREV (%edx)	
die_out:
	movl	%ebp, %esp
	popl	%ebp
	ret
#void insert_beg ( struct node **head, int data )
#{
#	struct node *newnode;
#	newnode = get_node ( data );
#	if ( *head == NULL)
#	{
#		*head = newnode;
#	}
#	else
#	{
#		struct node *temp = *head;
#		newnode->next = temp;
#		temp->prev = newnode;
#		*head = newnode;
#	}
#}
.section .text
.globl doubly_insert_beg
.type doubly_insert_beg @ function
.equ pp_head, 8
.equ data, 12
.equ newnode, -4
.equ temp, -8
doubly_insert_beg :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	doubly_get_node
	movl	%eax, newnode (%ebp)
	dib_if:
		movl	pp_head (%ebp), %eax
		cmpl	$0, (%eax)
		jne		dib_else
		movl	newnode (%ebp), %edx
		movl	%edx, (%eax)
		jmp		dib_out
	dib_else:
		movl	pp_head (%ebp), %eax
		movl	(%eax), %eax
		movl	%eax, temp (%ebp)
		#newnode->next = temp;
		movl	temp (%ebp), %eax
		movl	newnode (%ebp), %edx
		movl	%eax, NODE_NEXT (%edx)
		#temp->prev = newnode;
		movl	 newnode (%ebp), %eax
		movl	temp (%ebp), %edx
		movl	%eax, NODE_PREV (%edx)
		# *head = newnode;
		movl	pp_head (%ebp), %eax
		movl	newnode (%ebp), %edx
		movl	%edx, (%eax)
dib_out:
	movl	%ebp, %esp
	popl	%ebp
	ret
#void insert_after_data (struct node **head, int e_data, int n_data)
#{
#	struct node *newnode, *temp;
#	newnode = get_node (n_data);
#	temp = search_node ( (*head), e_data);
#	if ( temp != NULL)
#	{
#		forward = temp->next;
#		newnode->next = forward;
#		newnode->prev = temp;
#		temp->next = newnode;
#		if ( forward != NULL)
#		{
#			forward->prev = newnode;
#		}
#	}
#}
#struct node * search_node ( struct node *head, int e_data)
#{
#	struct node *temp = head;
#	while ( temp != NULL && temp->data != e_data)
#	{
#		temp = temp->next;
#	}
#	
#	if ( temp == NULL)
#	{
#		return NULL;
#	}
#	else
#	{
#		return temp;
#	}
#}
.section .text
.globl doubly_search_node
.type doubly_search_node @ function
.equ head, 8
.equ e_data, 12
.equ temp, -4
doubly_search_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	head (%ebp), %eax
	movl	%eax, temp (%ebp)
	jmp		dsn_while_cond
	dsn_while:
		movl	temp (%ebp), %eax
		movl	NODE_DATA (%eax), %eax
		cmpl	e_data (%ebp), %eax
		je		dsn_if_cond2
		movl	temp (%ebp), %eax
		movl	NODE_NEXT (%eax), %eax
		movl	%eax, temp (%ebp)
	dsn_while_cond:
		movl	temp (%ebp), %eax
		cmpl	$0, %eax
		jne		dsn_while
	dsn_if_cond2:
		movl	temp (%ebp), %eax
		cmpl	$0, %eax
		jne		dsn_else_cond2
		movl	$0, %eax
		jmp		dsn_out
	dsn_else_cond2:
		movl	temp (%ebp), %eax
dsn_out:	
	movl	%ebp, %esp
	popl	%ebp
	ret
#void delete_before_data ( struct node **head, int e_data)
#{
#	struct node *temp, *prev = *head, *pp_prev;
#	temp = search_node ( (*head), e_data);
#	if ( temp != NULL)
#	{
#
#		if ( temp == *head)
#		{
#			return
#		}
#		else
#		{
#			prev->prev = pp_prev;
#			temp->prev = pp_prev;
#			if ( pp_prev != NULL)
#			{
#				pp_prev->next = temp;
#			}
#			free ( prev );
#		}
#	}
#}
.section .text
.globl doubly_delete_before_data
.type doubly_delete_before_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ temp, -4
.equ prev, -8
.equ pp_prev, -12
doubly_delete_before_data :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp

	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, prev (%ebp)

	movl	e_data (%ebp), %edx
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	call	doubly_search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, %eax
	je		ddbd_out_f
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, temp (%ebp)
	jne		ddbd_else
	ddbd_if:
		jmp		ddbd_out
	ddbd_else:
		#prev->prev = pp_prev;
		movl	prev (%ebp), %eax
		movl	NODE_PREV (%eax),%eax
		movl	%eax, pp_prev (%ebp)
		# temp->prev = pp_prev
		movl	pp_prev (%ebp), %eax
		movl	temp (%ebp), %edx
		movl	%eax, NODE_PREV (%edx)
		cmpl	$0, %eax
		je		ddbd_init1
		#pp_prev->next = temp;
		movl	temp (%ebp), %eax
		movl	pp_prev (%ebp), %edx
		movl	%eax, NODE_NEXT (%edx)
		jmp		ddbd_free
	ddbd_init1:
		# *head = temp;
		movl	temp (%ebp), %eax
		movl	pp_head (%ebp), %edx
		movl	%eax, (%edx)
	ddbd_free:
		movl	prev (%ebp), %eax
		movl	%eax, 0(%esp)
		call	free 
		jmp		ddbd_out
	ddbd_out_f:
		movl	$msg_err2, 0(%esp)
		call	printf
ddbd_out:	
	movl	%ebp, %esp
	popl	%ebp
	ret
#void delete_after_data ( struct node **head, int e_data)
#{
#	struct node *temp, *forward, ff_forward;
#	temp = search_node ( (*head), e_data);
#	if ( temp != NULL)
#	{
#		forward = temp->next;
#		if ( forward != NULL)
#		{
#			ff_forward = forward->next;
#			temp->next = ff_forward;
#			if ( ff_forward != NULL)
#			{
#				ff_forward->prev = temp;
#			}
#			free (forward);
#		}
#	}
#}
.section .text
.globl doubly_delete_after_data
.type doubly_delete_after_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ temp, -4
.equ forward, -8
.equ ff_forward, -12
doubly_delete_after_data :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	e_data (%ebp), %edx
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	call	doubly_search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, %eax
	je		ddad_out_f
	
	movl	temp (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, forward (%ebp)
	
	movl	forward (%ebp), %eax
	cmpl	$0, %eax
	je		ddad_out
	
	movl	forward (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, ff_forward (%ebp)
	
	#temp->next = ff_forward;
	movl	ff_forward (%ebp), %eax
	movl	temp (%ebp), %edx
	movl	%eax, NODE_NEXT (%edx)
	cmpl	$0, %eax
	je		ddad_free
	movl	ff_forward (%ebp), %eax
	movl	temp (%ebp), %edx
	movl	%edx, NODE_PREV (%eax)
	ddad_free:
		movl	forward (%ebp), %eax
		movl	%eax, 0(%esp)
		call	free 
		jmp		ddad_out
	ddad_out_f:
		movl	$msg_err2, 0(%esp)
		call	printf
ddad_out:
	movl	%ebp, %esp
	popl	%ebp
	ret
#void insert_before_data ( struct node **head, int e_data, int n_data )
#{
#	struct node *newnode, *temp, *prev;
#	newnode = get_node (n_data);
#	temp = search_node ((*head), e_data);
#	if (temp != NULL)
#	{
#		if ( temp->prev != NULL)
#		{
#			prev = temp->prev;
#		}
#		newnode->next = temp;
#		temp->prev = newnode;
#		if ( prev == *head)
#		{
#			newnode->prev = NULL;
#			*head = newnode;
#		}
#		else
#		{
#			newnode->prev = prev;
#			prev->next = newnode;
#		}
#	}
#}
.section .text
.globl doubly_insert_before_data
.type doubly_insert_before_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ n_data, 16
.equ newnode, -4
.equ temp, -8
.equ prev, -12
doubly_insert_before_data :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, prev (%ebp)
	movl	n_data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	doubly_get_node
	movl	%eax, newnode (%ebp)
	movl	NODE_DATA (%eax), %ebx
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	e_data (%ebp), %edx
	movl	%eax, 0(%esp)
	movl	%edx, 4(%esp)
	call	doubly_search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, %eax
	je		dibd_out_f
	# if ( temp->prev != NULL)
	movl	temp (%ebp), %eax
	cmpl	$0, NODE_PREV (%eax)
	je		dibd_init1		
	#prev = temp->prev
	movl	temp (%ebp), %eax
	movl	NODE_PREV (%eax), %eax
	movl	%eax, prev (%ebp)
dibd_init1:
	# newnode->next = temp;
	movl	temp (%ebp), %eax
	movl	newnode (%ebp), %edx
	movl	%eax, NODE_NEXT (%edx)
	# temp->prev = newnode;
	movl	newnode (%ebp), %eax
	movl	temp (%ebp), %edx
	movl	%eax, NODE_PREV (%edx)
	movl	prev (%ebp), %eax
	movl	pp_head (%ebp), %edx
	cmpl	(%edx), %eax
	jne		dibd_else
	dibd_if:
		movl	newnode (%ebp), %eax
		movl	pp_head (%ebp), %edx
		movl	%eax, (%edx)	
		jmp		dibd_out
	dibd_else:
		# newnode -> prev = prev
		movl	prev (%ebp), %edx
		movl	newnode (%ebp), %eax
		movl	%edx, NODE_PREV (%eax)
		#prev->next = newnode;
		movl	newnode (%ebp), %edx
		movl	prev (%ebp), %eax
		movl	%edx, NODE_NEXT (%eax)
		jmp		dibd_out
	dibd_out_f:
		movl	$msg_err2, 0(%esp)
		call	printf
dibd_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl doubly_insert_after_data 
.type doubly_insert_after_data @ function
.equ pp_head, 8
.equ e_data, 12
.equ n_data, 16
.equ newnode, -4
.equ temp, -8
.equ forward, -12
doubly_insert_after_data :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, forward (%ebp)
	movl	n_data (%ebp), %eax
	movl	%eax, 0(%esp)
	call	doubly_get_node
	movl	%eax, newnode (%ebp)
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 0(%esp)
	movl	e_data (%ebp), %edx
	movl	%edx, 4(%esp)
	call	doubly_search_node
	movl	%eax, temp (%ebp)
	cmpl	$0, %eax
	je		diad_out_f
	movl	temp (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, forward (%ebp)
	movl	newnode (%ebp), %eax
	movl	forward (%ebp), %edx
	movl	%edx, NODE_NEXT (%eax)
	movl	temp (%ebp), %edx
	movl	newnode (%ebp), %eax
	movl	%edx, NODE_PREV (%eax)
	movl	temp (%ebp), %eax
	movl	newnode (%ebp), %edx
	movl	%edx, NODE_NEXT (%eax)
	movl	forward (%ebp), %eax
	cmpl	$0, %eax
	je		diad_out
	movl	newnode (%ebp), %eax
	movl	forward (%ebp), %edx
	movl	%eax, NODE_PREV (%edx)
	jmp		diad_out
diad_out_f:
	movl	$msg_err2, 0(%esp)
	call	printf 
diad_out:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl doubly_delete_end
.type doubly_delete_end @ function
.equ pp_head, 8
.equ temp, -4
.equ prev, -8
.equ forward, -12
doubly_delete_end :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	je		dde_out_f
	movl	(%eax), %eax
	movl	%eax, temp (%ebp)
	jmp		dde_cond
dde_while:
	movl	temp (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, temp (%ebp)
dde_cond:
	movl	temp (%ebp), %eax
	cmpl	$0, NODE_NEXT (%eax)
	jne		dde_while
	movl	temp (%ebp), %eax
	movl	NODE_PREV (%eax), %eax
	movl	%eax, prev (%ebp)
	movl	pp_head (%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, prev (%ebp)
	jne		dde_else
dde_if:
	movl	temp (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, forward (%ebp)
	movl	pp_head (%ebp), %eax
	movl	forward (%ebp), %edx
	movl	%edx, (%eax)
	cmpl	$0, forward (%ebp)
	je		dde_free
	movl	forward (%ebp), %eax
	movl	$0, NODE_PREV (%eax)
	jmp		dde_free
dde_else:
	movl	temp (%ebp), %eax
	movl	NODE_PREV (%eax), %eax
	movl	%eax, prev (%ebp)
	movl	prev (%ebp), %eax
	movl	$0, NODE_NEXT (%eax)
dde_free:
	movl	temp (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free
dde_out_f:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text 
.globl doubly_delete_beg 
.type doubly_delete_beg @ function
.equ pp_head, 8
.equ temp, -4
.equ prev, -8
.equ forward, -12
doubly_delete_beg :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	pp_head (%ebp), %eax
	cmpl	$0, (%eax)
	je		ddb_out_f
	movl	(%eax), %eax
	movl	%eax, temp (%ebp)
	movl	pp_head (%ebp), %eax
	movl	temp (%ebp), %edx
	movl	NODE_NEXT (%edx), %edx
	movl	%edx, (%eax)
	movl	%edx, forward (%ebp)
	cmpl	$0, forward (%ebp)
	je		ddb_free
	movl	forward (%ebp), %edx
	movl	$0, NODE_PREV (%edx)
ddb_free:
	movl	temp (%ebp), %eax
	movl	%eax, 0(%esp)
	call	free
ddb_out_f:
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text 
.globl doubly_display
.type doubly_display @ function
.equ head, 8
.equ temp, -4
doubly_display :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	head (%ebp), %eax
	movl	%eax, temp (%ebp)
	movl	$msg_d1, 0(%esp)
	call	printf
	jmp		dd_cond
dd_while:
	movl	temp (%ebp), %eax
	movl	NODE_DATA (%eax), %eax
	movl	%eax, 4(%esp)
	movl	$msg_d2, 0(%esp)
	call	printf
	movl	temp (%ebp), %eax
	movl	NODE_NEXT (%eax), %eax
	movl	%eax, temp (%ebp)
dd_cond:
	movl	temp (%ebp), %eax
	cmpl	$0, %eax
	jne		dd_while
	movl	$msg_d3, 0(%esp)
	call	printf
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl doubly_get_node
.type doubly_get_node @ function
.equ data, 8
.equ newnode, -4
doubly_get_node :
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$1, 0(%esp)
	movl	$SIZE_PER_NODE, 4(%esp)
	call	xcalloc
	movl	%eax, newnode (%ebp)
	movl	newnode (%ebp), %eax
	movl	data (%ebp), %edx
	movl	%edx, NODE_DATA (%eax)
	movl	$0, NODE_NEXT (%eax)
	movl	$0, NODE_PREV (%eax)
	movl	newnode (%ebp), %eax
	movl	%ebp, %esp
	popl	%ebp
	ret

.section .text
.globl xcalloc
.type xcalloc @ function
.equ no_of_elements, 8
.equ size_per_element, 12
.equ ptr, -4
xcalloc : 
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
	jmp		xc_out
xc_out_f:
	movl	$msg_err1, 0(%esp)
	call	printf 
	movl	$-1, 0(%esp)
	call	exit
xc_out:
	movl	%ebp, %esp
	popl	%ebp
	ret
