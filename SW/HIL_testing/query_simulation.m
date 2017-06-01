function output = query_simulation(design)

%current_design = design;

%% generate C code  
cd ../code_generator
generate_code;
cd ../HIL_testing

load ../src/prob_data.mat

%% copy C code into a relevant protoip project
files_to_copy = {'user_fgm_mpc.c', 'user_fgm_mpc.h'};
for i = files_to_copy
    current_name = i{:};
    copyfile(strcat('../src/',current_name),strcat('protoip_project/soc_prototype/src/',current_name));
end



%% run relevant protoip project (including synthesis and HIL test)
protoip_dir = strcat('protoip_project');
cd(protoip_dir);
run_protoip_project;
cd ../..;


% %% calculate output data
% output = [performance; cpu_time];
output = 1;
end