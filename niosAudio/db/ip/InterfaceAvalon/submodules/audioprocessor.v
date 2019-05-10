module audioProcessor(  input clock, //interface para Avalon
                        input reset,
								input bitclock,
                        input [31:0] writedata, //writedata = endereço do som
                        input read, //
                        input write, //sinal do avalon para startar
                        output [31:0] readdata,
                        output lrck, //saidas para codec
                        output bclk, 
                        output codecSerialData
                        );

    parameter   IDLE = 4'b0000,
                FETCH_MEMORY = 4'b0001,
                WAITING_MEMORY_1 = 4'b0011,
                WAITING_DONE_1 = 4'b0010,
					 SEND_CODEC_1 = 4'b0100,
					 WAITING_MEMORY_2 = 4'b0101,
                WAITING_DONE_2 = 4'b0110,
					 WAITING_CODEC = 4'b0111,
					 SEND_CODEC_2 = 4'b1000;

	 reg [31:0] savedWriteData;
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
	 reg [20:0] addrToController, addrToController_next;
	 wire readEnable, available, musicEnded;
	 wire [20:0] addrToMemory;

	 wire whatever;
	 
	 assign bclk = bitclock;
	 
    codecInterface codecInt(   .clock(clock),
                                .reset(reset),
                                .dataIn(dataToInterface),
                                .sendData(dataEnable),
                                .wordSent(interfaceDone),
                                .bclk(whatever),
                                .lrck(lrck),
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
										.musicEnded(musicEnded));
										
	romMemory rom(		.address(addrToMemory),
							.clock(clock),
							.rden(readEnable),
							.q(dataFromMemory));
	
    always @ (posedge clock) begin
        if (reset) begin
            dataToInterface <= 0;
            state <= IDLE;
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
                if (interfaceDone) begin
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
        case (state)
            IDLE: begin
            end
            FETCH_MEMORY: begin
					addrToController_next = writedata;
               readMemoryData = 1;
            end
				WAITING_MEMORY_1: begin
				end 
            WAITING_DONE_1: begin
					dataToInterface_next = dataFromMemory;
				end
				SEND_CODEC_1: begin
					dataEnable = 1;
					readMemoryData = 1;
				end
				WAITING_MEMORY_2: begin
				end 
            WAITING_DONE_2: begin
					dataStorage_next = dataFromMemory;
            end
				WAITING_CODEC: begin
				end
				SEND_CODEC_2: begin
					dataEnable = 1;
					if (!musicEnded)
						readMemoryData = 1;
				end
        endcase
    end

endmodule
