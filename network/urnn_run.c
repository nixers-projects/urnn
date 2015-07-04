/*
 *
 * urnn_run.c
 *
 * Usage ./urnn_run [trained file] [input file]
 * Run the network
 *
 * Compile with: cc urnn_run.c -o urnn_run -l fann -l m
 *
 */

#include <stdio.h>
#include "floatfann.h"


void
HELP(char* argv[])
{
	printf("Usage %s \t [trained file] [input file]\nRun the network.\n", argv[0]);
}


void
read_float_from_file(char* input, double from_file[])
{
	FILE* my_file  = NULL;
	double input_data = 0.0;
	int index = 0;

	my_file = fopen(input, "r");
	if (my_file == NULL) {
		printf("Couldn't open file for reading\n");
		exit(1);
	}

	for (int i = 0; i <  30; i++) {
		fscanf(my_file,"%lf",&input_data);
		from_file[index] = input_data;
		index++;
	}
	fclose(my_file);
	if (index != 30) {
		printf("There wasn't 10 colors in the input\n");
	}
}


int
main(int argc, char* argv[])
{
	if (argc != 3) {
		HELP(argv);
	}
	else {
		fann_type *calc_out;
		fann_type input[30];
		double from_file[30];

		struct fann *ann = fann_create_from_file(argv[1]);
		read_float_from_file(argv[2], from_file);

		for (int i = 0; i < 30; i++) {
			input[i] = from_file[i];
		}

		calc_out = fann_run(ann, input);

		for (int i = 0; i < 54; i++) {
			printf("%.15f ", calc_out[i]);
		}

		fann_destroy(ann);
	}
	return 0;
}
