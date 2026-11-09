/*

Nombre del archivo: direccionamiento.v
Descripción: Este módulo se encarga de calcular las coordenadas 
escaladas (x, y) basadas en las entradas de posición horizontal (iCol) 
y vertical (iFil). Estas coordenadas se utilizan para formar la 
dirección (oaddress_sig) que se enviará a la memoria ROM para acceder 
a los datos de la imagen. El cálculo de las coordenadas se realiza 
mediante la división y resta, y la dirección se forma concatenando 
las partes escaladas de las coordenadas. La señal oaddress_sig se 
establece en cero si la señal de habilitación (iDEN) está desactivada, 
indicando que no se está accediendo a la memoria ROM en ese momento.

*/

module direccionamiento (iDEN, iCol, iFil,oaddress_sig);

	input iDEN;
	
	input [10:0] iCol;
	input [ 9:0] iFil;
	
	reg [10:0] x; // Coordenada horizontal
	reg [ 9:0] y; // Coordenada vertical
	
	output  [16:0] oaddress_sig;// Señal de dirección para acceder a la memoria ROM
		
	
	always @(iCol)
	begin
		if(iDEN == 1'b1)
			begin
			x <= (iCol - 11'd216)/11'd2;// Cálculo de la coordenada horizontal escalada
			y <= (iFil - 10'd35)/10'd2; // Cálculo de la coordenada vertical escalada
		end
		else
		 begin
			x = 11'd0;  // Valor predeterminado para x cuando iDEN no está habilitado
			y = 10'd0;  // Valor predeterminado para y cuando iDEN no está habilitado
		 end
	end

	// Formación de la dirección de la memoria ROM a partir de las coordenadas escaladas
	assign oaddress_sig = (iDEN==1'b1)? {y[7:0],x[8:0]}:17'd0;
											  
endmodule
