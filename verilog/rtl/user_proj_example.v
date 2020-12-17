`default_nettype wire
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    //output wbs_ack_o,
    //output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    //output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [9:0] io_out,

    output [0:0] analog_io,
    //output [`MPRJ_IO_PADS-1:0] io_oeb
    
    input RESET_REGn,
    input [3:0] SEL_CONV_TIME_REG,
    input SEL_DESIGN,
    input [2:0] SEL_GROUP,
    input [1:0] SEL_INST,
    input CLK_REF,

    output CLK_OUT,
    output [23:0] DOUT,
    output DONE
);

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [9:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    wire [1:0] ldo_mode_sel;
    wire [8:0] ldo_std_pt_in_cnt;
    wire [8:0] ldo_ctrl_out;
    wire ldo_clk, ldo_reset, ldo_std_ctrl_in, ldo_VREF;
    wire ldo_cmp_out, ldo_VREG;
    

    // // WB MI A
    // assign valid = wbs_cyc_i && wbs_stb_i; 
    // assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    // assign wbs_dat_o = rdata;
    // assign wdata = wbs_dat_i;

    // // IO
    // assign io_out = count;
    // assign io_oeb = {(`MPRJ_IO_PADS-1){!RESET_REGn}};

    // // LA
    // assign la_data_out = {{(127-BITS){1'b0}}, count};
    // // Assuming LA probes [63:32] are for controlling the count register  
    // assign la_write = ~la_oen[63:32] & ~{BITS{valid}};
    // // Assuming LA probes [65:64] are for controlling the count clk & reset  
    // assign CLK_REF = (~la_oen[64]) ? la_data_in[64]: wb_clk_i;
    // assign RESET_REGn = (~la_oen[65]) ? la_data_in[65]: wb_rst_i;


    //assign io_out[25:0] = {CLK_OUT, DONE, DOUT};
    //assign io_in[11:0] = {CLK_REF, RESET_REGn, SEL_CONV_TIME_REG, SEL_DESIGN, SEL_GROUP, SEL_INST};
    assign io_out[9:0] = {ldo_ctrl_out, ldo_cmp_out};

    assign ldo_clk = io_in[14];
    assign ldo_reset = io_in[13];
    assign ldo_mode_sel = io_in[12:11];
    assign ldo_std_ctrl_in = io_in[10];
    assign ldo_std_pt_in_cnt = io_in[9:1];
    assign ldo_VREF = io_in[0];
    //assign io_ioe = {`MPRJ_IO_PADS{1'b0}};
    //assign wbs_ack_o = {`MPRJ_IO_PADS{1'b0}};
    //assign wbs_dat_o = {`MPRJ_IO_PADS{1'b0}};
    //assign la_data_out = {`MPRJ_IO_PADS{1'b0}};

    ldo ldo_0 (
      .clk            (ldo_clk            ),
      .reset          (ldo_reset          ),
      .mode_sel       (ldo_mode_sel       ),
      .std_ctrl_in    (ldo_std_ctrl_in    ),
      .std_pt_in_cnt  (ldo_std_pt_in_cnt  ),
      .cmp_out        (ldo_cmp_out        ),
      .ctrl_out       (ldo_ctrl_out       ),
      .VREF           (ldo_VREF           )
    );

    temp_wrapper twrapper(
      .RESET_REGn         (RESET_REGn       ),   
      .SEL_CONV_TIME_REG  (SEL_CONV_TIME_REG), 
      .SEL_DESIGN         (SEL_DESIGN       ), 
      .SEL_GROUP          (SEL_GROUP        ), 
      .SEL_INST           (SEL_INST         ),   
      .CLK_REF            (CLK_REF          ), 
      .CLK_OUT            (CLK_OUT          ),
      .DOUT               (DOUT             ), 
      .DONE               (DONE             )  
    
    );

endmodule

`default_nettype wire
