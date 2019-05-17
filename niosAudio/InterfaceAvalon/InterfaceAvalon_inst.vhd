	component InterfaceAvalon is
		port (
			codecdata_bclk            : out std_logic;  -- bclk
			codecdata_codecserialdata : out std_logic;  -- codecserialdata
			codecdata_lrck            : out std_logic   -- lrck
		);
	end component InterfaceAvalon;

	u0 : component InterfaceAvalon
		port map (
			codecdata_bclk            => CONNECTED_TO_codecdata_bclk,            -- codecdata.bclk
			codecdata_codecserialdata => CONNECTED_TO_codecdata_codecserialdata, --          .codecserialdata
			codecdata_lrck            => CONNECTED_TO_codecdata_lrck             --          .lrck
		);

