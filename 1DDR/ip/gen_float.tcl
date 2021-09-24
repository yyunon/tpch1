## Env Variables

set aip_dir 	$action_root/ip
set log_dir     .
set log_file    $log_dir/create_action_ip.log
set src_dir 	$aip_dir/action_ip_prj/action_ip_prj.srcs/sources_1/ip

######### You have to change some things  to make this work. Beware the name of modules!!!

#Floating point 0 is float to fixed converter
create_ip -name floating_point -vendor xilinx.com -library ip -version 7.* -module_name floating_point_1 >> $log_file
set_property -dict [list  \
        CONFIG.Operation_Type {Fixed_to_float} \
        CONFIG.A_Precision_Type {Custom} \
        CONFIG.C_A_Exponent_Width {46} \
        CONFIG.C_A_Fraction_Width {18} \
        CONFIG.Result_Precision_Type {Double} \
        CONFIG.Axi_Optimize_Goal {Performance} \
        CONFIG.Has_A_TLAST {true} \
        CONFIG.Has_A_TUSER {true} \
        CONFIG.C_A_Fraction_Width {18} \
        CONFIG.C_Result_Exponent_Width {11} \
        CONFIG.C_Result_Fraction_Width {53} \
        CONFIG.C_Accum_Msb {32} \
        CONFIG.C_Accum_Lsb {-31} \
        CONFIG.C_Accum_Input_Msb {32} \
        CONFIG.C_Mult_Usage {No_Usage} \
        CONFIG.C_Latency {10} \
        CONFIG.C_Rate {1} \
        CONFIG.RESULT_TLAST_Behv {Pass_A_TLAST}\
        ] [get_ips floating_point_1]

set_property generate_synth_checkpoint false [get_files $src_dir/floating_point_1/floating_point_1.xci] >> $log_file
generate_target {instantiation_template}     [get_files $src_dir/floating_point_1/floating_point_1.xci] >> $log_file
generate_target all                          [get_files $src_dir/floating_point_1/floating_point_1.xci] >> $log_file
export_ip_user_files -of_objects             [get_files $src_dir/floating_point_1/floating_point_1.xci] -no_script -force >> $log_file
export_simulation -of_objects                [get_files $src_dir/floating_point_1/floating_point_1.xci] -directory $aip_dir/ip_user_files/sim_scripts -force >> $log_file

create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.* -module_name mult_gen_0 >> $log_file
set_property -dict [list \
                    CONFIG.MultType {Parallel_Multiplier} \
                    CONFIG.PortAWidth {64} \
                    CONFIG.PortBWidth {64} \
                    CONFIG.Use_Custom_Output_Width {false} \
                    CONFIG.OutputWidthHigh {127} \
                    CONFIG.PipeStages {8}] [get_ips mult_gen_0]
set_property generate_synth_checkpoint false [get_files $src_dir/mult_gen_0/mult_gen_0.xci] >> $log_file
generate_target {instantiation_template}     [get_files $src_dir/mult_gen_0/mult_gen_0.xci] >> $log_file
generate_target all                          [get_files $src_dir/mult_gen_0/mult_gen_0.xci] >> $log_file
export_ip_user_files -of_objects             [get_files $src_dir/mult_gen_0/mult_gen_0.xci] -no_script -force >> $log_file
export_simulation -of_objects                [get_files $src_dir/mult_gen_0/mult_gen_0.xci] -directory $aip_dir/ip_user_files/sim_scripts -force >> $log_file
