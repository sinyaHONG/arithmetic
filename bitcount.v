/* 位计数电路：
**** 对寄存器A中值为1的位的个数进行计数。
**** 设计电路将数据按升序重新排列。
------------伪代码如下：----------
	B = 0;
	while A ≠ 0 do 
		if a0 = 1 then
			B = B + 1;
		end if;
		Right-shift A;
	end while 
----------------------------------
*定义A为8位数据，则 B为四位数剧
* [N-1 : 0] A
* [K-1 : 0] B
* K = log2 N
*/
module bitcount
#(	
	parameter N = 8,
	parameter K = 4
)
(
	
	input clk,
	input rst_n,
	input  [N-1:0] A,
	input A_en,
	
	output reg [K-1:0] B,
	output reg B_finish

);

parameter s0 = 4'd0;
parameter s1 = 4'd1;
parameter s2 = 4'd2;
parameter s3 = 4'd3;
parameter s4 = 4'd4;
parameter s5 = 4'd5;
parameter s6 = 4'd6;
parameter s7 = 4'd7;
parameter s8 = 4'd8;

reg [3:0]state;
reg [N-1:0] A_r;
reg [K-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= s0;
		B <= 0;
		cnt <= 0;
		B_finish<=0;
		A_r <= 0;
	end 
	else  begin 
		case(state) 
			s0: begin
					B_finish <= 0;
					if(A_en == 1) begin
						B <= 0;
						A_r <= A;
						state <= s1;
					end 
					else begin
						state <= s0;	
					end 
			end 
			s1: begin
					if(A_r[0] == 1)
						B <= B + 1;
					else 
						B <= B ;
						
					state <= s2;
			end 
			s2: begin 
					if(cnt < N) begin
						A_r[N-1:0] <= {1'b0, A_r[N-1 :1]};
						cnt <= cnt+1;
						state <= s1;
					end 
					else  begin
						state <= s4;
					end 
			end 
			s4: begin
					B_finish <= 1;
					state <= s0;
			
			end 
		endcase
	end 
end 


 
endmodule 

