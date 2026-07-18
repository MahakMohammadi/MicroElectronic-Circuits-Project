
*************CMOS Inverter HSPICE netlist************ 
.include 'C:\Users\MK\Documents\MC_Project\comparator_A\mosistsmc180.lib'
*netlist--------------------------------------- 
.param SUPPLY=1.8

*VDD Vdd 0 1.8
VDD 	 Vdd 0 'SUPPLY'
VA     A gnd PULSE ('SUPPLY' 0 0ps 100ps 100ps 10ns 20ns) 
VB     B gnd PULSE ('SUPPLY' 0 0ps 100ps 100ps 20ns 40ns) 

.subckt CMOS_INV in out	vdd
MP1 out 	in 	vdd 	vdd 	PMOS L=0.18u W=0.72u AS='0.72u*0.36u' PS='2*0.72u+2*0.36u' AD='0.72u*0.36u' PD='2*0.72u+2*0.36u'
MN1 out 	in 	0 		0 		NMOS L=0.18u W=0.36u AS='0.36u*0.36u' PS='2*0.36u+2*0.36u' AD='0.36u*0.36u' PD='2*0.36u+2*0.36u'
.ends

.subckt CMOS_AND NOT_in1 NOT_in2 out	vdd
MP1 vdd		 NOT_in1 	Node1 	vdd 	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MP2 Node1 	 NOT_in2 	out 		vdd 	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MN1 out 		 NOT_in1 	0 			0 		NMOS L=0.18u W=0.36u AS='0.36u*0.36u' PS='2*0.36u+2*0.36u' AD='0.36u*0.36u' PD='2*0.36u+2*0.36u'
MN2 out 		 NOT_in2 	0 			0 		NMOS L=0.18u W=0.36u AS='0.36u*0.36u' PS='2*0.36u+2*0.36u' AD='0.36u*0.36u' PD='2*0.36u+2*0.36u'
.ends

.subckt CMOS_XNOR in1 in2 NOT_in1 NOT_in2 out vdd
MP1 vdd 		in1 	 		Node1 	vdd	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MP2 vdd 		NOT_in2 		Node1 	vdd	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MP3 Node1 	NOT_in1 		out 		vdd	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MP4 Node1 	in2 			out 		vdd	PMOS L=0.18u W=1.44u AS='1.44u*0.36u' PS='2*1.44u+2*0.36u' AD='1.44u*0.36u' PD='2*1.44u+2*0.36u'
MN1 out 		NOT_in2 		Node2 	0		NMOS L=0.18u W=0.72u AS='0.72u*0.36u' PS='2*0.72u+2*0.36u' AD='0.72u*0.36u' PD='2*0.72u+2*0.36u'
MN2 Node2 	in1 			0 			0		NMOS L=0.18u W=0.72u AS='0.72u*0.36u' PS='2*0.72u+2*0.36u' AD='0.72u*0.36u' PD='2*0.72u+2*0.36u'
MN3 out 		in2 			Node3 	0		NMOS L=0.18u W=0.72u AS='0.72u*0.36u' PS='2*0.72u+2*0.36u' AD='0.72u*0.36u' PD='2*0.72u+2*0.36u'
MN4 Node3 	NOT_in1 		0 			0		NMOS L=0.18u W=0.72u AS='0.72u*0.36u' PS='2*0.72u+2*0.36u' AD='0.72u*0.36u' PD='2*0.72u+2*0.36u'
.ends



X1 	A 		NOT_A 	vdd 	CMOS_INV
X2 	B 		NOT_B 	vdd 	CMOS_INV

X3 	A 		B 			NOT_A 	NOT_B 		Equal 			vdd 	CMOS_XNOR
X4 	A 					NOT_B 					LessThan 		vdd 	CMOS_AND
X5 	NOT_A 			B 							GreaterThan 	vdd 	CMOS_AND



CL1  	LessThan 		gnd 	10fF 		*A<B
CL2 	Equal 			gnd 	10fF		*A=B
CL3 	GreaterThan 	gnd 	10fF		*A>B



*extra control information--------------------- 
.options post=2 nomod 
.op 
*analysis-------------------------------------- 
.tran 10ps 120ns  * transient analysis: Step end_time 
.probe tran v(LessThan) v(Equal) v(GreaterThan) v(A) v(B)

.END