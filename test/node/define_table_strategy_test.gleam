import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_table_if_not_exists_to_string_test() {
  node.define_table_strategy_to_string(node.DefineTableIfNotExists)
  |> should.equal("IF NOT EXISTS ")
}

pub fn define_table_overwrite_to_string_test() {
  node.define_table_strategy_to_string(node.DefineTableOverwrite)
  |> should.equal("OVERWRITE ")
}

pub fn define_table_regular_to_string_test() {
  node.define_table_strategy_to_string(node.DefineTableRegular)
  |> should.equal("")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_table_strategy_to_module_test() {
  node.define_table_strategy_to_module(node.DefineTableIfNotExists)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineTableIfNotExists")
}

pub fn define_table_strategy_to_module_overwrite_test() {
  node.define_table_strategy_to_module(node.DefineTableOverwrite)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineTableOverwrite")
}

pub fn define_table_strategy_to_module_regular_test() {
  node.define_table_strategy_to_module(node.DefineTableRegular)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineTableRegular")
}
