; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 --mattr=+32s,+d,+lam-bh < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 --mattr=+d,+lam-bh < %s | FileCheck %s --check-prefix=LA64

;; We need to ensure that even if lam-bh is enabled
;; it will not generate the am*.b/h instruction on loongarch32.

define i8 @atomicrmw_xchg_i8_acquire(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i8_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB0_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB0_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i8_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 %b acquire
  ret i8 %1
}

define i8 @atomicrmw_xchg_0_i8_acquire(ptr %a) nounwind {
; LA32-LABEL: atomicrmw_xchg_0_i8_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a2, $zero, 255
; LA32-NEXT:    sll.w $a2, $a2, $a1
; LA32-NEXT:    nor $a2, $a2, $zero
; LA32-NEXT:  .LBB1_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a3, $a0, 0
; LA32-NEXT:    and $a4, $a3, $a2
; LA32-NEXT:    sc.w $a4, $a0, 0
; LA32-NEXT:    beq $a4, $zero, .LBB1_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a3, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_0_i8_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.b $a1, $zero, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 0 acquire
  ret i8 %1
}

define i8 @atomicrmw_xchg_minus_1_i8_acquire(ptr %a) nounwind {
; LA32-LABEL: atomicrmw_xchg_minus_1_i8_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a2, $zero, 255
; LA32-NEXT:    sll.w $a2, $a2, $a1
; LA32-NEXT:  .LBB2_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a3, $a0, 0
; LA32-NEXT:    or $a4, $a3, $a2
; LA32-NEXT:    sc.w $a4, $a0, 0
; LA32-NEXT:    beq $a4, $zero, .LBB2_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a3, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_minus_1_i8_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.w $a2, $zero, -1
; LA64-NEXT:    amswap_db.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 -1 acquire
  ret i8 %1
}

define i16 @atomicrmw_xchg_i16_acquire(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i16_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB3_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB3_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i16_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 %b acquire
  ret i16 %1
}

define i16 @atomicrmw_xchg_0_i16_acquire(ptr %a) nounwind {
; LA32-LABEL: atomicrmw_xchg_0_i16_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a2, 15
; LA32-NEXT:    ori $a2, $a2, 4095
; LA32-NEXT:    sll.w $a2, $a2, $a1
; LA32-NEXT:    nor $a2, $a2, $zero
; LA32-NEXT:  .LBB4_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a3, $a0, 0
; LA32-NEXT:    and $a4, $a3, $a2
; LA32-NEXT:    sc.w $a4, $a0, 0
; LA32-NEXT:    beq $a4, $zero, .LBB4_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a3, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_0_i16_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.h $a1, $zero, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 0 acquire
  ret i16 %1
}

define i16 @atomicrmw_xchg_minus_1_i16_acquire(ptr %a) nounwind {
; LA32-LABEL: atomicrmw_xchg_minus_1_i16_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a2, 15
; LA32-NEXT:    ori $a2, $a2, 4095
; LA32-NEXT:    sll.w $a2, $a2, $a1
; LA32-NEXT:  .LBB5_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a3, $a0, 0
; LA32-NEXT:    or $a4, $a3, $a2
; LA32-NEXT:    sc.w $a4, $a0, 0
; LA32-NEXT:    beq $a4, $zero, .LBB5_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a3, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_minus_1_i16_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.w $a2, $zero, -1
; LA64-NEXT:    amswap_db.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 -1 acquire
  ret i16 %1
}

define i8 @atomicrmw_xchg_i8_release(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i8_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB6_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB6_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i8_release:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 %b release
  ret i8 %1
}

define i16 @atomicrmw_xchg_i16_release(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i16_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB7_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB7_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i16_release:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 %b release
  ret i16 %1
}

define i8 @atomicrmw_xchg_i8_acq_rel(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i8_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB8_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB8_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i8_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 %b acq_rel
  ret i8 %1
}

define i16 @atomicrmw_xchg_i16_acq_rel(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i16_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB9_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB9_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i16_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 %b acq_rel
  ret i16 %1
}

define i8 @atomicrmw_xchg_i8_seq_cst(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i8_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB10_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB10_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i8_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 %b seq_cst
  ret i8 %1
}

define i16 @atomicrmw_xchg_i16_seq_cst(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i16_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB11_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB11_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i16_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 %b seq_cst
  ret i16 %1
}

define i8 @atomicrmw_xchg_i8_monotonic(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i8_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB12_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB12_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i8_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i8 %b monotonic
  ret i8 %1
}

define i16 @atomicrmw_xchg_i16_monotonic(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_xchg_i16_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB13_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    addi.w $a5, $a1, 0
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB13_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_xchg_i16_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    amswap.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw xchg ptr %a, i16 %b monotonic
  ret i16 %1
}

