module fetchMemory(input clock, input reset, input [15:0]addr, input [15:0]dataIn, 
						output reg [15:0]dataOut, output reg [15:0]addrOut, output _end, output reg read);


reg[1:0] state, next_state;
reg[15:0] dataOut_next;

parameter 	BEGIN = 2'b00,
				SET_ADDR = 2'b01,
				READ = 2'b10,
				END = 2'b11;

assign _end = state == END;
always@(posedge clock) begin

	if(reset) begin
		dataOut <= 0;
		state <= 0;
	end
	else begin
		dataOut <= dataOut_next;
		state <= next_state;
	end
end

always@(*) begin
	case(state)
		BEGIN: begin
			next_state = SET_ADDR;
		end
		SET_ADDR: begin
			next_state = READ;
		end
		READ: begin
			next_state = END;
		end
		END: begin
			next_state = END;
		end
	endcase
end

always@(*) begin
	dataOut_next = dataOut;
	addrOut = 0;
	read = 0;
	case(state)	
		BEGIN: begin
		end
		SET_ADDR: begin
			read = 1;
			addrOut = addr;
		end
		READ: begin
			read = 1;
			addrOut = addr;
			dataOut_next = dataIn;
		end
		END: begin
		end
	endcase
end

endmodule
