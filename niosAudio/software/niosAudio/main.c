int * audioProcessorAddr = (int *) 0x3000;

int main(void) {

	*audioProcessorAddr = 0;

	for(;;);


	return  0;
}
