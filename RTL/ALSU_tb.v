module ALSU_tb ();
	reg clk,rst,cin,si,red_op_A,red_op_B,bypass_A,bypass_b,direction;
	reg [2:0]A,B,opcode;
	wire [15:0]leds;
	wire [5:0]out;
	ALSU #(.INPUT_PRIORITY("A"),.FULL_ADDER("on")) dut (clk,rst,A,B,cin,si,red_op_A,red_op_B,opcode,
		bypass_A,bypass_b,direction,leds,out);
	initial begin
		clk=0;
		forever begin
			#5; clk=~clk;
		end
	end
	integer i;
	initial begin
		rst=1;
		{clk,cin,si,red_op_A,red_op_B,bypass_A,bypass_b,direction,A,B,opcode}=0;
		@(negedge clk);
		rst=0; A=2; B=3; bypass_A=1;
		@(negedge clk);
		bypass_b=1; bypass_A=0;
		@(negedge clk);
		bypass_A=1; bypass_b=1;
		@(negedge clk);
		bypass_A=0; bypass_b=0;
		red_op_A=1; red_op_B=1;
		opcode=0;
		@(negedge clk);
		red_op_A=0; red_op_B=1;
		@(negedge clk);
		red_op_B=0;
		for (i = 0; i < 8; i=i+1) begin
			opcode=i;
			@(negedge clk);
			if (i==7||i==8) begin
				#25;
			end
		end
		$stop;
	end
endmodule : ALSU_tb