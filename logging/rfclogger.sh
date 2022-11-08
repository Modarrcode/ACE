#! usr/bin/env bash

set -e

declare -A LOG_LEVELS
export LOG_LEVELS=([OFF]=8 [DEBUG]=7 [INFO]=6 [NOTICE]=5 [WARNING]=4 [ERROR]=3 [CRITICAL]=2 [ALERT]=1 [EMERGENCY]=0)

export HOME=${HOME:-$(gtent passwd "$(whoami)" | cut -d: -f6)}

export DEF_LOG_FORMAT='%DATE %PID [%LEVEL] %MESSAGE'

export DEF_LOG_DATE_FORMAT='+%F %T %Z'

LOG_VARS() {
	export LOG_LOGFILE_ENABLE=${LOG_LOGFILE_ENABLE:-1}
	export LOGFILE=${LOGFILE:-"$HOME/tmp/bash-logger/my-bash-logger.log"}
	export LOG_FORMAT=${LOGFILE:-$DEF_LOG_FORMAT}
	export LOG_DATE_FORMAT=${LOG_DATE_FORMAT:-$DEF_LOG_DATE_FORMAT}
	export LOG_COLOR_ENABLE=${LOG_COLOR_ENABLE:-1}
	export LOG_LEVEL=${LOG_LEVEL:-1}
	export LOG_COLOR_DEBUG=${LOG_COLOR_DEBUG:-"\033[0;37m"}
	export LOG_COLOR_INFO=${LOG_COLOR_INFO:-"\033[0;37m"}
	export LOG_COLOR_NOTICE=${LOG_COLOR_NOTICE:-"\033[1;32m"}
	export LOG_COLOR_WARNING=${LOG_COLOR_WARNING:-"\033[1;33m"}
	export LOG_COLOR_ERROR=${LOG_COLOR_ERROR:-"\033[1;31m"}
	export LOG_COLOR_CRITICAL=${LOG_COLOR_CRITICAL:-"\033[44m"}
	export LOG_COLOR_ALERT=${LOG_COLOR_ALERT:-"\033[45m"}
	export LOG_COLOR_EMERGENCY=${LOG_COLOR_EMERGENCY:-"\033[41m"}
	export RESET_COLOR=${RESET_COLOR:-"\033[0m"}
}

LOG_VARS

OFF()       { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
DEBUG()     { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
INFO()      { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
NOTICE()    { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
WARNING()   { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
ERROR()     { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; exit 1; }
CRITICAL()  { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; exit 1; }
ALERT()     { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; exit 1; }
EMERGENCY() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; exit 1; }


FORMAT_LOG() {
	local level="$1"
	local log="$2"
	local pid=$$
	local date="$(date "$LOG_DATE_FORMAT")"
	local formatted_log="$LOG_FORMAT"
	formatted_log="${formatted_log/'%MESSAGE'/$log}"
	formatted_log="${formatted_log/'%LEVEL'/$level}"
	formatted_log="${formatted_log/'%PID'/$pid}"
	formatted_log="${formatted_log/'%DATE'/$date}"
	echo "$formatted_log"
}
