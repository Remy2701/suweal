import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operator_to_string_equal_test() {
  node.Equal
  |> node.operator_to_string()
  |> should.equal(" = ")
}

pub fn operator_not_equal_to_string_test() {
  node.NotEqual
  |> node.operator_to_string()
  |> should.equal(" != ")
}

pub fn operator_greater_than_to_string_test() {
  node.GreaterThan
  |> node.operator_to_string()
  |> should.equal(" > ")
}

pub fn operator_greater_than_or_equal_to_string_test() {
  node.GreaterThanOrEqual
  |> node.operator_to_string()
  |> should.equal(" >= ")
}

pub fn operator_less_than_to_string_test() {
  node.LessThan
  |> node.operator_to_string()
  |> should.equal(" < ")
}

pub fn operator_less_than_or_equal_to_string_test() {
  node.LessThanOrEqual
  |> node.operator_to_string()
  |> should.equal(" <= ")
}

pub fn operator_access_to_string_test() {
  node.Access
  |> node.operator_to_string()
  |> should.equal(".")
}

pub fn operator_namespace_access_to_string_test() {
  node.NamespaceAccess
  |> node.operator_to_string()
  |> should.equal("::")
}

pub fn operator_inside_to_string_test() {
  node.Inside
  |> node.operator_to_string()
  |> should.equal(" INSIDE ")
}

pub fn operator_relation_to_to_string_test() {
  node.RelationTo
  |> node.operator_to_string()
  |> should.equal("->")
}

pub fn operator_relation_from_to_string_test() {
  node.RelationFrom
  |> node.operator_to_string()
  |> should.equal("<-")
}

pub fn operator_relation_to_from_to_string_test() {
  node.RelationToFrom
  |> node.operator_to_string()
  |> should.equal("<->")
}

pub fn operator_indexing_to_string_test() {
  node.Indexing
  |> node.operator_to_string()
  |> should.equal("[")
}

pub fn operator_and_to_string_test() {
  node.And
  |> node.operator_to_string()
  |> should.equal(" AND ")
}

pub fn operator_or_to_string_test() {
  node.Or
  |> node.operator_to_string()
  |> should.equal(" OR ")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operator_equal_to_module_test() {
  node.Equal
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Equal")
}

pub fn operator_not_equal_to_module_test() {
  node.NotEqual
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.NotEqual")
}

pub fn operator_greater_than_to_module_test() {
  node.GreaterThan
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.GreaterThan")
}

pub fn operator_greater_than_or_equal_to_module_test() {
  node.GreaterThanOrEqual
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.GreaterThanOrEqual")
}

pub fn operator_less_than_to_module_test() {
  node.LessThan
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.LessThan")
}

pub fn operator_less_than_or_equal_to_module_test() {
  node.LessThanOrEqual
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.LessThanOrEqual")
}

pub fn operator_access_to_module_test() {
  node.Access
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Access")
}

pub fn operator_namespace_access_to_module_test() {
  node.NamespaceAccess
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.NamespaceAccess")
}

pub fn operator_inside_to_module_test() {
  node.Inside
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Inside")
}

pub fn operator_relation_to_to_module_test() {
  node.RelationTo
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.RelationTo")
}

pub fn operator_relation_from_to_module_test() {
  node.RelationFrom
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.RelationFrom")
}

pub fn operator_relation_to_from_to_module_test() {
  node.RelationToFrom
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.RelationToFrom")
}

pub fn operator_indexing_to_module_test() {
  node.Indexing
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Indexing")
}

pub fn operator_and_to_module_test() {
  node.And
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.And")
}

pub fn operator_or_to_module_test() {
  node.Or
  |> node.operator_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.Or")
}
