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
 * interrupt entry routines (included from vector.S)
 */

#include <tk/asm.h>

        .section .text
        .align 2

INT_ENTRY 1
INT_ENTRY 2
INT_ENTRY 3
INT_ENTRY 4
INT_ENTRY 5
INT_ENTRY 6
INT_ENTRY 7
#if !USE_TRAP
INT_ENTRY 8
#endif
#if (!USE_TRAP) & (CFN_MAX_SSYID <= 0)
INT_ENTRY 9
#endif
#if !USE_TRAP
INT_ENTRY 10
#endif
INT_ENTRY 11
INT_ENTRY 12
INT_ENTRY 13
INT_ENTRY 14
INT_ENTRY 15
INT_ENTRY 16
INT_ENTRY 17
INT_ENTRY 18
//INT_ENTRY 19	/* timer */
INT_ENTRY 20
INT_ENTRY 21
INT_ENTRY 22
INT_ENTRY 23
INT_ENTRY 24
INT_ENTRY 25
