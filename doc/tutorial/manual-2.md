# Instructions for the usage

## Start the Container

### Pull the image

After the docker installation is complete, restart your computer.

Open a terminal and enter the following command to pull the course image from dockerhub.

```bash
docker pull zhangshen777/ics-ubuntu
```

In ubuntu, if you have got the problem "permission denied", you can try to pull it with administrator privileges.

```bash
sudo docker pull zhangshen777/ics-ubuntu
```

### Basic Usage

In the terminal, enter the following command to start a container with the course image.

```bash
docker run -it -p 5001:22 zhangshen777/ics-ubuntu /bin/bash
```

If you fail to start the container, check whether you have pulled the image successfully using this command.

```
docker images -a
```

The image repository should include "zhangshen777/ics-ubuntu", like the following picture.

<div align=center>
<img src="../pictures/04-dockerimage.png" width="80%">
</div>

If the container is started successfully, it will enter the container's bash smoothly, as shown in the following image.

<div align=center>
<img src="../pictures/05-dockerbash.png" width="80%">
</div>

By enter `exit`, you can exit the bash and meanwhile the container will be shut down by the docker.

<div align=center>
<img src="../pictures/06-dockerexit.png" width="80%">
</div>

If you want to start the container again, you should check the container's ID firstly. The numbers in the red square is just your container's ID.

```
docker ps -a
```

<div align=center>
<img src="../pictures/07-dockerid.png" width="80%">
</div>

Then, you can start your container with this command.

<div><b>
<font color=red> Note!!! The ID in the command is different for everyone, and you must replace the ID with your own ID. </font>
</b></div>

```bash
docker satrt a85e338feb2c
```

After starting the container in this way, it will not automatically go to the terminal of ubuntu. If needed, we need to start the terminal manually.

```bash
docker exec -it a85e338feb2c /bin/bash
```

<div align=center>
<img src="../pictures/08-dockerstart.png" width="80%">
</div>

If you want to close the container , you can use the following command to close it.

```bash
docker stop a85e338feb2c
```

<div align=center>
<img src="../pictures/09-dockerstop.png" width="70%">
</div>

## Connect to the Container

Start the container.

```bash
docker satrt a85e338feb2c
```

Connect to the linux server with VS-Code via SSH.

<div align=center>
<img src="../pictures/10-vscode1.png" width="60%">
</div>

Input the ssh address in the pop-up window. The "123456" in the command is the password for user "docker".

```bash
ssh://docker:123456@localhost:5001
```

<div align=center>
<img src="../pictures/11-vscode2.png" width="70%">
</div>

Once the configuration is complete, click on the location in the image below to connect the container.

<div align=center>
<img src="../pictures/12-vscode3.png" width="60%">
</div>

When you click on it, a new window will usually pop up and you will need to enter your password. Enter password "123456" to get authorization. After that, click on "Open Folder" and select the path, "/home/docker/workspace".

<div align=center>
<img src="../pictures/13-vscode4.png" width="60%">
</div>

## Necessary Setup

### Get The Repository

The existing repository `ics` is the old repository and you need to get the newest repository.

You can execute the below command in `~/workspace/` to get the newest repository.

```bash
cd ~/workspace
git clone https://github.com/ColsonZhang/EE219-ICS.git
```

> Note: The repository used in the tutorial is `ics` but you can use `EE219-ICS` to follow the steps.

### Config Git

After the connection to the container, open the terminal of the container in VS-Code.

<div align=center>
<img src="../pictures/14-verilator1.png" width="70%">
</div>

In the terminal, config the git like the following command.

```bash
# config the user name with your real name
git config --global user.name "2021xxxxx-ZhangSan"
# config the user email with your real email
git config --global user.email "ZhangSan@ics.com"
```

### Fill your information

After the connection to the container, you can view the files in the container.

First of all, you should fill your information in `/home/docker/workspace/ics/myinfo.txt`

Note!!! If you did not fill the information, you could not be able to use the environment.

## Verilator Demo

Open a new terminal and input the following commands. Note: When executing the second command, the terminal will ask you to input the test cycles and you can randomly input a number.

```bash
cd ics
./build.sh -e demo -b -s
```

<div align=center>
<img src="../pictures/15-verilator2.png" width="90%">
</div>

After that, there will be a new folder, `build_test` in the dir `/home/docker/workspace/ics/projects/demo`. There are some intermidate simulation files and the final vcd waveform file. With the help of `wavetrace`, we can directly view the vcd waveform in VS-Code.

<div align=center>
<img src="../pictures/16-verilator3.png" width="90%">
</div>

You can also download the vcd waveform file and view the waveform in you local desktop using `gtkwave`.

<div align=center>
<img src="../pictures/17-verilator4.png" width="90%">
</div>

## Pytorch Test

The `miniconda3` has been installed in the iamge and the `pytorch` has been set up. By executing the following command in the terminal, you can activate the specific python environment.

```bash
conda activate torch
```

Usually we develop the python code in jupyter. The jupyter has also been set up in the container. And there are two methods that you can use to start your work in jupyter.

### Method 1

With the jupyter extension for VS-Code which has been installed, you can directly open the `ipynb` files in VS-Code and edit them. When you open one `ipynb` file, you can sellect the python version in the top right corner. Then after selecting the `torch`, the VS-Code will start the jupyter server thread.

<div align=center>
<img src="../pictures/18-pytorch1.png" width="90%">
</div>

### Method 2

Another methond is to use the website browser. This method requires the help of the extension for VS-Code, `ssh-extension`. With the forwarded ports via ssh, we can use local desktop to view and edit the website page in the contianer.

Open a new terminal of the container, start the `jupyter lab` or `jupyter notebook`.

```bash
# activate torch
conda activate torch

# enter the directory
cd /home/docker/workspace/ics/projects/torch

# start the jupyter-lab server
jupyter lab

# If you prefer to use notebook, start the jupyter-notebook server
# jupyter notebook
```

Then in your local destop, open the website browser and visit the URL, `http://127.0.0.1:8888/lab`.

<div align=center>
<img src="../pictures/19-pytorch2.png" width="90%">
</div>

Then, you can see this page of jupyter-lab.

NOTE!!! If the password authentication screen pops up when you visit the website, you can enter the password `123456` for authentication.

<div align=center>
<img src="../pictures/20-pytorch3.png" width="90%">
</div>

After the usage of jupyter-lab or jupyter-notebook, you can enter `ctrl+c` to end the jupyter server.

<div align=center>
<img src="../pictures/21-pytorch4.png" width="90%">
</div>
