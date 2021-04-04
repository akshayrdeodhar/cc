#include <stdio.h>
#include <errno.h>
#include <ctype.h>

#define MAX 10

#define DEBUG 0

int count_lines(FILE *fp) {
		char c;
		int count = 0;
		fseek(fp, 0, SEEK_SET);
		while ((c = fgetc(fp)) != EOF) {
				if (c == '\n') {
						++count;
				}
		}

		fseek(fp, 0, SEEK_SET);

		return count;
}

int count_digits(int i) {
		int count = 0;
		while (i) {
				i /= 10;
				++count;
		}

		return count;
}


int main(int argc, char *argv[]) {
		if (argc != 2) {
				fprintf(stderr, "usage: ./linenumbers <filename>\n");
		}

		FILE *fp;
		int n_lines, n_digits;
		int linecount;
		char c;
		char format_string[MAX];


		if ((fp = fopen(argv[1], "r")) == (FILE *)NULL) {
				perror(argv[1]);
				return errno;
		}

		n_lines = count_lines(fp);

		n_digits = count_digits(n_lines);

		sprintf(format_string, "\%%%dd| ", n_digits);

#if DEBUG > 0
		printf("Line number format string: %s\n", format_string);
#endif

		linecount = 0;

		printf(format_string, linecount + 1);
		while ((c = fgetc(fp)) != EOF) {
				putchar(c);
				if (c == '\n') {
						++linecount;
						if (linecount < n_lines) {
							printf(format_string, linecount + 1);
						}
				}
		}

		return 0;
}
