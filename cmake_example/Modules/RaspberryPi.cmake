
# Toolchain for raspberry pi
# - on non-windows platforms
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules/RaspberryPi.cmake
#
# to setup RaspberryPi compiler toolchain, run the Platform/install-raspberrypi-*.sh scripts:
# - Platform/install-raspberrypi-toolchain.sh  # builds an SDK directory with base LLVM cross-compiler
# - Platform/install-raspberrypi-sysroot.sh    # copy lib/includes from working RaspberryPi to SDK directory
#

set(RASPBERRY 1)
set(RASPBERRYPI 1)
set(APPLE 0)
set(MSVC 0)
set(WIN32 0)
set(UNIX 1)

set(triple arm-linux-gnueabihf)

set(CMAKE_SYSTEM_NAME Linux CACHE INTERNAL "" FORCE)
SET(CMAKE_SYSTEM_VERSION 1  CACHE INTERNAL "" FORCE)
set(CMAKE_SYSTEM_PROCESSOR arm CACHE INTERNAL "" FORCE)
set(CMAKE_LIBRARY_ARCHITECTURE ${triple} CACHE INTERNAL "" FORCE)
set(ARCH arm CACHE INTERNAL "" FORCE)
set(CMAKE_CROSSCOMPILING 1 CACHE INTERNAL "" FORCE)

set( CMAKE_VERBOSE_MAKEFILE ON CACHE INTERNAL "" FORCE)


set( SDK $ENV{HOME}/RPI_SDK )
set( BINTOOLS ${SDK}/compiler )
set( SYSROOT ${SDK}/sysroot )
set( INCLUDE_PATH1 ${SYSROOT})
set( INCLUDE_PATH2 ${SYSROOT}/usr/include/c++/4.9)
set( INCLUDE_PATH3 ${SYSROOT}/usr/include/${triple}/c++/4.9)
set( LINKER_PATH ${SYSROOT}/usr/lib/gcc/${triple}/4.9)
set( LINKER_PATH2 ${SYSROOT}/usr/lib/${triple})
set( LINKER_PATH3 ${SYSROOT}/usr/lib/${triple}/pulseaudio)
set( LINKER_PATH4 ${SYSROOT}/lib/${triple})

INCLUDE_DIRECTORIES(AFTER SYSTEM ${INCLUDE_PATH1})
INCLUDE_DIRECTORIES(AFTER SYSTEM ${INCLUDE_PATH2})
INCLUDE_DIRECTORIES(AFTER SYSTEM ${INCLUDE_PATH3})

set(CMAKE_C_COMPILE_OPTIONS_SYSROOT "--sysroot=" CACHE INTERNAL "" FORCE)
set(CMAKE_CPP_COMPILE_OPTIONS_SYSROOT "--sysroot=" CACHE INTERNAL "" FORCE)

set(CMAKE_C_COMPILER ${BINTOOLS}/bin/clang CACHE INTERNAL "" FORCE)
set(CMAKE_C_COMPILER_TARGET ${triple} CACHE INTERNAL "" FORCE)
set(CMAKE_CXX_COMPILER ${BINTOOLS}/bin/clang++ CACHE INTERNAL "" FORCE)
set(CMAKE_CXX_COMPILER_TARGET ${triple} CACHE INTERNAL "" FORCE)
#set(CMAKE_C_COMPILER_ID Clang)
#set(CMAKE_CXX_COMPILER_ID Clang)

#set(CMAKE_<LANG>_COMPILER_EXTERNAL_TOOLCHAIN )


set(CMAKE_SYSROOT ${SYSROOT} CACHE INTERNAL "" FORCE)
SET(CMAKE_FIND_ROOT_PATH ${SYSROOT}  CACHE INTERNAL "" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE INTERNAL "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE INTERNAL "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE INTERNAL "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY CACHE INTERNAL "" FORCE)

# for -Wl,-rpath-link, and -Wl,-rpath,
SET(RPATH "${LINKER_PATH};${LINKER_PATH2};${LINKER_PATH3};${LINKER_PATH4}")
SET(LINK_PATHS "-L${LINKER_PATH} -L${LINKER_PATH2} -L${LINKER_PATH3} -L${LINKER_PATH4}")

# CMAKE_BUILD_RPATH generates -Wl,--rpath, flags for clang and clang++
# To be compatible, we enable the lld.gold llvm linker for clang, using -fuse-ld=gold
# The gold linker correctly interprets --rpath, otherwise we would need -Wl,--rpath-link, for the bfd linker

SET(INSTALL_RPATH ${RPATH} CACHE INTERNAL "" FORCE)
SET(CMAKE_INSTALL_RPATH ${RPATH} CACHE INTERNAL "" FORCE)
SET(CMAKE_BUILD_RPATH ${RPATH} CACHE INTERNAL "" FORCE)
SET(BUILD_RPATH ${RPATH} CACHE INTERNAL "" FORCE)

SET(CMAKE_SKIP_RPATH False CACHE INTERNAL "" FORCE)

SET(CMAKE_SKIP_BUILD_RPATH False CACHE INTERNAL "" FORCE)
SET(SKIP_BUILD_RPATH False CACHE INTERNAL "" FORCE)

SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH True CACHE INTERNAL "" FORCE)
SET(INSTALL_RPATH_USE_LINK_PATH True CACHE INTERNAL "" FORCE)

