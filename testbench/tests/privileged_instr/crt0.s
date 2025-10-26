# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Western Digital Corporation or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
// startup code to support HLL programs

#include "defines.h"

// ============================================================
.section .text.reset, "ax"

// entry point
.global _start
_start:

    // enable caching, except region 0xd
    li t0, 0x59555555
    csrw 0x7c0, t0

    // set stack pointer
    la sp, STACK

    // set mtvec to trap_handler
    la      t0, trap_handler
    csrw    mtvec, t0
    csrrsi  zero, mtvec, 1      // set vector based trap

    //  jump to main
    call main

    // if main returns, go to finish
    j _finish

// ============================================================
.section .text.trap, "ax"
.align 4

// trap handler table
trap_handler:
    jal     x0, _trap_handler                   // 0: Instruction address misaligned
    jal     x0, _trap_handler                   // 1: Instruction access fault
    jal     x0, _illegal_instr_handler          // 2: Illegal instruction
    jal     x0, _trap_ebreak                    // 3: Breakpoint
    jal     x0, _trap_handler                   // 4: Load address misaligned
    jal     x0, _trap_handler                   // 5: Load access fault
    jal     x0, _trap_handler                   // 6: Store/AMO address misaligned
    jal     x0, _trap_handler                   // 7: Store/AMO access fault
1:  jal     x0, _trap_ecall                     // 8: Environment call from U-mode
1:  jal     x0, 1b                              // 9: Environment call from S-mode
1:  jal     x0, 1b                              // 10: Reserved
    jal     x0, _trap_ecall                     // 11: Environment call from M-mode
1:  jal     x0, 1b                              // 12:
1:  jal     x0, 1b                              // 13:
1:  jal     x0, 1b                              // 14:
1:  jal     x0, 1b                              // 15:

// user defined handlers
    .weak   user_trap_handler
    .weak   user_illegal_instr_handler

// ============================================================
_trap_handler:
    // store registers
    addi    sp, sp, -80
    sw      ra, 76(sp)
    sw      t0, 72(sp)
    sw      t1, 68(sp)
    sw      t2, 64(sp)
    sw      s0, 60(sp)
    sw      a0, 56(sp)
    sw      a1, 52(sp)
    sw      a2, 48(sp)
    sw      a3, 44(sp)
    sw      a4, 40(sp)
    sw      a5, 36(sp)
    sw      a6, 32(sp)
    sw      a7, 28(sp)
    sw      t3, 24(sp)
    sw      t4, 20(sp)
    sw      t5, 16(sp)
    sw      t6, 12(sp)
    addi    s0, sp, 80

    // check user defined handler
    lui     a5, %hi(user_trap_handler)
    addi    a5, a5, %lo(user_trap_handler)
    beq     a5, zero, 1f
    call    user_trap_handler
    j       2f

1:
    // default handler
    csrr    t5, mepc
    addi    t5, t5, 4
    csrw    mepc, t5

2:
    // restore registers
    lw      ra, 76(sp)
    lw      t0, 72(sp)
    lw      t1, 68(sp)
    lw      t2, 64(sp)
    lw      s0, 60(sp)
    lw      a0, 56(sp)
    lw      a1, 52(sp)
    lw      a2, 48(sp)
    lw      a3, 44(sp)
    lw      a4, 40(sp)
    lw      a5, 36(sp)
    lw      a6, 32(sp)
    lw      a7, 28(sp)
    lw      t3, 24(sp)
    lw      t4, 20(sp)
    lw      t5, 16(sp)
    lw      t6, 12(sp)
    addi    sp, sp, 80

    mret

// ============================================================
_illegal_instr_handler:
    // store registers
    addi    sp, sp, -80
    sw      ra, 76(sp)
    sw      t0, 72(sp)
    sw      t1, 68(sp)
    sw      t2, 64(sp)
    sw      s0, 60(sp)
    sw      a0, 56(sp)
    sw      a1, 52(sp)
    sw      a2, 48(sp)
    sw      a3, 44(sp)
    sw      a4, 40(sp)
    sw      a5, 36(sp)
    sw      a6, 32(sp)
    sw      a7, 28(sp)
    sw      t3, 24(sp)
    sw      t4, 20(sp)
    sw      t5, 16(sp)
    sw      t6, 12(sp)
    addi    s0, sp, 80

    // check user defined handler
    lui     a5, %hi(user_illegal_instr_handler)
    addi    a5, a5, %lo(user_illegal_instr_handler)
    beq     a5, zero, 1f
    call    user_illegal_instr_handler
    j       2f

