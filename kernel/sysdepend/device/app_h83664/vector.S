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
 * Vector table
 */

#include "utk_config.h"


#define int_ill loop_trap

        .section .vector, "a"
        .align 2

        .global __reset

#if !USE_FULL_VECTOR
__reset:
	.word   Csym(start)         /* 0: reset */
	.word   int_ill             /* 1: reserved */
	.word   int_ill             /* 2: reserved */
	.word   int_ill             /* 3: reserved */
	.word   int_ill             /* 4: reserved */
	.word   int_ill             /* 5: reserved */
	.word   int_ill             /* 6: reserved */
	.word	int_ill             /* 7: NMI */
#if USE_TRAP
	.word   Csym(knl_dispatch_entry) /* 8: trap (#0) */
#else
	.word	int_ill                  /* 8: trap (#0) */
#endif
#if USE_TRAP | CFN_MAX_SSYID > 0
	.word   Csym(knl_call_entry)     /* 9: trap (#1) */
#else
	.word	int_ill                  /* 9: trap (#1) */
#endif
#if USE_TRAP
	.word   Csym(tk_ret_int_impl)    /* 10: trap (#2) */
#else
	.word	int_ill                  /* 10: trap (#2) */
#endif
	.word	int_ill             /* 11: trap (#3) */
	.word   int_ill             /* 12: address break */
	.word   int_ill             /* 13: direct transition */
	.word   int_ill             /* 14: IRQ0 */
	.word   int_ill             /* 15: IRQ1 */
	.word   int_ill             /* 16: IRQ2 */
	.word   int_ill             /* 17: IRQ3 */
	.word   int_ill             /* 18: WKP */
	.word   Csym(knl_timer_handler_startup)	/* 19: Timer A */
	.word   int_ill             /* 20: reserved */
	.word   int_ill             /* 21: Timer W */
	.word   int_ill             /* 22: Timer V */
	.word   int_ill             /* 23: SCI3 */
	.word   int_ill             /* 24: I2C */
	.word   int_ill             /* 25: A/D converter */

#else /* USE_FULL_VECTOR */

__reset:
	.word   Csym(start)           /* 0: reset */
	.word   knl_inthdr_entry1     /* 1: reserved */
	.word   knl_inthdr_entry2     /* 2: reserved */
	.word   knl_inthdr_entry3     /* 3: reserved */
	.word   knl_inthdr_entry4     /* 4: reserved */
	.word   knl_inthdr_entry5     /* 5: reserved */
	.word   knl_inthdr_entry6     /* 6: reserved */
	.word	knl_inthdr_entry7     /* 7: NMI */
#if USE_TRAP
	.word   Csym(knl_dispatch_entry) /* 8: trap (#0) */
#else
	.word	knl_inthdr_entry8        /* 8: trap (#0) */
#endif
#if USE_TRAP | CFN_MAX_SSYID > 0
	.word   Csym(knl_call_entry)     /* 9: trap (#1) */
#else
	.word	knl_inthdr_entry9        /* 9: trap (#1) */
#endif
#if USE_TRAP
	.word   Csym(tk_ret_int_impl)    /* 10: trap (#2) */
#else
	.word	knl_inthdr_entry10       /* 10: trap (#2) */
#endif
	.word	knl_inthdr_entry11       /* 11: trap (#3) */
	.word   knl_inthdr_entry12    /* 12: address break */
	.word   knl_inthdr_entry13    /* 13: direct transition */
	.word   knl_inthdr_entry14    /* 14: IRQ0 */
	.word   knl_inthdr_entry15    /* 15: IRQ1 */
	.word   knl_inthdr_entry16    /* 16: IRQ2 */
	.word   knl_inthdr_entry17    /* 17: IRQ3 */
	.word   knl_inthdr_entry18    /* 18: WKP */
	.word   Csym(knl_timer_handler_startup)	/* 19: Timer A */
	.word   knl_inthdr_entry20    /* 20: reserved */
	.word   knl_inthdr_entry21    /* 21: Timer W */
	.word   knl_inthdr_entry22    /* 22: Timer V */
	.word   knl_inthdr_entry23    /* 23: SCI3 */
	.word   knl_inthdr_entry24    /* 24: I2C */
	.word   knl_inthdr_entry25    /* 25: A/D converter */

#include "inthdr_startup.S"

#endif /* !USE_FULL_VECTOR */
