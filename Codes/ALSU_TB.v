module ALSU_tb ();
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
reg clk,rst,cin,serial_in,op_a,op_b,bypass_A, bypass_B;
reg [2:0]a,b,opcode;
wire [5:0]out;
wire [15:0]leds;
ASLU #(.INPUT_PRIORITY(INPUT_PRIORITY), . FULL_ADDER(FULL_ADDER)) dut (clk,rst,a,b,cin,serial_in,op_a,op_b,opcode,bypass_A, bypass_B, out, leds);
initial begin
	clk=0;
	forever 
	#1 clk=~clk ;
end
initial begin
	rst=1;
	repeat(10) begin
	@( negedge clk)
		a=$random ; b=$random ; cin=$random ; serial_in=$random ; op_a=$random ; op_b=$random ;
		bypass_A=$random ; bypass_B=$random ; opcode=$urandom_range(0,7);
		if ((out!=0)&&(leds!=0)) begin
			$display("the design is wrong");
			$stop;
		end
	end
end

initial begin
	rst=0; bypass_A=1;
	repeat(10) begin
	
	@( negedge clk)
		a=$random ; b=$random ; cin=$random ; serial_in=$random ; op_a=$random ; op_b=$random ;
		bypass_A=$random ; bypass_B=$random ; opcode=$urandom_range(0,7);
		if ((out!=a)&&(leds!=0)) begin
			$display("the design is wrong");
			$stop;
		end
	end
end

initial begin
	rst=0; bypass_A=0; bypass_B=1 ;
	repeat(10) begin
	
	@( negedge clk)
		a=$random ; b=$random ; cin=$random ; serial_in=$random ; op_a=$random ; op_b=$random ;
		bypass_A=$random ;  opcode=$urandom_range(0,7);
		if ((out!=b)&&(leds!=0)) begin
			$display("the design is wrong");
			$stop;
		end
	end
end

initial begin
	rst=0; bypass_A=0; bypass_B=0 ;
	repeat(30) begin
	@( negedge clk)
		a=$random ; b=$random ; cin=$random ; serial_in=$random ; op_a=$random ; op_b=$random ;
		bypass_A=$random ;  opcode=$urandom_range(0,7);
		
	end
end

initial begin
	$monitor("time = %0t, A = %b, B = %b, opcode = %b, cin = %b, serial_in = %b,red_op_A = %b, red_op_B = %b, bypass_A = %b, bypass_B = %b, clk = %b, rst
= %b, out = %b, leds = %b",
$time,a, b, opcode, cin, serial_in, op_a, op_b , bypass_A, bypass_B, clk, rst, out, leds);
end
endmodule