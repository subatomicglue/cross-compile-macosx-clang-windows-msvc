
# Platform/System: LlvmWindowsCrossCompile
# this file should live in ${CMAKE_CURRENT_SOURCE_DIR}/Modules/Platform/LlvmWindowsCrossCompile.cmake
# put following in your CMakeLists.txt file
#   list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")
# to cross compile for Windows call:
#   cmake -DCMAKE_SYSTEM_NAME=LlvmWindowsCrossCompile
SET(CMAKE_SYSTEM_NAME LlvmWindowsCrossCompile CACHE STRING "Target system.")

# if you want to see the compiler commands, set to TRUE
SET( VERBOSE_OUTPUT FALSE )

# useful paths:
#    /usr/local/Cellar/cmake/3.10.3/share/cmake/Modules/Platform/Windows-MSVC.cmake
# useful links:
#    https://cmake.org/Wiki/CMake_Build_Rules


set(APPLE 0)
set(MSVC 1)
set(WIN32 1)


# x64 or x86
if (NOT DEFINED ARCH)
   set( ARCH "x64" CACHE STRING "" FORCE )
endif()

# MSVC Includes and Libs:
# currently I am mounting MSVC from Parallels - TODO: allow configuring the path to MSVC.
set( PROGRAMFILES "/Volumes/[C] Windows 10/Program Files (x86)" )
IF(NOT EXISTS "${PROGRAMFILES}")
   message(FATAL_ERROR "\n\nERROR: INCLUDE/LIB DIRECTORY DOESNT EXIST:\n    ${PROGRAMFILES}\nLocation doesn't exist, please mount it, or install MSVC version ${_MSC_VER} v2015\n\n" )
endif()

# http://marcofoco.com/microsoft-visual-c-version-map/
IF(EXISTS "${PROGRAMFILES}/Microsoft Visual Studio 15.0/VC") # 2017
   set( _MSC_VER 1910 )
   set( MSVC_BASE_DIR "${PROGRAMFILES}/Microsoft Visual Studio 15.0/VC" )
endif()
IF(EXISTS "${PROGRAMFILES}/Microsoft Visual Studio 14.0/VC") # 2015
   set( _MSC_VER 1900 )
   set( MSVC_BASE_DIR "${PROGRAMFILES}/Microsoft Visual Studio 14.0/VC" )
endif()
IF(EXISTS "${PROGRAMFILES}/Microsoft Visual Studio 12.0/VC") # 2013
   set( _MSC_VER 1800 )
   set( MSVC_BASE_DIR "${PROGRAMFILES}/Microsoft Visual Studio 12.0/VC" )
endif()
IF(EXISTS "${PROGRAMFILES}/Microsoft Visual Studio 11.0/VC") # 2012
   set( _MSC_VER 1700 )
   set( MSVC_BASE_DIR "${PROGRAMFILES}/Microsoft Visual Studio 11.0/VC" )
endif()
IF(EXISTS "${PROGRAMFILES}/Microsoft Visual Studio 10.0/VC") # 2010
   set( _MSC_VER 1600 )
   set( MSVC_BASE_DIR "${PROGRAMFILES}/Microsoft Visual Studio 10.0/VC" )
endif()
if (NOT DEFINED _MSC_VER)
   message(FATAL_ERROR "\n\nERROR: Visual Studio Installation not found/recognized in ${PROGRAMFILES}:\n    Please install it.\n\n" )
endif()
if (NOT DEFINED MSVC_BASE_DIR)
   message(FATAL_ERROR "\n\nERROR: Visual Studio Installation not found/recognized in ${PROGRAMFILES}:\n    Please install it.\n\n" )
endif()

IF(EXISTS "${PROGRAMFILES}/Windows Kits/10") # 2010
   set( WINKIT10_BASE_DIR "${PROGRAMFILES}/Windows Kits/10" )
endif()
if (NOT DEFINED WINKIT10_BASE_DIR)
   message(FATAL_ERROR "\n\nERROR: 'Windows Kits/10' not found in ${PROGRAMFILES}:\n    Please install it, should come with MSVC.\n\n" )
endif()

IF(EXISTS "${PROGRAMFILES}/Windows Kits/8.1") # 2010
   set( WINKIT81_BASE_DIR "${PROGRAMFILES}/Windows Kits/8.1" )
endif()
if (NOT DEFINED WINKIT81_BASE_DIR)
   message(FATAL_ERROR "\n\nERROR: 'Windows Kits/81' not found in ${PROGRAMFILES}:\n    Please install it, should come with MSVC.\n\n" )
endif()

