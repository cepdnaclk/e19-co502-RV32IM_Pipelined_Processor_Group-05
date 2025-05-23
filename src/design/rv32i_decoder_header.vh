// `define ALU_WIDTH 14

`define ALU_ADD 0
`define ALU_SUB 1
`define ALU_SLT 2
`define ALU_SLTU 3
`define ALU_XOR 4
`define ALU_OR 5
`define ALU_AND 6
`define ALU_SLL 7
`define ALU_SRL 8
`define ALU_SRA 9
`define ALU_EQ 10
`define ALU_NEQ 11
`define ALU_GE 12
`define ALU_GEU 13

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

// `define FUNCT3_EQ 3'b000
// `define FUNCT3_NEQ 3'b001
// `define FUNCT3_LT 3'b100
// `define FUNCT3_GE 3'b101
// `define FUNCT3_LTU 3'b110
// `define FUNCT3_GEU 3'b111 
