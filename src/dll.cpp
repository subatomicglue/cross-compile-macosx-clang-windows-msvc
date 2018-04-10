#include <stdio.h>

extern "C"
{

#if defined(WIN32)
   __declspec(dllexport)
#endif
   void blend() {
      printf( "Blending Ingredients\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }

}

