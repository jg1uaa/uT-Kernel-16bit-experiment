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
 *	@(#)sysdef_depend.h (tk/h8300)
 *
 *	Definition about H8/300
 *
 *	Included also from assembler program.
 */

#ifndef __TK_SYSDEF_DEPEND_H__
#define __TK_SYSDEF_DEPEND_H__

/*
 * Use specify register
 */
#define SP	r7	/* Stack pointer */

/*
 * CCR register
 */
#define CCR_I		( 0x01 << 7 )	/* Interrupt mask (mode 0) */
#define CCR_EI_MASK	( 0x7f )		/* Interrupt mask (mode 0) */

/*----------------------------------------------------------*/

#endif /* __TK_SYSDEF_DEPEND_H__ */
