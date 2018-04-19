
# Clang/MSVC Compatibility Notes:
# https://clang.llvm.org/docs/MSVCCompatibility.html
# Install on MacOSX:  brew install llvm

ARCH32=x86
ARCH64=x64
ARCH=$(ARCH64) # set to either one, and the right stuff will get chosen
DEFINES=-DWIN32 -std=c++11 #-fno-rtti -fno-exceptions -D_HAS_EXCEPTIONS=0 -D_ITERATOR_DEBUG_LEVEL=0
_MSC_VER=1900 # 1800=VC2013, 1900=VC2015, 1910=VC2017 / others: https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B
SRC=../src
LIBS=libcmt.lib

# base locations of MSVC toolchain:
# search location #1
PROGRAMFILES_PATH1=$(HOME)/MSVC
# search location #2
PROGRAMFILES_PATH2=/Volumes/[C] Windows 10/Program Files (x86)
PROGRAMFILES_PATH=$(shell if [ -d "$(PROGRAMFILES_PATH1)" ]; then echo "$(PROGRAMFILES_PATH1)"; else echo "$(PROGRAMFILES_PATH2)"; fi )
WINDOWS_KITS10_PATH=$(PROGRAMFILES_PATH)/Windows Kits/10
WINDOWS_KITS81_PATH=$(PROGRAMFILES_PATH)/Windows Kits/8.1
MSVC_PATH=$(PROGRAMFILES_PATH)/Microsoft Visual Studio 14.0/VC
LLVM_PATH=/usr/local/opt/llvm/bin

# MSVC system INCLUDE and LIB paths
UniversalCRT_IncludePath="$(WINDOWS_KITS10_PATH)/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib="$(WINDOWS_KITS10_PATH)/Lib/10.0.10150.0/ucrt/$(ARCH)"
MSVC_INCLUDE="$(MSVC_PATH)/include"
MSVC_LIB="$(MSVC_PATH)/lib$(if $(filter $(ARCH),x64),/amd64,)"
WINSDK_INC="$(WINDOWS_KITS81_PATH)/Include/um"
WINSDK_SHARED__INC="$(WINDOWS_KITS81_PATH)/Include/shared"
WINSDK_LIB="$(WINDOWS_KITS81_PATH)/Lib/winv6.3/um/$(ARCH)"

UniversalCRT_IncludePath32="$(WINDOWS_KITS10_PATH)/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib32="$(WINDOWS_KITS10_PATH)/Lib/10.0.10150.0/ucrt/$(ARCH32)"
MSVC_INCLUDE32="$(MSVC_PATH)/include"
MSVC_LIB32="$(MSVC_PATH)/lib$(if $(filter $(ARCH32),x64),/amd64,)"
WINSDK_INC32="$(WINDOWS_KITS81_PATH)/Include/um"
WINSDK_SHARED_INC32="$(WINDOWS_KITS81_PATH)/Include/shared"
WINSDK_LIB32="$(WINDOWS_KITS81_PATH)/Lib/winv6.3/um/$(ARCH32)"

UniversalCRT_IncludePath64="$(WINDOWS_KITS10_PATH)/Include/10.0.10150.0/ucrt"
UniversalCRT_Lib64="$(WINDOWS_KITS10_PATH)/Lib/10.0.10150.0/ucrt/$(ARCH64)"
MSVC_INCLUDE64="$(MSVC_PATH)/include"
MSVC_LIB64="$(MSVC_PATH)/lib$(if $(filter $(ARCH64),x64),/amd64,)"
WINSDK_INC64="$(WINDOWS_KITS81_PATH)/Include/um"
WINSDK_SHARED_INC64="$(WINDOWS_KITS81_PATH)/Include/shared"
WINSDK_LIB64="$(WINDOWS_KITS81_PATH)/Lib/winv6.3/um/$(ARCH64)"

