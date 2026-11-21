import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_if_not_exists_to_string_test() {
  node.define_access_strategy_to_string(node.DefineAccessIfNotExists)
  |> should.equal("IF NOT EXISTS ")
}

pub fn define_access_overwrite_to_string_test() {
  node.define_access_strategy_to_string(node.DefineAccessOverwrite)
  |> should.equal("OVERWRITE ")
}

pub fn define_access_regular_to_string_test() {
  node.define_access_strategy_to_string(node.DefineAccessRegular)
  |> should.equal("")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_strategy_to_module_test() {
  node.define_access_strategy_to_module(node.DefineAccessIfNotExists)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessIfNotExists")
}

pub fn define_access_strategy_to_module_overwrite_test() {
  node.define_access_strategy_to_module(node.DefineAccessOverwrite)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessOverwrite")
}

pub fn define_access_strategy_to_module_regular_test() {
  node.define_access_strategy_to_module(node.DefineAccessRegular)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessRegular")
}
