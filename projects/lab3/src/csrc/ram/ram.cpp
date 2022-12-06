/***************************************************************************************
* Copyright (c) 2020-2021 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* XiangShan is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <sys/mman.h>
// #include "common.h"
#include "ram.h"

static uint32_t *ram;
static long img_size = 0;
static pthread_mutex_t ram_mutex;

void*	get_img_start() { return &ram[0]; }
long 	get_img_size() 	{ return img_size; }
void* get_ram_start() { return &ram[0]; }
long 	get_ram_size() 	{ return EMU_RAM_SIZE; }

void init_ram(const char *img) {
  assert(img != NULL);

  printf("The image is %s\n", img);
  // initialize memory using Linux mmap
  printf("Using simulated %luMB RAM\n", EMU_RAM_SIZE / (1024 * 1024));
  ram = (uint32_t *)mmap(NULL, EMU_RAM_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
  if (ram == (uint32_t *)MAP_FAILED) {
    printf("Cound not mmap 0x%lx bytes\n", EMU_RAM_SIZE);
    assert(0);
  }
  
	int ret;
  FILE *fp = fopen(img, "rb");
  if (fp == NULL) {
    printf("Can not open '%s'\n", img);
    assert(0);
  }
  fseek(fp, 0, SEEK_END);
  img_size = ftell(fp);
  if (img_size > EMU_RAM_SIZE) {
    img_size = EMU_RAM_SIZE;
  }
  fseek(fp, 0, SEEK_SET);
  
  ret = fread(ram, img_size, 1, fp);
  assert(ret == 1);
  fclose(fp);

  pthread_mutex_init(&ram_mutex, 0);
}

void ram_finish() {
  munmap(ram, EMU_RAM_SIZE);
  pthread_mutex_destroy(&ram_mutex);
}

uint32_t read_interface( uint8_t en, uint32_t rIdx ) {
  if (!ram)
    return 0;
  if (en && rIdx >= EMU_RAM_SIZE / sizeof(uint32_t)) {
    rIdx %= EMU_RAM_SIZE / sizeof(uint32_t);
  }
  pthread_mutex_lock(&ram_mutex);
  uint32_t rdata = (en) ? ram[rIdx] : 0;
  pthread_mutex_unlock(&ram_mutex);
	return rdata ;
}

void write_interface(uint32_t wIdx, uint32_t wdata, uint32_t wmask, uint8_t wen) {
  if (wen && ram) {
    if (wIdx >= EMU_RAM_SIZE / sizeof(uint32_t)) {
      printf("\033[31mERROR: ram wIdx = 0x%x out of bound!\033[0m\n", wIdx);
      assert(wIdx < EMU_RAM_SIZE / sizeof(uint32_t));
    } 
    pthread_mutex_lock(&ram_mutex);
    ram[wIdx] = (ram[wIdx] & ~wmask) | (wdata & wmask);
    pthread_mutex_unlock(&ram_mutex);
  }
}

uint32_t pmem_read(uint32_t raddr) {
  if (raddr % sizeof(uint32_t)) {
    printf("Warning: pmem_read only supports 32-bit aligned memory access\n");
  }
  raddr -= 0x80000000;
	raddr = raddr / sizeof(uint32_t);
  return read_interface(1, raddr );
}

void pmem_write(uint32_t waddr, uint32_t wdata) {
  if (waddr % sizeof(uint32_t)) {
    printf("Warning: pmem_write only supports 32-bit aligned memory access\n");
  }
  waddr -= 0x80000000;
	waddr = waddr / sizeof(uint32_t) ;
  return write_interface(waddr , wdata, -1UL, 1);
}

extern "C" uint32_t ram_read_helper(uint8_t en, uint32_t rIdx) {
	rIdx -= (0x80000000 >> 2) ;
	uint32_t rdata = read_interface( en, rIdx ) ;
  return rdata;
}

extern "C" void ram_write_helper(uint32_t wIdx, uint32_t wdata, uint32_t wmask, uint8_t wen) {
	wIdx -= (0x80000000 >> 2);
	write_interface( wIdx, wdata, wmask, wen );
}

