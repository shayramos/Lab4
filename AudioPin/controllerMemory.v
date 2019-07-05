module controllerMemory(input clock, input reset, input[4:0] indiceMemory, input lrck, input lrck_last,
								//input [15:0]addr, input [15:0]dataIn, 
								output reg [15:0]dataOut, output finishMusic);

reg [15:0]finalPosition, finalPosition_next, initialPosition, initialPosition_next;
wire [15:0] fetchOut;
reg next, finishMusicNext;

reg [4:0] indiceMemory_next, indiceMemory_reg;
reg [15:0]addr, addr_next;

reg [3:0] state, next_state;
reg [15:0] dataOut_next;

wire fetchReset;

wire readEN;
wire _end;
wire [15:0] memAddr, memOut;

parameter 	BEGIN = 4'b0000,
				GET_INITIAL = 4'b0001,
				WAIT_INITIAL = 4'b0010,
				GET_FINAL = 4'b0011,
				WAIT_FINAL = 4'b0100,
				GET_ADDR = 4'b0101,
				WAIT_ADDR = 4'b0110,
				SET_BEGINNING = 4'b0111,
				END = 4'b1000;
				
	assign fetchReset = reset | next; // a máquina fetchMemory será resetada quando o sinal "next" estiver em um, além do reset.
	assign finishMusic = state == END; 
	 
	fetchMemory ftMem( 	.clock(clock),
								.reset(fetchReset),
								.addr(addr),
								.addrOut(memAddr),
								.dataIn(memOut),
								.dataOut(fetchOut),								
								._end(_end),
								.read(readEN)
						  );
						  
						  	romMemory rom(	.address(memAddr),
												.clock(clock),
												.rden(readEN),
												.q(memOut));

							
always@(posedge clock) begin
	if(reset) begin
		dataOut <= 0;
		state <= BEGIN;
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
		BEGIN: begin
			next_state = GET_INITIAL;
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
			if(addr == finalPosition) begin
				next_state = END;
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
		END: begin
			next_state = END;
		end
	endcase
end

always@(*) begin
	finalPosition_next = finalPosition;
	addr_next = addr;
	next = 0;
	indiceMemory_next = indiceMemory_reg;
	initialPosition_next = initialPosition;
	dataOut_next = dataOut;
	case(state)
		BEGIN: begin
			indiceMemory_next = indiceMemory;
		end
		GET_INITIAL: begin
			addr_next = {indiceMemory_reg, 1'b0};
			next = 1;
		end
		WAIT_INITIAL: begin
			addr_next = {indiceMemory_reg, 1'b0};
			if (_end) begin
				initialPosition_next = fetchOut;
			end
		end
		GET_FINAL: begin
			addr_next = {indiceMemory_reg, 1'b1};
			next = 1;
		end
		WAIT_FINAL: begin
			addr_next = {indiceMemory_reg, 1'b1};
			if (_end) begin
				finalPosition_next = fetchOut;
			end
		end
		SET_BEGINNING: begin
			addr_next = initialPosition - 1;
		end
		GET_ADDR: begin
			addr_next = addr + 1;
			next = 1;
			if (addr == finalPosition) begin
			end
		end
		WAIT_ADDR: begin
			addr_next = addr;
			if (_end && lrck_last && !lrck) begin
				dataOut_next = fetchOut;
			end
		end
	endcase
end

endmodule
