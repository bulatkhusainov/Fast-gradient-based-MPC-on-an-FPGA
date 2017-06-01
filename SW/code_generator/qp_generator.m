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
    qp_problem.b_upper = kron(ones(1,N),0.2*ones(1, m));
    qp_problem.b_lower = kron(ones(1,N),-0.2*ones(1, m));
    
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

    L=abs(max(eig(qp_problem.H)));
    a = 1/L;

    qp_problem.h_x = a*qp_problem.h_x;
    qp_problem.H_diff = eye(size(qp_problem.H)) - a*qp_problem.H;

    mu = abs(min(eig(qp_problem.H)));


    qp_problem.beta_var = (sqrt(L) - sqrt(mu))/(sqrt(L) + sqrt(mu));
    qp_problem.beta_plus = 1 + qp_problem.beta_var;

end

