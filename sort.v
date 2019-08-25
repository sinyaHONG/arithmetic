/* 排序操作：
**** k个n位无符号组成的序列存在寄存器R0~Rk-1中,
**** 设计电路将数据按升序重新排列。
------------伪代码如下：----------
for i=0 to k-2 do
	A = Ri;
	for j=i+1 to k-1 do 
		B = Rj;
		if B < A then
			Ri = B;
			Rj = A;
			A = Ri;
		end if;
	end for
end for 
----------------------------------
*
* start = 1 sorting 
* finish = 1 sort finished
*/
module sort
#(	
	parameter N = 8,
	parameter K = 10
)
(
//	input reg [N-1:0] R_IN [K-1 :0],
//	input reg [7:0]R_IN [0:9],
	input clk,
	input rst_n
//	output [N-1:0] temp_r [K-1 :0],
//	output reg [7:0] temp_r [0:9]

);

parameter s0 = 4'd0;
parameter s1 = 4'd1;
parameter s2 = 4'd2;
parameter s3 = 4'd3;
parameter s4 = 4'd4;
parameter s5 = 4'd5;

reg [3:0]state;

reg [N-1 : 0] cnt;
reg [N-1 : 0] i;

reg [N-1 : 0] i_min;
reg [N-1 : 0] R_min;

reg start;
reg finish;
reg [N-1:0] R_IN [K-1:0];

  
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 0;
		
		i <= 1;
		state <= s0;
		finish <= 0;
		start <= 0;
		i_min <= 0;
		R_min <= 0;
		
		R_IN [0]  <= 8'h42;
		R_IN [1]  <= 8'h12;
		R_IN [2]  <= 8'h02;
		R_IN [3]  <= 8'h20;
		R_IN [4]  <= 8'h2a;
		R_IN [5]  <= 8'h29;
		R_IN [6]  <= 8'h22;
		R_IN [7]  <= 8'h52;
		R_IN [8]  <= 8'h01;
		R_IN [9]  <= 8'h00; 
		
	end
	else begin
		case(state) 
			
			s0: begin
					if(finish == 0) 
						start <= 1;
					else 
						start <= 0;
						
					if(start) begin
						i <= 1;
						R_min <= R_IN[cnt];
						i_min <= cnt;
						state <= s1;
					end 
			end
			s1: begin
					if( i <= K-1) begin
						if (R_min > R_IN[cnt+i]) begin
							R_min <= R_IN[cnt+i];
							i_min <= cnt+i;
						end
						else begin 
							R_min <= R_min;
							i_min <= i_min;
						end 
						state <= s2;	
					end 
					else begin
						R_IN[i_min] <= R_IN[cnt];
						state <= s3;
					end 				
			end
			s2: begin
					i <= i+1;
					state <= s1;
			
			end
			s3: begin	
					R_IN[cnt] <= R_min;
					cnt <= cnt + 1;
					state <= s4;
			end
			s4: begin
					state <= s0;
					if(cnt == K-1) begin 
						 cnt <= 0;
						 start <= 0;
						 finish <=1;
					end 
					else begin
						cnt <= cnt ;
					end 
					
					
			end 
		endcase
	end
end
//assign finish = (cnt == (K-1))? 1:0;
endmodule 

