import common
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn permission_full_to_string_test() {
  node.PermissionFull
  |> node.permission_to_string()
  |> should.equal("FULL")
}

pub fn permission_none_to_string_test() {
  node.PermissionNone
  |> node.permission_to_string()
  |> should.equal("NONE")
}

pub fn permission_for_full_single_to_string_test() {
  node.PermissionForFull(targets: [node.OperationCreate])
  |> node.permission_to_string()
  |> should.equal("FOR create FULL")
}

pub fn permission_for_full_multiple_to_string_test() {
  node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_string()
  |> should.equal("FOR create, update FULL")
}

pub fn permission_for_none_single_to_string_test() {
  node.PermissionForNone(targets: [node.OperationCreate])
  |> node.permission_to_string()
  |> should.equal("FOR create NONE")
}

pub fn permission_for_none_multiple_to_string_test() {
  node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_string()
  |> should.equal("FOR create, update NONE")
}

pub fn permission_for_where_single_to_string_test() {
  node.PermissionForWhere(
    targets: [node.OperationCreate],
    expression: node.binop.equal(
      node.identifier.create("a"),
      node.identifier.create("b"),
    ),
  )
  |> node.permission_to_string()
  |> should.equal("FOR create WHERE a = b")
}

pub fn permission_for_where_multiple_to_string_test() {
  node.PermissionForWhere(
    targets: [node.OperationCreate, node.OperationUpdate],
    expression: node.binop.equal(
      node.identifier.create("a"),
      node.identifier.create("b"),
    ),
  )
  |> node.permission_to_string()
  |> should.equal("FOR create, update WHERE a = b")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn permission_full_to_module_test() {
  node.PermissionFull
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.PermissionFull")
}

pub fn permission_none_to_module_test() {
  node.PermissionNone
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node("node.PermissionNone")
}

pub fn permission_for_full_single_to_module_test() {
  node.PermissionForFull(targets: [node.OperationCreate])
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForFull(targets: [node.OperationCreate])",
  )
}

pub fn permission_for_full_multiple_to_module_test() {
  node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])",
  )
}

pub fn permission_for_none_single_to_module_test() {
  node.PermissionForNone(targets: [node.OperationCreate])
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForNone(targets: [node.OperationCreate])",
  )
}

pub fn permission_for_none_multiple_to_module_test() {
  node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])",
  )
}

pub fn permission_for_where_single_to_module_test() {
  node.PermissionForWhere(
    targets: [node.OperationCreate],
    expression: node.binop.equal(
      node.identifier.create("a"),
      node.identifier.create("b"),
    ),
  )
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForWhere(\n"
    <> "  targets: [node.OperationCreate],\n"
    <> "  expression: node.BinaryOperator(\n"
    <> "    lhs: node.Identifier(\"a\"),\n"
    <> "    operator: node.Equal,\n"
    <> "    rhs: node.Identifier(\"b\"),\n"
    <> "  ),\n"
    <> ")",
  )
}

pub fn permission_for_where_multiple_to_module_test() {
  node.PermissionForWhere(
    targets: [node.OperationCreate, node.OperationUpdate],
    expression: node.binop.equal(
      node.identifier.create("a"),
      node.identifier.create("b"),
    ),
  )
  |> node.permission_to_module()
  |> common.assert_import("import suweal/node")
  |> common.assert_node(
    "node.PermissionForWhere(\n"
    <> "  targets: [node.OperationCreate, node.OperationUpdate],\n"
    <> "  expression: node.BinaryOperator(\n"
    <> "    lhs: node.Identifier(\"a\"),\n"
    <> "    operator: node.Equal,\n"
    <> "    rhs: node.Identifier(\"b\"),\n"
    <> "  ),\n"
    <> ")",
  )
}
