// RUN: tco %s | FileCheck %s
// RUN: %flang_fc1 -mmlir -disable-external-name-interop  -emit-llvm %s -o -| FileCheck %s


// CHECK-LABEL: define void @_QPtest_callee(
func.func @_QPtest_callee(%arg0: !fir.box<!fir.array<?xi32>>) {
  return
}

// CHECK-LABEL: define void @_QPtest_slice()
func.func @_QPtest_slice() {
// CHECK:  %[[a1:.*]] = alloca { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] }, align 8
// CHECK:  %[[a2:.*]] = alloca [20 x i32], i64 1, align 4
// CHECK:  %[[a3:.*]] = getelementptr [20 x i32], ptr %[[a2]], i64 0, i64 0
// CHECK:  %[[a4:.*]] = insertvalue { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] }
// CHECK:  { ptr undef, i64 4, i32 20240719, i8 1, i8 9, i8 0, i8 0, [1 x [3 x i64]]
// CHECK: [i64 1, i64 5, i64 8]] }, ptr %[[a3]], 0
// CHECK:  store { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] } %[[a4]], ptr %[[a1]], align 8
// CHECK:  call void @_QPtest_callee(ptr %[[a1]])
  %c20 = arith.constant 20 : index
  %c1_i64 = arith.constant 1 : i64
  %c10_i64 = arith.constant 10 : i64
  %c2_i64 = arith.constant 2 : i64
  %0 = fir.alloca !fir.array<20xi32> {bindc_name = "x", uniq_name = "_QFtest_sliceEx"}
  %1 = fir.shape %c20 : (index) -> !fir.shape<1>
  %2 = fir.slice %c1_i64, %c10_i64, %c2_i64 : (i64, i64, i64) -> !fir.slice<1>
  %3 = fir.embox %0(%1) [%2] : (!fir.ref<!fir.array<20xi32>>, !fir.shape<1>, !fir.slice<1>) -> !fir.box<!fir.array<?xi32>>
  fir.call @_QPtest_callee(%3) : (!fir.box<!fir.array<?xi32>>) -> ()
  return
}

// CHECK-LABEL: define void @_QPtest_dt_callee(
func.func @_QPtest_dt_callee(%arg0: !fir.box<!fir.array<?xi32>>) {
  return
}

// CHECK-LABEL: define void @_QPtest_dt_slice()
func.func @_QPtest_dt_slice() {
// CHECK:  %[[a1:.*]] = alloca { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] }, align 8
// CHECK:  %[[a3:.*]] = alloca [20 x %_QFtest_dt_sliceTt], i64 1, align 8
// CHECK:  %[[a4:.*]] = getelementptr [20 x %_QFtest_dt_sliceTt], ptr %[[a3]], i64 0, i64 0, i32 0
// CHECK: %[[a5:.*]] = insertvalue { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] }
// CHECK-SAME: { ptr undef, i64 4, i32 20240719, i8 1, i8 9, i8 0, i8 0, [1 x [3 x i64]]
// CHECK-SAME: [i64 1, i64 5, i64 16
// CHECK-SAME: , ptr %[[a4]], 0

// CHECK: store { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] } %[[a5]], ptr %[[a1]], align 8
// CHECK:  call void @_QPtest_dt_callee(ptr %[[a1]])
  %c20 = arith.constant 20 : index
  %c1_i64 = arith.constant 1 : i64
  %c10_i64 = arith.constant 10 : i64
  %c2_i64 = arith.constant 2 : i64
  %0 = fir.alloca i32 {bindc_name = "v", uniq_name = "_QFtest_dt_sliceEv"}
  %1 = fir.alloca !fir.array<20x!fir.type<_QFtest_dt_sliceTt{i:i32,j:i32}>> {bindc_name = "x", uniq_name = "_QFtest_dt_sliceEx"}
  %2 = fir.field_index i, !fir.type<_QFtest_dt_sliceTt{i:i32,j:i32}>
  %3 = fir.shape %c20 : (index) -> !fir.shape<1>
  %4 = fir.slice %c1_i64, %c10_i64, %c2_i64 path %2 : (i64, i64, i64, !fir.field) -> !fir.slice<1>
  %5 = fir.embox %1(%3) [%4] : (!fir.ref<!fir.array<20x!fir.type<_QFtest_dt_sliceTt{i:i32,j:i32}>>>, !fir.shape<1>, !fir.slice<1>) -> !fir.box<!fir.array<?xi32>>
  fir.call @_QPtest_dt_callee(%5) : (!fir.box<!fir.array<?xi32>>) -> ()
  return
}

func.func private @takesRank2CharBox(!fir.box<!fir.array<?x?x!fir.char<1,?>>>)

