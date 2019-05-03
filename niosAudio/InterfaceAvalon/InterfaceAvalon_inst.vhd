	component InterfaceAvalon is
		port (
			clk_clk                   : in  std_logic := 'X'; -- clk
			codecdata_bclk            : out std_logic;        -- bclk
			codecdata_codecserialdata : out std_logic;        -- codecserialdata
			codecdata_lrck            : out std_logic         -- lrck
		);
	end component InterfaceAvalon;

	u0 : component InterfaceAvalon
		port map (
			clk_clk                   => CONNECTED_TO_clk_clk,                   --       clk.clk
			codecdata_bclk            => CONNECTED_TO_codecdata_bclk,            -- codecdata.bclk
			codecdata_codecserialdata => CONNECTED_TO_codecdata_codecserialdata, --          .codecserialdata
			codecdata_lrck            => CONNECTED_TO_codecdata_lrck             --          .lrck
		);

