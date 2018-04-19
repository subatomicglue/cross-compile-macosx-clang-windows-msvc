
# Cross-Compile C/C++ Windows binaries from MacOSX bash terminal

Here is an example Makefile, as well as example `cmake` platform & toolchains, to cross-compile C/C++ Windows binaries from MacOSX bash terminal, using llvm's `clang`/`lld`.

Included are both 32 and 64bit examples for:
- `.exe`
- `.lib` (static linked)
- `.dll` (dynamic linked)
- `.dll` (dynamic loaded - plugin)

Prerequisites:
- MacOSX High Sierra (or similar)
- MacOSX terminal
- Windows10 installed under Parallels
  - Windows `C:\` mounted under MacOSX `/Volumes/[C] Windows 10/`.  This is how `clang` will find the MSVC compiler `lib/` & `include/` directories.
- Microsoft Visual Studio 2015 w/ windows sdk (for includes and libs)
- `brew install llvm`  (clang compiler version 6.0.0, or similar)
  - clang/clang++
  - lld
- `brew install cmake` (cmake version 3.10.3, or similar)
- Optional: Parallels 13 (or similar) - virtualization host running Windows 10


## Makefile example:

A simple example illustrating how to cross-compile C/C++ Windows binaries from a system such as MacOSX, using the LLVM clang compiler.

* [makefile_example/](makefile_example/)

## CMake example:

A more advanced example, with reusable `cmake` toolchain for cross-compiling C/C++ Windows binaries under MacOSX, using the LLVM clang compiler.

* [cmake_example/](cmake_example/)


