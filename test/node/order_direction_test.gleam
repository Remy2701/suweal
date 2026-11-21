import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn order_direction_ascending_to_string_test() {
  node.Ascending
  |> node.order_direction_to_string()
  |> should.equal("ASC")
}

pub fn order_direction_descending_to_string_test() {
  node.Descending
  |> node.order_direction_to_string()
  |> should.equal("DESC")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn order_direction_ascending_to_module_test() {
  node.Ascending
  |> node.order_direction_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Ascending")
}

pub fn order_direction_descending_to_module_test() {
  node.Descending
  |> node.order_direction_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Descending")
}
