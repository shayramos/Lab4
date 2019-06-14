module memoController(	input clock,
						input reset,
						input [15:0] dataIn,
						input [15:0] addrInitial,
						input readData,
						output reg readEn,
						output reg [15:0] dataOut,
						output reg [15:0] addrOut,
						output reg available,
						output musicEnded
						);

	reg [15:0] addrFinal, addrFinal_next;
	//de 0 até 15 guarda o endereço inicial, e de 16 até 31 guarda o endereço final
	reg [31:0] addr;
	reg [3:0] state, next_state;
	reg [1:0] first;
	
	assign musicEnded = addrOut == addrFinal;
	
	parameter INPUTSTATE = 4'b0000,
				READADDR = 4'b0001,
				WAIT1 = 4'b0010,
				STOREADDR = 4'b0011,
				WAIT2 = 4'b0100,
				ITADDR = 4'b0101,
				WAIT3 = 4'b0110,
				OUTDATA = 4'b0111,
				WAIT4 = 4'b1000;


	always@(posedge clock) begin
		if(reset) begin
			state <= INPUTSTATE;
			addrOut <= 0;
		end
		else begin
			if(next_state==INPUTSTATE) begin
				addrOut <= 0;
			end
			if(next_state==READADDR) begin
				if(first==1) begin
					addrOut <= addrInitial;
				end
				else begin
					addrOut <= addrInitial+1;
				end
			end
			if(next_state==ITADDR) begin
				addrOut <= addrOut + 1;
			end
			if (next_state==READADDR || next_state == INPUTSTATE) begin
				addrFinal <= addrFinal_next;
			end
		end
	end
	
	//Decodificador de entrada
	always @ (*) begin
		next_state = INPUTSTATE;
		case (state)
			INPUTSTATE: begin
				if(readData) begin
					next_state = READADDR;
				end
				else begin
					next_state = INPUTSTATE;
				end
			end
			READADDR: begin
				next_state = WAIT1;
			end
			WAIT1: begin
				next_state = STOREADDR;
			end
			STOREADDR: begin
				if(first==1) begin
					next_state = WAIT2;
				end
				else begin
					if(first==2) begin
						next_state = READADDR;
					end
				end
			end
			WAIT2: begin
				next_state = ITADDR;
			end
			ITADDR: begin
				next_state = WAIT3;
			end
			WAIT3: begin
				next_state = OUTDATA;
			end
			OUTDATA: begin
				next_state = WAIT4;
			end
			WAIT4: begin
				if(addr[15:0]>=addrFinal && readData==1) begin
					next_state = WAIT2;
				end
				else begin
					if(addr[15:0]<addrFinal) begin
						next_state = INPUTSTATE;
					end
					else begin 
						if(readData==0) begin 
							next_state = WAIT4;
						end
					end
				end
			end
		endcase
	end
	
	//Decodificador de saida
   always @ (*) begin
		readEn = 0;
		available = 0;
		first = 1;
		addr = 0;
		dataOut = 0;
		addrFinal_next = 0;
		case (state)
			INPUTSTATE: begin
				first = 1;
			end
			READADDR: begin
				readEn = 1;
			end
			WAIT1: begin
			end
			STOREADDR: begin
				if(first==1) begin
					addr[15:0] = dataIn;
					first = 2;
				end
				else begin
					addr[31:16] = dataIn;
					first = 1;
					addrFinal_next = addr[31:16];
//					dataOut = addr[15:0];
				end
			end
			WAIT2: begin
			end
			ITADDR: begin
				readEn = 1;
			end
			WAIT3: begin
			end
			OUTDATA: begin
				dataOut = dataIn;
				available = 1;
			end
			WAIT4: begin
				available = 1;
			end
		endcase
	end
	
endmodule
