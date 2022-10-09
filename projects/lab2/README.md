# EE219 Lab2 Systolic Array

## Introduction
This lab aims to design a matrix multiplication module based on systolic array, and apply it to 2D convolution. The diagram of the system design is shown below.

The inputs of our system is the image and weights (convolution kernels). There is an **im2col** module to do conversion on the image in order to do convolutions using GEMM. The **systolic_array** module instantiate a **weight-stationary** systolic array composed by PEs (Processing Elements), it receives the activation **X** from X_buffer and outputs MAC (Multiply Accumulate) results **Y** to Y_buffer.

In this lab, you need to implement the im2col, PE, and systolic_array module by yourself.

<p align="center">
  <img src ="images/top.png"  width="70%"/>
</p>
<p align = "center">
  <i>System Top Diagram</i>
</p>

### im2col + GEMM

When performing a 2D convolution, the data in the convolution window is stored discontinously in memory, which is not efficient for computation. The im2col operation is to expand each convolution **window** on the image into a **column** of matrix X, and expand each convolution **kernel** into a **row** of matrix W. After im2col, the operation of 2D convolution is equivalent to the mutiplication of matrix X and matrix W. The size of matrix X and matrix W is **M \* N** and **N \* K**, where M is the number of convolution kernels, N the number of weights in a kernel and K is the number of total image pixels.

<p align="center">
  <img src ="images/im2col.gif"  width="45%"/>
</p>
<p align = "center">
  <i>im2col operation  </i>
</p>

### Weight Stationary Systolic Array

In parallel computer architectures, a systolic array is a homogeneous network of tightly coupled processing elements (PEs) called cells or nodes. Each node or PE independently computes a partial result as a function of the data received from its upstream neighbours, stores the result within itself and passes it downstream. 