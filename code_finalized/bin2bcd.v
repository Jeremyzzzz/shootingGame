/*************************************************
module	:bin2bcd(������תʮ����)
input	:8λ��������
output	:����BCD�루��λ��
function:ʵ����������ת��
*************************************************/
module bin2bcd(
	clock,		//ϵͳʱ��
	bin,		//��Ҫת��������
	y1,			//ת�������λ
	y2,			//ת�����ʮλ
	y3);		//ת�������λ
	
	input			clock;
	input	[7:0]	bin;
	output	[3:0]	y1;
	output	[3:0]	y2;
	output	[3:0]	y3;
	
	reg		[3:0]	y1;
	reg		[3:0]	y2;
	reg		[3:0]	y3;
	
	reg		[3:0]	state=0;//״̬������
	reg		[7:0]	A;		//�м����
	reg		[3:0]	temp=0;		
	always@(posedge clock)begin
		case(state)
			0:begin//�м������ʼ����׼������ת��
				A<=bin;
				temp<=0;
				state<=1;
			end
			1:begin
				if(A>=100)begin//���A���ڵ���100����A-100��ͬʱtemp+1.
					A<=A-100;
					temp<=temp+1;
					state<=1;
				end
				else begin
					y1<=temp;//��temp��ֵ��dout_100��ͬʱ�������㡣������һ��״̬��
					temp<=0;
					state<=2;
				end
			end
			2:begin
				if(A>=10)begin//���A���ڵ���10����A-10��ͬʱtemp+1.
					A<=A-10;
					temp<=temp+1;
					state<=2;
				end
				else begin//��temp��ֵ��dout_10,��������ֵdout_1
					y2<=temp;
					y3<=A[3:0];
					state<=0;
				end
			end
			default:state<=0;
		endcase		
	end

endmodule

