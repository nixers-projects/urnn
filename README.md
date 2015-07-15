### urnn

A neural network to smartly create coherent terminal colorschemes based on an
image, which might then be used as background.

### converting pixel to raw data (for vompatti)

say we have a pixel with the rgb value of (255, 120, 70). to display this information in a format that the neural network can understand, we have to convert it to 3 floats. each consist of the color/255 (max value).

255/255 = 1.00000000

120/255 = 0.47058823

70/255  = 0.27450980

so there you have it. our pixel is represented by 1.00000000 0.47058823 0.27450980

### Examples

![1](http://pub.iotek.org/p/gguePe7.png)
![2](http://pub.iotek.org/p/84nIYJl.png)
![3](http://pub.iotek.org/p/CG8ZGqZ.png)
![4](http://pub.iotek.org/p/wG8Fd90.png)


[Blog post explanation](http://venam.nixers.net/blog/programming/2015/07/06/project-summer-july-2015.html)
