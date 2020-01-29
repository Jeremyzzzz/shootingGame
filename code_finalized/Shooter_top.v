// Part 2 skeleton

module Shooter_top
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
        PS2_CLK,
        PS2_DAT,
        
        HEX3,
        HEX2,
        HEX1,
        HEX0, 
        LEDR,  
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [17:0]  SW;
	input   [3:0]   KEY;
    input     		PS2_CLK;
    input   	    PS2_DAT; 
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output	[6:0]	HEX3;
	output	[6:0]	HEX2;
	output	[6:0]	HEX1;
	output	[6:0]	HEX0;
	
	output	[15:0]	LEDR;
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn=1'b1;
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire	[2:0]	colour	;
	wire	[7:0]	x		;
	wire	[6:0]	y		;
	wire			writeEn	=1'b1;
	
	wire	[1:0]	gun_dir	;
	wire			shooting;
	
	wire	[31:0]	monster_pos_x_vector;
	wire	[27:0]	monster_pos_y_vector;	
	wire	[63:0]	ball_x_vector	;
	wire	[55:0]	ball_y_vector	;
		
	wire	[3:0]	dat1;
	wire	[3:0]	dat2;
	wire	[3:0]	play_hp		;
	wire	[7:0]	play_score	;
	wire	[3:0]	disp_state	;
	wire	[19:0]	size_monster;
	wire			bombing		;
	wire	[3:0]	num_bomb	;
	
	assign	LEDR={play_hp,play_score};
		
	keyboard_PS2 u1(
		.clock(CLOCK_50),
		.ps2_clk(PS2_CLK),
		.ps2_dat(PS2_DAT),
		.gun_dir(gun_dir),
		.bombing(bombing),
		.shooting(shooting));

	game_ctrl u2(
		.clock(CLOCK_50),
		.reset(SW[0]),
		.start(SW[1]),		
		.gun_dir(gun_dir),
		.bombing(bombing),
		.shooting(shooting),
		.disp_state(disp_state),
		.size_monster(size_monster),
		.monster_pos_x_vector(monster_pos_x_vector),
		.monster_pos_y_vector(monster_pos_y_vector),
		.ball_x_vector(ball_x_vector),
		.ball_y_vector(ball_y_vector),	
		.num_bomb(num_bomb),
		.play_hp(play_hp),
		.play_score(play_score));

	bin2bcd u3(
		.clock(CLOCK_50),	//系统时钟
		.bin(play_score),		//需要转换的数据
		.y1(),				//转换输出百位
		.y2(dat1),			//转换输出十位
		.y3(dat2));			//转换输出个位

	seg7_decoder u4(
		.dat1_i(num_bomb),
		.dat2_i(play_hp),
		.dat3_i(dat1),
		.dat4_i(dat2),
		.seg1_o(HEX3),
		.seg2_o(HEX2),
		.seg3_o(HEX1),
		.seg4_o(HEX0)); 

	display_ctrl u5(
		.clock(CLOCK_50),
		.gun_dir(gun_dir),
		.disp_state(disp_state),
		.size_monster(size_monster),		
		.monster_pos_x_vector(monster_pos_x_vector),
		.monster_pos_y_vector(monster_pos_y_vector),
		.ball_x_vector(ball_x_vector),
		.ball_y_vector(ball_y_vector),		
		.colour(colour),
		.x(x),
		.y(y));
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);

    // Instansiate FSM control
    // control c0(...);
    
endmodule
