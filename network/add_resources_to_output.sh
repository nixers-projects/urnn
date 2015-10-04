cat ${1}| ../scripts/extract_hex_from_xresources.pl -s | ../scripts/convert_hex_to_val_2.pl -s 1 > ../dataset/${2}.resources.data
