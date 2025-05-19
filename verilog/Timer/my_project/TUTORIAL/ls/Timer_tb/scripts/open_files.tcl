global env
# OPEN SOURCE FILES
analyze [list "$env(HDS_PROJECT_DIR)/TUTORIAL/hdl/control_fsm.v"] -format verilog -work tutorial -tech apa
analyze [list "C:/FPGAdv72LS/Hds/examples/tutorial_ref/Import/Timer/Timer_BCDCounter.v"] -format verilog -work my_project_lib1 -tech apa
analyze [list "$env(HDS_PROJECT_DIR)/TUTORIAL/hdl/counter_struct.v"] -format verilog -work tutorial -tech apa
analyze [list "$env(HDS_PROJECT_DIR)/TUTORIAL/hdl/timer_struct.v"] -format verilog -work tutorial -tech apa
analyze [list "$env(HDS_PROJECT_DIR)/TUTORIAL/hdl/timer_tester_flow.v"] -format verilog -work tutorial -tech apa
analyze [list "$env(HDS_PROJECT_DIR)/TUTORIAL/hdl/timer_tb_struct.v"] -format verilog -work tutorial -tech apa
elaborate Timer_tb -work tutorial -tech apa
present_design .tutorial.Timer_tb.INTERFACE
