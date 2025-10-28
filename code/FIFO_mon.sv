import shared_pkg::*;
import FIFO_transactions_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;

module FIFO_mon(IFIFO.MONITOR fifo_if);
    FIFO_transactions fifo_trans = new;
    FIFO_scoreboard fifo_score = new;
    FIFO_coverage fifo_cov = new;

    initial begin
        forever begin
            @fifo_if.start_to_sample;
            @(negedge fifo_if.clk);

            fifo_trans.rst_n = fifo_if.rst_n;
            fifo_trans.data_in = fifo_if.data_in;
            fifo_trans.wr_en = fifo_if.wr_en;
            fifo_trans.rd_en = fifo_if.rd_en;
            fifo_trans.data_out = fifo_if.data_out;
            fifo_trans.empty = fifo_if.empty;
            fifo_trans.almostempty = fifo_if.almostempty;
            fifo_trans.full = fifo_if.full;
            fifo_trans.almostfull = fifo_if.almostfull;
            fifo_trans.overflow = fifo_if.overflow;
            fifo_trans.underflow = fifo_if.underflow;
            fifo_trans.wr_ack = fifo_if.wr_ack;

            fork
                begin
                    fifo_cov.sample_data(fifo_trans);
                end

                begin
                    fifo_score.check_data(fifo_trans);
                end
            join

            if (test_finished) begin
                $display("error: %d, correct: %d", error_count, correct_count);

                $stop;
            end
        end
    end
endmodule