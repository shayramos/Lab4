romMemory_inst : romMemory PORT MAP (
		address	 => address_sig,
		clock	 => clock_sig,
		rden	 => rden_sig,
		q	 => q_sig
	);
