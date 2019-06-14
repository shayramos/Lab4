module i2cController(	input clock12_5,
								input reset,
								input [23:0] dataIn,
								output sclk,
								output sdata);
								

	localparam 	START = 3'b000,
					R_ADDR = 3'b001,
					RW = 3'b010,
					ACK1 = 3'b011,
					DATA1 = 3'b100,
					ACK2 = 3'b101,
					DATA2 = 3'b110,
					END = 3'b111;

	reg [2:0] state, next_state;
	assign sclk = clock12_5;
	
	always @ (*) begin
		case (state)
			START: begin
				
			end
		
		endcase
	end
	
	always @ (posedge clock12_5) begin
		if (reset) begin
			state <= 0;
		end
		else begin
			state <= next_state;
		end
	end

endmodule
