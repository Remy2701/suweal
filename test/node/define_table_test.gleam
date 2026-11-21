import gleeunit/should
import suweal/node.{define_table, select}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_table_to_string_test() {
  define_table.create("user")
  |> define_table.with_strategy(node.DefineTableRegular)
  |> define_table.with_schema(node.Schemafull)
  |> define_table.with_type(node.NormalTable)
  |> define_table.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal("DEFINE TABLE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL")
}

pub fn define_simple_table_overwrite_to_string_test() {
  define_table.create("user")
  |> define_table.with_strategy(node.DefineTableOverwrite)
  |> define_table.with_schema(node.Schemafull)
  |> define_table.with_type(node.NormalTable)
  |> define_table.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE OVERWRITE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_simple_table_if_not_exists_to_string_test() {
  define_table.create("user")
  |> define_table.with_strategy(node.DefineTableIfNotExists)
  |> define_table.with_schema(node.Schemafull)
  |> define_table.with_type(node.NormalTable)
  |> define_table.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE IF NOT EXISTS user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_relation_table_to_string_test() {
  define_table.create("user")
  |> define_table.with_strategy(node.DefineTableRegular)
  |> define_table.with_schema(node.Schemafull)
  |> define_table.with_type(node.RelationTable(in: "user", out: "profile"))
  |> define_table.add_permission(node.PermissionNone)
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE RELATION IN user OUT profile SCHEMAFULL PERMISSIONS NONE",
  )
}

pub fn define_table_with_query_to_string_test() {
  define_table.create("user")
  |> define_table.with_strategy(node.DefineTableRegular)
  |> define_table.with_schema(node.Schemafull)
  |> define_table.with_type(node.NormalTable)
  |> define_table.add_permission(node.PermissionForWhere(
    targets: [
      node.OperationCreate,
      node.OperationUpdate,
      node.OperationDelete,
    ],
    expression: node.binop.equal(
      node.identifier.create("id"),
      node.binop.access(
        node.parameter.create("auth"),
        node.identifier.create("id"),
      ),
    ),
  ))
  |> define_table.add_permission(
    node.PermissionForFull(targets: [node.OperationSelect]),
  )
  |> define_table.set_as(
    select.create("user")
    |> select.add_field(node.identifier.create("id")),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE NORMAL SCHEMAFULL "
    <> "AS SELECT id FROM user PERMISSIONS "
    <> "FOR create, update, delete WHERE id = $auth.id "
    <> "FOR select FULL",
  )
}
