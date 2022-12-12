#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  const char *p = s;
  while( *p++ ) ;
  return( (int)(p - s - 1) );
  // panic("Not implemented");
}

char *strcpy(char *dst, const char *src) {
  char *cp = dst;
  while( (*cp++ = *src++) ); 
  return( dst );
  // panic("Not implemented");
}

char *strncpy(char *dst, const char *src, size_t n) {
      char *p = dst;
      while (n && (*p++ = *src++)) n--;
      while(n--) *p++ = '\0';
      return(dst);
  // panic("Not implemented");
}

char *strcat(char *dst, const char *src) {
  char *p = dst;
  while( *p )    p++;
  while( (*p++ = *src++) ) ;
  return( dst );
  // panic("Not implemented");
}

int strcmp(const char *s1, const char *s2) {
  int ch1, ch2;
  do{
    if ( ((ch1 = (unsigned char)(*(s1++))) >= 'A') &&(ch1 <= 'Z') )
      ch1 += 0x20;
    if ( ((ch2 = (unsigned char)(*(s2++))) >= 'A') &&(ch2 <= 'Z') )
      ch2 += 0x20;
  } while ( ch1 && (ch1 == ch2) );
  
  return(ch1 - ch2);
  // panic("Not implemented");
}

int strncmp(const char *s1, const char *s2, size_t n) {
  if (!n) return(0);
  while (--n && *s1 && *s1 == *s2)s1++,s2++;
  return( *(unsigned char *)s1 - *(unsigned char *)s2 );
  // panic("Not implemented");
}

void *memset(void *s, int c, size_t n) {
  char *ptr = (char*)s;

  while (n--)
  {
    *ptr++ = c;
  }

  return s;
  // panic("Not implemented");
}

void *memmove(void *dst, const void *src, size_t n) {
  const char *s = (char *)src;
  char *d = (char *)dst;

  const char *nexts = s + n;
  char *nextd = d + n;

  if (d < s)
  {
    while (d != nextd)
    {
      *d++ = *s++;
    }
  }
  else
  {
    while (nextd != d)
    {
      *--nextd = *--nexts;
    }
  }
  return dst;
  // panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
  const char *s = (char*)in;
  char *d = (char*)out;

  while (n--)
  {
    *d++ = *s++;
  }

  return out;
  // panic("Not implemented");
}

int memcmp(const void *s1, const void *s2, size_t n) {
  const unsigned char *str1 = (unsigned char *)s1;
  const unsigned char *str2 = (unsigned char *)s2;

  while (n-- > 0)
  {
    if (*str1++ != *str2++)
    {
      return str1[-1] < str2[-1] ? -1 : 1;
    }
  }
  return 0;
  // panic("Not implemented");
}

#endif
