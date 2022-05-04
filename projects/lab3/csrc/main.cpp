
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

static Vtop* top;
static VerilatedVcdC* tfp;
static vluint64_t main_time = 0;
static const vluint64_t sim_time = 100000;

static uint64_t inst_baseaddr  = 0x80000000 ;

static uint64_t dataA_baseaddr = 0x80100000 ;
static uint64_t dataB_baseaddr = 0x80200000 ;
static uint64_t dataC_baseaddr = 0x80300000 ;
static uint64_t data_baseaddr[3] = {0x80100000, 0x80200000, 0x80300000} ;
static uint64_t dataD_baseaddr = 0x80400000 ;

const uint32_t MATRIX_ROW = 8 ;
const uint32_t MATRIX_COL = 8 ;
const uint32_t MATRIX_NUM = 3 ;

uint32_t ***readtxt(const char *img){

	// initial the 3-D array
    uint32_t ***data ;
    data = new uint32_t **[MATRIX_NUM] ;
    for(uint32_t i=0; i<MATRIX_NUM; i++){
        data[i] = new uint32_t *[MATRIX_ROW];
    }
    for(uint32_t i=0; i<MATRIX_NUM; i++){
        for(uint32_t j=0; j<MATRIX_ROW; j++){
            data[i][j] = new uint32_t [MATRIX_COL] ;
        }
    }

	// read ram-file
    ifstream infile;
    infile.open(img);
    if(!infile) {
        printf("Read file fail!\n");
    }
    for(uint32_t i=0; i<MATRIX_NUM; i++){
        for(uint32_t j=0; j<MATRIX_ROW; j++){
            for(uint32_t k=0; k<MATRIX_COL; k++){
                infile >> data[i][j][k];
            }
        }
    }
    infile.close();

    return data ;
}

void load_ram(const char *img){
	uint64_t the_addr ;
	uint64_t the_data ;
	uint64_t tmp_data ;

	uint32_t ***data ;
	data = readtxt(img);

	for(uint64_t i=0; i<MATRIX_NUM; i++){
		the_addr = data_baseaddr[i] ;
		the_data = 0 ;
		for(uint64_t j=0; j<MATRIX_ROW; j++){
			for(uint64_t k=0; k<MATRIX_COL; k++){
				if(k%2 != 0){
					tmp_data = data[i][j][k] ;
					the_data = ( tmp_data << 32 ) + the_data ;
					pmem_write( the_addr, the_data );
					the_addr = the_addr + 1*sizeof(uint64_t) ;
				}
				else{
					the_data = data[i][j][k]  ;
				}
			}
		}
	}
}

void show_ram(uint64_t baseaddr , char type){
	uint64_t the_addr ;
	uint64_t data_read ;
	uint32_t the_data ;

	the_addr = baseaddr ;
	printf("-----------------------------\n");
	printf("The Matrix in the ram:\n");
	printf("-----------------------------\n");
	for(uint64_t i=0; i<MATRIX_ROW; i++ ){
		for(uint64_t j=0; j<MATRIX_COL; j++ ){
			if(j%2 != 0) {
				data_read = pmem_read( the_addr );

				the_data = data_read ;
				if(type == 'd') {
					printf("%10d\t", the_data);
				}
				else if(type == 'x'){
					printf("%10x\t", the_data);
				}
				

				the_data = data_read>>32;
				if(type == 'd') {
					printf("%10d\t", the_data);
				}
				else if(type == 'x'){
					printf("%10x\t", the_data);
				}

				the_addr = the_addr + 1*sizeof(uint64_t) ;	
			}
		}
		printf("\n");
	}
}

void dump_ram(const char *savepath){
	uint64_t the_addr ;
	uint64_t data_read ;
	uint32_t the_data ;

	uint32_t **result ;
	result = new uint32_t *[MATRIX_ROW];
	for(uint32_t i=0; i<MATRIX_ROW; i++){
		result[i] = new uint32_t [MATRIX_COL];
	}

	the_addr = dataD_baseaddr ;
	printf("-----------------------------\n");
	printf("The Matrix-D in the ram:\n");
	printf("-----------------------------\n");
	for(uint64_t i=0; i<MATRIX_ROW; i++ ){
		for(uint64_t j=0; j<MATRIX_COL; j++ ){
			if(j%2 != 0) {
				data_read = pmem_read( the_addr );

				the_data = data_read & 0xffffffff ;
				result[i][j-1] = the_data;
				printf("%d\t", the_data);

				the_data = (data_read>>32) & 0xffffffff ;
				result[i][j] = the_data ;
				printf("%d\t", the_data);

				the_addr = the_addr + 1*sizeof(uint64_t) ;	
			}
		}
		printf("\n");
	}

	ofstream outfile;
	outfile.open(savepath, ios::out|ios::trunc);

	if(!outfile){
		printf("Open file fail!\n");
	}

	for(uint64_t i=0; i<MATRIX_ROW; i++ ){
		for(uint64_t j=0; j<MATRIX_COL; j++ ){

			outfile << setiosflags(ios::left)<<setw(10) << (int32_t)(result[i][j]) << + "\t" ;
		}
		outfile << endl ;
	}
	outfile.close();
}


int main(int argc, char **argv)
{

	char default_instpath[] = "../bin/demo.bin" ;
	char default_imgpath[] = "../data/ramdata.txt" ;
	char default_savepath[] = "../data/dumpdata.txt" ;

	char *instpath ;
	char *imgpath ;
	char *savepath ;

	if (argc != 4){
		printf("ERROR: wrong number of arguments\n");
		instpath = default_instpath ;
		imgpath = default_imgpath ;
		savepath = default_savepath ;
	}else{
		instpath = argv[1] ;
		imgpath = argv[2] ;
		savepath = argv[3] ;
	}

	printf("Using Instruction File Path: %s\n",instpath);
	printf("Using Ram Image File Path: %s\n",imgpath);
	printf("Using Saving File Path: %s\n",savepath);
	
	uint64_t data_read ;

    init_ram(instpath);

	load_ram(imgpath) ;

  	// initialization
  	// Verilated::commandArgs(argc, argv);
  	Verilated::traceEverOn(true);

	top = new Vtop;
  	tfp = new VerilatedVcdC;

  	top->trace(tfp, 0);
  	tfp->open("top.vcd");
	
	while( !Verilated::gotFinish() && main_time < sim_time )
	{
		if( main_time % 10 == 0 ) top->clk = 0;
		if( main_time % 10 == 5 ) top->clk = 1;
			
		if( main_time < 10 )
		{
			top->rst = 1;
		}
		else
		{
			top->rst = 0;
		}
		top->eval();
		tfp->dump(main_time);
		main_time++;
	}
	
	// clean
	tfp->close();

	// show_ram(dataA_baseaddr, 'd');
	// show_ram(dataB_baseaddr, 'd');
	// show_ram(dataC_baseaddr, 'd');
	dump_ram(savepath);

	delete top;
	delete tfp;
	exit(0);
	return 0;
}
