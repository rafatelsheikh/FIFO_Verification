package FIFO_coverage_pkg;
    import FIFO_transactions_pkg::*;

    class FIFO_coverage;
        FIFO_transactions F_cvg_txn;

        covergroup CovCode;
            wr_en_cp: coverpoint F_cvg_txn.wr_en iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            rd_en_cp: coverpoint F_cvg_txn.rd_en iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            full_cp: coverpoint F_cvg_txn.full iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            almostfull_cp: coverpoint F_cvg_txn.almostfull iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            empty_cp: coverpoint F_cvg_txn.empty iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            almostempty_cp: coverpoint F_cvg_txn.almostempty iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            overflow_cp: coverpoint F_cvg_txn.overflow iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            underflow_cp: coverpoint F_cvg_txn.underflow iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            wr_ack_cp: coverpoint F_cvg_txn.wr_ack iff (F_cvg_txn.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            full_cr: cross wr_en_cp, rd_en_cp, full_cp iff (F_cvg_txn.rst_n) {
                ignore_bins ignr = binsof(rd_en_cp.high) && binsof(full_cp.high);
            }

            almostfull_cr: cross wr_en_cp, rd_en_cp, almostfull_cp iff (F_cvg_txn.rst_n);

            empty_cr: cross wr_en_cp, rd_en_cp, empty_cp iff (F_cvg_txn.rst_n) {
                ignore_bins ignr = binsof(wr_en_cp.high) && binsof(empty_cp.high);
            }

            almostempty_cr: cross wr_en_cp, rd_en_cp, almostempty_cp iff (F_cvg_txn.rst_n);

            overflow_cr: cross wr_en_cp, rd_en_cp, overflow_cp iff (F_cvg_txn.rst_n) {
                ignore_bins ignr = binsof(wr_en_cp.low) && binsof(overflow_cp.high);
            }

            underflow_cr: cross wr_en_cp, rd_en_cp, underflow_cp iff (F_cvg_txn.rst_n) {
                ignore_bins ignr = binsof(rd_en_cp.low) && binsof(underflow_cp.high);
            }
        
            wr_ack_cr: cross wr_en_cp, rd_en_cp, wr_ack_cp iff (F_cvg_txn.rst_n) {
                ignore_bins ignr = binsof(wr_en_cp.low) && binsof(wr_ack_cp.high);
            }
        endgroup

        function new();
            CovCode = new;
        endfunction

        function void sample_data(FIFO_transactions F_txn);
            F_cvg_txn = F_txn;
            CovCode.sample();
        endfunction
    endclass
endpackage