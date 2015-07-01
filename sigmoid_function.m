function [norm_x, k] = sigmoid_function(input_data, k, x_o, direction)

    % ****************************************************************
    %  [norm_x, k] = sigmoid_function(input_data, k, x_o, direction)
    %  
    %   Non-linear intensity scretching based on the logistic function.
    %
    % - input_data is 1D / 2D or 3D.
    % - k controls the steepness of the function: so far, it's configured
    % automatically with 4.96 / (max_x - x_o)
    % - x_o controls the center of the function
    % - direction controls the direction of the function forward/inverse
    %
    % Sergi Valverde sergi.valverde@udg.edu
    % June 2015
    
    x = input_data(:);
    
    % scale data between -10 and 10
    max_x = max(x);
    x = ((20.*x)./max_x)-10;
    x_o = ((20*x_o) ./ max_x)-10;
    
    max_x = max(x(:)); % automatic k
    k = 4.96 / (max_x - x_o);
    if strcmp(direction,'forward')
        X = 1 ./ (1 + exp(k.*(-x+x_o)));
    else
        X = 1 ./ (1 + exp(k.*(+x-x_o)));
    end
    norm_x = reshape(X, size(input_data));
end