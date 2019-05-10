int * audioProcessorAddr = (int *) 0x3000;

int main(void) {



	for(;;) {

		*audioProcessorAddr = 0;
	}


	return  0;
}
