cat ~/.Xresources | ./extract_hex_from_xresources.pl -s | ./convert_hex_to_val.pl -s 1 | xargs -n3 | ./convert_val_to_xresources_colors.pl -s 1 -n
