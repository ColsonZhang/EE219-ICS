# Introduction of the Compiling Script

## Usage

The `build.sh` is a verilator compilation script that greatly simplifies the compilation of vialtor. At the same time, this script can record the user's compilation history to avoid faking.

## Parameter

The parameter usage can be get by executing the following command in the directory `/home/docker/workspace/ics/`.

```bash
./build.sh -h
```

The deatiled parameter description is here.

| parameter | meaning                                                                                                                                                            |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `-e`    | `Specify a routine as the project directory, if not, the "demo" directory will be used as the project directory.`                                                |
| `-b`    | `Compile the project. After compiling, it will create subdirectory "build_test" in the project directory, which will store the files generated after compiling.` |
| `-t`    | `Specify the verilog top-level file name. If nothing specified, "top.v" will be used.`                                                                           |
| `-s`    | `Run the simulation program, i.e. "build/emu" program. And the working directory is "build_test" subdirectory when running.`                                     |
| `-a`    | `Pass in the parameters of the emulation. If there are more than one argument, use double quotes. For example: -a "1 2 3 ......"`                                |
| `-f`    | `Pass in the c++ compiler arguments, e.g. -f "-DGLOBAL_DEFINE=1 -ggdb3". Multiple arguments need to use double quotes.`                                          |
| `-l`    | `Pass c++ linker arguments, for example: -l "-ldl -lm". Multiple arguments need to use double quotes.`                                                           |
| `-g`    | `use gdb to debug the emulator.`                                                                                                                                 |
| `-c`    | `Delete the compiled "build" folder in the project directory.`                                                                                                   |
| `-v`    | `Pass parameters to verilator, e.g. -v '--timescale \ "1ns/1ns\"'`                                                                                               |
| `-h`    | `Get the help information. `                                                                                                                                     |
