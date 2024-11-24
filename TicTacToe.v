module TCell(input clk, set, reset, set_symbol, output reg valid, output reg symbol);
    initial begin
        valid <= 1'b0;
        symbol <= 1'b0; 
    end

    always @(posedge clk) begin
        if (reset) begin
            valid <= 1'b0;
            symbol <= 1'b0; 
        end
        else if (~valid & set) begin
            valid <= 1'b1;
            symbol <= set_symbol; 
        end
    end
endmodule

module TBox(input clk, set, reset, input [1:0] row, input [1:0] col, output [8:0] valid, output [8:0] symbol, output reg [1:0] game_state);
    wire [8:0] d;
    wire cur_sym; 

    reg [3:0] fcells;
    integer j;
    always @(*) begin
        fcells = 4'b0000;
        for (j = 0; j < 9; j = j + 1) begin
            if (valid[j]) 
                fcells = fcells + 1;
        end
    end

    assign cur_sym = ~fcells[0];

    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin
            TCell t(clk, (set & (d[i])), reset, cur_sym, valid[i], symbol[i]);
        end
    endgenerate


    row_col_decoder decoder(row, col, d);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            game_state <= 2'b00; 
        end else begin
            if (|valid) begin

                if (((valid[0] & symbol[0]) & (valid[1] & symbol[1]) & (valid[2] & symbol[2])) ||
                    ((valid[3] & symbol[3]) & (valid[4] & symbol[4]) & (valid[5] & symbol[5])) ||
                    ((valid[6] & symbol[6]) & (valid[7] & symbol[7]) & (valid[8] & symbol[8])) ||
                    ((valid[0] & symbol[0]) & (valid[3] & symbol[3]) & (valid[6] & symbol[6])) ||
                    ((valid[1] & symbol[1]) & (valid[4] & symbol[4]) & (valid[7] & symbol[7])) ||
                    ((valid[2] & symbol[2]) & (valid[5] & symbol[5]) & (valid[8] & symbol[8])) ||
                    ((valid[0] & symbol[0]) & (valid[4] & symbol[4]) & (valid[8] & symbol[8])) ||
                    ((valid[2] & symbol[2]) & (valid[4] & symbol[4]) & (valid[6] & symbol[6]))) begin
                    game_state <= 2'b01; 
                end
                
                else if (((valid[0] & ~symbol[0]) & (valid[1] & ~symbol[1]) & (valid[2] & ~symbol[2])) ||
                         ((valid[3] & ~symbol[3]) & (valid[4] & ~symbol[4]) & (valid[5] & ~symbol[5])) ||
                         ((valid[6] & ~symbol[6]) & (valid[7] & ~symbol[7]) & (valid[8] & ~symbol[8])) ||
                         ((valid[0] & ~symbol[0]) & (valid[3] & ~symbol[3]) & (valid[6] & ~symbol[6])) ||
                         ((valid[1] & ~symbol[1]) & (valid[4] & ~symbol[4]) & (valid[7] & ~symbol[7])) ||
                         ((valid[2] & ~symbol[2]) & (valid[5] & ~symbol[5]) & (valid[8] & ~symbol[8])) ||
                         ((valid[0] & ~symbol[0]) & (valid[4] & ~symbol[4]) & (valid[8] & ~symbol[8])) ||
                         ((valid[2] & ~symbol[2]) & (valid[4] & ~symbol[4]) & (valid[6] & ~symbol[6]))) begin
                    game_state <= 2'b10; 
                end
            
                else if (valid == 9'b111111111) begin
                    game_state <= 2'b11; 
                end

                else begin
                    game_state <= 2'b00; 
                end
            end
        end
    end
endmodule

module row_col_decoder(
    input [1:0] row, 
    input [1:0] col, 
    output reg [8:0] d
);
    always @(*) begin
        case ({row, col})
            4'b0101: d = 9'b000000001; // Row 1, Col 1
            4'b0110: d = 9'b000000010; // Row 1, Col 2
            4'b0111: d = 9'b000000100; // Row 1, Col 3
            4'b1001: d = 9'b000001000; // Row 2, Col 1
            4'b1010: d = 9'b000010000; // Row 2, Col 2
            4'b1011: d = 9'b000100000; // Row 2, Col 3
            4'b1101: d = 9'b001000000; // Row 3, Col 1
            4'b1110: d = 9'b010000000; // Row 3, Col 2
            4'b1111: d = 9'b100000000; // Row 3, Col 3
            default: d = 9'b000000000; 
        endcase
    end
endmodule