# options seem to be 64bit: x86_64-pc-windows-msvc, i686-pc-windows-msvc;  or 32bit: i386-pc-win32
TARGET=-target $(if $(filter $(ARCH),x64),x86_64-pc-windows-msvc,i386-pc-win32)
TARGET_32=-target i386-pc-win32 -m32
TARGET_64=-target x86_64-pc-windows-msvc -m64
TARGETCL=/arch:$(if $(filter $(ARCH),x64),-m64,-m32)
TARGETCL_32=-m32 /arch:SSE2
TARGETCL_64=-m64 /arch:AVX2
SYSTEM_INC=-isystem $(MSVC_INCLUDE) -isystem $(UniversalCRT_IncludePath) -isystem $(WINSDK_INC) -isystem $(WINSDK_SHARED_INC)
SYSTEM_INC_32=-isystem $(MSVC_INCLUDE32) -isystem $(UniversalCRT_IncludePath32) -isystem $(WINSDK_INC32) -isystem $(WINSDK_SHARED_INC32)
SYSTEM_INC_64=-isystem $(MSVC_INCLUDE64) -isystem $(UniversalCRT_IncludePath64) -isystem $(WINSDK_INC64) -isystem $(WINSDK_SHARED_INC64)
SYSTEMCL_INC=/imsvc $(MSVC_INCLUDE) /imsvc $(UniversalCRT_IncludePath) /imsvc $(WINSDK_INC) /imsvc $(WINSDK_SHARED_INC)
SYSTEMCL_INC_32=/imsvc $(MSVC_INCLUDE32) /imsvc $(UniversalCRT_IncludePath32) /imsvc $(WINSDK_INC32) /imsvc $(WINSDK_SHARED_INC32)
SYSTEMCL_INC_64=/imsvc $(MSVC_INCLUDE64) /imsvc $(UniversalCRT_IncludePath64) /imsvc $(WINSDK_INC64) /imsvc $(WINSDK_SHARED_INC64)
SYSTEM_LIB_INC=/libpath:$(MSVC_LIB) /libpath:$(UniversalCRT_Lib) /libpath:$(WINSDK_LIB)
SYSTEM_LIB_INC_32=/libpath:$(MSVC_LIB32) /libpath:$(UniversalCRT_Lib32) /libpath:$(WINSDK_LIB32)
SYSTEM_LIB_INC_64=/libpath:$(MSVC_LIB64) /libpath:$(UniversalCRT_Lib64) /libpath:$(WINSDK_LIB64)
SYSTEM_LIBGCC_INC=-L$(MSVC_LIB) -L$(UniversalCRT_Lib) -L$(WINSDK_LIB)
SYSTEM_LIBGCC_INC_32=-L$(MSVC_LIB32) -L$(UniversalCRT_Lib32) -L$(WINSDK_LIB32)
SYSTEM_LIBGCC_INC_64=-L$(MSVC_LIB64) -L$(UniversalCRT_Lib64) -L$(WINSDK_LIB64)
SYSTEM_FLAGS=-fmsc-version=$(_MSC_VER) -fms-extensions -fms-compatibility -fdelayed-template-parsing

# llvm compiler binaries (tested with clang version 6.0.0 (tags/RELEASE_600/final))

# clang compiler (GCC lookalike)
C=$(LLVM_PATH)/clang $(TARGET) $(SYSTEM_INC) $(SYSTEM_FLAGS)
CPP=$(LLVM_PATH)/clang++ $(TARGET) $(SYSTEM_INC)  $(SYSTEM_FLAGS)
C32=$(LLVM_PATH)/clang $(TARGET_32) $(SYSTEM_INC_32)  $(SYSTEM_FLAGS)
CPP32=$(LLVM_PATH)/clang++ $(TARGET_32) $(SYSTEM_INC_32)  $(SYSTEM_FLAGS)
C64=$(LLVM_PATH)/clang $(TARGET_64) $(SYSTEM_INC_64)  $(SYSTEM_FLAGS)
CPP64=$(LLVM_PATH)/clang++ $(TARGET_64)  $(SYSTEM_INC_64)  $(SYSTEM_FLAGS)

# clang lld linker (MSVC link.exe lookalike)
LDD=$(LLVM_PATH)/lld -flavor link $(SYSTEM_LIB_INC)
LDD32=$(LLVM_PATH)/lld -flavor link $(SYSTEM_LIB_INC_32)
LDD64=$(LLVM_PATH)/lld -flavor link $(SYSTEM_LIB_INC_64)

