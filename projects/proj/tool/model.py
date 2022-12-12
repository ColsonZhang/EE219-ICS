import torch 
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import numpy as np

CIFAR10_PATH = "../data/cifar10"
MODLE_PATH = "../data/model/model_lab1.pth"
SAVE_PATH = "../data/bin/data.bin"

class Network(nn.Module):
    def __init__(self):
        super(Network, self).__init__()
        self.conv1 = nn.Conv2d(3, 12, 5, bias=False)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(12, 32, 3, bias=False)
        self.fc1 = nn.Linear(32 * 6 * 6, 256, bias=False)
        self.fc2 = nn.Linear(256, 64, bias=False)
        self.fc3 = nn.Linear(64, 10, bias=True)

def load_model( path ):
    model = torch.load(path)
    return model

def get_testloader():
    transform = transforms.Compose(
        [transforms.ToTensor(),
        transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])
    testset = torchvision.datasets.CIFAR10(root=CIFAR10_PATH, train=False,
                                        download=True, transform=transform)
    testloader = torch.utils.data.DataLoader(testset, batch_size=4,
                                            shuffle=False, num_workers=2)
    return testloader 

def gen_testcase(testloader, batch=1):
    cnt = 0 
    images_set = []
    labels_set = []
    for data in testloader:
        images, labels = data
        images_set.append(images)
        labels_set.append(labels)
        cnt += 1 
        if cnt>=batch:
            break 
    return images_set, labels_set

def export_bin(filename, data_bytes):
    with open(filename, "wb") as f:
        f.write(data_bytes)

if __name__=='__main__':
    model = load_model(MODLE_PATH)
    test_loader = get_testloader()
    images_set, labels_set = gen_testcase(test_loader, batch=1)
    input_img = images_set[0]

    input_scale = torch.clamp(torch.round(input_img*model.input_scale), min=-128, max=127)
    print(input_scale.shape)

    # select the data to be saved
    total_data = np.array([],dtype=np.int8)
    the_data = input_scale.data[0]
    the_data = np.array(the_data,dtype=np.int8)
    total_data = np.append(total_data, the_data)
    print(total_data.shape)


    the_bin = bytes(total_data)
    export_bin( SAVE_PATH, the_bin )