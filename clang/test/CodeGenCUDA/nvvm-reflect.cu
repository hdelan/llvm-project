// REQUIRES: nvptx-registered-target

// Checking to see that __nvvm_reflect resolves to the correct llvm.nvvm.reflect
// intrinsic
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -disable-llvm-passes -S -emit-llvm -x c++ %s -o - | FileCheck %s --check-prefix=NO_NVVM_REFLECT_PASS

// Prepare bitcode file to link with
// RUN: %clang_cc1 -triple nvptx-unknown-cuda -emit-llvm-bc \
// RUN:    -disable-llvm-passes -o %t.bc %s

// Checking to see if the correct values are substituted for the nvvm_reflect
// call when llvm passes are enabled.
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_50 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_1
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_52 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_2
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_53 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_3
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_60 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_4
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_61 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_5
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_62 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_6
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_70 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_7
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_72 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_8
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_75 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_9
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_80 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_10
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda -target-cpu \
// RUN:    sm_86 -S -o /dev/null %s -mllvm -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=ARCH_REFLECT_11

// Check to see that nvvm_reflect("__CUDA_FTZ") returns 1 or 0 based on value
// of -fdenormal-fp-math-f32 flag
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda \
// RUN:    -fdenormal-fp-math-f32=preserve-sign -S -o /dev/null %s -mllvm \
// RUN:    -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=FTZ_REFLECT
// RUN: %clang_cc1 -fcuda-is-device -triple nvptx64-nvidia-cuda \
// RUN:    -fdenormal-fp-math-f32=ieee -S -o /dev/null %s -mllvm \
// RUN:    -print-after-all 2>&1 \
// RUN:    | FileCheck %s --check-prefix=NO_FTZ_REFLECT

#include "Inputs/cuda.h"

__device__ int foo_arch() {
  // NO_NVVM_REFLECT_PASS: call i32 @llvm.nvvm.reflect
  // ARCH_REFLECT_1: ret i32 500
  // ARCH_REFLECT_2: ret i32 520
  // ARCH_REFLECT_3: ret i32 530
  // ARCH_REFLECT_4: ret i32 600
  // ARCH_REFLECT_5: ret i32 610
  // ARCH_REFLECT_6: ret i32 620
  // ARCH_REFLECT_7: ret i32 700
  // ARCH_REFLECT_8: ret i32 720
  // ARCH_REFLECT_9: ret i32 750
  // ARCH_REFLECT_10: ret i32 800
  // ARCH_REFLECT_11: ret i32 860
  return __nvvm_reflect("__CUDA_ARCH");
}

__device__ int foo_ftz() {
  // FTZ_REFLECT: ret i32 1
  // NO_FTZ_REFLECT: ret i32 0
  return __nvvm_reflect("__CUDA_FTZ");
}

