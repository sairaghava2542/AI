# ====================================================================
# SYNCHRONOUS SYNTHESIS SCRIPT FOR 8-NEURON AI ACCELERATOR (32nm)
# ====================================================================

# 1. Library Setup
# UPDATE THIS PATH to point to your DBs folder on your Linux machine
set EDK_PATH "/path/to/your/RISC-V_Synthesis_and_Physical_Design-master/ref/DBs"

set search_path [concat $search_path $EDK_PATH "../rtl"]
set target_library "saed32rvt_ss0p75v125c.db saed32hvt_ss0p75v125c.db saed32lvt_ss0p75v125c.db"
set link_library [concat "*" $target_library]

# 2. Define Top Module and Design Files
set TOP_MODULE "grid"
set RTL_FILES [list \
    "../rtl/abs_dtc.v" \
    "../rtl/bias_and_quantize.v" \
    "../rtl/dtc.v" \
    "../rtl/dtc_wabs.v" \
    "../rtl/mac_top.v" \
    "../rtl/neuron_wxor.v" \
    "../rtl/relu.v" \
    "../rtl/tac_signed_wxor.v" \
    "../rtl/grid.v" \
]

# 3. Analyze and Elaborate the Design
define_design_lib WORK -path ./WORK

echo "--- Analyzing RTL Files ---"
analyze -format verilog $RTL_FILES

echo "--- Elaborating Top Module: $TOP_MODULE ---"
elaborate $TOP_MODULE
current_design $TOP_MODULE

# 4. Check for Link Errors
if {[link] == 0} {
    echo "ERROR: Link stage failed. Check library paths!"
    exit
}

# 5. Apply Timing and Constraints
echo "--- Applying Timing Constraints ---"

# Target: 500 MHz clock frequency (Period = 2.0ns)
set CLK_PERIOD 2.0
create_clock -name my_clk -period $CLK_PERIOD [get_ports clk]

# Basic I/O Constraints (Assuming 20% of clock period for external delay)
set IO_DELAY [expr $CLK_PERIOD * 0.2]
set_input_delay  $IO_DELAY -clock my_clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay $IO_DELAY -clock my_clk [all_outputs]

# Set operating conditions and load constraints
set_max_fanout 20 $TOP_MODULE
set_max_area 0

# 6. Compile the Design
echo "--- Compiling Logic Design ---"
compile_ultra

# 7. Generate Outputs & Reports
echo "--- Writing Netlist & Reports ---"

# Create a reports folder if it doesn't exist
file mkdir ./reports
file mkdir ./outputs

# Write out the gate-level files we need for ICC2
write_file -format verilog -hierarchy -output "./outputs/${TOP_MODULE}_mapped.v"
write_sdc "./outputs/${TOP_MODULE}_mapped.sdc"

# Generate human-readable analysis reports
report_timing > ./reports/timing.rpt
report_area   > ./reports/area.rpt
report_power  > ./reports/power.rpt
report_constraint -all_violators > ./reports/violators.rpt

echo "========================================="
echo " Synthesis Completed Successfully! "
echo " Check ./reports and ./outputs folders. "
echo "========================================="
exit
