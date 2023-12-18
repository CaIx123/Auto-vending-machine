######################################################################
#
# File name : tb_lcd_rgb_char_simulate.do
# Created on: Sun Jun 25 15:06:10 +0800 2023
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.tb_lcd_rgb_char xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {tb_lcd_rgb_char_wave.do}

view wave
view structure
view signals

do {tb_lcd_rgb_char.udo}

run 1000ns
