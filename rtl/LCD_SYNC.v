/*

Nombre del archivo: LCD_SYNC.v
Descripción: Este módulo sincroniza y genera señales de control para 
un sistema de visualización LCD, para ello, utiliza un módulo PLL para 
generar una señal de reloj de salida (oNCLK) a partir de la entrada del 
reloj principal (iCLK), dos contadores parametrizables se utilizan para 
generar las señales de fila (oFILA) y columna (oCOLUMNA) necesarias para 
dirigir las posiciones en la pantalla LCD. 
La señal oHD indica el estado de desplazamiento horizontal, oVD indica el 
estado de desplazamiento vertical, y oGREST refleja el estado de reinicio. 
La señal oDEN se activa dentro de una región específica de la pantalla LCD. 
El diseño se complementa con la inversión de las señales oHD y oVD según 
sea necesario.

*/

module LCD_SYNC(iCLK, iRST_n, oNCLK, oGREST, oHD, oDEN, oVD, oFILA, oCOLUMNA);
	input iCLK, iRST_n;
	output oNCLK, oGREST,oHD, oDEN, oVD;
	output wire  [10:0] oCOLUMNA;
	output wire  [9 :0] oFILA;
	
	
	wire TC_Enable;
	wire TC_Fila;
	
	// Instanciación del DUT (Device Under Test)
	PLL	PLL_lcd_sync 
	(
		.inclk0 ( iCLK ),
		.c0 ( oNCLK )
	);

	
	// Instanciación del DUT (Device Under Test)
	count_param #(.fin_cuenta(1056)) HCOUNT 
	(    .iCLK(oNCLK),
		  .iRST_n(iRST_n),
		  .iENABLE(1'b1),
		  .iUP_DOWN(1'b1),
		  .oCOUNT(oCOLUMNA),
		  .oTC(TC_Enable)
	);
	
	// Instanciación del DUT (Device Under Test)
	count_param #(.fin_cuenta(525)) VCOUNT 
	(    .iCLK(oNCLK),
		  .iRST_n(iRST_n),
		  .iENABLE(TC_Enable),
		  .iUP_DOWN(1'b1),
		  .oCOUNT(oFILA),
		  .oTC(TC_Fila)
	);
	
	
	
	assign oHD = ~TC_Enable;
	assign oVD = ~TC_Fila;
	assign oGREST = iRST_n;
	
	assign oDEN = ((oCOLUMNA >= 216) && (oCOLUMNA <= 1015 ) && (oFILA >= 35) && (oFILA <= 514))? 1'b1: 1'b0; 
	
	
	
endmodule




