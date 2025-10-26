// hw1.c - Test program to print "hello", the stack address and tohost address using custom printf

// Declare the printf function
extern int printf(const char* format, ...);

// Declare the STACK symbol from the linker script
extern char STACK[];

// tohost symbol for output (if needed)
extern char tohost[];

// Main function
int main() {
  int i = 255;
  printf("\nhello 0x%04x\n", i);
  
  // Access the STACK symbol
  unsigned int stack_addr = (unsigned int)STACK;
  printf("Stack address: 0x%08x\n", stack_addr);

  // Access the tohost symbol
  unsigned int tohost_addr = (unsigned int)tohost;
  printf("tohost address: 0x%08x\n", tohost_addr);

  return 0;
}
