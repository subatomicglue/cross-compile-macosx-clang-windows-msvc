
# A `cmake` toolchain for cross-compiling C/C++ Windows binaries under MacOSX

Here is an example HOWTO to cross compile C/C++ from MacOSX terminal to Windows compatible binaries, using llvm's `clang`/`lld`.

There are *Platform* and *Toolchain* files [under Modules](Modules/)) for compiling a Windows binary using a non-windows system (such as MacOSX), using the LLVM compiler.

See also: [looking for a Makefile version?](../makefile_example/README.md)

Included are both 32 and 64bit examples for:
- `.exe`
- `.lib` (static linked)
- `.dll` (dynamic linked)
- `.dll` (dynamic loaded - plugin)

Prerequisites:
- MacOSX High Sierra (or similar)
- MacOSX terminal
- Parallels 13 (or similar) - virtualization host
- Windows10 installed under Parallels
  - Windows `C:\` mounted under MacOSX `/Volumes/[C] Windows 10/`.  This is how `clang` will find the MSVC compiler `lib/` & `include/` directories.
- Microsoft Visual Studio 2015 w/ windows sdk (for includes and libs)
- `brew install llvm`  (clang compiler version 6.0.0, or similar)
  - clang/clang++
  - lld
- `brew install cmake` (cmake version 3.10.3, or similar)

View the [CMakeLists.txt](CMakeLists.txt) for details.

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

Install llvm (for clang); Install cmake:
```
$ brew install llvm

$ /usr/local/opt/llvm/bin/clang++ --version
clang version 6.0.0 (tags/RELEASE_600/final)
Target: x86_64-apple-darwin17.4.0
Thread model: posix
InstalledDir: /usr/local/opt/llvm/bin

$ brew install cmake

$ cmake --version
cmake version 3.10.3
```

Useful Scripts:
```
# from MacOSX terminal:
$ ./cmake_windows # calls cmake with our Windows32/64 cross compile toolchain
$ ./cmake_native  # yep, we can build natively for Linux/MacOSX/Whatever.. too!
                    calls cmake with our Native32/64 native toolchain
$ ./clean         # clean up from the cmake scripts

# from Windows CMD prompt:
C:\cross-windows\cmake_example> cmake_windows.bat
                  :: builds the .sln using MSVC installed on local OS
                  :: calls cmake with our Native32/64 native toolchain
```

What's it look like? (32 bit)
```
$ cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Windows32.cmake ..

-- The C compiler identification is AppleClang 9.0.0.9000039
-- The CXX compiler identification is AppleClang 9.0.0.9000039
-- Check for working C compiler: /usr/local/opt/llvm/bin/clang-cl
-- Check for working C compiler: /usr/local/opt/llvm/bin/clang-cl -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/local/opt/llvm/bin/clang-cl
-- Check for working CXX compiler: /usr/local/opt/llvm/bin/clang-cl -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /Users/...path.../cmake_example/build-wincross32
Scanning dependencies of target plugin-x86
[  6%] Building CXX object CMakeFiles/plugin-x86.dir/Users/...path.../makefile_example/dll.cpp.obj
[ 12%] Linking CXX shared module plugin-x86.dll
[ 12%] Built target plugin-x86
Scanning dependencies of target mainCPP-x86
[ 18%] Building CXX object CMakeFiles/mainCPP-x86.dir/Users/...path.../makefile_example/main.cpp.obj
[ 25%] Linking CXX executable mainCPP-x86.exe
[ 25%] Built target mainCPP-x86
Scanning dependencies of target dll-x86
[ 31%] Building CXX object CMakeFiles/dll-x86.dir/Users/...path.../makefile_example/dll.cpp.obj
[ 37%] Linking CXX shared library dll-x86.dll
[ 37%] Built target dll-x86
Scanning dependencies of target pluginmain-x86
[ 43%] Building CXX object CMakeFiles/pluginmain-x86.dir/Users/...path.../makefile_example/plugin.cpp.obj
[ 50%] Linking CXX executable pluginmain-x86.exe
[ 50%] Built target pluginmain-x86
Scanning dependencies of target dllmain-x86
[ 56%] Building CXX object CMakeFiles/dllmain-x86.dir/Users/...path.../makefile_example/dllmain.cpp.obj
[ 62%] Linking CXX executable dllmain-x86.exe
[ 62%] Built target dllmain-x86
Scanning dependencies of target lib-x86
[ 68%] Building CXX object CMakeFiles/lib-x86.dir/Users/...path.../makefile_example/lib.cpp.obj
[ 75%] Linking CXX static library lib-x86.lib
[ 75%] Built target lib-x86
Scanning dependencies of target libmain-x86
[ 81%] Building CXX object CMakeFiles/libmain-x86.dir/Users/...path.../makefile_example/libmain.cpp.obj
[ 87%] Linking CXX executable libmain-x86.exe
[ 87%] Built target libmain-x86
Scanning dependencies of target mainC-x86
[ 93%] Building C object CMakeFiles/mainC-x86.dir/Users/...path.../makefile_example/main.c.obj
[100%] Linking C executable mainC-x86.exe
[100%] Built target mainC-x86

