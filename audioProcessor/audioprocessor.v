module audioProcessor(  input clock, //interface para Avalon
                        input reset,
                        input [31:0] writedata, //writedata = endereço do som
                        input read,
                        input write,
                        output [31:0] readdata,
                        output waitrequest,
                        output lrck, //saidas para codec
                        output bclk, 
                        output codecSerialData
                        );

    parameter   IDLE = 2'b00,
                WAITING_INTERFACE = 2'b01,
                DATA_SEND = 2'b11,
                WAITING_DONE = 2'b10;

    //definir memoria
	 reg [15:0] memory [0:1048575];


    reg [31:0] savedWriteData;
    reg [1:0] state, next_state;
    reg [15:0] dataToInterface, dataToInterfaceNext;
    wire interfaceDone, dataEnable;
    wire [15:0] dataFromMemory, dataFromController;
	 wire [20:0] addrToMemory;

	 
    codecInterface codecInt(   .clock(clock),
                                .reset(reset),
                                .dataIn(dataToInterface),
                                .sendData(dataEnable),
                                .wordSent(interfaceDone),
                                .bclk(blck),
                                .lrck(lrck),
                                .data(codecSerialData));
										  
	memoController memoInt( 	.clock(clock),
										.reset(reset),
										.dataIn(memory[addrToMemory]),
										.addrInitial(addrToMemory),
										.readEn(read),
										.dataOut(dataFromController));

    always @ (posedge clock) begin
        if (reset) begin
            dataToInterface <= 0;
            state <= IDLE;
        end
        else begin
            state <= next_state;
            dataToInterface <= dataToInterfaceNext;
        end
    end
    
    //Decodificador de proximo estado
    always @ (*) begin
        case (state)
            IDLE: begin
                if (write) begin
                    next_state = WAITING_INTERFACE;
                end
                else begin
                    next_state = IDLE;
                end
            end
            WAITING_INTERFACE: begin
                next_state = DATA_SEND;
            end
            DATA_SEND: begin
                next_state = WAITING_DONE;
            end
            WAITING_DONE: begin
                if (interfaceDone) next_state = IDLE;
                else next_state = WAITING_DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    //Decodificador de saida
    always @ (*) begin
        dataToInterfaceNext = dataToInterface;
		  /*  ...  */

    end

endmodule
