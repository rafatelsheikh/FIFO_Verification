import shared_pkg::*;
import FIFO_transactions_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;

module FIFO_tb (IFIFO.DUT fifo_if);
    FIFO_transactions fifo_trans = new;
    FIFO_scoreboard fifo_score = new;
    FIFO_coverage fifo_cov = new;

    initial begin
        fifo_trans.rst_n = 0;
        fifo_if.rst_n = fifo_trans.rst_n;

        @(negedge fifo_if.clk);

        ->fifo_if.start_to_sample;

        fifo_score.check_data(fifo_trans);

        fifo_trans.rst_n = 1;
        fifo_if.rst_n = fifo_trans.rst_n;

        repeat (1000) begin
            fifo_trans.randomize();

            fifo_if.rst_n = fifo_trans.rst_n;
            fifo_if.data_in = fifo_trans.data_in;
            fifo_if.wr_en = fifo_trans.wr_en;
            fifo_if.rd_en = fifo_trans.rd_en;

            @(negedge fifo_if.clk);

            ->fifo_if.start_to_sample;
        end

        test_finished = 1;

        @(negedge fifo_if.clk);

        ->fifo_if.start_to_sample;
    end
endmodule