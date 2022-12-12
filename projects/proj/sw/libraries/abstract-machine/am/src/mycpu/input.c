#include <am.h>
#include <klib.h>

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  static int count = 0 ;
  // kbd->keydown = 0;
  // kbd->keycode = AM_KEY_NONE;
  // printf("Input Warning !\n");

  if(count < 1000){
    count++;
    kbd->keydown = 1 ;
    kbd->keycode = 36 ;
    // printf("keycode:\t 36\n");
  }
  else{
    kbd->keydown = 0;
    kbd->keycode = AM_KEY_NONE;
    // printf("keycode:\t 0\n");
  }

}
