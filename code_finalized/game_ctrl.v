module game_ctrl(
	clock,
	reset,
	start,
	gun_dir,
	bombing,
	shooting,
	disp_state,
	size_monster,
	monster_pos_x_vector,
	monster_pos_y_vector,
	ball_x_vector,
	ball_y_vector,
	num_bomb,
	play_hp,
	play_score);


	input			clock;
	input			reset;
	input			start;
	input	[1:0]	gun_dir;
	input			bombing;
	input			shooting;
	output	[3:0]	disp_state;
	output	[3:0]	size_monster;
	output	[31:0]	monster_pos_x_vector;
	output	[27:0]	monster_pos_y_vector;	
	output	[63:0]	ball_x_vector	;
	output	[55:0]	ball_y_vector	;
	
	output	[3:0]	num_bomb	;		
	output	[3:0]	play_hp		;
	output  [7:0]	play_score	;
	
	parameter	IDLE 	= 4'b0001,
				RUN 	= 4'b0010,
				SUCESS 	= 4'b0100,
				FAIL 	= 4'b1000;
	
	reg		[3:0]	state=IDLE;


	reg		[7:0]	monster_pos_x[3:0];
	reg		[6:0]	monster_pos_y[3:0];	
	reg		[7:0]	ball_x	[7:0];
	reg		[6:0]	ball_y	[7:0];	
	
	reg		[1:0]	dir_monster	[3:0];
	reg		[3:0]	size_monster;
	reg		[1:0]	dir_ball	[7:0];	
	
	reg		[3:0]	num_bomb	=3;
	reg		[3:0]	play_hp		=3;
	reg		[7:0]	play_score	=0;
	
	reg		[4:0]	addr_ball	=0;
	reg		[4:0]	addr_monster=0;
	
	assign	monster_pos_x_vector={monster_pos_x[0],monster_pos_x[1],monster_pos_x[2],monster_pos_x[3]};
	assign	monster_pos_y_vector={monster_pos_y[0],monster_pos_y[1],monster_pos_y[2],monster_pos_y[3]};
	assign	ball_x_vector={ball_x[0],ball_x[1],ball_x[2],ball_x[3],ball_x[4],ball_x[5],ball_x[6],ball_x[7]};
	assign	ball_y_vector={ball_y[0],ball_y[1],ball_y[2],ball_y[3],ball_y[4],ball_y[5],ball_y[6],ball_y[7]};

	reg		[39:0]	cnt_pixel_updata=0;//ball
	reg				clk_pixel_updata=0;
	
	reg		[39:0]	cnt_pixel_updata_2=0;//monster
	reg				clk_pixel_updata_2=0;	
	
	wire	[3:0]	monster_sel;
	
	assign	monster_sel[0]=(monster_pos_x[0]<159) ? 1'b1 : 1'b0;
	assign	monster_sel[1]=(monster_pos_x[1]<159) ? 1'b1 : 1'b0;
	assign	monster_sel[2]=(monster_pos_x[2]<159) ? 1'b1 : 1'b0;
	assign	monster_sel[3]=(monster_pos_x[3]<159) ? 1'b1 : 1'b0;
	
	assign disp_state=state;
	
	always@(posedge clock)begin
		if(cnt_pixel_updata<1000000)begin
			cnt_pixel_updata<=cnt_pixel_updata+1;
			clk_pixel_updata<=0;
		end
		else begin
			cnt_pixel_updata<=0;
			clk_pixel_updata<=1;
		end
	end
	
	always@(posedge clock)begin
		if(cnt_pixel_updata_2<2000000)begin
			cnt_pixel_updata_2<=cnt_pixel_updata_2+1;
			clk_pixel_updata_2<=0;
		end
		else begin
			cnt_pixel_updata_2<=0;
			clk_pixel_updata_2<=1;
		end
	end	
	
	reg	[15:0]	tmp=16'h5555;
	reg	[39:0]	cnt_random=0;
	reg			clk_random=0;
	
	always@(posedge clock)begin
		if(cnt_random<200000000)begin
			cnt_random<=cnt_random+1;
			clk_random<=0;
		end
		else begin
			cnt_random<=0;
			clk_random<=1;
			tmp[15:1]<=tmp[14:0];
			tmp[0]<=tmp[15]^tmp[11]^tmp[2]^tmp[0];
		end
	end
	
	
	always@(posedge clock)begin
		case(state)
			IDLE:begin
				if(start==1)begin
					state<=RUN;
					num_bomb<=3;
					play_hp<=3;
					play_score<=0;
				end
				else begin
					state<=IDLE;
					monster_pos_x[0]<=159;
					monster_pos_x[1]<=159;
					monster_pos_x[2]<=159;
					monster_pos_x[3]<=159;
					
					monster_pos_y[0]<=119;
					monster_pos_y[1]<=119;
					monster_pos_y[2]<=119;
					monster_pos_y[3]<=119;
					////////////////////
					ball_x[0]<=0;
					ball_x[1]<=0;
					ball_x[2]<=0;
					ball_x[3]<=0;
					ball_x[4]<=0;
					ball_x[5]<=0;
					ball_x[6]<=0;
					ball_x[7]<=0;
					
					ball_y[0]<=0;
					ball_y[1]<=0;
					ball_y[2]<=0;
					ball_y[3]<=0;
					ball_y[4]<=0;
					ball_y[5]<=0;
					ball_y[6]<=0;
					ball_y[7]<=0;
					num_bomb<=3;
					play_hp<=3;
					play_score<=0;							
				end
			end
			RUN:begin
				if(reset==1)begin
					state<=IDLE;
				end
				else if(shooting==1)begin
					if(addr_ball<7)
						addr_ball<=addr_ball+1;
					else
						addr_ball<=0;
					dir_ball[addr_ball]<=gun_dir;
					case(gun_dir)
						2'b00:begin
							ball_x[addr_ball]<=85;
							ball_y[addr_ball]<=60;
						end
						2'b01:begin
							ball_x[addr_ball]<=80;
							ball_y[addr_ball]<=55;
						end
						2'b10:begin
							ball_x[addr_ball]<=75;
							ball_y[addr_ball]<=60;
						end
						2'b11:begin
							ball_x[addr_ball]<=80;
							ball_y[addr_ball]<=65;
						end
						default:begin
							ball_x[addr_ball]<=85;
							ball_y[addr_ball]<=60;
						end
					endcase
				end
				else if(clk_random==1)begin
					if(addr_monster<3)
						addr_monster<=addr_monster+1;
					else
						addr_monster<=0;
					dir_monster[addr_monster]<=tmp[9:8];
					size_monster[addr_monster]<=tmp[7];
					case(tmp[9:8])
						2'b00:begin
							monster_pos_x[addr_monster]<=150;
							monster_pos_y[addr_monster]<=60;
						end
						2'b01:begin
							monster_pos_x[addr_monster]<=80;
							monster_pos_y[addr_monster]<=10;
						end
						2'b10:begin
							monster_pos_x[addr_monster]<=10;
							monster_pos_y[addr_monster]<=60;
						end
						2'b11:begin
							monster_pos_x[addr_monster]<=80;
							monster_pos_y[addr_monster]<=110;
						end
						default:begin
							monster_pos_x[addr_ball]<=85;
							monster_pos_y[addr_ball]<=60;
						end
					endcase																								
				end
				else if(clk_pixel_updata==1)begin
					if(ball_x[0]>5 && ball_y[0]>5 && ball_x[0]<155 && ball_y[0]<115)begin
						case(dir_ball[0])
							2'b00:begin
								ball_x[0]<=ball_x[0]+1;
							end
							2'b01:begin
								ball_y[0]<=ball_y[0]-1;
							end
							2'b10:begin
								ball_x[0]<=ball_x[0]-1;
							end
							2'b11:begin
								ball_y[0]<=ball_y[0]+1;
							end
							default:begin
								ball_x[0]<=ball_x[0]+1;
							end
						endcase																											
					end
					else begin
						ball_x[0]<=0;
						ball_y[0]<=0;
					end
					
					if(ball_x[1]>5 && ball_y[1]>5 && ball_x[1]<155 && ball_y[1]<115)begin
						case(dir_ball[1])
							2'b00:begin
								ball_x[1]<=ball_x[1]+1;
							end
							2'b01:begin
								ball_y[1]<=ball_y[1]-1;
							end
							2'b10:begin
								ball_x[1]<=ball_x[1]-1;
							end
							2'b11:begin
								ball_y[1]<=ball_y[1]+1;
							end
							default:begin
								ball_x[1]<=ball_x[1]+1;
							end
						endcase																											
					end
					else begin
						ball_x[1]<=0;
						ball_y[1]<=0;
					end

					if(ball_x[2]>5 && ball_y[2]>5 && ball_x[2]<155 && ball_y[2]<115)begin
						case(dir_ball[2])
							2'b00:begin
								ball_x[2]<=ball_x[2]+1;
							end
							2'b01:begin
								ball_y[2]<=ball_y[2]-1;
							end
							2'b10:begin
								ball_x[2]<=ball_x[2]-1;
							end
							2'b11:begin
								ball_y[2]<=ball_y[2]+1;
							end
							default:begin
								ball_x[2]<=ball_x[2]+1;
							end
						endcase																											
					end
					else begin
						ball_x[2]<=0;
						ball_y[2]<=0;
					end

					if(ball_x[3]>5 && ball_y[3]>5 && ball_x[3]<155 && ball_y[3]<115)begin
						case(dir_ball[3])
							2'b00:begin
								ball_x[3]<=ball_x[3]+1;
							end
							2'b01:begin
								ball_y[3]<=ball_y[3]-1;
							end
							2'b10:begin
								ball_x[3]<=ball_x[3]-1;
							end
							2'b11:begin
								ball_y[3]<=ball_y[3]+1;
							end
							default:begin
								ball_x[3]<=ball_x[3]+1;
							end
						endcase																											
					end
					else begin
						ball_x[3]<=0;
						ball_y[3]<=0;
					end

					if(ball_x[4]>5 && ball_y[4]>5 && ball_x[4]<155 && ball_y[4]<115)begin
						case(dir_ball[4])
							2'b00:begin
								ball_x[4]<=ball_x[4]+1;
							end
							2'b01:begin
								ball_y[4]<=ball_y[4]-1;
							end
							2'b10:begin
								ball_x[4]<=ball_x[4]-1;
							end
							2'b11:begin
								ball_y[4]<=ball_y[4]+1;
							end
							default:begin
								ball_x[4]<=ball_x[4]+1;
							end
						endcase																											
					end
					else begin
						ball_x[4]<=0;
						ball_y[4]<=0;
					end					
				
					if(ball_x[5]>5 && ball_y[5]>5 && ball_x[5]<155 && ball_y[5]<115)begin
						case(dir_ball[5])
							2'b00:begin
								ball_x[5]<=ball_x[5]+1;
							end
							2'b01:begin
								ball_y[5]<=ball_y[5]-1;
							end
							2'b10:begin
								ball_x[5]<=ball_x[5]-1;
							end
							2'b11:begin
								ball_y[5]<=ball_y[5]+1;
							end
							default:begin
								ball_x[5]<=ball_x[5]+1;
							end
						endcase																											
					end
					else begin
						ball_x[5]<=0;
						ball_y[5]<=0;
					end
					
					if(ball_x[6]>5 && ball_y[6]>5 && ball_x[6]<155 && ball_y[6]<115)begin
						case(dir_ball[6])
							2'b00:begin
								ball_x[6]<=ball_x[6]+1;
							end
							2'b01:begin
								ball_y[6]<=ball_y[6]-1;
							end
							2'b10:begin
								ball_x[6]<=ball_x[6]-1;
							end
							2'b11:begin
								ball_y[6]<=ball_y[6]+1;
							end
							default:begin
								ball_x[6]<=ball_x[6]+1;
							end
						endcase																											
					end
					else begin
						ball_x[6]<=0;
						ball_y[6]<=0;
					end

					if(ball_x[7]>5 && ball_y[7]>5 && ball_x[7]<155 && ball_y[7]<115)begin
						case(dir_ball[7])
							2'b00:begin
								ball_x[7]<=ball_x[7]+1;
							end
							2'b01:begin
								ball_y[7]<=ball_y[7]-1;
							end
							2'b10:begin
								ball_x[7]<=ball_x[7]-1;
							end
							2'b11:begin
								ball_y[7]<=ball_y[7]+1;
							end
							default:begin
								ball_x[7]<=ball_x[7]+1;
							end
						endcase																											
					end
					else begin
						ball_x[7]<=0;
						ball_y[7]<=0;
					end				
				end
				else if(clk_pixel_updata_2==1)begin									
					if(monster_pos_x[0]>5 && monster_pos_y[0]>5 && monster_pos_x[0]<155 && monster_pos_y[0]<115)begin
						case(dir_monster[0])
							2'b00:begin
								monster_pos_x[0]<=monster_pos_x[0]-1;
							end
							2'b01:begin
								monster_pos_y[0]<=monster_pos_y[0]+1;
							end
							2'b10:begin
								monster_pos_x[0]<=monster_pos_x[0]+1;
							end
							2'b11:begin
								monster_pos_y[0]<=monster_pos_y[0]-1;
							end
							default:begin
								monster_pos_x[0]<=monster_pos_x[0]-1;
							end
						endcase																											
					end
					else begin
						monster_pos_x[0]<=159;
						monster_pos_y[0]<=119;
					end
					
					if(monster_pos_x[1]>5 && monster_pos_y[1]>5 && monster_pos_x[1]<155 && monster_pos_y[1]<115)begin
						case(dir_monster[1])
							2'b00:begin
								monster_pos_x[1]<=monster_pos_x[1]-1;
							end
							2'b01:begin
								monster_pos_y[1]<=monster_pos_y[1]+1;
							end
							2'b10:begin
								monster_pos_x[1]<=monster_pos_x[1]+1;
							end
							2'b11:begin
								monster_pos_y[1]<=monster_pos_y[1]-1;
							end
							default:begin
								monster_pos_x[1]<=monster_pos_x[1]-1;
							end
						endcase																											
					end
					else begin
						monster_pos_x[1]<=159;
						monster_pos_y[1]<=119;
					end

					if(monster_pos_x[2]>5 && monster_pos_y[2]>5 && monster_pos_x[2]<155 && monster_pos_y[2]<115)begin
						case(dir_monster[2])
							2'b00:begin
								monster_pos_x[2]<=monster_pos_x[2]-1;
							end
							2'b01:begin
								monster_pos_y[2]<=monster_pos_y[2]+1;
							end
							2'b10:begin
								monster_pos_x[2]<=monster_pos_x[2]+1;
							end
							2'b11:begin
								monster_pos_y[2]<=monster_pos_y[2]-1;
							end
							default:begin
								monster_pos_x[2]<=monster_pos_x[2]-1;
							end
						endcase																											
					end
					else begin
						monster_pos_x[2]<=159;
						monster_pos_y[2]<=119;
					end

					if(monster_pos_x[3]>5 && monster_pos_y[3]>5 && monster_pos_x[3]<155 && monster_pos_y[3]<115)begin
						case(dir_monster[3])
							2'b00:begin
								monster_pos_x[3]<=monster_pos_x[3]-1;
							end
							2'b01:begin
								monster_pos_y[3]<=monster_pos_y[3]+1;
							end
							2'b10:begin
								monster_pos_x[3]<=monster_pos_x[3]+1;
							end
							2'b11:begin
								monster_pos_y[3]<=monster_pos_y[3]-1;
							end
							default:begin
								monster_pos_x[3]<=monster_pos_x[3]-1;
							end
						endcase																											
					end
					else begin
						monster_pos_x[3]<=159;
						monster_pos_y[3]<=119;
					end				
				end				
				else if((ball_x[0]-monster_pos_x[0])*(ball_x[0]-monster_pos_x[0])+(ball_y[0]-monster_pos_y[0])*(ball_y[0]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[0]<=0;
					ball_y[0]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[0]-monster_pos_x[1])*(ball_x[0]-monster_pos_x[1])+(ball_y[0]-monster_pos_y[1])*(ball_y[0]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[0]<=0;
					ball_y[0]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[0]-monster_pos_x[2])*(ball_x[0]-monster_pos_x[2])+(ball_y[0]-monster_pos_y[2])*(ball_y[0]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[0]<=0;
					ball_y[0]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[0]-monster_pos_x[3])*(ball_x[0]-monster_pos_x[3])+(ball_y[0]-monster_pos_y[3])*(ball_y[0]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[0]<=0;
					ball_y[0]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end
	
				else if((ball_x[1]-monster_pos_x[0])*(ball_x[1]-monster_pos_x[0])+(ball_y[1]-monster_pos_y[0])*(ball_y[1]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[1]<=0;
					ball_y[1]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[1]-monster_pos_x[1])*(ball_x[1]-monster_pos_x[1])+(ball_y[1]-monster_pos_y[1])*(ball_y[1]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[1]<=0;
					ball_y[1]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[1]-monster_pos_x[2])*(ball_x[1]-monster_pos_x[2])+(ball_y[1]-monster_pos_y[2])*(ball_y[1]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[1]<=0;
					ball_y[1]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[1]-monster_pos_x[3])*(ball_x[1]-monster_pos_x[3])+(ball_y[1]-monster_pos_y[3])*(ball_y[1]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[1]<=0;
					ball_y[1]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end

				else if((ball_x[2]-monster_pos_x[0])*(ball_x[2]-monster_pos_x[0])+(ball_y[2]-monster_pos_y[0])*(ball_y[2]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[2]<=0;
					ball_y[2]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[2]-monster_pos_x[1])*(ball_x[2]-monster_pos_x[1])+(ball_y[2]-monster_pos_y[1])*(ball_y[2]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[2]<=0;
					ball_y[2]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[2]-monster_pos_x[2])*(ball_x[2]-monster_pos_x[2])+(ball_y[2]-monster_pos_y[2])*(ball_y[2]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[2]<=0;
					ball_y[2]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[2]-monster_pos_x[3])*(ball_x[2]-monster_pos_x[3])+(ball_y[2]-monster_pos_y[3])*(ball_y[2]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[2]<=0;
					ball_y[2]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end

				else if((ball_x[3]-monster_pos_x[0])*(ball_x[3]-monster_pos_x[0])+(ball_y[3]-monster_pos_y[0])*(ball_y[3]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[3]<=0;
					ball_y[3]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[3]-monster_pos_x[1])*(ball_x[3]-monster_pos_x[1])+(ball_y[3]-monster_pos_y[1])*(ball_y[3]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[3]<=0;
					ball_y[3]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[3]-monster_pos_x[2])*(ball_x[3]-monster_pos_x[2])+(ball_y[3]-monster_pos_y[2])*(ball_y[3]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[3]<=0;
					ball_y[3]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[3]-monster_pos_x[3])*(ball_x[3]-monster_pos_x[3])+(ball_y[3]-monster_pos_y[3])*(ball_y[3]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[3]<=0;
					ball_y[3]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end
					
				else if((ball_x[4]-monster_pos_x[0])*(ball_x[4]-monster_pos_x[0])+(ball_y[4]-monster_pos_y[0])*(ball_y[4]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[4]<=0;
					ball_y[4]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[4]-monster_pos_x[1])*(ball_x[4]-monster_pos_x[1])+(ball_y[4]-monster_pos_y[1])*(ball_y[4]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[4]<=0;
					ball_y[4]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[4]-monster_pos_x[2])*(ball_x[4]-monster_pos_x[2])+(ball_y[4]-monster_pos_y[2])*(ball_y[4]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[4]<=0;
					ball_y[4]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[4]-monster_pos_x[3])*(ball_x[4]-monster_pos_x[3])+(ball_y[4]-monster_pos_y[3])*(ball_y[4]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[4]<=0;
					ball_y[4]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end
					
				else if((ball_x[5]-monster_pos_x[0])*(ball_x[5]-monster_pos_x[0])+(ball_y[5]-monster_pos_y[0])*(ball_y[5]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[5]<=0;
					ball_y[5]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[5]-monster_pos_x[1])*(ball_x[5]-monster_pos_x[1])+(ball_y[5]-monster_pos_y[1])*(ball_y[5]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[5]<=0;
					ball_y[5]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[5]-monster_pos_x[2])*(ball_x[5]-monster_pos_x[2])+(ball_y[5]-monster_pos_y[2])*(ball_y[5]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[5]<=0;
					ball_y[5]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[5]-monster_pos_x[3])*(ball_x[5]-monster_pos_x[3])+(ball_y[5]-monster_pos_y[3])*(ball_y[5]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[5]<=0;
					ball_y[5]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end

				else if((ball_x[6]-monster_pos_x[0])*(ball_x[6]-monster_pos_x[0])+(ball_y[6]-monster_pos_y[0])*(ball_y[6]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[6]<=0;
					ball_y[6]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end

				else if((ball_x[6]-monster_pos_x[1])*(ball_x[6]-monster_pos_x[1])+(ball_y[6]-monster_pos_y[1])*(ball_y[6]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[6]<=0;
					ball_y[6]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[6]-monster_pos_x[2])*(ball_x[6]-monster_pos_x[2])+(ball_y[6]-monster_pos_y[2])*(ball_y[6]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[6]<=0;
					ball_y[6]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[6]-monster_pos_x[3])*(ball_x[6]-monster_pos_x[3])+(ball_y[6]-monster_pos_y[3])*(ball_y[6]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[6]<=0;
					ball_y[6]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end

				else if((ball_x[7]-monster_pos_x[0])*(ball_x[7]-monster_pos_x[0])+(ball_y[7]-monster_pos_y[0])*(ball_y[7]-monster_pos_y[0])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[7]<=0;
					ball_y[7]<=0;
					monster_pos_x[0]<=159;
					monster_pos_y[0]<=119;
				end
				else if((ball_x[7]-monster_pos_x[1])*(ball_x[7]-monster_pos_x[1])+(ball_y[7]-monster_pos_y[1])*(ball_y[7]-monster_pos_y[1])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[7]<=0;
					ball_y[7]<=0;
					monster_pos_x[1]<=159;
					monster_pos_y[1]<=119;
				end
				else if((ball_x[7]-monster_pos_x[2])*(ball_x[7]-monster_pos_x[2])+(ball_y[7]-monster_pos_y[2])*(ball_y[7]-monster_pos_y[2])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[7]<=0;
					ball_y[7]<=0;
					monster_pos_x[2]<=159;
					monster_pos_y[2]<=119;
				end
				else if((ball_x[7]-monster_pos_x[3])*(ball_x[7]-monster_pos_x[3])+(ball_y[7]-monster_pos_y[3])*(ball_y[7]-monster_pos_y[3])<=25)begin
					if(play_score+2<99)begin
						play_score<=play_score+2;
					end
					else begin
						play_score<=99;
					end
					ball_x[7]<=0;
					ball_y[7]<=0;
					monster_pos_x[3]<=159;
					monster_pos_y[3]<=119;
				end

				else if((monster_pos_x[0]-80)*(monster_pos_x[0]-80)+(monster_pos_y[0]-60)*(monster_pos_y[0]-60)<=81)begin	
					if(play_hp>0)begin
						play_hp<=play_hp-1;
					end
					else begin
						play_hp<=0;
						state<=FAIL;
					end
					monster_pos_x[0]<=159;
					monster_pos_x[1]<=159;
					monster_pos_x[2]<=159;
					monster_pos_x[3]<=159;
					
					monster_pos_y[0]<=119;
					monster_pos_y[1]<=119;
					monster_pos_y[2]<=119;
					monster_pos_y[3]<=119;

					////////////////////
					ball_x[0]<=0;
					ball_x[1]<=0;
					ball_x[2]<=0;
					ball_x[3]<=0;
					ball_x[4]<=0;
					ball_x[5]<=0;
					ball_x[6]<=0;
					ball_x[7]<=0;
					
					ball_y[0]<=0;
					ball_y[1]<=0;
					ball_y[2]<=0;
					ball_y[3]<=0;
					ball_y[4]<=0;
					ball_y[5]<=0;
					ball_y[6]<=0;
					ball_y[7]<=0;				
				end
				else if((monster_pos_x[1]-80)*(monster_pos_x[1]-80)+(monster_pos_y[1]-60)*(monster_pos_y[1]-60)<=81)begin	
					if(play_hp>0)begin
						play_hp<=play_hp-1;
					end
					else begin
						play_hp<=0;
						state<=FAIL;
					end
					monster_pos_x[0]<=159;
					monster_pos_x[1]<=159;
					monster_pos_x[2]<=159;
					monster_pos_x[3]<=159;
					
					monster_pos_y[0]<=119;
					monster_pos_y[1]<=119;
					monster_pos_y[2]<=119;
					monster_pos_y[3]<=119;

					////////////////////
					ball_x[0]<=0;
					ball_x[1]<=0;
					ball_x[2]<=0;
					ball_x[3]<=0;
					ball_x[4]<=0;
					ball_x[5]<=0;
					ball_x[6]<=0;
					ball_x[7]<=0;
					
					ball_y[0]<=0;
					ball_y[1]<=0;
					ball_y[2]<=0;
					ball_y[3]<=0;
					ball_y[4]<=0;
					ball_y[5]<=0;
					ball_y[6]<=0;
					ball_y[7]<=0;
					
				end
				else if((monster_pos_x[2]-80)*(monster_pos_x[2]-80)+(monster_pos_y[2]-60)*(monster_pos_y[2]-60)<=81)begin	
					if(play_hp>0)begin
						play_hp<=play_hp-1;
					end
					else begin
						play_hp<=0;
						state<=FAIL;
					end
					monster_pos_x[0]<=159;
					monster_pos_x[1]<=159;
					monster_pos_x[2]<=159;
					monster_pos_x[3]<=159;
					
					monster_pos_y[0]<=119;
					monster_pos_y[1]<=119;
					monster_pos_y[2]<=119;
					monster_pos_y[3]<=119;

					////////////////////
					ball_x[0]<=0;
					ball_x[1]<=0;
					ball_x[2]<=0;
					ball_x[3]<=0;
					ball_x[4]<=0;
					ball_x[5]<=0;
					ball_x[6]<=0;
					ball_x[7]<=0;
					
					ball_y[0]<=0;
					ball_y[1]<=0;
					ball_y[2]<=0;
					ball_y[3]<=0;
					ball_y[4]<=0;
					ball_y[5]<=0;
					ball_y[6]<=0;
					ball_y[7]<=0;						
				end
				else if((monster_pos_x[3]-80)*(monster_pos_x[3]-80)+(monster_pos_y[3]-60)*(monster_pos_y[3]-60)<=81)begin	
					if(play_hp>0)begin
						play_hp<=play_hp-1;
					end
					else begin
						play_hp<=0;
						state<=FAIL;
					end
					monster_pos_x[0]<=159;
					monster_pos_x[1]<=159;
					monster_pos_x[2]<=159;
					monster_pos_x[3]<=159;
					
					monster_pos_y[0]<=119;
					monster_pos_y[1]<=119;
					monster_pos_y[2]<=119;
					monster_pos_y[3]<=119;

					////////////////////
					ball_x[0]<=0;
					ball_x[1]<=0;
					ball_x[2]<=0;
					ball_x[3]<=0;
					ball_x[4]<=0;
					ball_x[5]<=0;
					ball_x[6]<=0;
					ball_x[7]<=0;
					
					ball_y[0]<=0;
					ball_y[1]<=0;
					ball_y[2]<=0;
					ball_y[3]<=0;
					ball_y[4]<=0;
					ball_y[5]<=0;
					ball_y[6]<=0;
					ball_y[7]<=0;					
				end
				else begin
					state<=RUN;
				end
				if(play_score==99)begin
					state<=SUCESS;
				end
				if(bombing==1)begin
					if(num_bomb>0)begin						
						if(monster_sel==4'b0001 || monster_sel==4'b0010 || monster_sel==4'b0100 || monster_sel==4'b1000)begin
							if(play_score+2<99)begin
								play_score<=play_score+2;
							end
							else begin
								play_score<=99;
							end
						end
						else if(monster_sel==4'b0011 || monster_sel==4'b0110 || monster_sel==4'b1100 || monster_sel==4'b1001 || monster_sel==4'b0101 || monster_sel==4'b1010)begin
							if(play_score+4<99)begin
								play_score<=play_score+4;
							end
							else begin
								play_score<=99;
							end
						end
						else if(monster_sel==4'b1110 || monster_sel==4'b1101 || monster_sel==4'b1011 || monster_sel==4'b0111)begin
							if(play_score+6<99)begin
								play_score<=play_score+6;
							end
							else begin
								play_score<=99;
							end
						end
						else if(monster_sel==4'b1111)begin
							if(play_score+8<99)begin
								play_score<=play_score+6;
							end
							else begin
								play_score<=99;
							end
						end
						else begin
							play_score<=play_score;
						end
						monster_pos_x[0]<=159;
						monster_pos_x[1]<=159;
						monster_pos_x[2]<=159;
						monster_pos_x[3]<=159;
						
						monster_pos_y[0]<=119;
						monster_pos_y[1]<=119;
						monster_pos_y[2]<=119;
						monster_pos_y[3]<=119;
						////////////////////
						ball_x[0]<=0;
						ball_x[1]<=0;
						ball_x[2]<=0;
						ball_x[3]<=0;
						ball_x[4]<=0;
						ball_x[5]<=0;
						ball_x[6]<=0;
						ball_x[7]<=0;
						
						ball_y[0]<=0;
						ball_y[1]<=0;
						ball_y[2]<=0;
						ball_y[3]<=0;
						ball_y[4]<=0;
						ball_y[5]<=0;
						ball_y[6]<=0;
						ball_y[7]<=0;
						num_bomb<=num_bomb-1;
					end
					else begin
						num_bomb<=0;
					end
				end
			end
			SUCESS:begin
				if(reset==1)begin
					state<=IDLE;
				end
				else begin
					state<=SUCESS;
				end
			end
			FAIL:begin
				if(reset==1)begin
					state<=IDLE;
				end
				else begin
					state<=FAIL;
				end				
			end			
			default:begin
				state<=IDLE;
			end
		endcase			
	end

	
	
	
	
endmodule