# clang's version of MSVC cl.exe compiler
CL=$(LLVM_PATH)/clang-cl $(TARGETCL) $(SYSTEMCL_INC) $(SYSTEM_FLAGS)
CL32=$(LLVM_PATH)/clang-cl $(TARGETCL_32) $(SYSTEMCL_INC_32) $(SYSTEM_FLAGS)
CL64=$(LLVM_PATH)/clang-cl $(TARGETCL_64) $(SYSTEMCL_INC_64) $(SYSTEM_FLAGS)

# clang's version of MSVC link.exe linker
LINK=$(LLVM_PATH)/lld-link $(SYSTEM_LIB_INC)
LINK32=$(LLVM_PATH)/lld-link $(SYSTEM_LIB_INC_32)
LINK64=$(LLVM_PATH)/lld-link $(SYSTEM_LIB_INC_64)

# llvm's version of MSVC lib.exe
# /usr/local/opt/llvm/bin/llvm-lib /libpath:<path>] [/out:<output>] [/llvmlibthin] [/ignore] [/machine] [/nologo] [files…]
LIB=$(LLVM_PATH)/llvm-lib $(SYSTEM_LIB_INC) /nologo
LIB32=$(LLVM_PATH)/llvm-lib $(SYSTEM_LIB_INC_32) /nologo
LIB64=$(LLVM_PATH)/llvm-lib $(SYSTEM_LIB_INC_64) /nologo

# llvm's version of MSVC rc.exe resource compiler
RC=$(LLVM_PATH)/llvm-rc

all: exe execl lib dll

# executable - compile and link windows .exe
# using clang/clang++ -target and lld -flavor link
exe:
	@echo "\n==================="
	@echo "create 64bit C++ Executable (.exe)  (using clang++ & lld)"
	$(CPP64) $(DEFINES) -c $(SRC)/main.cpp -o mainCPP-x64.o
	$(LDD64) $(LIBS) /subsystem:console /out:mainCPP-x64.exe mainCPP-x64.o
	@echo "\n==================="
	@echo "create 64bit C Executable (.exe)  (using clang & lld)"
	$(C64) -c $(SRC)/main.c -o mainC-x64.o
	$(LDD64) $(LIBS) /subsystem:console /out:mainC-x64.exe mainC-x64.o
	@echo "\n==================="
	@echo "create 32bit C++ Executable (.exe)  (using clang++ & lld)"
	$(CPP32) $(DEFINES) -c $(SRC)/main.cpp -o mainCPP-x86.o
	$(LDD32) $(LIBS) /subsystem:console /out:mainCPP-x86.exe mainCPP-x86.o
	@echo "\n==================="
	@echo "create 32bit C Executable (.exe)  (using clang & lld)"
	$(C32) -c $(SRC)/main.c -o mainC-x86.o
	$(LDD32) $(LIBS) /subsystem:console /out:mainC-x86.exe mainC-x86.o

# executable - compile and link windows .exe
# using clang-cl and lld-link
execl:
	@echo "\n==================="
	@echo "create 64bit C++ Executable (.exe) (using clang-cl & lld-link)"
	$(CL64) /c /Tp$(SRC)/main.cpp /omainCPP-x64.o
	$(LINK64) $(LIBS) /subsystem:console /out:mainCPP-x64-cl.exe mainCPP-x64.o
	@echo "\n==================="
	@echo "create 64bit C Executable (.exe) (using clang-cl & lld-link)"
	$(CL64) /c /Tc$(SRC)/main.c /omainC-x64.o
	$(LINK64) $(LIBS) /subsystem:console /out:mainC-x64-cl.exe mainC-x64.o
	@echo "\n==================="
	@echo "create 32bit C++ Executable (.exe) (using clang-cl & lld-link)"
	$(CL32) /c /Tp$(SRC)/main.cpp /omainCPP-x86.o
	$(LINK32) $(LIBS) /subsystem:console /out:mainCPP-x86-cl.exe mainCPP-x86.o
	@echo "\n==================="
	@echo "create 32bit  C Executable (.exe) (using clang-cl & lld-link)"
	$(CL32) /c /Tc$(SRC)/main.c /omainC-x86.o
	$(LINK32) $(LIBS) /subsystem:console /out:mainC-x86-cl.exe mainC-x86.o

