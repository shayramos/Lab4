module controllerMemory(input clock, input reset, input[4:0] indiceMemory, input next,
								//input [15:0]addr, input [15:0]dataIn, 
								output reg [15:0]dataOut, output reg finishMusic);

//output reg [15:0]dataOut;
reg [15:0]finalPosition;
reg [15:0]actualPosition;

reg [15:0]addr;

reg [2:0] state, next_state;
wire [15:0] dataOut_next;

wire readEN;
wire _end;
wire [15:0] memAddr, memOut;

parameter 	IDLE = 2'b000,
				GET_INITIAL = 2'b001,
				WAIT_INITIAL = 2'b010,
				GET_FINAL = 2'b011,
				WAIT_FINAL = 2'b100,
				GET_ADDR = 2'b101,
				WAIT_ADDR = 2'b110;
	 
	 fetchMemory ftMem( .clock(clock),
								.reset(reset),
                        .start(next),
								.addr(addr),
								.addrOut(memAddr),
								.dataIn(memOut),
								.dataOut(dataOut_next),								
								._end(_end),
								.read(readEN)
						  );
						  
						  	romMemory rom(		.address(memAddr),
							.clock(clock),
							.rden(readEN),
							.q(memOut));

							
always@(posedge clock) begin
	if(reset) begin
		dataOut <= 0;
		state <= 0;
		actualPosition <= 0;
	end
	else begin
		dataOut <= dataOut_next;
		state <= next_state;
		if (state == WAIT_ADDR && _end == 1)begin
			actualPosition <= actualPosition + 1;
		end
		if (state == WAIT_INITIAL && _end == 1)begin
			actualPosition <= dataOut_next;
		end
	end
end


always@(*) begin
	case(state)
		IDLE: begin
			if(next) begin
				next_state = GET_INITIAL;
			end else begin
				next_state = IDLE;
			end
		end
		GET_INITIAL: begin
			next_state = WAIT_INITIAL;
		end
		WAIT_INITIAL: begin
			if(_end) begin
				next_state = GET_FINAL;
			end
			else begin
				next_state = WAIT_INITIAL;
			end
		end
		GET_FINAL: begin
			next_state = WAIT_FINAL;
		end
		WAIT_FINAL: begin
			if(_end) begin
				next_state = GET_ADDR;
			end
			else begin
				next_state = WAIT_FINAL;
			end
		end
		GET_ADDR: begin
			if(actualPosition>finalPosition) begin
				next_state = IDLE;
			end
			else begin
				next_state = WAIT_ADDR;
			end
		end
		WAIT_ADDR: begin
			if(_end) begin
				next_state = GET_ADDR;
			end
			else begin
				next_state = WAIT_ADDR;
			end
		end
	endcase
end

always@(*) begin
	finishMusic = 0;
	case(state)
		IDLE: begin
		end
		GET_INITIAL: begin
			addr = indiceMemory*2;
		end
		WAIT_INITIAL: begin
			addr = indiceMemory*2;
		end
		GET_FINAL: begin
			addr = indiceMemory*2 + 1;
		end
		WAIT_FINAL: begin
			addr = indiceMemory*2+1;
			if (_end) begin
				finalPosition = dataOut_next;
			end
		end
		GET_ADDR: begin
			addr = actualPosition;
			if (actualPosition>finalPosition) begin
				finishMusic = 1;
			end
		end
		WAIT_ADDR: begin
			addr = actualPosition;
		end
	endcase
end

endmodule
