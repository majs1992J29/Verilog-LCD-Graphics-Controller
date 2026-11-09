/*

Nombre del archivo: imagen_lcd.v
Descripción: Este módulo utiliza el módulo "LCD_SYNC" para sincronizar 
las señales y generar posiciones en una pantalla LCD. La instancia 
de "direccionamiento" se encarga de generar la dirección para acceder 
a la memoria ROM, que almacena los datos de la imagen. Los datos de 
la memoria ROM se extraen y se utilizan para formar los componentes 
de color (oRED, oGREEN, oBLUE) que se envían como salida para representar 
la imagen en la pantalla. Las coordenadas (x, y) se almacenan como 
registros internos para posiblemente ser utilizadas en futuras 
expansiones del diseño.

*/

module imagen_lcd (iCLK, iRST_n, oNCLK, oGREST, oHD, oDEN, oVD, oRED, oGREEN, oBLUE);

	input iCLK, iRST_n;
	output oNCLK, oGREST,oHD, oDEN, oVD;
	output  [7:0] oRED;
	output  [7:0] oGREEN;
	output  [7:0] oBLUE;
	
	wire [10:0] oCol;
	wire [ 9:0] oFil;
	
	reg [10:0] x;// Coordenada horizontal
	reg [ 9:0] y;// Coordenada vertical
	
	wire [15:0] oData_rom;
	wire [16:0] address_sig;
		
	// Instancia del módulo LCD_SYNC para la sincronización y generación de posiciones
	LCD_SYNC  LCD_SYNC_T2 	 (   .iCLK(iCLK),
                                .iRST_n(iRST_n),
                                .oNCLK(oNCLK), 
										  .oGREST(oGREST), 
										  .oHD(oHD), 
										  .oDEN(oDEN),
										  .oVD(oVD),
										  .oFILA(oFil), 
										  .oCOLUMNA(oCol));
	
	// Instancia del módulo direccionamiento para generar la dirección de la memoria ROM
	direccionamiento direccionamiento_T2(.iDEN(oDEN),
	.iCol(oCol),
	.iFil(oFil),
	.oaddress_sig(address_sig));
	
	

	// Instancia de la memoria ROM para almacenar los datos de la imagen
	ROM5        ROM_image_inst (
	  .address ( address_sig ),
	  .clock ( oNCLK ),
	  .q ( oData_rom )
	);
	
	// Extracción de los componentes de color de los datos de la memoria ROM
	assign oRED 	= {oData_rom[15:11], oData_rom[15:13]}; // Duplicar bits de R
	assign oGREEN 	= {oData_rom[10: 5], oData_rom[10: 9]}; // Duplicar bits de G
	assign oBLUE 	= {oData_rom[ 4: 0], oData_rom[ 4: 2]}; // Duplicar bits de B
										  
endmodule
