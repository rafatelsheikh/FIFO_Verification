package FIFO_scoreboard_pkg;
    import FIFO_transactions_pkg::*;
    import shared_pkg::*;

    class FIFO_scoreboard;
        logic [FIFO_WIDTH - 1 : 0] data_out_ref;
        logic [FIFO_WIDTH - 1 : 0] q_ref[$];
        
        task check_data(FIFO_transactions f_trans);
            reference_model(f_trans);

            if (f_trans.data_out != data_out_ref) begin
                error_count++;

                $display("error, rst_n: %b, wr_en: %b, rd_en: %b, data_in: %b, data_out_dut: %h, data_out_ref: %h",
                            f_trans.rst_n, f_trans.wr_en, f_trans.rd_en, f_trans.data_in, f_trans.data_out, data_out_ref);
            end else begin
                correct_count++;
            end
        endtask

        task reference_model(FIFO_transactions f_trans);
            if (!f_trans.rst_n) begin
                q_ref.delete();
            end else begin    
                bit is_wr, is_rd;

                if (f_trans.wr_en && f_trans.rd_en) begin
                    if (q_ref.size() == 0) begin
                        is_wr = 1;
                        is_rd = 0;
                    end else if (q_ref.size() == FIFO_DEPTH) begin
                        is_wr = 0;
                        is_rd = 1;
                    end else begin
                        is_wr = 1;
                        is_rd = 1;
                    end
                end else begin
                    is_wr = f_trans.wr_en;
                    is_rd = f_trans.rd_en;
                end

                if (is_wr) begin
                    q_ref.push_back(f_trans.data_in);
                end

                if (is_rd) begin
                    data_out_ref = q_ref.pop_front();
                end
            end
        endtask
    endclass
endpackage