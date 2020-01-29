/*******************************************************************
模块名称：ps2_keyboard
实现功能：PS2键盘驱动程序
********************************************************************/
module keyboard_PS2(
	clock,
	ps2_clk,
	ps2_dat,
	gun_dir,
	bombing,
	shooting);

	input			clock;									//50M时钟信号
	input			ps2_clk;								//PS2接口时钟信号
	input			ps2_dat;								//PS2接口数据信号
	output	[1:0]	gun_dir;
	output			bombing;								
	output			shooting;

	reg		[1:0]	gun_dir=0;	
	reg				bombing=0;							
	reg		 		shooting=0;
	reg				dat_ready=0;
	//------------------------------------------
	reg				ps2_clk_delay1=0;						//ps2k_clk状态寄存器
	reg				ps2_clk_delay2=0;
	reg				ps2_clk_delay3=0;	
	wire			ps2_clk_neg;							// ps2k_clk下降沿标志位
	
	always @ (posedge clock ) begin							//边沿检测							
		ps2_clk_delay1 <= ps2_clk;
		ps2_clk_delay2 <= ps2_clk_delay1;
		ps2_clk_delay3 <= ps2_clk_delay2;
	end

	assign ps2_clk_neg = ~ps2_clk_delay2 & ps2_clk_delay3;	//下降沿

	//------------------------------------------
	reg	[7:0]	ps2_byte		=0;								//PC接收来自PS2的一个字节数据存储器
	reg	[7:0]	temp_data		=0;								//当前接收数据寄存器
	reg	[3:0] 	num				=0;								//计数寄存器
	reg 		ps2_state		=1;								//键盘当前状态，ps2_state_r=1表示有键被按下
	reg			ps2_state_delay1=0;								
	reg			ps2_state_delay2=0;
	reg 		key_flag		=0;								//松键标志位，置1表示接收到数据8'hf0，再接收到下一个数据后清零

	always@(posedge clock)begin
		ps2_state_delay1<=ps2_state;
		ps2_state_delay2<=ps2_state_delay1;
		dat_ready<=(~ps2_state_delay2) &  ps2_state_delay1;
	end

	always @ (posedge clock ) begin
		if(ps2_clk_neg) begin						//检测到ps2k_clk的下降沿
			case (num)
				4'd0:	num <= num+1'b1;
				4'd1:	begin
						num <= num+1'b1;
						temp_data[0] <= ps2_dat;	//bit0
						end
				4'd2:	begin
						num <= num+1'b1;
						temp_data[1] <= ps2_dat;	//bit1
						end
				4'd3:	begin
						num <= num+1'b1;
						temp_data[2] <= ps2_dat;	//bit2
						end
				4'd4:	begin
						num <= num+1'b1;
						temp_data[3] <= ps2_dat;	//bit3
						end
				4'd5:	begin
						num <= num+1'b1;
						temp_data[4] <= ps2_dat;	//bit4
						end
				4'd6:	begin
						num <= num+1'b1;
						temp_data[5] <= ps2_dat;	//bit5
						end
				4'd7:	begin
						num <= num+1'b1;
						temp_data[6] <= ps2_dat;	//bit6
						end
				4'd8:	begin
						num <= num+1'b1;
						temp_data[7] <= ps2_dat;	//bit7
						end
				4'd9:	begin
						num <= num+1'b1;			//奇偶校验位，不做处理
						end
				4'd10:  begin
						num <= 4'd0;				// num清零
						end
				default:;
			endcase
		end	
	end 

	always @ (posedge clock)begin	//接收数据的相应处理，这里只对1byte的键值进行处理
		if(num==4'd10) begin	//刚传送完一个字节数据
			if(temp_data == 8'hf0) 
				key_flag <= 1'b1;
			else begin
				if(!key_flag) begin	//说明有键按下
					ps2_state <= 1'b1;
					ps2_byte <= temp_data;	//锁存当前键值
				end
				else begin
					ps2_state <= 1'b0;
					key_flag <= 1'b0;
				end
			end
		end
	end

	always @ (posedge clock)begin
		case (ps2_byte)
			8'h1d: gun_dir <= 2'b01;//8'h57;	//W			  	
			8'h1c: gun_dir <= 2'b10;//8'h41;	//A
			8'h1b: gun_dir <= 2'b11;//8'h53;	//S
			8'h23: gun_dir <= 2'b00;//8'h44;	//D								
			default:gun_dir<=gun_dir;
		endcase
	end
	
	always @ (posedge clock)begin
		if (ps2_byte==8'h44 && dat_ready==1)begin
			shooting<=1'b1;
		end
		else if (ps2_byte==8'h32 && dat_ready==1)begin
			bombing	<=1'b1;
		end		
		else begin
			bombing	<=1'b0;
			shooting<=1'b0;
		end
	end	
	
endmodule
