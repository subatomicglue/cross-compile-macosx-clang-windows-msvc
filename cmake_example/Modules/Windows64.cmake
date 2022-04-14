
# Toolchain for 64bit windows builds
# - on MacOSX we will crosscompile for Windows using MSVC directories
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Windows64.cmake
#
# - on Windows will generate a .sln project/solution for visual studio
#   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Windows64.cmake -G "Visual Studio 14 Win64" ..
#
# to set up MSVC compiler toolchain, run the Platform/install-msvc-*.sh scripts:
# - Platform/install-msvc-toolchain.sh  # builds an SDK directory with base LLVM cross-compiler
# - Platform/install-msvc-sysroot.sh    # copy lib/includes from MSVC compiler to SDK directory
#

if (NOT WIN32)
  message( "We're going to use LLVM to cross compile to Windows for you" )
  set( CMAKE_SYSTEM_NAME LlvmWindowsCrossCompile )
  set( CMAKE_C_FLAGS_INIT "-m64 -MT" CACHE STRING "" FORCE)
  set( CMAKE_CXX_FLAGS_INIT "-m64 -MT" CACHE STRING "" FORCE)
  set( CMAKE_EXE_LINKER_FLAGS_INIT "/MACHINE:X64"  CACHE STRING "" FORCE)
  set( CMAKE_MODULE_LINKER_FLAGS_INIT "/MACHINE:X64"  CACHE STRING "" FORCE)
  set( CMAKE_SHARED_LINKER_FLAGS_INIT "/MACHINE:X64"  CACHE STRING "" FORCE)
  set( CMAKE_ASM-ATT_FLAGS_INIT -m64 CACHE STRING "" FORCE)
  set( CMAKE_LIBRARY_ARCHITECTURE x64  CACHE STRING "" FORCE)
  set( ARCH x64  CACHE STRING "" FORCE)  # my custom flag
else()
   message( "Looks like you're actually on Windows 64bit with " ${CMAKE_GENERATOR} " sure I know how to do that" )
   if (NOT DEFINED CMAKE_GENERATOR)
      set( CMAKE_GENERATOR "Visual Studio 14 Win64" )
   endif()
   set( CMAKE_C_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_C_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   SET( CMAKE_EXE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   SET( CMAKE_MODULE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   SET( CMAKE_SHARED_LINKER_FLAGS "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   set( CMAKE_BUILD_TYPE Release )
   set( CMAKE_LIBRARY_ARCHITECTURE x64  CACHE STRING "" FORCE)
   set( ARCH x64  CACHE STRING "" FORCE)  # my custom flag
endif()

