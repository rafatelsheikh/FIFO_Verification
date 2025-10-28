package FIFO_transactions_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    class FIFO_transactions;
        rand logic [FIFO_WIDTH - 1 : 0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH - 1 : 0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        function new(int rd_en_on_dist = 30, int wr_en_on_dist = 70);
            RD_EN_ON_DIST = rd_en_on_dist;
            WR_EN_ON_DIST = wr_en_on_dist;
        endfunction

        constraint FIFO_1 {
            rst_n dist {1 :/ 95, 0 :/ 5};
        }

        constraint FIFO_6_8 {
            wr_en dist {1 :/ WR_EN_ON_DIST, 0 :/ 100 - WR_EN_ON_DIST};
        }

        constraint FIFO_7_10 {
            wr_en dist {1 :/ RD_EN_ON_DIST, 0 :/ 100 - RD_EN_ON_DIST};
        }
    endclass
endpackage