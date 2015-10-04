../convert/colors -en 10 $1 | ../scripts/convert_hex_to_val.pl -s 1 > out
./urnn_run urnn.trained out | xargs -n3 | ../scripts/convert_val_to_xresources_colors.pl -s 1 -n
