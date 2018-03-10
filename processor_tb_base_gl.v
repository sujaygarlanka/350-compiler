`timescale 1 ns / 100 ps

/*--------------------
  Processor Test Bench
  --------------------*/
  
module processor_tb_auto();

	integer CYCLE_LIMIT = CYCLE_LIMIT_AUTO_GENERATE; // Modify this to change number of cycles run during test

	reg clock = 0, reset = 0;
	integer cycle_count = 0, error_count = 0;

	wire [31:0] my_register;
	// DUT 
	skeleton dut(clock, reset, my_register);
	
	// Main: wait specified cycles, then perform tests
	initial begin
		$display($time, ":  << Starting Test >>\n");	

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
			if(my_register !== expected_value) begin
				$display("ERROR: register $%d (expected: %d, read: %d)", reg_num, expected_value, my_register);
				//$display("\t\t\t\tExecute_o_out: %d, Execute_b_out: %d", execute_o_out, execute_b_out);
				//$display("\t\t\t\tMemory_o_in: %d, Memory_b_in: %d", memory_o_in, memory_b_in);
				//$display("\t\t\t\tMemory_address: %d, q_dmem: %d", memory_address, memory_q_dmem);
				//$display("\t\t\t\tMemory_o_out: %d, Memory_d_out: %d", memory_o_out, memory_d_out);
				//$display("\t\t\t\tWrite_o_in: %d, Write_d_in: %d", writeback_o_in, writeback_d_in);
				//$display("Write register: %d", regfile_ctrlWrite);
				//$display("\t\t\t\ReadRegA: %d, ReadRegB: %d", regfile_ctrlA, regfile_ctrlA);
				//$display("ALU_op: %b, alu_opA: %d, alu_opB: %d alu_result: %d", ALU_op, alu_operandA, alu_operandB, alu_operandB, exec_alu_operandB, alu_result);
				error_count = error_count + 1;
			end
			else
				$display("\t\t\t\t\t\t\t\t\t Success! register $%d (expected: %h, read: %h)", reg_num, expected_value, my_register);
		end
	endtask
