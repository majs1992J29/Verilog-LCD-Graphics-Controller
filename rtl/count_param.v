/*
Nombre del archivo: count_param.v
Descripción: es un semisumador de 2 entradas, una salida y un acarreo
la siguiente funcionalidad de sus entradas y salidas:
1. S,C son salidas (outputs) S=suma, C=acarreo
2. x,y son las entradas(inputs) 
*/


module count_param(iCLK,iRST_n,iENABLE,iUP_DOWN, oCOUNT, oTC);

	parameter fin_cuenta = 20;
	parameter n	= $clog2(fin_cuenta);
	
	input iCLK, iRST_n, iENABLE, iUP_DOWN;
	output reg [n-1:0] oCOUNT;
	output oTC;
	
	always @(posedge iCLK)
	
		if(!iRST_n)
			if (iUP_DOWN == 1'b1)
			oCOUNT <= {n{1'b0}};
			else
			oCOUNT <= fin_cuenta-1;
		else
		
			if(iENABLE == 1'b1)
			
				if(iUP_DOWN == 1'b1)
					if(oCOUNT == fin_cuenta-1)
						oCOUNT <= {n{1'b0}};
					else
						oCOUNT <= oCOUNT + 1'b1;
				else 
					if(oCOUNT == 1'b0)
						oCOUNT <= fin_cuenta-1;
					else
						oCOUNT <= oCOUNT - 1'b1;					
			
	assign oTC = ((iRST_n == 0) || (iENABLE == 0))? 1'b0: ((oCOUNT == fin_cuenta-1) && (iUP_DOWN == 1'b1))?1'b1: ((oCOUNT == 1'b0) && (iUP_DOWN == 1'b0))? 1'b1:1'b0;		
endmodule
