import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_database_to_string_test() {
  node.define_access_target_to_string(node.DefineAccessDatabase)
  |> should.equal("DATABASE")
}

pub fn define_access_namespace_to_string_test() {
  node.define_access_target_to_string(node.DefineAccessNamespace)
  |> should.equal("NAMESPACE")
}

pub fn define_access_root_to_string_test() {
  node.define_access_target_to_string(node.DefineAccessRoot)
  |> should.equal("ROOT")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_target_to_module_database_test() {
  node.define_access_target_to_module(node.DefineAccessDatabase)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessDatabase")
}

pub fn define_access_target_to_module_namespace_test() {
  node.define_access_target_to_module(node.DefineAccessNamespace)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessNamespace")
}

pub fn define_access_target_to_module_root_test() {
  node.define_access_target_to_module(node.DefineAccessRoot)
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.DefineAccessRoot")
}
