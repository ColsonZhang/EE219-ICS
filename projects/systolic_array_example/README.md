## EE219 Systolic Array Example Introduced in the Lecture Slides
 
There are three verilog file: `PE.v` is a single MAC unit with control signals; `PE_array.v` is a 2D systolic array consisting of the MAC units; `PE_array_tb.v` is a testbench for `PE_array.v`, computing 

<p align="center">
  <img src ="http://latex.codecogs.com/svg.latex?%5Cbegin%7Bpmatrix%7D%0D%0A0%261%261%5C%5C%0D%0A1%261%260%5C%5C%0D%0A1%260%261%5C%5C%0D%0A%5Cend%7Bpmatrix%7D%5Ctimes%5Cbegin%7Bpmatrix%7D1%262%5C%5C3%264%5C%5C5%266%5C%5C%5Cend%7Bpmatrix%7D"  width="14%"/>
</p>
<p align = "center">
</p>

To run the testbench, either in the experiment environment or on your local computer (with iverilog installed) 
```
iverilog -o PE_array_test PE_array_tb.v PE_array.v PE.v
vvp PE_array_test
```


### Systolic Array

In parallel computer architectures, a systolic array is a homogeneous network of tightly coupled processing elements (PEs) called cells or nodes. Each node or PE independently computes a partial result as a function of the data received from its upstream neighbours, stores the result within itself and passes it downstream. 

<p align="center">
  <img src ="img/array.png"  width="45%"/>
  <img src ="img/flow.gif"  width="45%"/>
</p>
<p align = "center">
  <i>Systolic Array</i>
</p>

### im2col + GEMM

When performing a 2D convolution, the data in the convolution window is stored discontinously in memory, which is not efficient for computation. The im2col operation is to expand each convolution **window** into a **column** of matrix B, and expand each convolution **kernel** into a **row** of matrix A. After im2col, the operation of 2D convolution is equivalent to the mutiplication of matrix A and matrix B. The size of matrix A and matrix B is **M \* N** and **N \* K**, where M is the number of convolution kernels, N the number of weights in a kernel and K the number of image pixels.

<p align="center">
  <img src ="img/im2col.gif"  width="45%"/>
</p>

## Lab Tasks

The whole design includes three tasks

1. perform im2col transformation on the input images
2. slice two matrices and load data to the buffer
3. perform matrix multiplication using systolic array

You need to implement the first and third tasks (im2col and systolic array).

### Data Storage

All the input and output data are stored in a simulated memory with 32 bits, find the base addresses of each parameter in the below form. Please note that the image, weights and output matrix are stored in row-major order, the im2col are stored in column-major order.


| Name | Value | Description |
| - | - | - |
| IMG_BASE | 0x00000000 | image base address |
| WEIGHT_BASE | 0x00001000 | weights base address |
| IM2COL_BASE | 0x00002000 | im2col base address |
| OUTPUT_BASE | 0x00003000 | output base address |

<p align="center">
  <img src ="img/mem.png"  width="45%"/>
</p>


### Matrix Slicing

When the size of input matrix is larger than the size of systolic array, the matrix should be first sliced, the width of each slice is the same as the array size. Assume below situation, matrix A and matrix B are divided into 4 slice respectively, we first stream (A_slice0, B_slice0) into the array, and second stream (A_slcie0, B_slice1), and so on... To finish the whole matrix multiplication, each PE needs to do 4x4=16 accumulations. To control the streaming of the input, we needs two cascaded counter to provide correct indexes of slices and pixels.

For the case that the matrix size is not a multiple of the array size, the matrix needs to be appended with zero rows and colunms. This operation is automatically done in the testbench and **you can just assume the integer multiples in your design**.

<p align="center">
  <img src ="img/slicing.png"  width="60%"/>
</p>

## Design Specification

Implementation of below three modules are mandatory, you can add extra modules (but not necessary). All the modules should be written by Verilog.

* im2col.v
* pe.v
* systolic.v

Design details are described below.

### Module im2col (im2col.v)

This module performs the im2col conversion. You need to read image values from memory and write them back to the proper location. (Here we only consider 3x3 filters.)

#### Parameters

| name | description |
| - | - |
| IMG_W | image width |
| IMG_H | image height |
| DATA_WIDTH | data width |
| ADDR_WIDTH | address width |
| FILTER_SIZE | size of convolution kernel（e.g. 3 means 3x3 kernel） |
| IMG_BASE | image base address |
| IM2COL_BASE | im2col base address |

#### Ports

| name | type | width | description |
| - | - | - | - |
| clk | input | 1 | clock signal |
| rst_im2col | input | 1 | reset signal |
| data_rd | input | DATA_WIDTH | memory read value |
| data_wr | output | DATA_WIDTH | memory write value |
| addr_rd | output | ADDR_WIDTH | memory read address |
| addr_wr | output | ADDR_WIDTH | memory write address |
| im2col_done | output | 1 | oepration done signal |
| mem_wr_en | output | 1 | memory write enable |

#### Design Requirements

1. Begin im2col conversion on negedge of `rst_im2col`, pull `im2col_done` up when finish.
2. The memory can be read and write once per clock cycle.
3. Use zero-padding in 2D convolution.

### Module PE (pe.v)

The basic function of PE is calculating the dot products of the rows and columns, and streaming the inputs to its neighbors.

#### Parameters