# include paths
set( UniversalCRT_IncludePath "${WINKIT10_BASE_DIR}/Include/10.0.10150.0/ucrt" )
set( UniversalCRT_Lib "${WINKIT10_BASE_DIR}/Lib/10.0.10150.0/ucrt/${ARCH}" )
set( MSVC_INCLUDE "${MSVC_BASE_DIR}/include" )
if (ARCH STREQUAL "x64" )
   set( MSVC_LIB "${MSVC_BASE_DIR}/lib/amd64" )
   set( triple "x86_64-pc-windows-msvc" )
   set(CMAKE_LIBRARY_ARCHITECTURE x64 CACHE STRING "" FORCE)
else()
   set( MSVC_LIB "${MSVC_BASE_DIR}/lib" )
   set( triple "i386-pc-win32" )
   set(CMAKE_LIBRARY_ARCHITECTURE x86 CACHE STRING "" FORCE)
endif()
set( WINSDK_INC "${WINKIT81_BASE_DIR}/Include/um" )
set( WINSDK_SHARED_INC32 "${WINKIT81_BASE_DIR}/Include/shared" )
set( WINSDK_LIB "${WINKIT81_BASE_DIR}/Lib/winv6.3/um/${ARCH}" )

if(CMAKE_VERBOSE_MAKEFILE)
  set(CMAKE_CL_NOLOGO)
else()
  set(CMAKE_CL_NOLOGO "/nologo")
endif()

# compiler clang (same interface as gcc, with -target i386-pc-win32 outputs MSVC .obj files
set( SYSFLAGS "-target ${triple} -isystem \"${MSVC_INCLUDE}\" -isystem \"${UniversalCRT_IncludePath}\" -isystem \"${WINSDK_INC}\" -isystem \"${WINSDK_SHARED_INC32}\" -fmsc-version=${_MSC_VER} -fms-extensions -fms-compatibility -fdelayed-template-parsing" )
# compiler clang-cl  (clang-cl has same interface as cl.exe... outputs MSVC .obj files)
#set( SYSFLAGS "/imsvc \"${MSVC_INCLUDE}\" /imsvc \"${UniversalCRT_IncludePath}\" /imsvc \"${WINSDK_INC}\" /imsvc \"${WINSDK_SHARED_INC32}\" -fmsc-version=${_MSC_VER} -fms-extensions -fms-compatibility -fdelayed-template-parsing" )


foreach(lang C CXX)
   set(CMAKE_${lang}_COMPILE_OPTIONS_PIC "")
   set(CMAKE_SHARED_LIBRARY_${lang}_FLAGS "")
   set( CMAKE_INCLUDE_SYSTEM_FLAG_${lang} "${SYSFLAGS}" CACHE STRING "" FORCE)
   set( CMAKE_LIB_SYSTEM_PATHS_${lang} "/libpath:\"${MSVC_LIB}\" /libpath:\"${UniversalCRT_Lib}\" /libpath:\"${WINSDK_LIB}\"" CACHE STRING "" FORCE)
endforeach()
#set( CMAKE_SHARED_LINKER_FLAGS "" )

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


#set(CMAKE_C_STANDARD_LIBRARIES_INIT "libcmt.lib")
#set(CMAKE_CXX_STANDARD_LIBRARIES_INIT "libcmt.lib")
foreach(t EXE SHARED MODULE)
  #string(APPEND CMAKE_${t}_LINKER_FLAGS_INIT " /NODEFAULTLIB:libc.lib /NODEFAULTLIB:oldnames.lib")
  #string(APPEND CMAKE_${t}_LINKER_FLAGS_INIT " ${_MACHINE_ARCH_FLAG}")
  if (CMAKE_COMPILER_SUPPORTS_PDBTYPE)
    #string(APPEND CMAKE_${t}_LINKER_FLAGS_DEBUG_INIT " /debug /pdbtype:sept ${MSVC_INCREMENTAL_YES_FLAG}")
    #string(APPEND CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO_INIT " /debug /pdbtype:sept ${MSVC_INCREMENTAL_YES_FLAG}")
  else ()
    #string(APPEND CMAKE_${t}_LINKER_FLAGS_DEBUG_INIT " /debug ${MSVC_INCREMENTAL_YES_FLAG}")
    #string(APPEND CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO_INIT " /debug ${MSVC_INCREMENTAL_YES_FLAG}")
  endif ()
  # for release and minsize release default to no incremental linking
  #string(APPEND CMAKE_${t}_LINKER_FLAGS_MINSIZEREL_INIT " /INCREMENTAL:NO")
  #string(APPEND CMAKE_${t}_LINKER_FLAGS_RELEASE_INIT " /INCREMENTAL:NO")
