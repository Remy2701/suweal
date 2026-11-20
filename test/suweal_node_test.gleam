import gleam/option
import gleam/string
import gleeunit/should
import omcg/module
import suweal/node
import suweal/surreal_ql
import suweal/surreal_type

fn assert_import(module: module.Module, expected: String) -> module.Module {
  module
  |> module.module_imports_to_string()
  |> should.equal(expected)
  module
}

fn assert_imports(
  module: module.Module,
  expected: List(String),
) -> module.Module {
  module
  |> module.module_imports_to_string()
  |> should.equal(string.join(expected, "\n"))
  module
}

fn assert_node(module: module.Module, expected: String) -> module.Module {
  module
  |> module.module_node_to_string()
  |> should.equal(expected)
  module
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                        Order Direction                                        //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn order_direction_to_string_test() {
  node.Ascending
  |> node.order_direction_to_string()
  |> should.equal("ASC")

  node.Descending
  |> node.order_direction_to_string()
  |> should.equal("DESC")
}

pub fn order_direction_to_module_test() {
  node.Ascending
  |> node.order_direction_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Ascending")

  node.Descending
  |> node.order_direction_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Descending")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           Operator                                            //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operator_to_string_test() {
  node.Equal
  |> node.operator_to_string()
  |> should.equal(" = ")

  node.NotEqual
  |> node.operator_to_string()
  |> should.equal(" != ")

  node.GreaterThan
  |> node.operator_to_string()
  |> should.equal(" > ")

  node.GreaterThanOrEqual
  |> node.operator_to_string()
  |> should.equal(" >= ")

  node.LessThan
  |> node.operator_to_string()
  |> should.equal(" < ")

  node.LessThanOrEqual
  |> node.operator_to_string()
  |> should.equal(" <= ")

  node.Access
  |> node.operator_to_string()
  |> should.equal(".")

  node.NamespaceAccess
  |> node.operator_to_string()
  |> should.equal("::")

  node.Inside
  |> node.operator_to_string()
  |> should.equal(" INSIDE ")

  node.RelationTo
  |> node.operator_to_string()
  |> should.equal("->")

  node.RelationFrom
  |> node.operator_to_string()
  |> should.equal("<-")

  node.RelationToFrom
  |> node.operator_to_string()
  |> should.equal("<->")

  node.Indexing
  |> node.operator_to_string()
  |> should.equal("[")

  node.And
  |> node.operator_to_string()
  |> should.equal(" AND ")

  node.Or
  |> node.operator_to_string()
  |> should.equal(" OR ")
}

pub fn operator_to_module_test() {
  node.Equal
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Equal")

  node.NotEqual
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.NotEqual")

  node.GreaterThan
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.GreaterThan")

  node.GreaterThanOrEqual
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.GreaterThanOrEqual")

  node.LessThan
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.LessThan")

  node.LessThanOrEqual
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.LessThanOrEqual")

  node.Access
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Access")

  node.NamespaceAccess
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.NamespaceAccess")

  node.Inside
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Inside")

  node.RelationTo
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.RelationTo")

  node.RelationFrom
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.RelationFrom")

  node.RelationToFrom
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.RelationToFrom")

  node.Indexing
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Indexing")

  node.And
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.And")

  node.Or
  |> node.operator_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Or")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Select Field                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn select_field_to_string_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.None,
    value: False,
  )
  |> node.select_field_to_string()
  |> should.equal("field")
}

pub fn select_value_field_to_string_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.None,
    value: True,
  )
  |> node.select_field_to_string()
  |> should.equal("VALUE field")
}

pub fn select_field_with_alias_to_string_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.Some("alias"),
    value: False,
  )
  |> node.select_field_to_string()
  |> should.equal("field AS alias")
}

pub fn select_value_field_with_alias_to_string_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.Some("alias"),
    value: True,
  )
  |> node.select_field_to_string()
  |> should.equal("VALUE field AS alias")
}

pub fn select_field_to_module_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.None,
    value: False,
  )
  |> node.select_field_to_module()
  |> assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.None,\n"
    <> "  value: False,\n"
    <> ")",
  )
}

