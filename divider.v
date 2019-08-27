/*除法器：
**** 
****		  
**** 
------------伪代码如下：----------
	P = 0;
	for i = 0 to n-1 do 
		left-shift R || A ;
		if R ≥ B then
			qi = 1;
			R = R - B ; 
		else
			qi = 0;
		else if ;
	end for; 
----------------------------------
*A B为 无符号 N位数据，电路产生 N 位的输出Q 和 R 
*其中 Q = A/B 的商， R是余数
*
*A 被乘数 B 为乘数
* [N-1 : 0] A
* [N-1 : 0] B
* [K-1 : 0] P
*/
module divider
#(	
	parameter N = 8
)
(
	
	input clk,
	input rst_n,
	input in_en,
	input  [N-1:0] data_A,
	input  [N-1:0] data_B,
	
	output  [N-1:0] data_R,
	output  [N-1:0] data_Q,
	output reg done

);

parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;


reg [3:0]state;
reg [3:0] next_state;

reg [N-1:0] B_r;
reg [N-1:0] A_r;

reg [N-1:0] R_r;
reg [N-1:0] Q_r;
reg [N-1:0] q_cnt;

//control circuit
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		 R_r <= 0;
		 Q_r <= 0;
		 q_cnt <= N-1;
		 A_r <= 0;
		 B_r <= 0;
		 done <= 0;
		 state<= S0 ;
	end
	case(state) 
		S0 : begin
				Q_r <= 0;
				R_r <= 0;
				q_cnt <= N-1;
				done <= 0;
				state <= S1;
		end 
		
		S1 : begin
				if(in_en) begin
					A_r <= data_A;
					B_r <= data_B;	
					state <= S2;					
				end
				else begin
					A_r <= 0;
					B_r <= 0;
					state <= S1;					
				end	
				
		end 
		S2 : begin
				 R_r <=  R_r << 1;
				 state <= S3;
		end 
		S3 : begin
				 R_r[0] <= A_r[q_cnt];
				 state <= S4;
		end 
		S4 : begin
				 if(R_r >= B_r) begin
					Q_r[q_cnt] <= 1;
					R_r <= R_r - B_r;
				 end 
				 else begin
					Q_r[q_cnt] <= 0;
					R_r <= R_r;
				 end 
				 state <= S5;
		end 
		S5 : begin
				if(q_cnt == 0) begin
					done <= 1;
					state <= S0;
				end 
				else begin
					q_cnt <= q_cnt - 1;
					state <= S2;
				end 

		end 
		default: state <= S0;
		
	endcase
end 


assign data_Q = (done == 1) ? Q_r : 0;
assign data_R = (done == 1) ? R_r : 0;
 
endmodule 

