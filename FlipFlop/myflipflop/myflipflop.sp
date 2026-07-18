
*************D FLIP FLOP HSPICE netlist************ 
.include 'C:\Users\MK\Documents\MC_Project\FlipFlop\mosistsmc180.lib'
*netlist---------------------------------------


VDD        vdd       0       1.8

*VCLK      clk      gnd     pulse(0ns  0v  5ns  1v  10ns  0v  15ns  1v)
*vNOTD     NOTD     gnd     pulse(0ns  1v  4ns  0v  14ns  1v)


VCLK      clk       gnd     Pulse(1.8  0 		0ps 100ps 100ps 5ns 10ns)
VNCLK     Nclk      gnd     Pulse(0    1.8   0ps 100ps 100ps 5ns 10ns)
vNOTD     NOTD      gnd     Pwl(0ns 1.8 4ns 1.8 4.1ns 0 14ns 0 14.1ns 1.8 )

.option scale=90n
.param N=6
.param P=18

.subckt CMOS_INV in out	vdd	N=3 P=9
MP1 out 	in 	vdd 	vdd 					PMOS W='P' L=2 AS='P*5' PS='2*P+10' AD='P*5' PD='2*P+10'
MN1 out 	in 	0 		0 						NMOS W='N' L=2 AS='N*5' PS='2*N+10' AD='N*5' PD='2*N+10'
.ends

.subckt TRI_STATE_INV in En NOT_En out	vdd
MP1 vdd		 in 			Node1 	vdd 	PMOS W='P' L=2 AS='P*5' PS='2*P+10' AD='P*5' PD='2*P+10'
MP2 Node1 	 NOT_En	 	out 		vdd 	PMOS W='P' L=2 AS='P*5' PS='2*P+10' AD='P*5' PD='2*P+10'
MN1 out 		 En		 	Node2 	0 		NMOS W='N' L=2 AS='N*5' PS='2*N+10' AD='N*5' PD='2*N+10'
MN2 Node2 	 in 			0 			0 		NMOS W='N' L=2 AS='N*5' PS='2*N+10' AD='N*5' PD='2*N+10'
.ends

X1 	NOTD 		D 		vdd 	CMOS_INV			N=6 P=18

X2 	D 			Nclk	clk	NOTD2 	vdd 	TRI_STATE_INV


X3 	NOTD2 	D2 	vdd 	CMOS_INV			N=6 P=18

X4 	D2 		clk	Nclk	NOTD3 	vdd 	TRI_STATE_INV

X5 	NOTD3 	Q	 	vdd 	CMOS_INV			N=6 P=18

*making the loops

X6 	D2 		NOTD2	 	vdd 	CMOS_INV		N=3 P=9

X7 	Q 			NOTD3	 	vdd 	CMOS_INV		N=3 P=9



CL  	Q 		gnd 	10fF

*extra control information--------------------- 
.options post=2 nomod 
.op 
*analysis-------------------------------------- 
.tran 10ps 20ns  * transient analysis: Step end_time 
.probe tran v(Q) v(NOTD) v(clk) v(Nclk)


.measure TRAN tpLH TRIG v(clk) VAL=0.9 RISE=1 TARG v(Q) VAL=0.9 RISE=1
.measure TRAN tpHL TRIG v(clk) VAL=0.9 RISE=2 TARG v(Q) VAL=0.9 FALL=2
.measure TRAN tp_avg param='(tpLH + tpHL)/2'



.END
