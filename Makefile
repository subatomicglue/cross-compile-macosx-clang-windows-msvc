
# Clang/MSVC Compatibility Notes:
# https://clang.llvm.org/docs/MSVCCompatibility.html
# Install on MacOSX:  brew install llvm

ARCH32=x86
ARCH64=x64
ARCH=$(ARCH64) # set to either one, and the right stuff will get chosen
DEFINES=-std=c++11 #-fno-rtti -fno-exceptions -D_HAS_EXCEPTIONS=0 -D_ITERATOR_DEBUG_LEVEL=0
_MSC_VER=1900 # 1800=VC2013, 1900=VC2015, 1910=VC2017 / others: https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B
PROGRAMFILES=/Volumes/[C] Windows 10/Program Files (x86)

# compiler system paths
UniversalCRT_IncludePath="$(PROGRAMFILES)/Windows Kits/10/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib="$(PROGRAMFILES)/Windows Kits/10/Lib/10.0.10150.0/ucrt/$(ARCH)"
MSVC_INCLUDE="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/include"
MSVC_LIB="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/lib$(if $(filter $(ARCH),x64),/amd64,)"
WINSDK_LIB="$(PROGRAMFILES)/Windows Kits/8.1/Lib/winv6.3/um/$(ARCH)"

UniversalCRT_IncludePath32="$(PROGRAMFILES)/Windows Kits/10/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib32="$(PROGRAMFILES)/Windows Kits/10/Lib/10.0.10150.0/ucrt/$(ARCH32)"
MSVC_INCLUDE32="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/include"
MSVC_LIB32="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/lib$(if $(filter $(ARCH32),x64),/amd64,)"
WINSDK_LIB32="$(PROGRAMFILES)/Windows Kits/8.1/Lib/winv6.3/um/$(ARCH32)"

UniversalCRT_IncludePath64="$(PROGRAMFILES)/Windows Kits/10/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib64="$(PROGRAMFILES)/Windows Kits/10/Lib/10.0.10150.0/ucrt/$(ARCH64)"
MSVC_INCLUDE64="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/include"
MSVC_LIB64="$(PROGRAMFILES)/Microsoft Visual Studio 14.0/VC/lib$(if $(filter $(ARCH64),x64),/amd64,)"
WINSDK_LIB64="$(PROGRAMFILES)/Windows Kits/8.1/Lib/winv6.3/um/$(ARCH64)"

# options seem to be 64bit: x86_64-pc-windows-msvc, i686-pc-windows-msvc;  or 32bit: i386-pc-win32
TARGET=$(if $(filter $(ARCH),x64),x86_64-pc-windows-msvc,i386-pc-win32)
TARGET_32=i386-pc-win32
TARGET_64=x86_64-pc-windows-msvc
SYSTEM=-target $(TARGET) -isystem $(MSVC_INCLUDE) -isystem $(UniversalCRT_IncludePath)
SYSTEM_32=-target $(TARGET_32) -isystem $(MSVC_INCLUDE) -isystem $(UniversalCRT_IncludePath)
SYSTEM_64=-target $(TARGET_64) -isystem $(MSVC_INCLUDE) -isystem $(UniversalCRT_IncludePath)

# compiler binaries

# GCC lookalikes
C=/usr/local/opt/llvm/bin/clang $(SYSTEM) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing
CPP=/usr/local/opt/llvm/bin/clang++ $(SYSTEM) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing
C32=/usr/local/opt/llvm/bin/clang $(SYSTEM_32) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing
CPP32=/usr/local/opt/llvm/bin/clang++ $(SYSTEM_32) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing
C64=/usr/local/opt/llvm/bin/clang $(SYSTEM_64) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing
CPP64=/usr/local/opt/llvm/bin/clang++ $(SYSTEM_64) -fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing

# clang's version of MSVC cl.exe compiler
CL=/usr/local/opt/llvm/bin/clang-cl

# clang's version of MSVC link.exe linker
LINK=/usr/local/opt/llvm/bin/lld -flavor link /libpath:$(MSVC_LIB) /libpath:$(UniversalCRT_Lib) /libpath:$(WINSDK_LIB)
LINK32=/usr/local/opt/llvm/bin/lld -flavor link /libpath:$(MSVC_LIB32) /libpath:$(UniversalCRT_Lib32) /libpath:$(WINSDK_LIB32)
LINK64=/usr/local/opt/llvm/bin/lld -flavor link /libpath:$(MSVC_LIB64) /libpath:$(UniversalCRT_Lib64) /libpath:$(WINSDK_LIB64)
#LINK=/usr/local/opt/llvm/bin/lld-link


all:
	@echo "==================="
	@echo "settings:"
	@echo "UniversalCRT_IncludePath: " $(UniversalCRT_IncludePath)
	@echo "UniversalCRT_Lib: " $(UniversalCRT_Lib)
	@echo "MSVC_INCLUDE:    " $(MSVC_INCLUDE)
	@echo "MSVC_LIB:        " $(MSVC_LIB)
	@echo "WINSDK_LIB:      " $(WINSDK_LIB)
	@echo "==================="
	@echo "compile some 64bit C++"
	$(CPP64) $(DEFINES) -c main.cpp -o mainCPP-x64.o
	$(LINK64) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x64.exe mainCPP-x64.o
	@echo "==================="
	@echo "compile some 64bit C"
	$(C64) -c main.c -o mainC-x64.o
	$(LINK64) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x64.exe mainC-x64.o
	@echo "==================="
	@echo "compile some 32bit C++"
	$(CPP32) $(DEFINES) -c main.cpp -o mainCPP-x86.o
	$(LINK32) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x86.exe mainCPP-x86.o
	@echo "==================="
	@echo "compile some 32bit  C"
	$(C32) -c main.c -o mainC-x86.o
	$(LINK32) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x86.exe mainC-x86.o

clean:
	rm *.o *.exe

