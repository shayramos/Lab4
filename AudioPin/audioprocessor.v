module audioProcessor(  input clock, //interface para Avalon
                        input reset,
                        input [15:0] writedata, //writedata = endereço do som
                        input read, //
                        input write, //sinal do avalon para startar
                        output [31:0] readdata,
                        output lrck, //saidas para codec
                        output bclk, 
                        output codecSerialData,
								output codec_clk,
								output sclk,
								output sdata,
								output [15:0] addr,
								output [15:0] dataParallel
                        );

    parameter   BEGIN = 								5'h0,
                GET_INDEX = 							5'h1,
                WAIT_MUSIC = 							5'h2,
					 CONFIG_RESET = 						5'h3,
					 SEND_CONFIG_RESET = 				5'h4,
					 CONFIG_LH_OUT = 						5'h5,
					 SEND_CONFIG_LH_OUT = 				5'h6,
					 CONFIG_RH_OUT = 						5'h7,
					 SEND_CONFIG_RH_OUT = 				5'h8,
					 CONFIG_ANALOG_AUDIO_PATH = 		5'h9,
					 SEND_CONFIG_ANALOG_AUDIO_PATH = 5'hA,
					 CONFIG_DAI = 							5'hB,
					 SEND_CONFIG_DAI = 					5'hC,
					 CONFIG_SAMPL_CONTROL = 			5'hD,
					 SEND_CONFIG_SAMPL_CONTROL = 		5'hE,
					 IDLE = 									5'hF;

    //reg [31:0] savedWriteData;
    reg [4:0] state, next_state, addr_initial, addr_next;
	 //indica que a palavra está disponível
	 //sinal que diz para o controlador ler a palavra da memoria
	 reg readMemoryData;
	 //palavra da memoria
	 wire [15:0] dataFromMemory;
	 //endereço da musica a ser tocada
	 wire musicEnded, controllerReset;
	 wire codecReset, lrck_last;
	 reg codecCombReset, i2cCombReset;
	 
	 wire i2cReset, i2cFinished;	 
	 reg [23:0] codecConfig;
	 
	 assign i2cReset = reset | i2cCombReset;
	 assign codecReset = reset | codecCombReset;
	 assign controllerReset = reset | readMemoryData;
	 assign dataParallel = dataFromMemory;
	 
	 /*wire [15:0] datagerador;
	 geradorsqwave gerador( .clock(lrck),
									.reset(reset),
									.data(datagerador));
	 
	 codecInterface codecInt2( .clock(clock),
                                .reset(reset),
                                .dataIn(datagerador),
										  .codec_clk(codec_clk),
                                .bclk(bclk),
                                .lrck(lrck),
										  .lrck_last(lrck_last),
                                .data(codecSerialData)
										  );*/

	 
    codecInterface codecInt(   .clock(clock),
                                .reset(codecReset),
                                .dataIn(dataFromMemory),
										  .codec_clk(codec_clk),
                                .bclk(bclk),
                                .lrck(lrck),
										  .lrck_last(lrck_last),
                                .data(codecSerialData));
										  
										
										
	controllerMemory memoInt( 	.clock(clock),
										.reset(controllerReset),
										.indiceMemory(addr_initial),
										.dataOut(dataFromMemory),
										.finishMusic(musicEnded),
										.lrck(lrck),
										.lrck_last(lrck_last),
										.addr(addr)
									);										
							
	i2cController contr( 	.clock12_5(codec_clk),
									.reset(i2cReset),
									.dataIn(codecConfig),
									.sclk(sclk),
									.sdata(sdata),
									.finished(i2cFinished)
									);
	
    always @ (posedge clock) begin
        if (reset) begin
            state <= BEGIN;
				addr_initial <= 0;
        end
        else begin
            state <= next_state;
				addr_initial <= addr_next;
        end
    end
    
    //Decodificador de proximo estado
    always @ (*) begin
        case (state)
				BEGIN: begin
					next_state = CONFIG_RESET;
				end
				CONFIG_RESET: begin
					next_state = SEND_CONFIG_RESET;
				end
				SEND_CONFIG_RESET: begin
					if (i2cFinished) begin
						next_state = CONFIG_LH_OUT;
					end else begin
						next_state = SEND_CONFIG_RESET;
					end
				end
				CONFIG_LH_OUT: begin
					next_state = SEND_CONFIG_LH_OUT;
				end
				SEND_CONFIG_LH_OUT: begin
					if (i2cFinished) begin
						next_state = CONFIG_RH_OUT;
					end else begin
						next_state = SEND_CONFIG_LH_OUT;
					end
				end
				CONFIG_RH_OUT: begin
					next_state = SEND_CONFIG_RH_OUT;
				end
				SEND_CONFIG_RH_OUT: begin
					if (i2cFinished) begin
						next_state = CONFIG_ANALOG_AUDIO_PATH;
					end else begin
						next_state = SEND_CONFIG_RH_OUT;
					end
				end
				CONFIG_ANALOG_AUDIO_PATH: begin
					next_state = SEND_CONFIG_ANALOG_AUDIO_PATH;
				end
				SEND_CONFIG_ANALOG_AUDIO_PATH: begin
					if (i2cFinished) begin
						next_state = CONFIG_DAI;
					end else begin
						next_state = SEND_CONFIG_ANALOG_AUDIO_PATH;
					end
				end
				CONFIG_DAI: begin
					next_state = SEND_CONFIG_DAI;
				end
				SEND_CONFIG_DAI: begin
					if (i2cFinished) begin
						next_state = CONFIG_SAMPL_CONTROL;
					end else begin
						next_state = SEND_CONFIG_DAI;
					end
				end
				CONFIG_SAMPL_CONTROL: begin
					next_state = SEND_CONFIG_SAMPL_CONTROL;
				end
				SEND_CONFIG_SAMPL_CONTROL: begin
					if (i2cFinished) begin
						next_state = IDLE;
					end else begin
						next_state = SEND_CONFIG_SAMPL_CONTROL;
					end
				end
            IDLE: begin
                if (write) begin
                    next_state = GET_INDEX;
                end
                else begin
                    next_state = IDLE;
                end
            end
            GET_INDEX: begin
                next_state = WAIT_MUSIC;
            end
				WAIT_MUSIC: begin
                if (musicEnded) begin
						next_state = IDLE;
					 end else begin
						next_state = WAIT_MUSIC;
					 end
				end 
        endcase
    end

    //Decodificador de saida
    always @ (*) begin
			readMemoryData = 0;
			codecCombReset = 0;
			codecConfig = 24'b0;
			i2cCombReset = 1'b0;
			addr_next  = addr_initial;
        case (state)
				BEGIN: begin
					
				end
				CONFIG_RESET: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_RESET: begin
					codecConfig = 	24'b000111100000000000000000;
				end
				CONFIG_LH_OUT: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_LH_OUT: begin
					codecConfig = 	24'b000001000000000001111111;
				end
				CONFIG_RH_OUT: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_RH_OUT: begin
					codecConfig = 	24'b000001100000000001111111;
				end
				CONFIG_ANALOG_AUDIO_PATH: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_ANALOG_AUDIO_PATH: begin
					codecConfig = 	24'b000010000000000000011010;
				end
				CONFIG_DAI: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_DAI: begin
					codecConfig = 	24'b000011100000000000000001;
				end
				CONFIG_SAMPL_CONTROL: begin
					i2cCombReset = 1;
				end
				SEND_CONFIG_SAMPL_CONTROL: begin
					codecConfig = 	24'b000100000000000000000000;
				end
            IDLE: begin
					codecCombReset = 0;
					if (write) begin
						addr_next = writedata[4:0];
					end
            end
            GET_INDEX: begin
               readMemoryData = 1;
					
            end
				WAIT_MUSIC: begin
				end
        endcase
		  
		  
    end

endmodule
