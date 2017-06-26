% Ts =     0.02:0.5
% N =         1:12
% n_iter     20:500
% q_ratio = 0.2:5


% Bounds       
lb = [0.02;   1;   20;   0.2];
ub = [ 0.5;  12;  500;     5];
% Starting Guess
x0 = [0.05; 7; 100; 1];


% Options
opts = nomadset('display_degree',2,'bb_output_type','obj obj pb');

opts.bb_input_type = '[R I I R]';
opts.multi_overall_bb_eval = 200;
%opts.lh_search = '5 1';


% do not forget to delete functio query history (query_history.mat)
[xr,fval,ef,iter] = nomad(@wrapper_query_simulation,x0,lb,ub,opts); 

