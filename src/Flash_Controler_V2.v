module Flash_Controler (
    input wire[15:0] adresse,
    input wire read_enable,          // Signal pour démarrer une lecture
    output reg[31:0] DataOUT,        // Données 32 bits en sortie
    output reg data_valid,           // Indique que les données sont valides
    
    input wire clkout,
    input wire rst,
    output wire busy,
    
    output wire spi_clk,
    output wire spi_mosi,
    input wire spi_miso,
    output reg spi_cs_n
);    

    // Commandes Flash MX25L3233F
    parameter CMD_READ    = 8'h03;  // Fast Read
    
    // États de la machine à états
    parameter STATE_IDLE       = 3'd0;
    
    parameter CMD_number = 4'd1;
    parameter STATE_CMD        = 3'd1;
    parameter STATE_CMD_SEND   = 3'd2;
    
    parameter ADDR_number = 4'd3;
    parameter STATE_ADDR     = 3'd3;   // Adresse haute
    parameter STATE_ADDR_SEND     = 3'd4;   // Adresse haute
    
    parameter DATA_number = 4'd4;
    parameter STATE_DATA    = 3'd5;   // Premier octet (MSB)
    parameter STATE_DATA_SEND    = 3'd6;   // Premier octet (MSB)
    
    parameter STATE_FINISH     = 3'd7;   // Finalisation
    
    // Registres internes
    reg [4:0] state, next_state;
    reg [7:0] spi_tx_data;
    wire [7:0] spi_rx_data;
    reg [7:0] cmd_buffer[CMD_number-1 : 0];
    reg [7:0] addr_buffer[ADDR_number-1 : 0];
    reg [7:0] data_buffer[DATA_number-1 : 0];
    reg [3:0] cmd_cnt, addr_cnt, data_cnt;
    reg spi_clk_en;
    reg read_req;
    reg read_req_prev;
    wire spi_busy;
    wire clk_SM;

    SPI_flash spi0(
        .clk(clkout),
        .rst(rst),
        .tx_data(spi_tx_data), // Données à transmettre
        .rx_data(spi_rx_data),// Données reçues
        .write(spi_clk_en),
        .busy(spi_busy),
        //.cpha(confspi),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso)
    );
    assign busy = (state != STATE_IDLE);
    
    // Détection du front montant de read_enable
    always @(posedge clkout or posedge rst) begin
        if (rst) begin
            read_req_prev <= 1'b0;
            read_req <= 1'b0;
        end else begin
            read_req_prev <= read_enable;
            read_req <= read_enable & ~read_req_prev;
        end
    end
    
    // Machine à états principale - Mise à jour sur front montant de clk
    always @(posedge clkout or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;
            spi_cs_n <= 1'b1;
            spi_clk_en <= 1'b0;
            DataOUT <= 32'h0;
            data_valid <= 1'b0;
            spi_tx_data <= 8'h0;
        end else begin
            state <= next_state;
            case (state)
                STATE_IDLE: begin
                    spi_cs_n <= 1'b1;
                    spi_clk_en <= 1'b0;
                    data_valid <= 1'b0;
                    spi_tx_data <= CMD_READ;
                    
                    if (read_req) begin
                        spi_cs_n <= 1'b0;
						cmd_buffer[0] <= CMD_READ;
						addr_buffer[0] <= {adresse[5:0],2'b00};
						addr_buffer[1] <= adresse[13:6];
						addr_buffer[2] <= {6'b00, adresse[15:14]};	//addresse dispatcher sur 24bits
						cmd_cnt <= CMD_number;
						addr_cnt <= ADDR_number;
						data_cnt <= DATA_number;

                    end
                end
                
                STATE_CMD: begin
					spi_clk_en <= 1'b1;
					spi_tx_data <= cmd_buffer[cmd_cnt]; // Premier octet d'adresse
					if (spi_busy)cmd_cnt<=cmd_cnt-1'b1;            
				end


                STATE_CMD_SEND: begin
                    spi_clk_en <= 1'b0;
                end
                
                STATE_ADDR: begin
					if (spi_busy)addr_cnt<=addr_cnt-1'b1;
                    spi_clk_en <= 1'b1;
                    spi_tx_data <= addr_buffer[addr_cnt-4'b1]; // Premier octet d'adresse
                end

                STATE_ADDR_SEND: begin
                    spi_clk_en <= 1'b0;
                end
                
                STATE_DATA: begin // MSB
					if (spi_busy)data_cnt<=data_cnt-1'b1;
                    spi_tx_data <= 8'd255;
                    spi_clk_en <= 1'b1;
                end

                STATE_DATA_SEND: begin // MSB
                    spi_clk_en <= 1'b0;
                    if (~spi_busy)data_buffer[data_cnt] <= spi_rx_data;
                end
                
                STATE_FINISH: begin
                    spi_cs_n <= 1'b1;
                    DataOUT <= {data_buffer[3],data_buffer[2],data_buffer[1],data_buffer[0]};
                    data_valid <= 1'b1;
                end
            endcase
        end
    end
    
    // Logique de transition d'états - basée sur les fronts SPI
    always @(*) begin
        next_state = state;
        case (state)
            STATE_IDLE: begin
                if (read_req)next_state = STATE_CMD;
            end
            
            STATE_CMD: begin
				if (spi_busy)next_state = STATE_CMD_SEND;
            end
             
            STATE_CMD_SEND: begin
                if ((~spi_busy) & (cmd_cnt==0))next_state = STATE_ADDR;
                if ((~spi_busy) & (cmd_cnt>0))next_state = STATE_CMD;
            end

            STATE_ADDR: begin
				if (spi_busy)next_state = STATE_ADDR_SEND;
            end
            
            STATE_ADDR_SEND: begin
                if ((~spi_busy) & (addr_cnt==0))next_state = STATE_DATA;
                else if ((~spi_busy) & (addr_cnt>0))next_state = STATE_ADDR;
            end
            
            STATE_DATA: begin
				if (spi_busy)next_state = STATE_DATA_SEND;
            end

            STATE_DATA_SEND: begin
                if ((~spi_busy) & (data_cnt==0))next_state = STATE_FINISH;
                else if ((~spi_busy) & (data_cnt>0))next_state = STATE_DATA;
            end
            
            STATE_FINISH: begin
				next_state = STATE_IDLE;
            end
        endcase
    end
endmodule