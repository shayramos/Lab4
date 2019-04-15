module memoController(	input clock,
						input reset,
						input [15:0] dataIn,
						input readEn,
						input writeEn,
						input [20:0] addrInitial,
						output [15:0] dataOut,
						output [20:0] addrOut
						);
						
	reg [20:0] addrFinal;
	reg [20:0] add;
	reg [1:0] state, next_state;

	parameter INICIO = 2'b00,
				IDLE = 2'b01,
				READDATA = 2'b10;
				
	
	always@(posedge clock) begin
	
		if(reset) begin
			state <= INICIO;
			dataOut <= 0;
		end
		else begin
			state <= next_state;
			if (readEn) begin
				dataOut <= dataIn;
			end
		end
	end
	
	//Decodificador de entrada
	always @ (*) begin
		readEn = 0;
		writeEn = 0;
		case (state)
			INICIO: begin
				next_state = state;
			end
		endcase
	
	end
	
	//Decodificador de saida
   always @ (*) begin
		  /*  ...  */

	end
	
endmodule
