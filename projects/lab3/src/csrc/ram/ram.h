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

#ifndef __RAM_H
#define __RAM_H

#include "config.h"

#ifndef EMU_RAM_SIZE
#define EMU_RAM_SIZE (256 * 1024 * 1024UL)
#endif

void init_ram(const char *img);
void ram_finish();
void* get_ram_start();
long get_ram_size();

void* get_img_start();
long get_img_size();

uint32_t pmem_read(uint32_t raddr);
void pmem_write(uint32_t waddr, uint32_t wdata);

#endif
