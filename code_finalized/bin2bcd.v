/*************************************************
module	:bin2bcd(二进制转十进制)
input	:8位二进制数
output	:三个BCD码（四位）
function:实现数据类型转换
*************************************************/
module bin2bcd(
	clock,		//系统时钟
	bin,		//需要转换的数据
	y1,			//转换输出百位
	y2,			//转换输出十位
	y3);		//转换输出个位
	
	input			clock;
	input	[7:0]	bin;
	output	[3:0]	y1;
	output	[3:0]	y2;
	output	[3:0]	y3;
	
	reg		[3:0]	y1;
	reg		[3:0]	y2;
	reg		[3:0]	y3;
	
	reg		[3:0]	state=0;//状态机定义
	reg		[7:0]	A;		//中间变量
	reg		[3:0]	temp=0;		
	always@(posedge clock)begin
		case(state)
			0:begin//中间变量初始化，准备进行转换
				A<=bin;
				temp<=0;
				state<=1;
			end
			1:begin
				if(A>=100)begin//如果A大于等于100，则A-100，同时temp+1.
					A<=A-100;
					temp<=temp+1;
					state<=1;
				end
				else begin
					y1<=temp;//将temp赋值给dout_100，同时将其清零。进入下一个状态。
					temp<=0;
					state<=2;
				end
			end
			2:begin
				if(A>=10)begin//如果A大于等于10，则A-10，同时temp+1.
					A<=A-10;
					temp<=temp+1;
					state<=2;
				end
				else begin//将temp赋值给dout_10,将余数赋值dout_1
					y2<=temp;
					y3<=A[3:0];
					state<=0;
				end
			end
			default:state<=0;
		endcase		
	end

endmodule

