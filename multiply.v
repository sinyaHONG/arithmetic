/*移位相加乘法器：
****方法一： 使用两个同样的二维阵列子电路，
****		 每个子电路包含一个全加器和一个与门。
****方法二： 利用一个移位寄存器结合一个加法器，
------------伪代码如下：----------
	P = 0;
	for i = 0 to n-1 do 
		if bi = 1 then
			P = P + A;
		end if;
		left-shift A;
	end for; 
----------------------------------
*定义A B为N位数据，A*B = P,P 为K 位数。
*A 被乘数 B 为乘数
* K = 2N
* [N-1 : 0] A
* [N-1 : 0] B
* [K-1 : 0] P
*/
module multiply
#(	
	parameter N = 8,
	parameter K = 16
)
(
	
	input clk,
	input rst_n,
	input in_en,
	input  [N-1:0] A,
	input  [N-1:0] B,
	output reg done,
	output  [K-1:0] P

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

reg [N-1:0] B_r;

reg [N-1:0] b_cnt;
reg [K-1:0] A_r;
reg [K-1:0] P_r;


reg s; //输入数据是否装载进A_r
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		A_r <= 0;
		B_r <= 0;
		P_r <= 0;
		b_cnt <= 0;
		done <=0;
		state <= s1;
		
	end 
	else  begin 
		case(state) 
			s1: begin
					P_r <= 0;
					done <=0;
					if(in_en ==1) begin
						A_r <= A;
						B_r <= B;
						s <= 1;
					end 
					else if(s == 1) begin
						state <= s2;
					end 
					else begin
						s <= 0;
					end 								
			end 
			s2: begin
					
					b_cnt <= 0;
					A_r <= { 8'b0, A_r};
					state <= s3;
					
			end 
			s3: begin 
					if(B_r[b_cnt] == 1) begin
						P_r <= P_r  + A_r;	
					end 
					else begin
						P_r <= P_r ;
					end
					state <= s4;
			end 
			s4: begin			
					if(b_cnt < N) begin
						A_r <= (A_r << 1);
						b_cnt <= b_cnt + 1; 
						state <= s3;
					end 
					else begin
						b_cnt <= 0;
						state <= s5;
					end 
					
				end 
			s5: begin
					done <= 1;
					state <= s1;
			
			end 
			
		endcase
	end 
end 
assign P = (done == 1) ? P_r : 0;
 
 
endmodule 