endforeach()


# how to make:
# object
# executable
# shared library
# static library
foreach(lang C CXX)
   if(NOT MSVC_VERSION LESS 1400)
    # for 2005 make sure the manifest is put in the dll with mt
    set(_CMAKE_VS_LINK_DLL "")#"<CMAKE_COMMAND> -E vs_link_dll --intdir=<OBJECT_DIR> --manifests <MANIFESTS> -- ")
    set(_CMAKE_VS_LINK_EXE "")#"<CMAKE_COMMAND> -E vs_link_exe --intdir=<OBJECT_DIR> --manifests <MANIFESTS> -- ")
   endif()

   set(CMAKE_${lang}_COMPILE_OBJECT "<CMAKE_${lang}_COMPILER> ${CMAKE_INCLUDE_SYSTEM_FLAG_${lang}} <DEFINES> <FLAGS> ${${lang}_COMPILE_OBJECT_FLAG} ${${lang}_COMPILE_OBJECT_SOURCE_FLAG}<SOURCE> ${${lang}_COMPILE_OBJECT_OUTPUT_FLAG}<OBJECT>  " CACHE STRING "" FORCE)
   set(CMAKE_${lang}_LINK_EXECUTABLE "${_CMAKE_VS_LINK_EXE}<CMAKE_LINKER> ${CMAKE_${lang}_SYSTEM_LINK_FLAGS} ${CMAKE_LIB_SYSTEM_PATHS_${lang}} ${CMAKE_CL_NOLOGO} <OBJECTS> ${CMAKE_START_TEMP_FILE} <LINK_FLAGS> /subsystem:console libcmt.lib <LINK_LIBRARIES> /out:<TARGET>${CMAKE_END_TEMP_FILE}")
   set(CMAKE_${lang}_CREATE_SHARED_LIBRARY "${_CMAKE_VS_LINK_DLL}<CMAKE_LINKER> ${CMAKE_${lang}_SYSTEM_LINK_FLAGS} ${CMAKE_LIB_SYSTEM_PATHS_${lang}} ${CMAKE_CL_NOLOGO} <OBJECTS> ${CMAKE_START_TEMP_FILE} /implib:<TARGET_IMPLIB> /pdb:<TARGET_PDB> /dll /version:<TARGET_VERSION_MAJOR>.<TARGET_VERSION_MINOR>${_PLATFORM_LINK_FLAGS} <LINK_FLAGS> libcmt.lib <LINK_LIBRARIES> /out:<TARGET> ${CMAKE_END_TEMP_FILE}")
   set(CMAKE_${lang}_CREATE_SHARED_MODULE ${CMAKE_${lang}_CREATE_SHARED_LIBRARY})
   set(CMAKE_${lang}_CREATE_STATIC_LIBRARY  "${CMAKE_LIB} ${CMAKE_LIB_SYSTEM_PATHS_${lang}} <LINK_FLAGS> ${CMAKE_CL_NOLOGO} <OBJECTS> /out:<TARGET>")

   # verbose output:
   if (VERBOSE_OUTPUT)
      set(CMAKE_${lang}_COMPILE_OBJECT "echo OBJ: ${CMAKE_${lang}_COMPILE_OBJECT}; ${CMAKE_${lang}_COMPILE_OBJECT}" )
      set(CMAKE_${lang}_LINK_EXECUTABLE "echo EXE: ${CMAKE_${lang}_LINK_EXECUTABLE}; ${CMAKE_${lang}_LINK_EXECUTABLE}" )
      set(CMAKE_${lang}_CREATE_SHARED_LIBRARY "echo SHARED_LIB: ${CMAKE_${lang}_CREATE_SHARED_LIBRARY}; ${CMAKE_${lang}_CREATE_SHARED_LIBRARY}" )
      set(CMAKE_${lang}_CREATE_SHARED_MODULE "echo SHARED_MODULE: ${CMAKE_${lang}_CREATE_SHARED_MODULE}; ${CMAKE_${lang}_CREATE_SHARED_MODULE}" )
      set(CMAKE_${lang}_CREATE_STATIC_LIBRARY "echo STATIC_LIB: ${CMAKE_${lang}_CREATE_STATIC_LIBRARY}; ${CMAKE_${lang}_CREATE_STATIC_LIBRARY}" )
      set(CMAKE_${lang}_LINKER_SUPPORTS_PDB ON)
   endif()

   if("x${lang}" STREQUAL "xC" OR
      "x${lang}" STREQUAL "xCXX")
    if(CMAKE_${lang}_COMPILER MATCHES "clang")
      # note: MSVC 14 2015 Update 1 sets -fno-ms-compatibility by default, but this does not allow one to compile many projects
      # that include MS's own headers. CMake itself is affected project too.
      #string(APPEND CMAKE_${lang}_FLAGS_INIT " ${_PLATFORM_DEFINES}${_PLATFORM_DEFINES_${lang}} -fms-extensions -fms-compatibility -D_WINDOWS -Wall${_FLAGS_${lang}}")
      #string(APPEND CMAKE_${lang}_FLAGS_DEBUG_INIT " /MDd -gline-tables-only -fno-inline -O0 ${_RTC1}")
      #string(APPEND CMAKE_${lang}_FLAGS_RELEASE_INIT " /MD -O2 -DNDEBUG")
      #string(APPEND CMAKE_${lang}_FLAGS_RELWITHDEBINFO_INIT " /MD -gline-tables-only -O2 -fno-inline -DNDEBUG")
      #string(APPEND CMAKE_${lang}_FLAGS_MINSIZEREL_INIT " /MD -DNDEBUG") # TODO: Add '-Os' once VS generator maps it properly for Clang
    else()
      #string(APPEND CMAKE_${lang}_FLAGS_INIT " ${_PLATFORM_DEFINES}${_PLATFORM_DEFINES_${lang}} /D_WINDOWS /W3${_FLAGS_${lang}}")
      #string(APPEND CMAKE_${lang}_FLAGS_DEBUG_INIT " /MDd /Zi /Ob0 /Od ${_RTC1}")
      #string(APPEND CMAKE_${lang}_FLAGS_RELEASE_INIT " /MD /O2 /Ob2 /DNDEBUG")
      #string(APPEND CMAKE_${lang}_FLAGS_RELWITHDEBINFO_INIT " /MD /Zi /O2 /Ob1 /DNDEBUG")
      #string(APPEND CMAKE_${lang}_FLAGS_MINSIZEREL_INIT " /MD /O1 /Ob1 /DNDEBUG")
    endif()
  endif()
