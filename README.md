
# Cross Compile C/C++ code for Windows, using MacOSX

Here is an example HOWTO to cross compile C/C++ from MacOSX terminal to Windows compatible binaries, using llvm's `clang`/`lld`.

Included are examples for:
- `.exe`
- `.lib` (static linked)
- `.dll` (dynamic linked)
- `.dll` (dynamic loaded - plugin)

Prerequisites:
- MacOSX High Sierra
- MacOSX terminal
- Parallels - virtualization host
- Windows10 installed under Parallels with C: mounted under /Volumes
- Microsoft Visual Studio 2015 w/ windows sdk (for includes and libs)
- `brew install llvm`  (the Clang compiler)
  - clang/clang++
  - lld

View the Makefile for details.

## Details:

C Hello World Demo:
```
#include <stdio.h>

int main()
{
   printf( "hello world!\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   return 0;
}
```

C++ Hello World Demo:
```
#include <stdio.h>

int main()
{
   printf( "hello world!\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   return 0;
}
```

Install llvm (for clang):
```
$ brew install llvm

$ /usr/local/opt/llvm/bin/clang++ --version
clang version 6.0.0 (tags/RELEASE_600/final)
Target: x86_64-apple-darwin17.4.0
Thread model: posix
InstalledDir: /usr/local/opt/llvm/bin
```

What's it look like?
Build it:
```
$ make
===================
compile some 64bit C++
/usr/local/opt/llvm/bin/clang++ -target x86_64-pc-windows-msvc -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include" -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Include/10.0.10150.0/ucrt" -fmsc-version=1900  -fms-extensions -fms-compatibility -fdelayed-template-parsing -std=c++11  -c main.cpp -o mainCPP-x64.o
/usr/local/opt/llvm/bin/lld -flavor link /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/lib/amd64" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Lib/10.0.10150.0/ucrt/x64" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x64" libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x64.exe mainCPP-x64.o
===================
compile some 64bit C
/usr/local/opt/llvm/bin/clang -target x86_64-pc-windows-msvc -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include" -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Include/10.0.10150.0/ucrt" -fmsc-version=1900  -fms-extensions -fms-compatibility -fdelayed-template-parsing -c main.c -o mainC-x64.o
/usr/local/opt/llvm/bin/lld -flavor link /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/lib/amd64" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Lib/10.0.10150.0/ucrt/x64" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x64" libucrt.lib libcmt.lib /subsystem:console /out:mainC-x64.exe mainC-x64.o
===================
compile some 32bit C++
/usr/local/opt/llvm/bin/clang++ -target i386-pc-win32 -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include" -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Include/10.0.10150.0/ucrt" -fmsc-version=1900  -fms-extensions -fms-compatibility -fdelayed-template-parsing -std=c++11  -c main.cpp -o mainCPP-x86.o
/usr/local/opt/llvm/bin/lld -flavor link /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/lib" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Lib/10.0.10150.0/ucrt/x86" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x86" libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x86.exe mainCPP-x86.o
===================
compile some 32bit  C
/usr/local/opt/llvm/bin/clang -target i386-pc-win32 -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include" -isystem "/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Include/10.0.10150.0/ucrt" -fmsc-version=1900  -fms-extensions -fms-compatibility -fdelayed-template-parsing -c main.c -o mainC-x86.o
/usr/local/opt/llvm/bin/lld -flavor link /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Microsoft Visual Studio 14.0/VC/lib" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/10/Lib/10.0.10150.0/ucrt/x86" /libpath:"/Volumes/[C] Windows 10/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x86" libucrt.lib libcmt.lib /subsystem:console /out:mainC-x86.exe mainC-x86.o

```

Run it on Windows 10 (under Parallels):
```
Z:\src\cross-compile-windows>test.bat

Z:\src\cross-compile-windows>mainCPP-x64.exe
Hello, world!
sizeof(size_t) == 8

Z:\src\cross-compile-windows>mainC-x64.exe
hello world!
sizeof(size_t): 8

Z:\src\cross-compile-windows>mainCPP-x86.exe
Hello, world!
sizeof(size_t) == 4

Z:\src\cross-compile-windows>mainC-x86.exe
hello world!
sizeof(size_t): 4

Z:\src\cross-compile-windows>libmain-x64.exe
Start Your Engines
sizeof(size_t): 8

Z:\src\cross-compile-windows>libmain-x86.exe
Start Your Engines
sizeof(size_t): 4

Z:\src\cross-compile-windows>dllmain-x64.exe
Start Your Engines
sizeof(size_t): 8

Z:\src\cross-compile-windows>dllmain-x86.exe
Start Your Engines
sizeof(size_t): 4

Z:\src\cross-compile-windows>plugin-x64.exe
Loading DLL plugin 'dll-x64.dll':
Finding plugin entrypoint 'vroooom':
Found 'vroooom', calling:
Start Your Engines
sizeof(size_t): 8

Z:\src\cross-compile-windows>plugin-x86.exe
Loading DLL plugin 'dll-x86.dll':
Finding plugin entrypoint 'vroooom':
Found 'vroooom', calling:
Start Your Engines
sizeof(size_t): 4
```



# Useful things:
- dumpbin shows all symbols in a DLL
   - `"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\dumpbin.exe" /exports dll-x86.dll`


