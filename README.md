### urnn

A neural network to smartly create coherent terminal colorschemes based on an
image, which might then be used as background.

### process

* scrape images (png only)

* use convert/ tool to convert all the images in images/ to a data.train file 

* use the data.train file to train the network

### convert/

Written in C, this tool will convert all the images in images/ to a data.train file that follows the format specified by fann.

````
num_data_sets input_vars output_vars
input_var input_var
output_var
input_var input_var
output_var
input_var input_var
output_var
````

To express the colors themselves the best way would probably be to convert the hex to RGB and simply put a decimal in front of it. For example, to convert #bada55 to a float:

````
#bada55 = 186,218,085 = 0.186218085
````

### images/

This tool can be written in whatever, we just need to figure out the best place to scrape images from and record the data we want. 

### network/

This will be the actual network, using fann libraries, written in C.

### what's next

* write convert/

* scrape images

* profit