pub fn select_value_field_to_module_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.None,
    value: True,
  )
  |> node.select_field_to_module()
  |> assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> assert_node(
    "node.SelectField("
    <> "field: node.Identifier(\"field\"), "
    <> "alias: option.None, "
    <> "value: True"
    <> ")",
  )
}

pub fn select_field_with_alias_to_module_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.Some("alias"),
    value: False,
  )
  |> node.select_field_to_module()
  |> assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.Some(\"alias\"),\n"
    <> "  value: False,\n"
    <> ")",
  )
}

pub fn select_value_field_with_alias_to_module_test() {
  node.SelectField(
    field: node.Identifier("field"),
    alias: option.Some("alias"),
    value: True,
  )
  |> node.select_field_to_module()
  |> assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.Some(\"alias\"),\n"
    <> "  value: True,\n"
    <> ")",
  )
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Schema Type                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn schema_type_to_string_test() {
  node.Schemafull
  |> node.schema_type_to_string()
  |> should.equal("SCHEMAFULL")

  node.Schemaless
  |> node.schema_type_to_string()
  |> should.equal("SCHEMALESS")
}

pub fn schema_type_to_module_test() {
  node.Schemafull
  |> node.schema_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Schemafull")

  node.Schemaless
  |> node.schema_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.Schemaless")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Table Type                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn table_type_to_string_test() {
  node.NormalTable
  |> node.table_type_to_string()
  |> should.equal("NORMAL")

  node.RelationTable(in: "user", out: "likes")
  |> node.table_type_to_string()
  |> should.equal("RELATION IN user OUT likes")
}

pub fn table_type_to_module_test() {
  node.NormalTable
  |> node.table_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.NormalTable")

  node.RelationTable(in: "user", out: "likes")
  |> node.table_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.RelationTable(in: \"user\", out: \"likes\")")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Operation Type                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn operation_type_to_string_test() {
  node.OperationCreate
  |> node.operation_type_to_string()
  |> should.equal("create")

  node.OperationSelect
  |> node.operation_type_to_string()
  |> should.equal("select")

  node.OperationUpdate
  |> node.operation_type_to_string()
  |> should.equal("update")

  node.OperationDelete
  |> node.operation_type_to_string()
  |> should.equal("delete")
}

pub fn operation_type_to_module_test() {
  node.OperationCreate
  |> node.operation_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.OperationCreate")

  node.OperationSelect
  |> node.operation_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.OperationSelect")

  node.OperationUpdate
  |> node.operation_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.OperationUpdate")

  node.OperationDelete
  |> node.operation_type_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.OperationDelete")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Permission                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn permission_to_string_test() {
  node.PermissionFull
  |> node.permission_to_string()
  |> should.equal("FULL")

  node.PermissionNone
  |> node.permission_to_string()
  |> should.equal("NONE")

  node.PermissionForFull(targets: [node.OperationCreate])
  |> node.permission_to_string()
  |> should.equal("FOR create FULL")

  node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_string()
  |> should.equal("FOR create, update FULL")

  node.PermissionForNone(targets: [node.OperationCreate])
  |> node.permission_to_string()
  |> should.equal("FOR create NONE")

  node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_string()
  |> should.equal("FOR create, update NONE")

  node.PermissionForWhere(
    targets: [node.OperationCreate],
    expression: node.BinaryOperator(
      lhs: node.Identifier("a"),
      operator: node.Equal,
      rhs: node.Identifier("b"),
    ),
  )
  |> node.permission_to_string()
  |> should.equal("FOR create WHERE a = b")

  node.PermissionForWhere(
    targets: [node.OperationCreate, node.OperationUpdate],
    expression: node.BinaryOperator(
      lhs: node.Identifier("a"),
      operator: node.Equal,
      rhs: node.Identifier("b"),
    ),
  )
  |> node.permission_to_string()
  |> should.equal("FOR create, update WHERE a = b")
}

pub fn permission_to_module_test() {
  node.PermissionFull
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.PermissionFull")

  node.PermissionNone
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.PermissionNone")

  node.PermissionForFull(targets: [node.OperationCreate])
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.PermissionForFull(targets: [node.OperationCreate])")

  node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node(
    "node.PermissionForFull(targets: [node.OperationCreate, node.OperationUpdate])",
  )

  node.PermissionForNone(targets: [node.OperationCreate])
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node("node.PermissionForNone(targets: [node.OperationCreate])")

  node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node(
    "node.PermissionForNone(targets: [node.OperationCreate, node.OperationUpdate])",
  )

  node.PermissionForWhere(
    targets: [node.OperationCreate],
    expression: node.BinaryOperator(
      lhs: node.Identifier("a"),
      operator: node.Equal,
      rhs: node.Identifier("b"),
    ),
  )
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node(
    "node.PermissionForWhere(\n"
    <> "  targets: [node.OperationCreate],\n"
    <> "  expression: node.BinaryOperator(\n"
    <> "    lhs: node.Identifier(\"a\"),\n"
    <> "    operator: node.Equal,\n"
    <> "    rhs: node.Identifier(\"b\"),\n"
    <> "  ),\n"
    <> ")",
  )

  node.PermissionForWhere(
    targets: [node.OperationCreate, node.OperationUpdate],
    expression: node.BinaryOperator(
      lhs: node.Identifier("a"),
      operator: node.Equal,
      rhs: node.Identifier("b"),
    ),
  )
  |> node.permission_to_module()
  |> assert_import("import suweal/node")
  |> assert_node(
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

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Field Strategy                                     //
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

pub fn define_field_strategy_to_module_test() {
  node.define_field_strategy_to_module(node.DefineFieldIfNotExists)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineFieldIfNotExists")
}

pub fn define_field_strategy_to_module_overwrite_test() {
  node.define_field_strategy_to_module(node.DefineFieldOverwrite)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineFieldOverwrite")
}

pub fn define_field_strategy_to_module_regular_test() {
  node.define_field_strategy_to_module(node.DefineFieldRegular)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineFieldRegular")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Table Strategy                                     //
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

pub fn define_table_strategy_to_module_test() {
  node.define_table_strategy_to_module(node.DefineTableIfNotExists)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineTableIfNotExists")
}

pub fn define_table_strategy_to_module_overwrite_test() {
  node.define_table_strategy_to_module(node.DefineTableOverwrite)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineTableOverwrite")
}

pub fn define_table_strategy_to_module_regular_test() {
  node.define_table_strategy_to_module(node.DefineTableRegular)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineTableRegular")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                    Define Access Strategy                                     //
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

pub fn define_access_strategy_to_module_test() {
  node.define_access_strategy_to_module(node.DefineAccessIfNotExists)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessIfNotExists")
}

pub fn define_access_strategy_to_module_overwrite_test() {
  node.define_access_strategy_to_module(node.DefineAccessOverwrite)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessOverwrite")
}

pub fn define_access_strategy_to_module_regular_test() {
  node.define_access_strategy_to_module(node.DefineAccessRegular)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessRegular")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Access Target                                      //
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

pub fn define_access_target_to_module_database_test() {
  node.define_access_target_to_module(node.DefineAccessDatabase)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessDatabase")
}

pub fn define_access_target_to_module_namespace_test() {
  node.define_access_target_to_module(node.DefineAccessNamespace)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessNamespace")
}

pub fn define_access_target_to_module_root_test() {
  node.define_access_target_to_module(node.DefineAccessRoot)
  |> assert_import("import suweal/node")
  |> assert_node("node.DefineAccessRoot")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Table                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_table_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableRegular,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal("DEFINE TABLE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL")
}

pub fn define_simple_table_overwrite_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableOverwrite,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE OVERWRITE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_simple_table_if_not_exists_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableIfNotExists,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE IF NOT EXISTS user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_relation_table_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableRegular,
    schema: node.Schemafull,
    type_: node.RelationTable(in: "user", out: "profile"),
    permissions: [node.PermissionNone],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE RELATION IN user OUT profile SCHEMAFULL PERMISSIONS NONE",
  )
}

pub fn define_table_with_query_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableRegular,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [
      node.PermissionForWhere(
        targets: [
          node.OperationCreate,
          node.OperationUpdate,
          node.OperationDelete,
        ],
        expression: node.BinaryOperator(
          lhs: node.Identifier("id"),
          operator: node.Equal,
          rhs: node.BinaryOperator(
            lhs: node.Parameter("auth"),
            operator: node.Access,
            rhs: node.Identifier("id"),
          ),
        ),
      ),
      node.PermissionForFull(targets: [node.OperationSelect]),
    ],
    as_: option.Some(node.Select(
      fields: [
        node.SelectField(
          field: node.Identifier("id"),
          alias: option.None,
          value: False,
        ),
      ],
      only: False,
      table: "user",
      where: option.None,
      order: option.None,
      limit: option.None,
      group_all: False,
    )),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE NORMAL SCHEMAFULL "
    <> "AS SELECT id FROM user PERMISSIONS "
    <> "FOR create, update, delete WHERE id = $auth.id "
    <> "FOR select FULL",
  )
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Field                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal("DEFINE FIELD name ON user TYPE string PERMISSIONS FULL")
}

pub fn define_simple_overwrite_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldOverwrite,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD OVERWRITE name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_simple_if_not_exists_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldIfNotExists,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD IF NOT EXISTS name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_field_with_default_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.String,
    default: option.Some(node.Value(surreal_ql.String("unknown"))),
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string DEFAULT \"unknown\" PERMISSIONS FULL",
  )
}

pub fn define_field_with_assert_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.Some(node.BinaryOperator(
      lhs: node.Parameter("value"),
      operator: node.NotEqual,
      rhs: node.None,
    )),
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string ASSERT $value != NONE PERMISSIONS FULL",
  )
}

