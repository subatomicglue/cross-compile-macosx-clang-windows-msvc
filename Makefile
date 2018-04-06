
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
TARGET=-target $(if $(filter $(ARCH),x64),x86_64-pc-windows-msvc,i386-pc-win32)
TARGET_32=-target i386-pc-win32
TARGET_64=-target x86_64-pc-windows-msvc
TARGETCL=/arch:$(if $(filter $(ARCH),x64),-m64,-m32)
TARGETCL_32=-m32 /arch:SSE2
TARGETCL_64=-m64 /arch:AVX2
SYSTEM_INC=-isystem $(MSVC_INCLUDE) -isystem $(UniversalCRT_IncludePath)
SYSTEM_INC_32=-isystem $(MSVC_INCLUDE32) -isystem $(UniversalCRT_IncludePath32)
SYSTEM_INC_64=-isystem $(MSVC_INCLUDE64) -isystem $(UniversalCRT_IncludePath64)
SYSTEMCL_INC=/imsvc $(MSVC_INCLUDE) /imsvc $(UniversalCRT_IncludePath)
SYSTEMCL_INC_32=/imsvc $(MSVC_INCLUDE32) /imsvc $(UniversalCRT_IncludePath32)
SYSTEMCL_INC_64=/imsvc $(MSVC_INCLUDE64) /imsvc $(UniversalCRT_IncludePath64)
SYSTEM_LIB_INC=/libpath:$(MSVC_LIB) /libpath:$(UniversalCRT_Lib) /libpath:$(WINSDK_LIB)
SYSTEM_LIB_INC_32=/libpath:$(MSVC_LIB32) /libpath:$(UniversalCRT_Lib32) /libpath:$(WINSDK_LIB32)
SYSTEM_LIB_INC_64=/libpath:$(MSVC_LIB64) /libpath:$(UniversalCRT_Lib64) /libpath:$(WINSDK_LIB64)
SYSTEM_LIBGCC_INC=-L$(MSVC_LIB) -L$(UniversalCRT_Lib) -L$(WINSDK_LIB)
SYSTEM_LIBGCC_INC_32=-L$(MSVC_LIB32) -L$(UniversalCRT_Lib32) -L$(WINSDK_LIB32)
SYSTEM_LIBGCC_INC_64=-L$(MSVC_LIB64) -L$(UniversalCRT_Lib64) -L$(WINSDK_LIB64)
SYSTEM_FLAGS=-fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing

# compiler binaries

# clang compiler (GCC lookalike)
C=/usr/local/opt/llvm/bin/clang $(TARGET) $(SYSTEM_INC) $(SYSTEM_FLAGS)
CPP=/usr/local/opt/llvm/bin/clang++ $(TARGET) $(SYSTEM_INC)  $(SYSTEM_FLAGS)
C32=/usr/local/opt/llvm/bin/clang $(TARGET_32) $(SYSTEM_INC_32)  $(SYSTEM_FLAGS)
CPP32=/usr/local/opt/llvm/bin/clang++ $(TARGET_32) $(SYSTEM_INC_32)  $(SYSTEM_FLAGS)
C64=/usr/local/opt/llvm/bin/clang $(TARGET_64) $(SYSTEM_INC_64)  $(SYSTEM_FLAGS)
CPP64=/usr/local/opt/llvm/bin/clang++ $(TARGET_64)  $(SYSTEM_INC_64)  $(SYSTEM_FLAGS)

# clang linker (MSVC link.exe lookalike)
LDD=/usr/local/opt/llvm/bin/lld -flavor link $(SYSTEM_LIB_INC)
LDD32=/usr/local/opt/llvm/bin/lld -flavor link $(SYSTEM_LIB_INC_32)
LDD64=/usr/local/opt/llvm/bin/lld -flavor link $(SYSTEM_LIB_INC_64)

# clang's version of MSVC cl.exe compiler
CL=/usr/local/opt/llvm/bin/clang-cl $(TARGETCL) $(SYSTEMCL_INC) $(SYSTEM_FLAGS)
CL32=/usr/local/opt/llvm/bin/clang-cl $(TARGETCL_32) $(SYSTEMCL_INC_32) $(SYSTEM_FLAGS)
CL64=/usr/local/opt/llvm/bin/clang-cl $(TARGETCL_64) $(SYSTEMCL_INC_64) $(SYSTEM_FLAGS)

# clang's version of MSVC link.exe linker
LINK=/usr/local/opt/llvm/bin/lld-link $(SYSTEM_LIB_INC)
LINK32=/usr/local/opt/llvm/bin/lld-link $(SYSTEM_LIB_INC_32)
LINK64=/usr/local/opt/llvm/bin/lld-link $(SYSTEM_LIB_INC_64)


all:
	@echo "==================="
	@echo "settings:"
	@echo "UniversalCRT_IncludePath: " $(UniversalCRT_IncludePath)
	@echo "UniversalCRT_Lib: " $(UniversalCRT_Lib)
	@echo "MSVC_INCLUDE:    " $(MSVC_INCLUDE)
	@echo "MSVC_LIB:        " $(MSVC_LIB)
	@echo "WINSDK_LIB:      " $(WINSDK_LIB)
	@echo "==================="
	@echo "cland/lld compile some 64bit C++"
	$(CPP64) $(DEFINES) -c main.cpp -o mainCPP-x64.o
	$(LDD64) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x64.exe mainCPP-x64.o
	@echo "==================="
	@echo "clang/lld compile some 64bit C"
	$(C64) -c main.c -o mainC-x64.o
	$(LDD64) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x64.exe mainC-x64.o
	@echo "==================="
	@echo "clang/lld compile some 32bit C++"
	$(CPP32) $(DEFINES) -c main.cpp -o mainCPP-x86.o
	$(LDD32) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x86.exe mainCPP-x86.o
	@echo "==================="
	@echo "clang/lld compile some 32bit  C"
	$(C32) -c main.c -o mainC-x86.o
	$(LDD32) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x86.exe mainC-x86.o

# compile using clang-cl and ldd-link
cl:
	@echo "==================="
	@echo "settings:"
	@echo "UniversalCRT_IncludePath: " $(UniversalCRT_IncludePath)
	@echo "UniversalCRT_Lib: " $(UniversalCRT_Lib)
	@echo "MSVC_INCLUDE:    " $(MSVC_INCLUDE)
	@echo "MSVC_LIB:        " $(MSVC_LIB)
	@echo "WINSDK_LIB:      " $(WINSDK_LIB)
	@echo "==================="
	@echo "cl/link compile some 64bit C++"
	$(CL64) /c /Tpmain.cpp /omainCPP-x64.o
	$(LINK64) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x64.exe mainCPP-x64.o
	@echo "==================="
	@echo "cl/link compile some 64bit C"
	$(CL64) /c /Tcmain.c /omainC-x64.o
	$(LINK64) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x64.exe mainC-x64.o
	@echo "==================="
	@echo "cl/link compile some 32bit C++"
	$(CL32) /c /Tpmain.cpp /omainCPP-x86.o
	$(LINK32) libucrt.lib libcmt.lib /subsystem:console /out:mainCPP-x86.exe mainCPP-x86.o
	@echo "==================="
	@echo "cl/link compile some 32bit  C"
	$(CL32) /c /Tcmain.c /omainC-x86.o
	$(LINK32) libucrt.lib libcmt.lib /subsystem:console /out:mainC-x86.exe mainC-x86.o

clean:
	rm *.o *.exe

