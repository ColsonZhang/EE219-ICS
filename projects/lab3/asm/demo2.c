// This is a demo code showing how to convert the c-code into the assembly code
// The fuction demo2() is used to do the matrix addition ( Matrix-B + Matrix-C )
// and write the addition result into the memory ( the address of Matrix-D )

static int mem[1000] ;
int B_baseaddr = 0x00200000 ;
int C_baseaddr = 0x00300000 ;
int D_baseaddr = 0x00400000 ;

void demo2()
{

    int num_size = 8 ;

    int addr_B = B_baseaddr ;
    int addr_C = C_baseaddr ;
    int addr_D = D_baseaddr ;

    int data_B ;
    int data_C ;
    int data_D ;

    for(int index_col=0; index_col<num_size ; index_col=index_col+1 )
    {
        for(int index_row=0; index_row<num_size; index_row=index_row+1 )
        {
            data_B = mem[addr_B] ;
            data_C = mem[addr_C] ;

            data_D = data_B + data_C ;

            mem[addr_D] = data_D ;

            addr_B = addr_B + 4 ;
            addr_C = addr_C + 4 ;
            addr_D = addr_D + 4 ;
        }
    }
}
