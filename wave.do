delete wave *

add wave -divider "Clock e Reset"
add wave -format Logic /tb/clk_100kHz
add wave -format Logic /tb/reset

add wave -divider "Entradas"
add wave -format Logic /tb/op_a
add wave -format Logic /tb/op_b

add wave -divider "Saídas"
add wave -format Logic /tb/data_out
add wave -format Logic /tb/status_out

add wave -divider "Sinais Internos da FPU"
add wave -format Logic /tb/uut/signal_a
add wave -format Logic /tb/uut/expoente_a
add wave -format Logic /tb/uut/mantisa_a
add wave -format Logic /tb/uut/signal_b
add wave -format Logic /tb/uut/expoente_b
add wave -format Logic /tb/uut/mantisa_b
add wave -format Logic /tb/uut/status

TreeUpdate [SetDefaultTree]

configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -signalnamewidth 1
configure wave -timeline 1

