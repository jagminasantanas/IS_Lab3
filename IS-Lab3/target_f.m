
% Generate random data points for training
num_data_points = 50;
x_train = sort(rand(1, num_data_points));
y_train = target_function(x_train);

% Initialize RBF network parameters
num_centers = 10;
centers = linspace(0, 1, num_centers);
widths = (1 / num_centers) * 0.5;

% Initialize weights randomly
weights = rand(1, num_centers);

% Training parameters
learning_rate = 0.01;
epochs = 1000;

% Training the RBF network
for epoch = 1:epochs
    for i = 1:num_data_points
        % Compute the output of each RBF neuron
        rbf_outputs = arrayfun(@(c, w) radial_basis_function(x_train(i), c, w), centers, widths);

        % Compute the predicted output of the network
        predicted_output = weights * rbf_outputs';

        % Compute the error
        error = y_train(i) - predicted_output;

        % Update the weights using the Delta Rule
        weights = weights + learning_rate * error * rbf_outputs;

        % Update the centers and widths using a fraction of the learning rate
        centers = centers + learning_rate * 0.1 * error * (x_train(i) - centers);
        widths = widths + learning_rate * 0.1 * error * ((x_train(i) - centers).^2 - widths.^2);
    end
end

% Testing the trained RBF network
x_test = linspace(0, 1, 1000);
y_pred = zeros(size(x_test));

for i = 1:length(x_test)
    rbf_outputs = arrayfun(@(c, w) radial_basis_function(x_test(i), c, w), centers, widths);
    y_pred(i) = weights * rbf_outputs';
end

% Plotting the results
figure;
plot(x_test, y_pred, 'LineWidth', 2, 'DisplayName', 'RBF Network Output');
hold on;
plot(x_test, arrayfun(@target_function, x_test), 'LineWidth', 2, 'DisplayName', 'Target Function');
scatter(x_train, y_train, 'r', 'DisplayName', 'Training Data');
legend();
title('RBF Network Approximation');
xlabel('x');
ylabel('y');
hold off;

% Define the target function
function y = target_function(x)
    y = ((1 + 0.6 * sin(2 * pi * x / 0.7)) + 0.3 * sin(2 * pi * x)) / 2;
end

% Define the radial basis function
function phi = radial_basis_function(x, center, width)
    phi = exp(-norm(x - center)^2 / (2 * width^2));
end