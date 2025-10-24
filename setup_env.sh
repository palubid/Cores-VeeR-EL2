#!/bin/bash

export RV_ROOT=${PWD}

module load questa/24.1
module load verilator/v5.034
module load riscv/gcc-riscv-multilib

alias mk='make -f ${RV_ROOT}/tools/Makefile'