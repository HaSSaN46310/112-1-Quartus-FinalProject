module main(
output reg[7:0]R,G,B,bosslife,selflife,
output reg[6:0]segment,
output reg[3:0]COM,
output reg[3:0]segCOM, 
input clock,attack,start,left,right,up,down
);
divfreq4 F0(clock,clk_div);
divfreqin F1(clock,clk_div2);
divfreq F2(clock,clk_div3);
divfreqinv F3(clock,clk_divinv);
reg [5:0]count,round;
reg [7:0]x;
reg [3:0]y;
reg [6:0]segment_LOSE[3:0];
reg [6:0]segment_PASS[3:0];
reg [1:0] mux;

initial begin
R=8'b11111111;
B=8'b11111111;
G=8'b11111111;
count<=6'b0;
round<=6'b0;
COM<=4'b1000;
bosslife<=8'b11111111;
selflife<=8'b11111111;
x<=8'b11011111;
y<=4'b1011;
segment_LOSE[0] = 7'b1000111; // L
segment_LOSE[1] = 7'b1000000; // O
segment_LOSE[2] = 7'b0010010; // S
segment_LOSE[3] = 7'b0000110; // E
segment_PASS[0] = 7'b0001100; // P
segment_PASS[1] = 7'b0001000; // A
segment_PASS[2] = 7'b0010010; // S
segment_PASS[3] = 7'b0010010; // S
end
parameter
SA=8'b01111111,SB=8'b10111111,
S2=8'b11011111,S3=8'b11101111,
S4=8'b11110111,S5=8'b11111011,
S6=8'b11111101,S7=8'b11111110,
CD=4'b0000,C0=4'b1000,C1=4'b1001,
C2=4'b1010,C3=4'b1011,C4=4'b1100,
C5=4'b1101,C6=4'b1110,C7=4'b1111,
S1=8'b00000000,S0=8'b11111111;
always@(posedge clk_div3)begin
if(left)
case(y)
C0:y<=C0;
C1:y<=C0;
C2:y<=C1;
C3:y<=C2;
C4:y<=C3;
C5:y<=C4;
C6:y<=C5;
C7:y<=C6;
endcase
if(right)
case (y)
C0:y<=C1;
C1:y<=C2;
C2:y<=C3;
C3:y<=C4;
C4:y<=C5;
C5:y<=C6;
C6:y<=C7;
C7:y<=C7;
endcase
if(up)
case (x)
SA:x<=SB;
SB:x<=S2;
S2:x<=S3;
S3:x<=S4;
S4:x<=S5;
S5:x<=S6;
S6:x<=S7;
S7:x<=S7;
endcase
if(down)
case (x)
S2:x<=SB;
S3:x<=S2;
S4:x<=S3;
S5:x<=S4;
S6:x<=S5;
S7:x<=S6;
SB:x<=SA;
SA:x<=SA;
endcase
end

always@(posedge clk_divinv)begin
if(bosslife==S1||selflife==S1)$finish;
else if(round%2==1) begin
if(((x[7]==0)&&(COM==y)&&(B[7]==0||G[7]==0))||
((x[6]==0)&&(COM==y)&&(B[6]==0||G[6]==0))||
((x[5]==0)&&(COM==y)&&(B[5]==0||G[5]==0))||
(((x[4]==0)&&(COM==y))&&(B[4]==0||G[4]==0))||
((x[3]==0)&&(COM==y)&&(B[3]==0||G[3]==0))||
((x[2]==0)&&(COM==y)&&(B[2]==0||G[2]==0))||
((x[1]==0)&&(COM==y)&&(B[1]==0||G[1]==0))||
((x[0]==0)&&(COM==y)&&(B[0]==0||G[0]==0)))selflife<=(selflife>>1);
end
end

