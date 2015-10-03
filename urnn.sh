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
  [[ -z "$2" ]] && usage && exit 1
  [[ ! -f "$2" ]] && echo "ERR: could not find $2" && exit 1

  # ghetto
  cd network
  ./test2.sh "$2"
}

# Make things relative to dir this script resides in
cd $(dirname $0)
echo $(dirname $0)

valid="retrain refresh regen colors"
[[ -z "$1" ]] && usage
[[ $valid =~ $1 ]] && $1 || usage

