typedef struct {
	char *key;
	double value;
	double (*funcptr)();
}symentry;

symentry *symlookup(char *name);

void addfunc(char *funcname, double (*fn)());
