//=======================================================
//  This code implements a PLL reconfiguration state
//  machine for use with the ALTPLLRECONFIG megafunction
//
//  Copyright Lee Szuba 2012
//=======================================================


module RECONFIG_STATE_MACHINE (
    reset,
    clk,
    update,
    busy,
    write_param,
    reconfig );

	input reset;
    input clk;
    input update;
    input busy;
    output write_param;
    output reconfig;

    reg write_param;
    reg reconfig;

    reg [4:0] fstate;
    reg [4:0] reg_fstate;

    parameter IDLE = 0,
              RECONFIG = 1,
              START_RECONFIG = 2,
              WRITE_PARAMS = 3,
              START_UPDATE = 4;

    always @(posedge clk)
    begin
        if (clk) begin
            fstate <= reg_fstate;
        end
    end

    always @(fstate or reset or update or busy)
    begin
        if (reset) begin
            reg_fstate <= IDLE;
            write_param <= 1'b0;
            reconfig <= 1'b0;
        end else begin
            write_param <= 1'b0;
            reconfig <= 1'b0;
            case (fstate)
                IDLE: begin
                    if (update)
                        reg_fstate <= START_UPDATE;
                    else
                        reg_fstate <= IDLE;
                end
                RECONFIG: begin
                    if (~busy)
                        reg_fstate <= IDLE;
                    else
                        reg_fstate <= RECONFIG;
                    reconfig <= 1'b0;
                end
                START_RECONFIG: begin
                    reg_fstate <= RECONFIG;

                    reconfig <= 1'b1;
                end
                WRITE_PARAMS: begin
                    if (~busy)
                        reg_fstate <= START_RECONFIG;
                    else
                        reg_fstate <= WRITE_PARAMS;
                end
                START_UPDATE: begin
                    reg_fstate <= WRITE_PARAMS;
                    write_param <= 1'b1;
                end
            endcase
        end
    end
endmodule
