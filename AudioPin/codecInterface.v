module codecInterface(	input clock,
						input reset,
						input [15:0] dataIn,
						//input sendData,
						output bclk,
						output codec_clk,
						output lrck,
						output reg lrck_last,
						output data
						//output reg wordSent
						);
	
	parameter fs = 48000,
				 data_width = 16,
				 channels_number = 2,
				 clk_frequency = 50000000;
	
	//wire [3:0] data_index;
	wire [2:0]  bclk_next;
	reg [4:0] lrck_counter;
	wire [4:0] lrck_next;
	wire [15:0] reg_data;
	reg [1:0] codec_clk_counter;
	reg [2:0] bclk_counter;
	wire codec_clk_cycle_12_5, bclk_posedge, bclk_negedge, lrck_posedge;
	wire [1:0] codec_clk_next;
	reg bclk_last;
	
	wire [31:0] dataBufferNext;
	reg [31:0] dataBuffer;
	
	clkdiv pll( .areset(reset),
					.inclk0(clock),
					.c0(codec_clk)
					);
	
	
	
	//quando coloca sendData, salva a palavra a ser enviada
//	always @ (posedge sendData) begin
//		reg_data <= dataIn;
//	end
	
	always @ (posedge clock) begin
		if (reset) begin
			codec_clk_counter <= 0;
			bclk_counter <= 0;
			dataBuffer <= 0;
			lrck_counter <= 0;
			bclk_last <= 0;
			lrck_last <= 0;
		end
		else begin
			codec_clk_counter <= codec_clk_next;
			bclk_counter <= bclk_next;
			bclk_last <= bclk;
			lrck_counter <= lrck_next;
			lrck_last <= lrck;
			dataBuffer <= dataBufferNext;
		end
	end
	
	assign codec_clk_next = codec_clk_counter + 1; //divisor de frequencia por 4
	//assign codec_clk = codec_clk_counter[1];
	
	assign codec_clk_cycle_12_5 = (codec_clk_counter == 0) ? 1 : 0 ; //1 quando termina o periodo do codec_clk
	assign bclk = bclk_counter[2];
	assign bclk_next = bclk_counter + 1;
	assign bclk_posedge = bclk & ~bclk_last;
	assign bclk_negedge = ~bclk & bclk_last;
	assign lrck = lrck_counter[4];
	assign lrck_next = (bclk_negedge) ? lrck_counter + 1 : lrck_counter;
	assign lrck_posedge = ~lrck_last & lrck;
	//se acabou os 32 bits, pega palavra nova. senão, caso esteja no negedge do clk, desloca para a direita.
	assign dataBufferNext = (lrck_posedge) ? {dataIn, dataIn} : (bclk_negedge) ? {dataBuffer[30:0], 1'b0 } : dataBuffer ;
	assign data = dataBuffer[31];
	
	
	
	//calculo do bclk
	/*
	
	assign data = reg_data[~data_index];
	
	always @ (negedge clock) begin
		if (reset) begin
			bclk_temp <= 0;
			bclk_counter <= 0;
		end
		else begin
			if (bclk_counter >= clk_frequency/(fs*data_width*channels_number*2) - 1) begin
				bclk_temp <= ~bclk_temp;
				bclk_counter <= 0;
			end
			else begin
				bclk_counter <= bclk_counter + 1;
			end
		end
	end
	*/
	//calculo do lrck
	/*always @ (negedge clock) begin
		if (reset) begin
			lrck <= 0;
			lrck_counter <= 0;
		end
		else begin
			if (lrck_counter >= clk_frequency/(fs*2) - 1) begin
				lrck <= ~lrck;
				lrck_counter <= 0;
				if (lrck == 1) begin //na virada de 1 para 0 do lrck a palavra foi enviada 2x
					wordSent <= 1;
				end
				else begin
					wordSent <= 0;
				end
			end
			else begin
				lrck_counter <= lrck_counter + 1;
			end
			
		end
	end

	always @ (negedge bclk) begin
		if (reset) begin
			data_index <= 0;
		end
		else begin
			data_index <= data_index + 1;
		end
	end*/
	
	
endmodule
