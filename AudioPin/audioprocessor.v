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
								output sdata
                        );

    parameter   BEGIN = 								5'b00000,
                FETCH_MEMORY = 						5'b00001,
                WAITING_MEMORY_1 = 					5'b00011,
                WAITING_DONE_1 = 					5'b00010,
					 SEND_CODEC_1 = 						5'b00100,
					 WAITING_MEMORY_2 = 					5'b00101,
                WAITING_DONE_2 = 					5'b00110,
					 WAITING_CODEC = 						5'b00111,
					 SEND_CODEC_2 = 						5'b01000,
					 CONFIG_RESET = 						5'b01001,
					 SEND_CONFIG_RESET = 				5'b01010,
					 CONFIG_LH_OUT = 						5'b01011,
					 SEND_CONFIG_LH_OUT = 				5'b01100,
					 CONFIG_RH_OUT = 						5'b01101,
					 SEND_CONFIG_RH_OUT = 				5'b01110,
					 CONFIG_ANALOG_AUDIO_PATH = 		5'b01111,
					 SEND_CONFIG_ANALOG_AUDIO_PATH = 5'b10000,
					 CONFIG_DAI = 							5'b10001,
					 SEND_CONFIG_DAI = 					5'b10010,
					 CONFIG_SAMPL_CONTROL = 			5'b10011,
					 SEND_CONFIG_SAMPL_CONTROL = 		5'b10100,
					 IDLE = 									5'b10101;

    //reg [31:0] savedWriteData;
    reg [3:0] state, next_state;
    reg [15:0] dataToInterface, dataToInterface_next;
    wire interfaceDone;
	 //indica que a palavra está disponível
	 reg dataEnable;
	 //sinal que diz para o controlador ler a palavra da memoria
	 reg readMemoryData;
	 //palavra da memoria
	 reg [15:0] dataStorage, dataStorage_next;
	 wire [15:0] dataFromController, dataFromMemory;
	 //endereço da musica a ser tocada
	 reg [15:0] addrToController, addrToController_next;
	 wire readEnable, available, musicEnded;
	 wire [15:0] addrToMemory;
	 wire codecReset, lrck_last;
	 reg codecCombReset, i2cCombReset;
	 wire [15:0] datagerador;
	 wire i2cReset, i2cFinished;	 
	 reg [23:0] codecConfig;
	 
	 assign i2cReset = reset | i2cCombReset;
	 assign codecReset = reset | codecCombReset;
	 
	 geradorsqwave gerador( .clock(lrck),
									.reset(reset),
									.data(datagerador));
	 
	 codecInterface codecInt2( .clock(clock),
                                .reset(codecReset),
                                .dataIn(datagerador),
										  .codec_clk(codec_clk),
                                .bclk(bclk),
                                .lrck(lrck),
										  .lrck_last(lrck_last),
                                .data(codecSerialData)
										  );

	 
    /*codecInterface codecInt(   .clock(clock),
                                .reset(codecReset),
                                .dataIn(dataToInterface),
										  .codec_clk(codec_clk),
                                .bclk(bclk),
                                .lrck(lrck),
										  .lrck_last(lrck_last),
                                .data(codecSerialData));
										  
	memoController memoInt( 	.clock(clock),
										.reset(reset),
										.dataIn(dataFromMemory),
										.addrInitial(addrToController),
										.readData(readMemoryData),
										.readEn(readEnable),
										.dataOut(dataFromController),
										.addrOut(addrToMemory),
										.available(available),
										.musicEnded(musicEnded));*/
										
										
	controllerMemory memoInt( 	.clock(clock),
										.reset(reset),
										.indiceMemory(writedata),
										.next(readMemoryData),
										.dataOut(dataFromMemory),
										.finishMusic(musicEnded)
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
            dataToInterface <= 0;
            state <= BEGIN;
        end
        else begin
            state <= next_state;
				addrToController <= addrToController_next;
				if (next_state > SEND_CODEC_1) begin
					dataToInterface <= dataStorage_next;
				end else begin
					dataToInterface <= dataToInterface_next;
				end
				dataStorage <= dataStorage_next;
        end
    end
    
    //Decodificador de proximo estado
    always @ (*) begin
        case (state)
				BEGIN: begin
					next_state = CONFIG_RESET;
				end
				SEND_CONFIG_RESET: begin
					if (i2cFinished) begin
						next_state = CONFIG_LH_OUT;
					end else begin
						next_state = state;
					end
				end
				CONFIG_LH_OUT: begin
					next_state = SEND_CONFIG_LH_OUT;
				end
				SEND_CONFIG_LH_OUT: begin
					if (i2cFinished) begin
						next_state = CONFIG_RH_OUT;
					end else begin
						next_state = state;
					end
				end
				CONFIG_RH_OUT: begin
					next_state = SEND_CONFIG_RH_OUT;
				end
				SEND_CONFIG_RH_OUT: begin
					if (i2cFinished) begin
						next_state = CONFIG_ANALOG_AUDIO_PATH;
					end else begin
						next_state = state;
					end
				end
				CONFIG_ANALOG_AUDIO_PATH: begin
					next_state = SEND_CONFIG_ANALOG_AUDIO_PATH;
				end
				SEND_CONFIG_ANALOG_AUDIO_PATH: begin
					if (i2cFinished) begin
						next_state = CONFIG_DAI;
					end else begin
						next_state = state;
					end
				end
				CONFIG_DAI: begin
					next_state = SEND_CONFIG_DAI;
				end
				SEND_CONFIG_DAI: begin
					if (i2cFinished) begin
						next_state = CONFIG_SAMPL_CONTROL;
					end else begin
						next_state = state;
					end
				end
				CONFIG_SAMPL_CONTROL: begin
					next_state = SEND_CONFIG_SAMPL_CONTROL;
				end
				SEND_CONFIG_SAMPL_CONTROL : begin
					if (i2cFinished) begin
						next_state = IDLE;
					end else begin
						next_state = state;
					end
				end
            IDLE: begin
                if (write) begin
                    next_state = FETCH_MEMORY;
                end
                else begin
                    next_state = IDLE;
                end
            end
            FETCH_MEMORY: begin
                next_state = WAITING_MEMORY_1;
            end
				WAITING_MEMORY_1: begin
                if (available) begin
                    next_state = WAITING_DONE_1;
                end
                else begin
                    next_state = WAITING_MEMORY_1;
                end
				end 
            WAITING_DONE_1: begin
                next_state = SEND_CODEC_1;
            end
				SEND_CODEC_1: begin
					next_state = WAITING_MEMORY_2;
				end
				WAITING_MEMORY_2: begin
                if (available) begin
                    next_state = WAITING_DONE_2;
                end
                else begin
                    next_state = WAITING_MEMORY_2;
                end
				end 
            WAITING_DONE_2: begin
                next_state = WAITING_CODEC;
            end
				WAITING_CODEC: begin
                if (lrck && !lrck_last) begin
                    next_state = SEND_CODEC_2;
                end
                else begin
                    next_state = WAITING_CODEC;
                end
				end
				SEND_CODEC_2: begin
                if (musicEnded) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = WAITING_MEMORY_2;
                end
				end
            default: next_state = IDLE;
        endcase
    end

    //Decodificador de saida
    always @ (*) begin
			readMemoryData = 0;
			dataEnable = 0;
			addrToController_next = addrToController;
			dataToInterface_next = dataToInterface;
			dataStorage_next = dataStorage;
			codecCombReset = 0;
			codecConfig = 24'b0;
			i2cCombReset = 1'b0;
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
				SEND_CONFIG_SAMPL_CONTROL : begin
					codecConfig = 	24'b000100000000000000000000;
				end
            IDLE: begin
					codecCombReset = 0;
            end
            FETCH_MEMORY: begin
					addrToController_next = {writedata, 1'b0};
               readMemoryData = 1;
            end
				WAITING_MEMORY_1: begin
				end 
            WAITING_DONE_1: begin
					dataToInterface_next = dataFromController;
				end
				SEND_CODEC_1: begin
					readMemoryData = 1;
				end
				WAITING_MEMORY_2: begin
				end 
            WAITING_DONE_2: begin
					dataStorage_next = dataFromController;
            end
				WAITING_CODEC: begin
				end
				SEND_CODEC_2: begin
					if (!musicEnded)
						readMemoryData = 1;
				end
        endcase
		  
		  
    end

endmodule
