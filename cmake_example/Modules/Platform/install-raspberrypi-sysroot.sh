
# rsync your sysroot (headers and libs from a working RaspberryPi)

# Then log into your raspberry pi and ensure that rsync is installed:
#ssh pi@octopi 'sudo aptitude install -y rsync'

# on mac then rsync the rPi stuff over to ./sysroot/:
#brew install rsync      # if not already installed

ARGC=$#
ARGV=("$@")

SDK=$HOME/RPI_SDK
if [ 0 -lt $ARGC ]; then
  SDK=${ARGV[0]}
  echo "Installing to SDK directory: $SDK"
fi

SYS_ROOT=$SDK/sysroot
RPI_USER=pi
RPI_HOST=octopi


mkdir -p $SYS_ROOT

`brew --prefix rsync`/bin/rsync -rzLR --safe-links \
      $RPI_USER@$RPI_HOST:/usr/lib/arm-linux-gnueabihf \
      $RPI_USER@$RPI_HOST:/usr/lib/gcc/arm-linux-gnueabihf \
      $RPI_USER@$RPI_HOST:/usr/include \
      $RPI_USER@$RPI_HOST:/lib/arm-linux-gnueabihf \
      $SYS_ROOT/

