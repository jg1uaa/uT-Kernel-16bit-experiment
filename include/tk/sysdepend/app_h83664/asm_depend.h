/*
 *----------------------------------------------------------------------
 *    micro T-Kernel
 *
 *    Copyright (C) 2006-2011 by Ken Sakamura. All rights reserved.
 *    micro T-Kernel is distributed under the T-License 2.0.
 *----------------------------------------------------------------------
 *
 *    Version:   1.01.01
 *    Released by T-Engine Forum(http://www.t-engine.org) at 2011/12/12.
 *
 *----------------------------------------------------------------------
 */

/*
 *	@(#)asm_depend.h (tk/h8300)
 *
 *	Assembler Macro for h8300
 */

#ifndef __TK_ASM_DEPEND_H__
#define __TK_ASM_DEPEND_H__

/*
 * Exception/Interrupt entry common processing
 */
 .macro	INT_ENTRY vecno
	.global knl_inthdr_entry\vecno
knl_inthdr_entry\vecno:
	push.w	r0
	push.w	r1

	mov.w	#\vecno, r0
	mov.w	#Csym(knl_intvec), r1
	mov.w	@(\vecno * 2, r1), r1
	jmp	@r1

 .endm


#endif /* __TK_ASM_DEPEND_H__ */
