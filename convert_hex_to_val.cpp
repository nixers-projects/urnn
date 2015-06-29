/*
 *
 * convert_hex_to_val.cpp
 *
 * Usage ./convert_hex_to_val [file with hexcode on every line] [ratio]
 *
 * Converts color hex code to red, green, blue percentage over the ratio.
 *
 * Compile with: g++ -std=c++11 convert_hex_to_val.cpp -o convert_hex_to_val
 *
 * NB: This program shouldn't fail otherwise it might corrupt the training data
 *
 */


#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>


void
HELP(char* argv[])
{
	std::cout<< "Usage "<< argv[0]
		<< " \t [file with hexcode on every line] [ratio]\n"
		<< "Converts color hex code to red, green, blue percentage over the ratio.\n";
}


int
extract_hex_color_from_index(const std::string hex, const int i1, const int i2)
{
	char col[3] = {hex[i1], hex[i2], '\0'};
	int rgbcol = strtol(col, NULL, 16);
	return rgbcol;
}


float
rule_of_three(const int number, const int over, const int ratio)
{
	return ((float)number/(float)over)*ratio;
}


float*
convert_hex_to_ratio(const std::string hex, const float val)
{
	float red = rule_of_three(
		extract_hex_color_from_index(hex, 0, 1),
		255,
		val
	);
	float green = rule_of_three(
		extract_hex_color_from_index(hex, 2, 3),
		255,
		val
	);
	float blue = rule_of_three(
		extract_hex_color_from_index(hex, 4, 5),
		255,
		val
	);
	return new float[3]{red, green, blue};
}


std::string
strip(std::string line, const char c)
{
	while (line[0] == c) {
		line = line.erase(0,1);
	}
	return line;
}


void
convert_file(const std::string filename, const float ratio)
{
	std::ifstream infile;
	infile.open(filename.c_str(), std::ifstream::in);
	if (infile.fail()){
		std::cerr<< "Could not open file "<< filename<< std::endl;
		exit(1);
	}
	std::string line = "";
	while (std::getline(infile, line)) {
		line = strip(line, '#');
		float* col = convert_hex_to_ratio(line, ratio);
		std::cout<< col[0]<< " "<< col[1]<< " "<< col[2]<< " ";
	}
}


int
main(int argc, char* argv[])
{
	if (argc != 3) {
		HELP(argv);
	}
	else {
		convert_file(argv[1], atof(argv[2]));
	}
	return 0;
}
