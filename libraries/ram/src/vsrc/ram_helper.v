import "DPI-C" function void ram_write_helper
(
  input  longint    wIdx,
  input  longint    wdata,
  input  longint    wmask,
  input  bit        wen
);

import "DPI-C" function longint ram_read_helper
(
  input  bit        en,
  input  longint    rIdx
);