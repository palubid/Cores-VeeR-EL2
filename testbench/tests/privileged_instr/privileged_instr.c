// insns.c - Test program for RISC-V instructions in different privilege modes
#include <stdint.h>
#include "printf.h"

#define read_csr(csr) ({ \
    unsigned long res; \
    asm volatile ("csrr %0, " #csr : "=r"(res)); \
    res; \
})

#define write_csr(csr, val) { \
    asm volatile ("csrw " #csr ", %0" : : "r"(val)); \
}

#define MISA_U  (1 << 8)

#define do_ecall()  asm volatile ("ecall")
#define do_ebreak() asm volatile ("ebreak\nnop") // EBREAK can translate to C.EBREAK. Insert a nop to align to 4
#define do_wfi()    asm volatile ("wfi")
#define do_sret()   asm volatile ("sret")
#define do_mret()   asm volatile ("mret")

#define is_ecall(x)  ((x) == 0x00000073)
#define is_ebreak(x) ((x) == 0x00100073 || ((x) & 0xFFFF) == 0x9002) // EBREAK or C.EBREAK
#define is_wfi(x)    ((x) == 0x10500073)
#define is_sret(x)   ((x) == 0x10200073)
#define is_mret(x)   ((x) == 0x30200073)

// PMP CSR definitions
#define PMP_R     0x01  // Read permission
#define PMP_W     0x02  // Write permission  
#define PMP_X     0x04  // Execute permission
#define PMP_A_OFF 0x00  // Address matching disabled
#define PMP_A_TOR 0x08  // Top of range
#define PMP_A_NA4 0x10  // Naturally aligned 4-byte
#define PMP_A_NAPOT 0x18 // Naturally aligned power of 2
#define PMP_L     0x80  // Lock bit

struct trap_info_t {
    uint32_t mcause;
    uint32_t insn;
};

volatile struct trap_info_t trap_info;

void user_trap_handler () {

    uint32_t mstatus = read_csr(mstatus);
    uint32_t mepc    = read_csr(mepc);

    trap_info.mcause = read_csr(mcause);
    trap_info.insn   = *((uint32_t*)mepc);

    printf("\ttrap! mstatus=0x%08X, mcause=0x%08X, mepc=0x%08X, insn=0x%08X\n",
        mstatus, trap_info.mcause, mepc, trap_info.insn);

    // Advance mepc to next instruction
    write_csr(mepc, mepc + 4);
}

void clear_trap () {
    trap_info.mcause = 0x00;
    trap_info.insn   = 0x00;
}

volatile int global_result = 1; // Success
extern unsigned long _end;
extern unsigned long STACK;

void check (int cond) {
    if (cond) {
        printf("\tpass\n\n");
    } else {
        printf("\tfail\n\n");
        global_result = 0;
    }
}

void user_main ();

void configure_pmp() {
    // Configure PMP for user mode access
    
    // PMP entry 0: Allow full access to entire address space for machine mode
    // and read/write/execute for user mode to code/data regions
    
    // Set PMP address 0 to cover entire 32-bit address space (0x00000000 to 0xFFFFFFFF)
    // For NAPOT mode, address = (base >> 2) | ((size >> 3) - 1)
    // For full 32-bit space: 0xFFFFFFFF >> 2 = 0x3FFFFFFF
    write_csr(pmpaddr0, 0x3FFFFFFF);
    
    // Configure PMP0: NAPOT mode, Read+Write+Execute permissions
    uint32_t pmp0cfg = PMP_A_NAPOT | PMP_R | PMP_W | PMP_X;
    write_csr(pmpcfg0, pmp0cfg);
    
    printf("PMP configured: pmpcfg0=0x%08X, pmpaddr0=0x%08X\n", 
           read_csr(pmpcfg0), read_csr(pmpaddr0));
}

int main () {
    printf("\nHello RISCV\n\n");

    unsigned long mstatus_val;
    mstatus_val = read_csr(mstatus);
    printf("STACK=0x%08x\n", (unsigned long)&STACK);
    printf("_end=0x%08x\n", &_end);
    printf("mepc=0x%08x\n", read_csr(mepc));
    printf("mstatus=0x%08x\n", mstatus_val);


    // The test requires user mode support
    if ((read_csr(misa) & MISA_U) == 0) {
        printf("MISA not implemented.\n");
    }

    // Do EBREAK
    printf("\n\t ** testing EBREAK **\n");
    clear_trap();
    do_ebreak();
    check(trap_info.mcause == 0x3 && is_ebreak(trap_info.insn));

    // Do WFI
    printf("\n\t ** testing WFI **\n");
    clear_trap();
    do_wfi();
    check(!trap_info.mcause); // No trap expected

    // Configure PMP before transitioning to user mode
    printf("Configuring PMP...\n");
    configure_pmp();

    mstatus_val &= ~(3 << 11);  // MPP  = 00 (user)
    mstatus_val &= ~(1 << 17);  // MPRV = 0
    write_csr(mstatus, mstatus_val);

    void* ptr = (void*)user_main;
    printf("\nuser_main address: 0x%08x\n", (unsigned long)ptr);
    write_csr(mepc, (unsigned long)ptr);
    printf("mepc=0x%08x\n", read_csr(mepc));
    printf("\nTransitioning to user mode...\n");
    asm volatile ("mret");

    // // Do SRET
    // printf("testing SRET\n");
    // clear_trap();
    // do_sret();
    // check(trap_info.mcause == 0x2 && is_sret(trap_info.insn));

    // // Do ECALL
    // printf("testing ECALL\n");
    // clear_trap();
    // do_ecall();
    // check(trap_info.mcause == 0xb && is_ecall(trap_info.insn));

    // Do not test MRET here. It is going to be used to go to user mode later
    // anyways.

    return 0;
}

// User mode main function
__attribute__((noreturn)) void user_main () {
    printf("Hello from user_main()\n");
    printf("mstatus=0x%08x\n", read_csr(mstatus));

    // Do EBREAK
    printf("\n\t ** testing EBREAK **\n");
    clear_trap();
    do_ebreak();
    check(trap_info.mcause == 0x3 && is_ebreak(trap_info.insn));

    // Do ECALL
    printf("\n\t ** testing ECALL **\n");
    clear_trap();
    do_ecall();
    check(trap_info.mcause == 0x8 && is_ecall(trap_info.insn));

    // Do WFI
    printf("\n\t ** testing WFI **\n");
    clear_trap();
    do_wfi();
    check(!trap_info.mcause); // No trap expected

    // Terminate the simulation
    // set the exit code to 0xFF or 0x1 and jump to _finish.
    printf("Exiting simulation...\n");
    unsigned char res = (global_result) ? 1 : 0;
    asm volatile (
        "mv a0, %0\n"
        "j  _finish\n"
        : : "r"(res)
    );

    while (1); // Make compiler not complain
}
