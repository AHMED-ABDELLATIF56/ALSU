module ALSU (clk,rst,A,B,cin,si,red_op_A,red_op_B,opcode,bypass_A,bypass_b,direction,leds,out);
	parameter INPUT_PRIORITY="A";
	parameter FULL_ADDER="on";
	input clk,rst,cin,si,red_op_A,red_op_B,bypass_A,bypass_b,direction;
	input [2:0]A,B,opcode;
	output reg[15:0]leds;
	output reg[5:0]out;
	reg cin_reg,si_reg,red_op_A_reg,red_op_B_reg,bypass_A_reg,bypass_b_reg,direction_reg;
	reg [2:0]A_reg,B_reg,opcode_reg;
	always @(posedge clk or posedge rst) begin 
		if(rst) begin
			{cin_reg,si_reg,red_op_A_reg,red_op_B_reg,bypass_A_reg,
			bypass_b_reg,direction_reg,A_reg,B_reg,opcode_reg} <= 0;
		end else begin
			cin_reg <= cin; si_reg<=si; red_op_A_reg<=red_op_A; red_op_B_reg<=red_op_B; bypass_A_reg<=bypass_A;
			bypass_b_reg<=bypass_b; direction_reg<=direction; A_reg<=A; B_reg<=B; opcode_reg<=opcode;
		end
	end
	always @(posedge clk or posedge rst) begin 
		if(rst) begin
			out <= 0; leds<=0;
		end else if (bypass_A_reg&bypass_b_reg) begin
			if(INPUT_PRIORITY=="A") out<=A_reg;
				else out<=B_reg;
		end else if(bypass_A_reg) begin
			 out<=A_reg; leds<=0;
		end else if(bypass_b_reg) begin
			 out<=B_reg; leds<=0;
		end else begin
			case (opcode)
				0: begin if (red_op_A_reg&red_op_B_reg) begin
					if(INPUT_PRIORITY=="A") out<=&(A_reg);
					else out<=&(B_reg); 
					end
					else if(red_op_A_reg) out<=&(A_reg);
					else if(red_op_B_reg) out<=&(B_reg);
					else out<=A_reg&B_reg;
				end
				1: begin if (red_op_A_reg&red_op_B_reg) begin
					if(INPUT_PRIORITY=="A") out<=^(A_reg);
					else out<=^(B_reg); 
					end 
					if(red_op_A_reg) out<=^(A_reg);
					else if(red_op_B_reg) out<=^(B_reg);
					else out<=A_reg^B_reg;
				end
				2: begin if (red_op_A_reg|red_op_B_reg) begin
					leds<=0;
					repeat(50) leds<=~leds;
					out<= 0;
					end else if (FULL_ADDER=="on") begin
						out<= A_reg+B_reg+cin_reg;
					end else out<= A_reg+B_reg;
				end 
				3: begin if (red_op_A_reg|red_op_B_reg) begin
					leds<=0;
					repeat(50) leds<=~leds;
					out<= 0;
					end else out<= A_reg*B_reg;
				end
				4: begin if (red_op_A_reg|red_op_B_reg) begin
					out<= 0;
					repeat(50) begin 
						leds<=~leds;
					end	
					end else if (direction_reg) out<= {out[4:0],si};
					else out<= {si,out[5:1]};
				end 
				5: begin if (red_op_A_reg|red_op_B_reg) begin
					out<= 0;
					repeat(50) begin
						leds<=~leds;
					end 
					end else if (direction_reg) out<= {out[4:0],out[5]};
					else out<= {out[0],out[5:1]};
				end 
				default: begin 
					out<= 0;
					repeat(50) begin
						leds<=~leds;
					end 
				end 
			endcase
		end
	end
endmodule : ALSU