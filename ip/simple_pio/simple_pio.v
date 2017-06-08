module simple_pio
(
	input wire clk,
	input wire reset,
	input wire[3:0] address_a,
	input wire[31:0] writedata_a,
	output wire[31:0] readdata_a,
	input wire write_a,
	input wire[3:0] address_b,
	input wire[31:0] writedata_b,
	output wire[31:0] readdata_b,
	input wire write_b
);

reg[31:0] d;

always @(posedge clk)
begin
	if(write_a == 1'b1) d <= writedata_a;
	else if(write_b == 1'b1) d <= writedata_b;
end

assign readdata_a = d;
assign readdata_b = d;

endmodule
