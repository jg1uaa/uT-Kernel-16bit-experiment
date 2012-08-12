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
	.globl	Csym(tk_wai_flg)
Csym(tk_wai_flg):
	mov.w	r0, @-r7
	mov.w	#TFN_WAI_FLG, r0

	jsr	Csym(knl_call_entry)

	adds	#2, r7
	rts
#endif

