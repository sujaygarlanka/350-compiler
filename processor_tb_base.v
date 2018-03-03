`timescale 1 ns / 100 ps

/*--------------------
  Processor Test Bench
  --------------------*/
  
module processor_tb_auto();

	integer CYCLE_LIMIT = CYCLE_LIMIT_AUTO_GENERATE; // Modify this to change number of cycles run during test

	reg clock = 0, reset = 1;
	integer cycle_count = 0, error_count = 0;
	
	// Probes
	wire [31:0] pc = dut.my_processor.pc_out;
	wire [31:0] mem_data_in = dut.my_processor.mem_data_in;
	wire [31:0] data = dut.my_processor.data;
	wire [31:0] memData = dut.my_processor.memData;
	wire [31:0] q_imem = dut.my_processor.q_imem;
	wire [31:0] q_dmem = dut.my_processor.q_dmem;
	wire [31:0] address_dmem = dut.my_processor.address_dmem;
	wire [4:0] ctrl_writeReg = dut.ctrl_writeReg;
	wire [31:0] data_writeReg = dut.data_writeReg;
	wire [31:0] writeback_instr = dut.my_processor.write.q_imem;
	wire [31:0] data_readRegA = dut.data_readRegA;
	wire [31:0] data_readRegB = dut.data_readRegB;
	wire ctrl_memToReg = dut.my_processor.write.ctrl_memToReg;
	wire [31:0] alu_calc = dut.my_processor.my_alu.data_out;
	wire [31:0] alu_shamt = dut.my_processor.my_alu.shamt;
	wire [31:0] alu_regA = dut.my_processor.my_alu.regA;
	wire [31:0] alu_regB = dut.my_processor.my_alu.regB;
	wire [31:0] alu_opB = dut.my_processor.my_alu.operandBIn;
	wire [31:0] alu_imm = dut.my_processor.my_alu.extendedImmediate;
	wire [16:0] alu_wimm = dut.my_processor.my_alu.q_imem[16:0];
	wire [31:0] decode_latch_in = dut.my_processor.instr_decode_in;
	wire [31:0] decode_latch_out = dut.my_processor.instr_execute_in;
	
	// DUT 
	skeleton dut(clock, reset);
	
	// Main: wait specified cycles, then perform tests
	initial begin
		$display($time, ":  << Starting Test >>");
		#12 reset = 0;	
		#(20*(CYCLE_LIMIT+1.5));
		performTests();		
		$display($time, ":  << Test Complete >>");
		$display("Errors: %d" , error_count);
		$stop;
	end
	
	// Clock generator
	always begin
		#10	clock = ~clock; // toggle every half-cycles
	end
	
	always begin
		@(posedge clock);
		if (reset != 1) begin
			cycle_count = cycle_count + 1;
		end
	end

	always begin
		#10 $display("Current Cycle: %d. Current PC: %b",cycle_count, pc[11:0]); // toggle every half-cycles
	end
	
	task checkRegister; // Note: this assumes regfile works properly and has a 2D array "register_output" that  holds all register values
		input [4:0] reg_num;
		input [31:0] expected_value;
		begin
			if(dut.my_regfile.register_output[reg_num] !== expected_value) begin
				$display("Error: register $%d (expected: %h, read: %h)", reg_num, expected_value, dut.my_regfile.register_output[reg_num]);
				error_count = error_count + 1;
			end
		end
	endtask
