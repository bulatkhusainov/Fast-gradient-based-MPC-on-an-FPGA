function [ output ] = wrapper_query_simulation( x )


% structure that defines design parameters
design.Ts = x(1);
design.N = x(2);
design.n_iter = x(3);
design.q_ratio = x(4);

output = query_simulation(design);


% add to query history
current_query.design = design;
current_query.output = output;
if isempty(dir('query_history.mat'))
    query_history = current_query;
    save query_history query_history
else
    load query_history
    query_history = [query_history current_query];
    save query_history query_history
end


end

