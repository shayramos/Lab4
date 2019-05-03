	component InterfaceAvalon is
		port (
			audioprocessor_0_conduit_end_bclk            : out std_logic;        -- bclk
			audioprocessor_0_conduit_end_codecserialdata : out std_logic;        -- codecserialdata
			audioprocessor_0_conduit_end_lrck            : out std_logic;        -- lrck
			clk_clk                                      : in  std_logic := 'X'  -- clk
		);
	end component InterfaceAvalon;

	u0 : component InterfaceAvalon
		port map (
			audioprocessor_0_conduit_end_bclk            => CONNECTED_TO_audioprocessor_0_conduit_end_bclk,            -- audioprocessor_0_conduit_end.bclk
			audioprocessor_0_conduit_end_codecserialdata => CONNECTED_TO_audioprocessor_0_conduit_end_codecserialdata, --                             .codecserialdata
			audioprocessor_0_conduit_end_lrck            => CONNECTED_TO_audioprocessor_0_conduit_end_lrck,            --                             .lrck
			clk_clk                                      => CONNECTED_TO_clk_clk                                       --                          clk.clk
		);

