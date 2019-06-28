module controllerMemory(input clock, input reset, input[4:0] indiceMemory, input start, input lrck, input lrck_last,
								//input [15:0]addr, input [15:0]dataIn, 
								output reg [15:0]dataOut, output reg finishMusic);

reg [15:0]finalPosition, finalPosition_next, initialPosition, initialPosition_next;
reg next;

reg [4:0] indiceMemory_next, indiceMemory_reg;
reg [15:0]addr, addr_next;

reg [2:0] state, next_state;
wire [15:0] dataOut_next;

wire readEN;
wire _end;
wire [15:0] memAddr, memOut;

parameter 	IDLE = 3'b000,
				GET_INITIAL = 3'b001,
				WAIT_INITIAL = 3'b010,
				GET_FINAL = 3'b011,
				WAIT_FINAL = 3'b100,
				GET_ADDR = 3'b101,
				WAIT_ADDR = 3'b110,
				SET_BEGINNING = 3'b111;
	 
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
		finalPosition <= 0;
		addr <= 0;
		indiceMemory_reg <= 0;
		initialPosition <= 0;
	end
	else begin
		dataOut <= dataOut_next;
		state <= next_state;
		addr <= addr_next;
		indiceMemory_reg <= indiceMemory_next;
		finalPosition <= finalPosition_next;
		initialPosition <= initialPosition_next;
	end
end


always@(*) begin
	case(state)
		IDLE: begin
			if(start) begin
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
				next_state = SET_BEGINNING;
			end
			else begin
				next_state = WAIT_FINAL;
			end
		end
		SET_BEGINNING: begin
			next_state = GET_ADDR;
		end
		GET_ADDR: begin
			if(addr > finalPosition) begin
				next_state = IDLE;
			end
			else begin
				next_state = WAIT_ADDR;
			end
		end
		WAIT_ADDR: begin
			if(_end && lrck_last && !lrck) begin
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
	finalPosition_next = finalPosition;
	addr_next = addr;
	next = 0;
	indiceMemory_next = indiceMemory_reg;
	initialPosition_next = initialPosition;
	case(state)
		IDLE: begin
			indiceMemory_next = indiceMemory;
		end
		GET_INITIAL: begin
			addr_next = {indiceMemory_reg, 1'b0};
			next = 1;
		end
		WAIT_INITIAL: begin
			addr_next = {indiceMemory_reg, 1'b0};
			if (_end) begin
				initialPosition_next = dataOut_next;
			end
		end
		GET_FINAL: begin
			addr_next = {indiceMemory_reg, 1'b1};
			next = 1;
		end
		WAIT_FINAL: begin
			addr_next = {indiceMemory_reg, 1'b1};
			if (_end) begin
				finalPosition_next = dataOut_next;
			end
		end
		SET_BEGINNING: begin
			addr_next = initialPosition - 1;
		end
		GET_ADDR: begin
			addr_next = addr + 1;
			next = 1;
			if (addr > finalPosition) begin
				finishMusic = 1;
			end
		end
		WAIT_ADDR: begin
			addr_next = addr;
		end
	endcase
end

endmodule
