import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn schema_type_schemafull_to_string_test() {
  node.Schemafull
  |> node.schema_type_to_string()
  |> should.equal("SCHEMAFULL")
}

pub fn schema_type_schemaless_to_string_test() {
  node.Schemaless
  |> node.schema_type_to_string()
  |> should.equal("SCHEMALESS")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn schema_type_schemafull_to_module_test() {
  node.Schemafull
  |> node.schema_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Schemafull")
}

pub fn schema_type_schemaless_to_module_test() {
  node.Schemaless
  |> node.schema_type_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Schemaless")
}
