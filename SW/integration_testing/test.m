tmp_str = 'mex mex_fgm_mpc.c ../src/fgm_mpc.c';
eval(tmp_str); % compile mex file

% open lopp test
mex_fgm_mpc(ones(1,20));

% closed loop test
a = -0.2; b = 0.2; % states intervals 
x_hat = a + (b-a).*rand(1,current_design.n_states); 
x_hat = x_hat';


N_sim = 500; % number of simulation points
x = x_hat;
x_store = zeros(current_design.n_states ,N_sim);
u_store = zeros(current_design.m_inputs ,N_sim);
for i = 1:N_sim
    u_opt_trajectory = mex_fgm_mpc(x);
    u_opt = u_opt_trajectory(1:current_design.m_inputs);
    x_next = model.a*x + model.b*u_opt;
    
    x_store(:,i) = x;
    u_store(:,i) = u_opt; 
    x = x_next;
end

subplot(2,1,1);
plot(x_store');
subplot(2,1,2);
plot(u_store'); 