// CHECK-LABEL: define void @emboxSubstring(
// CHECK-SAME: ptr {{[^%]*}}%[[arg0:.*]])
func.func @emboxSubstring(%arg0: !fir.ref<!fir.array<2x3x!fir.char<1,4>>>) {
  %c2 = arith.constant 2 : index
  %c3 = arith.constant 3 : index
  %c1 = arith.constant 1 : index
  %c1_i64 = arith.constant 1 : i64
  %c2_i64 = arith.constant 2 : i64
  %0 = fir.shape %c2, %c3 : (index, index) -> !fir.shape<2>
  %1 = fir.slice %c1, %c2, %c1, %c1, %c3, %c1 substr %c1_i64, %c2_i64 : (index, index, index, index, index, index, i64, i64) -> !fir.slice<2>
  %2 = fir.embox %arg0(%0) [%1] : (!fir.ref<!fir.array<2x3x!fir.char<1,4>>>, !fir.shape<2>, !fir.slice<2>) -> !fir.box<!fir.array<?x?x!fir.char<1,?>>>
  // CHECK: %[[addr:.*]] = getelementptr [3 x [2 x [4 x i8]]], ptr %[[arg0]], i64 0, i64 0, i64 0, i64 1
  // CHECK: insertvalue {[[descriptorType:.*]]} { ptr undef, i64 2, i32 20240719, i8 2, i8 40, i8 0, i8 0
  // CHECK-SAME: [2 x [3 x i64]] [{{\[}}3 x i64] [i64 1, i64 2, i64 4], [3 x i64] [i64 1, i64 3, i64 8]] }
  // CHECK-SAME: ptr %[[addr]], 0

  fir.call @takesRank2CharBox(%2) : (!fir.box<!fir.array<?x?x!fir.char<1,?>>>) -> ()
  return
}

func.func private @do_something(!fir.box<!fir.array<?xf32>>) -> ()
// CHECK: define void @fir_dev_issue_1416
// CHECK-SAME: ptr {{[^%]*}}%[[base_addr:.*]], i64 %[[low:.*]], i64 %[[up:.*]], i64 %[[at:.*]])
func.func @fir_dev_issue_1416(%arg0: !fir.ref<!fir.array<40x?xf32>>, %low: index, %up: index, %at : index) {
    // Test fir.embox with a constant interior array shape.
    %c1 = arith.constant 1 : index
    %c40 = arith.constant 40 : index
    %0 = fir.undefined index
    %1 = fir.shape_shift %c1, %c40, %low, %up : (index, index, index, index) -> !fir.shapeshift<2>
    %2 = fir.slice %c1, %c40, %c1, %at, %0, %0 : (index, index, index, index, index, index) -> !fir.slice<2>
// CHECK: %[[diff:.*]] = sub i64 %[[at]], %[[low]]
// CHECK: %[[mul:.*]] = mul i64 %[[diff]], 1
// CHECK: %[[offset:.*]] = add i64 %[[mul]], 0
// CHECK: %[[addr:.*]] = getelementptr [40 x float], ptr %0, i64 %[[offset]], i64 0
// CHECK: %[[box:.*]] = insertvalue { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] }
// CHECK-SAME: { ptr undef, i64 4, i32 20240719, i8 1, i8 27, i8 0, i8 0, [1 x [3 x i64]] [{{.*}} [i64 1, i64 40, i64 4]] }, ptr %[[addr]], 0
    %3 = fir.embox %arg0(%1) [%2] : (!fir.ref<!fir.array<40x?xf32>>, !fir.shapeshift<2>, !fir.slice<2>) -> !fir.box<!fir.array<?xf32>>
    fir.call @do_something(%3) : (!fir.box<!fir.array<?xf32>>) -> ()
    return
}

// CHECK-LABEL: define void @_QPtest_allocator1()
func.func @_QPtest_allocator1() {
  %c20 = arith.constant 20 : index
  %0 = fir.alloca !fir.array<20xi32> {bindc_name = "x", uniq_name = "_QFtest_sliceEx"}
  %1 = fir.shape %c20 : (index) -> !fir.shape<1>
  %3 = fir.embox %0(%1) {allocator_idx = 1 : i32} : (!fir.ref<!fir.array<20xi32>>, !fir.shape<1>) -> !fir.box<!fir.array<?xi32>>
  fir.call @_QPtest_callee(%3) : (!fir.box<!fir.array<?xi32>>) -> ()
  return
}

// %{{.*}} = insertvalue { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] } { ptr undef, i64 ptrtoint (ptr getelementptr (i32, ptr null, i32 1) to i64), i32 20240719, i8 1, i8 9, i8 0, i8 2, [1 x [3 x i64]] [[3 x i64] [i64 1, i64 20, i64 ptrtoint (ptr getelementptr (i32, ptr null, i32 1) to i64)]] }

// CHECK-LABEL: define void @_QPtest_allocator2()
func.func @_QPtest_allocator2() {
  %c20 = arith.constant 20 : index
  %0 = fir.alloca !fir.array<20xi32> {bindc_name = "x", uniq_name = "_QFtest_sliceEx"}
  %1 = fir.shape %c20 : (index) -> !fir.shape<1>
  %3 = fir.embox %0(%1) {allocator_idx = 3 : i32} : (!fir.ref<!fir.array<20xi32>>, !fir.shape<1>) -> !fir.box<!fir.array<?xi32>>
  fir.call @_QPtest_callee(%3) : (!fir.box<!fir.array<?xi32>>) -> ()
  return
}

// CHECK: %{{.*}} = insertvalue { ptr, i64, i32, i8, i8, i8, i8, [1 x [3 x i64]] } { ptr undef, i64 4, i32 20240719, i8 1, i8 9, i8 0, i8 6
