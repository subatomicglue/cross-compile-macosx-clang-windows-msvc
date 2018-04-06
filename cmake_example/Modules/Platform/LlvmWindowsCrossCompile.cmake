
# I cannot use Windows here, it doesn't allow me to change `CMAKE_CXX_COMPILE_OBJECT` or `CMAKE_CXX_LINK_EXECUTABLE` (missing /Tc or /Tp flags for compile)
# and REALLY, I want a blank slate, so we want Generic:
SET(CMAKE_SYSTEM_NAME LlvmWindowsCrossCompile CACHE STRING "Target system.")

set( _MSC_VER 1900 ) # 1800=VC2013, 1900=VC2015, 1910=VC2017.. etc.

if (NOT DEFINED ARCH)
   set( ARCH "x64" CACHE STRING "" FORCE )
endif()

# MSVC Includes and Libs:
# currently I am mounting MSVC from Parallels - TODO: allow configuring the path to MSVC.
set( PROGRAMFILES "/Volumes/[C] Windows 10/Program Files (x86)" )
IF(NOT EXISTS "${PROGRAMFILES}")
   message(FATAL_ERROR "\n\nERROR: INCLUDE/LIB DIRECTORY DOESNT EXIST:\n    ${PROGRAMFILES}\nLocation doesn't exist, please mount it, or install MSVC version ${_MSC_VER} v2015\n\n" )
endif()
set( UniversalCRT_IncludePath "${PROGRAMFILES}/Windows Kits/10/Include/10.0.10150.0/ucrt" )
set( UniversalCRT_Lib "${PROGRAMFILES}/Windows Kits/10/Lib/10.0.10150.0/ucrt/${ARCH}" )
set( MSVC_INCLUDE "${PROGRAMFILES}/Microsoft Visual Studio 14.0/VC/include" )
if (ARCH STREQUAL "x64" )
   set( MSVC_LIB "${PROGRAMFILES}/Microsoft Visual Studio 14.0/VC/lib/amd64" )
   set( triple "x86_64-pc-windows-msvc" )
else()
   set( MSVC_LIB "${PROGRAMFILES}/Microsoft Visual Studio 14.0/VC/lib" )
   set( triple "i386-pc-win32" )
endif()
set( WINSDK_LIB "${PROGRAMFILES}/Windows Kits/8.1/Lib/winv6.3/um/${ARCH}" )

if(CMAKE_VERBOSE_MAKEFILE)
  set(CMAKE_CL_NOLOGO)
else()
  set(CMAKE_CL_NOLOGO "/nologo")
endif()

# compiler clang (same interface as gcc, with -target i386-pc-win32 outputs MSVC .obj files
set( SYSFLAGS "-target ${triple} -isystem \"${MSVC_INCLUDE}\" -isystem \"${UniversalCRT_IncludePath}\" -fmsc-version=${_MSC_VER} -fms-extensions -fms-compatibility -fdelayed-template-parsing" )
# compiler clang-cl  (clang-cl has same interface as cl.exe... outputs MSVC .obj files)
#set( SYSFLAGS "/imsvc \"${MSVC_INCLUDE}\" /imsvc \"${UniversalCRT_IncludePath}\" -fmsc-version=${_MSC_VER} -fms-extensions -fms-compatibility -fdelayed-template-parsing" )


foreach(lang C CXX)
   set( CMAKE_INCLUDE_SYSTEM_FLAG_${lang} "${SYSFLAGS}" CACHE STRING "" FORCE)
   set( CMAKE_LIB_SYSTEM_PATHS_${lang} "/libpath:\"${MSVC_LIB}\" /libpath:\"${UniversalCRT_Lib}\" /libpath:\"${WINSDK_LIB}\"" CACHE STRING "" FORCE)
endforeach()

# compiler clang/clang++
set( CMAKE_C_COMPILER "/usr/local/opt/llvm/bin/clang" CACHE STRING "" FORCE)
set( CMAKE_CXX_COMPILER "/usr/local/opt/llvm/bin/clang++" CACHE STRING "" FORCE)
set( C_COMPILE_OBJECT_OUTPUT_FLAG -o )
set( CXX_COMPILE_OBJECT_OUTPUT_FLAG -o )
set( C_COMPILE_OBJECT_FLAG -c )
set( CXX_COMPILE_OBJECT_FLAG -c )
set( C_COMPILE_OBJECT_SOURCE_FLAG "")
set( CXX_COMPILE_OBJECT_SOURCE_FLAG "")
# compiler clang-cl
#set( CMAKE_${lang}_COMPILER "/usr/local/opt/llvm/bin/clang-cl" CACHE STRING "" FORCE)
#set( C_COMPILE_OBJECT_OUTPUT_FLAG /o )
#set( CXX_COMPILE_OBJECT_OUTPUT_FLAG /o )
#set( C_COMPILE_OBJECT_FLAG /c )
#set( CXX_COMPILE_OBJECT_FLAG /c )
#set( C_COMPILE_OBJECT_SOURCE_FLAG /Tc)
#set( CXX_COMPILE_OBJECT_SOURCE_FLAG /Tp)


