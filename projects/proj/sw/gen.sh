export AM_HOME=$(dirname $(readlink -f "$0"))/libraries/abstract-machine
export PATH="$PATH:/home/docker/workspace/2022/reference/toolchain/riscv/riscv64/bin"

FILENAME=$1
ARCH="riscv64-mycpu"
echo $FILENAME

make ARCH=$ARCH ALL=$FILENAME
