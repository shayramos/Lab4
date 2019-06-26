module i2cController(	input clock12_5,
								input reset,
								input [23:0] dataIn,
								output sclk,
								output reg sdata,
								output reg finished
								);
								

	localparam 	IDLE = 4'b1001,
					START = 4'b0000,
					R_ADDR = 4'b0001,
					RW = 4'b0010,
					ACK1 = 4'b0011,
					DATA1 = 4'b0100,
					ACK2 = 4'b0101,
					DATA2 = 4'b0110,
					ACK3 = 4'b0111,
					END = 4'b1000;

	reg [3:0] state, next_state;
	reg [4:0] dataIndex, dataIndexNext;
	assign sclk = (state == END || state == IDLE) ? 1'b1 : clock12_5 ;
	
	always @ (*) begin
		case (state)
			START: begin
				next_state = R_ADDR;
			end
			R_ADDR: begin
				if (dataIndex > 5'd16) begin
					next_state = R_ADDR;
				end
				else begin
					next_state = RW;
				end
			end
			RW: begin
				next_state = ACK1;
			end
			ACK1: begin
				next_state = DATA1;
			end
			DATA1: begin
				if (dataIndex > 5'd7) begin
					next_state = DATA1;
				end
				else begin
					next_state = ACK2;
				end
			end
			ACK2: begin
				next_state = DATA2;
			end
			DATA2: begin
				if (dataIndex >= 5'd0 && dataIndex < 5'd8) begin
					next_state = DATA2;
				end
				else begin
					next_state = ACK3;
				end
			end
			ACK3: begin
				next_state = END;
			end
			END: begin
				next_state = END;
			end
			IDLE: begin
				next_state = START;
			end
			default: begin
				next_state = START;
			end
		endcase
	end
	
	always @ (posedge clock12_5) begin
		if (reset) begin
			state <= IDLE;
			dataIndex <= 5'd23;
		end
		else begin
			state <= next_state;
			dataIndex <= dataIndexNext;
		end
	end
	
	always @ (*) begin
		sdata = 1;
		dataIndexNext = dataIndex;
		finished = 0;
		case (state)
			START: begin
				sdata = 0;
			end
			R_ADDR: begin
				dataIndexNext = dataIndex - 1;
				sdata = dataIn[dataIndex];
			end
			RW: begin
				dataIndexNext = dataIndex - 1;
				sdata = dataIn[dataIndex];
			end
			ACK1: begin
				sdata = 0;
			end
			DATA1: begin
				dataIndexNext = dataIndex - 1;
				sdata = dataIn[dataIndex];
			end
			ACK2: begin
				sdata = 0;
			end
			DATA2: begin
				dataIndexNext = dataIndex - 1;
				sdata = dataIn[dataIndex];
			end
			ACK3: begin
				sdata = 0;
			end
			END: begin
				finished = 1;
			end
			IDLE: begin
				sdata = 0;
			end
		endcase
	end

endmodule
