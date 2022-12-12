#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int printf_s(const char *format, ...) {
  panic("Not implemented");
}

int vsprintf_s(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf_s(char *out, const char *fmt, ...) {
  panic("Not implemented");
}

int snprintf_s(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf_s(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}





// int printf(const char *format, ...) {

//     va_list ap;  
//     va_start(ap,format);     //将ap指向第一个实际参数的地址
//     while(*format)  
//     {  
//         if(*format != '%')  
//         {  
//             putch(*format);  
//             format++;  
//         }  
//         else  
//         {  
//             format++;  
//             switch(*format)  
//             {  
//                 case 'c':  
//                 {  
//                     char valch = va_arg(ap,int);  //记录当前实践参数所在地址
//                     printch(valch);  
//                     format++;  
//                     break;  
//                 }  
//                 case 'd':  
//                 {  
//                     int valint = va_arg(ap,int);  
//                     printint(valint);  
//                     format++;  
//                     break;  
//                 }  
//                 case 's':  
//                 {  
//                     char *valstr = va_arg(ap,char *);  
//                     printstr(valstr);  
//                     format++;  
//                     break;  
//                 }  
//                 case 'f':  
//                 {  
//                     float valflt = va_arg(ap,double);  
//                     printfloat(valflt);  
//                     format++;  
//                     break;  
//                 }  
//                 default:  
//                 {  
//                     printch(*format);  
//                     format++;  
//                 }  
//             }    
//         }  
//     }
//     va_end(ap);

//     return 1 ;
// }

// void printch(const char ch)   //输出字符
// {  
//     putch(ch);  
// }  
 
 
// void printint(const int dec)     //输出整型数
// {  
//     if(dec == 0)  
//     {  
//         return;  
//     }  
//     printint(dec / 10);  
//     putch((char)(dec % 10 + '0'));  
// }  
 
 
// void printstr(const char *ptr)        //输出字符串
// {  
//     while(*ptr)  
//     {  
//         putch(*ptr);  
//         ptr++;  
//     }  
// }  
 
 
// void printfloat(const float flt)     //输出浮点数，小数点第5位四舍五入
// {  
//     int tmpint = (int)flt;  
//     int tmpflt = (int)(100000 * (flt - tmpint));  
//     if(tmpflt % 10 >= 5)  
//     {  
//         tmpflt = tmpflt / 10 + 1;  
//     }  
//     else  
//     {  
//         tmpflt = tmpflt / 10;  
//     }  
//     printint(tmpint);  
//     putch('.');  
//     printint(tmpflt);  
 
// }  

#endif
