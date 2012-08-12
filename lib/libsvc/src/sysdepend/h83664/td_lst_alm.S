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
	.globl	Csym(td_lst_alm)
Csym(td_lst_alm):
	mov.w	r0, @-r7
	mov.w	#TDFN_LST_ALM, r0

	jsr	Csym(knl_call_dbgspt)

	adds	#2, r7
	rts
#endif

