### urnn

A neural network to smartly create coherent terminal colorschemes based on an
image, which might then be used as background.

### process

* scrape images (png only)

* use convert/ tool to convert all the images in images/ to a data.train file 

* use the data.train file to train the network

### convert/

This tool will convert all the images in images/ to a data.train file that follows the format specified by fann.

````
num_data_sets input_vars output_vars
input_var input_var
output_var
input_var input_var
output_var
input_var input_var
output_var
````

To express a color we'll be using 3 neurons, each having a ratio of red, green, and blue

````
#bcbcaf = 0.737255 0.737255 0.686275
````

Thus the input will consist of 3 times the X most used colors in the image and
the output will consist of 54 neurons, 3 times the 18 colors used in a terminal
colorscheme.

### images/

This tool can be written in whatever, we just need to figure out the best place to scrape images from and record the data we want. 

### network/

This will be the actual network, using fann libraries, written in C.

### what's next

* write convert/

* scrape images

* profit


### Examples

![1](http://pub.iotek.org/p/gguePe7.png)
![2](http://pub.iotek.org/p/84nIYJl.png)
![3](http://pub.iotek.org/p/CG8ZGqZ.png)


[Blog post explanation](http://venam.nixers.net/blog/programming/2015/07/06/project-summer-july-2015.html)
