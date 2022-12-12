#include "trap.h"

#define ADDR_A      0x80800000
#define ADDR_B      0x80800000 + 1152
#define STEP_B      1152
#define ADDR_C      0x80850000

int main() {
    int i,j ;
    int8_t *p_A = (int8_t *)ADDR_A ;
    int8_t *p_B = (int8_t *)ADDR_B ;
    int32_t *p_C = (int32_t *)ADDR_C ;

    // access-data
    for (i=0; i<16; i++) {
        int8_t data = p_A[i];
        printf("%d\t",data);
    }
    printf("\n");

    for (i=0; i<16; i++) {
        int8_t data = *(p_B+i*STEP_B);
        printf("%d\t",data);
    }
    printf("\n");

    int8_t data_A, data_B;
    int32_t data_C ;
    for( i=0; i<256; i++ ){
        data_C = 0 ;
        for( j=0; j<1152; j++ ){
            data_A = p_A[j];
            data_B = p_B[i*STEP_B+j];
            data_C +=  data_A * data_B ;
        }
        p_C[i] = data_C ;
    }

    for (i=0; i<16; i++) {
        int32_t data = *(p_C+i);
        printf("%d\t",data);
    }

    return 0;
}
