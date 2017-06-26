
% Ts =     0.02:0.5
% N =         1:12
% n_iter     20:500
% q_ratio = 0.2:5

input_range = [0.02  0.5; 
                  1   12;
                 20  500;
                0.2    5];
integer = [0 1 1 0];
space_dimension = size(input_range,1);
n_points = 200;

design_matrix = lhsdesign(n_points,space_dimension);


for i = 1:space_dimension
    % add 0.9999 to integers variables
    input_range(i,2) = input_range(i,2) + 0.999*integer(i);
    % scale and shift with respect to the range
    design_matrix(:,i) = design_matrix(:,i)*(input_range(i,2)-input_range(i,1)) + input_range(i,1);
    % apply floor to integers
    if integer(i) == 1
        design_matrix(:,i) = floor(design_matrix(:,i));
    end
end


output_store = [];
for i = 1:n_points
    output = wrapper_query_simulation(design_matrix(i,:));    
    output_store = [output_store output];
end


