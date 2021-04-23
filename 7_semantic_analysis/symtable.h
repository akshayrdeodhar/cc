#define T_INT 202
#define T_DOUBLE 201

typedef struct {
	char *key;
	int ival;
	double dval;
	int type;
	double (*funcptr)();
}symentry;

symentry *symlookup(char *name);

void addfunc(char *funcname, double (*fn)());
