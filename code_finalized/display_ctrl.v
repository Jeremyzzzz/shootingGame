module display_ctrl(
	clock,
	gun_dir,
	disp_state,
	size_monster,
	monster_pos_x_vector,
	monster_pos_y_vector,
	ball_x_vector,
	ball_y_vector,
	colour,
	x,
	y);
	
	input			clock;								
	input	[1:0]	gun_dir;
	input	[3:0]	disp_state	;
	input	[19:0]	size_monster;
	input	[31:0]	monster_pos_x_vector;
	input	[27:0]	monster_pos_y_vector;	
	input	[63:0]	ball_x_vector	;
	input	[55:0]	ball_y_vector	;	
	
	output	[2:0]	colour	;
	output  [7:0]	x		;
	output  [6:0]	y		;

	reg		[2:0]	colour	=3'b000;
	reg		[7:0]	x		=8'b0;
	reg		[6:0]	y		=7'b0;
	
	wire	[7:0]	gun_pos_x=80;
	wire	[6:0]	gun_pos_y=60;
	
	wire	[7:0]	monster_pos_x[19:0];
	wire	[6:0]	monster_pos_y[19:0];	
	wire	[7:0]	ball_x	[19:0];
	wire	[6:0]	ball_y	[19:0];	

	assign	{monster_pos_x[0],monster_pos_x[1],monster_pos_x[2],monster_pos_x[3]}=monster_pos_x_vector;
	assign	{monster_pos_y[0],monster_pos_y[1],monster_pos_y[2],monster_pos_y[3]}=monster_pos_y_vector;
	assign	{ball_x[0],ball_x[1],ball_x[2],ball_x[3],ball_x[4],ball_x[5],ball_x[6],ball_x[7]}=ball_x_vector;
	assign	{ball_y[0],ball_y[1],ball_y[2],ball_y[3],ball_y[4],ball_y[5],ball_y[6],ball_y[7]}=ball_y_vector;

	always@(posedge clock)begin
		if(x<8'd159)begin
			x<=x+8'b1;
		end
		else if(y<7'd119)begin
			x<=0;
			y<=y+7'b1;
		end
		else begin
			x<=0;
			y<=0;
		end
	end

	always@(posedge clock)begin
		if(disp_state==4'b0001)begin
			colour<=3'b000;
		end
		else if(disp_state==4'b0010)begin
			if(x>=10 && x<=150 && y>=10 && y<=110)begin
				if(x>=gun_pos_x-8'd5 && x<=gun_pos_x+8'd5 && y>=gun_pos_y-7'd5 && y<=gun_pos_y+7'd5)begin
					case(gun_dir)
						2'b00: begin
							if(x<=gun_pos_x)begin
								colour<=3'b100;
							end
							else if(y>=gun_pos_y-7'd2 && y<=gun_pos_y+7'd2)begin
								colour<=3'b100;
							end
							else begin
								colour<=3'b000;
							end
						end
						2'b01: begin
							if(y>=gun_pos_y)begin
								colour<=3'b100;
							end
							else if(x>=gun_pos_x-8'd2 && x<=gun_pos_x+8'd2)begin
								colour<=3'b100;
							end
							else begin
								colour<=3'b000;
							end
						end				
						2'b10: begin
							if(x>=gun_pos_x)begin
								colour<=3'b100;
							end
							else if(y>=gun_pos_y-7'd2 && y<=gun_pos_y+7'd2)begin
								colour<=3'b100;
							end
							else begin
								colour<=3'b000;
							end
						end
						2'b11: begin
							if(y<=gun_pos_y)begin
								colour<=3'b100;
							end
							else if(x>=gun_pos_x-8'd2 && x<=gun_pos_x+8'd2)begin
								colour<=3'b100;
							end
							else begin
								colour<=3'b000;
							end
						end
						default:begin
							if(x<=gun_pos_x)begin
								colour<=3'b100;
							end
							else if(y>=gun_pos_y-7'd2 && y<=gun_pos_y+7'd2)begin
								colour<=3'b100;
							end
							else begin
								colour<=3'b000;
							end
						end
					endcase						
				end
				else if(x>=ball_x[0]-1 && x<=ball_x[0]+1 && y>=ball_y[0]-1 && y<=ball_y[0]+1)
					colour<=3'b010;	
				else if(x>=ball_x[1]-1 && x<=ball_x[1]+1 && y>=ball_y[1]-1 && y<=ball_y[1]+1)
					colour<=3'b010;
				else if(x>=ball_x[2]-1 && x<=ball_x[2]+1 && y>=ball_y[2]-1 && y<=ball_y[2]+1)
					colour<=3'b010;
				else if(x>=ball_x[3]-1 && x<=ball_x[3]+1 && y>=ball_y[3]-1 && y<=ball_y[3]+1)
					colour<=3'b010;
				else if(x>=ball_x[4]-1 && x<=ball_x[4]+1 && y>=ball_y[4]-1 && y<=ball_y[4]+1)
					colour<=3'b010;
				else if(x>=ball_x[5]-1 && x<=ball_x[5]+1 && y>=ball_y[5]-1 && y<=ball_y[5]+1)
					colour<=3'b010;
				else if(x>=ball_x[6]-1 && x<=ball_x[6]+1 && y>=ball_y[6]-1 && y<=ball_y[6]+1)
					colour<=3'b010;
				else if(x>=ball_x[7]-1 && x<=ball_x[7]+1 && y>=ball_y[7]-1 && y<=ball_y[7]+1)
					colour<=3'b010;						
				/////////////////////////////////////////////////////////////////////////////////																									
				else if((x>=monster_pos_x[0]-3 && x<=monster_pos_x[0]+3 && y>=monster_pos_y[0]-3 && y<=monster_pos_y[0]+3) && size_monster[0]==0)
					colour<=3'b001;
				else if((x>=monster_pos_x[0]-3 && x<=monster_pos_x[0]+3 && y>=monster_pos_y[0]-3 && y<=monster_pos_y[0]+3) && size_monster[0]==1)
					colour<=3'b100;				
				else if((x>=monster_pos_x[1]-3 && x<=monster_pos_x[1]+3 && y>=monster_pos_y[1]-3 && y<=monster_pos_y[1]+3) && size_monster[1]==0)
					colour<=3'b001;
				else if((x>=monster_pos_x[1]-3 && x<=monster_pos_x[1]+3 && y>=monster_pos_y[1]-3 && y<=monster_pos_y[1]+3) && size_monster[1]==1)
					colour<=3'b100;					
				else if((x>=monster_pos_x[2]-3 && x<=monster_pos_x[2]+3 && y>=monster_pos_y[2]-3 && y<=monster_pos_y[2]+3) && size_monster[2]==0)
					colour<=3'b001;
				else if((x>=monster_pos_x[2]-3 && x<=monster_pos_x[2]+3 && y>=monster_pos_y[2]-3 && y<=monster_pos_y[2]+3) && size_monster[2]==1)
					colour<=3'b100;	
				else if((x>=monster_pos_x[3]-3 && x<=monster_pos_x[3]+3 && y>=monster_pos_y[3]-3 && y<=monster_pos_y[3]+3) && size_monster[3]==0)
					colour<=3'b001;
				else if((x>=monster_pos_x[3]-3 && x<=monster_pos_x[3]+3 && y>=monster_pos_y[3]-3 && y<=monster_pos_y[3]+3) && size_monster[3]==1)
					colour<=3'b100;					
				else
					colour<=3'b000;
			end
			else begin
				colour<=3'b000;
			end
		end
		else if(disp_state==4'b0100)begin
			colour<=3'b010;
		end
		else if(disp_state==4'b1000)begin
			colour<=3'b100;
		end
		else begin
			colour<=3'b000;
		end				
	end
	
	
	
	
	
	
endmodule
