/*

Nombre del archivo: texto_LCD.v
Descripción: Este módulo combina un controlador de pantalla LCD (LCD_SYNC_T4) 
y un generador de texto (texto_T1). La entrada Pixel_on_off controla 
los colores de píxeles de salida (oRED, oGREEN, oBLUE), mostrando blanco 
cuando Pixel_on_off es 0 y negro cuando es 1. El controlador LCD se 
sincroniza con iCLK y iRST_n, generando señales de salida (oNCLK, 
oGREST, oHD, oDEN, oVD) para el manejo de la interfaz LCD.

*/

module texto_imagen_LCD (iCLK, iRST_n, iNM, oNCLK, oGREST, oHD, oDEN, oVD, oRED, oGREEN, oBLUE);

	input iCLK, iRST_n;
	input [7:0]iNM;
	 
	output oNCLK, oGREST,oHD, oDEN, oVD;
	output reg [7:0] oRED;
	output reg [7:0] oGREEN;
	output reg  [7:0] oBLUE;
		
	wire [10:0] oCol;
	wire [ 9:0] oFil;
	wire Pixel_on_off;
	wire [15:0] oData_rom;
	wire [16:0] address_sig;
	reg [7:0] iNM1 = 8'd159;

	
//	wire [7:0]iNM;
	// Instancias de módulo
	LCD_SYNC  LCD_SYNC_T4 	 (   .iCLK(iCLK),
                                .iRST_n(iRST_n),
                                .oNCLK(oNCLK), 
										  .oGREST(oGREST), 
										  .oHD(oHD), 
										  .oDEN(oDEN),
										  .oVD(oVD),
										  .oFILA(oFil), 
										  .oCOLUMNA(oCol));
	
	
	// Instancias de módulo
	texto texto_T1 (.iRST_n(iRST_n),
		.iDEN(oDEN),
		.iCol(oCol),
		.iFil(oFil),
		.iNCLK(oNCLK),
		.iNumero_a_mostrar(iNM1),
		.oPixel_on_off(Pixel_on_off));

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
		
		
		
		
	// Control de color de píxel basado en Pixel_on_off
	always @(*)
	begin
		case (Pixel_on_off)
			1'b0 :
				begin
					oRED 	   <= {oData_rom[15:11], oData_rom[15:13]}; // Duplicar bits de R
					oGREEN 	<= {oData_rom[10: 5], oData_rom[10: 9]}; // Duplicar bits de G
					oBLUE 	<= {oData_rom[ 4: 0], oData_rom[ 4: 2]};// Blanco cuando Pixel_on_off es 0
				end	
			1'b1 :
				begin 
					oRED   <= 8'b00000000;
					oGREEN <= 8'b00000000;
					oBLUE  <= 8'b00000000;// Negro cuando Pixel_on_off es 1
				end
			default
				begin 
					oRED   <= 8'b11111111;
					oGREEN <= 8'b11111111;
					oBLUE  <= 8'b11111111;// Blanco por defecto si no es 0 ni 1
				end
		endcase
	end

										  
endmodule
