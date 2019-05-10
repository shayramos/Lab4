// InterfaceAvalon.v

// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module InterfaceAvalon (
		input  wire  clk_clk,                   //       clk.clk
		output wire  codecdata_bclk,            // codecdata.bclk
		output wire  codecdata_codecserialdata, //          .codecserialdata
		output wire  codecdata_lrck             //          .lrck
	);

	wire         nios2_qsys_0_jtag_debug_module_reset_reset;                   // nios2_qsys_0:jtag_debug_module_resetrequest -> [rst_controller:reset_in0, rst_controller:reset_in1]
	wire  [31:0] nios2_qsys_0_data_master_readdata;                            // mm_interconnect_0:nios2_qsys_0_data_master_readdata -> nios2_qsys_0:d_readdata
	wire         nios2_qsys_0_data_master_waitrequest;                         // mm_interconnect_0:nios2_qsys_0_data_master_waitrequest -> nios2_qsys_0:d_waitrequest
	wire         nios2_qsys_0_data_master_debugaccess;                         // nios2_qsys_0:jtag_debug_module_debugaccess_to_roms -> mm_interconnect_0:nios2_qsys_0_data_master_debugaccess
	wire  [16:0] nios2_qsys_0_data_master_address;                             // nios2_qsys_0:d_address -> mm_interconnect_0:nios2_qsys_0_data_master_address
	wire   [3:0] nios2_qsys_0_data_master_byteenable;                          // nios2_qsys_0:d_byteenable -> mm_interconnect_0:nios2_qsys_0_data_master_byteenable
	wire         nios2_qsys_0_data_master_read;                                // nios2_qsys_0:d_read -> mm_interconnect_0:nios2_qsys_0_data_master_read
	wire         nios2_qsys_0_data_master_write;                               // nios2_qsys_0:d_write -> mm_interconnect_0:nios2_qsys_0_data_master_write
	wire  [31:0] nios2_qsys_0_data_master_writedata;                           // nios2_qsys_0:d_writedata -> mm_interconnect_0:nios2_qsys_0_data_master_writedata
	wire  [31:0] nios2_qsys_0_instruction_master_readdata;                     // mm_interconnect_0:nios2_qsys_0_instruction_master_readdata -> nios2_qsys_0:i_readdata
	wire         nios2_qsys_0_instruction_master_waitrequest;                  // mm_interconnect_0:nios2_qsys_0_instruction_master_waitrequest -> nios2_qsys_0:i_waitrequest
	wire  [13:0] nios2_qsys_0_instruction_master_address;                      // nios2_qsys_0:i_address -> mm_interconnect_0:nios2_qsys_0_instruction_master_address
	wire         nios2_qsys_0_instruction_master_read;                         // nios2_qsys_0:i_read -> mm_interconnect_0:nios2_qsys_0_instruction_master_read
	wire  [31:0] mm_interconnect_0_audioprocessor_0_avalon_slave_0_readdata;   // audioProcessor_0:readdata -> mm_interconnect_0:audioProcessor_0_avalon_slave_0_readdata
	wire         mm_interconnect_0_audioprocessor_0_avalon_slave_0_read;       // mm_interconnect_0:audioProcessor_0_avalon_slave_0_read -> audioProcessor_0:read
	wire         mm_interconnect_0_audioprocessor_0_avalon_slave_0_write;      // mm_interconnect_0:audioProcessor_0_avalon_slave_0_write -> audioProcessor_0:write
	wire  [31:0] mm_interconnect_0_audioprocessor_0_avalon_slave_0_writedata;  // mm_interconnect_0:audioProcessor_0_avalon_slave_0_writedata -> audioProcessor_0:writedata
	wire  [31:0] mm_interconnect_0_nios2_qsys_0_jtag_debug_module_readdata;    // nios2_qsys_0:jtag_debug_module_readdata -> mm_interconnect_0:nios2_qsys_0_jtag_debug_module_readdata
	wire         mm_interconnect_0_nios2_qsys_0_jtag_debug_module_waitrequest; // nios2_qsys_0:jtag_debug_module_waitrequest -> mm_interconnect_0:nios2_qsys_0_jtag_debug_module_waitrequest
	wire         mm_interconnect_0_nios2_qsys_0_jtag_debug_module_debugaccess; // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_debugaccess -> nios2_qsys_0:jtag_debug_module_debugaccess
	wire   [8:0] mm_interconnect_0_nios2_qsys_0_jtag_debug_module_address;     // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_address -> nios2_qsys_0:jtag_debug_module_address
	wire         mm_interconnect_0_nios2_qsys_0_jtag_debug_module_read;        // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_read -> nios2_qsys_0:jtag_debug_module_read
	wire   [3:0] mm_interconnect_0_nios2_qsys_0_jtag_debug_module_byteenable;  // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_byteenable -> nios2_qsys_0:jtag_debug_module_byteenable
	wire         mm_interconnect_0_nios2_qsys_0_jtag_debug_module_write;       // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_write -> nios2_qsys_0:jtag_debug_module_write
	wire  [31:0] mm_interconnect_0_nios2_qsys_0_jtag_debug_module_writedata;   // mm_interconnect_0:nios2_qsys_0_jtag_debug_module_writedata -> nios2_qsys_0:jtag_debug_module_writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect;             // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;               // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire         mm_interconnect_0_onchip_memory2_0_s1_debugaccess;            // mm_interconnect_0:onchip_memory2_0_s1_debugaccess -> onchip_memory2_0:debugaccess
	wire  [10:0] mm_interconnect_0_onchip_memory2_0_s1_address;                // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable;             // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;                  // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;              // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;                  // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire         mm_interconnect_0_onchip_memory2_1_s1_chipselect;             // mm_interconnect_0:onchip_memory2_1_s1_chipselect -> onchip_memory2_1:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_1_s1_readdata;               // onchip_memory2_1:readdata -> mm_interconnect_0:onchip_memory2_1_s1_readdata
	wire  [13:0] mm_interconnect_0_onchip_memory2_1_s1_address;                // mm_interconnect_0:onchip_memory2_1_s1_address -> onchip_memory2_1:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_1_s1_byteenable;             // mm_interconnect_0:onchip_memory2_1_s1_byteenable -> onchip_memory2_1:byteenable
	wire         mm_interconnect_0_onchip_memory2_1_s1_write;                  // mm_interconnect_0:onchip_memory2_1_s1_write -> onchip_memory2_1:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_1_s1_writedata;              // mm_interconnect_0:onchip_memory2_1_s1_writedata -> onchip_memory2_1:writedata
	wire         mm_interconnect_0_onchip_memory2_1_s1_clken;                  // mm_interconnect_0:onchip_memory2_1_s1_clken -> onchip_memory2_1:clken
	wire  [31:0] nios2_qsys_0_d_irq_irq;                                       // irq_mapper:sender_irq -> nios2_qsys_0:d_irq
	wire         rst_controller_reset_out_reset;                               // rst_controller:reset_out -> [audioProcessor_0:reset, irq_mapper:reset, mm_interconnect_0:nios2_qsys_0_reset_n_reset_bridge_in_reset_reset, nios2_qsys_0:reset_n, onchip_memory2_0:reset, onchip_memory2_1:reset, rst_translator:in_reset]
	wire         rst_controller_reset_out_reset_req;                           // rst_controller:reset_req -> [onchip_memory2_0:reset_req, onchip_memory2_1:reset_req, rst_translator:reset_req_in]

	audioProcessor #(
		.IDLE             (5'b00000),
		.FETCH_MEMORY     (5'b00001),
		.WAITING_MEMORY_1 (5'b00011),
		.WAITING_DONE_1   (5'b00010),
		.SEND_CODEC_1     (5'b00100),
		.WAITING_MEMORY_2 (5'b00101),
		.WAITING_DONE_2   (5'b00110),
		.WAITING_CODEC    (5'b00111),
		.SEND_CODEC_2     (5'b01000)
	) audioprocessor_0 (
		.reset           (rst_controller_reset_out_reset),                              //          reset.reset
		.writedata       (mm_interconnect_0_audioprocessor_0_avalon_slave_0_writedata), // avalon_slave_0.writedata
		.read            (mm_interconnect_0_audioprocessor_0_avalon_slave_0_read),      //               .read
		.write           (mm_interconnect_0_audioprocessor_0_avalon_slave_0_write),     //               .write
		.readdata        (mm_interconnect_0_audioprocessor_0_avalon_slave_0_readdata),  //               .readdata
		.bclk            (codecdata_bclk),                                              //    conduit_end.bclk
		.codecSerialData (codecdata_codecserialdata),                                   //               .codecserialdata
		.lrck            (codecdata_lrck),                                              //               .lrck
		.clock           (clk_clk),                                                     //          clock.clk
		.bitclock        (clk_clk)                                                      //     clock_sink.clk
	);

	InterfaceAvalon_nios2_qsys_0 nios2_qsys_0 (
		.clk                                   (clk_clk),                                                      //                       clk.clk
		.reset_n                               (~rst_controller_reset_out_reset),                              //                   reset_n.reset_n
		.d_address                             (nios2_qsys_0_data_master_address),                             //               data_master.address
		.d_byteenable                          (nios2_qsys_0_data_master_byteenable),                          //                          .byteenable
		.d_read                                (nios2_qsys_0_data_master_read),                                //                          .read
		.d_readdata                            (nios2_qsys_0_data_master_readdata),                            //                          .readdata
		.d_waitrequest                         (nios2_qsys_0_data_master_waitrequest),                         //                          .waitrequest
		.d_write                               (nios2_qsys_0_data_master_write),                               //                          .write
		.d_writedata                           (nios2_qsys_0_data_master_writedata),                           //                          .writedata
		.jtag_debug_module_debugaccess_to_roms (nios2_qsys_0_data_master_debugaccess),                         //                          .debugaccess
		.i_address                             (nios2_qsys_0_instruction_master_address),                      //        instruction_master.address
		.i_read                                (nios2_qsys_0_instruction_master_read),                         //                          .read
		.i_readdata                            (nios2_qsys_0_instruction_master_readdata),                     //                          .readdata
		.i_waitrequest                         (nios2_qsys_0_instruction_master_waitrequest),                  //                          .waitrequest
		.d_irq                                 (nios2_qsys_0_d_irq_irq),                                       //                     d_irq.irq
		.jtag_debug_module_resetrequest        (nios2_qsys_0_jtag_debug_module_reset_reset),                   //   jtag_debug_module_reset.reset
		.jtag_debug_module_address             (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_address),     //         jtag_debug_module.address
		.jtag_debug_module_byteenable          (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_byteenable),  //                          .byteenable
		.jtag_debug_module_debugaccess         (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_debugaccess), //                          .debugaccess
		.jtag_debug_module_read                (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_read),        //                          .read
		.jtag_debug_module_readdata            (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_readdata),    //                          .readdata
		.jtag_debug_module_waitrequest         (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_waitrequest), //                          .waitrequest
		.jtag_debug_module_write               (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_write),       //                          .write
		.jtag_debug_module_writedata           (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_writedata),   //                          .writedata
		.no_ci_readra                          (),                                                             // custom_instruction_master.readra
		.reset_req                             (1'b0)                                                          //               (terminated)
	);

	InterfaceAvalon_onchip_memory2_0 onchip_memory2_0 (
		.clk         (clk_clk),                                           //   clk1.clk
		.address     (mm_interconnect_0_onchip_memory2_0_s1_address),     //     s1.address
		.debugaccess (mm_interconnect_0_onchip_memory2_0_s1_debugaccess), //       .debugaccess
		.clken       (mm_interconnect_0_onchip_memory2_0_s1_clken),       //       .clken
		.chipselect  (mm_interconnect_0_onchip_memory2_0_s1_chipselect),  //       .chipselect
		.write       (mm_interconnect_0_onchip_memory2_0_s1_write),       //       .write
		.readdata    (mm_interconnect_0_onchip_memory2_0_s1_readdata),    //       .readdata
		.writedata   (mm_interconnect_0_onchip_memory2_0_s1_writedata),   //       .writedata
		.byteenable  (mm_interconnect_0_onchip_memory2_0_s1_byteenable),  //       .byteenable
		.reset       (rst_controller_reset_out_reset),                    // reset1.reset
		.reset_req   (rst_controller_reset_out_reset_req),                //       .reset_req
		.freeze      (1'b0)                                               // (terminated)
	);

	InterfaceAvalon_onchip_memory2_1 onchip_memory2_1 (
		.clk        (clk_clk),                                          //   clk1.clk
		.address    (mm_interconnect_0_onchip_memory2_1_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_onchip_memory2_1_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_onchip_memory2_1_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_onchip_memory2_1_s1_write),      //       .write
		.readdata   (mm_interconnect_0_onchip_memory2_1_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_onchip_memory2_1_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_onchip_memory2_1_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),                   // reset1.reset
		.reset_req  (rst_controller_reset_out_reset_req),               //       .reset_req
		.freeze     (1'b0)                                              // (terminated)
	);

	InterfaceAvalon_mm_interconnect_0 mm_interconnect_0 (
		.clk_0_clk_clk                                    (clk_clk),                                                      //                                  clk_0_clk.clk
		.nios2_qsys_0_reset_n_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                               // nios2_qsys_0_reset_n_reset_bridge_in_reset.reset
		.nios2_qsys_0_data_master_address                 (nios2_qsys_0_data_master_address),                             //                   nios2_qsys_0_data_master.address
		.nios2_qsys_0_data_master_waitrequest             (nios2_qsys_0_data_master_waitrequest),                         //                                           .waitrequest
		.nios2_qsys_0_data_master_byteenable              (nios2_qsys_0_data_master_byteenable),                          //                                           .byteenable
		.nios2_qsys_0_data_master_read                    (nios2_qsys_0_data_master_read),                                //                                           .read
		.nios2_qsys_0_data_master_readdata                (nios2_qsys_0_data_master_readdata),                            //                                           .readdata
		.nios2_qsys_0_data_master_write                   (nios2_qsys_0_data_master_write),                               //                                           .write
		.nios2_qsys_0_data_master_writedata               (nios2_qsys_0_data_master_writedata),                           //                                           .writedata
		.nios2_qsys_0_data_master_debugaccess             (nios2_qsys_0_data_master_debugaccess),                         //                                           .debugaccess
		.nios2_qsys_0_instruction_master_address          (nios2_qsys_0_instruction_master_address),                      //            nios2_qsys_0_instruction_master.address
		.nios2_qsys_0_instruction_master_waitrequest      (nios2_qsys_0_instruction_master_waitrequest),                  //                                           .waitrequest
		.nios2_qsys_0_instruction_master_read             (nios2_qsys_0_instruction_master_read),                         //                                           .read
		.nios2_qsys_0_instruction_master_readdata         (nios2_qsys_0_instruction_master_readdata),                     //                                           .readdata
		.audioProcessor_0_avalon_slave_0_write            (mm_interconnect_0_audioprocessor_0_avalon_slave_0_write),      //            audioProcessor_0_avalon_slave_0.write
		.audioProcessor_0_avalon_slave_0_read             (mm_interconnect_0_audioprocessor_0_avalon_slave_0_read),       //                                           .read
		.audioProcessor_0_avalon_slave_0_readdata         (mm_interconnect_0_audioprocessor_0_avalon_slave_0_readdata),   //                                           .readdata
		.audioProcessor_0_avalon_slave_0_writedata        (mm_interconnect_0_audioprocessor_0_avalon_slave_0_writedata),  //                                           .writedata
		.nios2_qsys_0_jtag_debug_module_address           (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_address),     //             nios2_qsys_0_jtag_debug_module.address
		.nios2_qsys_0_jtag_debug_module_write             (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_write),       //                                           .write
		.nios2_qsys_0_jtag_debug_module_read              (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_read),        //                                           .read
		.nios2_qsys_0_jtag_debug_module_readdata          (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_readdata),    //                                           .readdata
		.nios2_qsys_0_jtag_debug_module_writedata         (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_writedata),   //                                           .writedata
		.nios2_qsys_0_jtag_debug_module_byteenable        (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_byteenable),  //                                           .byteenable
		.nios2_qsys_0_jtag_debug_module_waitrequest       (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_waitrequest), //                                           .waitrequest
		.nios2_qsys_0_jtag_debug_module_debugaccess       (mm_interconnect_0_nios2_qsys_0_jtag_debug_module_debugaccess), //                                           .debugaccess
		.onchip_memory2_0_s1_address                      (mm_interconnect_0_onchip_memory2_0_s1_address),                //                        onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                        (mm_interconnect_0_onchip_memory2_0_s1_write),                  //                                           .write
		.onchip_memory2_0_s1_readdata                     (mm_interconnect_0_onchip_memory2_0_s1_readdata),               //                                           .readdata
		.onchip_memory2_0_s1_writedata                    (mm_interconnect_0_onchip_memory2_0_s1_writedata),              //                                           .writedata
		.onchip_memory2_0_s1_byteenable                   (mm_interconnect_0_onchip_memory2_0_s1_byteenable),             //                                           .byteenable
		.onchip_memory2_0_s1_chipselect                   (mm_interconnect_0_onchip_memory2_0_s1_chipselect),             //                                           .chipselect
		.onchip_memory2_0_s1_clken                        (mm_interconnect_0_onchip_memory2_0_s1_clken),                  //                                           .clken
		.onchip_memory2_0_s1_debugaccess                  (mm_interconnect_0_onchip_memory2_0_s1_debugaccess),            //                                           .debugaccess
		.onchip_memory2_1_s1_address                      (mm_interconnect_0_onchip_memory2_1_s1_address),                //                        onchip_memory2_1_s1.address
		.onchip_memory2_1_s1_write                        (mm_interconnect_0_onchip_memory2_1_s1_write),                  //                                           .write
		.onchip_memory2_1_s1_readdata                     (mm_interconnect_0_onchip_memory2_1_s1_readdata),               //                                           .readdata
		.onchip_memory2_1_s1_writedata                    (mm_interconnect_0_onchip_memory2_1_s1_writedata),              //                                           .writedata
		.onchip_memory2_1_s1_byteenable                   (mm_interconnect_0_onchip_memory2_1_s1_byteenable),             //                                           .byteenable
		.onchip_memory2_1_s1_chipselect                   (mm_interconnect_0_onchip_memory2_1_s1_chipselect),             //                                           .chipselect
		.onchip_memory2_1_s1_clken                        (mm_interconnect_0_onchip_memory2_1_s1_clken)                   //                                           .clken
	);

	InterfaceAvalon_irq_mapper irq_mapper (
		.clk        (clk_clk),                        //       clk.clk
		.reset      (rst_controller_reset_out_reset), // clk_reset.reset
		.sender_irq (nios2_qsys_0_d_irq_irq)          //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (2),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (nios2_qsys_0_jtag_debug_module_reset_reset), // reset_in0.reset
		.reset_in1      (nios2_qsys_0_jtag_debug_module_reset_reset), // reset_in1.reset
		.clk            (clk_clk),                                    //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),             // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req),         //          .reset_req
		.reset_req_in0  (1'b0),                                       // (terminated)
		.reset_req_in1  (1'b0),                                       // (terminated)
		.reset_in2      (1'b0),                                       // (terminated)
		.reset_req_in2  (1'b0),                                       // (terminated)
		.reset_in3      (1'b0),                                       // (terminated)
		.reset_req_in3  (1'b0),                                       // (terminated)
		.reset_in4      (1'b0),                                       // (terminated)
		.reset_req_in4  (1'b0),                                       // (terminated)
		.reset_in5      (1'b0),                                       // (terminated)
		.reset_req_in5  (1'b0),                                       // (terminated)
		.reset_in6      (1'b0),                                       // (terminated)
		.reset_req_in6  (1'b0),                                       // (terminated)
		.reset_in7      (1'b0),                                       // (terminated)
		.reset_req_in7  (1'b0),                                       // (terminated)
		.reset_in8      (1'b0),                                       // (terminated)
		.reset_req_in8  (1'b0),                                       // (terminated)
		.reset_in9      (1'b0),                                       // (terminated)
		.reset_req_in9  (1'b0),                                       // (terminated)
		.reset_in10     (1'b0),                                       // (terminated)
		.reset_req_in10 (1'b0),                                       // (terminated)
		.reset_in11     (1'b0),                                       // (terminated)
		.reset_req_in11 (1'b0),                                       // (terminated)
		.reset_in12     (1'b0),                                       // (terminated)
		.reset_req_in12 (1'b0),                                       // (terminated)
		.reset_in13     (1'b0),                                       // (terminated)
		.reset_req_in13 (1'b0),                                       // (terminated)
		.reset_in14     (1'b0),                                       // (terminated)
		.reset_req_in14 (1'b0),                                       // (terminated)
		.reset_in15     (1'b0),                                       // (terminated)
		.reset_req_in15 (1'b0)                                        // (terminated)
	);

endmodule
