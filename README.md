Handwritten Digit Classifier in x86 Assembly

This CS61C inspired - personal project implements a handwritten digit classification system using x86 assembly, inspired by neural network principles. It processes input matrices representing images, applies mathematical transformations such as ReLU activation and matrix multiplication, and predicts the digit using an argmax operation.

Features:
Matrix Operations: Implements core operations like ReLU activation, dot product, and matrix multiplication.
File Handling: Reads and writes matrix data stored in binary files, ensuring seamless integration with datasets like MNIST.
Neural Network Workflow:
Reads weights and input matrices.
Computes hidden layer activations using ReLU.
Performs forward propagation through the network.
Predicts the digit by finding the index of the highest value in the output matrix.