SET(CMAKE_BUILD_WITH_INSTALL_RPATH True CACHE INTERNAL "" FORCE)
SET(BUILD_WITH_INSTALL_RPATH True CACHE INTERNAL "" FORCE)


# -mtls-dialect=gnu2              # doesn't work with clang
# -Otime                          # doesn't work with clang
# -mvectorize-with-neon-quad      # doesn't work with clang

SET( PI_DEFAULT_RELEASE_FLAGS "-O3 -DNDEBUG" )
SET( PI1_RELEASE_FLAGS "-mcpu=arm1176jzf-s  -mfpu=vfp  -march=armv7-a -mtune=arm1176jzf-s" )
SET( PI2_RELEASE_FLAGS "-mcpu=cortex-a7  -mfpu=neon-vfpv4  -march=armv7-a -mtune=cortex-a7" )
SET( PI3_RELEASE_FLAGS "-mcpu=cortex-a53  -mfpu=neon-fp-armv8 -march=armv8-a+crc -mtune=cortex-a53" )
SET( PI4_RELEASE_FLAGS "-mcpu=cortex-a72  -mfpu=neon-fp-armv8 -march=armv8-a+crc -mtune=cortex-a72" )
SET( PI_RELEASE_FLAGS "${PI_DEFAULT_RELEASE_FLAGS} -O3 -DNDEBUG -marm -mabi=aapcs-linux -mfloat-abi=hard -funsafe-math-optimizations -mhard-float -mlittle-endian -mno-unaligned-access" CACHE INTERNAL "" FORCE )

# to choose between these you'll need to define CMAKE_BUILD_TYPE
# options: Debug, Release, RelWithDebInfo, MinSizeRel
# e.g.
#   cmake -DCMAKE_BUILD_TYPE=Release
SET (CMAKE_C_FLAGS_DEBUG          "-g" CACHE INTERNAL "" FORCE)
SET (CMAKE_C_FLAGS_MINSIZEREL     "-Os -DNDEBUG" CACHE INTERNAL "" FORCE)
SET (CMAKE_C_FLAGS_RELEASE        "-O3 -DNDEBUG" CACHE INTERNAL "" FORCE)
SET (CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g" CACHE INTERNAL "" FORCE)

SET (CMAKE_CXX_FLAGS_DEBUG          "-g" CACHE INTERNAL "" FORCE)
SET (CMAKE_CXX_FLAGS_MINSIZEREL     "-Os -DNDEBUG" CACHE INTERNAL "" FORCE)
SET (CMAKE_CXX_FLAGS_RELEASE        "${PI_RELEASE_FLAGS}" CACHE INTERNAL "" FORCE)
SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g" CACHE INTERNAL "" FORCE)

SET(CMAKE_C_FLAGS "" CACHE INTERNAL "" FORCE)
SET(CMAKE_CXX_FLAGS "" CACHE INTERNAL "" FORCE)
#SET(LINK_RPATH "-Wl,-rpath-link,${RPATH}")
SET(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=gold -Wl,--as-needed " CACHE INTERNAL "" FORCE)
SET(CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=gold -Wl,--no-undefined -Wl,--as-needed" CACHE INTERNAL "" FORCE)
SET(CMAKE_STATIC_LINKER_FLAGS "" CACHE INTERNAL "" FORCE)
SET(CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=gold -Wl,--as-needed " CACHE INTERNAL "" FORCE)

# from add_definitions (older cmake) / add_compile_options (newer cmake)
#message( "COMPILE_DEFINITIONS ${CMAKE_C_FLAGS}" ) 
#message( "CMAKE_C_FLAGS ${CMAKE_C_FLAGS}" )
#message( "CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}" )
#message( "CMAKE_C_FLAGS_INIT ${CMAKE_C_FLAGS_INIT}" )
#message( "CMAKE_CXX_FLAGS_INIT ${CMAKE_CXX_FLAGS_INIT}" )
#message( "CMAKE_C_FLAGS_RELEASE_INIT ${CMAKE_C_FLAGS_RELEASE_INIT}" )
#message( "CMAKE_CXX_FLAGS_RELEASE_INIT ${CMAKE_CXX_FLAGS_RELEASE_INIT}" )


SET (CMAKE_AR      ${BINTOOLS}/bin/llvm-ar  CACHE INTERNAL "" FORCE)
SET (CMAKE_LINKER  ${BINTOOLS}/bin/arm-linux-gnueabihf-ld.gold  CACHE INTERNAL "" FORCE)
SET (CMAKE_NM      ${BINTOOLS}/bin/llvm-nm  CACHE INTERNAL "" FORCE)
SET (CMAKE_OBJDUMP ${BINTOOLS}/bin/llvm-objdump  CACHE INTERNAL "" FORCE)
SET (CMAKE_RANLIB  ${BINTOOLS}/bin/llvm-ranlib  CACHE INTERNAL "" FORCE)

