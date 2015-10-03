package main

import (
	"bytes"
	"fmt"
	"image"
	_ "image/png"
	"io/ioutil"
	"math"
	"strconv"
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

	l := (116.0 * yd) - 16.0
	a := 500.0 * (xd - yd)
	b := 200.0 * (yd - zd)

	return l, a, b
}

func convertRadToDeg(rad float64) float64 {
	return (rad * 180.0) / math.Pi
}

func convertDegToRad(deg float64) float64 {
	return (deg * math.Pi) / 180.0
}

func convertLABToHue(a, b float64) float64 {
	var bias float64 = 0
	if a >= 0 && b == 0 {
		return 0
	}
	if a < 0 && b == 0 {
		return 180
	}
	if a == 0 && b > 0 {
		return 90
	}
	if a == 0 && b < 0 {
		return 270
	}
	if a > 0 && b > 0 {
		bias = 0
	}
	if a < 0 {
		bias = 180
	}
	if a > 0 && b < 0 {
		bias = 360
	}
	return (convertRadToDeg(math.Atan(b/a)) + bias)
}

func round(v float64, decimals int) float64 {
	var pow float64 = 1
	for i := 0; i < decimals; i++ {
		pow *= 10
	}
	return float64(int((v*pow)+0.5)) / pow
}

func calculateDelta(l1, a1, b1, l2, a2, b2 float64) float64 {
	wht_l := 1.0
	wht_c := 1.0
	wht_h := 1.0

	xc1 := math.Sqrt((a1 * a1) + (b1 * b1))
	xc2 := math.Sqrt((a2 * a2) + (b2 * b2))
	xcx := (xc1 + xc2) / 2.0
	xgx := 0.5 * (1.0 - math.Sqrt((math.Pow(xcx, 7.0))/((math.Pow(xcx, 7.0))+(math.Pow(25.0, 7.0)))))
	xnn := (1.0 + xgx) * a1
	xc1 = math.Sqrt((xnn * xnn) + (b1 * b1))
	xh1 := convertLABToHue(xnn, b1)
	xnn = (1.0 + xgx) * a2
	xc2 = math.Sqrt((xnn * xnn) + (b2 * b2))
	xh2 := convertLABToHue(xnn, b2)
	xdl := l2 - l1
	xdc := xc2 - xc1

	var xdh float64
	if (xc1 * xc2) == 0 {
		xdh = 0
	} else {
		xnn = round(xh2-xh1, 12)
		if math.Abs(xnn) <= 180 {
			xdh = xh2 - xh1
		} else {
			if xnn > 180 {
				xdh = xh2 - xh1 - 360.0
			} else {
				xdh = xh2 - xh1 + 360.0
			}
		}
	}

	xdh = 2.0 * math.Sqrt(xc1*xc2) * math.Sin(convertDegToRad(xdh/2.0))
	xlx := (l1 + l2) / 2.0
	xcy := (xc1 + xc2) / 2.0

	var xhx float64
	if (xc1 * xc2) == 0 {
		xhx = xh1 + xh2
	} else {
		xnn = math.Abs(round(xh1-xh2, 12))
		if xnn > 180 {
			if (xh2 + xh1) < 360 {
				xhx = xh1 + xh2 + 360.0
			} else {
				xhx = xh1 + xh2 - 360.0
			}
		} else {
			xhx = xh1 + xh2
		}
		xhx = xhx / 2.0
	}

	xtx := 1.0 - 0.17*math.Cos(convertDegToRad(xhx-30.0)) + 0.24*math.Cos(convertDegToRad(2.0*xhx)) + 0.32*math.Cos(convertDegToRad(3.0*xhx+6.0)) - 0.20*math.Cos(convertDegToRad(4.0*xhx-63.0))
	xph := 30.0 * math.Exp((-1.0 * ((xhx - 275.0) / 25.0) * ((xhx - 275.0) / 25.0)))
	xrc := 2.0 * math.Sqrt((math.Pow(xcy, 7.0))/((math.Pow(xcy, 7.0))+math.Pow(25.0, 7.0)))
	xsl := 1.0 + ((0.015 * ((xlx - 50.0) * (xlx - 50.0))) / math.Sqrt(20.0+((xlx-50.0)*(xlx-50.0))))
	xsc := 1.0 + (0.045 * xcy)
	xsh := 1.0 + (0.015 * xcy * xtx)
	xrt := (-1.0 * math.Sin(convertDegToRad(2.0*xph))) * xrc
	xdl = xdl / (wht_l * xsl)
	xdc = xdc / (wht_c * xsc)
	xdh = xdh / (wht_h * xsh)
	e := math.Sqrt(math.Pow(xdl, 2) + math.Pow(xdc, 2) + math.Pow(xdh, 2) + (xrt * xdc * xdh))
	return e
}

type Pixel struct {
	Hex   string
	Lab   [3]float64
	Count int
}

func extractColors(img image.Image, width, height int, userDelta float64) map[string]Pixel {

	pixels := make(map[string]Pixel)
	row := make(chan Pixel, height*width)
	done := make(chan bool)

	var most_used string
	var most_used_num int

	go func() {
		for i := 0; i < (height * width); i++ {
			pixel := <-row
			ext_pixel := pixels[pixel.Hex]
			ext_pixel.Count++
			ext_pixel.Lab = pixel.Lab
			pixels[pixel.Hex] = ext_pixel
		}
		for k, v := range pixels {
			if v.Count > most_used_num {
				most_used_num = v.Count
				most_used = k
			}
		}
		done <- true
	}()

	for i := 0; i < height; i++ {
		go func(y int) {
			for a := 0; a < width; a++ {
				color := img.At(a, y)
				r, g, b, _ := color.RGBA()
				hex := fmt.Sprintf("#%-x", []byte{uint8(r), uint8(g), uint8(b)})
				l1, a1, b1 := convertXYZToLAB(convertRGBToXYZ(int(r), int(g), int(b)))
				list := [3]float64{l1, a1, b1}
				row <- Pixel{hex, list, 0}
			}
		}(i)
	}

	<-done
	var list []string
	for k, v := range pixels {
		e := pixels[most_used]
		delta := calculateDelta(v.Lab[0], v.Lab[1], v.Lab[2], e.Lab[0], e.Lab[1], e.Lab[2])
		if delta < userDelta || v.Count < 100 {
			list = append(list, k)
		}
	}
	for _, v := range list {
		delete(pixels, v)
	}
	return pixels
}

func usage() {
	fmt.Fprintf(os.Stderr, "Usage cat image.png | %s [delta]\n", os.Args[0])
	os.Exit(2)
}

func main() {
	// reads stdin into rawImg which is a []byte containing all the bytes
	// of the image
	if len(os.Args) != 2 {
		usage()
	}
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

	delta, err := strconv.ParseFloat(os.Args[1], 64)
	colors := extractColors(img, width, height, delta)
	for k, v := range colors {
		fmt.Println(k, v.Count)
	}
}