define i8 @atomicrmw_add_i8_acquire(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i8_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB14_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB14_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i8_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i8 %b acquire
  ret i8 %1
}

define i16 @atomicrmw_add_i16_acquire(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i16_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB15_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB15_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i16_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i16 %b acquire
  ret i16 %1
}

define i8 @atomicrmw_add_i8_release(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i8_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB16_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB16_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i8_release:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i8 %b release
  ret i8 %1
}

define i16 @atomicrmw_add_i16_release(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i16_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB17_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB17_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i16_release:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i16 %b release
  ret i16 %1
}

define i8 @atomicrmw_add_i8_acq_rel(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i8_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB18_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB18_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i8_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i8 %b acq_rel
  ret i8 %1
}

define i16 @atomicrmw_add_i16_acq_rel(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i16_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB19_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB19_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i16_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i16 %b acq_rel
  ret i16 %1
}

define i8 @atomicrmw_add_i8_seq_cst(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i8_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB20_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB20_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i8_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i8 %b seq_cst
  ret i8 %1
}

define i16 @atomicrmw_add_i16_seq_cst(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i16_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB21_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB21_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i16_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd_db.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i16 %b seq_cst
  ret i16 %1
}

define i8 @atomicrmw_add_i8_monotonic(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i8_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB22_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB22_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i8_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd.b $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i8 %b monotonic
  ret i8 %1
}

define i16 @atomicrmw_add_i16_monotonic(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_add_i16_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB23_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    add.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB23_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_add_i16_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    amadd.h $a2, $a1, $a0
; LA64-NEXT:    move $a0, $a2
; LA64-NEXT:    ret
  %1 = atomicrmw add ptr %a, i16 %b monotonic
  ret i16 %1
}

define i8 @atomicrmw_sub_i8_acquire(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i8_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB24_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB24_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i8_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i8 %b acquire
  ret i8 %1
}

define i16 @atomicrmw_sub_i16_acquire(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i16_acquire:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB25_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB25_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i16_acquire:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i16 %b acquire
  ret i16 %1
}

define i8 @atomicrmw_sub_i8_release(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i8_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB26_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB26_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i8_release:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i8 %b release
  ret i8 %1
}

define i16 @atomicrmw_sub_i16_release(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i16_release:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB27_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB27_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i16_release:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i16 %b release
  ret i16 %1
}

define i8 @atomicrmw_sub_i8_acq_rel(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i8_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB28_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB28_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i8_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i8 %b acq_rel
  ret i8 %1
}

define i16 @atomicrmw_sub_i16_acq_rel(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i16_acq_rel:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB29_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB29_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i16_acq_rel:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i16 %b acq_rel
  ret i16 %1
}

define i8 @atomicrmw_sub_i8_seq_cst(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i8_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB30_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB30_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i8_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i8 %b seq_cst
  ret i8 %1
}

define i16 @atomicrmw_sub_i16_seq_cst(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i16_seq_cst:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB31_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB31_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i16_seq_cst:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd_db.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i16 %b seq_cst
  ret i16 %1
}

define i8 @atomicrmw_sub_i8_monotonic(ptr %a, i8 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i8_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    ori $a3, $zero, 255
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    andi $a1, $a1, 255
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB32_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB32_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i8_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd.b $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i8 %b monotonic
  ret i8 %1
}

define i16 @atomicrmw_sub_i16_monotonic(ptr %a, i16 %b) nounwind {
; LA32-LABEL: atomicrmw_sub_i16_monotonic:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a0, 3
; LA32-NEXT:    bstrins.w $a0, $zero, 1, 0
; LA32-NEXT:    lu12i.w $a3, 15
; LA32-NEXT:    ori $a3, $a3, 4095
; LA32-NEXT:    sll.w $a3, $a3, $a2
; LA32-NEXT:    bstrpick.w $a1, $a1, 15, 0
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:  .LBB33_1: # =>This Inner Loop Header: Depth=1
; LA32-NEXT:    ll.w $a4, $a0, 0
; LA32-NEXT:    sub.w $a5, $a4, $a1
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    and $a5, $a5, $a3
; LA32-NEXT:    xor $a5, $a4, $a5
; LA32-NEXT:    sc.w $a5, $a0, 0
; LA32-NEXT:    beq $a5, $zero, .LBB33_1
; LA32-NEXT:  # %bb.2:
; LA32-NEXT:    srl.w $a0, $a4, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: atomicrmw_sub_i16_monotonic:
; LA64:       # %bb.0:
; LA64-NEXT:    sub.w $a2, $zero, $a1
; LA64-NEXT:    amadd.h $a1, $a2, $a0
; LA64-NEXT:    move $a0, $a1
; LA64-NEXT:    ret
  %1 = atomicrmw sub ptr %a, i16 %b monotonic
  ret i16 %1
}
