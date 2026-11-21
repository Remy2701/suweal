import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_field_if_not_exists_to_string_test() {
  node.define_field_strategy_to_string(node.DefineFieldIfNotExists)
  |> should.equal("IF NOT EXISTS ")
}

pub fn define_field_overwrite_to_string_test() {
  node.define_field_strategy_to_string(node.DefineFieldOverwrite)
  |> should.equal("OVERWRITE ")
}

pub fn define_field_regular_to_string_test() {
  node.define_field_strategy_to_string(node.DefineFieldRegular)
  |> should.equal("")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_field_strategy_to_module_test() {
  node.define_field_strategy_to_module(node.DefineFieldIfNotExists)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineFieldIfNotExists")
}

pub fn define_field_strategy_to_module_overwrite_test() {
  node.define_field_strategy_to_module(node.DefineFieldOverwrite)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineFieldOverwrite")
}

pub fn define_field_strategy_to_module_regular_test() {
  node.define_field_strategy_to_module(node.DefineFieldRegular)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineFieldRegular")
}
