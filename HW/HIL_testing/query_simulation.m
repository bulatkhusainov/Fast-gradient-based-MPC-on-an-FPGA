function output = query_simulation(design)

current_design = design;

%% generate C code  
cd ../code_generator
generate_code;
cd ../HIL_testing

load ../src/prob_data.mat

if qp_problem.mu > 0 % the remaining code will not make sense if Hessian is not convex
    %% copy C code into a relevant protoip project
    files_to_copy = {'user_fgm_mpc.cpp', 'user_fgm_mpc.h'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),strcat('protoip_project/ip_design/src/',current_name));
    end



    %% run relevant protoip project (including synthesis and HIL test)
    protoip_dir = strcat('protoip_project');
    cd(protoip_dir);
    run_protoip_project;
    cd ../;


    % %% calculate output data
    output = [settling_time; resource_usage; (fpga_time - current_design.Ts); -qp_problem.mu ];
else
    output = [1; 1; 1; -qp_problem.mu ]; % with extreme barrier approach for infeasible solutions objectives (and perhaps progressive barrier constraints) a set to infinity anyway
end


%output = 1;


end