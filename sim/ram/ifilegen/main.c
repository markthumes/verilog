#include <stdio.h>

#define UNUSED __attribute__((unused))
#define MEM_LEN 256
#define WIDTH 16

int main( UNUSED int argc, UNUSED char** argv ){
	FILE* fp = NULL;
	if( (fp = fopen("init.dat", "w")) == NULL ){
		perror("Failed to open init file");
		return 1;
	}
	//Memory address will be layed out as follows:
	//"@%08x %04x .... %04x\n"
	for( int i = 0; i < MEM_LEN; i++ ){
		fprintf(fp, "@%08x %04x", i, i);
		if( i != MEM_LEN-1 ) fprintf(fp, "\n");
	}
	if( fclose(fp) ){
		perror("Failed to close file");
		return 2;
	}
	return 0;
}
