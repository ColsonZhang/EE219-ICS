# EE219-Final-Project

## Environment

> NOTE: The image for this experiment has been updated, please update the image from and create a new container before starting the project.
>
> ```bash
> docker pull zhangshen777/ics-ubuntu
> ```
>
> Or, you can also install the required packeages in the old docker image by the following commands.
>
> ```bash
> su
> sudo apt-get update -y
> sudo apt-get install -y gcc-riscv64-linux-gnu
> ```

## Introduction

This project is designed to allow you to practice what you have learned in this course. Through this project, students can actually design a valuable intelligent computing system, including model training, model quantification, hardware design, operator and algorithm development. Of course, due to time constraints, this project has been simplified to reduce the difficulty appropriately, but this does not prevent you from going more deeply into a particular direction according to your interests. Just enjoy it !

## Project Goal

The goal of this project is to design an intelligent computing system that enables computational acceleration of neural networks. This system is divided into 3 levels, neural network model, hardware platform, and application software.

1. Neural networks: In lab0 and lab1, you have learned how to train and quantize neural networks. In this project you can use the quantized model from lab1, but you need to make some modifications to improve this model.
2. Hardware platform: In lab2 you have learned the design of an accelerator as an example of a systolic-array, and in lab3 you have learned the structure of a general-purpose processor as an example of a RISC-V32IMV. Now, you need to design a custom hardware computing platform to deploy your neural network model.
3. Application software: In lab0 you learned to use the numpy library of the high-level language python to build neural networks, and in lab3 you learned to use assembly language to do MAC operations. Now you need to use c + inline assembly to build the neural network arithmetic library and complete the corresponding software on your customized computing platform to make your neural network work for real.

After you have completed these 3 aspects, the most basic requirement you need to achieve is to be able to implement the deployment of the first 3 layers of the network (conv1+relu+pooling) and ensure that the results running on hardware are consistent with the results running in python.

If you wish to do better, you can explore these directions.

1. try to change the bit width used in the quantization of the network model.
2. try to build your own processor that supports all RV64I instruction sets.
3. try to refine the arithmetic so that the application software supports the deployment of the entire neural network.

## Detailed Task

### Neural-Networks

To deploy a neural network to hardware, it is usually necessary to quantify the neural network, as was done in lab1. But the quantization in lab1 does not take into account the specific hardware. In fact, the hardware conditions can also limit the model quantization. For example, in lab1, we used a floating-point type scaling factor to adjust the range of values for the output of each layer. However, in this experiment, our hardware platform does not support floating-point operations, so we need to make some minor adjustments to the quantization strategy to convert floating-point operations to integer operations.

After you have done this part of the work, you need to export the model. You can export the model by adding the following code to the end of the ipynb file. If your variable names do not match the template here, please modify the variable mapping relationship in the function `copy_from_model`. Also, please modify the `save_filename` path according to the location of your ipynb file (the relative path given here assumes that your ipynb file is located under `/EE219-ICS/projects/lab1/`).

```python
class Network(nn.Module):
    def __init__(self):
        super(Network, self).__init__()
        self.conv1 = nn.Conv2d(3, 12, 5, bias=False)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(12, 32, 3, bias=False)
        self.fc1 = nn.Linear(32 * 6 * 6, 256, bias=False)
        self.fc2 = nn.Linear(256, 64, bias=False)
        self.fc3 = nn.Linear(64, 10, bias=True)

    def copy_from_model(self, model_old):
        self.input_scale = model_old.input_scale
        self.conv1.weight = model_old.conv1.weight
        self.conv1.output_scale = model_old.conv1.output_scale
        self.conv2.weight = model_old.conv2.weight
        self.conv2.output_scale = model_old.conv2.output_scale
        self.fc1.weight = model_old.fc1.weight
        self.fc1.output_scale = model_old.fc1.output_scale
        self.fc2.weight = model_old.fc2.weight
        self.fc2.output_scale = model_old.fc2.output_scale
        self.fc3.weight = model_old.fc3.weight
        self.fc3.bias = model_old.fc3.bias
        self.fc3.output_scale = model_old.fc3.output_scale

model_old = net_quantized_with_bias
model = Network()
model.copy_from_model(model_old)

save_filename = "../proj/data/model/model_lab1.pth"
torch.save( model, save_filename )
```

After successfully exporting the model, you still need to go and refine the code in the file `/proj/tool/model.py`. This file is mainly used to generate test cases and memory images. You need to export the parameters and input data involved in the previous 3 layers into an image for easy recall by the hardware platform. The data here can be organized in any way you want.

### Hardware-Platform

Our hardware platform uses the RISV processor architecture and supports all instructions of RV64I and some customized vector instructions. A single-cycle scalar processor core supporting RV64I has been implemented and is available for you to use directly. But considering that lab3 is not yet finished, the source code of this scalar processor core is obfuscated. And the vector processor part of the hardware platform is the focus of your design. You can embed a custom accelerator into the ALU of the vector processor, considering the large access bandwidth of the vector processor.

This project does not require too much instruction for the vector processor, you can even use the code of lab3 with simple modifications. But in order to be able to control the accelerator, you will need to add a few custom vector instructions.

As for the accelerator design, this project does not restrict the accelerator architecture, but you need to give a reasonable enough reason for the architecture. These cases are not allowed, such as using too many registers in the accelerator, using too many arithmetic units in the accelerator, etc. In short, your accelerator needs to be as efficient as possible while matching the access bandwidth to the bandwidth.

### Application-Software

Since the architecture of our intelligent computing system is processor-based, we need software to control the processor to work the way we want it to. After completing the first two parts, you need to build the operator library to support the specific computation of the neural network. Here, you can use mainly c to do this. But for the parts that involve vector instructions (including custom instructions), you need to use inline assembly to do this. For both cases, we provide sample programs.

## Score

The final specific scoring criteria will be released later.

* Report (30%)
* Code (50%)
* Competition (20%)

## Submission

Using the make command to export the git log file and pack up tha lab3 folder. You will get the compressed file `lab3.tar.gz` in `ICS/projects`.

```
make pack
```

Please compress `lab3.tar.gz` and the report into a `zip` file with the name `{StudentNumber_StudentName}_EE219_Lab3.zip`, and submit to Blackboard. The file structure should be like this.

```
12345678_张三_EE219_Lab3.zip
|-- report.pdf
|-- presentation.ppt/pdf
|-- lab3.tar.gz
```
