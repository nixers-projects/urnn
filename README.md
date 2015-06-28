### urnn

**u**nix **r**icing **n**eural **n**etwork


###A Simple Starting[ Idea

A neural network to smartly create coherent terminal colorschemes based on an
image, which might then be used as background.


Steps needed to achieve this:

* Gather images with related colorschemes

* Extract the 10 or so most used colors from the images that are at least separated by a delta factor (we don't want to only have shades of greys if there's a lot of grey in an image)

* Convert the hexadecimal code for the color into 3 neurons which should have a value varying from 0 to 1

* Train the network

* ???

* Profit
