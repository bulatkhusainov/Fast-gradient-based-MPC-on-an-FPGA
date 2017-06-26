% figure out vector interfaces length
x_hat_in = strcat('x_hat:',num2str(current_design.n_states),':float');
u_opt_out = strcat('u_opt:',num2str(current_design.N*size(model.b,2)),':float');
 
% delete previous test files
%delete('ip_prototype/test/results/my_project0/*.dat');


%ip_design_build('project_name','my_project0', 'input', x_hat_in, 'output', u_opt_out);

ip_design_build_debug('project_name','my_project0');

%ip_prototype_build('project_name','my_project0','board_name','zedboard');

%ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp');

%ip_prototype_load_debug('project_name','my_project0','board_name','zedboard')

%ip_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);


% mkdir(strcat('soc_prototype/test/results/my_project0/PAR_',num2str(PAR)));
% copyfile('soc_prototype/test/results/my_project0/*.dat', strcat('soc_prototype/test/results/my_project0/N_',num2str(N),'_PAR_',num2str(PAR+double(logical(double(rem_partition))))));
% delete('soc_prototype/test/results/my_project0/*.dat');

% read obectives and constraints
settling_time = sum(importdata('ip_prototype/test/results/my_project0/settling_time.dat'));

fpga_time = (importdata('ip_prototype/test/results/my_project0/fpga_time_log.dat'));
fpga_time = max(str2num(cell2mat(([fpga_time.textdata]))));

resource_usage = importdata('doc/my_project0/ip_prototype.dat');            
resource_usage = sqrt( (resource_usage(13)/53200)^2 + (resource_usage(14)/106400)^2 + (resource_usage(16)/220)^2 + (resource_usage(15)/280)^2 );