# static linking - compile .lib and link into a windows .exe
# using clang-cl and lld-link
lib:
	@echo "\n==================="
	@echo "create 64bit C++ Library (.lib)"
	$(CPP64) $(DEFINES) -c $(SRC)/lib.cpp -o lib-x64.o
	$(LIB64) /out:lib-x64.lib lib-x64.o
	@echo "\nstatically link that lib into a 64bit Executable (.exe)"
	$(CPP64) $(DEFINES) -c $(SRC)/libmain.cpp -o libmain-x64.o
	$(LINK64) $(LIBS) lib-x64.lib /subsystem:console /out:libmain-x64.exe libmain-x64.o
	@echo "\n==================="
	@echo "create 32bit C++ Library (.lib)"
	$(CPP32) $(DEFINES) -c $(SRC)/lib.cpp -o lib-x86.o
	$(LIB32) /out:lib-x86.lib lib-x86.o
	@echo "\nstatically link that lib into a 64bit Executable (.exe)"
	$(CPP32) $(DEFINES) -c $(SRC)/libmain.cpp -o libmain-x86.o
	$(LINK32) $(LIBS) lib-x86.lib /subsystem:console /out:libmain-x86.exe libmain-x86.o


# dynamic linking - compile .lib/.dll and link into a windows .exe
# dynamic loading - create a standalone windows .exe which loads a dll, retreives a function, and calls it
# using clang++ and lld-link
dll:
	@echo "\n==================="
	@echo "compile windows resource (.rc => .res)"
	$(RC) /FO resource.res $(SRC)/resource.rc
	@echo "\n==================="
	@echo "create 64bit C++ DLL (.lib/.dll)"
	$(CPP64) $(DEFINES) -c $(SRC)/dll.cpp -o dll-x64.o
	$(LINK64) $(LIBS) resource.res /dll /out:dll-x64.dll dll-x64.o
	@echo "\ndynamic link DLL into a 64bit Executable (.exe)"
	$(CPP64) $(DEFINES) -c $(SRC)/dllmain.cpp -o dllmain-x64.o
	$(LINK64) $(LIBS) resource.res dll-x64.lib /subsystem:console /out:dllmain-x64.exe dllmain-x64.o
	@echo "\ncreate 64bit C++ Plugin DLL (.dll)"
	$(CPP64) $(DEFINES) -c $(SRC)/plugin.cpp -o plugin-x64.o
	$(LINK64) $(LIBS) resource.res /dll /def:$(SRC)/definition.def /out:plugin-x64.dll plugin-x64.o
	rm plugin-x64.lib
	@echo "\ndynamic load DLL from a 64bit standalone Executable (.exe)"
	$(CPP64) $(DEFINES) -c $(SRC)/pluginmain.cpp -o pluginmain-x64.o
	$(LINK64) $(LIBS) resource.res /subsystem:console /out:pluginmain-x64.exe pluginmain-x64.o
	@echo "\n==================="
	@echo "create 32bit C++ DLL (.lib/.dll)"
	$(CPP32) $(DEFINES) -c $(SRC)/dll.cpp -o dll-x86.o
	$(LINK32) $(LIBS) resource.res /dll /out:dll-x86.dll dll-x86.o
	@echo "\ndynamic link DLL into a 32bit Executable (.exe)"
	$(CPP32) $(DEFINES) -c $(SRC)/dllmain.cpp -o dllmain-x86.o
	$(LINK32) $(LIBS) resource.res dll-x86.lib /subsystem:console /out:dllmain-x86.exe dllmain-x86.o
	@echo "\ncreate 32bit C++ Plugin DLL (.dll)"
	$(CPP32) $(DEFINES) -c $(SRC)/plugin.cpp -o plugin-x86.o
	$(LINK32) $(LIBS) resource.res /dll /def:$(SRC)/definition.def /out:plugin-x86.dll plugin-x86.o
	rm plugin-x86.lib
	@echo "\ndynamic load DLL from a 32bit standalone Executable (.exe)"
	$(CPP32) $(DEFINES) -c $(SRC)/pluginmain.cpp -o pluginmain-x86.o
	$(LINK32) $(LIBS) resource.res /subsystem:console /out:pluginmain-x86.exe pluginmain-x86.o



clean:
	rm -f *.o *.exe *.dll *.lib *.obj *.res

