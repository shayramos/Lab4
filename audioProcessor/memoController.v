module memoController(	input clock,
						input reset,
						input [15:0] dataIn,
						input [20:0] addrInitial,
						output reg readEn,
//						output writeEn,
						output reg [15:0] dataOut
//						output reg [20:0] addrOut
						);
						
	reg [20:0] addrFinal;
	reg [20:0] addr;
	reg [1:0] state, next_state;

	parameter INICIO = 3'b000,
				IDLE = 3'b001,
				READDATA = 3'b010,
				WAIT = 3'b011,
				OUTDATA = 3'b100,
				INPUTSTATE = 3'b101;

		
	always@(posedge clock) begin
	
		if(reset) begin
			state <= INICIO;
			addr <= 0;
		end
		else begin
			if(next_state==INPUTSTATE) begin
				addr <= 0;
			end
			
			if(next_state==INICIO && addr<addrFinal) begin
				addr <= addr + 1;
			end
			else begin
				addr <= 0;
			end
			
			if(next_state==READDATA && addr==0) begin
				addr <= addrInitial;
			end
			state <= next_state;
		end
	end
	
	//Decodificador de entrada
	always @ (*) begin
		next_state = INICIO;
		case (state)
			INPUTSTATE: begin
				next_state = INICIO;
			end
			INICIO: begin
				next_state = READDATA;
			end
			READDATA: begin
				next_state = WAIT;
			end
			WAIT: begin
				next_state = OUTDATA;
			end
			OUTDATA: begin
				next_state = IDLE;
			end
			IDLE: begin
				if(addr>addrFinal) begin
					next_state = INPUTSTATE;
				end
				else begin
					next_state = INICIO;
				end
			end
		endcase
	
	end
	
	//Decodificador de saida
   always @ (*) begin
		readEn = 0;
//		writeEn = 0;
		case (state)
			INPUTSTATE: begin
				addrFinal = 0;
//				addrOut = 0;
			end
			INICIO: begin
				readEn = 0;
//				writeEn = 0;
			end
			READDATA: begin
				readEn = 1;
//				addrOut = addr;
				if(addrFinal==0) begin
					addrFinal = addrInitial + 1;
				end
			end
			WAIT: begin
			end
			OUTDATA: begin
				dataOut[15:0] = dataIn[15:0];
			end
			IDLE: begin
			end
		endcase
	end
	
endmodule
