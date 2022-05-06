**Systolic Array Example Introduced in the Lecture Slides**
 
There are three verilog file: `PE.v` is a single MAC unit with control signals; `PE_array.v` is a 2D systolic array consisting of the MAC units; `PE_array_tb.v` is a testbench for `PE_array.v`, computing 

<p align="center">
<img src="https://latex.codecogs.com/svg.image?\begin{matrix}1&space;&&space;2&space;&&space;3&space;\\&space;4&space;&&space;5&space;&&space;6&space;\\7&space;&&space;8&space;&&space;9\end{matrix}" title="https://latex.codecogs.com/svg.image?\begin{matrix}1 & 2 & 3 \\ 4 & 5 & 6 \\7 & 8 & 9\end{matrix}" width="7%"/>
</p>
<p align = "center">
</p>

To run the testbench, use the command line either in the experiment environment or on your local computer (with iverilog installed), `cd` to the folder containing the verilog code and type in the following commands
```
iverilog -o PE_array_test PE_array_tb.v PE_array.v PE.v
vvp PE_array_test
```
After this, the simulation results are printed, but they are in hexadecimal, so do not reveal the real values, especially the output results are concatenated as one `reg` signal. To verify the results, the waveform file is also generated as `PE_array_tb.vcd`. View it using either **WaveTrace** or **gtkwave**.

The signal `W` represents the weights and they are concatenated as one signal (010203040506)<sub>16</sub>; the input signals are re-arranged as shown in the below figure

<p align="center">
  <img src ="img/PE_array.png"  width="45%"/>
</p>
<p align = "center">
  <i>Systolic Array</i>
</p>

So the input signal `X` are (010000)<sub>16</sub>, (040200)<sub>16</sub>, (070503)<sub>16</sub>, (000806)<sub>16</sub>, (000009)<sub>16</sub> repectively for each clock cycle. The output result should be 

<p align="center">
  <img src ="http://latex.codecogs.com/svg.latex?%5Cbegin%7Bpmatrix%7D%0D%0A22%2628%5C%5C%0D%0A49%2664%5C%5C%0D%0A76%26100%5C%5C%0D%0A%5Cend%7Bpmatrix%7D"  width="8%"/>
</p>
<p align = "center">
</p>
corresponds to (00000016)<sub>16</sub>, (0000001C)<sub>16</sub>, (00000031)<sub>16</sub>, (00000040)<sub>16</sub>, (0000004C)<sub>16</sub>, (00000064)<sub>16</sub> in signal `Y`.

For the detailed computing procedure, please refer to the lecture slides.

**Reference**

[1] N. P. Jouppi et al., "In-datacenter performance analysis of a tensor processing unit," 2017 ACM/IEEE 44th Annual International Symposium on Computer Architecture (ISCA), 2017, pp. 1-12.
