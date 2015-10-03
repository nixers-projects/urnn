#!/usr/bin/env bash
# wrapper script for urnn scripts and functions

# planned:
function usage
{
  echo "usage: $0 [retrain|regen|refresh|colors] (file)"
  echo "       retrain          retrain urnn with the current dataset"
  # This will eventually have a (convert/colors) arg, for now using colors only.
  echo "       regen            regenerate ALL urnn data from inputs (HEAVY operation)"
  echo "       refresh          check for inputs that aren't in the dataset and add them"
  echo "       colors (file)    generate xresources to STDOUT using current training result"
}

function retrain
{
  cd network
  ./urnn_train urnn.data urnn.trained
}

function regen
{
  echo "placeholder"
}

function refresh
{
  echo "placeholder"
}

function colors
{
  file="$1"
  [[ -z "$file" ]] && usage && exit 1
  [[ ! -f "$file" ]] && echo "ERR: could not find $file" && exit 1

  # Is this a png file?
  if ! file "$file" | grep "PNG image data"; then
    echo "File is not png, making a tmp copy to /tmp/urnn.png"
    type convert >/dev/null 2>&1 || { echo >&2 "Unable to convert image to png file without imagemagick package."; exit 1; }
    convert "$file" "/tmp/urnn.png"
    file="/tmp/urnn.png"
  fi

  # ghetto
  cd network
  ./test2.sh "$file"
}

# Make things relative to dir this script resides in
cd $(dirname $0)

valid="retrain refresh regen colors"
[[ -z "$1" ]] && usage
[[ $valid =~ $1 ]] && $1 $2 || usage

