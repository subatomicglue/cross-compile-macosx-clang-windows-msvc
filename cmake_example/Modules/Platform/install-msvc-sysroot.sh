
dest="$HOME/MSVC_SDK/sysroot"

# currently support 2013 (12) and 2015 (14)

if [ "$#" -ne 2 ]; then
   echo "This script will copy your MSVC2013 or 2015 inc/lib dir tree to your home directory under $dest"
   echo "Just provide:"
   echo " - the base of your MSVC (usually Program Files (x86))"
   echo " - the version on your .../Microsoft Visual Studio XX.0/VC/ directory with the inc/libs"
   echo ""
   echo "usage: $0 \"/Volumes/C/Program Files (x86)\" 12|14"
   echo ""
   exit -1
fi

echo "destination: $dest"

rm -rf "$dest/Microsoft Visual Studio 12.0"
rm -rf "$dest/Microsoft Visual Studio 14.0"
rm -rf "$dest/Windows Kits"
rm -rf "$dest/DXSDK"

# Copy the DIRECT X SDK
mkdir -p "$dest/DXSDK"
if [ -d "$1/Microsoft DirectX SDK (June 2010)" ]; then
  echo " - Microsoft DirectX SDK (June 2010)"
  cp -r "$1/Microsoft DirectX SDK (June 2010)/Include" "$dest/DXSDK/"
  cp -r "$1/Microsoft DirectX SDK (June 2010)/Lib" "$dest/DXSDK/"
  cp -r "$1/Microsoft DirectX SDK (June 2010)/Developer Runtime" "$dest/DXSDK/"
fi

# Copy MSVC SDK
if [ $2 -eq 12 ]; then
   echo " - $dest/Microsoft Visual Studio 12.0"
   echo " - $dest/Windows Kits"
   mkdir -p "$dest/Microsoft Visual Studio 12.0/VC"
   mkdir -p "$dest/Windows Kits/8.0"
   mkdir -p "$dest/Windows Kits/8.1"
   cp -r "$1/Microsoft Visual Studio 12.0/VC/include" "$dest/Microsoft Visual Studio 12.0/VC/"
   cp -r "$1/Microsoft Visual Studio 12.0/VC/lib" "$dest/Microsoft Visual Studio 12.0/VC/"
   cp -r "$1/Windows Kits/8.0/Include" "$dest/Windows Kits/8.0/"
   cp -r "$1/Windows Kits/8.0/Lib" "$dest/Windows Kits/8.0/"
   cp -r "$1/Windows Kits/8.1/Include" "$dest/Windows Kits/8.1/"
   cp -r "$1/Windows Kits/8.1/Lib" "$dest/Windows Kits/8.1/"
elif [ $2 -eq 14 ]; then
   echo " - $dest/Microsoft Visual Studio 14.0"
   echo " - $dest/Windows Kits"
   mkdir -p "$dest/Microsoft Visual Studio 14.0/VC"
   mkdir -p "$dest/Windows Kits/8.1"
   mkdir -p "$dest/Windows Kits/10"
   cp -r "$1/Microsoft Visual Studio 14.0/VC/include" "$dest/Microsoft Visual Studio 14.0/VC/"
   cp -r "$1/Microsoft Visual Studio 14.0/VC/lib" "$dest/Microsoft Visual Studio 14.0/VC/"
   cp -r "$1/Windows Kits/8.1/Include" "$dest/Windows Kits/8.1/"
   cp -r "$1/Windows Kits/8.1/Lib" "$dest/Windows Kits/8.1/"
   cp -r "$1/Windows Kits/10/Include" "$dest/Windows Kits/10/"
   cp -r "$1/Windows Kits/10/Lib" "$dest/Windows Kits/10/"
else
  echo "Currently only version 12 (2013) and 14 (2015) are supported."
  echo "But it should be easy to add versions to this script, take a look!"
fi



