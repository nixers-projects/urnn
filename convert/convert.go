package main

import (
	"bytes"
	"fmt"
	"image"
	_ "image/png"
	"io/ioutil"
	"math"
	"os"
)

func convertRGBToXYZStep(raw float64, out chan float64) {
	if raw > 0.04045 {
		raw = math.Pow(((raw + 0.055) / 1.055), 2.4)
	} else {
		raw = raw / 12.92
	}
	out <- (raw * 100)
}

func convertRGBToXYZ(r, g, b int) (float64, float64, float64) {
	rr := float64(r) / float64(255)
	gr := float64(g) / float64(255)
	br := float64(b) / float64(255)

	rc := make(chan float64)
	gc := make(chan float64)
	bc := make(chan float64)

	go convertRGBToXYZStep(rr, rc)
	go convertRGBToXYZStep(gr, gc)
	go convertRGBToXYZStep(br, bc)

	rd := <-rc
	gd := <-gc
	bd := <-bc

	x := (rd * 0.4124) + (gd * 0.3576) + (bd * 0.1805)
	y := (rd * 0.2126) + (gd * 0.7152) + (bd * 0.0722)
	z := (rd * 0.0193) + (gd * 0.1192) + (bd * 0.9505)

	return x, y, z
}

func convertXYZToLABStep(raw float64, out chan float64) {
	if raw > 0.008856 {
		raw = math.Pow(raw, (float64(1) / float64(3)))
	} else {
		raw = (7.787 * raw) + (float64(16) / float64(116))
	}
	out <- raw
}

func convertXYZToLAB(x, y, z float64) (float64, float64, float64) {
	xr := x / 95.047
	yr := y / 100.000
	zr := z / 108.883

	xc := make(chan float64)
	yc := make(chan float64)
	zc := make(chan float64)

	go convertXYZToLABStep(xr, xc)
	go convertXYZToLABStep(yr, yc)
	go convertXYZToLABStep(zr, zc)

	xd := <-xc
	yd := <-yc
	zd := <-zc

	var l float64 = (116.0 * yd) - 16.0
	var a float64 = 500.0 * (xd - yd)
	var b float64 = 200.0 * (yd - zd)

	return l, a, b
}

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
				//x, y, z := convertRGBToXYZ(int(r), int(g), int(b))
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

	x, y, z := convertRGBToXYZ(62, 224, 62)
	fmt.Println(convertXYZToLAB(x, y, z))
}
