#!/bin/bash
# (c) Copyright 2012-2013 PRO DESIGN Electronic GmbH.
# All rights reserved.
#
# This file is owned and controlled by ProDesign and must be used solely
# for design, simulation, implementation and creation of design files
# limited to profpga systems or technologies. Use with non-profpga
# systems or technologies is expressly prohibited and immediately
# terminates your license.
#
# PRODESIGN IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY
# FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR PRODESIGN SYSTEMS. BY
# PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE
# IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, PRODESIGN IS
# MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY
# CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY
# RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION. PRODESIGN EXPRESSLY
# DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
# IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
# REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
# INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE.
#
# ProDesign products are not intended for use in life support appliances,
# devices, or systems. Use in such applications are expressly
# prohibited.
#
set -e

# check if path to proFPGA installation is set
if [[ -z "$PROFPGA" ]]; then
 echo "Path to proFPGA installation (\$PROFPGA) not set - terminating!"
 exit 1
fi

if [ $# -ge 1 ] ; then
TOP_LANGUAGE=$1
else
TOP_LANGUAGE='vhdl'
fi

# Set top level synthesis
if [[ $TOP_LANGUAGE == 'verilog' ]] ; then
  echo "Using Verilog top level $TOP_LANGUAGE"
  export SYNTHESIS_TOP_LEVEL='Verilog'
  vivado -mode batch -source vivado.tcl
else
  echo "Using VHDL top level $TOP_LANGUAGE"
  export SYNTHESIS_TOP_LEVEL='VHDL'
  vivado -mode batch -source vivado.tcl
fi




