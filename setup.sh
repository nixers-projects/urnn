# setup.sh
# This file compiles the urnn c programs, and runs an initial train.

# Check if we have the fan header filei
#  (unsure about consistency between distros here):
if ! ls /usr/include | grep --quiet -w fann.h; then
  echo "You need to install libfann to compile urnn."
  echo "https://github.com/libfann/fann"
  exit 1
fi

cd $(dirname $0)
cd network

cc urnn_train.c -o urnn_train -l fann -l m
cc urnn_run.c -o urnn_run -l fann -l m -std=c99

./urnn_train urnn.data urnn.trained

cd ../convert/sin_colors
make clean
make