endforeach()

#if(NOT CMAKE_RC_COMPILER_INIT)
#   set(CMAKE_RC_COMPILER_INIT rc)
#endif()
#if(NOT CMAKE_RC_FLAGS_INIT)
#   string(APPEND CMAKE_RC_FLAGS_INIT " ${_PLATFORM_DEFINES} ${_PLATFORM_DEFINES_${lang}}")
#endif()
#if(NOT CMAKE_RC_FLAGS_DEBUG_INIT)
#   string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT " /D_DEBUG")
#endif()

#enable_language(RC)

# you can set lib paths with , and libs with cmt (which will expand to libcmt.lib)
# PROBLEM: makes no difference, every one gets overridden by cmake/Modules/CMakeGenericSystem.cmake during PROJECT() in the CMakeLists
set(CMAKE_STATIC_LIBRARY_PREFIX  ""             CACHE STRING "Library prefix" FORCE)
SET(CMAKE_STATIC_LIBRARY_SUFFIX  ".lib"         CACHE STRING "Static library extension" FORCE)
set(CMAKE_SHARED_LIBRARY_PREFIX  ""             CACHE STRING "Library prefix" FORCE)
SET(CMAKE_SHARED_LIBRARY_SUFFIX  ".dll"         CACHE STRING "Shared library extension" FORCE)
set(CMAKE_SHARED_MODULE_PREFIX   ""             CACHE STRING "Library prefix" FORCE)
SET(CMAKE_SHARED_MODULE_SUFFIX   ".dll"         CACHE STRING "Shared library extension" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX      ".exe"         CACHE STRING "Executable extention" FORCE)
set(CMAKE_IMPORT_LIBRARY_PREFIX  ""             CACHE STRING "DLL Import lib suffix" FORCE)
set(CMAKE_IMPORT_LIBRARY_SUFFIX  ".lib"         CACHE STRING "DLL Import lib suffix" FORCE)
SET(CMAKE_LINK_LIBRARY_FLAG      ""             CACHE STRING "Linker's Libray flag" FORCE)
SET(CMAKE_LINK_LIBRARY_SUFFIX    ".lib"         CACHE STRING "Library extension" FORCE)
set(CMAKE_FIND_LIBRARY_PREFIXES "")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
set(CMAKE_C_OUTPUT_EXTENSION     ".obj"         CACHE STRING "C compiler object extension")
set(CMAKE_CXX_OUTPUT_EXTENSION   ".obj"         CACHE STRING "C++ compiler object extension")
SET(CMAKE_LIBRARY_PATH_FLAG      "/libpath:"    CACHE STRING "Linker's Library path flag" FORCE)
set(CMAKE_DL_LIBS "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

