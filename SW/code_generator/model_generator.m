function [model, design] = model_generator(design)
N_carts=10;
Ts = design.Ts;

design.n_states = N_carts*2;
design.m_inputs = N_carts;
design.n_variables = design.N*design.m_inputs;

% k = 1*ones(1,N_carts); % spring constants
% b = 0.2*ones(1,N_carts); % damping constants
% m = 1*ones(1,N_carts); % damping constants

k = [0.5472    0.1386    0.1493    0.2575    0.08407  0.1966    0.0511    0.6160    0.4733    0.10517];
b = [0.0509    0.1629    0.0487    0.1859    0.0700   0.5472    0.0386    0.1493    0.2575    0.08407];
m = [0.1966    0.2511    0.6160    0.4733    0.10517  0.4509    0.1629    0.1487    0.1859    0.0700];


k(N_carts+1) = 0; % the last cart is connected only to previous one
b(N_carts+1) = 0;

% state matrix generation
A = kron(diag(ones(1,N_carts)),[0 1; 0 0]); 

for i=1:N_carts
    A(i*2,i*2-1) = -(k(i)+k(i+1))/m(i);
    A(i*2,i*2) = -(b(i)+b(i+1))/m(i); 
    
    if(i>1)
        A(i*2,i*2-3) = k(i)/m(i);
        A(i*2,i*2-2) = b(i)/m(i);
    end
    
    if(i<N_carts)
        A(i*2,i*2+1) = k(i+1)/m(i);
        A(i*2,i*2+2) = b(i+1)/m(i);
    end
    
    
end

% input matrix generation
B = zeros(N_carts*2,N_carts);
for i=1:N_carts
    B(i*2,i) = 1 / m(i);
end

% output matrix generation
C=eye(N_carts*2);

% Direct transition matrix generation
D = zeros(N_carts*2, N_carts);

system = ss(A,B,C,D);

descrete_system = c2d(system,Ts);

model = descrete_system;

%[A,B,C,D] = ssdata(descrete_system); 

% Initial conditions
%X = 0.01*rand(1, N*2);

% Input
%F = 0.05*ones(1, N);
