source /home/docker/miniconda3/bin/activate

# conda create -n torch python=3.8.8

conda activate torch

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple jupyterlab numpy==1.21.2 matplotlib==3.4.3 --no-cache-dir

conda install pytorch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1 cpuonly -c pytorch

conda clean -f

rm -rf /home/docker/.cache/pip