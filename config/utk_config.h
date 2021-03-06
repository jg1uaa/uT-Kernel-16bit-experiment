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
 *	utk_config.h
 *	System Configuration Definition
 */

#ifndef _UTK_CONFIG_H_
#define _UTK_CONFIG_H_

#include "config.h"

#ifdef _APP_H83664_
#include "sysdepend/app_h83664/utk_config_depend.h"
#endif

#include "utk_config_func.h"

#if !USE_TRAP && !(USE_DBGSPT && USE_HOOK_TRACE)
#include "tksvcproxy.h"
#include "tdsvcproxy.h"
#endif

#endif /* _UTK_CONFIG_H_ */
