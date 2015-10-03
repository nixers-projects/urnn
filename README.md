## urnn (unix ricing neural network)
[This is a fork that is currently a wip]

A neural network to smartly create coherent terminal colorschemes based on an image.

### Examples (Colors generated from wallpapers):

![1](http://pub.iotek.org/p/84nIYJl.png)
![2](http://pub.iotek.org/p/jL2NNE5.png)


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

[not implemented]If you want to test one or more here to see what kind of effect you can have on the network:
``` bash
$ urnn.sh add /some/image.png /test/.Xresouces
$ urnn.sh retrain
```
And then you will have a trained set including your inputs(you might retrain several times, they can vary in quality)

To test out the effects of them here, you will

#### Related links
- [Venams blog post](http://venam.nixers.net/blog/programming/2015/07/06/project-summer-july-2015.html)
- [libfann](https://github.com/libfann/fann)


**Everything from here down I will revaluate after I finish restructure**

1. Fetch a wallpaper from the internet and set it as background
2. Make sure they are all in .png format (You can use imagemagick "convert" tool to do that)
3. Go into the network dir (from now on it is assumed you are in that dir)
4. Compile the programs `cc urnn_train.c -o urnn_train -l fann -l m` and `cc urnn_run.c -o urnn_run -l fann -l m -std=c99`
5. Train the network `./urnn_train urnn.data urnn.trained`
6. Run the wrapper script with your PNG image as argument `sh test2.sh yourimage.png`
7. Replace your .Xressources colors with the ones of the output (don't forget the backup)
8. Update the resources `xrdb -load ~/.Xresources`
9. Open a new terminal and make sure the theme is good
10. If the theme is bad repeat from step 5 by retraining the network
11. Compile `sin_colors` script (if not already compiled)
12. Run the `add_to_output.sh` script with, as argument, the next number of the training set (check the outputs directory). For example `add_to_output.sh 62`
13. Put the new theme in a file
14. Run the `add_resources_to_output.sh` with as arguments the file just created and the next training set number. For example `./add_resources_to_output.sh new_theme.resources 61`
15. Update the training set sample by running `../helper_scripts/prepare_inputs.pl > urnn.data`
16. Go to step 1


