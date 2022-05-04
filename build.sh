#!/bin/bash

VERSION="1.00"

COPYRIGHT="Shanghai Technology University\nIntelligent Computing System"

help() {
    echo -e $COPYRIGHT
    echo "Version v"$VERSION
    echo "Usage:"
    echo "build.sh [-e project_name] [-b] [-t top_file] [-s] [-a parameters_list] [-f] [-l] [-g] [-c] [-m] [-v parameters_list] "
    echo "Description:"
    echo "-e: Specify a example project. For example: -e counter. If not specified, the default directory \"cpu\" will be used."
    echo "-b: Build project using verilator and make tools automatically. It will generate the \"build\"(difftest) or \"build_test\" subfolder under the project directory."
    echo "-t: Specify a file as verilog top file. If not specified, the default filename \"top.v\" will be used. This option is invalid when connected difftest."
    echo "-s: Run simulation program. Use the \"build_test\" or \"build\"(difftest) folder as work path."
    echo "-a: Parameters passed to the simulation program. For example: -a \"1 2 3 ......\". Multiple parameters require double quotes."
    echo "-f: C++ compiler arguments for makefile. For example: -f \"-DGLOBAL_DEFINE=1 -ggdb3\". Multiple parameters require double quotes. This option is invalid when connected difftest."
    echo "-l: C++ linker arguments for makefile. For example: -l \"-LDFLAGS -lz -ldl -lm\". Multiple parameters require double quotes. This option is invalid when connected difftest."
    echo "-g: Debug the simulation program with GDB. This option is invalid when connected difftest."
    echo "-c: Delete \"build\" and \"build_test\" folders under the project directory."
    echo "-v: Parameters passed to verilator. For example: -v '--timescale \"1ns/1ns\"'"
    exit 0
}

build_proj() {
    cd $PROJECT_PATH

    # get all .cpp files
    CSRC_LIST=`find -L $PROJECT_PATH/$CSRC_FOLDER $RAM_PATH/src/$CSRC_FOLDER -name "*.cpp"`
    for CSRC_FILE in ${CSRC_LIST[@]}
    do
        CSRC_FILES="$CSRC_FILES $CSRC_FILE"
    done
    # get all vsrc subfolders
    VSRC_SUB_FOLDER=`find -L $VSRC_FOLDER $RAM_PATH/src/$VSRC_FOLDER -type d`
    for SUBFOLDER in ${VSRC_SUB_FOLDER[@]}
    do
        INCLUDE_VSRC_FOLDERS="$INCLUDE_VSRC_FOLDERS -I$SUBFOLDER"
    done
    # get all csrc subfolders
    CSRC_SUB_FOLDER=`find -L $PROJECT_PATH/$CSRC_FOLDER $RAM_PATH/src/$CSRC_FOLDER -type d`
    for SUBFOLDER in ${CSRC_SUB_FOLDER[@]}
    do
        INCLUDE_CSRC_FOLDERS="$INCLUDE_CSRC_FOLDERS -I$SUBFOLDER"
    done

    # compile
    mkdir $BUILD_FOLDER 1>/dev/null 2>&1
    eval "verilator --x-assign unique --cc --exe --trace --assert -O3  -Wno-TIMESCALEMOD $VERILATORFLAGS -CFLAGS \"-std=c++11 -Wall $INCLUDE_CSRC_FOLDERS $CFLAGS\" -LDFLAGS $LDFLAGS -o $PROJECT_PATH/$BUILD_FOLDER/$EMU_FILE \
        -Mdir $PROJECT_PATH/$BUILD_FOLDER/emu-compile $INCLUDE_VSRC_FOLDERS --build $V_TOP_FILE $CSRC_FILES"
    if [ $? -ne 0 ]; then
        echo "Failed to run verilator!!!"
        exit 1
    fi

    cd $ICS_PATH
}

