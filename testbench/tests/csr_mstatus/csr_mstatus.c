// csr_mstatus.c - Test program to read and write mstatus CSR to check MPP field

// Declare the printf function
#include "printf.h"

// Macros to read and write CSRs
#define read_csr(csr) ({ \
    unsigned long res; \
    asm volatile ("csrr %0, " #csr : "=r"(res)); \
    res; \
})

#define write_csr(csr, val) { \
    asm volatile ("csrw " #csr ", %0" : : "r"(val)); \
}

// CSR addresses
#define MISA_U (1 << 20)

// main function
int main () {
    printf("hello\n");
    // The test requires user mode support
    if ((read_csr(misa) & MISA_U) == 0) {
        printf("misa not implemented\n");
    }

    unsigned long prv, cur;
    int res = 0;

    // Test privilete mode availablilty by writing to mstatus.MPP and reading
    // it back. The value should match.

    // M-mode
    printf("M mode:\n");
    prv  = read_csr(mstatus);
    prv &= ~(3 << 11);
    prv |=  (3 << 11); // MPP = 11
    printf(" 0x%08X\n", prv);
    write_csr(mstatus, prv);
    cur  = read_csr(mstatus);
    printf(" 0x%08X\n", cur);
    if (((prv ^ cur) & (3 << 11)) == 0) {
        printf(" ok.\n");
    } else {
        printf(" not supported.\n");
        res = -1; // error
    }

    // S-mode
    printf("S mode:\n");
    prv  = read_csr(mstatus);
    prv &= ~(3 << 11);
    prv |=  (1 << 11); // MPP = 01
    printf(" 0x%08X\n", prv);
    write_csr(mstatus, prv);
    cur  = read_csr(mstatus);
    printf(" 0x%08X\n", cur);
    if (((prv ^ cur) & (3 << 11)) == 0) {
        printf(" ok.\n");
    } else {
        printf(" not supported.\n");
        res = -1; // error
    }

    // U-mode
    printf("U mode:\n");
    prv  = read_csr(mstatus);
    prv &= ~(3 << 11); // MPP = 00
    printf(" 0x%08X\n", prv);
    write_csr(mstatus, prv);
    cur  = read_csr(mstatus);
    printf(" 0x%08X\n", cur);
    if (((prv ^ cur) & (3 << 11)) == 0) {
        printf(" ok.\n");
    } else {
        printf(" not supported.\n");
        res = -1; // error
    }

    return res;
}
