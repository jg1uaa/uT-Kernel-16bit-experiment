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


#ifndef _MEMORY_H_
#define _MEMORY_H_

/*
 * Memory allocation management information
 *
 *  Order of members must not be changed because members are used
 *  with casting from MPLCB.
 */
typedef struct {
	W		memsz;

	/* AreaQue for connecting each area where reserved pages are
	   divided Sort in ascending order of addresses in a page.
	   Do not sort between pages. */
	QUEUE		areaque;
	/* FreeQue for connecting unused area in reserved pages
	   Sort from small to large free spaces. */
	QUEUE		freeque;
} IMACB;

/*
 * Compensation for aligning "&areaque" position to 2 bytes border
 */
#define AlignIMACB(imacb)	( (IMACB*)((UW)(imacb) & ~0x00000001UL) )

/*
 * Minimum unit of subdivision
 *	The lower 1 bit of address is always 0
 *	because memory is allocated by ROUNDSZ.
 *	AreaQue uses the lower 1 bit for flag.
 */
#define ROUNDSZ		( sizeof(QUEUE) )	/* 8 bytes */
#define ROUND(sz)	( ((UW)(sz) + (UW)(ROUNDSZ-1)) & ~(UW)(ROUNDSZ-1) )

/* Minimum fragment size */
#define MIN_FRAGMENT	( sizeof(QUEUE) * 2 )

/*
 * Adjusting the size which can be allocated 
 */
Inline W roundSize( W sz )
{
	if ( sz < (W)MIN_FRAGMENT ) {
		sz = (W)MIN_FRAGMENT;
	}
	return (W)(((UW)sz + (UW)(ROUNDSZ-1)) & ~(UW)(ROUNDSZ-1));
}


/*
 * Flag that uses the lower bits of AreaQue's 'prev'.
 */
#define AREA_USE	0x0001	/* In-use */
#define AREA_MASK	0x0001

#define setAreaFlag(q, f)   ( (q)->prev = (QUEUE*)((UH)(q)->prev |  (UH)(f)) )
#define clrAreaFlag(q, f)   ( (q)->prev = (QUEUE*)((UH)(q)->prev & ~(UH)(f)) )
#define chkAreaFlag(q, f)   ( ((UH)(q)->prev & (UH)(f)) != 0 )

#define Mask(x)		( (QUEUE*)((UH)(x) & ~AREA_MASK) )
#define Assign(x, y)	( (x) = (QUEUE*)(((UH)(x) & AREA_MASK) | (UH)(y)) )
/*
 * Area size
 */
#define AreaSize(aq)	( (VB*)(aq)->next - (VB*)((aq) + 1) )
#define FreeSize(fq)	( (UH)((fq) + 1)->prev )


IMPORT QUEUE* knl_searchFreeArea( IMACB *imacb, W blksz );
IMPORT void knl_appendFreeArea( IMACB *imacb, QUEUE *aq );
IMPORT void knl_removeFreeQue( QUEUE *fq );
IMPORT void knl_insertAreaQue( QUEUE *que, QUEUE *ent );
IMPORT void knl_removeAreaQue( QUEUE *aq );

IMPORT IMACB *knl_imacb;
IMPORT ER knl_init_Imalloc( void );

#endif /* _MEMORY_H_ */
