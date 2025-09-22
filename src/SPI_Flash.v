   module SPI_flash (
    // Interface système
    input  wire        clk,          // Horloge système principale
    input  wire        rst,        // Reset actif bas (bonne pratique)
    
    // Interface de contrôle
    input  wire [7:0]  tx_data,      // Données à transmettre
    output wire [7:0]  rx_data,      // Données reçues
    input  wire        write,     // Démarrer transmission (edge-triggered)
    output reg        busy,         // Transmission en cours
    
    // Configuration SPI
    //input  wire   cpha,       // Configuration: {cs_pol, cpol, cpha, first_bit}
    
    // Interface SPI
    output wire         spi_clk,      // Horloge SPI
    output wire         spi_mosi,     // Master Out Slave In
    input  wire        spi_miso     // Master In Slave Out
);


    // Décodage de la configuration
    
    reg [7:0] shift_regIN, shift_regOUT;
    reg [2:0] counter;
    wire SR_RST;
    
    assign SR_RST = (counter==3'd7);
	assign spi_clk = clk & busy;
    assign spi_mosi = shift_regOUT[7];
    assign rx_data = shift_regIN;
	
    always@(negedge clk or posedge rst)begin
		if(rst)begin
			busy<=1'b0;
			counter<=3'b0;
		end else begin
			if(SR_RST)begin 
				counter<=3'b0;
				busy <= 1'b0;
			end else begin
				counter<=counter+busy;
				busy <= write?1'b1:busy;
			end
		end
		
	end
	
	always@(negedge clk or posedge rst)begin
		if(rst)begin 
			shift_regOUT<=8'b0;
		end else begin
			if(write & ~busy)shift_regOUT<=tx_data;
			else if(busy)begin
				shift_regOUT<={shift_regOUT[6:0],1'b0};
			end
		end
	end
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin 
			shift_regIN<=8'b0;
		end else begin
			if(busy)begin
				shift_regIN<={shift_regIN[6:0],spi_miso};
			end
		end
	end
endmodule 