../helper_scripts/extract_hex_from_xresources.pl $1 | ../helper_scripts/convert_hex_to_val.pl -s 1 > out.reverse
./urnn_run_reverse urnn_reversed.trained out.reverse | xargs -n3 | ../helper_scripts/convert_val_to_xresources_colors.pl -s 1
