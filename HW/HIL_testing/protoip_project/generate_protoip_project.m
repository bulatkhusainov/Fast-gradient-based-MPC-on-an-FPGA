% figure out vector interfaces lengths
% ip interfaces
x_hat_in = strcat('x_hat:',num2str(5),':float');
u_opt_out = strcat('u_opt:',num2str(5),':float');


%make_template('type','PL','project_name','my_project0','input',x_hat_in,'output',u_opt_out);

%ip_design_build('project_name','my_project0', 'input', x_hat_in, 'output', u_opt_out);

%ip_design_build_debug('project_name','my_project0');

%ip_prototype_build('project_name','my_project0','board_name','zedboard');

%ip_prototype_build_debug('project_name','my_project0','board_name','zedboard');

%ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp');

%ip_prototype_load_debug('project_name','my_project0','board_name','zedboard')

%ip_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);
 
%soc_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp', 'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%soc_prototype_load_debug('project_name','my_project0','board_name','zedboard');

%soc_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);

%ip_design_duplicate('from','my_project0','to','my_project0');

%ip_design_delete('project_name','my_project0');