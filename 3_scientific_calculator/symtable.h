typedef struct {
	char *key;
	double value;
}symentry;

symentry *symlookup(char *name);
