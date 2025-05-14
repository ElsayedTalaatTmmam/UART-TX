vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.UART_TX_TB
add wave *
add wave -position insertpoint  \
sim:/UART_TX_TB/DUT/FSM_TX/current_state
run -all