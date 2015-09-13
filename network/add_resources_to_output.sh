cat ${1}| ../helper_scripts/extract_hex_from_xresources.pl -s | ../helper_scripts/convert_hex_to_val_2.pl -s 1 > ../outputs/${2}.resources.data
