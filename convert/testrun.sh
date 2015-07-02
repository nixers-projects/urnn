cat test.png | ./convert 70 | sort -k 2 -g -r | cut -d ' ' -f1 | head -n 10 | ../convert_hex_to_val.pl -s 1 | xargs -n3 | ../convert_val_to_xresources_colors.pl -s 1
