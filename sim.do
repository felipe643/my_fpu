# Remove e recria a biblioteca de trabalho "work"
if {[file exists work]} {
    file delete -force work
}
vlib work
vmap work work

vcom -work work -2008 -explicit fpu.vhd
vcom -work work -2008 -explicit fpu.tb
vsim work.tb
quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1
# Executa o arquivo de ondas, se existir
if {[file exists wave.do]} {
    do wave.do
}
run 100000 ns