pub fn define_flexible_object_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.Object,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: True,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE object FLEXIBLE PERMISSIONS FULL",
  )
}

pub fn define_nested_object_field_to_string_test() {
  node.DefineField(
    name: node.BinaryOperator(
      node.Identifier("settings"),
      node.Access,
      node.Identifier("notification"),
    ),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.Bool,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD settings.notification ON user TYPE bool PERMISSIONS FULL",
  )
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Access                                         //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON DATABASE TYPE RECORD")
}

pub fn define_access_overwrite_node_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessOverwrite,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS OVERWRITE user ON DATABASE TYPE RECORD")
}

pub fn define_access_if_not_node_exists_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessIfNotExists,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS IF NOT EXISTS user ON DATABASE TYPE RECORD")
}

pub fn define_access_namespace_node_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessNamespace,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON NAMESPACE TYPE RECORD")
}

pub fn define_access_root_node_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessRoot,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON ROOT TYPE RECORD")
}

pub fn define_access_with_signin_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(node.Select(
        fields: [
          node.SelectField(field: node.All, alias: option.None, value: False),
        ],
        only: False,
        table: "user",
        where: option.Some(node.BinaryOperator(
          lhs: node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          operator: node.And,
          rhs: node.FunctionCall(
            node: node.BinaryOperator(
              lhs: node.Identifier("crypto"),
              operator: node.NamespaceAccess,
              rhs: node.BinaryOperator(
                lhs: node.Identifier("argon2"),
                operator: node.NamespaceAccess,
                rhs: node.Identifier("compare"),
              ),
            ),
            arguments: [
              node.Identifier("password"),
              node.Parameter("password"),
            ],
          ),
        )),
        order: option.None,
        limit: option.None,
        group_all: False,
      )),
      signup: option.None,
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}

