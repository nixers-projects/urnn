/* See LICENSE file for copyright and license details. */
#include <err.h>
#include <stdio.h>

#include <png.h>
#include "colors.h"

void
parseimg(char *f, void (*fn)(int, int, int))
{
	png_structp png_struct_p;
	png_infop png_info_p;
	png_bytepp png_row_p;
	png_uint_32 y, x, width, height;
	int depth, color, interlace;
	FILE *fp;

	if (!(fp = fopen(f, "r")))
		err(1, "fopen %s", f);

	png_struct_p = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	png_info_p = png_create_info_struct(png_struct_p);
	if (!png_struct_p || !png_info_p || setjmp(png_jmpbuf(png_struct_p)))
		errx(1, "failed to initialize libpng");

	png_init_io(png_struct_p, fp);
	png_set_add_alpha(png_struct_p, 255, PNG_FILLER_AFTER);
	png_set_gray_to_rgb(png_struct_p);
	png_read_png(png_struct_p, png_info_p, PNG_TRANSFORM_STRIP_16 |
	             PNG_TRANSFORM_PACKING | PNG_TRANSFORM_EXPAND , NULL);
	png_get_IHDR(png_struct_p, png_info_p, &width, &height, &depth,
	             &color, &interlace, NULL, NULL);
	png_row_p = png_get_rows(png_struct_p, png_info_p);

	for (y = 0; y < height; y++) {
		png_byte *row = png_row_p[y];
		for (x = 0; x < width; x++) {
			png_byte *p = &row[x * 4];
			if (color == PNG_COLOR_TYPE_RGB_ALPHA && !p[3])
				continue;
			fn(p[0], p[1], p[2]);
		}
	}

	png_free_data(png_struct_p, png_info_p, PNG_FREE_ALL, -1);
	png_destroy_read_struct(&png_struct_p, &png_info_p, NULL);

	fclose(fp);
}
