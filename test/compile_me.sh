#!/bin/bash

# check if path to proFPGA installation is set
if [[ -z "$PROFPGA" ]]; then
 echo "Path to proFPGA installation (\$PROFPGA) not set - terminating!"
 exit 1
fi

gcc -pthread -o usertest -Wl,--no-as-needed -ldl -I ${PROFPGA}/include/ main.c -Wl,--whole-archive ${PROFPGA}/lib/linux_x86_64/libmmi64.a  -Wl,--no-whole-archive ${PROFPGA}/lib/linux_x86_64/libmmi64pli.a  ${PROFPGA}/lib/linux_x86_64/libprofpga.a ${PROFPGA}/lib/linux_x86_64/libconfig.a
