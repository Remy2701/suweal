import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn table_type_normal_to_string_test() {
  node.NormalTable
  |> node.table_type_to_string()
  |> should.equal("NORMAL")
}

pub fn table_type_relation_to_string_test() {
  node.RelationTable(in: "user", out: "likes")
  |> node.table_type_to_string()
  |> should.equal("RELATION IN user OUT likes")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn table_type_normal_to_module_test() {
  node.NormalTable
  |> node.table_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.NormalTable")
}

pub fn table_type_relation_to_module_test() {
  node.RelationTable(in: "user", out: "likes")
  |> node.table_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.RelationTable(in: \"user\", out: \"likes\")")
}
