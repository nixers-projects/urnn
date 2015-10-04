#!/usr/bin/env bash
# wrapper script for urnn scripts and functions

# planned:
function usage
{
  echo "usage: $0 [retrain|regen|refresh|colors] (file) (file)"
  echo "       retrain          retrain urnn with the current dataset"
  # This will eventually have a (convert/colors) arg, for now using colors only.
  echo "       regen            regenerate ALL urnn data from inputs (HEAVY operation)"
  echo "       refresh          check for inputs that aren't in the dataset and add them"
  echo "       colors (img)     generate xresources to STDOUT using current training result"
  echo "       add (img) (Xres) generate and add urnn data about "
}

function retrain
{
  cd network
  ./urnn_train urnn.data urnn.trained
}

function regen
{
  if [ ! -d inputs/data ]; then
    echo "no input/data directory found, pulling urnnputs.."
    git submodule init
    git submodule update
  fi

 # clear out the current dataset.
  cd dataset
  rm *.data

  # Make new one from input/data.
  cd ../scripts
  ./extracter.pl
}

function refresh
{
  if [ ! -d inputs/data ]; then
    echo "no input/data directory found, pulling urnnputs.."
    git submodule init
    git submodule update
  fi

  # count inputs + 1 vs dataset.
  # todo: account for staging folder.
  echo "not implemented"
}

function colors
{
  file="$1"
  [[ -z "$file" ]] && usage && exit 1
  [[ ! -f "$file" ]] && echo "ERR: could not find $file" && exit 1

  # Is this a png file?
  if ! file "$file" | grep "PNG image data"; then
    type convert >/dev/null 2>&1 || { echo >&2 "File was not png. Unable to convert image to png file without imagemagick package."; exit 1; }
    convert "$file" "/tmp/urnn.png"
    file="/tmp/urnn.png"
  fi

  # ghetto
  cd network
  ./test2.sh "$file"
}

# Add inputs to the dataset folder.
# add (image file) (xresources file)
# extracts colors from png and xresources and adds to the dataset folder.
function add
{
  image_file="$1"
  xres_file="$2"
  [[ -z "$image_file" ]] && usage && exit 1
  [[ -z "$xres_file" ]] && usage && exit 1
  [[ ! -f "$image_file" ]] && echo "ERR: could not find $image_file" && exit 1

  # Is this a png image_file?
  if ! image_file "$image_file" | grep "PNG image data"; then
    type convert >/dev/null 2>&1 || { echo >&2 "image_file was not png. Unable to convert image to png image_file without imagemagick package."; exit 1; }
    convert "$image_file" "/tmp/urnn.png"
    image_file="/tmp/urnn.png"
  fi

  cd scripts
  # Xresources
  #./extract_hex_from_resources.pl "$xres_file" | ./convert_hex_to_val_2.pl -s 1

  echo "not implemented"

  # if submodule exists, add to staging folder
  # else, copy to inputs_extra
}

# Make things relative to dir this script resides in
cd $(dirname $0)

valid="retrain refresh regen colors add"
[[ -z "$1" ]] && usage
[[ $valid =~ $1 ]] && $@ || usage

