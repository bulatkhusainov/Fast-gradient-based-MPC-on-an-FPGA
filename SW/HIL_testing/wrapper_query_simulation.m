function [ output ] = wrapper_query_simulation( x )


% structure that defines design parameters
design.Ts = x(1);
design.N = x(2);
design.n_iter = x(3);
design.q_ratio = x(4);

output = query_simulation(design);

end

