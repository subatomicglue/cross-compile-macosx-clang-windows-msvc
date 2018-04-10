
extern "C"
{
   extern
#if defined(WIN32)
   __declspec(dllimport)
#endif
   void blend();
}

int main() {
   blend();
   return 0;
}

