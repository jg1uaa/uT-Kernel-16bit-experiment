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
 *  @(#) icrt0.S
 */

#include "utk_config.h"

#include <machine.h>
#include <tk/asm.h>

#if USE_IMALLOC
	/* Low level memory manager information */
	.comm	Csym(knl_lowmem_top), 2	// Head of area (Low address)
	.comm	Csym(knl_lowmem_limit), 2	// End of area (High address)
#endif

        .section .text
        .align     2
        .global    Csym(start)
Csym(start):
	mov.w   #RI_INTSTACK, r7

	ldc.b   #0xc0, ccr

	mov.w   #__data_start, r2  /* dst address */
	mov.w   #__data_end, r3

	cmp.w   r2, r3
	ble     data_done           /* if __data_start >= __data_end */

	mov.w   #__data_org, r1    /* src address */

data_loop:
	mov.b   @r1+, r0l
	mov.b   r0l, @r2
	adds    #1, r2

	cmp.w   r2, r3
        bgt     data_loop          /* if er2 < __data_end */

data_done:

#if USE_NOINIT
	mov.w   #__noinit_end, r2   /* dst address */
#else
	/* .bss */
	mov.w   #__bss_start, r2   /* dst address */
#endif
	mov.w   #__bss_end, r3

	cmp.w   r2, r3
	ble     bss_done           /* if __bss_start >= __bss_end */

	sub.w   r0, r0
bss_loop:
	mov.b	r0l, @r2
	adds    #1, r2
	cmp.w   r2, r3
	bgt     bss_loop           /* if er2 < __bss_end */

bss_done:

#if USE_IMALLOC
	mov.w   #SYSTEMAREA_TOP, r5
	cmp.w	r5, r3           /* _end or RAM_TOP */
	bge     no_mov             /* if er5 <= er3 */
	mov.w   r5, r3
no_mov:

	mov.w   r3, @Csym(knl_lowmem_top)	/* knl_lowmem_top = _end or RAM_TOP */
	mov.w   #SYSTEMAREA_END, r3
	mov.w   r3, @Csym(knl_lowmem_limit)	/* knl_lowmem_limit = RAM_END */
#endif

serial_init:
	jsr	@Csym(sio_init)		/* initialize serial I/O */

kernel_start:
	sub.w   r0, r0
	jsr     @Csym(main)
loop_trap:
	bra     loop_trap


#include "vector.S"
