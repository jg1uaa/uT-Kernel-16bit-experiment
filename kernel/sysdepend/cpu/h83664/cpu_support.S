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
 *	cpu_support.S (h8300)
 *	Device-Dependent CPU Operation
 */

#define	_in_asm_source_

#include <machine.h>
#include <tk/errno.h>
#include <tk/sysdef.h>
#include <tk/asm.h>
#include <sys/sysinfo.h>

#include "config.h"
#include "utk_config.h"
#if USE_TRAP | (USE_DBGSPT & USE_HOOK_TRACE)
#include "isysconf.h"
#endif
#include "tkdev_conf.h"

#if	USE_TRAP | USE_DBGSPT | USE_HOOK_TRACE
#error	ouch!
#endif

/* ------------------------------------------------------------------------ */
/*
 * Dispatcher
 *	dispatch_to_schedtsk:
 *		Throw away the current contexts and forcibly dispatch to
 *		'schedtsk.'
 *		Called directly by jump (jmp) but do not return.
 *		Called on the undefined stack state (undefined 'ssp').
 *		Called on the interrupt disable state.
 *	dispatch_entry:
 *		Normal dispatch processing.
 *	_ret_int_dispatch:
 *		Called when dispatch is required by 'tk_ret_int().'
 *
 *	Contexts to save
 *	Save registers except for SP to a stack. Save SP to TCB.
 *
 *		   High Address	+---------------+
 *				| SPC(16bit)	|
 *				| SCCR(8bit)	| Saved by interrupt entry
 *				| SCCR(8bit)	| routines until here.
 *				+---------------+
 *				| R0		|
 *				| R1		|
 *				| R2		|
 *				| R3		|
 *				| R4		|
 *				| R5		|
 *	Saved to TCB  SP =>	| R6		|
 *		    Low Address	+---------------+
 */

/* Temporal stack used when 'dispatch_to_schedtsk' is called */


	.text
	.balign	2
	.globl	Csym(knl_dispatch_to_schedtsk)
	.globl	Csym(knl_dispatch_entry)

Csym(knl_dispatch_to_schedtsk):
	/* During interrupt disable CCR.I=1 */
	mov.w	#(Csym(knl_tmp_stack) + TMP_STACK_SZ), r7	// Set temporal stack

	mov.w	#1, r0				// r0 := 1
	mov.w	r0, @Csym(knl_dispatch_disabled)	// Dispatch disable

	mov.w	#Csym(knl_ctxtsk), r6		// r6 := &ctxtsk
	sub.w	r0, r0
	mov.w	r0, @r6				// ctxtsk = NULL

	andc	#CCR_EI_MASK, ccr		// Interrupt enable
	bra	l_dispatch0

Csym(knl_dispatch_entry):
	/* During interrupt disable CCR.I=1 */
	stc	ccr, r0h
	and.b	#CCR_EI_MASK, r0h
	push.w	r0

_ret_int_dispatch:
	/* During interrupt disable CCR.I=1 */

	mov.w	#1, r0				// r0 := 1
	mov.w	r0, @Csym(knl_dispatch_disabled)	// Dispatch disable
	andc	#CCR_EI_MASK, ccr		// Interrupt enable

	push.w	r0				// Context save
	push.w	r1
	push.w	r2
	push.w	r3
	push.w	r4
	push.w	r5
	push.w	r6

	mov.w	#Csym(knl_ctxtsk), r6           // r6 := &ctxtsk
	mov.w	@r6, r1
	mov.w	@Csym(CTXB_ssp), r0
	add.w	r0, r1                          // r1 = &ctxtsk.ssp
	mov.w	r7, @r1                         // Save SSP to TCB

  l_dispatch0:
	/* During interrupt enable CCR.I=0 */

  l_dispatch1:
	orc	#CCR_I, ccr			// Interrupt disable

	mov.w	@Csym(knl_schedtsk), r5		// ER5 = schedtsk
						// Is there 'schedtsk'?
	bne	l_dispatch2

	/* Because there is no task that should be executed, move to the power-saving mode */
	mov.w	@Csym(knl_lowpow_discnt), r0	// Is 'low_pow' disabled?
	bne	l_dispatch11

	jsr	@Csym(knl_low_pow)		// call low_pow()
  l_dispatch11:

	andc	#CCR_EI_MASK, ccr		// Interrupt enable
	bra	l_dispatch1

  l_dispatch2:					// Switch to 'schedtsk'
	/* During interrupt disable CCR.I=1 */
	mov.w	r5, @r6				// ctxtsk = schedtsk
	mov.w	@Csym(CTXB_ssp), r1
	add.w	r5, r1
	mov.w	@r1, r7				// Restore SSP from TCB

	sub.w	r1, r1
	mov.w	r1, @Csym(knl_dispatch_disabled)	// Dispatch enable 

	pop.w	r6				// Context restore
	pop.w	r5
	pop.w	r4
	pop.w	r3
	pop.w	r2
	pop.w	r1
	pop.w	r0

	rte

