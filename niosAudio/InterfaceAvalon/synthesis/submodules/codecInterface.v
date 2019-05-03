module codecInterface(	input clock,
						input reset,
						input [15:0] dataIn,
						input sendData,
						output reg bclk,
						output reg lrck,
						output data,
						output reg wordSent
						);
	
	parameter fs = 9600,
				 data_width = 24,
				 channels_number = 2,
				 clk_frequency = 49766400, //usar pll para essa frequencia
				 blck_counter_max = clk_frequency/(fs*data_width*channels_number*2) - 1, //
				 lrck_counter_max = clk_frequency/(fs*2) - 1;
	
	reg [3:0] data_index;
	reg [7:0] bclk_counter;
	reg [11:0] lrck_counter;
	reg [15:0] reg_data;
	reg [7:0] bclk_counter_max;
	
	assign data = reg_data[~data_index];

	//quando coloca sendData, salva a palavra a ser enviada
	always @ (posedge sendData) begin
		reg_data <= dataIn;
	end
	
	//calculo do bclk
	always @ (negedge clock) begin
		if (reset) begin
			bclk <= 0;
			bclk_counter <= 0;
		end
		else begin
			if (bclk_counter >= clk_frequency/(fs*data_width*channels_number*2) - 1) begin
				bclk <= ~bclk;
				bclk_counter <= 0;
			end
			else begin
				bclk_counter <= bclk_counter + 1;
			end
		end
	end

	//calculo do lrck
	always @ (negedge clock) begin
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
	end
	
	
endmodule
