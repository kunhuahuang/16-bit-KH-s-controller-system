`timescale 1ns / 1ps

module BIN_BCD(A,FORTH,THIRD,SECOND,FIRST,CY
    );
input [15:0] A;
output [3:0] FORTH,THIRD,SECOND,FIRST;
output CY;
wire [3:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10;
wire [3:0] c11,c12,c13,c14,c15,c16,c17,c18;
wire [3:0] c19,c20,c21,c22,c23,c24,c25,c26;
wire [3:0] c27,c28,c29,c30,c31,c32,c33,c34;
wire [3:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10;
wire [3:0] d11,d12,d13,d14,d15,d16,d17,d18;
wire [3:0] d19,d20,d21,d22,d23,d24,d25,d26;
wire [3:0] d27,d28,d29,d30,d31,d32,d33,d34; 

assign
d1 = {1'b0,A[15:13]},
d2 = {c1[2:0],A[12]},
d3 = {c2[2:0],A[11]},
d4 = {c3[2:0],A[10]},
d5 = {c4[2:0],A[9]},
d6 = {c5[2:0],A[8]},
d7 = {c6[2:0],A[7]},
d8 = {c7[2:0],A[6]},
d9 = {c8[2:0],A[5]},
d10 = {c9[2:0],A[4]},
d11 = {c10[2:0],A[3]},
d12 = {c11[2:0],A[2]},
d13 = {c12[2:0],A[1]},
d14 = {1'b0,c1[3],c2[3],c3[3]},
d15 = {c14[2],c14[1],c14[0],c4[3]},
d16 = {c15[2],c15[1],c15[0],c5[3]},
d17 = {c16[2],c16[1],c16[0],c6[3]},
d18 = {c17[2],c17[1],c17[0],c7[3]},
d19 = {c18[2],c18[1],c18[0],c8[3]},
d20 = {c19[2],c19[1],c19[0],c9[3]},
d21 = {c20[2],c20[1],c20[0],c10[3]},
d22 = {c21[2],c21[1],c21[0],c11[3]},
d23 = {c22[2],c22[1],c22[0],c12[3]},
d24 = {1'b0,c14[3],c15[3],c16[3]},
d25 = {c24[2],c24[1],c24[0],c17[3]},
d26 = {c25[2],c25[1],c25[0],c18[3]},
d27 = {c26[2],c26[1],c26[0],c19[3]},
d28 = {c27[2],c27[1],c27[0],c20[3]},
d29 = {c28[2],c28[1],c28[0],c21[3]},
d30 = {c29[2],c29[1],c29[0],c22[3]},
d31 = {1'b0,c24[3],c25[3],c26[3]},
d32 = {c31[2],c31[1],c31[0],c27[3]},
d33 = {c32[2],c32[1],c32[0],c28[3]},
d34 = {c33[2],c33[1],c33[0],c29[3]};


assign
FIRST = {c13[2:0],A[0]},
SECOND = {c23[2:0],c13[3]},
THIRD = {c30[2:0],c23[3]},
FORTH = {c34[2:0],c30[3]},
CY = c34[3];


ADD3 m1(d1,c1);
ADD3 m2(d2,c2);
ADD3 m3(d3,c3);
ADD3 m4(d4,c4);
ADD3 m5(d5,c5);
ADD3 m6(d6,c6);
ADD3 m7(d7,c7);
ADD3 m8(d8,c8);
ADD3 m9(d9,c9);
ADD3 m10(d10,c10);
ADD3 m11(d11,c11);
ADD3 m12(d12,c12);
ADD3 m13(d13,c13);
ADD3 m14(d14,c14);
ADD3 m15(d15,c15);
ADD3 m16(d16,c16);
ADD3 m17(d17,c17);
ADD3 m18(d18,c18);
ADD3 m19(d19,c19);
ADD3 m20(d20,c20);
ADD3 m21(d21,c21);
ADD3 m22(d22,c22);
ADD3 m23(d23,c23);
ADD3 m24(d24,c24);
ADD3 m25(d25,c25);
ADD3 m26(d26,c26);
ADD3 m27(d27,c27);
ADD3 m28(d28,c28);
ADD3 m29(d29,c29);
ADD3 m30(d30,c30);
ADD3 m31(d31,c31);
ADD3 m32(d32,c32);
ADD3 m33(d33,c33);
ADD3 m34(d34,c34);


endmodule
