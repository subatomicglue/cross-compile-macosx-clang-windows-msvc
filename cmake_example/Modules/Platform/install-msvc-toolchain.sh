
SDK="$HOME/MSVC_SDK"    # install destination

# download binutils from here: http://ftp.gnu.org/gnu/binutils/

ARGC=$#
ARGV=("$@")


# 1st (optional) argument is the install SDK location
if [ 0 -lt $ARGC ]; then
  SDK=${ARGV[0]}
  echo "Installing to SDK directory: $SDK"
fi


mkdir -p $SDK/compiler


# install clang into the sdk/binutils
cd $SDK
curl -L -O http://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-apple-darwin.tar.xz
xz -d clang+llvm-6.0.0-x86_64-apple-darwin.tar.xz
tar xf clang+llvm-6.0.0-x86_64-apple-darwin.tar -C compiler --strip-components=1
rm clang+llvm-6.0.0-x86_64-apple-darwin.tar
cd -

