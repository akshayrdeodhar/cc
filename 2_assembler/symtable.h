typedef struct {
	char *key;
	int value;
}symentry;

int symlookup(char *name);
void symtableadd(char *name, int address);
