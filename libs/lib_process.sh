#!/bin/bash
#
# Utilities to work with processes.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_PROCESS=1;

function stat_pid() {
    #######################################################
    # Report interesting stuff about a PID from /proc/$PID.
    #######################################################
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# = 1 ]] || { printf "Usage: %s pid\n" "${func}"; return 1; }

    local pid=${1}

    if [[ -n "$pid" ]]; then
      read pid tcomm state ppid pgid sid tty_nr tty_pgrp flags min_flt cmin_flt maj_flt cmaj_flt utime stime cutime cstime priority nice num_threads it_real_value start_time vsize mm rsslim start_code end_code start_stack eis eip pending blocked sigign sigcatch wchan oul1 oul2 exit_signal cpu rt_priority policy ticks < /proc/$pid/stat

      printf "Pid ${pid} ${tcomm} is in state ${state} on CPU ${cpu}. Its parent is Pid ${ppid}\n"
      printf "It is occupying $(( ${vsize} / 1024 )) kilobytes\n"
    fi
}