create_soft_link() {
    mkdir ${1} 1>/dev/null 2>&1
    find -L ${1} -type l -delete
    FILES=`eval "find ${2} -mindepth 1 -maxdepth 1 -name ${3}"`
    for FILE in ${FILES[@]}
    do
        eval "ln -s \"`realpath --relative-to="${1}" "$FILE"`\" \"${1}/${FILE##*/}\" 1>/dev/null 2>&1"
    done
}

# automatically get current path
ICS_PATH=$(dirname $(readlink -f "$0"))
# user-infomation
MYINFO_FILE=$ICS_PATH"/myinfo.txt"

EMU_FILE="emu"
V_TOP_FILE="top.v"

BUILD_FOLDER="build_test"
PROJECT_FOLDER="demo"
VSRC_FOLDER="vsrc"
CSRC_FOLDER="csrc"
BIN_FOLDER="bin"

BUILD="false"
SIMULATE="false"
PARAMETERS=
CFLAGS=
LDFLAGS="-lz"
GDB="false"
CLEAN="false"

LIBRARIES_FOLDER="libraries"
RAM_FOLDER="ram"
RAM_PATH=$ICS_PATH/$LIBRARIES_FOLDER/$RAM_FOLDER

VERILATORFLAGS=

while getopts 'he:t:bsa:f:l:gcv:' OPT; do
    case $OPT in
        h)  help;;
        e)  PROJECT_FOLDER="$OPTARG";;
        t)  V_TOP_FILE="$OPTARG";;
        b)  BUILD="true";;
        s)  SIMULATE="true";;
        a)  PARAMETERS="$OPTARG";;
        f)  CFLAGS="$OPTARG";;
        l)  LDFLAGS="$OPTARG";;
        g)  GDB="true";;
        c)  CLEAN="true";;
        v)  VERILATORFLAGS="$OPTARG";;
        ?)  help;;
    esac
done

PROJECT_PATH=$ICS_PATH/projects/$PROJECT_FOLDER
BUILD_PATH=$PROJECT_PATH/$BUILD_FOLDER
BIN_PATH=$ICS_PATH/$PROJECT_FOLDER/$BIN_FOLDER

# Get id and name
ID=`sed '/^ID=/!d;s/.*=//' $MYINFO_FILE`
NAME=`sed '/^Name=/!d;s/.*=//' $MYINFO_FILE`
if [[ ${#ID} -le 1 ]] || [[ ${#NAME} -le 1 ]]; then
    echo "Please fill your information in myinfo.txt first !!!"
    exit 1
fi
ID="${ID##*\r}"
NAME="${NAME##*\r}"


# Build
if [[ "$BUILD" == "true" ]]; then
    # clean build path
    [[ -d $BUILD_PATH ]] && find $BUILD_PATH -type l -delete
    
    # build the project
    build_proj

    # git commit
    if [[ ! -f $ICS_PATH/.no_commit ]]; then
        git add . -A --ignore-errors
        (echo $NAME && echo $ID && hostnamectl && uptime) | git commit -F - -q --author='ICS-ShanghaiTech <tracer@ics>' --no-verify --allow-empty 1>/dev/null 2>&1
        sync
    fi
fi

# Simulate
if [[ "$SIMULATE" == "true" ]]; then

    cd $BUILD_PATH
    
    # run simulation program
    echo "Simulating..."
    [[ "$GDB" == "true" ]] && gdb -s $EMU_FILE --args ./$EMU_FILE $PARAMETERS || ./$EMU_FILE $PARAMETERS

    if [ $? -ne 0 ]; then
        echo "Failed to simulate!!!"
        FAILED="true"
    fi

    cd $ICS_PATH
fi

# Clean
if [[ "$CLEAN" == "true" ]]; then
    rm -rf $PROJECT_PATH/$BUILD_FOLDER
    # unlink $PROJECT_PATH/$BUILD_FOLDER 1>/dev/null 2>&1
    exit 0
fi