pub fn define_access_with_signup_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.Some(
        node.Create(only: False, target: "user", set: [
          node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          node.BinaryOperator(
            lhs: node.Identifier("password"),
            operator: node.Equal,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("generate"),
                ),
              ),
              arguments: [
                node.Parameter("password"),
              ],
            ),
          ),
        ]),
      ),
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password))",
  )
}

pub fn define_access_with_signin_and_signup_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(node.Select(
        fields: [
          node.SelectField(field: node.All, alias: option.None, value: False),
        ],
        only: False,
        table: "user",
        where: option.Some(node.BinaryOperator(
          lhs: node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          operator: node.And,
          rhs: node.FunctionCall(
            node: node.BinaryOperator(
              lhs: node.Identifier("crypto"),
              operator: node.NamespaceAccess,
              rhs: node.BinaryOperator(
                lhs: node.Identifier("argon2"),
                operator: node.NamespaceAccess,
                rhs: node.Identifier("compare"),
              ),
            ),
            arguments: [
              node.Identifier("password"),
              node.Parameter("password"),
            ],
          ),
        )),
        order: option.None,
        limit: option.None,
        group_all: False,
      )),
      signup: option.Some(
        node.Create(only: False, target: "user", set: [
          node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          node.BinaryOperator(
            lhs: node.Identifier("password"),
            operator: node.Equal,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("generate"),
                ),
              ),
              arguments: [
                node.Parameter("password"),
              ],
            ),
          ),
        ]),
      ),
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}

