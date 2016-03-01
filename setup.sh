# setup.sh
# This file compiles the urnn c programs, and runs an initial train.

cd $(dirname $0)
cd network

cc urnn_train.c -o urnn_train -l fann -l m
cc urnn_run.c -o urnn_run -l fann -l m -std=c99

# ./urnn_train urnn.data urnn.trained

cd ../colors/sin_colors
make clean
make
