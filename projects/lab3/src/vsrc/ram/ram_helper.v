import "DPI-C" function void ram_write_helper
(
  input  int    wIdx,
  input  int    wdata,
  input  int    wmask,
  input  bit    wen
);

import "DPI-C" function int ram_read_helper
(
  input  bit    en,
  input  int    rIdx
);