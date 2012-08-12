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
 *	tkdev_timer.h (H8/3664)
 *	Hardware-Dependent Timer Processing
 */

#ifndef _TKDEV_TIMER_
#define _TKDEV_TIMER_

#include <tk/sysdef.h>
#include <tk/syslib.h>
#include <sys/sysinfo.h>

/*
 * Settable interval range (millisecond)
 */
#define MIN_TIMER_PERIOD	31
#define MAX_TIMER_PERIOD	1000

/*
 * Timer definition
 */
#define	MSTCR1		((_UB *)0xfff9)

#define	TMA		((_UB *)0xffa6)
#define	TCA		((_UB *)0xffa7)

#define	IENR1		((_UB *)0xfff4)
#define	IRR1		((_UB *)0xfff6)

#define	MSTTA		(1 << 0)

#define	TMA_START	0x7a	// 32.768kHz, 0.25s
#define	TMA_STOP	(TMA_START | 0x04)

#define	IENTA		(1 << 6)
#define	IRRTA		(1 << 6)

/*
 * Set timer
 */
Inline void knl_init_hw_timer( void )
{
	/* disable timer interrupt */
	*IENR1 &= ~IENTA;

	/* module power on */
	*MSTCR1 &= ~MSTTA;

	/* reset timer */
	*TMA = TMA_STOP;

	/* clear interrupt */
	*IRR1 &= ~IRRTA;
}

/*
 * Timer start processing
 *	Initialize the timer and start the periodical timer interrupt.
 */
Inline void knl_start_hw_timer( void )
{
	/* Set timer */
	knl_init_hw_timer();

	/* start timer */
	*TMA = TMA_START;

	/* enable interrupt */
	*IENR1 |= IENTA;
}

/*
 * Clear timer interrupt
 *	Clear the timer interrupt request. Depending on the type of
 *	hardware, there are two timings for clearing: at the beginning
 *	and the end of the interrupt handler.
 *	'clear_hw_timer_interrupt()' is called at the beginning of the
 *	timer interrupt handler.
 *	'end_of_hw_timer_interrupt()' is called at the end of the timer
 *	interrupt handler.
 *	Use either or both according to hardware.
 */
Inline void knl_clear_hw_timer_interrupt( void )
{
	*IRR1 &= ~IRRTA;
}
Inline void knl_end_of_hw_timer_interrupt( void )
{
	/* Nothing required to do at this point */
}

/*
 * Timer stop processing
 *	Stop the timer operation.
 *	Called when system stops.
 */
Inline void knl_terminate_hw_timer( void )
{
	/* disable timer interrupt */
	*IENR1 &= ~IENTA;

	/* reset timer */
	*TMA = TMA_STOP;

	/* clear interrupt */
	*IRR1 &= ~IRRTA;

	/* module power off */
	*MSTCR1 |= MSTTA;
}

/*
 * Get processing time from the previous timer interrupt to the
 * current (nanosecond)
 *	Consider the possibility that the timer interrupt occurred
 *	during the interrupt disable and calculate the processing time
 *	within the following
 *	range: 0 <= Processing time < CFN_TIMER_PERIOD * 2
 */
Inline UW knl_get_hw_timer_nsec( void )
{
	// XXX not supported
	return 0;
}

#endif /* _TKDEV_TIMER_ */
