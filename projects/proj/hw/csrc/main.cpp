
//rvcpu-test.cpp
#include <verilated.h>          
#include <verilated_vcd_c.h>    
#include <iostream>
#include <fstream>
#include <typeinfo>
#include <iomanip>

#include "ram.h"
#include "Vtop.h"

using namespace std;

#define DUMP_WAVE_ENABLE
#define SAVE_DATA_ENABLE

#define ADDR_BASE		0x80000000
#define ADDR_INST		0x80000000
#define ADDR_DATA		0x80800000

static Vtop* top;
static VerilatedVcdC* tfp;
static vluint64_t main_time = 0;
static const vluint64_t sim_time = 100000000;

int main(int argc, char **argv)
{
	char default_path_inst[] = "../../data/bin/hello-str-riscv64-mycpu.bin" ;
	char default_path_data[] = "../../data/bin/fc1.bin" ;
	char default_path_save[] = "./save.dat";

	char *path_inst ;
	if (argc != 2){
		printf("\033[31mERROR: No binary file\033[0m\n");
		path_inst = default_path_inst ;
	}else{
		path_inst = argv[1] ;
	}
	printf("Initialing RAM ...\n");
    init_ram(path_inst);
	printf("\033[32mInitial RAM done !!!\033[0m\n");

	printf("Initialing Data ...\n");
	load_data(ADDR_DATA, default_path_data );
	printf("\033[32mLoad Data done !!!\033[0m\n");

  	// Verilated::commandArgs(argc, argv);
	top = new Vtop;

#ifdef DUMP_WAVE_ENABLE
	Verilated::traceEverOn(true);
  	tfp = new VerilatedVcdC;
	top->trace(tfp, 0);
  	tfp->open("top.vcd");
#endif

	printf("\033[34mThe program is running now......\033[0m\n");
	printf("----------------------------------------------------------\n");
	while( !Verilated::gotFinish() && main_time < sim_time ){
		if( main_time % 10 == 0 ) top->clock = 0;
		if( main_time % 10 == 5 ) top->clock = 1;
		if( main_time < 10 ) {
			top->reset = 1;
		} else {
			top->reset = 0;
		}
		top->eval();
	#ifdef DUMP_WAVE_ENABLE
		tfp->dump(main_time);
	#endif 
		main_time++;
	}
	printf("----------------------------------------------------------\n");
	printf("\033[34mThe program finished after \033[35m%ld\033[34m cycles.\033[0m \n", main_time/10);

#ifdef SAVE_DATA_ENABLE
	save_data( ADDR_DATA, default_path_save);
#endif

#ifdef DUMP_WAVE_ENABLE
	tfp->close();
	delete tfp;
#endif 
	delete top;
	ram_finish();
	exit(0);
	return 0;
}
