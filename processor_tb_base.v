`timescale 1 ns / 100 ps

/*--------------------
  Processor Test Bench
  --------------------*/
  
module processor_tb_auto();

	integer CYCLE_LIMIT = CYCLE_LIMIT_AUTO_GENERATE; // Modify this to change number of cycles run during test

	reg clock = 0, reset = 0;
	integer cycle_count = 0, error_count = 0;
	
	// Probes
	wire [31:0] r0 = dut.my_regfile.register_output[0];
	wire [31:0] r1 = dut.my_regfile.register_output[1];
	wire [31:0] r2 = dut.my_regfile.register_output[2];
	wire [31:0] r3 = dut.my_regfile.register_output[3];
	wire [31:0] r31 = dut.my_regfile.register_output[31];

	wire [4:0] alu_op = dut.my_processor.execute.ctrl_alu_op;
	wire [31:0] alu_a = dut.my_processor.execute.operand_A;
	wire [31:0] alu_b = dut.my_processor.execute.operand_B;
	wire [31:0] rd_data = dut.my_processor.writeback.rf_write_data;
	wire rd_enable = dut.my_processor.writeback.rf_write_enable;
	wire [4:0] rd_ctrl = dut.my_processor.writeback.rf_write_ctrl;
	wire [4:0] alu_shift = dut.my_processor.execute.math_unit.ctrl_shiftamt;
	wire [4:0] regfile_ctrlA = dut.my_processor.ctrl_readRegA;
	wire [4:0] regfile_ctrlB = dut.my_processor.ctrl_readRegB;
	wire [4:0] decode_ctrl_b = dut.my_processor.ctrl_readRegB;
	wire [31:0] q_dmem = dut.my_processor.q_dmem;
	wire stall = dut.my_processor.hazard_stall;
	wire s1 = dut.my_processor.stall_hazard.fd_rs1__is__dx_rd;
	wire s2 = dut.my_processor.stall_hazard.fd_rs2__is__dx_rd;
	wire s3 = dut.my_processor.stall_hazard.fd_rs1__is__xm_rd;
	wire s4 = dut.my_processor.stall_hazard.fd_rs2__is__xm_rd;
	wire [31:0] pcout = dut.my_processor.pc.pc_out;

	wire [31:0] pc_pc_in = dut.my_processor.latch_pc_pc_in;
	wire [31:0] pc_pc_out = dut.my_processor.latch_pc_pc_out;
	wire [31:0] decode_a_out = dut.my_processor.decode.a_out;
	wire [31:0] decode_b_out = dut.my_processor.decode.b_out;
	wire [31:0] execute_pc_in = dut.my_processor.execute.pc_in;
	wire [31:0] execute_a_in = dut.my_processor.execute.a_in;
	wire [31:0] execute_b_in = dut.my_processor.execute.b_in;
	wire [31:0] execute_o_out = dut.my_processor.execute.o_out;
	wire [31:0] execute_b_out = dut.my_processor.execute.b_out;
	wire [31:0] execute_pc_out = dut.my_processor.execute.pc_out;
	wire [31:0] memory_o_in = dut.my_processor.memory.o_in;
	wire [31:0] memory_b_in = dut.my_processor.memory.b_in;
	wire [31:0] memory_o_out = dut.my_processor.memory.o_out;
	wire [31:0] memory_d_out = dut.my_processor.memory.d_out;
	wire [31:0] writeback_o_in = dut.my_processor.writeback.o_in;
	wire [31:0] writeback_d_in = dut.my_processor.writeback.d_in;
	wire [31:0] pc_instruction = dut.my_processor.fetch.instruction_out;
	wire [31:0] decode_instruction = dut.my_processor.latch_fd_instruction_out;
	wire [31:0] execute_instruction = dut.my_processor.latch_dx_instruction_out;
	wire [31:0] memory_instruction = dut.my_processor.latch_xm_instruction_out;
	wire [31:0] writeback_instruction = dut.my_processor.latch_mw_instruction_out;


	// DUT 
	skeleton dut(clock, reset);
	
	// Main: wait specified cycles, then perform tests
	initial begin
		$display($time, ":  << Starting Test >>");	
		#(20*(CYCLE_LIMIT+1.5))
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
		#20   cycle_count = cycle_count + 1;
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
