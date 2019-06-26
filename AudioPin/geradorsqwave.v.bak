module geradorsqwave(input clock, input reset, output [15:0] data);


	reg [15:0] counter;
	
	always @ (posedge clock) begin
		if (reset) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end

	assign data = (counter[15] == 1) ? 16'b0111111111111111 : 16'b0000000000000000 ; 

endmodule
