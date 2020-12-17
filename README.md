This branch is created for putting LDO and temperature wrapper on Caravel. The LDO and temperature wrapper gds files are created using proprietary tools. The LDO uses the IO pads in caravel. The temperature wrapper has its own pad ring, and the gds is merged into the user_project_wrapper.gds

gds/:

- caravel.gds.gz: caravel integrated with ldo and temperature wrapper
- user_project_wrapper.gds.gz: including LDO and temperature wrapper designs

verilog/rtl/:

- user_proj_example.v: rtl including ldo designs
- user_project_wrapper.v: wrapper including user_proj_example.v

def/:

- user_project_wrapper_routed.def: user project DEF including the routed LDO

lef/:

- ldo.lef: LEF for the LDO
- temp_wrapper.lef: LEF of the temperature wrapper excluding the padring

spi/lvs:

- user_project_wrapper.cdl: cdl netlist including the LDO only
