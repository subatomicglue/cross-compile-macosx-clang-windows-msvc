
#include <stdio.h>
#if defined(WIN32)
#include "Windows.h" // for LoadLibrary/GetProcAddress
#else
#include <dlfcn.h> // for dlopen
#endif

typedef void (*vroooom_func)();

int main()
{
   bool is64 = sizeof(size_t) == 8;
#if defined(WIN32)
   const char* plugin_filename = is64 ? "plugin-x64.dll" : "plugin-x86.dll";
#else
   const char* plugin_filename = is64 ? "libplugin-x64.so" : "libplugin-x86.so";
#endif
   void* module = NULL;

   printf( "Loading %s plugin:\n", plugin_filename );
#if defined(WIN32)
   module = (void*)LoadLibrary( plugin_filename );
#else
   module = dlopen( plugin_filename, RTLD_LOCAL | RTLD_LAZY);
#endif
   if (!module)
   {
      printf( "Couldn't load plugin\n" );
      return -1;
   }

   printf( "Finding plugin entrypoint 'vroooom':\n" );
   vroooom_func vroooom = NULL;
#if defined(WIN32)
   vroooom = (vroooom_func)GetProcAddress( (HMODULE)module, "vroooom" );
#else
   vroooom = (vroooom_func)dlsym( module, "vroooom" );
#endif
   if (vroooom)
   {
      printf( "Found 'vroooom', calling:\n" );
      vroooom();
   }
   else
   {
      printf( "Couldn't find 'vroooom' in DLL plugin\n" );
   }


   vroooom_func crash = NULL;
#if defined(WIN32)
   crash = (vroooom_func)GetProcAddress( (HMODULE)module, "crash" );
#else
   crash = (vroooom_func)dlsym( module, "crash" );
#endif
   if (crash)
   {
      printf( "Found 'crash', calling:\n" );
      crash();
   }
   else
   {
      printf( "Couldn't find 'crash' in DLL plugin\n" );
   }

   return 0;
}
