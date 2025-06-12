`define ALU_OP_WIDTH 5

`define ALU_ADD  5'd0
`define ALU_SUB  5'd1
`define ALU_SLT  5'd2
`define ALU_SLTU 5'd3
`define ALU_XOR  5'd4
`define ALU_OR   5'd5
`define ALU_AND  5'd6
`define ALU_SLL  5'd7
`define ALU_SRL  5'd8
`define ALU_SRA  5'd9

`define ALU_EQ   5'd10
`define ALU_NEQ  5'd11
`define ALU_LT   5'd12
`define ALU_GE   5'd13
`define ALU_LTU  5'd14
`define ALU_GEU  5'd15

// Load upper immediate bypass
`define ALU_LUI  5'd16

// `define OPCODE_WIDTH 9

// `define RTYPE 0
// `define ITYPE 1
// `define LOAD 2
// `define STORE 3
// `define BRANCH 4
// `define JAL 5
// `define JALR 6
// `define LUI 7
// `define AUIPC 8
// `define SYSTEM 9
// `define FENCE 10

// `define EXCEPTION_WIDTH 4
// `define ILLEGAL 0
// `define ECALL 1
// `define EBREAK 2
// `define MRET 3

`define OPCODE_RTYPE 7'b0110011 
`define OPCODE_ITYPE 7'b0010011
`define OPCODE_LOAD 7'b0000011
`define OPCODE_STORE 7'b0100011
`define OPCODE_BRANCH 7'b1100011
`define OPCODE_JAL 7'b1101111
`define OPCODE_JALR 7'b1100111
`define OPCODE_LUI 7'b0110111
`define OPCODE_AUIPC 7'b0010111
`define OPCODE_SYSTEM 7'b1110011
`define OPCODE_FENCE 7'b0001111

`define FUNCT3_ADD_SUB 3'b000   // add or sub
`define FUNCT3_SLL 3'b001
`define FUNCT3_SLT 3'b010       // signed comparison
`define FUNCT3_SLTU 3'b011      // unsigned comparison
`define FUNCT3_XOR 3'b100
`define FUNCT3_SRL_SRA 3'b101   // logical right shift or arithmetic right shift
`define FUNCT3_OR 3'b110
`define FUNCT3_AND 3'b111

`define FUNCT3_EQ 3'b000
`define FUNCT3_NEQ 3'b001
`define FUNCT3_LT 3'b100
`define FUNCT3_GE 3'b101
`define FUNCT3_LTU 3'b110
`define FUNCT3_GEU 3'b111 

// ALU src B definitions
`define ALU_SRC_B_REG 2'b00
`define ALU_SRC_B_IMM 2'b01
`define ALU_SRC_B_PL4 2'b10     // PC + 4

// ALU src A definitions
`define ALU_SRC_A_REG 1'b0
`define ALU_SRC_A_PC 1'b1

// MEM to REG definitions
`define MEM_TO_REG_ALU 1'b0
`define MEM_TO_REG_MEM 1'b1

// Write Back Select definitions
`define WB_SEL_ALU 2'b00
`define WB_SEL_MEM 2'b01
`define WB_SEL_PC  2'b10

// define Data memory functions
`define FUNCT3_LB 3'b000
`define FUNCT3_LH 3'b001
`define FUNCT3_LW 3'b010
`define FUNCT3_LBU 3'b100
`define FUNCT3_LHU 3'b101
`define FUNCT3_SB 3'b000
`define FUNCT3_SH 3'b001
`define FUNCT3_SW 3'b010
