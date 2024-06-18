// Copyright (c) 2024 Hansem Ro <hansemro@outlook.com>
// SPDX-License-Identifier: CERN-OHL-P-2.0

`timescale 1ns / 1ps

module jtag_led #(
        parameter USER_PORT = 3, // Valid Options: 1-4
        parameter REG_LENGTH = 4 // >= 2
    ) (
        output wire [3:0] led
    );
    
    wire jtag_drck;
    wire jtag_shift;
    wire jtag_tdi;
    reg jtag_tdo;
    
    BSCANE2 #(
        .JTAG_CHAIN(USER_PORT)
    ) bscane (
        .DRCK(jtag_drck),
        .CAPTURE(),
        .SHIFT(jtag_shift),
        .TDI(jtag_tdi),
        .TDO(jtag_tdo),
        .UPDATE(),
        .RESET(),
        .RUNTEST(),
        .SEL(),
        .TCK(),
        .TMS()
    );
    
    reg [REG_LENGTH-1:0] data_register;

//`define LS
    
`ifdef LS
    always @(posedge jtag_drck)
        if (jtag_shift) begin
            data_register <= {data_register[REG_LENGTH-2:0],jtag_tdi};
            jtag_tdo <= data_register[REG_LENGTH-1];
        end
`else
    always @(posedge jtag_drck)
        if (jtag_shift) begin
            data_register <= {jtag_tdi,data_register[REG_LENGTH-1:1]};
            jtag_tdo <= data_register[0];
        end
`endif
    
    assign led[0] = !data_register[0];
    assign led[1] = !data_register[1];
    assign led[2] = !data_register[2];
    assign led[3] = !data_register[3];
    
endmodule

