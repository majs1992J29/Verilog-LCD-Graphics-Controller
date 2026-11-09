/*

Nombre del archivo: tb_imagen_lcd.v
Descripción: test bench del modulo imagen_lcd que genera un archivo 
imagen_lcd.txt (..\simulation\modelsim\) que se puede utilizar en
http://personales.upv.es/rcolom/webs/screensim/index.html con una
frecuencia de 25 MHz, resolución vertical de 800 pixeles y resolucion
vertical de 480. Back Porch a partir de la columna 216 y la fila 35.

*/



`timescale 1ns/1ns

module tb_imagen_lcd();
	localparam T = 20; //25MHz
	reg CLK, RST_n;
	wire NCLK, GREST,HD, DEN, VD;
	wire  [7 :0] RED, GREEN, BLUE;
	integer fd;
	event cierraFichero;
	
	// Instanciación del DUT (Device Under Test)
	imagen_lcd  imagen_lcd_Test (    .iCLK(CLK),
                                .iRST_n(RST_n),
										  .oNCLK(NCLK),
										  .oGREST(GREST),
                                .oHD(HD),
										  .oDEN(DEN),
										  .oVD(VD),
										  .oRED(RED),
										  .oGREEN(GREEN),
										  .oBLUE(BLUE));
										  

										  
										  
										  
										  
initial
		 begin
		 CLK=1'b0;
		RESET;
		@(posedge VD);
	   $display("Fin de la simulacion\n");
		-> cierraFichero;
		#10;
		$stop;
		 end	
		 
initial begin
fd = $fopen("imagen_LCD.txt","w");
@(cierraFichero);
disable guardaFichero;
$display("Cierro Fichero");
$fclose(fd);
end

initial forever begin: guardaFichero
@(posedge NCLK)
$fwrite(fd,"%0t ps: %b %b %b %b %b %b\n",$time,HD,VD,DEN,RED,GREEN,BLUE);
end
 
task RESET;
	begin
	RST_n = 1'b0;
		repeat(7)@(negedge CLK);
	RST_n = 1'b1;
	
	end
endtask



 
 
 always
		 begin
			  #(T/2) CLK <= ~CLK;
		 end

endmodule
									  
										  