| name | description |
| - | - |
| N | the number of columns in matrix A |
| MAX_CNT | maximun number of accumulation operations（(M\*K)/(ARR_SIZE\*ARR_SIZE)） |
| DATA_WIDTH | data width |
| ACC_WIDTH | accumulator width |

#### Ports

| name | type | width | description |
| - | - | - | - |
| clk | input | 1 | clock signal |
| rst | input | 1 | reset signal |
| init | input | 1 | signal to clear accumulator |
| in_a | input | DATA_WIDTH | input a |
| in_b | input | DATA_WIDTH | input b |
| out_a | output | DATA_WIDTH | output a |
| out_b | output | DATA_WIDTH | output b |
| out_sum | output | ACC_WIDTH | accumulation output |
| valid_D | output | 1 | output valid |

#### Design Requirements

1. Perform multiply-accumulation on two inputs `in_a` and `in_b` in every clock cycle.
2. Streaming out registered version of `in_a` and `in_b` to `out_a` and `out_b`.
3. Pull up `valid_D` when the dot product is valid.
4. Reset all the output on `rst`.
5. Clear the accumulator and start a new accumulation on `init`.

### Module Systolic Array (systolic.v)

The systolic array is constructed by instantiation of the PE modules. You need to connect the PEs properly and generate the `init` signal for each of them. You also need to generate the pixel and slice counter as described above.

#### Parameters

| name | description |
| - | - |
| M | number of rows in matrix A |
| N | number of columns in matrix A |
| K | number of columns in matrix B |
| ARR_SIZE | size of systolic array |
| DATA_WIDTH | data width |
| ACC_WIDTH | accumulator width |

#### Ports

| name | type | width | description |
| - | - | - | - |
| clk | input | 1 | clock signal |
| rst | input | 1 | reset signal |
| enable_row_count_A | input | 1 | allow the slice counter of A to increment |
| A | input | DATA_WIDTH*ARR_SIZE | inputs on the side of matrix A |
| B | input | DATA_WIDTH*ARR_SIZE | inputs on the side of matrix B |
| D | output | ACC_WIDTH\*ARR_SIZE\*ARR_SIZE | connect to each PE's `out_sum` (D[i][j] -> PE[i][j].out_sum) |
| valid_D | output | ARR_SIZE*ARR_SIZE | connect to each PE's `valid_D` (valid_D[i][j] -> PE[i][j].valid_D) |
| pixel_cntr_A | output | 32 | pixel index of matrix A |
| slice_cntr_A | output | 32 | slice index of matrix A |
| pixel_cntr_B | output | 32 | pixel index of matrix B |
| slice_cntr_B | output | 32 | slice index of matrix B |

#### Design Requirements

1. reset all the outputs on `rst`.

## Simulation Environment

### File location

Copy the `lab2` folder to path `~/workspace/ics/projects/` in the docker image. The three module files with ports defination are located in `lab2/vsrc/src/`

### Run single test

You may have to install numpy first by
```
conda install numpy
```
or
```
pip3 install numpy
```

Simply run `make` under `~/workspace/ics/projects/lab2`, it will automatically generate inputs and do a test on your design. If you pass the test, the terminal will show something like

<img src="img/make.png" width="95%" align="middle"/>

(numbers are printed in hexadecimal)

#### Specifiy parameters

You can specify the parameters like

```
make ARR_SIZE=4 IMG_W=5 IMG_H=4 FILTER_NUM=6 FILTER_SIZE=3
```

#### Enable debug

Add `DEBUG=1` to print more useful information.

#### Clean

Run `make clean` to clean up the output files. It is recommended to do this before every simulation.

### Run multiple tests

Give execute permission to the script
```
chmod +x ./run_test.sh
```

Run tests
```
./run_test.sh
```
20 test cases are given in `test/testcase.txt`, you can add your own cases to it.

Test results (pass or filed) are saved in file `test/test_result.txt`.

### Debug
For the usage of docker image and waveform viewing, please follow this tutorial: [https://github.com/ColsonZhang/ICS/blob/master/doc/tutorial/manual-2.md](https://github.com/ColsonZhang/ICS/blob/master/doc/tutorial/manual-2.md)

## Marking
The total score (100%) is the sum of code (80%) and report writing (20%)

### Code (80%)
* Successful submission (5%) 
* Complete im2col module (10%)
* Complete PE module (10%)
* Complete systolic array
  * Fail all the tests (0%)
  * Pass N tests (25% + 1.5% * N)

Your code will be tested by the same cases in `test/testcase.txt`.

### Report (20%)
The report should be written in English and follows the [IEEE double-column template](https://www.ieee.org/conferences/publishing/templates.html). Only PDF format is acceptable.

A good report should includes following components:
* An introduction to briefly introduce the system design.
* Implementation details for each of the modules.
* A strong conclusion to assess and summarize your design.

## Bonus
Compute the total execution time of systolic array (begin with the negedge of rst and end with the last posedge of valid_D). You shoud give a equation of clock cycles based on the module parameters (M, N, K, ARR_SIZE, etc.) and explain the reason.

## Submission
Please compress all the files in your `vsrc/src` folder and the report into a `zip` file with name `{StudentNumber}_EE219_Lab2.zip`, and submit to Blackboard. The file structure should be like
```
12345678_EE219_Lab2
|-- report.pdf
|-- src
    |-- im2col.v
    |-- pe.v
    |-- systolic.v
    `-- ...
```

## Reference

[1] Yajun, Ha. EE116: FPGA-based Hardware System Design. ShanghaiTech University, 2020
