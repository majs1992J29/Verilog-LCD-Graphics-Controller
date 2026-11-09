/*

Nombre del archivo: texto.v
Descripción: Este módulo genera direcciones basadas en la posición 
de columna y fila (iCol e iFil) cuando la señal de habilitación (iDEN) 
está activa. Estas direcciones se utilizan para acceder a dos memorias 
diferentes (frase_5 y ROM_char). La salida oPixel_on_off se controla 
según los datos leídos de ROM_char.

*/

module texto (iRST_n,iDEN, iCol, iFil,iNCLK,iNumero_a_mostrar, oPixel_on_off);
	parameter escala = 2'd4; //escalado de la imagen.
	input iDEN,iNCLK,iRST_n;
	input [10:0] iCol;
	input [ 9:0] iFil;
//	wire [6: 0] Caracter;
	wire [12:0] Direccion;
//	wire [10:0] Direccion_0;
	input [7:0] iNumero_a_mostrar;// = 169; // El número a mostrar, puedes cambiarlo según sea necesario

	reg [10:0] x;
	reg [9: 0] y;
	reg [2: 0] x_1;
	reg [2: 0] y_1;
	output oPixel_on_off;
	
   wire [6:0] digito1, digito2, digito3; // Dígitos individuales
	reg [1:0] estado; // Estado para mostrar dígito 1, 2 o 3
//	wire [6:0] hex_caracter;

	 assign digito1 = 7'h30 + (iNumero_a_mostrar / 100); 		// Centenas
	 assign digito2 = 7'h30 + (iNumero_a_mostrar / 10) % 10; 	// Decenas
	 assign digito3 = 7'h30 + (iNumero_a_mostrar % 10); 		// Unidades
	 
	 
	/* Direccionamiento */
	always @(iCol)
	begin
		if(iDEN == 1'b1)
			begin
			
				if(iCol > 315 && iCol < 345 && iFil > 350 && iFil < 385) //350 && iFil < 385)
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 345 && iCol < 375 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 375 && iCol < 405 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
			
				else if(iCol > 565 && iCol < 600 && iFil > 350 && iFil < 385) //350 && iFil < 385)
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 600 && iCol < 630 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 630 && iCol < 660 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				
				else if(iCol > 825 && iCol < 855 && iFil > 350 && iFil < 385) //350 && iFil < 385)
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 855 && iCol < 885 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else if(iCol > 885 && iCol < 915 && iFil > 350 && iFil < 385) 
				begin
					x <= (iCol  - 11'd216)/escala;// Cálculo de la coordenada horizontal escalada
					y <= (iFil  - 10'd35)/escala;// Cálculo de la coordenada vertical escalada
				end
				else 
				begin
					x <= 11'd0;  // Valor predeterminado para x cuando iDEN no está habilitado
					y <= 10'd0;  // Valor predeterminado para y cuando iDEN no está habilitado
				end
				
			end
		else
		begin
			  x <= 11'd0;  // Valor predeterminado para x cuando iDEN no está habilitado
			  y <= 10'd0;  // Valor predeterminado para y cuando iDEN no está habilitado
		end
	end

//	assign hex_caracter = 7'd48 + digito_actual; // 48 en decimal es igual a 0x30 en hexadecimal
	/* Genera la dirección para acceder a la memoria frase_5 */
//	assign Direccion_0 = (iDEN==1'b1)? {y[7:3],x[8:3]}:11'd0;
//

//	frase_5 		frase_5_inst3(
//	.address(Direccion_0),
//	.clock(iNCLK),
//	.q(Caracter)
//	);	
//	/* Actualiza los bits menos significativos de x_1 y y_1 */
	always @(posedge iNCLK)
	begin
		if(iDEN == 1'b1)
			begin
				x_1 <= x[2:0];
				y_1 <= y[2:0];
			end	
		else
			begin
			  x_1 <= 3'b0;  // Asigna un valor por defecto en el caso contrario
			  y_1 <= 3'b0;
			end
	end	
	/* Genera la dirección para acceder a la memoria ROM_char */
//	assign Direccion = (iDEN==1'b1)? {Caracter,y_1[2:0],x_1[2:0]}:13'd0;
	assign Direccion = (iDEN != 1'b1)? 13'd0: 
											(iCol > 315 && iCol < 345)? {digito1,y_1[2:0],x_1[2:0]}:
											(iCol > 345 && iCol < 375)? {digito2,y_1[2:0],x_1[2:0]}:
											(iCol > 375 && iCol < 405)? {digito3,y_1[2:0],x_1[2:0]}: 
											(iCol > 565 && iCol < 600)? {digito1,y_1[2:0],x_1[2:0]}:
											(iCol > 600 && iCol < 630)? {digito2,y_1[2:0],x_1[2:0]}:
											(iCol > 630 && iCol < 660)? {digito3,y_1[2:0],x_1[2:0]}: 
											(iCol > 825 && iCol < 855)? {digito1,y_1[2:0],x_1[2:0]}:
											(iCol > 855 && iCol < 885)? {digito2,y_1[2:0],x_1[2:0]}:
											(iCol > 885 && iCol < 915)? {digito3,y_1[2:0],x_1[2:0]}: 13'd0;


	ROM_char        ROM_image_inst2 (
	  .address ( Direccion ),
	  .clock ( iNCLK ),
	  .q ( oPixel_on_off )
	);
		
endmodule
