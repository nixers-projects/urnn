/*
 *
 * urnn_train.c
 *
 * Usage ./urnn_train [train file] [output file]
 * Train the network.
 *
 * Compile with: cc urnn_train.c -o urnn_train -l fann -l m
 *
 */

#include "fann.h"
#include "math.h"
#include "stdio.h"


void
HELP(char* argv[])
{
	printf("Usage %s \t [train file] [output file]\nTrain the network.\n", argv[0]);
}


int
main(int argc, char* argv[])
{
	if (argc != 3) {
		HELP(argv);
	}
	else {
		const unsigned int num_input = 3*10; // 3 times 10 most used colors
		const unsigned int num_output = 3*18; // 3 times the 18 colors used in a colorscheme
		const unsigned int num_layers = 2+4;
		const float desired_error = (const float) 0.0014; //tolerance level
		const unsigned int max_epochs = 1500000; // allow for a long run
		const unsigned int epochs_between_reports = 20000;

		struct fann *ann = fann_create_standard(num_layers, num_input,
				34, 40, 60, 47,
		num_output);
        fann_set_training_algorithm(ann, FANN_TRAIN_QUICKPROP);

		fann_set_activation_function_hidden(ann, FANN_ELLIOT_SYMMETRIC);
		fann_set_activation_function_output(ann, FANN_ELLIOT_SYMMETRIC);
		fann_set_activation_steepness_layer(ann, 0.34, 1);
		fann_set_activation_steepness_layer(ann, 0.3, 2);
		fann_set_activation_steepness_layer(ann, 0.5, 3);
		fann_set_activation_steepness_layer(ann, 0.34, 4);
		fann_set_activation_steepness_layer(ann, 0.34, 5);

		fann_train_on_file(
			ann,
			argv[1],
			max_epochs,
			epochs_between_reports,
			desired_error
		);
		fann_save(ann, argv[2]);

		fann_destroy(ann);
	}

	return 0;
}
