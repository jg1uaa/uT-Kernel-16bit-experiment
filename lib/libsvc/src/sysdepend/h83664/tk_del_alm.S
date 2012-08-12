/*
 *	micro T-Kernel SVC interface library (h83664)
 */

#include <machine.h>
#include <tk/sysdef.h>
#include <sys/svc/tkfncd.h>
#include "utk_config.h"

#if USE_TRAP || (USE_DBGSPT && USE_HOOK_TRACE)
	.text
	.balign	2
	.globl	Csym(tk_del_alm)
Csym(tk_del_alm):
	mov.w	r0, @-r7
	mov.w	#TFN_DEL_ALM, r0

	jsr	Csym(knl_call_entry)

	adds	#2, r7
	rts
#endif