#if USE_HLL_INTHDR
/* ------------------------------------------------------------------------ */
/*
 * High level programming language routine for interrupt handler
 *	Called by interrupt entry routine on the state saved in the interrupt 
 *	stack as shown below.
 *	   High Address	+---------------+
 *			| SPC(16bit)	|
 *			| SCCR(8bit)	|
 *			| SCCR(8bit)	|
 *			| r0		|
 *		ISP =>	| r1		|
 *	    Low Address	+---------------+
 *
 *	r0 = intno
 */
	.text
	.balign	2
	.globl	Csym(knl_inthdr_startup)
Csym(knl_inthdr_startup):
	/* During interrupt disable CCR.I=1 */
	push.w	r2			// er0-er1 are already saved
	push.w	r3
	push.w	r4
	push.w	r5
	push.w	r6

	mov.w	@Csym(knl_taskindp), r6	// enter task independent mode
	adds	#1, r6
	mov.w	r6, @Csym(knl_taskindp)

	mov.w	@Csym(knl_int_nest), r2	// interrupt nest count
	mov.w	r2, r5
	adds	#1, r2
	mov.w	r2, @Csym(knl_int_nest)

	mov.w	r5, r5
	bne	l_no_change_sp		// multiple interrupt

	mov.w	r7, r2
	mov.w	#RI_INTSTACK, r7	// change to ISP
	mov.w	r2, @-r7		// SSP save
  l_no_change_sp:

	add.w	r0, r0			// offset = dintno << 1
	mov.w	@(Csym(knl_hll_inthdr), r0), r3	// call hll_inthdr[n](dintno)
	jsr	@r3

	orc.b	#CCR_I, ccr		// Interrupt disable

	/* During interrupt disable CCR.I=1 */
	mov.w	r5, r5
	bne	l_no_change_sp2		// multiple interrupt

	mov.w	@r7+, r2		// r2 = SSP
	mov.w	r2, r7
l_no_change_sp2:

	subs	#1, r6
	mov.w	r6, @Csym(knl_taskindp)

	pop.w	r6
	pop.w	r5
	pop.w	r4
	pop.w	r3
	pop.w	r2

	jmp	@Csym(tk_ret_int_impl)

#endif /* USE_HLL_INTHDR */

/*
 * _tk_ret_int()
 *
 * tk_ret_int() processing
 *	When called, the interrupt stack is configured as shown below.
 *	   High Address	+---------------+
 *			| SPC(16bit)	| Saved when interrupt occur
 *			| SCCR(8bit)	|
 *			| SCCR(8bit)	|
 *			| R0(16bit)	|
 *		SSP =>	| R1(16bit)	|
 *	    Low Address	+---------------+
 */
	.text
	.balign	2
	.globl	Csym(tk_ret_int_impl)
Csym(tk_ret_int_impl):
	/* During interrupt disable CCR.I=1 */
	mov.w	@Csym(knl_int_nest), r0	// Is it a nesting interrupt?
	subs	#1, r0
	mov.w	r0, @Csym(knl_int_nest)
	bne	l_nodispatch

	mov.w	@(2*2, r7), r0		// CCR when EIT occurs
	and.b	#CCR_I, r0h		// Is it an exception during interrupt disable?
	bne	l_nodispatch

	mov.w	@Csym(knl_dispatch_disabled), r0	// Is it during dispatch disable?
	bne	l_nodispatch

	mov.w	@Csym(knl_ctxtsk), r0		// Is dispatch required?
	mov.w	@Csym(knl_schedtsk), r1
	cmp	r0, r1
	beq	l_nodispatch

	pop.w	r1			// R0, R1 restore
	pop.w	r0
	jmp	_ret_int_dispatch	// To dispatch processing

  l_nodispatch:				// Dispatch not required
	pop.w	r1			// R0, R1 restore
	pop.w	r0
	rte

/* ------------------------------------------------------------------------ */
/*
 * High level programming language routine for timer handler
 */
	.text
	.balign	2
	.globl	Csym(knl_timer_handler_startup)
Csym(knl_timer_handler_startup):
	/* During interrupt disable CCR.I=1 */
	push.w	r0
	push.w	r1
	push.w	r2
	push.w	r3
	push.w	r4
	push.w	r5
	push.w	r6

	mov.w	@Csym(knl_taskindp), r6	// enter task independent mode
	adds	#1, r6
	mov.w	r6, @Csym(knl_taskindp)

	mov.w	@Csym(knl_int_nest), r2	// interrupt nest count
	mov.w	r2, r5
	adds	#1, r2
	mov.w	r2, @Csym(knl_int_nest)

	mov.w	r5, r5
	bne	l_no_change_sp_timerhdr		// multiple interrupt

	mov.w	r7, r2
	mov.w	#RI_INTSTACK, r7	// change to ISP
	mov.w	r2, @-r7		// SSP save
  l_no_change_sp_timerhdr:

	jsr	@Csym(knl_timer_handler)	// call timer_handler()

	orc.b	#CCR_I, ccr		// Interrupt disable

	/* During interrupt disable CCR.I=1 */
	mov.w	r5, r5
	bne	l_no_change_sp2_timerhdr		// multiple interrupt

	mov.w	@r7+, r2		// R2 = SSP
	mov.w	r2, r7
  l_no_change_sp2_timerhdr:

	subs	#1, r6
	mov.w	r6, @Csym(knl_taskindp)

	pop.w	r6
	pop.w	r5
	pop.w	r4
	pop.w	r3
	pop.w	r2

	jmp	@Csym(tk_ret_int_impl)