1:
    // default handler
    csrr    t5, mepc
    addi    t5, t5, 4
    csrw    mepc, t5

2:
    // restore registers
    lw      ra, 76(sp)
    lw      t0, 72(sp)
    lw      t1, 68(sp)
    lw      t2, 64(sp)
    lw      s0, 60(sp)
    lw      a0, 56(sp)
    lw      a1, 52(sp)
    lw      a2, 48(sp)
    lw      a3, 44(sp)
    lw      a4, 40(sp)
    lw      a5, 36(sp)
    lw      a6, 32(sp)
    lw      a7, 28(sp)
    lw      t3, 24(sp)
    lw      t4, 20(sp)
    lw      t5, 16(sp)
    lw      t6, 12(sp)
    addi    sp, sp, 80

    mret

// ============================================================
_trap_ecall:
    // store registers
    addi    sp, sp, -80
    sw      ra, 76(sp)
    sw      t0, 72(sp)
    sw      t1, 68(sp)
    sw      t2, 64(sp)
    sw      s0, 60(sp)
    sw      a0, 56(sp)
    sw      a1, 52(sp)
    sw      a2, 48(sp)
    sw      a3, 44(sp)
    sw      a4, 40(sp)
    sw      a5, 36(sp)
    sw      a6, 32(sp)
    sw      a7, 28(sp)
    sw      t3, 24(sp)
    sw      t4, 20(sp)
    sw      t5, 16(sp)
    sw      t6, 12(sp)
    addi    s0, sp, 80

    // check user defined handler
    lui     a5, %hi(user_trap_handler)
    addi    a5, a5, %lo(user_trap_handler)
    beq     a5, zero, 1f
    call    user_trap_handler
    j       2f

1:
    // default handler
    csrr    t5, mepc
    addi    t5, t5, 4
    csrw    mepc, t5

2:
    // restore registers
    lw      ra, 76(sp)
    lw      t0, 72(sp)
    lw      t1, 68(sp)
    lw      t2, 64(sp)
    lw      s0, 60(sp)
    lw      a0, 56(sp)
    lw      a1, 52(sp)
    lw      a2, 48(sp)
    lw      a3, 44(sp)
    lw      a4, 40(sp)
    lw      a5, 36(sp)
    lw      a6, 32(sp)
    lw      a7, 28(sp)
    lw      t3, 24(sp)
    lw      t4, 20(sp)
    lw      t5, 16(sp)
    lw      t6, 12(sp)
    addi    sp, sp, 80

    mret

// ============================================================
_trap_ebreak:
    // store registers
    addi    sp, sp, -80
    sw      ra, 76(sp)
    sw      t0, 72(sp)
    sw      t1, 68(sp)
    sw      t2, 64(sp)
    sw      s0, 60(sp)
    sw      a0, 56(sp)
    sw      a1, 52(sp)
    sw      a2, 48(sp)
    sw      a3, 44(sp)
    sw      a4, 40(sp)
    sw      a5, 36(sp)
    sw      a6, 32(sp)
    sw      a7, 28(sp)
    sw      t3, 24(sp)
    sw      t4, 20(sp)
    sw      t5, 16(sp)
    sw      t6, 12(sp)
    addi    s0, sp, 80

    // check user defined handler
    lui     a5, %hi(user_trap_handler)
    addi    a5, a5, %lo(user_trap_handler)
    beq     a5, zero, 1f
    call    user_trap_handler
    j       2f

1:
    // default handler
    csrr    t5, mepc
    addi    t5, t5, 4
    csrw    mepc, t5

2:
    // restore registers
    lw      ra, 76(sp)
    lw      t0, 72(sp)
    lw      t1, 68(sp)
    lw      t2, 64(sp)
    lw      s0, 60(sp)
    lw      a0, 56(sp)
    lw      a1, 52(sp)
    lw      a2, 48(sp)
    lw      a3, 44(sp)
    lw      a4, 40(sp)
    lw      a5, 36(sp)
    lw      a6, 32(sp)
    lw      a7, 28(sp)
    lw      t3, 24(sp)
    lw      t4, 20(sp)
    lw      t5, 16(sp)
    lw      t6, 12(sp)
    addi    sp, sp, 80

    mret

// ============================================================

// finish section
.section .text.finish, "ax"
.global _finish

// test termination
_finish:
        la t0, tohost
        li t1, 0xff
        sb t1, 0(t0) // DemoTB test termination
        li t1, 1
        sw t1, 0(t0) // Whisper test termination
        beq x0, x0, _finish
        .rept 10
        nop
        .endr

// ============================================================

// data section
.section .data.io
.global tohost
tohost: .word 0

