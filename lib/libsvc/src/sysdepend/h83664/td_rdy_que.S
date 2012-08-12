/*
 *	micro T-Kernel SVC interface library (h83664)
 */

#include <machine.h>
#include <tk/sysdef.h>
#include <sys/svc/tdfncd.h>
#include "utk_config.h"

#if USE_TRAP || (USE_DBGSPT && USE_HOOK_TRACE)
	.text
	.balign	2
	.globl	Csym(td_rdy_que)
Csym(td_rdy_que):
	mov.w	r0, @-r7
	mov.w	#TDFN_RDY_QUE, r0

	jsr	Csym(knl_call_dbgspt)

	adds	#2, r7
	rts
#endif

