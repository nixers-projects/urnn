./urnn_run urnn.trained ../outputs/20.images.data | xargs -n3 | ../helper_scripts/convert_val_to_xresources_colors.pl -s 1 -n
