#!/bin/sh
#
# Copyright 2014-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# setup ADC channels

ADC_PATH="/sys/devices/platform/ast_adc.0"
# channel 0 (ADC0_12V)     :  r1:  5.6K; r2:  1.0K; v2: 0mv
# channel 1 (ADC_P5V_STBY) :  r1:  3.3K; r2:  1.0K; v2: 0mv
# channel 2 (ADC_P3V3_STBY):  r1:  1.0K; r2:  1.0K; v2: 0mv
# channels 3-7 (P1V8/P1V53/P0V9/P0V9_E/P1V26) connect directly to the AST2400
# ADC pins (0-ohm series, no divider; all < 2.5V full-scale), so r1=0, r2=1
# gives a direct 1:1 reading. Without these lines the driver defaults leave the
# channels unsampled and sensor-util reports them as 0.000V (lower-critical) --
# note P1V53 powers the BMC's DDR3 and P1V26 the AST2400 core, so those are
# never actually 0V on a booted BMC.

config_adc() {
    channel=$1
    r1=$2
    r2=$3
    v2=$4
    echo $r1 > ${ADC_PATH}/adc${channel}_r1
    echo $r2 > ${ADC_PATH}/adc${channel}_r2
    echo $v2 > ${ADC_PATH}/adc${channel}_v2
    echo 1 > ${ADC_PATH}/adc${channel}_en
}

config_adc 0 5600 1000 0
config_adc 1 3300 1000 0
config_adc 2 1000 1000 0
config_adc 3 0 1 0
config_adc 4 0 1 0
config_adc 5 0 1 0
config_adc 6 0 1 0
config_adc 7 0 1 0

