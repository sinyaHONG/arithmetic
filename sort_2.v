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
* 输入为(2^K)个 N位数据
*/
module sort_2
#(	
	parameter N = 8,
	parameter K = 5
)
(
	
	input clk,
	input rst_n,
	input  [N-1:0] data_in,
	input wr_data,
	
	output reg [N-1:0] data_out,
	output reg data_out_en

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
parameter s9 = 4'd9;
parameter s10 = 4'd10;
reg [3:0]state;
reg rev_flag;



reg [N-1: 0] i;
reg [N-1: 0] j;

reg [N-1: 0] A;
reg [N-1: 0] B;
 
reg [N-1: 0] DATA_IN[K-1:0];
reg [K-1: 0] data_num; 
reg [K-1 : 0] out_num;
reg wr_done;
reg sort_done;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_num <= 0;
	end 
	else if(wr_data) begin 
		if(data_num <= K ) begin
			data_num <= data_num + 1;
		end
		else 
			data_num <=0;
	end 
	else begin
		data_num <= 0;
	end 
end 
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wr_done <=0;
		i <= 0;
		j <= 0;
		sort_done <= 0;
		state <= s0;
		out_num <=0;
		data_out_en <=0;
	end
	else begin
		case (state)
	
			s0:	begin
				
				if(wr_data) begin
					sort_done <= 0;
					state <= s1;
				end 
				else begin
					state <= s0; 
				end 
				i <= 0;
			
			end
			s1: begin
					if(data_num <= K)begin 
					DATA_IN[data_num-1] <= data_in;
					wr_done <= 0;					
				end 
				else begin
					state <= s2;
					wr_done <= 1;
				end 	
			end
			s2: begin
					A <= DATA_IN[i];
					j <= i;
					state <= s3;		
			end 
			s3: begin
				j <= j+1;
				state <= s4;
			end 
			s4: begin
				B <= DATA_IN[j];
				state <= s5;
			end
			s5: begin
				if(A > B)
					state <= s6;
				else 
					state <= s8;
			end 
			s6: begin
				DATA_IN[j] <= A;
				state <= s7;
			end 
			s7: begin
				DATA_IN[i] <= B;
				state <= s8;
			end
			s8: begin
				A <= DATA_IN[i] ;
				if(j == K-1) begin
					if(i == K-2) begin
						state <= s9;
					end 
					else begin
						i <= i+1;
						state <= s2;
					end 
				end 
				else begin
					j <= j+1;
					state <= s4;
				end 
				
			end
			s9: begin
				sort_done <= 1;
				data_out_en<=1;
				state <= 10;
			end 
			s10: begin
				
				if(out_num < K) begin
					data_out <= DATA_IN[out_num];
					out_num <= out_num +1;
				end 
				else begin
					data_out_en <=0;
					out_num <= 0;
					data_out <= 0;
					state <= s0;
				end 
			end 
		endcase 
	end 
end

 
endmodule 

