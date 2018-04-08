
# Cross Compile C/C++ code for Windows, using MacOSX

Here is an example HOWTO to cross compile C/C++ from MacOSX terminal to Windows compatible binaries, using llvm's `clang`/`lld`.

Included are examples for:
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


## Makefile example:

A simple example illustrating how to cross-compile C/C++ Windows binaries from a system such as MacOSX, using the LLVM clang compiler.

* [makefile_example/](makefile_example/)

## CMake example:

A more advanced example, with reusable `cmake` toolchain for cross-compiling C/C++ Windows binaries under MacOSX

* [cmake_example/](cmake_example/)


