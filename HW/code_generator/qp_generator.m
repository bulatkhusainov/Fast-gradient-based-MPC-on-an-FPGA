function [qp_problem] = qp_generator(current_design, model, model_c)
    A = model.a;
    B = model.b;
    N = current_design.N;
        
    m = size(B,2); %number of model inputs
    n = size(A,1); %number of states/outputs
    
    % calculating discrete penalties from continious
    Q_c = kron(eye(n/2), diag([1, current_design.q_ratio]));
    R_c = 0.001*eye(m);
    [ ~,~,~, Q, R ] = custom_lrqd(model_c.a,model_c.b,Q_c,R_c,current_design.Ts);
    Q_c_term = Q;
    
    % define upper and lower bounds on inputs
    qp_problem.b_upper = kron(ones(1,N),0.2*ones(1, m)); % upper bounds are always good, since fixed point conversion error is negative
    qp_problem.b_lower = kron(ones(1,N),-0.2*ones(1, m));
    b_lower_ideal = qp_problem.b_lower;
    while double(fi(qp_problem.b_lower, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor')) < b_lower_ideal
        qp_problem.b_lower = qp_problem.b_lower + 0.0001;    
    end
    
    
    %precalculating prediction matrices
    A_big = zeros(0);
    for i=0:N
        A_big = [A_big; A^i];
    end

    B_inter = zeros(size(B));
    for i=0:N-1
        B_inter = [B_inter; (A^i)*B];
    end

    B_big = [];
    for i=0:(N-1)
        shifted = circshift(B_inter,[i*n,0]);
        shifted(1:i*n, :) = zeros(i*n, m);
        B_big = [B_big shifted];
    end


    % penalty matrices
    qp_problem.Q = Q;
    qp_problem.Q_term = Q;
    Q_big = kron(eye(N), Q);
    Q_big = blkdiag(Q_big, Q_c_term);
    qp_problem.Q_big = Q_big;


    qp_problem.R = R;
    R_big = kron(eye(N), R);
    qp_problem.R_big = R_big;

    % QP matrices
    qp_problem.H = B_big'*Q_big*B_big + R_big;
    qp_problem.h_x = A_big'*Q_big*B_big; %h = X'*h_x;
    %L=abs(max(eig(qp_problem.H)));
    
    
    % check if convexity is preserved with fixed point aritmetic by
    % checking minimum eigenvalue
    mu = min(eig(double(fi(qp_problem.H, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor'))));
    qp_problem.mu = mu;
    
    % check if the max eigenvalue is leq than one
    L = max(eig(double(fi(qp_problem.H, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor'))));
    a = 1/L;
    max_eig = max(eig(double(fi(a*qp_problem.H, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor'))));
    while max_eig > 1
        a = a*0.99;
        max_eig = max(eig(double(fi(a*qp_problem.H, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor'))));
    end
    
    % scale Hessian and gradient matrices
    qp_problem.h_x = a*qp_problem.h_x;
    qp_problem.H_diff = eye(size(qp_problem.H)) - a*qp_problem.H;



    % calculate beta
    tmp_var = sqrt(max_eig/abs(mu));
    beta_ideal = (tmp_var-1)/(tmp_var+1);
    beta_real = beta_ideal;
    while double(fi(beta_real, 1, current_design.n_bits_integer+current_design.n_bits_fraction,current_design.n_bits_fraction,'RoundingMethod', 'Floor')) < beta_ideal
        beta_real = beta_real + 0.0001;    
    end
       
    qp_problem.beta_var = beta_real;
    qp_problem.beta_plus = 1 + qp_problem.beta_var;

end

