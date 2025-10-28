////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(IFIFO.DUT fifo_if);
	localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

	reg [fifo_if.FIFO_WIDTH - 1 : 0] mem [fifo_if.FIFO_DEPTH - 1 : 0];

	reg [max_fifo_addr - 1 : 0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			wr_ptr <= 0;
			fifo_if.wr_ack <= 0;
			fifo_if.overflow <= 0;
		end
		else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
			mem[wr_ptr] <= fifo_if.data_in;
			fifo_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			fifo_if.wr_ack <= 0; 
			if (fifo_if.wr_en)
				fifo_if.overflow <= 1;
			else
				fifo_if.overflow <= 0;
		end
	end

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			rd_ptr <= 0;
			fifo_if.underflow <= 0;
		end
		else if (fifo_if.rd_en && count != 0) begin
			fifo_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end else if (fifo_if.empty && fifo_if.rd_en) begin
			fifo_if.underflow <= 1;
		end else begin
			fifo_if.underflow <= 0;
		end
	end

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
				count <= count + 1;
			else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
				count <= count - 1;
			else if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full) 
				count <= count - 1;
			else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty)
				count <= count + 1;
		end
	end

	assign fifo_if.full = (count == fifo_if.FIFO_DEPTH)? 1 : 0;
	assign fifo_if.empty = (count == 0)? 1 : 0;
	assign fifo_if.almostfull = (count == fifo_if.FIFO_DEPTH - 1)? 1 : 0; 
	assign fifo_if.almostempty = (count == 1)? 1 : 0;

	`ifdef SIM
		property IsFullEmpty;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) !(fifo_if.full && fifo_if.empty);
		endproperty

		property IsEmpty;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count == 0 |-> fifo_if.empty == 1;
		endproperty

		property IsNotEmpty;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count != 0 |-> fifo_if.empty == 0;
		endproperty

		property IsAlmostEmpty;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count == 1 |-> fifo_if.almostempty == 1;
		endproperty

		property IsFull;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count == fifo_if.FIFO_DEPTH |-> fifo_if.full == 1;
		endproperty

		property IsNotFull;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count != fifo_if.FIFO_DEPTH |-> fifo_if.full == 0;
		endproperty

		property IsAlmostFull;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count == fifo_if.FIFO_DEPTH - 1 |-> fifo_if.almostfull == 1;
		endproperty

		property IsOverflow;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) (fifo_if.full && fifo_if.wr_en) |=> fifo_if.overflow == 1;
		endproperty

		property IsUnderflow;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) (fifo_if.empty && fifo_if.rd_en) |=> fifo_if.underflow == 1;
		endproperty

		property IsWriteAck;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) (!fifo_if.full && fifo_if.wr_en) |=> fifo_if.wr_ack == 1;
		endproperty

		property wr_ptr_wrap;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
				(!fifo_if.full && fifo_if.wr_en && wr_ptr == fifo_if.FIFO_DEPTH - 1) |=> wr_ptr == 0;
		endproperty

		property rd_ptr_wrap;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
				(!fifo_if.empty && fifo_if.rd_en && rd_ptr == fifo_if.FIFO_DEPTH - 1) |=> rd_ptr == 0;
		endproperty

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_empty: assert final(fifo_if.empty == 1);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_full: assert final(fifo_if.full == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_almostempty: assert final(fifo_if.almostempty == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_almostfull: assert final(fifo_if.almostfull == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_overflow: assert final(fifo_if.overflow == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_underflow: assert final(fifo_if.underflow == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_wr_ack: assert final(fifo_if.wr_ack == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_wr_ptr: assert final(wr_ptr == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_rd_ptr: assert final(rd_ptr == 0);
			end
		end

		always_comb begin
			if (!fifo_if.rst_n) begin
				a_reset_count: assert final(count == 0);
			end
		end

		always_comb begin
			a_wr_ptr_threshold: assert final(wr_ptr < fifo_if.FIFO_DEPTH);
		end

		always_comb begin
			a_rd_ptr_threshold: assert final(rd_ptr < fifo_if.FIFO_DEPTH);
		end

		always_comb begin
			a_count_threshold: assert final(count <= fifo_if.FIFO_DEPTH);
		end

		a_IsFullEmpty: assert property (IsFullEmpty);
		c_IsFullEmpty: cover property (IsFullEmpty);

		a_IsEmpty: assert property (IsEmpty);
		c_IsEmpty: cover property (IsEmpty);

		a_IsNotEmpty: assert property (IsNotEmpty);
		c_IsNotEmpty: cover property (IsNotEmpty);

		a_IsAlmostEmpty: assert property (IsAlmostEmpty);
		c_IsAlmostEmpty: cover property (IsAlmostEmpty);

		a_IsFull: assert property (IsFull);
		c_IsFull: cover property (IsFull);

		a_IsNotFull: assert property (IsNotFull);
		c_IsNotFull: cover property (IsNotFull);

		a_IsAlmostFull: assert property (IsAlmostFull);
		c_IsAlmostFull: cover property (IsAlmostFull);

		a_IsOverflow: assert property (IsOverflow);
		c_IsOverflow: cover property (IsOverflow);

		a_IsUnderflow: assert property (IsUnderflow);
		c_IsUnderflow: cover property (IsUnderflow);

		a_IsWriteAck: assert property (IsWriteAck);
		c_IsWriteAck: cover property (IsWriteAck);

		a_wr_ptr_wrap: assert property (wr_ptr_wrap);
		c_wr_ptr_wrap: cover property (wr_ptr_wrap);

		a_rd_ptr_wrap: assert property (rd_ptr_wrap);
		c_rd_ptr_wrap: cover property (rd_ptr_wrap);
	`endif
endmodule