#/MACHINE:X64|X86

# executable and DLL linker lld -flavor link (llvm's version of MSVC's link.exe)
set( CMAKE_LINKER "/usr/local/opt/llvm/bin/lld" CACHE STRING "" FORCE)
foreach(lang C CXX)
   set( CMAKE_${lang}_SYSTEM_LINK_FLAGS "-flavor link" CACHE STRING "" FORCE)
endforeach()

# executable and DLL linker lld-link (llvm's version of MSVC's link.exe)
#set( CMAKE_LINKER "/usr/local/opt/llvm/bin/lld-link" CACHE STRING "" FORCE)
#foreach(lang C CXX)
#  set( CMAKE_${lang}_LINK_FLAGS "" CACHE STRING "" FORCE)
#endforeach()

# library linker - llvm-lib (llvm's version of MSVC's lib.exe)
set( CMAKE_LIB "/usr/local/opt/llvm/bin/llvm-lib" CACHE STRING "" FORCE)

# how to make:
# executable
# shared library
# static library
foreach(lang C CXX)
   set(CMAKE_${lang}_COMPILE_OBJECT "<CMAKE_${lang}_COMPILER> ${CMAKE_INCLUDE_SYSTEM_FLAG_${lang}} <DEFINES> <FLAGS> ${${lang}_COMPILE_OBJECT_OUTPUT_FLAG}<OBJECT>  ${${lang}_COMPILE_OBJECT_FLAG} ${${lang}_COMPILE_OBJECT_SOURCE_FLAG}<SOURCE>" CACHE STRING "" FORCE)
   set(CMAKE_${lang}_LINK_EXECUTABLE "<CMAKE_LINKER> ${CMAKE_${lang}_SYSTEM_LINK_FLAGS} ${CMAKE_LIB_SYSTEM_PATHS_${lang}} <FLAGS> <LINK_FLAGS> /subsystem:console libcmt.lib <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
   set(CMAKE_${lang}_CREATE_SHARED_LIBRARY "echo _CREATE_SHARED_LIBRARY;<CMAKE_LINKER> ${CMAKE_CL_NOLOGO} <OBJECTS> /out:<TARGET> /implib:<TARGET_IMPLIB> /pdb:<TARGET_PDB> /dll /version:<TARGET_VERSION_MAJOR>.<TARGET_VERSION_MINOR>${_PLATFORM_LINK_FLAGS} <LINK_FLAGS> <LINK_LIBRARIES> ${CMAKE_END_TEMP_FILE}")
   set(CMAKE_${lang}_CREATE_SHARED_MODULE ${CMAKE_${lang}_CREATE_SHARED_LIBRARY})
   set(CMAKE_${lang}_CREATE_STATIC_LIBRARY  "echo _CREATE_STATIC_LIBRARY; ${CMAKE_LIB} ${CMAKE_LIB_SYSTEM_PATHS_${lang}} <LINK_FLAGS> ${CMAKE_CL_NOLOGO} /out:<TARGET> <OBJECTS>")
   set(CMAKE_${lang}_LINKER_SUPPORTS_PDB ON)
endforeach()

set(CMAKE_LIBRARY_ARCHITECTURE x86 CACHE STRING "" FORCE)

# you can set lib paths with , and libs with cmt (which will expand to libcmt.lib)
# PROBLEM: makes no difference, every one gets overridden by cmake/Modules/CMakeGenericSystem.cmake during PROJECT() in the CMakeLists
SET(CMAKE_LIBRARY_PATH_FLAG      "/libpath:"    CACHE STRING "Linker's Library path flag" FORCE)
SET(CMAKE_LINK_LIBRARY_FLAG      ""             CACHE STRING "Linker's Libray flag" FORCE)
SET(CMAKE_LINK_LIBRARY_SUFFIX    ".lib"         CACHE STRING "Library extension" FORCE)
set(CMAKE_STATIC_LIBRARY_PREFIX  ""             CACHE STRING "Library prefix" FORCE)
SET(CMAKE_STATIC_LIBRARY_SUFFIX  ".lib"         CACHE STRING "Linker library extension" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX      ".exe"         CACHE STRING "Executable extention" FORCE)
set(CMAKE_C_OUTPUT_EXTENSION     ".obj"         CACHE STRING "C compiler object extension")
set(CMAKE_CXX_OUTPUT_EXTENSION   ".obj"         CACHE STRING "C++ compiler object extension")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

