module ASLU (clk,rst,a,b,cin,serial_in,op_a,op_b,opcode,bypass_A, bypass_B, out, leds);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
input clk,rst,cin,serial_in,op_a,op_b,bypass_A, bypass_B;
input [2:0]a,b,opcode;
output reg [5:0]out;
output reg [15:0]leds;
reg cin_ff,serial_in_ff,op_a_ff,op_b_ff,bypass_A_ff, bypass_B_ff;
reg [2:0]a_ff,b_ff,opcode_ff;
wire invalid ;
assign invalid = (opcode[2]&opcode[1])|((op_a|op_b)&(~opcode[2]&~opcode[1]));
always @(posedge clk or posedge rst) begin
	if (rst) begin
		a_ff <= 0; b_ff <= 0; opcode_ff <= 0; cin_ff <= 0; serial_in_ff <= 0; op_a_ff <= 0;
        op_b_ff <= 0; bypass_A_ff <= 0; bypass_B_ff <= 0;
	end
	else begin
	a_ff <= a; b_ff <= b; opcode_ff <= opcode; cin_ff <= cin; serial_in_ff <= serial_in; op_a_ff <= op_a;
        op_b_ff <= op_b; bypass_A_ff <= bypass_A; bypass_B_ff <= bypass_B;

	end
end
always @(posedge clk or posedge rst) begin
	if (rst) begin
		leds <= 0;
		
	end
	else if (invalid) begin
	leds <= ~leds;
	leds <= 0;
	end
end
always @(posedge clk or posedge rst) begin
	if (rst|invalid) begin
	out<=0;
	end
	 if ( bypass_A_ff & bypass_B_ff ) begin
		if (INPUT_PRIORITY=="A") begin
		out <=  a_ff;
	end
	else begin
		out <=  b_ff ;
	end
	 if (bypass_A_ff) begin
		out <=  a_ff;
	end
	 if (bypass_B_ff) begin
		out <=  b_ff;
	end
end
end
always @(posedge clk or posedge rst) begin
	if (rst) begin
		out<=0;
		
	end
	else  begin
	case (opcode_ff)
    3'b000:
    if (op_a_ff && op_b_ff) begin 
	if (INPUT_PRIORITY=="A") begin
		out <=  &a_ff;
	end
	else begin
		out <=  &b_ff ;	
	end	
    if (op_a_ff) begin
    out <= &a_ff;	
    end
     if (op_b_ff) begin
    out <= &b_ff;	
    end 
end
    else begin
    	  out <= a_ff & b_ff;	
    end
    3'b001:
    if (op_a_ff && op_b_ff) begin 
	if (INPUT_PRIORITY=="A") begin
		out <=  ^a_ff;
	end
	else begin
		out <=  ^b_ff ;	
	end	
     if (op_a_ff) begin
    out <= ^a_ff;	
    end
    if (op_b_ff) begin
    out <= ^b_ff;	
    end 
end
    else begin
    	  out <= a_ff ^ b_ff;
    end
    3'b010: 
    if (FULL_ADDER == "ON") begin
	out<= a_ff + b_ff + cin_ff ;
    end
    else begin
    out<= a_ff + b_ff ;	
    end
    3'b011: 
    out<= a_ff * b_ff ;
    3'b100:
    out <= {out[4:0], serial_in_ff};
    3'b101:
    out <= {out[4:0], out[5]}; 
    endcase	
	end
end
endmodule 