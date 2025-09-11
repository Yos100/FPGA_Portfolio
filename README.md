# FPGA CPU Project

A custom **32-bit CPU** implemented in VHDL, designed and simulated as part of my computer engineering work.  
The project demonstrates a working datapath and control unit architecture, supporting basic R-type, I-type, and J-type instructions.

---

## 🚀 Features
- **Program Counter (PC)** with asynchronous reset  
- **Instruction Cache (I-Cache)** for fetching machine code  
- **Register File** with two read ports and one write port  
- **Sign Extension Unit** for immediate values  
- **Arithmetic Logic Unit (ALU)** with add, subtract, logical, and comparison operations  
- **Data Cache (D-Cache)** for load/store operations  
- **Next Address Unit** handling branch, jump, and sequential instructions  
- **Control Unit** decoding opcodes and generating control signals  
- **Top-Level CPU Entity** integrating datapath and control logic  

---

## 🛠️ Technologies & Tools
- **Languages:** VHDL  
- **Simulation:** ModelSim  
- **FPGA Tools:** Xilinx Vivado  
- **Target Board:** Nexys A7 (can be adapted to other FPGA boards)  
- **Development Environment:** Linux terminal  

---

## 📂 Repository Structure
FPGA_Portfolio/
│── src/ # VHDL source files
│ ├── PC_Register.vhd
│ ├── I_Cache.vhd
│ ├── regfile.vhd
│ ├── Sign_Extend.vhd
│ ├── Data_Cache.vhd
│ ├── datapath.vhd
│ ├── control_unit.vhd
│ └── cpu.vhd
│── sim/ # Testbenches and simulation files
│── README.md # Project documentation (this file)


---

## 📖 Supported Instructions
- **R-type:** `add`, `sub`, `slt`, `jr`  
- **I-type:** `addi`, `andi`, `lw`, `sw`  
- **J-type:** `j`  
- **Branching:** `beq`, `bne`  

---

## ⚡ How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/Yos100/FPGA_Portfolio.git
   cd FPGA_Portfolio
Open project in Vivado or ModelSim.

Compile all .vhd files inside src/.

Run testbenches from the sim/ folder to verify functionality.

(Optional) Synthesize and implement on Nexys A7 FPGA.

📊 Example Simulation
Load immediate values into registers.

Perform arithmetic operations (add, sub).

Store and load data from memory.

Execute a branch instruction and observe PC change.

🎯 Learning Outcomes
Designed and integrated a full CPU datapath and control unit.

Learned hardware-software co-design using VHDL and FPGA.

Improved skills in simulation, debugging, and hardware synthesis.

👤 Author
Yoseph Assefa
