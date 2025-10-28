vlib work
vlog *v  +cover +define+SIM
vsim -voptargs=+acc FIFO_top -cover
add wave *
add wave /FIFO_top/dut/a_reset_empty /FIFO_top/dut/a_reset_full /FIFO_top/dut/a_reset_almostempty /FIFO_top/dut/a_reset_almostfull /FIFO_top/dut/a_reset_overflow /FIFO_top/dut/a_reset_underflow /FIFO_top/dut/a_reset_wr_ack /FIFO_top/dut/a_reset_wr_ptr /FIFO_top/dut/a_reset_rd_ptr /FIFO_top/dut/a_reset_count /FIFO_top/dut/a_wr_ptr_threshold /FIFO_top/dut/a_rd_ptr_threshold /FIFO_top/dut/a_count_threshold /FIFO_top/dut/a_IsFullEmpty /FIFO_top/dut/c_IsFullEmpty /FIFO_top/dut/a_IsEmpty /FIFO_top/dut/c_IsEmpty /FIFO_top/dut/a_IsNotEmpty /FIFO_top/dut/c_IsNotEmpty /FIFO_top/dut/a_IsAlmostEmpty /FIFO_top/dut/c_IsAlmostEmpty /FIFO_top/dut/a_IsFull /FIFO_top/dut/c_IsFull /FIFO_top/dut/a_IsNotFull /FIFO_top/dut/c_IsNotFull /FIFO_top/dut/a_IsAlmostFull /FIFO_top/dut/c_IsAlmostFull /FIFO_top/dut/a_IsOverflow /FIFO_top/dut/c_IsOverflow /FIFO_top/dut/a_IsUnderflow /FIFO_top/dut/c_IsUnderflow /FIFO_top/dut/a_IsWriteAck /FIFO_top/dut/c_IsWriteAck /FIFO_top/dut/a_wr_ptr_wrap /FIFO_top/dut/c_wr_ptr_wrap /FIFO_top/dut/a_rd_ptr_wrap /FIFO_top/dut/c_rd_ptr_wrap
coverage save FIFO.ucdb -onexit
run -all