
extern "C"
{
   extern
#if defined(WIN32)
   __declspec(dllimport)
#endif
   void init();
}

int main() {
   init();
   return 0;
}

