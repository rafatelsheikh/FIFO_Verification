module FIFO_top();
    bit clk;

    always #1 clk = ~clk;

    IFIFO fifo_if(clk);

    FIFO dut(fifo_if);
    FIFO_tb tb(fifo_if);
    FIFO_mon mon(fifo_if);
endmodule