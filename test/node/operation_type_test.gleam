import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operation_type_create_to_string_test() {
  node.OperationCreate
  |> node.operation_type_to_string()
  |> should.equal("create")
}

pub fn operation_type_select_to_string_test() {
  node.OperationSelect
  |> node.operation_type_to_string()
  |> should.equal("select")
}

pub fn operation_type_update_to_string_test() {
  node.OperationUpdate
  |> node.operation_type_to_string()
  |> should.equal("update")
}

pub fn operation_type_delete_to_string_test() {
  node.OperationDelete
  |> node.operation_type_to_string()
  |> should.equal("delete")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operation_type_create_to_module_test() {
  node.OperationCreate
  |> node.operation_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.OperationCreate")
}

pub fn operation_type_select_to_module_test() {
  node.OperationSelect
  |> node.operation_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.OperationSelect")
}

pub fn operation_type_update_to_module_test() {
  node.OperationUpdate
  |> node.operation_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.OperationUpdate")
}

pub fn operation_type_delete_to_module_test() {
  node.OperationDelete
  |> node.operation_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.OperationDelete")
}
