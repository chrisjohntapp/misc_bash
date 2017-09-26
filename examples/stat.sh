#!/bin/bash

# Example on RHEL5 (2.6.18 kernel):
#23267 (bash) S 23265 23267 23267 34818 23541 4202496 3005 27576 1 6 4 3 45 16 15 0 1 0 1269706754 72114176 448 18446744073709551615 4194304 4922060 140734626075216 18446744073709551615 272198374197 0 65536 3686404 1266761467 18446744071562230894 0 0 17 2 0 0 23

PID=${1}

if [ ! -z "$PID" ]; then
  read pid tcomm state ppid pgid sid tty_nr tty_pgrp flags min_flt cmin_flt maj_flt cmaj_flt utime stime cutime cstime priority nice num_threads it_real_value start_time vsize mm rsslim start_code end_code start_stack eis eip pending blocked sigign sigcatch wchan oul1 oul2 exit_signal cpu rt_priority policy ticks < /proc/$PID/stat
  echo "Pid $PID $tcomm is in state $state on CPU $cpu. Its parent is Pid $ppid"
  echo "It is occupying $(( $vsize / 1024 )) kilobytes"
fi

