
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

#define BASEADDR 			0x80000000

#define inst_baseaddr		0x80000000
#define dataA_baseaddr		0x80100000
#define dataAT_baseaddr 	0x80200000
#define dataB_baseaddr 		0x80300000
#define dataBT_baseaddr 	0x80400000
#define dataC_baseaddr 		0x80500000
#define dataCT_baseaddr 	0x80600000
#define dataD_baseaddr 		0x80700000
#define dataDT_baseaddr		0x80800000
#define task1_baseaddr 		0x80900000
#define task3_baseaddr 		0x80a00000

static Vtop* top;
static VerilatedVcdC* tfp;
static vluint64_t main_time = 0;
static const vluint64_t sim_time = 100000;

static uint32_t data_baseaddr[6] = {dataA_baseaddr, dataAT_baseaddr, dataB_baseaddr, dataBT_baseaddr, dataC_baseaddr, dataCT_baseaddr} ;

const uint32_t MATRIX_ROW = 8 ;
const uint32_t MATRIX_COL = 8 ;
const uint32_t MATRIX_NUM = 6 ;

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
	uint32_t the_addr ;
	uint32_t the_data ;

	uint32_t ***data ;
	data = readtxt(img);

	for(uint32_t i=0; i<MATRIX_NUM; i++){
		the_addr = data_baseaddr[i] ;
		for(uint32_t j=0; j<MATRIX_ROW; j++){
			for(uint32_t k=0; k<MATRIX_COL; k++){
				the_data = data[i][j][k] ;
				pmem_write( the_addr, the_data );
				the_addr = the_addr + 1*sizeof(uint32_t) ;
			}
		}
	}
}

void dump_data( uint32_t baseaddr, uint32_t length, const char *savepath ){
	uint32_t the_addr ;
	uint32_t the_data ;

	uint32_t *result ;
	result = new uint32_t [length];

	the_addr = baseaddr ;
	for(uint32_t j=0; j<length; j++ ){
		the_data = pmem_read( the_addr );
		result[j] = the_data ;
		the_addr = the_addr + 1*sizeof(uint32_t) ;	
	}

	ofstream outfile;
	outfile.open(savepath, ios::out|ios::trunc);
	if(!outfile){ printf("Open file fail!\n"); }

	uint32_t count = 0 ;
	for(uint32_t j=0; j<length; j++ ){
		outfile << setiosflags(ios::left)<<setw(10) << (int32_t)(result[j]) << + "\t" ;
		count += 1 ;
		if (count % 8 == 0) {
			outfile << "\n" ;
		}
	}
	outfile.close();
}

void dump_ram(uint32_t baseaddr, const char *savepath, bool transpose){
	uint32_t the_addr ;
	uint32_t data_read ;
	uint32_t the_data ;

	uint32_t **result ;
	result = new uint32_t *[MATRIX_ROW];
	for(uint32_t i=0; i<MATRIX_ROW; i++){
		result[i] = new uint32_t [MATRIX_COL];
	}

	the_addr = baseaddr ;
	for(uint32_t i=0; i<MATRIX_ROW; i++ ){
		for(uint32_t j=0; j<MATRIX_COL; j++ ){
			the_data = pmem_read( the_addr );
			result[i][j] = the_data ;
			the_addr = the_addr + 1*sizeof(uint32_t) ;	
		}
	}

	ofstream outfile;
	outfile.open(savepath, ios::out|ios::trunc);

	if(!outfile){ printf("Open file fail!\n"); }

	for(uint32_t i=0; i<MATRIX_ROW; i++ ){
		for(uint32_t j=0; j<MATRIX_COL; j++ ){
			outfile << setiosflags(ios::left)<<setw(10) << (int32_t)(result[i][j]) << + "\t" ;
		}
		outfile << endl ;
	}
	outfile.close();
}


int main(int argc, char **argv)
{

	char default_instpath[] = "../../bin/demo.bin" ;
	char default_imgpath[] = "../../data/ramdata.txt" ;
	char default_savepath[] = "../../data/dumpdata_D.txt" ;
	char default_savepath2[] = "../../data/dumpdata_DT.txt" ;
	char default_savepath3[] = "../../data/dumpdata_task1.txt" ;
	char default_savepath4[] = "../../data/dumpdata_task3.txt" ;

	char *instpath ;
	char *imgpath ;
	char *savepath ;
	char *savepath2 ;
	char *savepath3 ;
	char *savepath4 ;

	if (argc != 7){
		printf("ERROR: wrong number of arguments\n");
		instpath = default_instpath ;
		imgpath = default_imgpath ;
		savepath = default_savepath ;
		savepath2 = default_savepath2 ;
		savepath3 = default_savepath3 ;
		savepath4 = default_savepath4 ;
	}else{
		instpath = argv[1] ;
		imgpath = argv[2] ;
		savepath = argv[3] ;
		savepath2 = argv[4] ;
		savepath3 = argv[5] ;
		savepath4 = argv[6] ;
	}

	printf("Using Instruction File Path: %s\n",instpath);
	printf("Using Ram Image File Path: %s\n",imgpath);
	printf("Using Saving File Path: %s\n",savepath);
	printf("Using Saving File Path: %s\n",savepath2);
	printf("Using Saving File Path: %s\n",savepath3);
	printf("Using Saving File Path: %s\n",savepath4);
	
	uint64_t data_read ;

    init_ram(instpath);
	printf("\033[32mInitial Instruction RAM done !!!\033[0m\n");

	load_ram(imgpath) ;
	printf("\033[32mInitial Image RAM done !!!\033[0m\n");

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

	dump_data( task1_baseaddr, 16, savepath3 );
	dump_data( task3_baseaddr, 16*8, savepath4 );
	dump_ram( dataD_baseaddr, savepath, false );
	dump_ram( dataDT_baseaddr, savepath2, true );

	delete top;
	delete tfp;
	exit(0);
	return 0;
}
