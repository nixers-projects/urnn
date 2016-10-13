/* todo: learn */
#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

/* red, green, blue */
struct color {
	int rgb[3];
};

struct xresColors {
	struct color colors[16];
	struct color background;
	struct color foreground;
};

struct imageColors {
	struct color colors[10];
};

char* expandNewlines(const char *src)
{
	char *dest = malloc(2 * strlen(src) + 1);
	char *reset = dest;
	char c;

	while (c = *(src++)) {
		if (c == '\n') {
			*(dest++) = '\\';
			*(dest++) = 'n';
		} else {
			*(dest++) = c;
		}
	}

	*dest = '\0';
	dest = reset;
	return dest;
}

/* Read all text from file, turn newlines into literal \n for json */
char* readFile(char *filename, int maxLength)
{
	int i, k;
	FILE *fp;

	fp = fopen(filename, "r");
	if (fp == NULL) {
		perror("Failed to open file.");
		exit(1);
	}

	char *fileContents = malloc(sizeof(char) * maxLength);
	fgets(fileContents, maxLength, fp);
	fclose(fp);

	return fileContents;
}

/* take 6 char string, return color */
struct color ParseColor(char *colorString)
{
	struct color toReturn;
	int i = 0, index = 0;

	for (i = 0; i < 3; i++) {
		char hex[2] = {colorString[index++], colorString[index++]};
		toReturn.rgb[i] = (int)strtol(hex, NULL, 16);
	}

	return toReturn;
}

struct imageColors ParsePng(char *filename)
{
	struct imageColors toReturn;
	return toReturn;
}

struct xresColors ParseXres(char *filename)
{
	/* to consider: use regex in the future */
	struct xresColors toReturn;
	struct color color;
	int colonIndex;
	char *line, *index, *colorString;
	char key[6];

	line = strtok(readFile(filename, 500), "\n");
	while (line != NULL) {
		/* making exact assumptions about string format (for now) */

		memcpy(key, &line[2], 5);
		key[5] = '\0';

		colonIndex = (int)(strchr(line, ':') - line);
		colorString = &line[strlen(line)-6];
		color = ParseColor(colorString);

		if (strcmp(key, "color") == 0) {
			/* '*.color10: #000000' */
			// 7 to colonIndex
			memcpy(index, &line[7], colonIndex == 8 ? 1 : 2);
			toReturn.colors[atoi(index)] = color;
		} else if (strcmp(key, "foreg") == 0) {
			toReturn.foreground = color;
		} else if (strcmp(key, "backg") == 0) {
			toReturn.background = color;
		}

		line = strtok(NULL, "\n");
	}

	return toReturn;
}

/* extract image and xresources format to json  */
void Extract()
{
	char *dataDirString = "./res/inputs/data/";
	char target[40];

	int fileCount, i;
	struct dirent **namelist;

	fileCount = scandir(dataDirString, &namelist, NULL, alphasort);

	if (fileCount < 0)
	{
		perror("Couldn't access data directory.");
		exit(1);
	} else {
		for(i = 2; i < 5; i++) {
			/* hacky for now, assume png, resources, text
			   always existing and in that order. */
			strcpy(target, dataDirString);
			strcat(target, namelist[i]->d_name);
			ParsePng(target);

			strcpy(target, dataDirString);
			strcat(target, namelist[++i]->d_name);
			ParseXres(target);

			strcpy(target, dataDirString);
			strcat(target, namelist[++i]->d_name);
			printf("description: \"%s\"", expandNewlines(readFile(target, 256)));
		}
		free(namelist);
	}
}


int main(int argc, char *argv[])
{
	/* todo: make rel to location for res dir */
	Extract();
	exit(0);
}