always@(posedge clk_div)
begin count<=count+1'b1;
if(count==0&&round==16)begin round<=6'b000000;count<=6'b0;end
if(count==10&&(round%2)==0)begin round<=round+1'b1;count<=6'b0;end
else if(count==40&&(round%2)==1)begin round<=round+1'b1;count<=6'b0;end
else if(bosslife==S1||selflife==S1)$finish;
end
always@(posedge clk_div2)begin
if(bosslife==S1||selflife==S1)begin R<=S0;B<=S0;G<=S0;$finish;end
else case(round)
0:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
1:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
case(count)
6'b000000:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000001:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000010:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000011:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000100:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000101:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1010)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1001)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1011)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'b11111111;B<=8'b01111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'b11111111;B<=8'b00000000;COM<=4'b1000;end

6'b000110:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b000111:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001000:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001001:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001010:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001011:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001100:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001101:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001110:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b001111:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010000:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010001:
if(COM==4'b1000)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010010:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010011:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010100:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010101:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010110:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b010111:
if(COM==4'b1000)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11100111;B<=8'B11100111;B<=8'b11100111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011000:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011001:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011010:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011011:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011100:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011101:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;B<=8'b11111111;G<=8'b11000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;B<=8'b11111111;G<=8'B11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011110:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b011111:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b100000:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b100001:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b100010:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b100011:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;B<=8'b10000001;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'b11111111;B<=8'B11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'b11111111;B<=8'b11111111;COM<=4'b1000;end

6'b100100:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1000;end

6'b100101:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1000;end

6'b100110:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1000;end

6'b100111:
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111110;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'B11111111;B<=8'b00000000;COM<=4'b1000;end

6'b101000:begin
if(COM==4'b1000)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1111;end
else if(COM==4'b1111)begin G<=8'B11111111;B<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
 end
endcase
end
2:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
3:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y+1'b1)||((COM==4'b1000)&&(y==4'b1111)))begin R<=x;end
case(count)
6'b000000:
if(COM==4'b1000)		begin B<=8'b10000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000001:
if(COM==4'b1000)		begin B<=8'b11000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b10000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000010:
if(COM==4'b1000)		begin B<=8'b01000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b10000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000011:
if(COM==4'b1000)		begin B<=8'b01100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000100:
if(COM==4'b1000)		begin B<=8'b00100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000101:
if(COM==4'b1000)		begin B<=8'b00110000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000110:
if(COM==4'b1000)		begin B<=8'b00010000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1000;end

6'b000111:
if(COM==4'b1000)		begin B<=8'b00011000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00010000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10000000;COM<=4'b1000;end

6'b001000:
if(COM==4'b1000)		begin B<=8'b00001000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00011000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1000;end

6'b001001:
if(COM==4'b1000)		begin B<=8'b00001100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00011000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1000;end

6'b001010:
if(COM==4'b1000)		begin B<=8'b00000100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1000;end

6'b001011:
if(COM==4'b1000)		begin B<=8'b00000110;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1000;end

6'b001100:
if(COM==4'b1000)		begin B<=8'b00000010;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000110;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00011000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00010000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00110000;COM<=4'b1000;end

6'b001101:
if(COM==4'b1000)		begin B<=8'b00000011;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000010;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00011000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010000;COM<=4'b1000;end

6'b001110:
if(COM==4'b1000)		begin B<=8'b00000001;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000011;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00011000;COM<=4'b1000;end

6'b001111:
if(COM==4'b1000)		begin B<=8'b00000011;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000001;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001000;COM<=4'b1000;end

6'b010000:
if(COM==4'b1000)		begin B<=8'b00000010;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000011;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000001;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001100;COM<=4'b1000;end

6'b010001:
if(COM==4'b1000)		begin B<=8'b00000110;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000010;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000001;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000100;COM<=4'b1000;end

6'b010010:
if(COM==4'b1000)		begin B<=8'b00000100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000110;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000001;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000110;COM<=4'b1000;end

6'b010011:
if(COM==4'b1000)		begin B<=8'b00001100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000001;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000010;COM<=4'b1000;end

6'b010100:
if(COM==4'b1000)		begin B<=8'b00001000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000001;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000011;COM<=4'b1000;end

6'b010101:
if(COM==4'b1000)		begin B<=8'b00011000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000001;COM<=4'b1000;end

6'b010110:
if(COM==4'b1000)		begin B<=8'b00010000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00011000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000011;COM<=4'b1000;end

6'b010111:
if(COM==4'b1000)		begin B<=8'b00110000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00010000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00011000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000010;COM<=4'b1000;end

6'b011000:
if(COM==4'b1000)		begin B<=8'b00100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000110;COM<=4'b1000;end

6'b011001:
if(COM==4'b1000)		begin B<=8'b01100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000100;COM<=4'b1000;end

6'b011010:
if(COM==4'b1000)		begin B<=8'b01000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00011000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001100;COM<=4'b1000;end

6'b011011:
if(COM==4'b1000)		begin B<=8'b11000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00011000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001000;COM<=4'b1000;end

6'b011100:
if(COM==4'b1000)		begin B<=8'b10000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00010000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00011000;COM<=4'b1000;end

6'b011101:
if(COM==4'b1000)		begin B<=8'b11000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b10000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010000;COM<=4'b1000;end

6'b011110:
if(COM==4'b1000)		begin B<=8'b01000000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b10000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00110000;COM<=4'b1000;end

6'b011111:
if(COM==4'b1000)		begin B<=8'b01100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1000;end

6'b100000:
if(COM==4'b1000)		begin B<=8'b00100000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1000;end

6'b100001:
if(COM==4'b1000)		begin B<=8'b00110000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1000;end

6'b100010:
if(COM==4'b1000)		begin B<=8'b00010000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1000;end

6'b100011:
if(COM==4'b1000)		begin B<=8'b00011000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00010000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10000000;COM<=4'b1000;end

6'b100100:
if(COM==4'b1000)		begin B<=8'b00001000;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00011000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1000;end

6'b100101:
if(COM==4'b1000)		begin B<=8'b00001100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00011000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1000;end

6'b100110:
if(COM==4'b1000)		begin B<=8'b00000100;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00001100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1000;end

6'b100111:
if(COM==4'b1000)		begin B<=8'b00000110;COM<=4'b1111;end
else if(COM==4'b1111)begin B<=8'b00000100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1000;end

6'b101000:
begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111111;end
endcase
end
4:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
5:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
case(count)
0:
case(COM)
C7:begin B<=8'b11111111;COM<=C0;end
C0:begin B<=8'b11111110;COM<=C1;end
C1:begin B<=8'b11111110;COM<=C2;end
C2:begin B<=8'b11111110;COM<=C3;end
C3:begin B<=8'b11111110;COM<=C4;end
C4:begin B<=8'b11111110;COM<=C5;end
C5:begin B<=8'b11111110;COM<=C6;end
C6:begin B<=8'b11111110;COM<=C7;end
endcase

1:if(COM==4'b1111)     begin B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11111101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111101;COM<=4'b1110;end
else begin B<=8'b11111101;COM<=4'b1111;end

2:if(COM==4'b1111)     begin B<=8'b11111110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11111011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111010;COM<=4'b1110;end
else begin B<=8'b11111010;COM<=4'b1111;end

3:if(COM==4'b1111)     begin B<=8'b11111101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11110111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11110101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11110101;COM<=4'b1110;end
else begin B<=8'b11110101;COM<=4'b1111;end

4:if(COM==4'b1111)     begin B<=8'b11111010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11101010;COM<=4'b1110;end
else begin B<=8'b11101010;COM<=4'b1111;end

5:if(COM==4'b1111)     begin B<=8'b11110101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11010101;COM<=4'b1110;end
else begin B<=8'b11010101;COM<=4'b1111;end

6:
if(COM==4'b1111)     begin B<=8'b11101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

7:
if(COM==4'b1111)     begin B<=8'b11010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

8:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

9:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

10:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

11:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

12:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101011;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

13:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01011101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010111;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

14:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10111010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101110;COM<=4'b1110;end
else 		     begin B<=8'b10101011;COM<=4'b1111;end

15:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01110101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01011101;COM<=4'b1110;end
else 		     begin B<=8'b01010111;COM<=4'b1111;end

16:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10111011;COM<=4'b1110;end
else 		     begin B<=8'b10101110;COM<=4'b1111;end

17:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01110111;COM<=4'b1110;end
else 		     begin B<=8'b01011101;COM<=4'b1111;end

18:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11101110;COM<=4'b1110;end
else 		     begin B<=8'b10111010;COM<=4'b1111;end

19:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11011101;COM<=4'b1110;end
else 		     begin B<=8'b01110101;COM<=4'b1111;end

20:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10111010;COM<=4'b1110;end
else 		     begin B<=8'b11101010;COM<=4'b1111;end

21:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01011101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01110101;COM<=4'b1110;end
else 		     begin B<=8'b11010101;COM<=4'b1111;end

22:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10111010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

23:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01110101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

24:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

25:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

26:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

27:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

28:
if(COM==4'b1111)     begin B<=8'b10101011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

29:
if(COM==4'b1111)     begin B<=8'b01010111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

30:
if(COM==4'b1111)     begin B<=8'b10101110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

31:
if(COM==4'b1111)     begin B<=8'b01011101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

32:
if(COM==4'b1111)     begin B<=8'b10111010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

33:
if(COM==4'b1111)     begin B<=8'b01110101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

34:
if(COM==4'b1111)     begin B<=8'b11101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

35:
if(COM==4'b1111)     begin B<=8'b11010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

36:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

37:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

38:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

39:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

40:
begin B<=8'b11111111;end
endcase
end
6:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
7:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
case(count)
6'b000000:
if(COM==4'b1111)		begin B<=8'b10000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000001:
if(COM==4'b1111)		begin B<=8'b11000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000010:
if(COM==4'b1111)		begin B<=8'b01000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000011:
if(COM==4'b1111)		begin B<=8'b01100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000100:
if(COM==4'b1111)		begin B<=8'b00100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000101:
if(COM==4'b1111)		begin B<=8'b00110000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11111111;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000110:
if(COM==4'b1111)		begin B<=8'b00010000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11111111;COM<=4'b1111;end

6'b000111:
if(COM==4'b1111)		begin B<=8'b00011000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00010000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b10000000;COM<=4'b1111;end

6'b001000:
if(COM==4'b1111)		begin B<=8'b00001000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00011000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1111;end

6'b001001:
if(COM==4'b1111)		begin B<=8'b00001100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00011000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1111;end

6'b001010:
if(COM==4'b1111)		begin B<=8'b00000100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1111;end

6'b001011:
if(COM==4'b1111)		begin B<=8'b00000110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1111;end

6'b001100:
if(COM==4'b1111)		begin B<=8'b00000010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00011000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00010000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00110000;COM<=4'b1111;end

6'b001101:
if(COM==4'b1111)		begin B<=8'b00000011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00011000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00010000;COM<=4'b1111;end

6'b001110:
if(COM==4'b1111)		begin B<=8'b00000001;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00011000;COM<=4'b1111;end

6'b001111:
if(COM==4'b1111)		begin B<=8'b00000011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000001;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001000;COM<=4'b1111;end

6'b010000:
if(COM==4'b1111)		begin B<=8'b00000010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000001;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001100;COM<=4'b1111;end

6'b010001:
if(COM==4'b1111)		begin B<=8'b00000110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000001;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000110;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000100;COM<=4'b1111;end

6'b010010:
if(COM==4'b1111)		begin B<=8'b00000100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000001;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000010;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000110;COM<=4'b1111;end

6'b010011:
if(COM==4'b1111)		begin B<=8'b00001100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000001;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000011;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000010;COM<=4'b1111;end

6'b010100:
if(COM==4'b1111)		begin B<=8'b00001000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00000100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000001;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000011;COM<=4'b1111;end

6'b010101:
if(COM==4'b1111)		begin B<=8'b00011000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000011;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000001;COM<=4'b1111;end

6'b010110:
if(COM==4'b1111)		begin B<=8'b00010000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00011000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001100;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000010;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000011;COM<=4'b1111;end

6'b010111:
if(COM==4'b1111)		begin B<=8'b00110000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00010000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00011000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001100;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00000100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000110;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000010;COM<=4'b1111;end

6'b011000:
if(COM==4'b1111)		begin B<=8'b00100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00001000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00000100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000110;COM<=4'b1111;end

6'b011001:
if(COM==4'b1111)		begin B<=8'b01100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001100;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00000100;COM<=4'b1111;end

6'b011010:
if(COM==4'b1111)		begin B<=8'b01000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00011000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00001000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001100;COM<=4'b1111;end

6'b011011:
if(COM==4'b1111)		begin B<=8'b11000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00011000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00001000;COM<=4'b1111;end

6'b011100:
if(COM==4'b1111)		begin B<=8'b10000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00010000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00011000;COM<=4'b1111;end

6'b011101:
if(COM==4'b1111)		begin B<=8'b11000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00010000;COM<=4'b1111;end

6'b011110:
if(COM==4'b1111)		begin B<=8'b01000000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00110000;COM<=4'b1111;end

6'b011111:
if(COM==4'b1111)		begin B<=8'b01100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01000000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1111;end

6'b100000:
if(COM==4'b1111)		begin B<=8'b00100000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01000000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1111;end

6'b100001:
if(COM==4'b1111)		begin B<=8'b00110000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00100000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1111;end

6'b100010:
if(COM==4'b1111)		begin B<=8'b00010000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00110000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1111;end

6'b100011:
if(COM==4'b1111)		begin B<=8'b00011000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00010000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00110000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00100000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01000000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b10000000;COM<=4'b1111;end

6'b100100:
if(COM==4'b1111)		begin B<=8'b00001000;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00011000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00110000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00100000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01000000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b11000000;COM<=4'b1111;end

6'b100101:
if(COM==4'b1111)		begin B<=8'b00001100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001000;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00011000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00010000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00110000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01000000;COM<=4'b1111;end

6'b100110:
if(COM==4'b1111)		begin B<=8'b00000100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00001100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00011000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00010000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00110000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00100000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b01100000;COM<=4'b1111;end

6'b100111:
if(COM==4'b1111)		begin B<=8'b00000110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00000100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00001100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00001000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00011000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00110000;COM<=4'b1110;end
else if(COM==4'b1110)begin B<=8'b00100000;COM<=4'b1111;end

6'b101000:
begin B<=8'b11111111;B<=8'b11111111;G<=8'b11111111;end
endcase
end
8:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
9:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
case(count)
6'b000000:if(COM==4'b1111)     begin B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01111111;COM<=4'b1110;end
else begin B<=8'b01111111;COM<=4'b1111;end

6'b000001:if(COM==4'b1111)     begin B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10111111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10111111;COM<=4'b1110;end
else begin B<=8'b10111111;COM<=4'b1111;end

6'b000010:
if(COM==4'b1111)     begin B<=8'b01111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11011111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01011111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01011111;COM<=4'b1110;end
else begin B<=8'b01011111;COM<=4'b1111;end

6'b000011:
if(COM==4'b1111)     begin B<=8'b10111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101111;COM<=4'b1110;end
else begin B<=8'b10101111;COM<=4'b1111;end

6'b000100:
if(COM==4'b1111)     begin B<=8'b01011111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010111;COM<=4'b1110;end
else begin B<=8'b01010111;COM<=4'b1111;end

6'b000101:
if(COM==4'b1111)     begin B<=8'b10101111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101011;COM<=4'b1110;end
else begin B<=8'b10101011;COM<=4'b1111;end

6'b000110:
if(COM==4'b1111)     begin B<=8'b01010111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

6'b000111:
if(COM==4'b1111)     begin B<=8'b10101011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

6'b001000:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

6'b001001:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

6'b001010:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else begin B<=8'b01010101;COM<=4'b1111;end

6'b001011:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else begin B<=8'b10101010;COM<=4'b1111;end

6'b001100:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01110101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b001101:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10111010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b001110:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01011101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01110101;COM<=4'b1110;end
else 		     begin B<=8'b11010101;COM<=4'b1111;end

6'b001111:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10111010;COM<=4'b1110;end
else 		     begin B<=8'b11101010;COM<=4'b1111;end

6'b010000:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11011101;COM<=4'b1110;end
else 		     begin B<=8'b01110101;COM<=4'b1111;end

6'b010001:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11101110;COM<=4'b1110;end
else 		     begin B<=8'b10111010;COM<=4'b1111;end

6'b010010:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01110111;COM<=4'b1110;end
else 		     begin B<=8'b01011101;COM<=4'b1111;end

6'b010011:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10111011;COM<=4'b1110;end
else 		     begin B<=8'b10101110;COM<=4'b1111;end

6'b010100:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01110101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01011101;COM<=4'b1110;end
else 		     begin B<=8'b01010111;COM<=4'b1111;end

6'b010101:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10111010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101110;COM<=4'b1110;end
else 		     begin B<=8'b10101011;COM<=4'b1111;end

6'b010110:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01011101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010111;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b010111:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101110;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101011;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b011000:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01011101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b011001:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b011010:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b011011:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b011100:
if(COM==4'b1111)     begin B<=8'b11010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b011101:
if(COM==4'b1111)     begin B<=8'b11101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b011110:
if(COM==4'b1111)     begin B<=8'b01110101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b011111:
if(COM==4'b1111)     begin B<=8'b10111011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b100000:
if(COM==4'b1111)     begin B<=8'b01011101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b100001:
if(COM==4'b1111)     begin B<=8'b10101110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10111011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b100010:
if(COM==4'b1111)     begin B<=8'b01010111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01011101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01110101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11010101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b100011:
if(COM==4'b1111)     begin B<=8'b10101011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101110;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10111010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11101010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b100100:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01011101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01110101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b100101:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10111010;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b100110:
if(COM==4'b1111)     begin B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b01010111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b01011101;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b01110101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11010101;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b01010101;COM<=4'b1110;end
else 		     begin B<=8'b01010101;COM<=4'b1111;end

6'b100111:
if(COM==4'b1111)     begin B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10101011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10101110;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b10111010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11101010;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10101010;COM<=4'b1110;end
else 		     begin B<=8'b10101010;COM<=4'b1111;end

6'b101000:B<=8'b11111111;
endcase
end
10:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
11:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
if(count==40)B<=8'b11111111;
else case(count%7)
0:
if(COM==4'b1111)     begin B<=8'b11100111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11100111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11100111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11100111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11100111;COM<=4'b1110;end
else 						begin B<=8'b11100111;COM<=4'b1111;end

1:
if(COM==4'b1111)     begin B<=8'b11001111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11001111;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11100100;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000000;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b00000011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00100111;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11110011;COM<=4'b1110;end
else 						begin B<=8'b11110011;COM<=4'b1111;end

2:
if(COM==4'b1111)     begin B<=8'b10011111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10011100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11001000;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11100011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b00010011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00111001;COM<=4'b1110;end
else 						begin B<=8'b11111001;COM<=4'b1111;end

3:
if(COM==4'b1111)     begin B<=8'b00111110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b10011100;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b11001001;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11100011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b10010011;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b00111001;COM<=4'b1110;end
else 						begin B<=8'b01111100;COM<=4'b1111;end

4:
if(COM==4'b1111)     begin B<=8'b01111100;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b00111001;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b10010011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b11000111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11100011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11001001;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b10011100;COM<=4'b1110;end
else 						begin B<=8'b00111110;COM<=4'b1111;end

5:
if(COM==4'b1111)     begin B<=8'b11111001;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b01110011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00010011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b10000111;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11100001;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11001000;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11001110;COM<=4'b1110;end
else 						begin B<=8'b10011111;COM<=4'b1111;end

6:
if(COM==4'b1111)     begin B<=8'b11110011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'b11110011;COM<=4'b1001;end
else if(COM==4'b1001)begin B<=8'b00100111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'b00000011;COM<=4'b1011;end
else if(COM==4'b1011)begin B<=8'b11000000;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'b11100100;COM<=4'b1101;end
else if(COM==4'b1101)begin B<=8'b11001111;COM<=4'b1110;end
else 						begin B<=8'b11001111;COM<=4'b1111;end
endcase

end
12:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
13:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
if(count==40)begin B<=8'b11111111;G<=8'b11111111;end
else if(count<6) 
case(count)
0:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b01111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b01111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b01111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b01111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111110;COM<=4'b1111;end

1:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b10111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111101;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b10111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b10111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b10111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111101;COM<=4'b1111;end

2:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11011111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111011;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11011111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111011;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11011111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111011;COM<=4'b1111;end

3:
if(COM==4'b1111)     begin G<=8'B11111110;B<=8'b11101111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B01111111;G<=8'b11110111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111110;B<=8'b11101111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B01111111;G<=8'b11110111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111110;B<=8'b11101111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B01111111;G<=8'b11110111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111110;B<=8'b11101111;COM<=4'b1110;end
else 						begin B<=8'B01111111;G<=8'b11110111;COM<=4'b1111;end

4:
if(COM==4'b1111)     begin G<=8'B11111101;B<=8'b11110111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B10111111;G<=8'b11101111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111101;B<=8'b11110111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B10111111;G<=8'b11101111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111101;B<=8'b11110111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B10111111;G<=8'b11101111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111101;B<=8'b11110111;COM<=4'b1110;end
else 						begin B<=8'B10111111;G<=8'b11101111;COM<=4'b1111;end

5:
if(COM==4'b1111)     begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1110;end
else 						begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1111;end
endcase
else
case(count%6)
0:
if(COM==4'b1111)     begin G<=8'B11110111;B<=8'b01111101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11101111;G<=8'b10111110;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11110111;B<=8'b01111101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11101111;G<=8'b10111110;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11110111;B<=8'b01111101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11101111;G<=8'b10111110;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11110111;B<=8'b01111101;COM<=4'b1110;end
else 						begin B<=8'B11101111;G<=8'b10111110;COM<=4'b1111;end

1:
if(COM==4'b1111)     begin G<=8'B11101111;B<=8'b10111110;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11110111;G<=8'b01111101;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11101111;B<=8'b10111110;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11110111;G<=8'b01111101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11101111;B<=8'b10111110;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11110111;G<=8'b01111101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11101111;B<=8'b10111110;COM<=4'b1110;end
else 						begin B<=8'B11110111;G<=8'b01111101;COM<=4'b1111;end

2:
if(COM==4'b1111)     begin G<=8'B11011111;B<=8'b11011111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111011;G<=8'b11111011;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11011111;B<=8'b11011111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111011;G<=8'b11111011;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11011111;B<=8'b11011111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111011;G<=8'b11111011;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11011111;B<=8'b11011111;COM<=4'b1110;end
else 						begin B<=8'B11111011;G<=8'b11111011;COM<=4'b1111;end

3:
if(COM==4'b1111)     begin G<=8'B10111110;B<=8'b11101111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B01111101;G<=8'b11110111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B10111110;B<=8'b11101111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B01111101;G<=8'b11110111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B10111110;B<=8'b11101111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B01111101;G<=8'b11110111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B10111110;B<=8'b11101111;COM<=4'b1110;end
else 						begin B<=8'B01111101;G<=8'b11110111;COM<=4'b1111;end

4:
if(COM==4'b1111)     begin G<=8'B01111101;B<=8'b11110111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B10111110;G<=8'b11101111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B01111101;B<=8'b11110111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B10111110;G<=8'b11101111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B01111101;B<=8'b11110111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B10111110;G<=8'b11101111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B01111101;B<=8'b11110111;COM<=4'b1110;end
else 						begin B<=8'B10111110;G<=8'b11101111;COM<=4'b1111;end

5:
if(COM==4'b1111)     begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111011;B<=8'b11111011;COM<=4'b1110;end
else 						begin B<=8'B11011111;G<=8'b11011111;COM<=4'b1111;end
endcase
end
14:
if(attack && (COM!=CD))begin
if(COM==C3||COM==C4)bosslife<=(bosslife>>1);
COM<=CD;
end
else begin
if(COM!=4'b0000)
case(count)
0: begin R<=S1;B<=S1;G<=S1;COM<=C0;end
1: begin R<=S0;B<=S0;G<=S1;COM<=C1;end
2: begin R<=S0;B<=S1;G<=S0;COM<=C2;end
3: begin R<=S1;B<=S0;G<=S0;COM<=C3;end
4: begin R<=S1;B<=S0;G<=S0;COM<=C4;end
5: begin R<=S0;B<=S1;G<=S0;COM<=C5;end
6: begin R<=S0;B<=S0;G<=S1;COM<=C6;end
7: begin R<=S1;B<=S1;G<=S1;COM<=C7;end
8: begin R<=S1;B<=S1;G<=S1;COM<=CD;end
endcase
end
15:begin R<=S0;B<=S0;G<=S0;COM<=C0;if(COM==(y-1'b1)||((COM==4'b1111)&&(y==4'b1000)))begin R<=x;end
if(count==40)begin B<=8'b11111111;G<=8'b11111111;end
else if(count<6)
case(count)
0:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1111;end

1:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b10101010;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end

2:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end

3:
if(COM==4'b1111)     begin G<=8'B10101010;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B01010101;G<=8'b11111111;COM<=4'b1111;end

4:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B10101010;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B01010101;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end

5:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B10101010;B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B01010101;G<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end
endcase
else
case(count%6)
0:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B10101010;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B01010101;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1111;end

1:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b10101010;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b01010101;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B01010101;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B10101010;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b10101010;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b01010101;COM<=4'b1111;end

2:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B01010101;B<=8'b01010101;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B10101010;G<=8'b10101010;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end

3:
if(COM==4'b1111)     begin G<=8'B10101010;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B01010101;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b01010101;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b10101010;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B10101010;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B01010101;G<=8'b11111111;COM<=4'b1111;end

4:
if(COM==4'b1111)     begin G<=8'B01010101;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B10101010;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b10101010;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b01010101;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B01010101;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B10101010;G<=8'b11111111;COM<=4'b1111;end

5:
if(COM==4'b1111)     begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1000;end
else if(COM==4'b1000)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1001;end
else if(COM==4'b1001)begin G<=8'B10101010;B<=8'b10101010;COM<=4'b1010;end
else if(COM==4'b1010)begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1011;end
else if(COM==4'b1011)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1100;end
else if(COM==4'b1100)begin B<=8'B01010101;G<=8'b01010101;COM<=4'b1101;end
else if(COM==4'b1101)begin G<=8'B11111111;B<=8'b11111111;COM<=4'b1110;end
else 						begin B<=8'B11111111;G<=8'b11111111;COM<=4'b1111;end
endcase
end
endcase
end

always@(posedge clk_div2) begin
mux <= mux + 1;

if (selflife == 8'd0) begin
segment <= segment_LOSE[mux];
end 
else if(bosslife == 8'd0) begin
segment <= segment_PASS[mux];
end 

case (mux)
	2'd0: segCOM <= 4'b1110;
   2'd1: segCOM <= 4'b1101;
   2'd2: segCOM <= 4'b1011;
   2'd3: segCOM <= 4'b0111;
endcase
end
endmodule

module divfreq4(input CLK,output reg clk_div);
reg[24:0]count=25'b0;
always@(posedge CLK)
begin
if(count > 12500000)
begin
count<=25'b0;
clk_div=~clk_div;
end
else
count<=count+1'b1;
end
endmodule

module divfreqin(input CLK,output reg clk_div);
reg[24:0]count=25'b0;
always@(posedge CLK)
begin
if(count > 25000)
begin
count<=25'b0;
clk_div=~clk_div;
end
else
count<=count+1'b1;
end
endmodule

module divfreq(input clk,output reg clk_div);
reg[24:0]count=25'b0;
always@(posedge clk)
begin
if(count>3125000)
begin
count<=25'b0;
clk_div=~clk_div;
end 
else
count<=count+1'b1;
end 
endmodule

module divfreqinv(input clk,output reg clk_div);
reg[25:0]count=26'b0;
always@(posedge clk)
begin
if(count>3125000)
begin
count<=25'b0;
clk_div=~clk_div;
end 
else
count<=count+1'b1;
end 
endmodule