$ ls
CMakeCache.txt		dll-x86.dll		libmain-x86.exe		plugin-x86.lib
CMakeFiles		dll-x86.lib		mainC-x86.exe		pluginmain-x86.exe
Makefile		dllmain-x86.exe		mainCPP-x86.exe		test.bat
cmake_install.cmake	lib-x86.lib		plugin-x86.dll
```

What's it look like? (64 bit):
```
$ cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Windows64.cmake ..

-- The C compiler identification is AppleClang 9.0.0.9000039
-- The CXX compiler identification is AppleClang 9.0.0.9000039
-- Check for working C compiler: /usr/local/opt/llvm/bin/clang-cl
-- Check for working C compiler: /usr/local/opt/llvm/bin/clang-cl -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/local/opt/llvm/bin/clang-cl
-- Check for working CXX compiler: /usr/local/opt/llvm/bin/clang-cl -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /Users/...path.../build-wincross64
Scanning dependencies of target pluginmain-x64
[  6%] Building CXX object CMakeFiles/pluginmain-x64.dir/Users/...path.../makefile_example/plugin.cpp.obj
[ 12%] Linking CXX executable pluginmain-x64.exe
[ 12%] Built target pluginmain-x64
Scanning dependencies of target dll-x64
[ 18%] Building CXX object CMakeFiles/dll-x64.dir/Users/...path.../makefile_example/dll.cpp.obj
[ 25%] Linking CXX shared library dll-x64.dll
[ 25%] Built target dll-x64
Scanning dependencies of target dllmain-x64
[ 31%] Building CXX object CMakeFiles/dllmain-x64.dir/Users/...path.../makefile_example/dllmain.cpp.obj
[ 37%] Linking CXX executable dllmain-x64.exe
[ 37%] Built target dllmain-x64
Scanning dependencies of target plugin-x64
[ 43%] Building CXX object CMakeFiles/plugin-x64.dir/Users/...path.../makefile_example/dll.cpp.obj
[ 50%] Linking CXX shared module plugin-x64.dll
[ 50%] Built target plugin-x64
Scanning dependencies of target mainCPP-x64
[ 56%] Building CXX object CMakeFiles/mainCPP-x64.dir/Users/...path.../makefile_example/main.cpp.obj
[ 62%] Linking CXX executable mainCPP-x64.exe
[ 62%] Built target mainCPP-x64
Scanning dependencies of target lib-x64
[ 68%] Building CXX object CMakeFiles/lib-x64.dir/Users/...path.../makefile_example/lib.cpp.obj
[ 75%] Linking CXX static library lib-x64.lib
[ 75%] Built target lib-x64
Scanning dependencies of target libmain-x64
[ 81%] Building CXX object CMakeFiles/libmain-x64.dir/Users/...path.../makefile_example/libmain.cpp.obj
[ 87%] Linking CXX executable libmain-x64.exe
[ 87%] Built target libmain-x64
Scanning dependencies of target mainC-x64
[ 93%] Building C object CMakeFiles/mainC-x64.dir/Users/...path.../makefile_example/main.c.obj
[100%] Linking C executable mainC-x64.exe
[100%] Built target mainC-x64

$ ls
CMakeCache.txt		dll-x64.dll		libmain-x64.exe		plugin-x64.lib
CMakeFiles		dll-x64.lib		mainC-x64.exe		pluginmain-x64.exe
Makefile		dllmain-x64.exe		mainCPP-x64.exe		test.bat
cmake_install.cmake	lib-x64.lib		plugin-x64.dll
```

Run it on Windows 10:
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

See also: [looking for a Makefile version?](../makefile_example/README.md)

