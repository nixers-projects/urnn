## urnn (unix ricing neural network)

A neural network to smartly create coherent terminal colorschemes based on an image.

### Examples (Colors generated from wallpapers):

![1](http://pub.iotek.org/p/84nIYJl.png) | ![2](http://pub.iotek.org/p/jL2NNE5.png)
-----------------------------------------|----------------------------------------
[3](http://pub.iotek.org/p/CG8ZGqZ.png) [4](http://pub.iotek.org/p/wG8Fd90.png) [5](http://pub.iotek.org/p/vhTj9zq.png) [6](http://pub.iotek.org/p/nBMMXv4.png) [7](http://pub.iotek.org/p/QPDnQzb.png) [8](http://pub.iotek.org/p/xzUveTc.png) [9](http://pub.iotek.org/p/VOTEaE3.png) [10](http://pub.iotek.org/p/mWpHBQG.png) [11](http://pub.iotek.org/p/oyQhwYt.png) [12](http://pub.iotek.org/p/JxiBe5s.png) [13](http://pub.iotek.org/p/tcAK5Jw.png) [14](http://pub.iotek.org/p/YyRXROw.png) [15](https://i.imgur.com/hp70r3o.png) [16](https://i.imgur.com/WZXJ7yU.jpg) [17](https://i.imgur.com/QHY404d.png) [18](https://i.imgur.com/PF2Kf18.png)

### How do I use this?
This project depends on [libfann](https://github.com/libfann/fann) and libpng. After you have those and clone:
``` bash
./urnn colors <some file.png>
       \____/  \___________/
          |          |
          |          \- The wallpaper you want to have your terminal
          |             colors fit with.
          |
          \- The colors command will print to STDOUT, in an Xresources
             format the colors that resulted after passing through the
             neural network. If the colors are bad you can retrain the
             network (see the help for more commands)

```

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

```
255/255 = 1.00000000
120/255 = 0.47058823
70/255  = 0.27450980
```

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
$ urnn add /some/image.png /test/.Xresouces
$ urnn add /some/other/image.png /second/.Xresouces
$ urnn refresh
$ urnn retrain
```
You will then have a trained set including your inputs, and could test out the `urnn colors` command and see that kind of effect you had. If any of the outputs are desirable, consider submitting a pull request with them ;)

#### Related links
- [Venams blog post](http://venam.nixers.net/blog/programming/2015/07/06/project-summer-july-2015.html)
- [libfann](https://github.com/libfann/fann)
