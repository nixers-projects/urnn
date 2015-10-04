## urnn (unix ricing neural network)
[This is a fork that is currently a wip]

A neural network to smartly create coherent terminal colorschemes based on an image.

### Examples (Colors generated from wallpapers):

![1](http://pub.iotek.org/p/84nIYJl.png)
![2](http://pub.iotek.org/p/jL2NNE5.png)

### How do I use this?
This project depends on [libfann](https://github.com/libfann/fann). After you have that and clone:
``` bash
$ ./setup.sh
$ ./urnn.sh colors /some/file.png
```
And colors will be printed to STDOUT in an Xresources format. If you the results you get are meh, you can retrain urnn with `./urnn.sh retrain`. There are other options as well.

### Repo layout

Folder	| Contents
--------|---------
colors 	| Programs for extracting colors from png images in different ways.
scripts | Scripts for misc tasks(using the color extractors, parsing .Xresources files, ...)
network | Folder containing the meat of this project, programs and scripts to train and use the neural network, as well as extract data and put it in the correct form to use.
inputs 	| Git submodule that points to the [urnnputs](https://github.com/neeasade/urnnputs), containing images and resources file to extract data from to use to train the neural network.
dataset | The extracted data from the inputs folder in a form suitable used to train urnn(explained below)

#### Dataset contents(color representation)

Colors are converted to a value that is between 0 and 1, for speed/use with [fann](https://github.com/libfann/fann).

for example, say we have a pixel with the rgb value of (255, 120, 70). to display this information in a format that the neural network can understand, we have to convert it to 3 floats. each consist of the color/255 (max value).

255/255 = 1.00000000

120/255 = 0.47058823

70/255  = 0.27450980

so there you have it. our pixel is represented by 1.00000000 0.47058823 0.27450980

### TODO

* [x] Turn the input of the network between [-1, 1] so that the training is faster
* [ ] Get more data for the training
* [ ] Test multiple color extracters and parameters for the training
* [ ] Easy wrappers for all the mini-tools written

### How To Contribute

Have inputs(pairs of xresources and walls) that you want to add?
If you just want to submit them for addition to the inputs, see https://github.com/neeasade/urnnputs#contributing

If you want to test one or more here to see what kind of effect you can have on the network:
``` bash
$ urnn.sh add /some/image.png /test/.Xresouces
$ urnn.sh add /some/other/image.png /second/.Xresouces
$ urnn.sh refresh
$ urnn.sh retrain
```
You will then have a trained set including your inputs, and could test out the `urnn.sh colors` command and see that kind of effect you had. If any of the outputs are desirable, consider submitting a pull request with them ;)

#### Related links
- [Venams blog post](http://venam.nixers.net/blog/programming/2015/07/06/project-summer-july-2015.html)
- [libfann](https://github.com/libfann/fann)
