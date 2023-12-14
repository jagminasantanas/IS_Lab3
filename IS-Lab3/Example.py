import numpy as np
import matplotlib.pyplot as plt

def target_function(x):
    return ((1 + 0.6 * np.sin(2 * np.pi * x / 0.7)) + 0.3 * np.sin(2 * np.pi * x)) / 2

def radial_basis_function(x, center, width):
    return np.exp(-(np.linalg.norm(x - center) ** 2) / (2 * width ** 2))

np.random.seed(42)
num_data_points = 50
x_train = np.linspace(0.1, 1, num_data_points)
y_train = target_function(x_train)

# Initialize RBF network parameters
num_centers = 3
centers = np.linspace(0.1, 1, num_centers)
widths = np.ones(num_centers) * ((1 / num_centers) * 0.5)

# Initialize weights randomly
weights = np.random.rand(num_centers)

# Training parameters
learning_rate = 0.01
epochs = 1000

# Training the RBF network
for epoch in range(epochs):
    for i in range(num_data_points):
        # Compute the output of each RBF neuron
        rbf_outputs = np.array([radial_basis_function(x_train[i], c, w) for c, w in zip(centers, widths)])

        # Compute the predicted output of the network
        predicted_output = np.dot(rbf_outputs, weights)

        # Compute the error
        error = y_train[i] - predicted_output

        # Update the weights using the Delta Rule
        weights += learning_rate * error * rbf_outputs

        # Update the centers and widths using a fraction of the learning rate
        centers += learning_rate * 0.1 * error * (x_train[i] - centers)
        widths += learning_rate * 0.1 * error * ((x_train[i] - centers) ** 2 - widths ** 2)

# Testing the trained RBF network
x_test = np.linspace(0.1, 1, 1000)
y_pred = np.zeros_like(x_test)

for i in range(len(x_test)):
    rbf_outputs = np.array([radial_basis_function(x_test[i], c, w) for c, w in zip(centers, widths)])
    y_pred[i] = np.dot(rbf_outputs, weights)

# Plotting the results
plt.plot(x_test, y_pred, label='RBF Network Output')
plt.plot(x_test, target_function(x_test), label='Target Function')
plt.scatter(x_train, y_train, color='red', label='Training Data')
plt.legend()
plt.title('RBF Network Approximation')
plt.xlabel('x')
plt.ylabel('y')
plt.show()
