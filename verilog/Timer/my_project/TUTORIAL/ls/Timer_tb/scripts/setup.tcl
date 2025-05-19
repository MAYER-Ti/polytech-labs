# SETUP
 # SET CLOCK PERIOD (eg 50MHz = 20ns)
 set register2register 25.00000
 set input2register 25.00000
 set register2output 25.00000
 set input2output 25.00000

# SETUP TECHNOLOGY
set part apa300pqfp208
set process STD
set wire_table APA
load_library apa

# APPEND GENERICS
set append_generics_to_toplevel FALSE

