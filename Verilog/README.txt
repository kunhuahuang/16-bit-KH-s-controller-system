The whole system include controller and many IPs.

Top module and Bus :
	Embedded_system.v
	
		clock resources : 
			clock_50.v (50MHz)

		controller part : (Need BRAM, and include the opcode.coe)
			ADD3.v
			ALU.v
			BIN_TO_BCD.v
			CPU.v
			CPU_Stage_01.v
			CPU_Stage_02.v
			LOG.v
			SHF.v

		IP part :
			Distance_Detect.v
			DMAX.v
			KEY_PAD.v
			LCDM_control.v
			KEYBOARD.v
			Seven_seg.v
			VGA_OUT.v  (Need BRAM, and include the Image Graphic)