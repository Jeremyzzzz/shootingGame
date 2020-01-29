/*******************************************************************
ģ�����ƣ�ps2_keyboard
ʵ�ֹ��ܣ�PS2������������
********************************************************************/
module keyboard_PS2(
	clock,
	ps2_clk,
	ps2_dat,
	gun_dir,
	bombing,
	shooting);

	input			clock;									//50Mʱ���ź�
	input			ps2_clk;								//PS2�ӿ�ʱ���ź�
	input			ps2_dat;								//PS2�ӿ������ź�
	output	[1:0]	gun_dir;
	output			bombing;								
	output			shooting;

	reg		[1:0]	gun_dir=0;	
	reg				bombing=0;							
	reg		 		shooting=0;
	reg				dat_ready=0;
	//------------------------------------------
	reg				ps2_clk_delay1=0;						//ps2k_clk״̬�Ĵ���
	reg				ps2_clk_delay2=0;
	reg				ps2_clk_delay3=0;	
	wire			ps2_clk_neg;							// ps2k_clk�½��ر�־λ
	
	always @ (posedge clock ) begin							//���ؼ��							
		ps2_clk_delay1 <= ps2_clk;
		ps2_clk_delay2 <= ps2_clk_delay1;
		ps2_clk_delay3 <= ps2_clk_delay2;
	end

	assign ps2_clk_neg = ~ps2_clk_delay2 & ps2_clk_delay3;	//�½���

	//------------------------------------------
	reg	[7:0]	ps2_byte		=0;								//PC��������PS2��һ���ֽ����ݴ洢��
	reg	[7:0]	temp_data		=0;								//��ǰ�������ݼĴ���
	reg	[3:0] 	num				=0;								//�����Ĵ���
	reg 		ps2_state		=1;								//���̵�ǰ״̬��ps2_state_r=1��ʾ�м�������
	reg			ps2_state_delay1=0;								
	reg			ps2_state_delay2=0;
	reg 		key_flag		=0;								//�ɼ���־λ����1��ʾ���յ�����8'hf0���ٽ��յ���һ�����ݺ�����

	always@(posedge clock)begin
		ps2_state_delay1<=ps2_state;
		ps2_state_delay2<=ps2_state_delay1;
		dat_ready<=(~ps2_state_delay2) &  ps2_state_delay1;
	end

	always @ (posedge clock ) begin
		if(ps2_clk_neg) begin						//��⵽ps2k_clk���½���
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
						num <= num+1'b1;			//��żУ��λ����������
						end
				4'd10:  begin
						num <= 4'd0;				// num����
						end
				default:;
			endcase
		end	
	end 

	always @ (posedge clock)begin	//�������ݵ���Ӧ��������ֻ��1byte�ļ�ֵ���д���
		if(num==4'd10) begin	//�մ�����һ���ֽ�����
			if(temp_data == 8'hf0) 
				key_flag <= 1'b1;
			else begin
				if(!key_flag) begin	//˵���м�����
					ps2_state <= 1'b1;
					ps2_byte <= temp_data;	//���浱ǰ��ֵ
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