pub fn define_access_with_signin_and_signup_with_jwt_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(node.Select(
        fields: [
          node.SelectField(field: node.All, alias: option.None, value: False),
        ],
        only: False,
        table: "user",
        where: option.Some(node.BinaryOperator(
          lhs: node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          operator: node.And,
          rhs: node.FunctionCall(
            node: node.BinaryOperator(
              lhs: node.Identifier("crypto"),
              operator: node.NamespaceAccess,
              rhs: node.BinaryOperator(
                lhs: node.Identifier("argon2"),
                operator: node.NamespaceAccess,
                rhs: node.Identifier("compare"),
              ),
            ),
            arguments: [
              node.Identifier("password"),
              node.Parameter("password"),
            ],
          ),
        )),
        order: option.None,
        limit: option.None,
        group_all: False,
      )),
      signup: option.Some(
        node.Create(only: False, target: "user", set: [
          node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          node.BinaryOperator(
            lhs: node.Identifier("password"),
            operator: node.Equal,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("generate"),
                ),
              ),
              arguments: [
                node.Parameter("password"),
              ],
            ),
          ),
        ]),
      ),
      jwt_config: option.Some(node.JWTConfiguration(
        algorithm: "HS256",
        key: "secret",
      )),
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password)) "
    <> "WITH JWT ALGORITHM HS256 KEY secret",
  )
}

pub fn define_access_with_signin_and_signup_no_double_wrap_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(
        node.WrappedNode(node.Select(
          fields: [
            node.SelectField(field: node.All, alias: option.None, value: False),
          ],
          only: False,
          table: "user",
          where: option.Some(node.BinaryOperator(
            lhs: node.BinaryOperator(
              lhs: node.Identifier("email"),
              operator: node.Equal,
              rhs: node.Parameter("email"),
            ),
            operator: node.And,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("compare"),
                ),
              ),
              arguments: [
                node.Identifier("password"),
                node.Parameter("password"),
              ],
            ),
          )),
          order: option.None,
          limit: option.None,
          group_all: False,
        )),
      ),
      signup: option.Some(
        node.WrappedNode(
          node.Create(only: False, target: "user", set: [
            node.BinaryOperator(
              lhs: node.Identifier("email"),
              operator: node.Equal,
              rhs: node.Parameter("email"),
            ),
            node.BinaryOperator(
              lhs: node.Identifier("password"),
              operator: node.Equal,
              rhs: node.FunctionCall(
                node: node.BinaryOperator(
                  lhs: node.Identifier("crypto"),
                  operator: node.NamespaceAccess,
                  rhs: node.BinaryOperator(
                    lhs: node.Identifier("argon2"),
                    operator: node.NamespaceAccess,
                    rhs: node.Identifier("generate"),
                  ),
                ),
                arguments: [
                  node.Parameter("password"),
                ],
              ),
            ),
          ]),
        ),
      ),
      jwt_config: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}
