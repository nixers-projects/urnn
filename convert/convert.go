package main

import (
	"bytes"
	"fmt"
	"image"
	//"image/color"
	_ "image/png"
	"io/ioutil"
	"os"
)

func extractColors(img image.Image, width, height int) []string {
	// colors is what we will return, containing the complete colorscheme
	var colors []string

	// row is our buffered channel that will receive the top color from
	// each row (of pixels)
	row := make(chan string, height)

	// done is our bool channel that will be written to once all the rows
	// are done
	done := make(chan bool)

	go func() {
		for i := 0; i < height; i++ {
			colors = append(colors, <-row)
		}

		done <- true
	}()

	for i := 0; i < height; i++ {
		go func(y int) {
			collection := make(map[string]struct{})
			for a := 0; a < width; a++ {
				color := img.At(a, y)
				r, g, b, _ := color.RGBA()
				collection[fmt.Sprintf("#%-x", []byte{uint8(r), uint8(g), uint8(b)})] = struct{}{}
			}
			for k, _ := range collection {
				// here will be the delta-e shit
				fmt.Print(k + " ")
			}
			fmt.Println()
			row <- "#bada55"
		}(i)
	}

	<-done
	return colors
}

func main() {
	// reads stdin into rawImg which is a []byte containing all the bytes
	// of the image
	rawImg, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
		return
	}

	// decodes the rawImg []byte into an image.Image object that we can use
	// later to get the pixels
	img, _, err := image.Decode(bytes.NewReader(rawImg))
	if err != nil {
		panic(err)
		return
	}

	width := int(img.Bounds().Dx())
	height := int(img.Bounds().Dy())

	_ = extractColors(img, width, height)

	/*for _, v := range colors {
		fmt.Println(v)
	}*/
}
