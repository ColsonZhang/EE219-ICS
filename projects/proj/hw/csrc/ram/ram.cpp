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

#include "config.h"
#include "ram.h"

static uint64_t *ram;
static long img_size = 0;
static pthread_mutex_t ram_mutex;

uint64_t* get_img_start() { return &ram[0]; }
long get_img_size() { return img_size; }
uint64_t* get_ram_start() { return &ram[0]; }
long get_ram_size() { return EMU_RAM_SIZE; }

void init_memory(){
  printf("Using simulated %luMB RAM\n", EMU_RAM_SIZE / (1024 * 1024));
  ram = (uint64_t *)mmap(NULL, EMU_RAM_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
  if (ram == (uint64_t *)MAP_FAILED) {
    printf("Cound not mmap 0x%lx bytes\n", EMU_RAM_SIZE);
    assert(0);
  }
}

void load_img(uint64_t *ram_ptr, const char *img){
  assert(img != NULL);
  printf("The image is %s\n", img);

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
  ret = fread(ram_ptr, img_size, 1, fp);
  assert(ret == 1);
  fclose(fp);
}

void save_img(uint64_t *ram_ptr, uint64_t size, const char *img){
  FILE *fp = fopen(img, "wb");
  if (fp == NULL) {
    printf("Can not create '%s'\n", img);
    assert(0);
  }
  fwrite( ram_ptr, size, 1, fp );
  fclose(fp);
}

void init_mutex(){
  pthread_mutex_init(&ram_mutex, 0);
}

void init_ram(const char *img) {
  // initialize memory using Linux mmap
  init_memory();
  // read bin file
  load_img( ram, img );
  // initialize pthread_mutex
  init_mutex();
}

void ram_finish() {
  munmap(ram, EMU_RAM_SIZE);
  pthread_mutex_destroy(&ram_mutex);
}

void load_data( uint64_t addr, const char *img){
  if (addr % sizeof(uint64_t)) {
    printf("Warning: only supports 64-bit aligned memory access\n");
  }
  
  uint64_t ptr_offset ;
  addr -= 0x80000000;
  ptr_offset = addr / sizeof(uint64_t) ;

  if ( ptr_offset >= EMU_RAM_SIZE / sizeof(uint64_t)) {
    printf("ERROR: addr = 0x%lx out of bound!\n", addr);
    assert(ptr_offset < EMU_RAM_SIZE / sizeof(uint64_t));
  }

  uint64_t *ram_ptr ;
  ram_ptr = get_ram_start();
  ram_ptr = ram_ptr + ptr_offset ;

  pthread_mutex_lock(&ram_mutex);
  load_img( ram_ptr, img );
  pthread_mutex_unlock(&ram_mutex);
}

void save_data( uint64_t addr, const char *img){
  if (addr % sizeof(uint64_t)) {
    printf("Warning: only supports 64-bit aligned memory access\n");
  }

  addr -= 0x80000000;

  uint64_t ptr_offset;
  ptr_offset = addr / sizeof(uint64_t) ;
  if ( ptr_offset >= EMU_RAM_SIZE / sizeof(uint64_t)) {
    printf("ERROR: addr = 0x%lx out of bound!\n", addr);
    assert(ptr_offset < EMU_RAM_SIZE / sizeof(uint64_t));
  }

  uint64_t size;
  size = EMU_RAM_SIZE - addr ;

  uint64_t *ram_ptr ;
  ram_ptr = get_ram_start();
  ram_ptr = ram_ptr + ptr_offset ;  

  pthread_mutex_lock(&ram_mutex);
  save_img( ram_ptr, size, img );
  pthread_mutex_unlock(&ram_mutex);
}

extern "C" uint64_t ram_read_helper(uint8_t en, uint64_t rIdx) {
  if (!ram)
    return 0;
  if (en && rIdx >= EMU_RAM_SIZE / sizeof(uint64_t)) {
    rIdx %= EMU_RAM_SIZE / sizeof(uint64_t);
  }
  pthread_mutex_lock(&ram_mutex);
  uint64_t rdata = (en) ? ram[rIdx] : 0;
  pthread_mutex_unlock(&ram_mutex);
  
  return rdata;
}

extern "C" uint64_t ram_inst_helper(uint8_t en, uint64_t rIdx) {
  if (!ram)
    return 0;
  if (en && rIdx >= EMU_RAM_SIZE / sizeof(uint64_t)) {
    rIdx %= EMU_RAM_SIZE / sizeof(uint64_t);
  }
  pthread_mutex_lock(&ram_mutex);
  uint64_t rdata = (en) ? ram[rIdx] : 0;
  pthread_mutex_unlock(&ram_mutex);
  // printf("Read\t rIdx: 0x%lx \t rdata: 0x%lx \n", rIdx, rdata );
  return rdata;
}

extern "C" void ram_write_helper(uint64_t wIdx, uint64_t wdata, uint64_t wmask, uint8_t wen) {
  if (wen && ram) {
    if (wIdx >= EMU_RAM_SIZE / sizeof(uint64_t)) {
      printf("ERROR: ram wIdx = 0x%lx out of bound!\n", wIdx);
      assert(wIdx < EMU_RAM_SIZE / sizeof(uint64_t));
    }
    pthread_mutex_lock(&ram_mutex);
    ram[wIdx] = (ram[wIdx] & ~wmask) | (wdata & wmask);
    pthread_mutex_unlock(&ram_mutex);
    // printf("\033[32mWrite\033[0m\t wIdx: 0x%lx \t wdata: 0x%lx \t wmask: 0x%lx \n", wIdx, wdata, wmask);
  }
}

uint64_t pmem_read(uint64_t raddr) {
  if (raddr % sizeof(uint64_t)) {
    printf("Warning: pmem_read only supports 64-bit aligned memory access\n");
  }
  raddr -= 0x80000000;
  return ram_read_helper(1, raddr / sizeof(uint64_t));
}

void pmem_write(uint64_t waddr, uint64_t wdata) {
  if (waddr % sizeof(uint64_t)) {
    printf("Warning: pmem_write only supports 64-bit aligned memory access\n");
  }
  waddr -= 0x80000000;
  return ram_write_helper(waddr / sizeof(uint64_t), wdata, -1UL, 1);
}