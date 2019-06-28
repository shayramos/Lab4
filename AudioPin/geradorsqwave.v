module geradorsqwave(input clock, input reset, output reg [15:0] data);


	reg [5:0] ramp;
	reg count, next_count;
	
	always @ (negedge clock) begin
		if (reset) begin
			ramp <= 0;
			count <= 0;
		end else begin
			count <= next_count;
			if (next_count) begin
				ramp <= ramp + 1;
			end
		end
	end
	always @ (*) begin
		next_count = !count;
	end

always@(ramp[5:0])
begin
    case(ramp[5:0])
 0 :	data=16'hFFFF;
 1 :	data=16'hFFFF;
 2 :	data=16'hFFFF;
 3 :	data=16'hFFFF;
 4 :	data=16'hFFFF;
 5 :	data=16'hFFFF;
 6 :	data=16'hFFFF;
 7 :	data=16'hFFFF;
 8 :	data=16'hFFFF;
 9 :	data=16'hFFFF;
 10 :	data=16'hFFFF;
 11 :	data=16'hFFFF;
 12 :	data=16'hFFFF;
 13 :	data=16'hFFFF;
 14 :	data=16'hFFFF;
 15 :	data=16'hFFFF;
 16 :	data=16'hFFFF;
 17 :	data=16'hFFFF;
 18 :	data=16'hFFFF;
 19 :	data=16'hFFFF;
 20 :	data=16'hFFFF;
 21 :	data=16'hFFFF;
 22 :	data=16'hFFFF;
 23 :	data=16'hFFFF;
 24 :	data=16'hFFFF;
 25 :	data=16'hFFFF;
 26 :	data=16'hFFFF;
 27 :	data=16'hFFFF;
 28 :	data=16'hFFFF;
 29 :	data=16'hFFFF;
 30 :	data=16'hFFFF;
 31 :	data=16'hFFFF;
 32 :	data=16'h1FFF;
 33 :	data=16'h1FFF;
 34 :	data=16'h1FFF;
 35 :	data=16'h1FFF;
 36 :	data=16'h1FFF;
 37 :	data=16'h1FFF;
 38 :	data=16'h1FFF;
 39 :	data=16'h1FFF;
 40 :	data=16'h1FFF;
 41 :	data=16'h1FFF;
 42 :	data=16'h1FFF;
 43 :	data=16'h1FFF;
 44 :	data=16'h1FFF;
 45 :	data=16'h1FFF;
 46 :	data=16'h1FFF;
 47 :	data=16'h1FFF;
 48 :	data=16'h1FFF;
 49 :	data=16'h1FFF;
 50 :	data=16'h1FFF;
 51 :	data=16'h1FFF;
 52 :	data=16'h1FFF;
 53 :data=16'h1FFF;
 54 :data=16'h1FFF;
 55 :data=16'h1FFF;
 56 :data=16'h1FFF;
 57 :data=16'h1FFF;
 58 :data=16'h1FFF;
 59 :data=16'h1FFF;
 60 :data=16'h1FFF;
 61 :data=16'h1FFF;
 62 :data=16'h1FFF;
 63 :data=16'h1FFF;
default	:data=0;
	endcase
end


endmodule
